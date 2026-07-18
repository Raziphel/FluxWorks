local Spectrum = require("prototypes.lib.flux-spectrum")
local RecipeIcons = require("prototypes.lib.flux-recipe-icons")

local recipes = {}
local unlocks = {}
local bio_category = Spectrum.bio_category()

local function add_recipe(recipe, technology_name)
  table.insert(recipes, recipe)
  Spectrum.add_unlock(unlocks, technology_name, recipe.name)
end

local function add_item_source_recipe(recipe_name, source_name, source_amount, flux_amount, order_suffix, technology_name)
  if not (
    Spectrum.item_exists(source_name)
    and Spectrum.fluid_exists("fw-green-flux")
  ) then
    return
  end

  local recipe = {
    type = "recipe",
    name = recipe_name,
    enabled = false,
    localised_name = { "", { "fluid-name.fw-green-flux" }, " <- ", { "item-name." .. source_name } },
    category = bio_category,
    subgroup = "fw-flux-green",
    order = "a[source]-" .. order_suffix .. "[" .. source_name .. "]",
    energy_required = 4,
    allow_productivity = false,
    ingredients = {
      { type = "item", name = source_name, amount = source_amount },
      { type = "fluid", name = "water", amount = 10 },
    },
    results = {
      { type = "fluid", name = "fw-green-flux", amount = flux_amount },
    },
    main_product = "fw-green-flux",
  }

  local icons = RecipeIcons.source_to_flux_icons(source_name, "fw-green-flux")
  if icons then
    for key, value in pairs(icons) do
      recipe[key] = value
    end
  end

  add_recipe(recipe, technology_name)
end

add_item_source_recipe("fw-green-flux-from-spoilage", "spoilage", 8, 20, "1", "fw-flux-green-reclamation")
add_item_source_recipe("fw-green-flux-from-nutrients", "nutrients", 8, 24, "2", "fw-flux-green-reclamation")
add_item_source_recipe("fw-green-flux-from-bioflux", "bioflux", 2, 28, "3", "fw-flux-synthesis")
add_item_source_recipe("fw-green-flux-from-raw-fish", "raw-fish", 2, 18, "4", "fw-flux-green-reclamation")
add_item_source_recipe("fw-green-flux-from-yumako-seed", "yumako-seed", 2, 22, "5", "fw-flux-synthesis")
add_item_source_recipe("fw-green-flux-from-jellynut-seed", "jellynut-seed", 2, 22, "6", "fw-flux-synthesis")
add_item_source_recipe("fw-green-flux-from-tree-seed", "tree-seed", 2, 18, "7", "fw-flux-synthesis")

add_recipe({
  type = "recipe", name = "fw-green-nutrient-reclamation", enabled = false,
  category = bio_category, subgroup = "fw-flux-green", order = "b[regeneration]-a[nutrients]",
  energy_required = 4, allow_productivity = true,
  ingredients = {
    { type = "item", name = "spoilage", amount = 12 },
    { type = "fluid", name = "water", amount = 20 },
    { type = "fluid", name = "fw-green-flux", amount = 8 },
  },
  results = { { type = "item", name = "nutrients", amount = 18 } },
  main_product = "nutrients",
}, "fw-flux-green-reclamation")

add_recipe({
  type = "recipe", name = "fw-green-bioflux-propagation", enabled = false,
  category = bio_category, subgroup = "fw-flux-green", order = "b[regeneration]-b[bioflux]",
  energy_required = 8, allow_productivity = false,
  ingredients = {
    { type = "item", name = "bioflux", amount = 2 },
    { type = "fluid", name = "water", amount = 30 },
    { type = "fluid", name = "fw-green-flux", amount = 16 },
  },
  results = { { type = "item", name = "bioflux", amount = 3 } },
  main_product = "bioflux",
}, "fw-flux-green-cultivation")

add_recipe({
  type = "recipe", name = "fw-green-seedbank-propagation", enabled = false,
  icon = "__space-age__/graphics/icons/yumako-seed.png",
  category = bio_category, subgroup = "fw-flux-green", order = "b[regeneration]-c[seedbank]",
  energy_required = 10, allow_productivity = false,
  ingredients = {
    { type = "item", name = "yumako-seed", amount = 1 },
    { type = "item", name = "jellynut-seed", amount = 1 },
    { type = "fluid", name = "fw-green-flux", amount = 18 },
  },
  results = {
    { type = "item", name = "yumako-seed", amount = 2 },
    { type = "item", name = "jellynut-seed", amount = 2 },
  },
}, "fw-flux-green-propagation")

Spectrum.publish(recipes, unlocks)
