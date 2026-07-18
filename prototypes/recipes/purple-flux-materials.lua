local Spectrum = require("prototypes.lib.flux-spectrum")
local RecipeIcons = require("prototypes.lib.flux-recipe-icons")

local recipes = {}
local unlocks = {}

local function add_material_downgrade(source_name, source_amount, flux_amount, order_suffix)
  if not Spectrum.item_exists(source_name) or not Spectrum.fluid_exists("fw-purple-flux") then
    return
  end

  local recipe_name = "fw-purple-flux-from-material-" .. string.gsub(source_name, "^fw%-", "")
  local recipe = {
    type = "recipe",
    name = recipe_name,
    enabled = false,
    localised_name = { "", { "fluid-name.fw-purple-flux" }, " <- ", { "item-name." .. source_name } },
    category = "fw-flux-harvesting",
    subgroup = "fw-flux-purple",
    order = "a[material-deconstruction]-" .. order_suffix .. "[" .. source_name .. "]",
    energy_required = 4.5,
    allow_productivity = false,
    ingredients = { { type = "item", name = source_name, amount = source_amount } },
    results = { { type = "fluid", name = "fw-purple-flux", amount = flux_amount } },
    main_product = "fw-purple-flux",
  }

  local icons = RecipeIcons.source_to_flux_icons(source_name, "fw-purple-flux")
  if icons then
    for key, value in pairs(icons) do
      recipe[key] = value
    end
  end

  recipes[#recipes + 1] = recipe
  Spectrum.add_unlock(unlocks, "fw-flux-purple-transmutation", recipe_name)
end

-- Purple is structure made fluid: increasingly engineered material returns more phase mass.
add_material_downgrade("iron-plate", 8, 14, "1")
add_material_downgrade("copper-plate", 8, 14, "2")
add_material_downgrade("steel-plate", 3, 20, "3")
add_material_downgrade("aluminum-plate", 4, 22, "4")
add_material_downgrade("titanium-plate", 3, 30, "5")
add_material_downgrade("fw-cermet", 3, 34, "6")
add_material_downgrade("fw-composite-panel", 2, 42, "7")

Spectrum.publish(recipes, unlocks)
