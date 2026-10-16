-- Retain old standalone technology IDs for save references but stop advertising
-- obsolete landable-Shattered-Planet branches as a second Razi campaign.
-- Any technology consumed by an active, nonlegacy technology stays visible.
local M = {}
local function obsolete(name)
  return name:sub(1,13) == "fw-shattered-" or name == "fw-ion-storm-capture"
end
function M.apply()
  local technologies = data.raw.technology or {}
  local needed = {}
  for name, tech in pairs(technologies) do
    if not obsolete(name) and tech.hidden ~= true then
      for _, prerequisite in ipairs(tech.prerequisites or {}) do
        needed[prerequisite] = true
      end
    end
  end
  -- Transitively preserve every legacy prerequisite needed by any still
  -- visible research, so a hidden chain never becomes a silent hard gate.
  local changed = true
  while changed do
    changed = false
    for name in pairs(needed) do
      local tech = technologies[name]
      for _, prerequisite in ipairs((tech and tech.prerequisites) or {}) do
        if not needed[prerequisite] then
          needed[prerequisite] = true
          changed = true
        end
      end
    end
  end
  local hidden = 0
  for name,tech in pairs(technologies) do
    if obsolete(name) and not needed[name] then
      tech.hidden = true
      tech.hidden_in_factoriopedia = true
      hidden = hidden+1
    end
  end
  log("FluxWorks extension: hidden " .. hidden .. " orphaned standalone expedition researches")
  return hidden
end
return M
