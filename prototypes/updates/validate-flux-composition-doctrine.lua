local doctrine = require("prototypes.updates.flux-composition-doctrine")

local function ingredient_name(ingredient)
  return ingredient.name or ingredient[1]
end

local function ingredient_type(ingredient)
  return ingredient.type or "item"
end

local function validate_variant(recipe_name, variant)
  if not variant then
    return
  end

  local spectra = {}
  local non_flux_count = 0
  for _, ingredient in pairs(variant.ingredients or {}) do
    local name = ingredient_name(ingredient)
    if ingredient_type(ingredient) == "fluid" and doctrine.flux_fluids[name] then
      spectra[name] = true
    else
      non_flux_count = non_flux_count + 1
    end
  end

  local spectrum_count = 0
  for _ in pairs(spectra) do
    spectrum_count = spectrum_count + 1
  end

  if spectrum_count == 4 and non_flux_count > 0 then
    error("Four-spectrum Flux recipe contains conventional ingredients: " .. recipe_name)
  end

  local is_exchange = string.sub(recipe_name, 1, 22) == "fw-exchange-from-flux-"
  if (is_exchange or doctrine.pure_recipes[recipe_name]) and spectrum_count ~= 4 then
    error("Matter-composition recipe must use all four Flux spectra: " .. recipe_name)
  end
end

for recipe_name, recipe in pairs(data.raw.recipe or {}) do
  validate_variant(recipe_name, recipe)
  validate_variant(recipe_name, recipe.normal)
  validate_variant(recipe_name, recipe.expensive)
end
