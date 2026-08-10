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

if data.raw["bool-setting"] and data.raw["bool-setting"]["fw-skip-burner-stage"] then
  error("Native industry validation: removed Skip burner stage setting still exists")
end

assert_ingredients("electric-mining-drill",
  { "burner-mining-drill", "electronic-circuit", "fw-bearing" },
  { "engine-unit" })
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
