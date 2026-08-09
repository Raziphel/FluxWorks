local Startup = require("prototypes.lib.startup-settings")
if not Startup.enabled("fw-skip-burner-stage", false) then return end

local function entry_name(entry)
  return type(entry) == "table" and (entry.name or entry[1]) or nil
end

local function set_ingredients(recipe_name, ingredients)
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if not recipe then return end
  recipe.ingredients = table.deepcopy(ingredients)
  if recipe.normal then recipe.normal.ingredients = table.deepcopy(ingredients) end
  if recipe.expensive then recipe.expensive.ingredients = table.deepcopy(ingredients) end
end

local function enable_recipe(recipe_name)
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if recipe then recipe.enabled = true end
end

local function add_unlock(technology, recipe_name)
  technology.effects = technology.effects or {}
  for _, effect in ipairs(technology.effects) do
    if effect.type == "unlock-recipe" and effect.recipe == recipe_name then return end
  end
  technology.effects[#technology.effects + 1] = { type = "unlock-recipe", recipe = recipe_name }
end

local function remove_prerequisite(technology, removed_name)
  for index = #(technology.prerequisites or {}), 1, -1 do
    if technology.prerequisites[index] == removed_name then table.remove(technology.prerequisites, index) end
  end
end

local hidden_technologies = { "burner-mechanics", "electric-lab", "steam-power", "basic-fluid-handling" }
for _, technology_name in ipairs(hidden_technologies) do
  local technology = data.raw.technology and data.raw.technology[technology_name]
  if technology then technology.hidden = true; technology.enabled = false end
end

for _, technology in pairs(data.raw.technology or {}) do
  for _, technology_name in ipairs(hidden_technologies) do remove_prerequisite(technology, technology_name) end
end

local burner_names = {
  "burner-assembling-machine", "burner-generator",
  "burner-lab", "burner-turbine",
}
for _, name in ipairs(burner_names) do
  if data.raw.item and data.raw.item[name] then data.raw.item[name].hidden = true end
  for _, prototype_type in ipairs({ "assembling-machine", "burner-generator", "inserter", "lab", "mining-drill" }) do
    local prototype = data.raw[prototype_type] and data.raw[prototype_type][name]
    if prototype then
      prototype.hidden = true
      prototype.hidden_in_factoriopedia = true
      prototype.next_upgrade = nil
    end
  end
  local recipe = data.raw.recipe and data.raw.recipe[name]
  if recipe then recipe.hidden = true; recipe.enabled = false end
end

-- Keep Factorio's two basic burner tools visible as optional hand-crafted
-- fallbacks. Skipping AAI's burner machine tier must not delete vanilla items.
for _, recipe_name in ipairs({ "burner-inserter", "burner-mining-drill" }) do
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if recipe then recipe.hidden = false; recipe.enabled = true end
  local item = data.raw.item and data.raw.item[recipe_name]
  if item then item.hidden = false end
end

-- Direct electric recipes replace AAI's burner-machine upgrade recipes.
set_ingredients("inserter", {
  { type = "item", name = "iron-plate", amount = 2 },
  { type = "item", name = "electric-motor", amount = 1 },
  { type = "item", name = "fw-bearing", amount = 1 },
})
set_ingredients("electric-mining-drill", {
  { type = "item", name = "iron-plate", amount = 10 },
  { type = "item", name = "electric-motor", amount = 4 },
  { type = "item", name = "fw-bearing", amount = 2 },
})
set_ingredients("assembling-machine-1", {
  { type = "item", name = "iron-plate", amount = 8 },
  { type = "item", name = "iron-gear-wheel", amount = 4 },
  { type = "item", name = "electric-motor", amount = 2 },
})
set_ingredients("lab", {
  { type = "item", name = "iron-plate", amount = 10 },
  { type = "item", name = "copper-plate", amount = 10 },
  { type = "item", name = "stone-brick", amount = 5 },
})
set_ingredients("boiler", {
  { type = "item", name = "stone-furnace", amount = 1 },
  { type = "item", name = "pipe", amount = 4 },
  { type = "item", name = "iron-plate", amount = 4 },
})

-- Hand mining and smelting ten copper plates now opens electricity, steam
-- power, and the electric laboratory without any hidden burner dependency.
local electricity = data.raw.technology and data.raw.technology.electricity
if electricity then
  electricity.prerequisites = {}
  electricity.unit = nil
  electricity.research_trigger = { type = "craft-item", item = "copper-plate", count = 10 }
  for _, recipe_name in ipairs({
    "boiler", "steam-engine", "offshore-pump",
    "pipe", "pipe-to-ground", "pump",
    "fw-copper-pipe", "fw-copper-pipe-to-ground", "fw-copper-pump",
  }) do
    add_unlock(electricity, recipe_name)
    if data.raw.recipe[recipe_name] then data.raw.recipe[recipe_name].enabled = false end
  end
end
local automation_science = data.raw.technology and data.raw.technology["automation-science-pack"]
if automation_science then
  automation_science.prerequisites = { "electricity" }
  automation_science.research_trigger = { type = "craft-item", item = "lab" }
end

local first_science_recipe = data.raw.recipe and data.raw.recipe["automation-science-pack"]
if first_science_recipe then
  first_science_recipe.categories = { "crafting" }
  first_science_recipe.category = nil
end

-- Water must be available before the first generator can power anything.
local offshore_pump = data.raw["offshore-pump"] and data.raw["offshore-pump"]["offshore-pump"]
if offshore_pump then
  offshore_pump.energy_source = { type = "void" }
  offshore_pump.energy_usage = "1W"
end

for _, recipe_name in ipairs({
  "motor", "iron-stick", "fw-bearing", "processed-fuel", "lab",
}) do enable_recipe(recipe_name) end

-- No surviving recipe may quietly demand a hidden burner item.
for recipe_name, recipe in pairs(data.raw.recipe or {}) do
  if not recipe.hidden then
    for _, ingredient in ipairs(recipe.ingredients or {}) do
      for _, burner_name in ipairs(burner_names) do
        if entry_name(ingredient) == burner_name then
          error("Skip burner stage left hidden ingredient " .. burner_name .. " in " .. recipe_name)
        end
      end
    end
  end
end
