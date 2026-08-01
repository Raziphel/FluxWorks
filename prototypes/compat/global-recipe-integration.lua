local Recipe = require("__razi_lib__/lib/recipe")
local Startup = require("prototypes.lib.startup-settings")
local Compatibility = require("prototypes.lib.compatibility-api")

local mode = Startup.value("fw-global-compatibility-mode", "broad")
if mode == "off" then return end

local ITEM_TYPES = {
  "item", "ammo", "capsule", "gun", "module", "armor", "tool",
  "repair-tool", "item-with-entity-data", "item-with-label", "item-with-tags",
  "rail-planner",
}

local ENTITY_TYPES = {
  "accumulator", "agricultural-tower", "ammo-turret", "arithmetic-combinator",
  "artillery-turret", "assembling-machine", "asteroid-collector", "beacon",
  "boiler", "burner-generator", "cargo-bay", "cargo-landing-pad", "constant-combinator",
  "container", "decider-combinator", "electric-energy-interface", "electric-pole",
  "electric-turret", "fluid-turret", "fluid-wagon", "furnace", "fusion-generator",
  "fusion-reactor", "generator", "heat-interface", "heat-pipe", "inserter", "lab",
  "lamp", "land-mine", "lightning-attractor", "linked-belt", "linked-container",
  "loader", "loader-1x1", "locomotive", "logistic-container", "mining-drill",
  "offshore-pump", "pipe", "pipe-to-ground", "power-switch", "programmable-speaker",
  "pump", "radar", "rail-chain-signal", "rail-ramp", "rail-signal", "rail-support",
  "reactor", "roboport", "rocket-silo", "selector-combinator", "solar-panel",
  "space-platform-hub", "spider-vehicle", "splitter", "storage-tank", "thruster",
  "train-stop", "transport-belt", "turret", "underground-belt", "wall",
}

local FAMILIES = {
  {
    name = "fluid-system", part = "fw-reinforced-seal",
    types = {
      "agricultural-tower", "boiler", "fluid-turret", "fluid-wagon",
      "fusion-generator", "fusion-reactor", "generator", "offshore-pump",
      "pipe", "pipe-to-ground", "pump", "storage-tank", "thruster",
    },
  },
  {
    name = "control-system", part = "fw-signal-conduit",
    types = {
      "arithmetic-combinator", "constant-combinator", "decider-combinator",
      "lamp", "power-switch", "programmable-speaker", "radar",
      "rail-chain-signal", "rail-signal", "selector-combinator", "train-stop",
    },
  },
  {
    name = "power-system", part = "fw-power-regulator",
    types = {
      "accumulator", "burner-generator", "electric-energy-interface",
      "electric-pole", "heat-interface", "heat-pipe", "lightning-attractor",
      "reactor", "solar-panel",
    },
  },
  {
    name = "combat-system", part = "fw-sensor-package",
    types = {
      "ammo-turret", "artillery-turret", "electric-turret", "land-mine",
      "spider-vehicle", "turret", "wall",
    },
  },
  {
    name = "logistics-system", part = "fw-bearing",
    types = {
      "cargo-bay", "cargo-landing-pad", "container", "inserter", "linked-belt",
      "linked-container", "loader", "loader-1x1", "locomotive",
      "logistic-container", "roboport", "splitter", "transport-belt",
      "underground-belt",
    },
  },
  {
    name = "production-system", part = "motor",
    types = {
      "assembling-machine", "asteroid-collector", "beacon", "furnace", "lab",
      "mining-drill", "rocket-silo",
    },
  },
}

for _, family in ipairs(Compatibility.recipe_families) do
  FAMILIES[#FAMILIES + 1] = family
end

local FAMILY_BY_ENTITY_TYPE = {}
local FAMILY_BY_ITEM_NAME = {}
local FAMILY_BY_ITEM_TYPE = {}
local FAMILY_BY_SUBGROUP = {}
for _, family in ipairs(FAMILIES) do
  for _, entity_type in ipairs(family.types or family.entity_types or {}) do
    FAMILY_BY_ENTITY_TYPE[entity_type] = family
  end
  for _, item_name in ipairs(family.item_names or {}) do
    FAMILY_BY_ITEM_NAME[item_name] = family
  end
  for _, item_type in ipairs(family.item_types or {}) do
    FAMILY_BY_ITEM_TYPE[item_type] = family
  end
  for _, subgroup in ipairs(family.subgroups or {}) do
    FAMILY_BY_SUBGROUP[subgroup] = family
  end
end

-- Rewriting these would make the compatibility parts depend on themselves.
local PROTECTED_BOOTSTRAP_RECIPES = {
  ["pipe-to-ground"] = true,
  ["storage-tank"] = true,
  ["pump"] = true,
  ["offshore-pump"] = true,
  ["chemical-plant"] = true,
  ["oil-refinery"] = true,
  ["pumpjack"] = true,
}

local function find_item(name)
  for _, item_type in ipairs(ITEM_TYPES) do
    local prototype = data.raw[item_type] and data.raw[item_type][name]
    if prototype then return prototype end
  end
end

local function find_entity_type(name)
  if not name then return nil end
  for _, entity_type in ipairs(ENTITY_TYPES) do
    if data.raw[entity_type] and data.raw[entity_type][name] then
      return entity_type
    end
  end
end

local function entry_name(entry)
  return entry.name or entry[1]
end

local function recipe_results(recipe)
  return recipe.results
    or (recipe.normal and recipe.normal.results)
    or (recipe.result and { { type = "item", name = recipe.result } })
    or (recipe.normal and recipe.normal.result and {
      { type = "item", name = recipe.normal.result },
    })
    or {}
end

local function primary_item(recipe)
  if recipe.main_product then
    return find_item(recipe.main_product)
  end
  local only
  for _, result in pairs(recipe_results(recipe)) do
    if (result.type or "item") == "item" then
      local item = find_item(entry_name(result))
      if item then
        if only then return nil end
        only = item
      end
    end
  end
  return only
end

local function has_ingredient(ingredients, name)
  for _, ingredient in pairs(ingredients or {}) do
    if entry_name(ingredient) == name then return true end
  end
  return false
end

local function ingredient_count(ingredients)
  local count = 0
  for _, _ in pairs(ingredients or {}) do count = count + 1 end
  return count
end

local function classify(item)
  if FAMILY_BY_ITEM_NAME[item.name] then return FAMILY_BY_ITEM_NAME[item.name] end
  for _, family in ipairs(Compatibility.recipe_families) do
    for _, pattern in ipairs(family.item_name_patterns or {}) do
      if string.find(item.name, pattern) then return family end
    end
    for _, pattern in ipairs(family.subgroup_patterns or {}) do
      if string.find(item.subgroup or "", pattern) then return family end
    end
  end
  local entity_type = find_entity_type(item.place_result)
  if entity_type and FAMILY_BY_ENTITY_TYPE[entity_type] then
    return FAMILY_BY_ENTITY_TYPE[entity_type]
  end
  if FAMILY_BY_ITEM_TYPE[item.type] then return FAMILY_BY_ITEM_TYPE[item.type] end
  if FAMILY_BY_SUBGROUP[item.subgroup] then return FAMILY_BY_SUBGROUP[item.subgroup] end
  if mode ~= "broad" then return nil end

  if item.type == "module" then
    return { name = "module", part = "fw-microchip" }
  end
  if item.type == "ammo" or item.type == "gun" or item.type == "armor" then
    return { name = "combat-item", part = "fw-metal-mesh" }
  end
  if item.type == "repair-tool" then
    return { name = "precision-tool", part = "fw-sensor-package" }
  end
  local subgroup = item.subgroup or ""
  if item.type == "tool"
    and not string.find(subgroup, "science", 1, true)
    and not string.find(item.name, "science%-pack")
  then
    return { name = "precision-tool", part = "fw-sensor-package" }
  end
  if string.find(subgroup, "robot", 1, true) then
    return { name = "robot", part = "fw-light-frame" }
  end
  if string.find(subgroup, "equipment", 1, true) then
    return { name = "equipment", part = "fw-microchip" }
  end
end

local stats = { scanned = 0, integrated = 0, ambiguous = 0, families = {} }

for recipe_name, raw_recipe in pairs(data.raw.recipe or {}) do
  stats.scanned = stats.scanned + 1
  if string.sub(recipe_name, 1, 3) ~= "fw-"
    and not PROTECTED_BOOTSTRAP_RECIPES[recipe_name]
    and not Compatibility.recipe_exclusions[recipe_name]
    and not raw_recipe.hidden
  then
    local explicit = Compatibility.recipe_parts[recipe_name]
    local item = primary_item(raw_recipe)
    local family = explicit and {
      name = "explicit",
      part = explicit.part,
      ingredient_amount = explicit.amount,
      min_ingredients = 1,
      max_ingredients = 100,
    } or (item and classify(item))
    local recipe = family and Recipe:get(recipe_name)
    local ingredients = recipe and recipe.ingredients or nil

    -- Packing, conversion, and free-output recipes are common exploit seams.
    -- Only construction-like recipes with an existing bill of materials qualify.
    local existing_count = ingredient_count(ingredients)
    if family
      and find_item(family.part)
      and existing_count >= (family.min_ingredients or 2)
      and existing_count <= (family.max_ingredients or 6)
    then
      if not has_ingredient(ingredients, family.part) then
        ingredients[#ingredients + 1] = {
          type = "item",
          name = family.part,
          amount = family.ingredient_amount or 1,
        }
        recipe:setIngredients(ingredients)
        stats.integrated = stats.integrated + 1
        stats.families[family.name] = (stats.families[family.name] or 0) + 1
      end
    elseif item then
      stats.ambiguous = stats.ambiguous + 1
    end
  end
end

log(
  ("FluxWorks global compatibility (%s): scanned %d recipes, integrated %d, left %d ambiguous")
    :format(mode, stats.scanned, stats.integrated, stats.ambiguous)
)

return stats
