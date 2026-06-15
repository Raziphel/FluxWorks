local Spectrum = require("prototypes.lib.flux-spectrum")

local recipes = {}
local unlocks = {}

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
  if not item or item.hidden or not Spectrum.fluid_exists("fw-yellow-flux") then
    return
  end

  local recipe = {
    type = "recipe",
    name = recipe_name,
    category = "chemistry",
    subgroup = "fw-flux-fluids",
    order = "a[flux-fluids]-b" .. order_suffix .. "[" .. source_name .. "-to-fw-yellow-flux]",
    enabled = false,
    energy_required = math.max(2, source_amount * 0.6),
    allow_productivity = false,
    ingredients = {
      { type = "item", name = source_name, amount = source_amount },
    },
    results = {
      { type = "fluid", name = "fw-yellow-flux", amount = flux_amount },
    },
    main_product = "fw-yellow-flux",
    localised_name = { "", { "item-name." .. source_name }, " -> ", { "fluid-name.fw-yellow-flux" } },
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

if Spectrum.item_exists("plastic-bar") and Spectrum.item_exists("sulfur") and Spectrum.fluid_exists("fw-yellow-flux") then
  add_recipe({
    type = "recipe",
    name = "fw-yellow-flux-conditioning",
    category = "chemistry",
    subgroup = "fw-flux-fluids",
    order = "a[flux-fluids]-b0[yellow-flux-conditioning]",
    enabled = false,
    energy_required = 3,
    allow_productivity = false,
    ingredients = {
      { type = "item", name = "plastic-bar", amount = 3 },
      { type = "item", name = "sulfur", amount = 2 },
    },
    results = {
      { type = "fluid", name = "fw-yellow-flux", amount = 24 },
    },
    main_product = "fw-yellow-flux",
  }, "fw-flux-field-theory")
end

add_item_source_recipe("fw-yellow-flux-from-sulfur", "sulfur", 4, 20, "1", "fw-flux-field-theory")
add_item_source_recipe("fw-yellow-flux-from-plastic-bar", "plastic-bar", 4, 24, "2", "fw-flux-field-theory")
add_item_source_recipe("fw-yellow-flux-from-battery", "battery", 3, 24, "3", "fw-flux-field-theory")
add_item_source_recipe("fw-yellow-flux-from-explosives", "explosives", 3, 24, "4", "fw-flux-field-theory")
add_item_source_recipe("fw-yellow-flux-from-fw-resin", "fw-resin", 3, 20, "5", "fw-flux-field-theory")
add_item_source_recipe("fw-yellow-flux-from-fw-rubber-sheet", "fw-rubber-sheet", 4, 20, "6", "fw-flux-field-theory")

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
