local function technology(name)
  local prototype = data.raw.technology and data.raw.technology[name]
  if not prototype then
    error("FluxWorks technology weave references missing technology " .. name)
  end
  return prototype
end

local function has_prerequisite(prototype, prerequisite_name)
  for _, name in ipairs(prototype.prerequisites or {}) do
    if name == prerequisite_name then
      return true
    end
  end
  return false
end

local woven_edges = {}

local function weave(technology_name, prerequisite_name, reason)
  local target = technology(technology_name)
  technology(prerequisite_name)
  target.prerequisites = target.prerequisites or {}
  if not has_prerequisite(target, prerequisite_name) then
    target.prerequisites[#target.prerequisites + 1] = prerequisite_name
  end
  woven_edges[#woven_edges + 1] = {
    technology = technology_name,
    prerequisite = prerequisite_name,
    reason = reason,
  }
end

-- Early industry repeatedly crosses between vanilla milestones and the
-- FluxWorks material ladder. Each return edge represents hardware or process
-- knowledge the vanilla technology visibly benefits from.
weave("logistics-2", "fw-ore-crushing", "fast logistics should follow the first serious bulk-material process")
weave("engine", "fw-tube-forming", "engines need the tubing and filtration branch")
weave("fluid-handling", "fw-tube-forming", "fluid infrastructure should inherit formed tubing")
weave("chemical-science-pack", "fw-metals-fabrication", "chemical science needs the developed alloy branch")
weave("advanced-circuit", "fw-circuit-foundry", "advanced circuits should follow purpose-built contact and solder work")
weave("modules", "fw-microelectronics", "module engineering should use the completed microelectronics lane")
weave("quality-module", "fw-microelectronics", "quality control belongs after precision electronics")
weave("production-science-pack", "fw-machine-casings", "production science should prove durable machine construction")
weave("utility-science-pack", "fw-advanced-fabrication", "utility science should consume mature fabrication knowledge")

-- Mature infrastructure returns FluxWorks disciplines to major vanilla lanes.
weave("coal-liquefaction", "fw-petrochemical-engineering", "coal liquefaction belongs after dedicated petrochemistry")
weave("logistic-robotics", "fw-sensor-integration", "autonomous robots need integrated sensing")
if data.raw.technology["fw-aai-network-storage"] then
  weave("logistic-system", "fw-aai-network-storage", "requester networks should cap the optional AAI storage-network branch")
else
  weave("logistic-system", "fw-sensor-integration", "requester networks should follow FluxWorks sensing without requiring optional storage mods")
end
weave("effect-transmission", "fw-field-balancing", "beacon transmission needs controlled electrical fields")
weave("rocket-silo", "fw-computational-arrays", "rocket infrastructure needs mature control computation")
weave("space-platform-thruster", "fw-orbital-hardening", "platform propulsion should follow orbitalized FluxWorks hardware")

-- Nuclear and military capstones now close through the matching FluxWorks
-- chemistry, safeguards, and recovery branches.
weave("kovarex-enrichment-process", "fw-fuel-fabrication", "advanced enrichment needs a real fuel-fabrication lane")
weave("nuclear-fuel-reprocessing", "fw-actinide-sorting", "reprocessing should follow developed actinide recovery")
weave("uranium-ammo", "fw-reactor-safeguards", "weaponized uranium should follow controlled reactor handling")
weave("artillery", "fw-energetic-compounds", "artillery should use the mature energetic chemistry branch")
weave("atomic-bomb", "fw-reactor-instrumentation", "the nuclear weapon capstone should follow full reactor instrumentation")

-- Alternate the new factory-wide research programs with vanilla upgrade nodes.
-- This makes each program leave and re-enter the base tree between tiers.
local alternating_programs = {
  {
    stem = "fw-industrial-yield",
    vanilla = { "mining-productivity-2", "mining-productivity-3" },
  },
  {
    stem = "fw-material-handling",
    vanilla = { "inserter-capacity-bonus-3", "inserter-capacity-bonus-4" },
  },
  {
    stem = "fw-autonomous-logistics",
    vanilla = { "worker-robots-speed-4", "worker-robots-speed-5" },
  },
  {
    stem = "fw-rail-network-control",
    vanilla = { "braking-force-3", "braking-force-4" },
  },
  {
    stem = "fw-research-methodology",
    vanilla = { "research-speed-3", "research-speed-4" },
  },
}

for _, program in ipairs(alternating_programs) do
  weave(program.vanilla[1], program.stem .. "-1", "the first FluxWorks program tier feeds the vanilla upgrade lane")
  weave(program.stem .. "-2", program.vanilla[1], "the second program tier returns from the vanilla upgrade lane")
  weave(program.vanilla[2], program.stem .. "-2", "the second FluxWorks program tier feeds the next vanilla upgrade")
  weave(program.stem .. "-3", program.vanilla[2], "the final program tier returns from the next vanilla upgrade")
end

-- Flux mastery remains its own discipline, but its later tiers explicitly wait
-- for the production and orbital eras instead of forming a detached mini-chain.
weave("fw-flux-process-mastery-2", "production-science-pack", "mature Flux yield control needs production science")
weave("fw-flux-process-mastery-3", "space-science-pack", "phase mastery belongs in the orbital era")

for _, edge in ipairs(woven_edges) do
  if not has_prerequisite(technology(edge.technology), edge.prerequisite) then
    error(
      "FluxWorks technology weave lost edge "
        .. edge.technology
        .. " <- "
        .. edge.prerequisite
        .. " ("
        .. edge.reason
        .. ")"
    )
  end
end

if #woven_edges ~= 42 then
  error("FluxWorks technology weave edge count drifted: expected 42, got " .. #woven_edges)
end
