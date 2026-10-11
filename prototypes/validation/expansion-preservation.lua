-- Regression contracts for the default expansion-first experience. FluxWorks
-- equipment and science may be complex, but base/K2SO early recipes remain theirs.
local Startup = require("prototypes.lib.startup-settings")
local function has_fw_ingredient(recipe)
  for _, ingredient in ipairs((recipe and recipe.ingredients) or {}) do
    local name = ingredient.name or ingredient[1]
    if type(name) == "string" and name:sub(1, 3) == "fw-" then return name end
  end
end
if not Startup.enabled("fw-enable-recipe-integration", false) then
  for _, recipe_name in ipairs({
    "electronic-circuit", "iron-gear-wheel", "pipe", "transport-belt", "rocket-silo",
  }) do
    local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
    local ingredient_name = has_fw_ingredient(recipe)
    if ingredient_name then
      error("Expansion-first mode must preserve " .. recipe_name
        .. " without a required FluxWorks part: " .. ingredient_name)
    end
  end
end
if not Startup.enabled("fw-enable-legacy-technology-overhaul", false) then
  for _, technology_name in ipairs({ "rocket-silo", "railway", "automation-3" }) do
    local technology = data.raw.technology and data.raw.technology[technology_name]
    for _, prerequisite in ipairs((technology and technology.prerequisites) or {}) do
      if prerequisite:sub(1, 3) == "fw-" then
        error("Expansion-first mode unexpectedly gates "
          .. technology_name .. " behind " .. prerequisite)
      end
    end
  end
end
