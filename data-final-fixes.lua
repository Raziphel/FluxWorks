local function load_modules(modules)
  for _, module_name in ipairs(modules) do
    require(module_name)
  end
end

-- Prototypes that depend on the complete base and compatibility prototype set.
load_modules({
  "prototypes.updates.resource-placement",
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
  "prototypes.updates.domain-science-integration",
  "prototypes.updates.progression-compression",
  "prototypes.updates.crafting-tabs",
  "prototypes.updates.flux-composition-doctrine",
  "prototypes.updates.recipe-icons",
  "prototypes.updates.visual-identity",
  "prototypes.updates.recipe-decomposition",
  "prototypes.updates.ore-icons",
})

require("prototypes.updates.dual-pipe-networks")

-- Cross-mod recipe checks operate on the completed recipe graph.
require("prototypes.updates.native-industry")
require("prototypes.updates.recipe_tweaks.ingredient_boundaries")()

-- Exact API promises land after broad rewrites and before recovery valuation.
require("prototypes.compat.api-finalization")
require("prototypes.recipes.flux-condensing")
require("prototypes.updates.progression-reconciliation")
require("prototypes.updates.playtest-report-reconciliation")
require("prototypes.updates.early-glass-progression")
require("prototypes.updates.item-recipe-cleanup")
-- Read the finalized ingredient boundaries before weaving K2SO into FluxWorks.
require("prototypes.compat.k2so")
require("prototypes.compat.k2so-planetary")
require("prototypes.compat.k2so-science")
require("prototypes.compat.k2so-stone-processing")
-- Remove legacy early science tolls after all research reconciliation passes.
require("prototypes.updates.optional-domain-science")
require("prototypes.updates.flux-tooltips")
require("prototypes.updates.remove-obsolete-beneficiation")
require("prototypes.updates.owned-iconography")
-- K2SO replaces several stock item and fluid names; reconcile only owned
-- recipes once all new FluxWorks recipes and compatibility edits exist.
require("prototypes.compat.k2so-baseline")
-- Late, additive factory alternatives see K2SO's reconciled item identities
-- and are validated with the rest of the finished prototype graph.
require("prototypes.recipes.spectrum-industries")
-- Tangible rewards for optional research projects. Built after K2SO aliases.
require("prototypes.updates.industrial-machine-upgrades")

-- Optional throughput paths: additional Razi-era industrial manufacturing,
-- with stable prototype IDs and no scripted processing or planet mutations.
require("prototypes.recipes.razi-industrial-extension")
-- Razi-owned research reconciliation runs before per-player-selected
-- industrial pacing so none of our settings alter world or chapter gates.

-- Standalone mod first, optional galaxy adapters second.
require("prototypes.overhaul.spectrum-materials")
-- FluxWorks owns its industrial graph in every installation. Razi's
-- adapters belong to Razi and run after FluxWorks when that mod is present.
-- Deliberately do NOT require Razi modules from FluxWorks: that recreates an
-- unwanted reverse dependency and can execute Razi before its own data stage.

-- Native planet content is registered after Razi's existing seven-system
-- specialty and paired-freight bridges. All three new catalogs are optional.
require("prototypes.compat.galaxy-planet-factories")
require("prototypes.compat.galaxy-k2so-factories")
require("prototypes.compat.galaxy-freight-factories")
require("prototypes.overhaul.rework-recipes").apply()
require("prototypes.overhaul.machine-specialization").apply()
require("prototypes.overhaul.planetary-research").apply()
require("prototypes.overhaul.origin-forge-processes")
require("prototypes.overhaul.independent-programs")
if require("prototypes.lib.companion-mode").razi_protocol then
  require("prototypes.updates.razi-domain-science-rewire").apply()
end
require("prototypes.updates.razi-industrial-balance").apply()
require("prototypes.updates.razi-industry-tech-clarity").apply()

-- Factorio 2.1 replaced singular recipe categories and product probability
-- fields. Normalize after every compatibility rewrite and before validation.
require("prototypes.overhaul.late-recipe-boundaries").apply()
require("__razi_lib__/lib/recipe").normalize_all_2_1()

require("prototypes.validation.init")

-- Neither FluxWorks nor optional integrations replace the Factorio main menu.
