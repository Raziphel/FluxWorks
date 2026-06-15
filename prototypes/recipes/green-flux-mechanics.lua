local Spectrum = require("prototypes.lib.flux-spectrum")

local recipes = {}
local unlocks = {}
local bio_category = Spectrum.bio_category()

local function add_recipe(recipe, technology_name)
  table.insert(recipes, recipe)
  Spectrum.add_unlock(unlocks, technology_name, recipe.name)
end

if Spectrum.item_exists("spoilage") and Spectrum.item_exists("nutrients") and Spectrum.fluid_exists("fw-green-flux") then
  add_recipe({
    type = "recipe",
    name = "fw-green-flux-spoilage-reclamation",
    category = bio_category,
    subgroup = "fw-bioprocessing-processes",
    order = "f[green-flux]-a[spoilage-reclamation]",
    enabled = false,
    energy_required = 4.5,
    allow_productivity = false,
    ingredients = {
      { type = "item", name = "spoilage", amount = 6 },
      { type = "fluid", name = "fw-green-flux", amount = 24 },
    },
    results = {
      { type = "item", name = "nutrients", amount = 10 },
    },
    main_product = "nutrients",
  }, "fw-flux-field-theory")
end

if Spectrum.item_exists("bioflux") and Spectrum.item_exists("nutrients") and Spectrum.item_exists("spoilage") and Spectrum.fluid_exists("fw-green-flux") then
  add_recipe({
    type = "recipe",
    name = "fw-green-flux-bioflux-cultivation",
    category = bio_category,
    subgroup = "fw-bioprocessing-processes",
    order = "f[green-flux]-b[bioflux-cultivation]",
    enabled = false,
    energy_required = 6,
    allow_productivity = false,
    ingredients = {
      { type = "item", name = "nutrients", amount = 14 },
      { type = "item", name = "spoilage", amount = 6 },
      { type = "fluid", name = "fw-green-flux", amount = 24 },
    },
    results = {
      { type = "item", name = "bioflux", amount = 1 },
    },
    main_product = "bioflux",
  }, "fw-flux-synthesis")
end

if Spectrum.fluid_exists("biolubricant") and Spectrum.item_exists("bioflux") and Spectrum.item_exists("nutrients") and Spectrum.fluid_exists("fw-green-flux") then
  add_recipe({
    type = "recipe",
    name = "fw-green-flux-biolubricant-culture",
    category = bio_category,
    subgroup = "fw-bioprocessing-processes",
    order = "f[green-flux]-c[biolubricant-culture]",
    enabled = false,
    energy_required = 7,
    allow_productivity = false,
    ingredients = {
      { type = "item", name = "bioflux", amount = 2 },
      { type = "item", name = "nutrients", amount = 10 },
      { type = "fluid", name = "fw-green-flux", amount = 18 },
    },
    results = {
      { type = "fluid", name = "biolubricant", amount = 24 },
    },
    main_product = "biolubricant",
  }, "fw-flux-synthesis")
end

if Spectrum.item_exists("raw-fish") and Spectrum.item_exists("nutrients") and Spectrum.fluid_exists("fw-green-flux") then
  add_recipe({
    type = "recipe",
    name = "fw-green-flux-aquaculture-feed",
    category = bio_category,
    subgroup = "fw-bioprocessing-processes",
    order = "f[green-flux]-d[aquaculture-feed]",
    enabled = false,
    energy_required = 6,
    allow_productivity = false,
    ingredients = {
      { type = "item", name = "raw-fish", amount = 1 },
      { type = "item", name = "nutrients", amount = 8 },
      { type = "fluid", name = "fw-green-flux", amount = 16 },
    },
    results = {
      { type = "item", name = "raw-fish", amount = 2 },
    },
    main_product = "raw-fish",
  }, "fw-flux-synthesis")
end

local function add_seed_recipe(seed_name, order_suffix)
  if Spectrum.item_exists(seed_name) and Spectrum.item_exists("nutrients") and Spectrum.fluid_exists("fw-green-flux") then
    add_recipe({
      type = "recipe",
      name = "fw-green-flux-" .. seed_name .. "-propagation",
      category = bio_category,
      subgroup = "fw-bioprocessing-processes",
      order = "f[green-flux]-" .. order_suffix .. "[" .. seed_name .. "-propagation]",
      enabled = false,
      energy_required = 7,
      allow_productivity = false,
      ingredients = {
        { type = "item", name = seed_name, amount = 1 },
        { type = "item", name = "nutrients", amount = 12 },
        { type = "fluid", name = "fw-green-flux", amount = 18 },
      },
      results = {
        { type = "item", name = seed_name, amount = 2 },
      },
      main_product = seed_name,
    }, "fw-flux-synthesis")
  end
end

add_seed_recipe("yumako-seed", "e")
add_seed_recipe("jellynut-seed", "f")
add_seed_recipe("tree-seed", "g")

Spectrum.publish(recipes, unlocks)
