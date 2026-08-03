local industrial_pack = "fw-industrial-methods-science-pack"
local systems_pack = "fw-systems-analysis-science-pack"
local flux_pack = "fw-flux-theory-science-pack"
local convergence_pack = "fw-planetary-convergence-science-pack"

local function science(...)
  local ingredients = {}
  for _, pack in ipairs({ ... }) do
    ingredients[#ingredients + 1] = { pack, 1 }
  end
  return ingredients
end

local science_tiers = {
  science("automation-science-pack", "logistic-science-pack", "chemical-science-pack", industrial_pack),
  science("automation-science-pack", "logistic-science-pack", "chemical-science-pack", "production-science-pack", systems_pack),
  science("automation-science-pack", "logistic-science-pack", "chemical-science-pack", "production-science-pack", "utility-science-pack", "space-science-pack", flux_pack),
}

local late_science_tiers = {
  science("automation-science-pack", "logistic-science-pack", "chemical-science-pack", "production-science-pack", "utility-science-pack", "space-science-pack", flux_pack),
  science("automation-science-pack", "logistic-science-pack", "chemical-science-pack", "production-science-pack", "utility-science-pack", "space-science-pack", "metallurgic-science-pack", "electromagnetic-science-pack", flux_pack),
  science("automation-science-pack", "logistic-science-pack", "chemical-science-pack", "production-science-pack", "utility-science-pack", "space-science-pack", "metallurgic-science-pack", "agricultural-science-pack", "electromagnetic-science-pack", "cryogenic-science-pack", convergence_pack),
}

local function productivity_effects(recipes, modifier)
  local effects = {}
  for _, recipe in ipairs(recipes) do
    if data.raw.recipe and data.raw.recipe[recipe] then
      effects[#effects + 1] = { type = "change-recipe-productivity", recipe = recipe, change = modifier }
    end
  end
  return effects
end

local programs = {
  {
    stem = "fw-precision-ceramics",
    title = "Precision Ceramics",
    description = "Improves yield across fired ceramic, wafer, insulation, and casing production.",
    icon = "__FluxWorksAssets__/graphics/technology/fw-ceramic-engineering.png",
    prerequisite = "fw-ceramic-engineering",
    recipes = { "fw-fired-ceramic", "fw-ceramic-wafer", "fw-ceramic-insulator", "fw-ceramic-casing" },
  },
  {
    stem = "fw-pressure-systems",
    title = "Pressure Systems",
    description = "Reduces losses while manufacturing seals, regulators, housings, and hydraulic manifolds.",
    icon = "__FluxWorksAssets__/graphics/technology/fw-hydraulic-systems.png",
    prerequisite = "fw-hydraulic-systems",
    recipes = { "fw-flow-regulator", "fw-pressure-housing", "fw-hydraulic-manifold", "fw-reinforced-seal" },
  },
  {
    stem = "fw-control-miniaturization",
    title = "Control Miniaturization",
    description = "Improves production of compact circuits, sensors, substrates, and logic hardware.",
    icon = "__FluxWorksAssets__/graphics/technology/fw-electromagnetic-architecture.png",
    prerequisite = "fw-logic-weaving",
    recipes = { "fw-microchip", "fw-circuit-substrate", "fw-sensor-package", "fw-logic-matrix" },
  },
  {
    stem = "fw-polymer-throughput",
    title = "Polymer Throughput",
    description = "Recovers more useful material throughout the latex, resin, binder, and elastomer chain.",
    icon = "__FluxWorksAssets__/graphics/technology/fw-polymer-stabilization.png",
    prerequisite = "fw-elastomer-engineering",
    recipes = { "fw-latex-polymerization", "fw-resin-polymerization", "fw-chlorinated-binder-stock", "fw-elastomer-matrix" },
  },
  {
    stem = "fw-spectral-hardware",
    title = "Spectral Hardware",
    description = "Improves stabilized components used to route and synchronize high-energy Flux.",
    icon = "__FluxWorksAssets__/graphics/technology/fw-flux-phase-engineering.png",
    prerequisite = "fw-flux-phase-engineering",
    late = true,
    recipes = { "fw-resonance-substrate", "fw-flux-resonance-cell-calibration", "fw-flux-phase-manifold-calibration" },
  },
  {
    stem = "fw-cryogenic-reclamation",
    title = "Cryogenic Reclamation",
    description = "Recovers more coolant and cryogenic material from closed-loop Aquilo processes.",
    icon = "__FluxWorksAssets__/graphics/technology/fw-cryogenic-control.png",
    prerequisite = "fw-aquilo-cryochemistry",
    late = true,
    recipes = { "fw-spectral-coolant-blend", "fw-spectral-coolant-recycling", "fw-aquilo-cryogel", "fw-aquilo-cryogel-annealing" },
  },
  {
    stem = "fw-orbital-recovery",
    title = "Orbital Recovery",
    description = "Improves useful yield from Flux-rich asteroids and recovered rocket debris.",
    icon = "__FluxWorksAssets__/graphics/technology/fw-rocket-chunk-processing.png",
    prerequisite = "fw-flux-asteroid-harvesting",
    late = true,
    recipes = { "rocket-chunk-processing", "fw-flux-asteroid-refining", "advanced-metallic-asteroid-crushing", "advanced-carbonic-asteroid-crushing" },
  },
  {
    stem = "fw-actinide-closure-methods",
    title = "Actinide Closure Methods",
    description = "Pushes radioactive recovery toward a tighter and more productive fuel cycle.",
    icon = "__FluxWorksAssets__/graphics/technology/fw-actinide-recovery.png",
    prerequisite = "fw-actinide-recovery",
    late = true,
    recipes = { "fw-radioactive-scrap-sorting", "fw-isotope-recovery", "fw-actinide-matrix-seeding", "fw-actinide-dopant-refining" },
  },
}

local counts = { 180, 480, 1100 }
local times = { 25, 35, 45 }
local modifiers = { 0.03, 0.05, 0.07 }
local technologies = {}
local roman_tiers = { "I", "II", "III" }

for program_index, program in ipairs(programs) do
  for tier = 1, 3 do
    local name = program.stem .. "-" .. tier
    local prerequisites = tier == 1 and { program.prerequisite } or { program.stem .. "-" .. (tier - 1) }
    if tier == 2 then
      prerequisites[#prerequisites + 1] = program.late and "fw-flux-theory-science" or "fw-systems-analysis-science"
    elseif tier == 3 then
      prerequisites[#prerequisites + 1] = program.late and "fw-planetary-convergence-science" or "fw-flux-theory-science"
    end

    technologies[#technologies + 1] = {
      type = "technology",
      name = name,
      icon = "__FluxWorksAssets__/graphics/technology/programs/" .. program.stem .. "-" .. tier .. ".png",
      icon_size = 256,
      prerequisites = prerequisites,
      unit = {
        count = counts[tier],
        ingredients = table.deepcopy((program.late and late_science_tiers or science_tiers)[tier]),
        time = times[tier],
      },
      effects = productivity_effects(program.recipes, modifiers[tier]),
      upgrade = true,
      order = ("fw-progression-%02d-%d"):format(program_index, tier),
      -- Keep a literal fallback on generated names. Locale keys remain defined
      -- for search and external references, while this prevents stale locale
      -- caches from exposing an Unknown key label in the technology browser.
      localised_name = { "", program.title, " ", roman_tiers[tier] },
      localised_description = { "", program.description },
    }
  end
end

data:extend(technologies)

return technologies
