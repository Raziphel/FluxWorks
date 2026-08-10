-- Keep the vanilla machine ladder connected to FluxWorks' mechanical and
-- electrical component lanes using the vanilla engine progression.
local function entry_name(entry)
  return type(entry) == "table" and (entry.name or entry[1]) or nil
end

local function add_ingredient(recipe_name, ingredient_name, amount)
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if not recipe then return end
  for _, ingredients in ipairs({
    recipe.ingredients,
    recipe.normal and recipe.normal.ingredients,
    recipe.expensive and recipe.expensive.ingredients,
  }) do
    if ingredients then
      local found = false
      for _, ingredient in ipairs(ingredients) do
        if entry_name(ingredient) == ingredient_name then found = true end
      end
      if not found then
        ingredients[#ingredients + 1] = { type = "item", name = ingredient_name, amount = amount }
      end
    end
  end
end

local function set_ingredients(recipe_name, ingredients)
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if not recipe then return end
  recipe.ingredients = table.deepcopy(ingredients)
  if recipe.normal then recipe.normal.ingredients = table.deepcopy(ingredients) end
  if recipe.expensive then recipe.expensive.ingredients = table.deepcopy(ingredients) end
end

local function remove_ingredient(recipe_name, ingredient_name)
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if not recipe then return end
  for _, ingredients in ipairs({
    recipe.ingredients,
    recipe.normal and recipe.normal.ingredients,
    recipe.expensive and recipe.expensive.ingredients,
  }) do
    for index = #(ingredients or {}), 1, -1 do
      if entry_name(ingredients[index]) == ingredient_name then table.remove(ingredients, index) end
    end
  end
end

local function remove_fluxworks_ingredients(recipe_name)
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if not recipe then return end
  for _, ingredients in ipairs({
    recipe.ingredients,
    recipe.normal and recipe.normal.ingredients,
    recipe.expensive and recipe.expensive.ingredients,
  }) do
    for index = #(ingredients or {}), 1, -1 do
      local name = entry_name(ingredients[index])
      if name and string.sub(name, 1, 3) == "fw-" then table.remove(ingredients, index) end
    end
  end
end

for _, ingredient in ipairs({
  { "fw-bearing", 2 },
  { "fw-circuit-contact", 2 },
}) do
  add_ingredient("assembling-machine-2", ingredient[1], ingredient[2])
end

for _, ingredient in ipairs({
  { "fw-control-assembly", 2 },
  { "fw-transformer-core", 1 },
}) do
  add_ingredient("assembling-machine-3", ingredient[1], ingredient[2])
end

add_ingredient("pumpjack", "fw-bearing", 2)
remove_ingredient("steam-engine", "bronze-plate")

set_ingredients("fw-control-assembly", {
  { type = "item", name = "fw-circuit-substrate", amount = 1 },
  { type = "item", name = "fw-chip-carrier", amount = 1 },
  { type = "item", name = "fw-solder-wire", amount = 1 },
  { type = "item", name = "fw-circuit-contact", amount = 1 },
})
set_ingredients("fw-transformer-core", {
  { type = "item", name = "fw-steel-beam", amount = 1 },
  { type = "item", name = "fw-tinned-cable", amount = 2 },
  { type = "item", name = "fw-inductor-coil", amount = 1 },
  { type = "item", name = "bronze-plate", amount = 1 },
})
set_ingredients("fw-flow-regulator", {
  { type = "item", name = "fw-pressure-housing", amount = 1 },
  { type = "item", name = "fw-bearing", amount = 1 },
  { type = "item", name = "fw-inline-filter", amount = 1 },
})
set_ingredients("fw-flux-quarry", {
  { type = "item", name = "electric-mining-drill", amount = 4 },
  { type = "item", name = "electric-engine-unit", amount = 4 },
  { type = "item", name = "fw-pressure-housing", amount = 6 },
  { type = "item", name = "fw-flow-regulator", amount = 4 },
})
remove_ingredient("fw-hydraulic-regulator-calibration", "engine-unit")

-- Electronics is Factorio's ten-copper trigger and must remain the bootstrap
-- for circuits, poles, inserters, and laboratories.
for _, recipe_name in ipairs({
  "electronic-circuit", "small-electric-pole", "inserter", "lab",
  "pipe", "pipe-to-ground", "pump", "storage-tank", "barrel",
  "captive-biter-spawner",
}) do
  remove_fluxworks_ingredients(recipe_name)
end
