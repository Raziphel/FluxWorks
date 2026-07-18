local Spectrum = require("prototypes.lib.flux-spectrum")

local recipes = {}
local unlocks = {}

local function add_recipe(recipe, technology_name)
  table.insert(recipes, recipe)
  Spectrum.add_unlock(unlocks, technology_name, recipe.name)
end

add_recipe({
  type = "recipe", name = "fw-red-solid-fuel-overdrive", enabled = false,
  category = "chemistry", subgroup = "fw-flux-red", order = "b[energetics]-a[solid-fuel]",
  energy_required = 3, allow_productivity = true,
  ingredients = {
    { type = "fluid", name = "light-oil", amount = 20 },
    { type = "fluid", name = "fw-red-flux", amount = 8 },
  },
  results = { { type = "item", name = "solid-fuel", amount = 3 } },
  main_product = "solid-fuel",
}, "fw-flux-red-energetics")

add_recipe({
  type = "recipe", name = "fw-red-rocket-fuel-overdrive", enabled = false,
  category = "chemistry", subgroup = "fw-flux-red", order = "b[energetics]-b[rocket-fuel]",
  energy_required = 12, allow_productivity = true,
  ingredients = {
    { type = "item", name = "solid-fuel", amount = 8 },
    { type = "fluid", name = "light-oil", amount = 10 },
    { type = "fluid", name = "fw-red-flux", amount = 18 },
  },
  results = { { type = "item", name = "rocket-fuel", amount = 1 } },
  main_product = "rocket-fuel",
}, "fw-flux-thermal-networks")

add_recipe({
  type = "recipe", name = "fw-red-steel-flash-smelting", enabled = false,
  category = "fw-arc-smelting", subgroup = "fw-flux-red", order = "b[energetics]-c[steel]",
  energy_required = 8, allow_productivity = true,
  ingredients = {
    { type = "item", name = "iron-plate", amount = 4 },
    { type = "fluid", name = "fw-red-flux", amount = 12 },
  },
  results = { { type = "item", name = "steel-plate", amount = 1 } },
  main_product = "steel-plate",
}, "fw-flux-metallurgy")

Spectrum.publish(recipes, unlocks)
