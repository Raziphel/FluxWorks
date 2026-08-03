-- These narrow ore-washing loops competed with simpler crushing and smelting
-- routes, cluttered the Flux Harvester selector, and did not justify a factory
-- branch of their own. Keep the Harvester focused on Flux transmutation and
-- recovery instead.
local obsolete_recipes = {
  ["fw-salt-brine-clarification"] = true,
  ["fw-silica-beneficiation"] = true,
  ["fw-carbonic-washing"] = true,
  ["fw-bauxite-slurry-clarification"] = true,
  ["fw-tin-ore-beneficiation"] = true,
  ["fw-lead-ore-beneficiation"] = true,
  ["fw-titanium-slurry-grading"] = true,
  ["fw-carbon-grade-screening"] = true,
}

local obsolete_technologies = {
  ["fw-slurry-beneficiation"] = true,
  ["fw-purple-spectrum-calibration"] = true,
  ["fw-harvester-throughput"] = true,
}

for technology_name in pairs(obsolete_technologies) do
  data.raw.technology[technology_name] = nil
end

for _, technology in pairs(data.raw.technology or {}) do
  local prerequisites = {}
  for _, prerequisite in pairs(technology.prerequisites or {}) do
    if not obsolete_technologies[prerequisite] then
      prerequisites[#prerequisites + 1] = prerequisite
    end
  end
  technology.prerequisites = prerequisites

  local effects = {}
  for _, effect in pairs(technology.effects or {}) do
    if not (effect.recipe and obsolete_recipes[effect.recipe]) then
      effects[#effects + 1] = effect
    end
  end
  technology.effects = effects
end

for recipe_name in pairs(obsolete_recipes) do
  data.raw.recipe[recipe_name] = nil
end
