local recipe_icons = require("prototypes.lib.flux-recipe-icons")

local BOTTOM_LEFT = { -9, 8 }
local TOP_RIGHT = { 9, -9 }
local BOTTOM_RIGHT = { 9, 8 }

local function set_recipe_icon(recipe_name, icon_data)
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if not (recipe and icon_data) then
    return
  end

  recipe.icon = nil
  recipe.icon_size = nil
  recipe.icon_mipmaps = nil
  recipe.icons = icon_data.icons or { icon_data }
end

local function smelting_icon(result_item, source_item)
  return recipe_icons.product_item_icons(result_item, {
    recipe_icons.item_overlay(source_item, 0.42, BOTTOM_LEFT),
    recipe_icons.item_overlay("stone-furnace", 0.34, BOTTOM_RIGHT),
  })
end

local function crusher_icon(result_item, source_item)
  return recipe_icons.product_item_icons(result_item, {
    recipe_icons.item_overlay(source_item, 0.42, BOTTOM_LEFT),
    recipe_icons.item_overlay("crusher", 0.34, BOTTOM_RIGHT),
  })
end

local function chemistry_item_icon(result_item, source_item, fluid_name)
  return recipe_icons.product_item_icons(result_item, {
    recipe_icons.item_overlay(source_item, 0.42, BOTTOM_LEFT),
    recipe_icons.fluid_overlay(fluid_name, 0.40, TOP_RIGHT),
  })
end

local function chemistry_fluid_icon(result_fluid, source_item, fluid_name)
  return recipe_icons.product_fluid_icons(result_fluid, {
    recipe_icons.item_overlay(source_item, 0.42, BOTTOM_LEFT),
    recipe_icons.fluid_overlay(fluid_name, 0.40, TOP_RIGHT),
  })
end

local function harvester_icon(result_item, source_item, flux_name)
  return recipe_icons.product_item_icons(result_item, {
    recipe_icons.item_overlay(source_item, 0.42, BOTTOM_LEFT),
    recipe_icons.fluid_overlay(flux_name or "fw-purple-flux", 0.40, TOP_RIGHT),
    recipe_icons.item_overlay("fw-flux-harvester", 0.30, BOTTOM_RIGHT),
  }, 0.90)
end

local function harvester_fluid_icon(result_fluid, source_item, flux_name)
  return recipe_icons.product_fluid_icons(result_fluid, {
    recipe_icons.item_overlay(source_item, 0.42, BOTTOM_LEFT),
    recipe_icons.fluid_overlay(flux_name or "fw-purple-flux", 0.40, TOP_RIGHT),
    recipe_icons.item_overlay("fw-flux-harvester", 0.30, BOTTOM_RIGHT),
  }, 0.90)
end

local function synthesis_icon(result_item, source_item, flux_name)
  return recipe_icons.product_item_icons(result_item, {
    recipe_icons.item_overlay(source_item, 0.42, BOTTOM_LEFT),
    recipe_icons.fluid_overlay(flux_name or "fw-purple-flux", 0.40, TOP_RIGHT),
    recipe_icons.item_overlay("fw-synthesis-plant", 0.30, BOTTOM_RIGHT),
  }, 0.90)
end

local function foundry_icon(result_item, source_item, flux_name)
  return recipe_icons.product_item_icons(result_item, {
    recipe_icons.item_overlay(source_item, 0.42, BOTTOM_LEFT),
    recipe_icons.fluid_overlay(flux_name or "fw-red-flux", 0.40, TOP_RIGHT),
    recipe_icons.item_overlay("fw-arc-foundry", 0.30, BOTTOM_RIGHT),
  }, 0.90)
end

set_recipe_icon("lead-plate", smelting_icon("lead-plate", "lead-ore"))
set_recipe_icon("lead-plate-from-crushed", smelting_icon("lead-plate", "fw-crushed-lead-ore"))
set_recipe_icon("titanium-plate", smelting_icon("titanium-plate", "titanium-ore"))
set_recipe_icon("titanium-plate-from-crushed", smelting_icon("titanium-plate", "fw-crushed-titanium-ore"))
set_recipe_icon("aluminum-plate", smelting_icon("aluminum-plate", "bauxite-ore"))
set_recipe_icon("tin-plate", smelting_icon("tin-plate", "tin-ore"))
set_recipe_icon("silicon", smelting_icon("silicon", "silicon-ore"))
set_recipe_icon("fw-carbon-refining", smelting_icon("fw-carbon", "coal"))
set_recipe_icon("fw-glass", smelting_icon("fw-glass", "fw-sand"))

set_recipe_icon("fw-crushed-lead-ore", crusher_icon("fw-crushed-lead-ore", "lead-ore"))
set_recipe_icon("fw-crushed-titanium-ore", crusher_icon("fw-crushed-titanium-ore", "titanium-ore"))
set_recipe_icon("fw-crushed-iron-ore", crusher_icon("fw-crushed-iron-ore", "iron-ore"))
set_recipe_icon("fw-crushed-copper-ore", crusher_icon("fw-crushed-copper-ore", "copper-ore"))
set_recipe_icon("fw-sand", crusher_icon("fw-sand", "stone"))
set_recipe_icon("fw-silicon-beneficiation", crusher_icon("silicon", "silicon-ore"))
set_recipe_icon("fw-carbon-washing", chemistry_item_icon("fw-carbon", "coal", "water"))

set_recipe_icon("fw-chlorine-pressurization", chemistry_fluid_icon("fw-chlorine", "fw-salt", "water"))
set_recipe_icon("fw-latex-polymerization", chemistry_fluid_icon("fw-latex", "plastic-bar", "water"))
set_recipe_icon("fw-resin-polymerization", chemistry_item_icon("fw-resin", "fw-carbon", "fw-latex"))
set_recipe_icon("fw-sulfur-bonding", chemistry_item_icon("sulfur", "fw-salt", "fw-chlorine"))
set_recipe_icon("fw-acid-synthesis", chemistry_fluid_icon("sulfuric-acid", "sulfur", "fw-chlorine"))
set_recipe_icon("fw-rubber-vulcanization", chemistry_item_icon("fw-rubber-sheet", "fw-resin", "fw-latex"))
set_recipe_icon("fw-blasting-gel", chemistry_fluid_icon("fw-blasting-gel", "explosives", "water"))
set_recipe_icon("fw-reactive-slurry", chemistry_item_icon("cliff-explosives", "explosives", "fw-blasting-gel"))
set_recipe_icon("fw-battery-electrolyte", chemistry_item_icon("battery", "lead-plate", "sulfuric-acid"))

set_recipe_icon("fw-salt-brine-clarification", harvester_fluid_icon("fw-chlorine", "fw-salt", "fw-yellow-flux"))
set_recipe_icon("fw-silica-beneficiation", harvester_icon("silicon", "silicon-ore", "fw-yellow-flux"))
set_recipe_icon("fw-carbonic-washing", harvester_icon("carbon", "coal", "fw-green-flux"))
set_recipe_icon("fw-bauxite-slurry-clarification", harvester_icon("bauxite-ore", "bauxite-ore", "fw-yellow-flux"))
set_recipe_icon("fw-tin-ore-beneficiation", harvester_icon("tin-ore", "tin-ore", "fw-yellow-flux"))
set_recipe_icon("fw-lead-ore-beneficiation", harvester_icon("fw-crushed-lead-ore", "lead-ore", "fw-yellow-flux"))
set_recipe_icon("fw-titanium-slurry-grading", harvester_icon("fw-crushed-titanium-ore", "titanium-ore", "fw-green-flux"))
set_recipe_icon("fw-carbon-grade-screening", harvester_icon("fw-carbon", "carbon", "fw-green-flux"))

set_recipe_icon("fw-harvester-head", harvester_icon("fw-harvester-head", "fw-pressure-housing", "fw-yellow-flux"))
set_recipe_icon("fw-flux-catalyst", synthesis_icon("fw-flux-catalyst", "fw-crystalised-flux", "fw-purple-flux"))
set_recipe_icon("fw-stabilized-flux-crystal", synthesis_icon("fw-stabilized-flux-crystal", "fw-crystalised-flux", "fw-purple-flux"))
set_recipe_icon("fw-flux-lattice", synthesis_icon("fw-flux-lattice", "fw-metal-mesh", "fw-yellow-flux"))
set_recipe_icon("fw-annealed-cermet", foundry_icon("fw-annealed-cermet", "fw-cermet", "fw-red-flux"))
set_recipe_icon("fw-resonance-substrate", synthesis_icon("fw-resonance-substrate", "fw-circuit-substrate", "fw-yellow-flux"))
set_recipe_icon("fw-condensed-flux-matrix", synthesis_icon("fw-condensed-flux-matrix", "fw-stabilized-flux-crystal", "fw-purple-flux"))
set_recipe_icon("fw-flux-resonance-cell", synthesis_icon("fw-flux-resonance-cell", "fw-condensed-flux-matrix", "fw-red-flux"))
set_recipe_icon("fw-flux-phase-manifold", synthesis_icon("fw-flux-phase-manifold", "fw-flux-resonance-cell", "fw-red-flux"))
set_recipe_icon("fw-rift-seed-crystallization", synthesis_icon("fw-crystalised-flux", "fw-flux-phase-manifold", "fw-purple-flux"))
set_recipe_icon("fw-flux-metallic-synthesis", synthesis_icon("uranium-ore", "fw-flux-phase-manifold", "fw-red-flux"))

for _, step in ipairs({
  { from = "coal", to = "copper-ore" },
  { from = "copper-ore", to = "iron-ore" },
  { from = "iron-ore", to = "lead-ore" },
  { from = "lead-ore", to = "tin-ore" },
  { from = "tin-ore", to = "bauxite-ore" },
  { from = "bauxite-ore", to = "silicon-ore" },
  { from = "silicon-ore", to = "titanium-ore" },
  { from = "titanium-ore", to = "uranium-ore" },
}) do
  set_recipe_icon(
    "fw-" .. string.gsub(step.from, "^fw%-", "") .. "-to-" .. string.gsub(step.to, "^fw%-", ""),
    harvester_icon(step.to, step.from, "fw-purple-flux")
  )
  set_recipe_icon(
    "fw-" .. string.gsub(step.to, "^fw%-", "") .. "-to-" .. string.gsub(step.from, "^fw%-", ""),
    harvester_icon(step.from, step.to, "fw-purple-flux")
  )
end
