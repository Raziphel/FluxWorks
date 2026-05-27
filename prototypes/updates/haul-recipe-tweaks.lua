local Recipe = require("__haul_lib__/utils/recipe")

local function ingredient_name(ingredient)
  return ingredient.name or ingredient[1]
end

local function add_unique_ingredient(ingredients, name, amount)
  for _, ingredient in pairs(ingredients or {}) do
    if ingredient_name(ingredient) == name then
      return ingredients
    end
  end
  table.insert(ingredients, { type = "item", name = name, amount = amount })
  return ingredients
end

local function patch_recipe_ingredients(recipe_name, name, amount)
  if not (data.raw.recipe and data.raw.recipe[recipe_name]) then
    return
  end

  local recipe = Recipe:get(recipe_name)
  local ingredients = recipe.ingredients or {}
  recipe:setIngredients(add_unique_ingredient(ingredients, name, amount))
end

-- Targeted base-game integration, kept intentionally light.
patch_recipe_ingredients("electronic-circuit", "fw-solder-alloy", 1)
patch_recipe_ingredients("advanced-circuit", "fw-solder-alloy", 1)
patch_recipe_ingredients("advanced-circuit", "fw-ceramic-insulator", 1)
patch_recipe_ingredients("processing-unit", "fw-solder-alloy", 1)
patch_recipe_ingredients("processing-unit", "fw-capacitor", 1)
patch_recipe_ingredients("engine-unit", "fw-bearing", 1)
patch_recipe_ingredients("electric-engine-unit", "fw-bearing", 1)
patch_recipe_ingredients("flying-robot-frame", "fw-light-frame", 1)
patch_recipe_ingredients("low-density-structure", "fw-light-frame", 1)
patch_recipe_ingredients("battery", "fw-ceramic-insulator", 1)
patch_recipe_ingredients("accumulator", "fw-capacitor", 2)
patch_recipe_ingredients("firearm-magazine", "fw-gunpowder", 1)
patch_recipe_ingredients("piercing-rounds-magazine", "fw-gunpowder", 1)
patch_recipe_ingredients("uranium-rounds-magazine", "fw-gunpowder", 1)
