local Spectrum = require("prototypes.lib.flux-spectrum")

local recipes = {}
local unlocks = {}
local bio_category = Spectrum.bio_category()

local function add_recipe(recipe, technology_name)
  table.insert(recipes, recipe)
  Spectrum.add_unlock(unlocks, technology_name, recipe.name)
end

local function item_icon(item)
  if item.icons then
    return { icons = table.deepcopy(item.icons) }
  end
  if item.icon then
    return {
      icon = item.icon,
      icon_size = item.icon_size or 64,
      icon_mipmaps = item.icon_mipmaps,
    }
  end
  return nil
end

local function add_item_source_recipe(recipe_name, source_name, source_amount, flux_amount, order_suffix, technology_name)
  local item = data.raw.item[source_name]
  if not item or item.hidden or not Spectrum.fluid_exists("fw-green-flux") then
    return
  end

  local recipe = {
    type = "recipe",
    name = recipe_name,
    category = bio_category,
    subgroup = "fw-flux-fluids",
    order = "a[flux-fluids]-d" .. order_suffix .. "[" .. source_name .. "-to-fw-green-flux]",
    enabled = false,
    energy_required = math.max(2, source_amount * 0.6),
    allow_productivity = false,
    ingredients = {
      { type = "item", name = source_name, amount = source_amount },
    },
    results = {
      { type = "fluid", name = "fw-green-flux", amount = flux_amount },
    },
    main_product = "fw-green-flux",
    localised_name = { "", { "item-name." .. source_name }, " -> ", { "fluid-name.fw-green-flux" } },
  }

  local icon = item_icon(item)
  if icon then
    recipe.icons = icon.icons
    recipe.icon = icon.icon
    recipe.icon_size = icon.icon_size
    recipe.icon_mipmaps = icon.icon_mipmaps
  end

  add_recipe(recipe, technology_name)
end

if Spectrum.item_exists("spoilage") and Spectrum.item_exists("nutrients") and Spectrum.fluid_exists("fw-green-flux") then
  add_recipe({
    type = "recipe",
    name = "fw-green-flux-conditioning",
    category = bio_category,
    subgroup = "fw-flux-fluids",
    order = "a[flux-fluids]-d0[green-flux-conditioning]",
    enabled = false,
    energy_required = 3,
    allow_productivity = false,
    ingredients = {
      { type = "item", name = "spoilage", amount = 6 },
      { type = "item", name = "nutrients", amount = 6 },
    },
    results = {
      { type = "fluid", name = "fw-green-flux", amount = 24 },
    },
    main_product = "fw-green-flux",
  }, "fw-flux-field-theory")
end

add_item_source_recipe("fw-green-flux-from-spoilage", "spoilage", 8, 20, "1", "fw-flux-field-theory")
add_item_source_recipe("fw-green-flux-from-nutrients", "nutrients", 8, 24, "2", "fw-flux-field-theory")
add_item_source_recipe("fw-green-flux-from-bioflux", "bioflux", 2, 28, "3", "fw-flux-synthesis")
add_item_source_recipe("fw-green-flux-from-raw-fish", "raw-fish", 2, 18, "4", "fw-flux-field-theory")
add_item_source_recipe("fw-green-flux-from-yumako-seed", "yumako-seed", 2, 22, "5", "fw-flux-synthesis")
add_item_source_recipe("fw-green-flux-from-jellynut-seed", "jellynut-seed", 2, 22, "6", "fw-flux-synthesis")
add_item_source_recipe("fw-green-flux-from-tree-seed", "tree-seed", 2, 18, "7", "fw-flux-synthesis")

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
