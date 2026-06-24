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
    and Spectrum.fluid_exists("fw-red-flux")
  ) then
    return
  end

  local recipe = {
    type = "recipe",
    name = recipe_name,
    enabled = false,
    localised_name = { "", { "fluid-name.fw-red-flux" }, " <- ", { "item-name." .. source_name } },
    category = "chemistry",
    subgroup = "fw-flux-red",
    order = "a[source]-" .. order_suffix .. "[" .. source_name .. "]",
    energy_required = 4,
    allow_productivity = false,
    ingredients = {
      { type = "item", name = source_name, amount = source_amount },
      { type = "fluid", name = "light-oil", amount = 10 },
    },
    results = {
      { type = "fluid", name = "fw-red-flux", amount = flux_amount },
    },
    main_product = "fw-red-flux",
  }

  local icons = RecipeIcons.source_to_flux_icons(source_name, "fw-red-flux")
  if icons then
    for key, value in pairs(icons) do
      recipe[key] = value
    end
  end

  add_recipe(recipe, technology_name)
end

add_item_source_recipe("fw-red-flux-from-fw-carbon", "fw-carbon", 3, 16, "1", "fw-flux-red-energetics")
add_item_source_recipe("fw-red-flux-from-coal", "coal", 4, 18, "2", "fw-flux-red-energetics")
add_item_source_recipe("fw-red-flux-from-solid-fuel", "solid-fuel", 2, 28, "3", "fw-flux-red-energetics")
add_item_source_recipe("fw-red-flux-from-rocket-fuel", "rocket-fuel", 1, 48, "4", "fw-flux-thermal-networks")
add_item_source_recipe("fw-red-flux-from-nuclear-fuel", "nuclear-fuel", 1, 80, "5", "fw-flux-overdrive")

Spectrum.publish(recipes, unlocks)
