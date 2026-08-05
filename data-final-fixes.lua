local function load_modules(modules)
  for _, module_name in ipairs(modules) do
    require(module_name)
  end
end

-- Prototypes that depend on the complete base and compatibility prototype set.
load_modules({
  "prototypes.updates.resource-placement",
  "prototypes.updates.asteroid-crushing",
  "prototypes.updates.rocket-reusability-late",
  "prototypes.technology.domain-science",
  "prototypes.technology.progression-projects",
  "prototypes.technology.industrial-research-programs",
  "prototypes.recipes.red-flux-fuels",
  "prototypes.recipes.purple-flux-materials",
  "prototypes.recipes.yellow-flux-mechanics",
  "prototypes.recipes.red-flux-sources",
  "prototypes.recipes.red-flux-mechanics",
  "prototypes.recipes.green-flux-mechanics",
  "prototypes.technology.mastery-research",
  "prototypes.technology.progression-programs",
  "prototypes.updates.factoriopedia",
})

-- Cross-mod recipe and technology integration. Ordering is intentional: broad
-- recipe changes land before presentation and final progression reconciliation.
load_modules({
  "prototypes.updates.chemistry-integration",
  "prototypes.updates.recipe-tweaks",
  -- Capability-driven external integration must land before Flux valuation so
  -- every generated recovery recipe prices the final bill of materials.
  "prototypes.compat.global-recipe-integration",
  "prototypes.updates.difficulty-overrides",
  "prototypes.updates.research-difficulty",
  "prototypes.updates.technology-weave",
  "prototypes.updates.domain-science-integration",
  "prototypes.updates.progression-compression",
  "prototypes.updates.crafting-tabs",
  "prototypes.updates.flux-composition-doctrine",
  "prototypes.updates.recipe-icons",
  "prototypes.updates.visual-identity",
  "prototypes.updates.recipe-decomposition",
  "prototypes.updates.ore-icons",
  "prototypes.compat.aai-suite",
})

-- Reapply the integration after broad recipe edits have landed.
require("prototypes.updates.aai-industry")()
require("prototypes.updates.dual-pipe-networks")

-- Platform handling is a player-selected balance rule, so land it after every
-- dependency has had a chance to adjust the shared acceleration expression.
require("prototypes.updates.space-platform-drag").apply()
require("prototypes.updates.player-tuning").apply()

-- These checks operate on the completed cross-mod recipes. They deliberately
-- follow AAI's substitutions, which can replace an entire ingredient list.
require("prototypes.updates.recipe_tweaks.ingredient_boundaries")()

-- Exact API promises land after broad rewrites and before recovery valuation.
require("prototypes.compat.api-finalization")
require("prototypes.recipes.flux-condensing")
require("prototypes.updates.progression-reconciliation")
require("prototypes.updates.playtest-report-reconciliation")
require("prototypes.updates.skip-burner-stage")
require("prototypes.updates.item-recipe-cleanup")
require("prototypes.updates.flux-tooltips")
require("prototypes.updates.remove-obsolete-beneficiation")
require("prototypes.updates.owned-iconography")

-- Factorio 2.1 replaced singular recipe categories and product probability
-- fields. Normalize after every compatibility rewrite and before validation.
require("__razi_lib__/lib/recipe").normalize_all_2_1()

require("prototypes.validation.init")

-- FluxWorks owns its menu playlist now that authored stage saves are available.
local utility_constants = data.raw["utility-constants"] and data.raw["utility-constants"].default
if utility_constants then
  utility_constants.main_menu_simulations = require("prototypes.menu-simulations")
  local menu_branding = require("prototypes.updates.menu-branding")
  menu_branding.apply(utility_constants.main_menu_simulations)
end
