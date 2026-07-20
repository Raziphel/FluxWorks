-- Four-spectrum Flux is the substance of matter, not a universal recipe tax.
-- Ordinary construction may use one spectrum for a specific physical effect,
-- but recipes using all four are reserved for direct matter composition.

local FLUX_FLUIDS = {
  ["fw-purple-flux"] = true,
  ["fw-yellow-flux"] = true,
  ["fw-red-flux"] = true,
  ["fw-green-flux"] = true,
}

local PURE_COMPOSITION_RECIPES = {
  ["fw-condensed-flux-matrix"] = true,
  ["fw-rift-seed-crystallization"] = true,
  ["fw-shattered-vent-spectrum-condensation"] = true,
}

local function ingredient_name(ingredient)
  return ingredient.name or ingredient[1]
end

local function ingredient_type(ingredient)
  return ingredient.type or "item"
end

local function four_spectrum_count(ingredients)
  local found = {}
  for _, ingredient in pairs(ingredients or {}) do
    local name = ingredient_name(ingredient)
    if ingredient_type(ingredient) == "fluid" and FLUX_FLUIDS[name] then
      found[name] = true
    end
  end

  local count = 0
  for _ in pairs(found) do
    count = count + 1
  end
  return count
end

local function keep_only_flux(ingredients)
  local result = {}
  for _, ingredient in pairs(ingredients or {}) do
    local name = ingredient_name(ingredient)
    if ingredient_type(ingredient) == "fluid" and FLUX_FLUIDS[name] then
      result[#result + 1] = ingredient
    end
  end
  return result
end

local function remove_flux(ingredients)
  local result = {}
  for _, ingredient in pairs(ingredients or {}) do
    local name = ingredient_name(ingredient)
    if not (ingredient_type(ingredient) == "fluid" and FLUX_FLUIDS[name]) then
      result[#result + 1] = ingredient
    end
  end
  return result
end

local function normalize_variant(recipe_name, variant)
  if not variant or four_spectrum_count(variant.ingredients) ~= 4 then
    return
  end

  local is_exchange = string.sub(recipe_name, 1, 22) == "fw-exchange-from-flux-"
  if is_exchange or PURE_COMPOSITION_RECIPES[recipe_name] then
    variant.ingredients = keep_only_flux(variant.ingredients)
  else
    variant.ingredients = remove_flux(variant.ingredients)
  end
end

for recipe_name, recipe in pairs(data.raw.recipe or {}) do
  normalize_variant(recipe_name, recipe)
  normalize_variant(recipe_name, recipe.normal)
  normalize_variant(recipe_name, recipe.expensive)
end

return {
  flux_fluids = FLUX_FLUIDS,
  pure_recipes = PURE_COMPOSITION_RECIPES,
}
