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
    "electronic-circuit", "iron-gear-wheel", "pipe", "transport-belt",
    "rocket-silo", "electric-mining-drill", "landing-pad-unloading-bay",
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

if not Startup.enabled("fw-enable-early-industry-overhaul", false) then
  local crusher = data.raw.recipe and data.raw.recipe.crusher
  if has_fw_ingredient(crusher) then
    error("Expansion-first mode cannot require FluxWorks parts to build Space Age Crusher")
  end
  local comminution = data.raw.technology and data.raw.technology["fw-comminution"]
  for _, effect in ipairs((comminution and comminution.effects) or {}) do
    if effect.type == "unlock-recipe" and effect.recipe == "crusher" then
      error("Space Age Crusher must retain its original research owner in expansion mode")
    end
  end
end
