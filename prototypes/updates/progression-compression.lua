-- Compress narrow, single-component research gates into the milestone that already
-- establishes their production family. Keep the old prototypes hidden so existing
-- saves and compatibility references remain safe, then redirect the completed graph.
local absorptions = {
  ["fw-brine-processing"] = "fw-basic-separation",
  ["fw-contact-casting"] = "fw-structural-fabrication",
  ["fw-tube-forming"] = "fw-structural-fabrication",
  ["fw-chip-packaging"] = "fw-wafer-etching",
  ["fw-cable-looming"] = "fw-conductive-assembly",
  ["fw-optical-instrumentation"] = "fw-instrumentation",
  ["fw-ribbon-conductors"] = "fw-instrumentation",
  ["fw-sensor-integration"] = "fw-systems-integration",
  ["fw-lightweight-framing"] = "fw-advanced-fabrication",
  ["fw-polymer-stabilization"] = "fw-elastomer-engineering",
  ["fw-thermal-retention"] = "fw-cryogenic-control",
}

local function effect_key(effect)
  return table.concat({
    effect.type or "",
    effect.recipe or "",
    effect.modifier or "",
    effect.space_location or "",
  }, "\0")
end

local function merge_effects(target, source)
  target.effects = target.effects or {}
  local existing = {}
  for _, effect in pairs(target.effects) do
    existing[effect_key(effect)] = true
  end
  for _, effect in pairs(source.effects or {}) do
    local key = effect_key(effect)
    if not existing[key] then
      target.effects[#target.effects + 1] = table.deepcopy(effect)
      existing[key] = true
    end
  end
end

for source_name, target_name in pairs(absorptions) do
  local source = data.raw.technology[source_name]
  local target = data.raw.technology[target_name]
  if not source then error("Missing technology selected for progression compression: " .. source_name) end
  if not target then error("Missing compression target technology: " .. target_name) end

  merge_effects(target, source)
  source.effects = {}
  source.prerequisites = {}
  source.hidden = true
  source.enabled = false
end

for technology_name, technology in pairs(data.raw.technology or {}) do
  local rewritten = {}
  local seen = {}
  for _, prerequisite in pairs(technology.prerequisites or {}) do
    local replacement = absorptions[prerequisite] or prerequisite
    if replacement ~= technology_name and not seen[replacement] then
      rewritten[#rewritten + 1] = replacement
      seen[replacement] = true
    end
  end
  technology.prerequisites = rewritten
end

return absorptions
