local programs = {
  "fw-industrial-yield",
  "fw-material-handling",
  "fw-autonomous-logistics",
  "fw-rail-network-control",
  "fw-research-methodology",
  "fw-flux-process-mastery",
}

local ResearchDifficulty = require("prototypes.lib.research-difficulty")
local expected_counts = { 240, 700, 1800 }
local domain_packs = {
  "fw-industrial-methods-science-pack",
  "fw-systems-analysis-science-pack",
  "fw-flux-theory-science-pack",
  "fw-planetary-convergence-science-pack",
}

local expected_domain = {
  ["fw-industrial-yield"] = "fw-industrial-methods-science-pack",
  ["fw-material-handling"] = "fw-industrial-methods-science-pack",
  ["fw-autonomous-logistics"] = "fw-systems-analysis-science-pack",
  ["fw-rail-network-control"] = "fw-systems-analysis-science-pack",
  ["fw-research-methodology"] = "fw-systems-analysis-science-pack",
  ["fw-flux-process-mastery"] = "fw-flux-theory-science-pack",
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

for _, stem in ipairs(programs) do
  for tier = 1, 3 do
    local name = stem .. "-" .. tier
    local technology = data.raw.technology and data.raw.technology[name]
    if not technology then
      error("FluxWorks research program is missing technology " .. name)
    end

    if not technology.effects or #technology.effects == 0 then
      error("FluxWorks research program technology has no tangible effect: " .. name)
    end

    local expected_count = ResearchDifficulty.normalized_count(
      ResearchDifficulty.scaled_count(
        expected_counts[tier],
        ResearchDifficulty.profile.count
      )
    )
    if not technology.unit or technology.unit.count ~= expected_count then
      error(("FluxWorks research program cost drifted for %s: expected %s, got %s"):format(
        name,
        tostring(expected_count),
        tostring(technology.unit and technology.unit.count)
      ))
    end

    for _, pack in ipairs(domain_packs) do
      local should_consume = pack == expected_domain[stem]
      local does_consume = contains(technology.unit and technology.unit.ingredients, pack)
      if should_consume ~= does_consume then
        error(name .. " has the wrong research discipline: " .. pack)
      end
    end

    if tier > 1 then
      local expected_prerequisite = stem .. "-" .. (tier - 1)
      local chained = false
      for _, prerequisite in ipairs(technology.prerequisites or {}) do
        if prerequisite == expected_prerequisite then
          chained = true
          break
        end
      end
      if not chained then
        error("FluxWorks research program tier is not chained: " .. name)
      end
    end

    for _, effect in ipairs(technology.effects) do
      if effect.type == "change-recipe-productivity"
        and not (data.raw.recipe and data.raw.recipe[effect.recipe])
      then
        error(name .. " improves missing recipe " .. tostring(effect.recipe))
      end
    end
  end
end
