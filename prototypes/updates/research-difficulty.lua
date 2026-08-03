local Startup = require("prototypes.lib.startup-settings")

local profiles = {
  easy = { count = 0.65, time = 0.80 },
  normal = { count = 1.00, time = 1.00 },
  hard = { count = 1.50, time = 1.20 },
}
local profile = profiles[Startup.difficulty_tier("fw-balance-research-cost", "normal")]

if profile.count == 1 and profile.time == 1 then
  return
end

local function scaled(value, multiplier)
  if multiplier > 1 then
    return math.max(1, math.ceil(value * multiplier))
  end
  return math.max(1, math.floor(value * multiplier))
end

for name, technology in pairs(data.raw.technology or {}) do
  local unit = technology.unit
  if string.sub(name, 1, 3) == "fw-" and unit and not unit.count_formula then
    if type(unit.count) == "number" then
      unit.count = scaled(unit.count, profile.count)
    end
    if type(unit.time) == "number" then
      unit.time = math.max(1, unit.time * profile.time)
    end
  end
end
