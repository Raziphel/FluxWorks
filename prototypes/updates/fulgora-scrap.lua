local Startup = require("prototypes.lib.startup-settings")

if not Startup.enabled("fw-enable-recipe-integration", true) then
  return
end

local scrap_recycling = data.raw.recipe and data.raw.recipe["scrap-recycling"]
if not scrap_recycling then
  return
end

local fluxworks_scrap_results = {
  { type = "item", name = "iron-gear-wheel", amount = 1, probability = 0.16, show_details_in_recipe_tooltip = false },
  { type = "item", name = "solid-fuel", amount = 1, probability = 0.05, show_details_in_recipe_tooltip = false },
  { type = "item", name = "concrete", amount = 1, probability = 0.04, show_details_in_recipe_tooltip = false },
  { type = "item", name = "ice", amount = 1, probability = 0.03, show_details_in_recipe_tooltip = false },
  { type = "item", name = "steel-plate", amount = 1, probability = 0.03, show_details_in_recipe_tooltip = false },
  { type = "item", name = "battery", amount = 1, probability = 0.03, show_details_in_recipe_tooltip = false },
  { type = "item", name = "advanced-circuit", amount = 1, probability = 0.02, show_details_in_recipe_tooltip = false },
  { type = "item", name = "processing-unit", amount = 1, probability = 0.01, show_details_in_recipe_tooltip = false },
  { type = "item", name = "low-density-structure", amount = 1, probability = 0.01, show_details_in_recipe_tooltip = false },
  { type = "item", name = "holmium-ore", amount = 1, probability = 0.02, show_details_in_recipe_tooltip = false },
  { type = "item", name = "copper-cable", amount = 1, probability = 0.03, show_details_in_recipe_tooltip = false },
  { type = "item", name = "bauxite-ore", amount = 1, probability = 0.05, show_details_in_recipe_tooltip = false },
  { type = "item", name = "silicon-ore", amount = 1, probability = 0.05, show_details_in_recipe_tooltip = false },
  { type = "item", name = "tin-ore", amount = 1, probability = 0.04, show_details_in_recipe_tooltip = false },
  { type = "item", name = "lead-ore", amount = 1, probability = 0.04, show_details_in_recipe_tooltip = false },
  { type = "item", name = "titanium-ore", amount = 1, probability = 0.01, show_details_in_recipe_tooltip = false },
  { type = "item", name = "aluminum-plate", amount = 1, probability = 0.04, show_details_in_recipe_tooltip = false },
  { type = "item", name = "silicon", amount = 1, probability = 0.04, show_details_in_recipe_tooltip = false },
  { type = "item", name = "tin-plate", amount = 1, probability = 0.03, show_details_in_recipe_tooltip = false },
  { type = "item", name = "lead-plate", amount = 1, probability = 0.03, show_details_in_recipe_tooltip = false },
  { type = "item", name = "fw-solder-alloy", amount = 1, probability = 0.025, show_details_in_recipe_tooltip = false },
  { type = "item", name = "fw-bearing", amount = 1, probability = 0.02, show_details_in_recipe_tooltip = false },
  { type = "item", name = "fw-ceramic-insulator", amount = 1, probability = 0.025, show_details_in_recipe_tooltip = false },
  { type = "item", name = "fw-capacitor", amount = 1, probability = 0.018, show_details_in_recipe_tooltip = false },
  { type = "item", name = "fw-light-frame", amount = 1, probability = 0.012, show_details_in_recipe_tooltip = false },
  { type = "item", name = "fw-sensor-package", amount = 1, probability = 0.008, show_details_in_recipe_tooltip = false },
  { type = "item", name = "fw-transformer-core", amount = 1, probability = 0.006, show_details_in_recipe_tooltip = false },
}

scrap_recycling.results = table.deepcopy(fluxworks_scrap_results)
if scrap_recycling.normal then
  scrap_recycling.normal.results = table.deepcopy(fluxworks_scrap_results)
end
if scrap_recycling.expensive then
  scrap_recycling.expensive.results = table.deepcopy(fluxworks_scrap_results)
end
