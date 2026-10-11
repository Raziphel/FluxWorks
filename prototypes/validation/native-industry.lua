local legacy_recipes = require("prototypes.lib.startup-settings").enabled("fw-enable-recipe-integration", false)
local legacy_early = require("prototypes.lib.startup-settings").enabled("fw-enable-early-industry-overhaul", false)

local function ingredient_names(recipe_name)
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if not recipe then error("Native industry validation is missing recipe " .. recipe_name) end
  local names = {}
  for _, ingredient in ipairs(recipe.ingredients or {}) do names[ingredient.name or ingredient[1]] = true end
  return names
end

local function assert_ingredients(recipe_name, required, forbidden)
  local names = ingredient_names(recipe_name)
  for _, name in ipairs(required or {}) do
    if not names[name] then
      error(("Native industry validation: %s is missing %s"):format(recipe_name, name))
    end
  end
  for _, name in ipairs(forbidden or {}) do
    if names[name] then
      error(("Native industry validation: %s still uses obsolete substitute %s"):format(recipe_name, name))
    end
  end
end

local native_icon_path = "__FluxWorksAssets__/graphics/icons/items/native-industry/"

local function assert_icon(prototype_type, name, expected)
  local prototype = data.raw[prototype_type] and data.raw[prototype_type][name]
  if not prototype then
    error(("Native industry validation is missing %s %s"):format(prototype_type, name))
  end
  if prototype.icon ~= expected then
    error(("Native industry validation: %s/%s uses %s instead of %s")
      :format(prototype_type, name, tostring(prototype.icon), expected))
  end
end

if data.raw["bool-setting"] and data.raw["bool-setting"]["fw-skip-burner-stage"] then
  error("Native industry validation: removed Skip burner stage setting still exists")
end

assert_icon("item", "sand", native_icon_path .. "sand.png")
assert_icon("item", "glass", native_icon_path .. "glass.png")
assert_icon("technology", "sand-processing", native_icon_path .. "sand.png")
assert_icon("technology", "glass-processing", native_icon_path .. "glass.png")

assert_ingredients("sand", { "stone" }, {})
assert_ingredients("glass", { mods["Krastorio2-spaced-out"] and "kr-sand" or "sand" }, {})

local function assert_unlock(technology_name, recipe_name)
  local technology = data.raw.technology and data.raw.technology[technology_name]
  if not technology then
    error("Native industry validation is missing technology " .. technology_name)
  end
  for _, effect in ipairs(technology.effects or {}) do
    if effect.type == "unlock-recipe" and effect.recipe == recipe_name then
      return
    end
  end
  error(("Native industry validation: %s does not unlock %s"):format(technology_name, recipe_name))
end

assert_unlock("sand-processing", "sand")
assert_unlock("glass-processing", "glass")

if legacy_recipes then
assert_ingredients("lab",
  { "electronic-circuit", "iron-gear-wheel", "transport-belt", mods["Krastorio2-spaced-out"] and "kr-glass" or "glass" },
  { "fw-glass-lens", "fw-ceramic-insulator" })

end

local sand_recipe = data.raw.recipe.sand
local sand_uses_crusher = sand_recipe.category == "basic-crushing"
for _, category in ipairs(sand_recipe.categories or {}) do
  if category == "basic-crushing" then sand_uses_crusher = true end
end
if legacy_early and not sand_uses_crusher then
  error("Native industry validation: Legacy Sand must require the Crusher")
elseif not legacy_early and ((sand_recipe.categories and sand_recipe.categories[1]) or sand_recipe.category) ~= "crafting" then
  error("Native industry validation: Expansion Sand must remain craftable without moving the Crusher")
end

local comminution = data.raw.technology["fw-comminution"]
if legacy_early and (comminution.unit or not comminution.research_trigger
  or comminution.research_trigger.type ~= "mine-entity"
  or not comminution.research_trigger.entities
  or comminution.research_trigger.entities[1] ~= "big-rock"
  or comminution.research_trigger.count ~= 5)
then
  error("Native industry validation: Comminution must unlock by mining five big rocks")
end

local sand_processing = data.raw.technology["sand-processing"]
if legacy_early and (sand_processing.unit or not sand_processing.research_trigger
  or sand_processing.research_trigger.type ~= "craft-item"
  or sand_processing.research_trigger.item ~= "crusher")
then
  error("Native industry validation: Sand Processing must unlock by crafting a Crusher")
end

local glass_processing = data.raw.technology["glass-processing"]
if legacy_early and (glass_processing.unit or not glass_processing.research_trigger
  or glass_processing.research_trigger.type ~= "craft-item"
  or glass_processing.research_trigger.item ~= (mods["Krastorio2-spaced-out"] and "kr-sand" or "sand"))
then
  error("Native industry validation: Glass Processing must unlock by crafting sand")
end

if not legacy_early then
  for _, tech in ipairs({ comminution, sand_processing, glass_processing }) do
    if tech.research_trigger or not tech.unit then
      error("Native industry validation: Expansion mineral research must use normal science")
    end
  end
  for _, effect in ipairs(comminution.effects or {}) do
    if effect.type == "unlock-recipe" and effect.recipe == "crusher" then
      error("Native industry validation: Comminution must not unlock the Space Age Crusher by default")
    end
  end
end

if legacy_recipes then
assert_ingredients("electric-mining-drill",
  { "iron-plate", "electronic-circuit", "fw-bearing" },
  { "burner-mining-drill", "engine-unit" })
end

assert_ingredients("fw-control-assembly",
  { "fw-circuit-substrate", "fw-chip-carrier", "fw-solder-wire", "fw-circuit-contact" },
  { "engine-unit", "iron-gear-wheel" })
assert_ingredients("fw-transformer-core",
  { "fw-steel-beam", "fw-tinned-cable", "fw-inductor-coil", "bronze-plate" },
  { "engine-unit", "iron-gear-wheel" })
assert_ingredients("fw-flow-regulator",
  { "fw-pressure-housing", "fw-bearing", "fw-inline-filter" },
  { "engine-unit", "iron-gear-wheel" })
assert_ingredients("fw-flux-quarry",
  { "electric-mining-drill", "electric-engine-unit", "fw-pressure-housing", "fw-flow-regulator" },
  { "engine-unit", "iron-gear-wheel" })
assert_ingredients("captive-biter-spawner", nil, { "fw-bearing" })
