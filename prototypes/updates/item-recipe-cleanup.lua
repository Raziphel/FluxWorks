-- Remove intermediates whose manufacturing role is already expressed by a
-- standard Factorio item. Copper tubes duplicated pipes without creating a
-- distinct process constraint, so consumers now use the shared pipe bus.
local REMOVED_ITEMS = {
  ["fw-copper-tube"] = { replacement = "pipe", amount_scale = 1 },
}

local function entry_name(entry)
  return type(entry) == "table" and (entry.name or entry[1]) or nil
end

local RECIPE_REPLACEMENTS = {
  ["fw-circuit-substrate"] = "copper-plate",
  ["fw-glass-lens"] = "copper-plate",
  ["selector-combinator"] = "copper-cable",
}

local function rewrite_ingredients(recipe_name, ingredients)
  local first_by_key = {}
  for _, ingredient in ipairs(ingredients or {}) do
    local removal = REMOVED_ITEMS[entry_name(ingredient)]
    if removal then
      ingredient.name = RECIPE_REPLACEMENTS[recipe_name] or removal.replacement
      ingredient[1] = nil
      ingredient.type = "item"
      ingredient.amount = math.max(1, math.ceil((ingredient.amount or ingredient[2] or 1) * removal.amount_scale))
      ingredient[2] = nil
    end
  end

  for index = #(ingredients or {}), 1, -1 do
    local ingredient = ingredients[index]
    local key = (ingredient.type or "item") .. ":" .. tostring(entry_name(ingredient))
    local first = first_by_key[key]
    if first then
      first.amount = (first.amount or first[2] or 1) + (ingredient.amount or ingredient[2] or 1)
      first[2] = nil
      table.remove(ingredients, index)
    else
      first_by_key[key] = ingredient
    end
  end
end

local removed_recipes = {}
for recipe_name, recipe in pairs(data.raw.recipe or {}) do
  local produces_removed_item = false
  for _, result in ipairs(recipe.results or {}) do
    if REMOVED_ITEMS[entry_name(result)] then produces_removed_item = true end
  end

  if produces_removed_item then
    removed_recipes[recipe_name] = true
  else
    rewrite_ingredients(recipe_name, recipe.ingredients)
    rewrite_ingredients(recipe_name, recipe.normal and recipe.normal.ingredients)
    rewrite_ingredients(recipe_name, recipe.expensive and recipe.expensive.ingredients)
  end
end

for _, technology in pairs(data.raw.technology or {}) do
  for index = #(technology.effects or {}), 1, -1 do
    local effect = technology.effects[index]
    if effect.type == "unlock-recipe" and removed_recipes[effect.recipe] then
      table.remove(technology.effects, index)
    end
  end
end

for recipe_name in pairs(removed_recipes) do data.raw.recipe[recipe_name] = nil end
for item_name in pairs(REMOVED_ITEMS) do data.raw.item[item_name] = nil end

return {
  removed_items = REMOVED_ITEMS,
  removed_recipes = removed_recipes,
}
