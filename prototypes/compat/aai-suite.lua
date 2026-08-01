-- Soft compatibility for Earendel's wider AAI suite. Only Loaders and
-- Containers are declared optional dependencies; the rest are detected here
-- and retuned after their prototypes exist.

local supported_mods = {
  "aai-industry",
  "aai-signals",
  "aai-zones",
  "aai-programmable-structures",
  "aai-programmable-vehicles",
  "aai-signal-transmission",
  "aai-vehicles-miner",
  "aai-vehicles-hauler",
  "aai-vehicles-warden",
  "aai-vehicles-chaingunner",
  "aai-vehicles-laser-tank",
  "aai-vehicles-flame-tank",
  "aai-vehicles-flame-tumbler",
  "aai-vehicles-ironclad",
}

local any_supported_mod = false
for _, mod_name in ipairs(supported_mods) do
  if mods[mod_name] then
    any_supported_mod = true
    break
  end
end
if not any_supported_mod then return end

local function ingredient_name(ingredient)
  return ingredient.name or ingredient[1]
end

local function add_ingredient(recipe, name, amount)
  if not (data.raw.item and data.raw.item[name]) then return end
  for _, ingredient in ipairs(recipe.ingredients or {}) do
    if ingredient_name(ingredient) == name then return end
  end
  recipe.ingredients = recipe.ingredients or {}
  recipe.ingredients[#recipe.ingredients + 1] = { type = "item", name = name, amount = amount }
end

local function add_prerequisite(technology, prerequisite)
  if not (data.raw.technology and data.raw.technology[prerequisite]) then return end
  for _, current in ipairs(technology.prerequisites or {}) do
    if current == prerequisite then return end
  end
  technology.prerequisites = technology.prerequisites or {}
  technology.prerequisites[#technology.prerequisites + 1] = prerequisite
end

local function result_name(recipe)
  if recipe.main_product then return recipe.main_product end
  local result = recipe.results and recipe.results[1]
  return result and (result.name or result[1])
end

local function matches_aai_family(name)
  name = string.lower(name or "")
  return string.find(name, "vehicle", 1, true)
    or string.find(name, "unit%-")
    or string.find(name, "zone%-")
    or string.find(name, "path%-")
    or string.find(name, "signal%-")
    or string.find(name, "aai%-")
    or string.find(name, "hauler", 1, true)
    or string.find(name, "miner%-mk")
    or string.find(name, "warden", 1, true)
    or string.find(name, "chaingunner", 1, true)
    or string.find(name, "laser%-tank")
    or string.find(name, "flame%-tank")
    or string.find(name, "flame%-tumbler")
    or string.find(name, "ironclad", 1, true)
end

local tuned_recipes = {}
for recipe_name, recipe in pairs(data.raw.recipe or {}) do
  local product_name = result_name(recipe)
  if matches_aai_family(recipe_name) or matches_aai_family(product_name) then
    local item = product_name and data.raw.item and data.raw.item[product_name]
    local entity_name = item and item.place_result
    local car = entity_name and data.raw.car and data.raw.car[entity_name]
    local programmable = string.find(recipe_name, "unit%-")
      or string.find(recipe_name, "zone%-")
      or string.find(recipe_name, "path%-")
      or string.find(recipe_name, "signal%-")

    if car then
      add_ingredient(recipe, "electric-motor", 1)
      add_ingredient(recipe, "fw-control-assembly", 1)
      if string.find(recipe_name, "miner", 1, true) then
        add_ingredient(recipe, "fw-harvester-head", 1)
      elseif car.guns and #car.guns > 0 then
        add_ingredient(recipe, "fw-ceramic-casing", 2)
      else
        add_ingredient(recipe, "fw-steel-beam", 2)
      end
      tuned_recipes[recipe_name] = "fw-electromechanical-systems"
    elseif programmable then
      add_ingredient(recipe, "fw-circuit-substrate", 1)
      add_ingredient(recipe, "fw-sensor-package", 1)
      tuned_recipes[recipe_name] = "fw-signal-architecture"
    end
  end
end

for _, technology in pairs(data.raw.technology or {}) do
  for _, effect in ipairs(technology.effects or {}) do
    if effect.type == "unlock-recipe" and tuned_recipes[effect.recipe] then
      add_prerequisite(technology, tuned_recipes[effect.recipe])
    end
  end
end
