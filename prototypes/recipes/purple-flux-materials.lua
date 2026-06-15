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

local material_sources = {
  { name = "stone", amount = 10, flux = 18, technology = "fw-liquid-mining" },
  { name = "stone-brick", amount = 8, flux = 20, technology = "fw-liquid-mining" },
  { name = "fw-sand", amount = 12, flux = 20, technology = "fw-liquid-mining" },
  { name = "iron-ore", amount = 10, flux = 24, technology = "fw-flux-catalysis" },
  { name = "copper-ore", amount = 10, flux = 24, technology = "fw-flux-catalysis" },
  { name = "lead-ore", amount = 8, flux = 24, technology = "fw-flux-catalysis" },
  { name = "tin-ore", amount = 8, flux = 24, technology = "fw-flux-catalysis" },
  { name = "bauxite-ore", amount = 8, flux = 26, technology = "fw-flux-catalysis" },
  { name = "silicon-ore", amount = 8, flux = 28, technology = "fw-flux-catalysis" },
  { name = "titanium-ore", amount = 6, flux = 30, technology = "fw-flux-field-theory" },
  { name = "iron-plate", amount = 8, flux = 20, technology = "fw-flux-catalysis" },
  { name = "copper-plate", amount = 8, flux = 20, technology = "fw-flux-catalysis" },
  { name = "lead-plate", amount = 6, flux = 20, technology = "fw-flux-catalysis" },
  { name = "tin-plate", amount = 6, flux = 20, technology = "fw-flux-catalysis" },
  { name = "glass", amount = 8, flux = 22, technology = "fw-flux-catalysis" },
}

for _, source in ipairs(material_sources) do
  local item = data.raw.item[source.name]
  if item and not item.hidden and Spectrum.fluid_exists("fw-purple-flux") then
    local recipe = {
      type = "recipe",
      name = "fw-purple-flux-from-material-" .. source.name,
      category = "chemistry",
      subgroup = "fw-flux-purple",
      order = "a[source]-b[" .. source.name .. "-to-fw-purple-flux]",
      enabled = false,
      allow_productivity = false,
      energy_required = math.max(1.5, source.amount * 0.4),
      ingredients = {
        { type = "item", name = source.name, amount = source.amount },
      },
      results = {
        { type = "fluid", name = "fw-purple-flux", amount = source.flux },
      },
      main_product = "fw-purple-flux",
      localised_name = { "", { "item-name." .. source.name }, " -> ", { "fluid-name.fw-purple-flux" } },
    }

    local icon = item_icon(item)
    if icon then
      recipe.icons = icon.icons
      recipe.icon = icon.icon
      recipe.icon_size = icon.icon_size
      recipe.icon_mipmaps = icon.icon_mipmaps
    end

    add_recipe(recipe, source.technology)
  end
end

Spectrum.publish(recipes, unlocks)
