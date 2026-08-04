local absorptions = require("prototypes.updates.progression-compression")

local function has_unlock(technology, recipe_name)
  for _, effect in pairs(technology.effects or {}) do
    if effect.type == "unlock-recipe" and effect.recipe == recipe_name then return true end
  end
  return false
end

local expected_unlocks = {
  ["fw-basic-separation"] = { "fw-carbon-refining", "fw-salt-from-water" },
  ["fw-structural-fabrication"] = {
    "fw-iron-beam", "fw-circuit-contact-leaded", "fw-inline-filter",
  },
  ["fw-wafer-etching"] = { "fw-silicon-wafer", "fw-chip-carrier" },
  ["fw-conductive-assembly"] = { "fw-tinned-cable" },
  ["fw-instrumentation"] = { "fw-glass-lens", "fw-lens-array", "fw-ribbon-cable" },
  ["fw-systems-integration"] = { "fw-transformer-core", "fw-sensor-package" },
  ["fw-advanced-fabrication"] = { "fw-composite-panel", "fw-light-frame" },
  ["fw-elastomer-engineering"] = { "fw-elastomer-matrix", "fw-reinforced-seal" },
  ["fw-cryogenic-control"] = { "fw-cryo-coil", "fw-thermal-buffer" },
}

for source_name in pairs(absorptions) do
  local source = data.raw.technology[source_name]
  if not source or not source.hidden or source.enabled ~= false then
    error("Progression compression failure: absorbed technology remains researchable: " .. source_name)
  end
  if next(source.effects or {}) or next(source.prerequisites or {}) then
    error("Progression compression failure: absorbed technology still owns progression: " .. source_name)
  end

  for technology_name, technology in pairs(data.raw.technology or {}) do
    for _, prerequisite in pairs(technology.prerequisites or {}) do
      if prerequisite == source_name then
        error(("Progression compression failure: %s still requires %s"):format(
          technology_name,
          source_name
        ))
      end
    end
  end
end

for technology_name, recipe_names in pairs(expected_unlocks) do
  local technology = data.raw.technology[technology_name]
  for _, recipe_name in ipairs(recipe_names) do
    if not has_unlock(technology, recipe_name) then
      error(("Progression compression failure: %s does not unlock %s"):format(
        technology_name,
        recipe_name
      ))
    end
  end
end
