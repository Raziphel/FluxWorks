local Spectrum = require("prototypes.lib.flux-spectrum")
local RecipeIcons = require("prototypes.lib.flux-recipe-icons")

local recipes = {}
local unlocks = {}

local function add_recipe(recipe, technology_name)
  table.insert(recipes, recipe)
  Spectrum.add_unlock(unlocks, technology_name, recipe.name)
end

local function add_item_source_recipe(recipe_name, source_name, source_amount, flux_amount, order_suffix, technology_name)
  if not (
    Spectrum.item_exists(source_name)
    and Spectrum.fluid_exists("fw-yellow-flux")
  ) then
    return
  end

  local recipe = {
    type = "recipe",
    name = recipe_name,
    enabled = false,
    localised_name = { "", { "fluid-name.fw-yellow-flux" }, " <- ", { "item-name." .. source_name } },
    category = "chemistry",
    subgroup = "fw-flux-yellow",
    order = "a[source]-" .. order_suffix .. "[" .. source_name .. "]",
    energy_required = 3.5,
    allow_productivity = false,
    ingredients = {
      { type = "item", name = source_name, amount = source_amount },
      { type = "fluid", name = "water", amount = 10 },
    },
    results = {
      { type = "fluid", name = "fw-yellow-flux", amount = flux_amount },
    },
    main_product = "fw-yellow-flux",
  }

  local icons = RecipeIcons.source_to_flux_icons(source_name, "fw-yellow-flux")
  if icons then
    for key, value in pairs(icons) do
      recipe[key] = value
    end
  end

  add_recipe(recipe, technology_name)
end

add_item_source_recipe("fw-yellow-flux-from-sulfur", "sulfur", 4, 20, "1", "fw-flux-field-theory")
add_item_source_recipe("fw-yellow-flux-from-plastic-bar", "plastic-bar", 4, 24, "2", "fw-flux-field-theory")
add_item_source_recipe("fw-yellow-flux-from-battery", "battery", 3, 24, "3", "fw-flux-field-theory")
add_item_source_recipe("fw-yellow-flux-from-explosives", "explosives", 3, 24, "4", "fw-flux-field-theory")
add_item_source_recipe("fw-yellow-flux-from-fw-resin", "fw-resin", 3, 20, "5", "fw-flux-field-theory")
add_item_source_recipe("fw-yellow-flux-from-fw-rubber-sheet", "fw-rubber-sheet", 4, 20, "6", "fw-flux-field-theory")

Spectrum.publish(recipes, unlocks)
