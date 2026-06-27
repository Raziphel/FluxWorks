local Spectrum = require("prototypes.lib.flux-spectrum")

local recipes = {}
local unlocks = {}

local function add_recipe(recipe, technology_name)
  table.insert(recipes, recipe)
  Spectrum.add_unlock(unlocks, technology_name, recipe.name)
end

Spectrum.publish(recipes, unlocks)
