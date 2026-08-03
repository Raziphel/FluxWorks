local function science(...)
  local ingredients = {}
  for _, name in ipairs({ ... }) do ingredients[#ingredients + 1] = { name, 1 } end
  return ingredients
end

local function recipe_productivity(recipes, amount)
  local effects = {}
  for _, recipe in ipairs(recipes) do
    if data.raw.recipe and data.raw.recipe[recipe] then
      effects[#effects + 1] = { type = "change-recipe-productivity", recipe = recipe, change = amount }
    end
  end
  return effects
end

local function runtime_effect(key)
  return { type = "nothing", effect_description = { "technology-effect." .. key } }
end

local icon_path = "__FluxWorksAssets__/graphics/technology/mastery/"
local late_science = science(
  "automation-science-pack", "logistic-science-pack", "chemical-science-pack",
  "production-science-pack", "utility-science-pack", "space-science-pack",
  "fw-flux-theory-science-pack"
)
local convergence_science = science(
  "automation-science-pack", "logistic-science-pack", "chemical-science-pack",
  "production-science-pack", "utility-science-pack", "space-science-pack",
  "metallurgic-science-pack", "agricultural-science-pack",
  "electromagnetic-science-pack", "cryogenic-science-pack",
  "fw-planetary-convergence-science-pack"
)

local function finite(name, icon, prerequisites, count, ingredients, effects, order)
  return {
    type = "technology", name = name, icon = icon_path .. icon, icon_size = 256,
    prerequisites = prerequisites,
    unit = { count = count, ingredients = ingredients, time = 60 },
    effects = effects, order = order,
  }
end

local function repeatable(name, icon, prerequisites, formula, ingredients, effects, order, max_level)
  return {
    type = "technology", name = name, icon = icon_path .. icon, icon_size = 256,
    prerequisites = prerequisites,
    unit = { count_formula = formula, ingredients = ingredients, time = 60 },
    effects = effects, max_level = max_level or "infinite", upgrade = true, order = order,
  }
end

data:extend({
  finite("fw-purple-spectrum-calibration", "purple-spectrum-calibration.png",
    { "fw-flux-purple-transmutation", "fw-flux-theory-science" }, 720, late_science,
    recipe_productivity({ "fw-silica-beneficiation", "fw-tin-ore-beneficiation", "fw-lead-ore-beneficiation", "fw-titanium-slurry-grading" }, 0.05),
    "fw-mastery-a[purple]"),
  finite("fw-yellow-spectrum-calibration", "yellow-spectrum-calibration.png",
    { "fw-flux-yellow-catalysis", "fw-flux-theory-science" }, 720, late_science,
    recipe_productivity({ "fw-salt-brine-clarification", "fw-bauxite-slurry-clarification", "fw-reactive-slurry-focusing" }, 0.05),
    "fw-mastery-b[yellow]"),
  finite("fw-red-spectrum-calibration", "red-spectrum-calibration.png",
    { "fw-flux-red-energetics", "fw-flux-theory-science" }, 720, late_science,
    recipe_productivity({ "fw-flux-fired-ceramic-annealing", "fw-flux-cermet-tempering", "fw-arc-cermet-densification", "fw-vulcanus-slag-cermet" }, 0.05),
    "fw-mastery-c[red]"),
  finite("fw-green-spectrum-calibration", "green-spectrum-calibration.png",
    { "fw-flux-green-cultivation", "fw-flux-theory-science" }, 720, late_science,
    recipe_productivity({ "fw-green-flux-from-spoilage", "fw-green-flux-from-nutrients", "fw-green-flux-from-bioflux" }, 0.05),
    "fw-mastery-d[green]"),
  finite("fw-unified-spectrum-control", "unified-spectrum-control.png",
    { "fw-purple-spectrum-calibration", "fw-yellow-spectrum-calibration", "fw-red-spectrum-calibration", "fw-green-spectrum-calibration", "fw-spectrum-control-project" },
    1400, late_science,
    recipe_productivity({ "fw-condensed-flux-matrix", "fw-flux-resonance-cell", "fw-flux-phase-manifold" }, 0.05),
    "fw-mastery-e[unified]"),
  finite("fw-spectral-recovery-theory", "spectral-recovery-theory.png",
    { "fw-flux-extraction", "fw-unified-spectrum-control" }, 1250, late_science,
    { runtime_effect("fw-spectral-recovery-theory") }, "fw-mastery-f[recovery]"),
  finite("fw-actinide-closure", "actinide-closure.png",
    { "fw-actinide-reforging", "fw-reactor-safeguards", "fw-fusion-lattices" }, 1500, late_science,
    recipe_productivity({ "fw-radioactive-scrap-sorting", "fw-isotope-recovery", "fw-actinide-matrix-seeding", "fw-scrap-lattice-recasting", "fw-pellet-bundle-reprocessing", "fw-actinide-dopant-refining", "fw-spent-fuel-reconditioning" }, 0.05),
    "fw-mastery-g[actinides]"),
  finite("fw-rift-network-synchronization", "rift-network-synchronization-v3.png",
    { "fw-rift-logistics", "fw-rift-harmonics", "fw-unified-spectrum-control" }, 1750, convergence_science,
    { runtime_effect("fw-rift-network-synchronization") }, "fw-mastery-h[rift-network]"),

  repeatable("fw-flux-synthesis-mastery", "flux-process-mastery-v2.png",
    { "fw-unified-spectrum-control", "fw-spectral-recovery-theory", "fw-flux-process-mastery-3" }, "800*1.6^(L-1)", late_science,
    recipe_productivity({ "fw-flux-catalyst", "fw-stabilized-flux-crystal", "fw-condensed-flux-matrix", "fw-flux-resonance-cell", "fw-flux-phase-manifold", "fw-flux-metallic-synthesis" }, 0.02),
    "fw-mastery-i[process]"),
  repeatable("fw-spectral-reservoir-density", "spectral-reservoir-density.png",
    { "fw-spectral-fluid-retention", "fw-unified-spectrum-control" }, "1000*1.55^(L-1)", late_science,
    { runtime_effect("fw-spectral-reservoir-density") }, "fw-mastery-j[reservoir]", 20),
  repeatable("fw-rift-transfer-harmonics", "rift-transfer-harmonics-v2.png",
    { "fw-rift-network-synchronization", "fw-convergence-directive-project" }, "1800*1.8^(L-1)", convergence_science,
    { runtime_effect("fw-rift-transfer-harmonics") }, "fw-mastery-k[rift-transfer]"),
  repeatable("fw-convergence-research", "convergence-research.png",
    { "fw-convergence-directive-project", "fw-unified-spectrum-control" }, "1500*1.7^(L-1)", convergence_science,
    { { type = "laboratory-productivity", modifier = 0.02 } }, "fw-mastery-l[convergence]"),
  repeatable("fw-harvester-throughput", "harvester-throughput.png",
    { "fw-unified-spectrum-control", "fw-harvester-systems" }, "900*1.6^(L-1)", late_science,
    recipe_productivity({ "fw-silica-beneficiation", "fw-salt-brine-clarification", "fw-bauxite-slurry-clarification", "fw-tin-ore-beneficiation", "fw-lead-ore-beneficiation", "fw-titanium-slurry-grading" }, 0.01),
    "fw-mastery-m[harvester]"),
  repeatable("fw-shattered-planet-yield", "shattered-planet-yield.png",
    { "fw-ion-storm-capture", "fw-convergence-directive-project" }, "2200*1.85^(L-1)", convergence_science,
    recipe_productivity({ "fw-shattered-red-bridgehead-forging", "fw-shattered-green-bridgehead-cultivation", "fw-shattered-yellow-bridgehead-reclamation", "fw-shattered-purple-bridgehead-annealing", "fw-shattered-vent-spectrum-condensation", "fw-ion-storm-harmonic-core" }, 0.02),
    "fw-mastery-n[shattered]"),
})
