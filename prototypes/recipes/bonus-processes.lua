local Spectrum = require("prototypes.lib.flux-spectrum")

local function item_exists(name)
  return data.raw.item and data.raw.item[name]
end

local function fluid_exists(name)
  return data.raw.fluid and data.raw.fluid[name]
end

local bio_category = Spectrum.bio_category()

local function assign_icon_fields(target, prototype)
  if prototype.icons then
    target.icons = prototype.icons
  else
    target.icon = prototype.icon
    target.icon_size = prototype.icon_size
  end
end

local function add_recipe_if_valid(recipes, recipe, requirements)
  for _, requirement in ipairs(requirements or {}) do
    local kind = requirement[1]
    local name = requirement[2]
    if kind == "item" and not item_exists(name) then
      return
    end
    if kind == "fluid" and not fluid_exists(name) then
      return
    end
  end

  table.insert(recipes, recipe)
end

local recipes = {}

add_recipe_if_valid(recipes, {
  type = "recipe",
  name = "fw-reactive-slurry-focusing",
  icon = "__base__/graphics/icons/cliff-explosives.png",
  icon_size = 64,
  category = "chemistry",
  subgroup = "fw-chemistry-processes",
  order = "e[base-chemistry]-h2[reactive-slurry-focusing]",
  enabled = false,
  energy_required = 7.5,
  allow_productivity = false,
  localised_name = { "", { "recipe-name.fw-reactive-slurry" }, " Focusing" },
  localised_description = { "", "Turns demolition gel into a denser double-yield charge instead of another open-ended productivity target." },
  ingredients = {
    { type = "item", name = "explosives", amount = 1 },
    { type = "fluid", name = "fw-blasting-gel", amount = 20 },
    { type = "fluid", name = "fw-yellow-flux", amount = 12 },
  },
  results = {
    { type = "item", name = "cliff-explosives", amount = 2 },
  },
  main_product = "cliff-explosives",
}, {
  { "item", "explosives" },
  { "fluid", "fw-blasting-gel" },
  { "fluid", "fw-yellow-flux" },
})

add_recipe_if_valid(recipes, {
  type = "recipe",
  name = "fw-gelled-napalm-mixing",
  icons = {
    {
      icon = "__FluxWorksAssets__/graphics/icons/fluids/fw-blasting-gel.png",
      icon_size = 64,
      icon_mipmaps = 4,
    },
    {
      icon = "__base__/graphics/icons/fluid/light-oil.png",
      icon_size = 64,
      scale = 0.45,
      shift = { 9, 9 },
    },
  },
  category = "chemistry",
  subgroup = "fw-chemistry-processes",
  order = "e[base-chemistry]-j2[gelled-napalm-mixing]",
  enabled = false,
  energy_required = 8.0,
  allow_productivity = false,
  localised_name = { "", { "recipe-name.fw-napalm" }, " Gel Mixing" },
  localised_description = { "", "A hotter, denser napalm blend that trades extra Flux conditioning for a much fatter fluid batch." },
  ingredients = {
    { type = "fluid", name = "fw-blasting-gel", amount = 30 },
    { type = "fluid", name = "light-oil", amount = 20 },
    { type = "item", name = "sulfur", amount = 1 },
    { type = "item", name = "fw-carbon", amount = 1 },
    { type = "fluid", name = "fw-red-flux", amount = 12 },
  },
  results = {
    { type = "fluid", name = "fw-napalm", amount = 70 },
  },
  main_product = "fw-napalm",
}, {
  { "fluid", "fw-blasting-gel" },
  { "fluid", "light-oil" },
  { "item", "sulfur" },
  { "item", "fw-carbon" },
  { "fluid", "fw-red-flux" },
})

add_recipe_if_valid(recipes, {
  type = "recipe",
  name = "fw-green-flux-compost-bloom",
  icon = "__space-age__/graphics/icons/bioflux.png",
  icon_size = 64,
  category = bio_category,
  subgroup = "fw-bioprocessing-processes",
  order = "f[green-flux]-a2[compost-bloom]",
  enabled = false,
  energy_required = 7.0,
  allow_productivity = false,
  localised_name = { "", { "recipe-name.fw-green-flux-bioflux-cultivation" }, " Compost Bloom" },
  localised_description = { "", "A spoilage-heavy recovery loop that climbs back to bioflux instead of stopping at basic nutrients." },
  ingredients = {
    { type = "item", name = "spoilage", amount = 12 },
    { type = "item", name = "nutrients", amount = 12 },
    { type = "fluid", name = "fw-green-flux", amount = 24 },
  },
  results = {
    { type = "item", name = "bioflux", amount = 1 },
    { type = "item", name = "nutrients", amount = 8 },
  },
  main_product = "bioflux",
}, {
  { "item", "spoilage" },
  { "item", "nutrients" },
  { "item", "bioflux" },
  { "fluid", "fw-green-flux" },
})

add_recipe_if_valid(recipes, {
  type = "recipe",
  name = "fw-green-flux-biolubricant-bloom",
  icon = "__space-age__/graphics/icons/fluid/biolubricant.png",
  icon_size = 64,
  category = bio_category,
  subgroup = "fw-bioprocessing-processes",
  order = "f[green-flux]-c2[biolubricant-bloom]",
  enabled = false,
  energy_required = 8.0,
  allow_productivity = false,
  localised_name = { "", { "recipe-name.fw-green-flux-biolubricant-culture" }, " Bloom" },
  localised_description = { "", "Pushes the Green Flux line toward bulk lubricant output instead of another invisible research multiplier." },
  ingredients = {
    { type = "item", name = "bioflux", amount = 2 },
    { type = "item", name = "nutrients", amount = 12 },
    { type = "fluid", name = "fw-green-flux", amount = 18 },
  },
  results = {
    { type = "fluid", name = "biolubricant", amount = 40 },
  },
  main_product = "biolubricant",
}, {
  { "item", "bioflux" },
  { "item", "nutrients" },
  { "fluid", "biolubricant" },
  { "fluid", "fw-green-flux" },
})

local aquaculture_bloom_recipe = {
  type = "recipe",
  name = "fw-green-flux-aquaculture-bloom",
  category = bio_category,
  subgroup = "fw-bioprocessing-processes",
  order = "f[green-flux]-d2[aquaculture-bloom]",
  enabled = false,
  energy_required = 7.5,
  allow_productivity = false,
  localised_name = { "", { "recipe-name.fw-green-flux-aquaculture-feed" }, " Bloom" },
  localised_description = { "", "Turns Green Flux aquaculture into an actual breeding surge rather than a flat recipe productivity buff." },
  ingredients = {
    { type = "item", name = "raw-fish", amount = 1 },
    { type = "item", name = "bioflux", amount = 1 },
    { type = "item", name = "nutrients", amount = 12 },
    { type = "fluid", name = "fw-green-flux", amount = 18 },
  },
  results = {
    { type = "item", name = "raw-fish", amount = 3 },
  },
  main_product = "raw-fish",
}

if item_exists("raw-fish") then
  assign_icon_fields(aquaculture_bloom_recipe, data.raw.item["raw-fish"])
end

add_recipe_if_valid(recipes, aquaculture_bloom_recipe, {
  { "item", "raw-fish" },
  { "item", "bioflux" },
  { "item", "nutrients" },
  { "fluid", "fw-green-flux" },
})

local function add_seedbank_recipe(seed_name, order_suffix)
  local recipe = {
    type = "recipe",
    name = "fw-green-flux-" .. seed_name .. "-seedbanking",
    category = bio_category,
    subgroup = "fw-bioprocessing-processes",
    order = "f[green-flux]-" .. order_suffix .. "[" .. seed_name .. "-seedbanking]",
    enabled = false,
    energy_required = 8.5,
    allow_productivity = false,
    localised_name = { "", { "item-name." .. seed_name }, " Seedbanking" },
    localised_description = { "", "Builds a managed seed reserve with bioflux support instead of leaning on an infinite propagation bonus." },
    ingredients = {
      { type = "item", name = seed_name, amount = 1 },
      { type = "item", name = "bioflux", amount = 1 },
      { type = "item", name = "nutrients", amount = 10 },
      { type = "fluid", name = "fw-green-flux", amount = 14 },
    },
    results = {
      { type = "item", name = seed_name, amount = 3 },
    },
    main_product = seed_name,
  }

  assign_icon_fields(recipe, data.raw.item[seed_name])

  add_recipe_if_valid(recipes, recipe, {
    { "item", seed_name },
    { "item", "bioflux" },
    { "item", "nutrients" },
    { "fluid", "fw-green-flux" },
  })
end

if item_exists("yumako-seed") then
  add_seedbank_recipe("yumako-seed", "e2")
end

if item_exists("jellynut-seed") then
  add_seedbank_recipe("jellynut-seed", "f2")
end

if item_exists("tree-seed") then
  add_seedbank_recipe("tree-seed", "g2")
end

add_recipe_if_valid(recipes, {
  type = "recipe",
  name = "fw-spectral-coolant-recycling",
  icon = "__space-age__/graphics/icons/fluid/fluoroketone-cold.png",
  icon_size = 64,
  category = "fw-flux-synthesis",
  subgroup = "fw-chemistry-processes",
  order = "c[synthesis]-c2[spectral-coolant-recycling]",
  enabled = false,
  energy_required = 8.5,
  allow_productivity = false,
  localised_name = { "", { "recipe-name.fw-spectral-coolant-blend" }, " Recycling" },
  localised_description = { "", "A closed-loop coolant pass that leans on cryogel recovery instead of infinite cryochemistry productivity." },
  ingredients = {
    { type = "item", name = "ice", amount = 4 },
    { type = "item", name = "fw-aquilo-cryogel", amount = 1 },
    { type = "fluid", name = "fluoroketone-hot", amount = 40, temperature = 180 },
    { type = "fluid", name = "fw-purple-flux", amount = 8 },
    { type = "fluid", name = "fw-yellow-flux", amount = 12 },
    { type = "fluid", name = "fw-green-flux", amount = 8 },
  },
  results = {
    { type = "fluid", name = "fluoroketone-cold", amount = 80, temperature = -150 },
    { type = "item", name = "fw-aquilo-cryogel", amount = 1, probability = 0.5 },
  },
  main_product = "fluoroketone-cold",
}, {
  { "item", "ice" },
  { "item", "fw-aquilo-cryogel" },
  { "fluid", "fluoroketone-hot" },
  { "fluid", "fw-purple-flux" },
  { "fluid", "fw-yellow-flux" },
  { "fluid", "fw-green-flux" },
})

add_recipe_if_valid(recipes, {
  type = "recipe",
  name = "fw-aquilo-cryogel-annealing",
  icons = data.raw.item["fw-aquilo-cryogel"].icons,
  category = "chemistry",
  subgroup = "fw-chemistry-processes",
  order = "f[late-chemistry]-d2[aquilo-cryogel-annealing]",
  enabled = false,
  energy_required = 11.0,
  allow_productivity = false,
  localised_name = { "", { "recipe-name.fw-aquilo-cryogel" }, " Annealing" },
  localised_description = { "", "Uses a colder, better-controlled pass that can preserve part of the thermal hardware in the loop." },
  ingredients = {
    { type = "item", name = "fw-salt", amount = 2 },
    { type = "item", name = "lithium", amount = 2 },
    { type = "item", name = "ice", amount = 8 },
    { type = "item", name = "fw-thermal-buffer", amount = 1 },
    { type = "fluid", name = "fluoroketone-cold", amount = 40, temperature = -150 },
    { type = "fluid", name = "fw-yellow-flux", amount = 18 },
    { type = "fluid", name = "fw-green-flux", amount = 12 },
  },
  results = {
    { type = "item", name = "fw-aquilo-cryogel", amount = 3 },
    { type = "item", name = "fw-thermal-buffer", amount = 1, probability = 0.5 },
  },
  main_product = "fw-aquilo-cryogel",
}, {
  { "item", "fw-salt" },
  { "item", "lithium" },
  { "item", "ice" },
  { "item", "fw-thermal-buffer" },
  { "fluid", "fluoroketone-cold" },
  { "fluid", "fw-yellow-flux" },
  { "fluid", "fw-green-flux" },
})

add_recipe_if_valid(recipes, {
  type = "recipe",
  name = "fw-flux-resonance-cell-calibration",
  icon = "__FluxWorksAssets__/graphics/icons/items/flux-2-light.png",
  icon_size = 64,
  category = "fw-flux-synthesis",
  subgroup = "fw-flux-systems",
  order = "b[systems]-f2[flux-resonance-cell-calibration]",
  enabled = false,
  energy_required = 11.5,
  allow_productivity = false,
  localised_name = { "", { "recipe-name.fw-flux-resonance-cell" }, " Calibration" },
  localised_description = { "", "A tuned assembly pass that prioritizes catalyst retention over brute-force productivity stacking." },
  ingredients = {
    { type = "item", name = "fw-stabilized-flux-crystal", amount = 2 },
    { type = "item", name = "fw-resonance-substrate", amount = 1 },
    { type = "item", name = "fw-condensed-flux-matrix", amount = 2 },
    { type = "item", name = "fw-flux-catalyst", amount = 1 },
    { type = "item", name = "fw-aquilo-cryogel", amount = 1 },
    { type = "fluid", name = "fw-yellow-flux", amount = 30 },
    { type = "fluid", name = "fw-red-flux", amount = 60 },
    { type = "fluid", name = "fw-green-flux", amount = 12 },
  },
  results = {
    { type = "item", name = "fw-flux-resonance-cell", amount = 1 },
    { type = "item", name = "fw-flux-catalyst", amount = 1 },
  },
  main_product = "fw-flux-resonance-cell",
}, {
  { "item", "fw-stabilized-flux-crystal" },
  { "item", "fw-resonance-substrate" },
  { "item", "fw-condensed-flux-matrix" },
  { "item", "fw-flux-catalyst" },
  { "item", "fw-aquilo-cryogel" },
  { "fluid", "fw-yellow-flux" },
  { "fluid", "fw-red-flux" },
  { "fluid", "fw-green-flux" },
})

add_recipe_if_valid(recipes, {
  type = "recipe",
  name = "fw-flux-phase-manifold-calibration",
  icon = "__FluxWorksAssets__/graphics/icons/items/fw-circuit-substrate.png",
  icon_size = 1024,
  category = "fw-flux-synthesis",
  subgroup = "fw-flux-systems",
  order = "b[systems]-g2[flux-phase-manifold-calibration]",
  enabled = false,
  energy_required = 15.5,
  allow_productivity = false,
  localised_name = { "", { "recipe-name.fw-flux-phase-manifold" }, " Calibration" },
  localised_description = { "", "A calmer high-end manifold build that pays you back in reliability instead of another infinite number." },
  ingredients = {
    { type = "item", name = "fw-flux-resonance-cell", amount = 2 },
    { type = "item", name = "fw-resonance-substrate", amount = 2 },
    { type = "item", name = "fw-condensed-flux-matrix", amount = 2 },
    { type = "item", name = "fw-flux-catalyst", amount = 1 },
    { type = "item", name = "fw-sensor-package", amount = 2 },
    { type = "item", name = "fw-aquilo-cryogel", amount = 1 },
    { type = "fluid", name = "fw-purple-flux", amount = 14 },
    { type = "fluid", name = "fw-yellow-flux", amount = 80 },
    { type = "fluid", name = "fw-red-flux", amount = 160 },
    { type = "fluid", name = "fw-green-flux", amount = 20 },
  },
  results = {
    { type = "item", name = "fw-flux-phase-manifold", amount = 1 },
    { type = "item", name = "fw-flux-catalyst", amount = 1 },
  },
  main_product = "fw-flux-phase-manifold",
}, {
  { "item", "fw-flux-resonance-cell" },
  { "item", "fw-resonance-substrate" },
  { "item", "fw-condensed-flux-matrix" },
  { "item", "fw-flux-catalyst" },
  { "item", "fw-sensor-package" },
  { "item", "fw-aquilo-cryogel" },
  { "fluid", "fw-purple-flux" },
  { "fluid", "fw-yellow-flux" },
  { "fluid", "fw-red-flux" },
  { "fluid", "fw-green-flux" },
})

add_recipe_if_valid(recipes, {
  type = "recipe",
  name = "fw-flux-asteroid-core-sorting",
  icon = "__FluxWorksAssets__/graphics/icons/items/flux-3.png",
  icon_size = 64,
  category = "fw-flux-synthesis",
  subgroup = "fw-flux-systems",
  order = "c[refinement]-a2[asteroid-core-sorting]",
  enabled = false,
  energy_required = 9.5,
  allow_productivity = false,
  localised_name = { "", { "recipe-name.fw-flux-asteroid-deep-refining" }, " Core Sorting" },
  localised_description = { "", "Sorts asteroid cores for cleaner catalyst retention and steadier crystal recovery rather than another passive multiplier." },
  ingredients = {
    { type = "item", name = "fw-flux-asteroid-chunk", amount = 2 },
    { type = "item", name = "fw-flux-catalyst", amount = 1 },
    { type = "item", name = "fw-flux-lattice", amount = 1 },
    { type = "fluid", name = "fw-purple-flux", amount = 16 },
    { type = "fluid", name = "fw-yellow-flux", amount = 18 },
    { type = "fluid", name = "fw-red-flux", amount = 30 },
  },
  results = {
    { type = "item", name = "fw-condensed-flux-matrix", amount = 1 },
    { type = "item", name = "fw-stabilized-flux-crystal", amount = 2 },
    { type = "item", name = "fw-flux-catalyst", amount = 1 },
  },
  main_product = "fw-condensed-flux-matrix",
}, {
  { "item", "fw-flux-asteroid-chunk" },
  { "item", "fw-flux-catalyst" },
  { "item", "fw-flux-lattice" },
  { "fluid", "fw-purple-flux" },
  { "fluid", "fw-yellow-flux" },
  { "fluid", "fw-red-flux" },
})

data:extend(recipes)
