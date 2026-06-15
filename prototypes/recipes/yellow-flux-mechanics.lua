local Spectrum = require("prototypes.lib.flux-spectrum")

local recipes = {}
local unlocks = {}

local function add_recipe(recipe, technology_name)
  table.insert(recipes, recipe)
  Spectrum.add_unlock(unlocks, technology_name, recipe.name)
end

if Spectrum.fluid_exists("fw-purple-flux") and Spectrum.fluid_exists("fw-yellow-flux") and Spectrum.item_exists("fw-flux-catalyst") and Spectrum.fluid_exists("fw-chlorine") and Spectrum.item_exists("fw-resin") then
  add_recipe({
    type = "recipe",
    name = "fw-yellow-flux-conditioning",
    category = "chemistry",
    subgroup = "fw-flux-systems",
    order = "a[conditioning]-b[yellow-flux]",
    enabled = false,
    energy_required = 3,
    allow_productivity = true,
    ingredients = {
      { type = "fluid", name = "fw-purple-flux", amount = 36 },
      { type = "item", name = "fw-flux-catalyst", amount = 1 },
      { type = "fluid", name = "fw-chlorine", amount = 18 },
      { type = "item", name = "fw-resin", amount = 1 },
    },
    results = {
      { type = "fluid", name = "fw-yellow-flux", amount = 28 },
      { type = "item", name = "fw-flux-catalyst", amount = 1, probability = 0.9 },
    },
    main_product = "fw-yellow-flux",
  }, "fw-flux-field-theory")
end

if Spectrum.item_exists("fw-salt") and Spectrum.fluid_exists("water") and Spectrum.fluid_exists("fw-chlorine") and Spectrum.fluid_exists("fw-purple-flux") and Spectrum.fluid_exists("fw-yellow-flux") then
  add_recipe({
    type = "recipe",
    name = "fw-yellow-flux-chlorine-pressurization",
    category = "chemistry",
    subgroup = "fw-chemistry-processes",
    order = "f[yellow-flux]-b[chlorine-pressurization]",
    enabled = false,
    energy_required = 4,
    allow_productivity = true,
    ingredients = {
      { type = "item", name = "fw-salt", amount = 3 },
      { type = "fluid", name = "water", amount = 40 },
      { type = "fluid", name = "fw-purple-flux", amount = 12 },
    },
    results = {
      { type = "fluid", name = "fw-chlorine", amount = 32 },
      { type = "fluid", name = "fw-yellow-flux", amount = 4, ignored_by_stats = 2 },
    },
    main_product = "fw-chlorine",
  }, "fw-flux-field-theory")
end

if Spectrum.item_exists("plastic-bar") and Spectrum.fluid_exists("water") and Spectrum.fluid_exists("fw-purple-flux") and Spectrum.fluid_exists("fw-yellow-flux") and Spectrum.fluid_exists("fw-latex") then
  add_recipe({
    type = "recipe",
    name = "fw-yellow-flux-latex-suspension",
    category = "chemistry",
    subgroup = "fw-chemistry-processes",
    order = "f[yellow-flux]-c[latex-suspension]",
    enabled = false,
    energy_required = 4.5,
    allow_productivity = true,
    ingredients = {
      { type = "item", name = "plastic-bar", amount = 3 },
      { type = "fluid", name = "water", amount = 30 },
      { type = "fluid", name = "fw-purple-flux", amount = 10 },
    },
    results = {
      { type = "fluid", name = "fw-latex", amount = 48 },
      { type = "fluid", name = "fw-yellow-flux", amount = 4, ignored_by_stats = 2 },
    },
    main_product = "fw-latex",
  }, "fw-flux-field-theory")
end

if Spectrum.item_exists("sulfur") and Spectrum.item_exists("fw-carbon") and Spectrum.fluid_exists("fw-chlorine") and Spectrum.fluid_exists("fw-purple-flux") and Spectrum.fluid_exists("fw-yellow-flux") then
  add_recipe({
    type = "recipe",
    name = "fw-yellow-flux-sulfur-bonding",
    category = "chemistry",
    subgroup = "fw-chemistry-processes",
    order = "f[yellow-flux]-d[sulfur-bonding]",
    enabled = false,
    energy_required = 4.5,
    allow_productivity = true,
    ingredients = {
      { type = "item", name = "fw-carbon", amount = 1 },
      { type = "fluid", name = "fw-chlorine", amount = 24 },
      { type = "fluid", name = "fw-purple-flux", amount = 10 },
    },
    results = {
      { type = "item", name = "sulfur", amount = 3 },
      { type = "fluid", name = "fw-yellow-flux", amount = 5, ignored_by_stats = 2 },
    },
    main_product = "sulfur",
  }, "fw-flux-field-theory")
end

if Spectrum.fluid_exists("sulfuric-acid") and Spectrum.item_exists("sulfur") and Spectrum.fluid_exists("fw-chlorine") and Spectrum.fluid_exists("water") and Spectrum.fluid_exists("fw-purple-flux") and Spectrum.fluid_exists("fw-yellow-flux") then
  add_recipe({
    type = "recipe",
    name = "fw-yellow-flux-acid-synthesis",
    category = "chemistry",
    subgroup = "fw-chemistry-processes",
    order = "f[yellow-flux]-e[acid-synthesis]",
    enabled = false,
    energy_required = 5,
    allow_productivity = true,
    ingredients = {
      { type = "item", name = "sulfur", amount = 2 },
      { type = "fluid", name = "fw-chlorine", amount = 20 },
      { type = "fluid", name = "water", amount = 50 },
      { type = "fluid", name = "fw-purple-flux", amount = 14 },
    },
    results = {
      { type = "fluid", name = "sulfuric-acid", amount = 120 },
      { type = "fluid", name = "fw-yellow-flux", amount = 6, ignored_by_stats = 3 },
    },
    main_product = "sulfuric-acid",
  }, "fw-flux-field-theory")
end

if Spectrum.item_exists("fw-resin") and Spectrum.item_exists("fw-carbon") and Spectrum.fluid_exists("fw-latex") and Spectrum.fluid_exists("fw-purple-flux") and Spectrum.fluid_exists("fw-yellow-flux") then
  add_recipe({
    type = "recipe",
    name = "fw-yellow-flux-resin-polymerization",
    category = "chemistry",
    subgroup = "fw-chemistry-processes",
    order = "f[yellow-flux]-f[resin-polymerization]",
    enabled = false,
    energy_required = 5,
    allow_productivity = true,
    ingredients = {
      { type = "item", name = "fw-carbon", amount = 1 },
      { type = "fluid", name = "fw-latex", amount = 30 },
      { type = "fluid", name = "fw-purple-flux", amount = 10 },
    },
    results = {
      { type = "item", name = "fw-resin", amount = 2 },
      { type = "fluid", name = "fw-yellow-flux", amount = 4, ignored_by_stats = 2 },
    },
    main_product = "fw-resin",
  }, "fw-flux-synthesis")
end

if Spectrum.item_exists("fw-rubber-sheet") and Spectrum.item_exists("fw-resin") and Spectrum.item_exists("sulfur") and Spectrum.fluid_exists("fw-latex") and Spectrum.fluid_exists("fw-purple-flux") and Spectrum.fluid_exists("fw-yellow-flux") then
  add_recipe({
    type = "recipe",
    name = "fw-yellow-flux-rubber-vulcanization",
    category = "chemistry",
    subgroup = "fw-chemistry-processes",
    order = "f[yellow-flux]-g[rubber-vulcanization]",
    enabled = false,
    energy_required = 4.5,
    allow_productivity = true,
    ingredients = {
      { type = "item", name = "fw-resin", amount = 1 },
      { type = "item", name = "sulfur", amount = 1 },
      { type = "fluid", name = "fw-latex", amount = 20 },
      { type = "fluid", name = "fw-purple-flux", amount = 8 },
    },
    results = {
      { type = "item", name = "fw-rubber-sheet", amount = 5 },
      { type = "fluid", name = "fw-yellow-flux", amount = 4, ignored_by_stats = 2 },
    },
    main_product = "fw-rubber-sheet",
  }, "fw-flux-synthesis")
end

if Spectrum.fluid_exists("fw-blasting-gel") and Spectrum.item_exists("explosives") and Spectrum.item_exists("fw-resin") and Spectrum.fluid_exists("water") and Spectrum.fluid_exists("fw-purple-flux") and Spectrum.fluid_exists("fw-yellow-flux") then
  add_recipe({
    type = "recipe",
    name = "fw-yellow-flux-blasting-gel",
    category = "chemistry",
    subgroup = "fw-chemistry-processes",
    order = "f[yellow-flux]-h[blasting-gel]",
    enabled = false,
    energy_required = 5.5,
    allow_productivity = true,
    ingredients = {
      { type = "item", name = "explosives", amount = 1 },
      { type = "item", name = "fw-resin", amount = 1 },
      { type = "fluid", name = "water", amount = 20 },
      { type = "fluid", name = "fw-purple-flux", amount = 12 },
    },
    results = {
      { type = "fluid", name = "fw-blasting-gel", amount = 40 },
      { type = "fluid", name = "fw-yellow-flux", amount = 6, ignored_by_stats = 3 },
    },
    main_product = "fw-blasting-gel",
  }, "fw-flux-synthesis")
end

if Spectrum.item_exists("explosives") and Spectrum.item_exists("cliff-explosives") and Spectrum.fluid_exists("fw-blasting-gel") and Spectrum.fluid_exists("fw-purple-flux") and Spectrum.fluid_exists("fw-yellow-flux") then
  add_recipe({
    type = "recipe",
    name = "fw-yellow-flux-reactive-slurry",
    category = "chemistry",
    subgroup = "fw-chemistry-processes",
    order = "f[yellow-flux]-i[reactive-slurry]",
    enabled = false,
    energy_required = 6,
    allow_productivity = true,
    ingredients = {
      { type = "item", name = "explosives", amount = 1 },
      { type = "fluid", name = "fw-blasting-gel", amount = 30 },
      { type = "fluid", name = "fw-purple-flux", amount = 8 },
    },
    results = {
      { type = "item", name = "cliff-explosives", amount = 2 },
      { type = "fluid", name = "fw-yellow-flux", amount = 4, ignored_by_stats = 2 },
    },
    main_product = "cliff-explosives",
  }, "fw-flux-synthesis")
end

if Spectrum.item_exists("battery") and Spectrum.fluid_exists("sulfuric-acid") and Spectrum.item_exists("lead-plate") and Spectrum.item_exists("copper-plate") and Spectrum.fluid_exists("fw-purple-flux") and Spectrum.fluid_exists("fw-yellow-flux") then
  add_recipe({
    type = "recipe",
    name = "fw-yellow-flux-battery-electrolyte",
    category = "chemistry",
    subgroup = "fw-chemistry-processes",
    order = "f[yellow-flux]-j[battery-electrolyte]",
    enabled = false,
    energy_required = 6,
    allow_productivity = true,
    ingredients = {
      { type = "item", name = "lead-plate", amount = 1 },
      { type = "item", name = "copper-plate", amount = 1 },
      { type = "fluid", name = "sulfuric-acid", amount = 20 },
      { type = "fluid", name = "fw-purple-flux", amount = 10 },
    },
    results = {
      { type = "item", name = "battery", amount = 2 },
      { type = "fluid", name = "fw-yellow-flux", amount = 4, ignored_by_stats = 2 },
    },
    main_product = "battery",
  }, "fw-flux-synthesis")
end

Spectrum.publish(recipes, unlocks)
