local recipe_touches_fluxworks = require("prototypes.updates.recipe-decomposition")

local boundary_count = 0
for recipe_name, recipe in pairs(data.raw.recipe or {}) do
  if recipe_touches_fluxworks(recipe) then
    boundary_count = boundary_count + 1
    if recipe.allow_decomposition ~= false then
      error("FluxWorks Total raw boundary drifted for recipe: " .. recipe_name)
    end
  end
end

if boundary_count < 100 then
  error("FluxWorks Total raw boundary coverage is unexpectedly small: " .. boundary_count)
end
