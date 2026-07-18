local Recipe = require("__haul_lib__/utils/recipe")
local Startup = require("prototypes.lib.startup-settings")

local shared = {
  enabled = Startup.enabled("fw-enable-recipe-integration", true),
  enable_core_material_replacements = Startup.enabled("fw-enable-core-material-replacements", true),
  enable_combat_recipe_integration = Startup.enabled("fw-enable-combat-recipe-integration", true),
  enable_orbital_and_planetary_integration = Startup.enabled("fw-enable-orbital-and-planetary-integration", true),
  enable_machine_part_rehoming = Startup.enabled("fw-enable-machine-part-rehoming", true),
  enable_incomplete_rocket_parts = Startup.enabled("enable-incomplete-rocket-parts", true),
}

local function ingredient_name(ingredient)
  return ingredient.name or ingredient[1]
end

local function clone_ingredient(spec)
  if spec.type or spec.name then
    return table.deepcopy(spec)
  end

  return {
    type = "item",
    name = spec[1],
    amount = spec[2],
  }
end

local function add_unique_ingredient(ingredients, spec)
  local new_ingredient = clone_ingredient(spec)
  for _, ingredient in pairs(ingredients or {}) do
    if ingredient_name(ingredient) == new_ingredient.name then
      return ingredients
    end
  end
  table.insert(ingredients, new_ingredient)
  return ingredients
end

function shared.patch_recipe_ingredient_spec(recipe_name, ingredient_spec)
  if not (data.raw.recipe and data.raw.recipe[recipe_name]) then
    return
  end

  local recipe = Recipe:get(recipe_name)
  local ingredients = recipe.ingredients or {}
  recipe:setIngredients(add_unique_ingredient(ingredients, ingredient_spec))
end

function shared.patch_recipe_ingredients(recipe_name, name, amount)
  shared.patch_recipe_ingredient_spec(recipe_name, { type = "item", name = name, amount = amount })
end

function shared.patch_many_recipes(recipe_names, ingredient_name_value, amount)
  for _, recipe_name in ipairs(recipe_names) do
    shared.patch_recipe_ingredients(recipe_name, ingredient_name_value, amount)
  end
end

function shared.patch_recipe_set(patches)
  for _, patch in ipairs(patches) do
    shared.patch_recipe_ingredients(patch[1], patch[2], patch[3])
  end
end

function shared.set_recipe_ingredients(recipe_name, ingredient_specs)
  if not (data.raw.recipe and data.raw.recipe[recipe_name]) then
    return
  end

  local ingredients = {}
  for _, spec in ipairs(ingredient_specs) do
    ingredients[#ingredients + 1] = clone_ingredient(spec)
  end

  local recipe = Recipe:get(recipe_name)
  recipe:setIngredients(ingredients)
end

local function remove_ingredient(ingredients, name)
  local filtered = {}
  for _, ingredient in pairs(ingredients or {}) do
    if ingredient_name(ingredient) ~= name then
      filtered[#filtered + 1] = ingredient
    end
  end
  return filtered
end

function shared.remove_recipe_ingredient(recipe_name, name)
  if not (data.raw.recipe and data.raw.recipe[recipe_name]) then
    return
  end

  local recipe = Recipe:get(recipe_name)
  recipe:setIngredients(remove_ingredient(recipe.ingredients or {}, name))
end

function shared.replace_recipe_ingredient(recipe_name, old_name, new_spec)
  if not (data.raw.recipe and data.raw.recipe[recipe_name]) then
    return
  end

  local recipe = Recipe:get(recipe_name)
  local ingredients = remove_ingredient(recipe.ingredients or {}, old_name)
  recipe:setIngredients(add_unique_ingredient(ingredients, new_spec))
end

function shared.replace_many_recipe_ingredients(recipe_names, old_name, new_spec)
  for _, recipe_name in ipairs(recipe_names) do
    shared.replace_recipe_ingredient(recipe_name, old_name, new_spec)
  end
end

function shared.remove_many_recipe_ingredients(recipe_names, ingredient_name_value)
  for _, recipe_name in ipairs(recipe_names) do
    shared.remove_recipe_ingredient(recipe_name, ingredient_name_value)
  end
end

function shared.set_recipe_category(recipe_name, category)
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if not recipe then
    return
  end

  recipe.category = category
  if recipe.normal then
    recipe.normal.category = category
  end
  if recipe.expensive then
    recipe.expensive.category = category
  end
end

function shared.set_recipe_subgroup(recipe_name, subgroup)
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if not recipe then
    return
  end

  recipe.subgroup = subgroup
  if recipe.normal then
    recipe.normal.subgroup = subgroup
  end
  if recipe.expensive then
    recipe.expensive.subgroup = subgroup
  end
end

return shared
