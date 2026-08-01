-- Native integration for Earendel's logistics mods. FluxWorks never clones
-- their prototypes or artwork; it only retunes the recipes and research when
-- the original mods are installed.

if not (mods["aai-loaders"] or mods["aai-containers"]) then return end

local function recipe_result_name(recipe)
  if recipe.main_product then return recipe.main_product end
  local result = recipe.results and recipe.results[1]
  return result and (result.name or result[1])
end

local function placed_entity(item_name)
  local item = data.raw.item and data.raw.item[item_name]
  local place_result = item and item.place_result
  if not place_result then return nil end
  for _, prototype_type in ipairs({ "loader", "loader-1x1", "container", "logistic-container" }) do
    local entity = data.raw[prototype_type] and data.raw[prototype_type][place_result]
    if entity then return entity, prototype_type end
  end
end

local function set_recipe(recipe, ingredients)
  recipe.enabled = false
  recipe.ingredients = ingredients
  recipe.allow_productivity = true
end

local function recipe_unlock(name)
  return { type = "unlock-recipe", recipe = name }
end

local function science_unit(count, packs, time)
  local ingredients = {}
  for _, pack in ipairs(packs) do ingredients[#ingredients + 1] = { pack, 1 } end
  return { count = count, ingredients = ingredients, time = time }
end

local function add_technology(name, icon, prerequisites, unit, recipe_names, order)
  if #recipe_names == 0 then return end
  local effects = {}
  for _, recipe_name in ipairs(recipe_names) do effects[#effects + 1] = recipe_unlock(recipe_name) end
  data:extend({
    {
      type = "technology",
      name = name,
      icon = icon,
      icon_size = 256,
      prerequisites = prerequisites,
      unit = unit,
      effects = effects,
      order = order,
    },
  })
end

local function add_prerequisite(technology, prerequisite_name)
  if not technology then return end
  technology.prerequisites = technology.prerequisites or {}
  for _, existing in pairs(technology.prerequisites) do
    if existing == prerequisite_name then return end
  end
  technology.prerequisites[#technology.prerequisites + 1] = prerequisite_name
end

local function integrate_native_unlocks(recipe_names, prerequisites, unit)
  local recipe_set = {}
  for _, recipe_name in ipairs(recipe_names) do recipe_set[recipe_name] = true end

  for _, technology in pairs(data.raw.technology or {}) do
    local unlocks_loader = false
    for _, effect in pairs(technology.effects or {}) do
      if effect.type == "unlock-recipe" and recipe_set[effect.recipe] then
        unlocks_loader = true
        break
      end
    end
    if unlocks_loader then
      for _, prerequisite_name in ipairs(prerequisites) do
        add_prerequisite(technology, prerequisite_name)
      end
      technology.unit = table.deepcopy(unit)
    end
  end
end

local loader_tiers = { {}, {}, {}, {} }
if mods["aai-loaders"] then
  local loaders = {}
  for recipe_name, recipe in pairs(data.raw.recipe or {}) do
    local product_name = recipe_result_name(recipe)
    local entity, prototype_type = placed_entity(product_name)
    local aai_name = string.find(string.lower(recipe_name), "aai", 1, true)
      or (product_name and string.find(string.lower(product_name), "aai", 1, true))
    if aai_name and entity and (prototype_type == "loader" or prototype_type == "loader-1x1") then
      loaders[#loaders + 1] = { recipe = recipe, name = recipe_name, speed = entity.speed or 0 }
    end
  end
  table.sort(loaders, function(a, b)
    if a.speed == b.speed then return a.name < b.name end
    return a.speed < b.speed
  end)

  for index, entry in ipairs(loaders) do
    local tier = math.min(index, 4)
    loader_tiers[tier][#loader_tiers[tier] + 1] = entry.name
    local ingredients = {
      { type = "item", name = tier == 1 and "transport-belt"
          or tier == 2 and "fast-transport-belt"
          or tier == 3 and "express-transport-belt"
          or "turbo-transport-belt", amount = 4 },
      { type = "item", name = "fw-bearing", amount = tier + 1 },
      { type = "item", name = tier < 3 and "fw-iron-beam" or "fw-steel-beam", amount = 2 },
    }
    if tier >= 2 then ingredients[#ingredients + 1] = { type = "item", name = "electric-motor", amount = tier } end
    if tier >= 3 then ingredients[#ingredients + 1] = { type = "item", name = "fw-control-assembly", amount = tier - 1 } end
    set_recipe(entry.recipe, ingredients)
  end

  -- AAI already owns one technology per loader tier. Integrate those native
  -- technologies instead of creating a duplicate FluxWorks research ladder.
  integrate_native_unlocks(loader_tiers[1], { "fw-beam-engineering", "fw-metals-fabrication" },
    science_unit(70, { "automation-science-pack", "logistic-science-pack" }, 22))
  integrate_native_unlocks(loader_tiers[2], { "fw-industrial-methods-science" },
    science_unit(110, { "automation-science-pack", "logistic-science-pack", "fw-industrial-methods-science-pack" }, 25))
  integrate_native_unlocks(loader_tiers[3], { "fw-signal-architecture", "fw-systems-analysis-science" },
    science_unit(190, {
      "automation-science-pack", "logistic-science-pack", "chemical-science-pack", "fw-systems-analysis-science-pack",
    }, 30))
  integrate_native_unlocks(loader_tiers[4], { "fw-computational-arrays", "fw-industrial-expansion" },
    science_unit(280, {
      "automation-science-pack", "logistic-science-pack", "chemical-science-pack", "production-science-pack",
      "fw-systems-analysis-science-pack",
    }, 35))
end

if mods["aai-containers"] then
  local bulk_storage = {}
  local network_storage = {}
  local controlled_storage = {}

  for recipe_name, recipe in pairs(data.raw.recipe or {}) do
    local product_name = recipe_result_name(recipe)
    local entity, prototype_type = placed_entity(product_name)
    local identity = string.lower((product_name or "") .. " " .. recipe_name)
    local aai_storage = string.find(identity, "aai", 1, true)
      or string.find(identity, "strongbox", 1, true)
      or string.find(identity, "storehouse", 1, true)
      or string.find(identity, "warehouse", 1, true)
    if aai_storage and entity and (prototype_type == "container" or prototype_type == "logistic-container") then
      local width = math.abs(entity.collision_box[2][1] - entity.collision_box[1][1])
      if width >= 1.5 then
        local ingredients = {
          { type = "item", name = width >= 3.5 and "fw-steel-beam" or "fw-iron-beam", amount = math.max(2, math.floor(width * 2)) },
          { type = "item", name = "fw-bearing", amount = math.max(1, math.floor(width / 2)) },
        }
        if prototype_type == "logistic-container" then
          ingredients[#ingredients + 1] = { type = "item", name = "fw-control-assembly", amount = math.max(1, math.floor(width / 2)) }
          ingredients[#ingredients + 1] = { type = "item", name = "advanced-circuit", amount = math.max(2, math.floor(width)) }
          if entity.logistic_mode == "requester" or entity.logistic_mode == "buffer" or entity.logistic_mode == "active-provider" then
            controlled_storage[#controlled_storage + 1] = recipe_name
          else
            network_storage[#network_storage + 1] = recipe_name
          end
        else
          ingredients[#ingredients + 1] = { type = "item", name = "steel-plate", amount = math.max(4, math.floor(width * width)) }
          bulk_storage[#bulk_storage + 1] = recipe_name
        end
        set_recipe(recipe, ingredients)
      end
    end
  end

  add_technology("fw-aai-bulk-storage", "__base__/graphics/technology/steel-processing.png",
    { "fw-metals-fabrication", "steel-processing", "logistics" },
    science_unit(90, { "automation-science-pack", "logistic-science-pack" }, 24),
    bulk_storage, "c-m-c[fw-aai-bulk-storage]")
  add_technology("fw-aai-network-storage", "__base__/graphics/technology/logistic-robotics.png",
    { "fw-aai-bulk-storage", "fw-signal-architecture", "logistic-robotics" },
    science_unit(185, { "automation-science-pack", "logistic-science-pack", "chemical-science-pack" }, 30),
    network_storage, "c-n-b[fw-aai-network-storage]")
  add_technology("fw-aai-controlled-storage", "__base__/graphics/technology/logistic-system.png",
    { "fw-aai-network-storage", "fw-computational-arrays", "logistic-system" },
    science_unit(285, {
      "automation-science-pack", "logistic-science-pack", "chemical-science-pack", "production-science-pack",
    }, 35), controlled_storage, "c-o-b[fw-aai-controlled-storage]")
end
