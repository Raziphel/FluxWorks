local recipe_touches_fluxworks = require("prototypes.updates.recipe-decomposition")
local MAXIMUM_INGREDIENTS = 7

for recipe_name, recipe in pairs(data.raw.recipe or {}) do
  if recipe_touches_fluxworks(recipe) then
    for _, ingredients in ipairs({
      recipe.ingredients,
      recipe.normal and recipe.normal.ingredients,
      recipe.expensive and recipe.expensive.ingredients,
    }) do
      if ingredients and #ingredients > MAXIMUM_INGREDIENTS then
        error(("%s has %d ingredients; FluxWorks recipes are capped at %d to avoid parts-checklist crafting"):format(
          recipe_name, #ingredients, MAXIMUM_INGREDIENTS
        ))
      end
    end
  end
end
