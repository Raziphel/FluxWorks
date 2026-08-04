local domains = {
  {
    technology = "fw-industrial-methods-science",
    pack = "fw-industrial-methods-science-pack",
    consumers = {
      "fw-circuit-foundry", "fw-beam-engineering",
      "fw-conductive-assembly", "fw-machine-casings", "fw-material-refinement",
      "fw-industrial-expansion", "fw-advanced-fabrication",
      "fw-metallurgic-assemblies", "fw-elastomer-engineering",
      "fw-hydraulic-systems", "fw-orbital-hardening",
      "fw-flux-extraction",
      "fw-material-handling-1", "fw-material-handling-2", "fw-material-handling-3",
      "fw-industrial-yield-1", "fw-industrial-yield-2", "fw-industrial-yield-3",
    },
    ingredient_consumers = {
      "fw-lightweight-framing", "fw-propellant-synthesis",
      "fw-reactive-powders", "fw-petrochemical-engineering",
      "fw-reactive-binders", "fw-polymer-stabilization", "fw-isotope-conditioning",
      "fw-fuel-fabrication", "fw-lattice-moderation", "fw-actinide-recovery",
      "fw-actinide-sorting", "fw-actinide-reforging",
    },
    external_consumers = {
      "production-science-pack", "advanced-material-processing-2", "automation-3",
      "logistics-3", "elevated-rail", "industrial-furnace", "area-mining-drill",
      "mining-productivity-2", "mining-productivity-3",
      "inserter-capacity-bonus-3", "inserter-capacity-bonus-4", "braking-force-3",
      "research-speed-5", "effect-transmission", "nuclear-fuel-reprocessing",
      "speed-module-2", "productivity-module-2", "efficiency-module-2", "quality-module-2",
    },
    supporting_consumers = {
      "fw-computational-arrays",
      "fw-superconductive-systems",
      "fw-flux-synthesis",
      "fw-deep-phase-storage",
      "fw-origin-infrastructure",
      "fw-flux-mining-productivity",
    },
  },
  {
    technology = "fw-systems-analysis-science",
    pack = "fw-systems-analysis-science-pack",
    consumers = {
      "fw-power-regulation", "fw-field-balancing", "fw-fluid-control-architecture",
      "fw-logic-weaving", "fw-reactor-instrumentation",
      "fw-computational-arrays", "fw-conductive-networks",
      "fw-superconductive-systems", "fw-reactor-safeguards",
      "fw-autonomous-logistics-1", "fw-autonomous-logistics-2", "fw-autonomous-logistics-3",
      "fw-rail-network-control-1", "fw-rail-network-control-2", "fw-rail-network-control-3",
      "fw-research-methodology-1", "fw-research-methodology-2", "fw-research-methodology-3",
    },
    ingredient_consumers = {
      "fw-electromagnetic-architecture", "fw-orbital-hardening", "fw-reactor-doping",
      "fw-fusion-lattices", "fw-deep-phase-storage", "fw-spectral-fluid-retention",
      "fw-rift-network-synchronization", "fw-spectral-reservoir-density",
    },
    external_consumers = {
      "utility-science-pack", "logistic-system",
      "worker-robots-speed-3", "worker-robots-speed-4", "worker-robots-speed-5",
      "worker-robots-storage-2", "worker-robots-storage-3",
      "inserter-capacity-bonus-5", "inserter-capacity-bonus-6", "inserter-capacity-bonus-7",
      "braking-force-4", "braking-force-5", "braking-force-6", "braking-force-7",
      "research-speed-6", "power-armor-mk2", "personal-roboport-mk2-equipment",
      "toolbelt-4", "toolbelt-5", "processing-unit-productivity",
    },
    supporting_consumers = {
      "fw-flux-field-theory",
      "fw-flux-phase-engineering",
      "fw-rift-logistics",
      "fw-shattered-network-logistics",
      "fw-origin-transcendence",
      "fw-flux-mining-productivity",
    },
  },
  {
    technology = "fw-flux-theory-science",
    pack = "fw-flux-theory-science-pack",
    consumers = {
      "fw-flux-field-theory", "fw-flux-phase-engineering", "fw-flux-purple-transmutation",
      "fw-flux-synthesis",
      "fw-flux-thermal-networks", "fw-flux-chemical-synthesis", "fw-flux-green-propagation",
      "fw-flux-overdrive", "fw-flux-convergence", "fw-deep-phase-storage",
      "fw-spectral-fluid-retention", "fw-rift-logistics",
      "fw-phase-assembly-productivity", "fw-green-cultivation-productivity",
      "fw-green-propagation-productivity", "fw-green-reclamation-productivity",
      "fw-flux-process-mastery-1", "fw-flux-process-mastery-2", "fw-flux-process-mastery-3",
    },
    ingredient_consumers = {
      "fw-flux-metallurgy", "fw-resonance-assemblies", "fw-flux-asteroid-harvesting",
      "fw-aquilo-cryochemistry", "fw-gleba-biochemistry", "fw-vulcanus-pyrochemistry",
      "fw-fulgora-electrochemistry", "fw-flux-reactive-slurries",
      "fw-flux-green-cultivation", "fw-superconductive-systems", "fw-fusion-lattices",
      "fw-yellow-spectrum-calibration",
      "fw-red-spectrum-calibration", "fw-green-spectrum-calibration",
      "fw-unified-spectrum-control", "fw-spectral-recovery-theory",
      "fw-flux-synthesis-mastery",
    },
    external_consumers = {
      "space-platform-thruster", "planet-discovery-vulcanus", "planet-discovery-gleba",
      "planet-discovery-fulgora", "asteroid-reprocessing", "advanced-asteroid-processing",
      "planet-discovery-aquilo", "kovarex-enrichment-process", "atomic-bomb", "artillery",
      "spidertron", "epic-quality", "legendary-quality",
      "speed-module-3", "productivity-module-3", "efficiency-module-3", "quality-module-3",
      "electric-weapons-damage-2", "electric-weapons-damage-3", "tesla-weapons",
      "railgun", "mech-armor", "rocket-turret", "asteroid-productivity",
    },
    supporting_consumers = {
      "fw-rift-harmonics",
      "fw-shattered-vent-harmonics",
      "fw-ion-storm-capture",
      "fw-shattered-origin-survey",
      "fw-origin-transcendence",
      "fw-flux-mining-productivity",
    },
  },
  {
    technology = "fw-planetary-convergence-science",
    pack = "fw-planetary-convergence-science-pack",
    consumers = {
      "fw-rift-harmonics", "fw-rift-logistics",
      "fw-shattered-expedition-planning", "fw-shattered-platform-hardening",
      "fw-shattered-landing-protocols", "fw-shattered-vulcanus-bridgehead",
      "fw-shattered-gleba-bridgehead", "fw-shattered-fulgora-bridgehead",
      "fw-shattered-aquilo-bridgehead", "fw-shattered-vent-harmonics",
      "fw-ion-storm-survival", "fw-shattered-network-logistics", "fw-shattered-origin-survey",
      "fw-ion-storm-capture", "fw-origin-infrastructure", "fw-storm-megastructures",
      "fw-origin-transcendence",
    },
    ingredient_consumers = {
      "fw-rift-network-synchronization", "fw-rift-transfer-harmonics",
      "fw-convergence-research", "fw-shattered-planet-yield",
      "fw-flux-mining-productivity",
    },
    external_consumers = {
      "research-productivity", "worker-robots-speed-7",
      "artillery-shell-damage-1", "artillery-shell-range-1", "artillery-shell-speed-1",
      "railgun-damage-1", "railgun-shooting-speed-1", "electric-weapons-damage-4",
      "laser-weapons-damage-7", "physical-projectile-damage-7", "stronger-explosives-7",
      "refined-flammables-7", "health", "rocket-part-productivity",
      "scrap-recycling-productivity", "steel-plate-productivity",
      "low-density-structure-productivity", "plastic-bar-productivity",
      "rocket-fuel-productivity", "follower-robot-count-5",
    },
  },
}

local function contains(entries, name)
  for _, entry in ipairs(entries or {}) do
    local entry_name = type(entry) == "table" and (entry.name or entry[1]) or entry
    if entry_name == name then
      return true
    end
  end
  return false
end

local function require_domain(technology_name, domain, add_prerequisite)
  local technology = data.raw.technology and data.raw.technology[technology_name]
  if not technology then
    error("FluxWorks domain science references missing consumer " .. technology_name)
  end

  if add_prerequisite then
    technology.prerequisites = technology.prerequisites or {}
    if not contains(technology.prerequisites, domain.technology) then
      technology.prerequisites[#technology.prerequisites + 1] = domain.technology
    end
  end

  technology.unit = technology.unit or {}
  technology.unit.ingredients = technology.unit.ingredients or {}
  if not contains(technology.unit.ingredients, domain.pack) then
    technology.unit.ingredients[#technology.unit.ingredients + 1] = { domain.pack, 1 }
  end
end

for _, technology_name in ipairs({
  "aai-loader",
  "aai-fast-loader",
  "fw-aai-bulk-storage",
}) do
  if data.raw.technology and data.raw.technology[technology_name] then
    domains[1].consumers[#domains[1].consumers + 1] = technology_name
  end
end

for _, technology_name in ipairs({
  "aai-express-loader",
  "aai-turbo-loader",
  "fw-aai-network-storage",
  "fw-aai-controlled-storage",
}) do
  if data.raw.technology and data.raw.technology[technology_name] then
    domains[2].consumers[#domains[2].consumers + 1] = technology_name
  end
end

for _, domain in ipairs(domains) do
  local unlock = data.raw.technology and data.raw.technology[domain.technology]
  local pack = data.raw.item and data.raw.item[domain.pack]
  if not (unlock and pack) then
    error("FluxWorks domain science definition is incomplete for " .. domain.pack)
  end

  for _, technology_name in ipairs(domain.consumers) do
    require_domain(technology_name, domain, true)
  end

  -- The science ingredient is itself the progression gate for established technologies.
  -- Avoid injecting redundant prerequisite edges into the base/mod technology graph:
  -- compatibility mods can rearrange those edges, while the pack requirement stays safe.
  for _, technology_name in ipairs(domain.external_consumers or {}) do
    require_domain(technology_name, domain, false)
  end

  -- These technologies are already downstream of the domain unlock through
  -- their existing branches. The bottle is the visible pivotal requirement;
  -- a second direct prerequisite edge would be redundant and Factorio drops it.
  for _, technology_name in ipairs(domain.ingredient_consumers or {}) do
    require_domain(technology_name, domain, false)
  end

  -- A few technologies deliberately combine disciplines. These are supporting
  -- requirements, not a blanket rule that every late technology consumes every
  -- earlier pack. Requiring the domain unlock as well as the bottle keeps the
  -- resulting technology graph honest and the research available when shown.
  for _, technology_name in ipairs(domain.supporting_consumers or {}) do
    require_domain(technology_name, domain, true)
  end
end

-- Technologies such as Research Productivity deliberately consume the complete
-- science catalog. Extend that semantic rule instead of maintaining another
-- name list: if a technology already requires every vanilla and Space Age
-- science pack, it also requires every FluxWorks domain pack.
local complete_science_catalog = {
  "automation-science-pack",
  "logistic-science-pack",
  "military-science-pack",
  "chemical-science-pack",
  "production-science-pack",
  "utility-science-pack",
  "space-science-pack",
  "metallurgic-science-pack",
  "electromagnetic-science-pack",
  "agricultural-science-pack",
  "cryogenic-science-pack",
  "promethium-science-pack",
}

local all_science_consumers = {}
for technology_name, technology in pairs(data.raw.technology or {}) do
  local ingredients = technology.unit and technology.unit.ingredients
  local consumes_complete_catalog = ingredients ~= nil

  for _, science_pack in ipairs(complete_science_catalog) do
    if not contains(ingredients, science_pack) then
      consumes_complete_catalog = false
      break
    end
  end

  if consumes_complete_catalog then
    for _, domain in ipairs(domains) do
      require_domain(technology_name, domain, false)
    end
    all_science_consumers[#all_science_consumers + 1] = technology_name
  end
end

table.sort(all_science_consumers)
domains.complete_science_catalog = complete_science_catalog
domains.all_science_consumers = all_science_consumers

return domains
