local domains = {
  {
    technology = "fw-industrial-methods-science",
    pack = "fw-industrial-methods-science-pack",
    consumers = {
      "fw-precision-alloys", "fw-circuit-foundry", "fw-beam-engineering",
      "fw-conductive-assembly", "fw-machine-casings", "fw-material-refinement",
      "fw-bulk-logistics", "fw-industrial-expansion", "fw-advanced-fabrication",
      "fw-lightweight-framing",
      "fw-metallurgic-assemblies", "fw-elastomer-engineering", "fw-polymer-stabilization",
      "fw-hydraulic-systems", "fw-pressure-containment", "fw-orbital-hardening",
      "fw-material-handling-1", "fw-material-handling-2", "fw-material-handling-3",
      "fw-industrial-yield-1", "fw-industrial-yield-2", "fw-industrial-yield-3",
    },
    external_consumers = {
      "production-science-pack", "advanced-material-processing-2", "automation-3",
      "logistics-3", "elevated-rail", "industrial-furnace", "area-mining-drill",
      "mining-productivity-2", "mining-productivity-3",
      "inserter-capacity-bonus-3", "inserter-capacity-bonus-4", "braking-force-3",
      "research-speed-5", "effect-transmission", "nuclear-fuel-reprocessing",
      "speed-module-2", "productivity-module-2", "efficiency-module-2", "quality-module-2",
    },
  },
  {
    technology = "fw-systems-analysis-science",
    pack = "fw-systems-analysis-science-pack",
    consumers = {
      "fw-power-regulation", "fw-field-balancing", "fw-fluid-control-architecture",
      "fw-logic-weaving", "fw-logistics-orchestration", "fw-reactor-instrumentation",
      "fw-computational-arrays", "fw-conductive-networks", "fw-network-logistics",
      "fw-superconductive-systems", "fw-reactor-safeguards",
      "fw-autonomous-logistics-1", "fw-autonomous-logistics-2", "fw-autonomous-logistics-3",
      "fw-rail-network-control-1", "fw-rail-network-control-2", "fw-rail-network-control-3",
      "fw-research-methodology-1", "fw-research-methodology-2", "fw-research-methodology-3",
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
  },
  {
    technology = "fw-flux-theory-science",
    pack = "fw-flux-theory-science-pack",
    consumers = {
      "fw-flux-field-theory", "fw-flux-phase-engineering", "fw-flux-synthesis",
      "fw-flux-thermal-networks", "fw-flux-chemical-synthesis", "fw-flux-green-propagation",
      "fw-flux-overdrive", "fw-flux-convergence", "fw-deep-phase-storage",
      "fw-spectral-fluid-retention", "fw-rift-logistics",
      "fw-phase-assembly-productivity", "fw-green-cultivation-productivity",
      "fw-green-propagation-productivity", "fw-green-reclamation-productivity",
      "fw-flux-process-mastery-1", "fw-flux-process-mastery-2", "fw-flux-process-mastery-3",
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
  },
  {
    technology = "fw-planetary-convergence-science",
    pack = "fw-planetary-convergence-science-pack",
    consumers = {
      "fw-rift-harmonics", "fw-shattered-expedition-planning", "fw-shattered-platform-hardening",
      "fw-shattered-landing-protocols", "fw-shattered-vulcanus-bridgehead",
      "fw-shattered-gleba-bridgehead", "fw-shattered-fulgora-bridgehead",
      "fw-shattered-aquilo-bridgehead", "fw-shattered-vent-harmonics",
      "fw-ion-storm-survival", "fw-shattered-network-logistics", "fw-shattered-origin-survey",
      "fw-ion-storm-capture", "fw-origin-infrastructure", "fw-storm-megastructures",
      "fw-origin-transcendence",
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

for _, domain in ipairs(domains) do
  local unlock = data.raw.technology and data.raw.technology[domain.technology]
  local pack = data.raw.tool and data.raw.tool[domain.pack]
  if not (unlock and pack) then
    error("FluxWorks domain science definition is incomplete for " .. domain.pack)
  end

  for _, technology_name in ipairs(domain.consumers) do
    local technology = data.raw.technology and data.raw.technology[technology_name]
    if not technology then
      error("FluxWorks domain science references missing consumer " .. technology_name)
    end

    technology.prerequisites = technology.prerequisites or {}
    if not contains(technology.prerequisites, domain.technology) then
      technology.prerequisites[#technology.prerequisites + 1] = domain.technology
    end

    technology.unit = technology.unit or {}
    technology.unit.ingredients = technology.unit.ingredients or {}
    if not contains(technology.unit.ingredients, domain.pack) then
      technology.unit.ingredients[#technology.unit.ingredients + 1] = { domain.pack, 1 }
    end
  end

  -- The science ingredient is itself the progression gate for established technologies.
  -- Avoid injecting redundant prerequisite edges into the base/mod technology graph:
  -- compatibility mods can rearrange those edges, while the pack requirement stays safe.
  for _, technology_name in ipairs(domain.external_consumers or {}) do
    local technology = data.raw.technology and data.raw.technology[technology_name]
    if not technology then
      error("FluxWorks domain science references missing external consumer " .. technology_name)
    end

    technology.unit = technology.unit or {}
    technology.unit.ingredients = technology.unit.ingredients or {}
    if not contains(technology.unit.ingredients, domain.pack) then
      technology.unit.ingredients[#technology.unit.ingredients + 1] = { domain.pack, 1 }
    end
  end
end

return domains
