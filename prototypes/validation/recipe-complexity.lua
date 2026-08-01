local recipe_touches_fluxworks = require("prototypes.updates.recipe-decomposition")
local MAXIMUM_INGREDIENTS = 7
local COMPACT_COMPONENTS = {
  "fw-ceramic-casing",
  "fw-control-assembly",
  "fw-field-winding",
  "fw-flow-regulator",
  "fw-foundry-lining",
  "fw-power-regulator",
  "fw-pressure-housing",
  "fw-sensor-package",
  "fw-signal-conduit",
  "fw-transformer-core",
}

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

-- Four inputs is enough detail for parts that recur throughout the factory.
for _, recipe_name in ipairs(COMPACT_COMPONENTS) do
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  local ingredients = recipe and recipe.ingredients
  if not ingredients then
    error("Missing compact component recipe " .. recipe_name)
  end
  if #ingredients > 4 then
    error(("%s has %d ingredients; recurring components are capped at 4"):format(
      recipe_name, #ingredients
    ))
  end
end
