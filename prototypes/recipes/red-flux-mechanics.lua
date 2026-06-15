local Spectrum = require("prototypes.lib.flux-spectrum")

local recipes = {}
local unlocks = {}

local function add_recipe(recipe, technology_name)
  table.insert(recipes, recipe)
  Spectrum.add_unlock(unlocks, technology_name, recipe.name)
end

if Spectrum.item_exists("solid-fuel") and Spectrum.item_exists("fw-carbon") and Spectrum.fluid_exists("fw-red-flux") then
  add_recipe({
    type = "recipe",
    name = "fw-red-flux-fuel-compaction",
    category = "chemistry",
    subgroup = "fw-flux-systems",
    order = "d[power]-a[fuel-compaction]",
    enabled = false,
    energy_required = 4.5,
    allow_productivity = true,
    ingredients = {
      { type = "item", name = "fw-carbon", amount = 3 },
      { type = "fluid", name = "fw-red-flux", amount = 32 },
    },
    results = {
      { type = "item", name = "solid-fuel", amount = 1 },
    },
    main_product = "solid-fuel",
  }, "fw-flux-red-energetics")
end

if Spectrum.item_exists("rocket-fuel") and Spectrum.item_exists("solid-fuel") and Spectrum.item_exists("fw-capacitor") and Spectrum.fluid_exists("fw-red-flux") then
  add_recipe({
    type = "recipe",
    name = "fw-red-flux-rocket-fuel-infusion",
    category = "chemistry",
    subgroup = "fw-flux-systems",
    order = "d[power]-b[rocket-fuel-infusion]",
    enabled = false,
    energy_required = 9,
    allow_productivity = true,
    ingredients = {
      { type = "item", name = "solid-fuel", amount = 3 },
      { type = "item", name = "fw-capacitor", amount = 1 },
      { type = "fluid", name = "fw-red-flux", amount = 110 },
    },
    results = {
      { type = "item", name = "rocket-fuel", amount = 1 },
    },
    main_product = "rocket-fuel",
  }, "fw-flux-thermal-networks")
end

if Spectrum.item_exists("nuclear-fuel") and Spectrum.item_exists("rocket-fuel") and Spectrum.item_exists("uranium-235") and Spectrum.item_exists("fw-transformer-core") and Spectrum.fluid_exists("fw-red-flux") then
  add_recipe({
    type = "recipe",
    name = "fw-red-flux-nuclear-fuel-staging",
    category = "chemistry",
    subgroup = "fw-flux-systems",
    order = "d[power]-c[nuclear-fuel-staging]",
    enabled = false,
    energy_required = 14,
    allow_productivity = true,
    ingredients = {
      { type = "item", name = "rocket-fuel", amount = 1 },
      { type = "item", name = "uranium-235", amount = 1 },
      { type = "item", name = "fw-transformer-core", amount = 1 },
      { type = "fluid", name = "fw-red-flux", amount = 160 },
    },
    results = {
      { type = "item", name = "nuclear-fuel", amount = 1 },
    },
    main_product = "nuclear-fuel",
  }, "fw-flux-overdrive")
end

Spectrum.publish(recipes, unlocks)
