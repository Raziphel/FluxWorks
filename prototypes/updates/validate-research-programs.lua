local programs = {
  "fw-industrial-yield",
  "fw-material-handling",
  "fw-autonomous-logistics",
  "fw-rail-network-control",
  "fw-research-methodology",
  "fw-flux-process-mastery",
}

local expected_counts = { 240, 700, 1800 }

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

    if not technology.unit or technology.unit.count ~= expected_counts[tier] then
      error("FluxWorks research program cost drifted for " .. name)
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
