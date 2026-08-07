local ResearchDifficulty = require("prototypes.lib.research-difficulty")
local profile = ResearchDifficulty.profile

if profile.count == 1 and profile.time == 1 then
  return
end

for name, technology in pairs(data.raw.technology or {}) do
  local unit = technology.unit
  if string.sub(name, 1, 3) == "fw-" and unit and not unit.count_formula then
    if type(unit.count) == "number" then
      unit.count = ResearchDifficulty.scaled_count(unit.count, profile.count)
    end
    if type(unit.time) == "number" then
      unit.time = math.max(1, unit.time * profile.time)
    end
  end
end
