local Startup = require("prototypes.lib.startup-settings")

local profiles = {
  easy = { count = 0.65, time = 0.80 },
  normal = { count = 1.00, time = 1.00 },
  hard = { count = 1.50, time = 1.20 },
}

local function scaled(value, multiplier)
  if multiplier > 1 then
    return math.max(1, math.ceil(value * multiplier))
  end
  return math.max(1, math.floor(value * multiplier))
end

local function normalized(value)
  -- The final playtest reconciliation presents finite research costs in clean
  -- five-pack increments; validators must compare against that visible value.
  return math.max(5, math.floor((value + 2.5) / 5) * 5)
end

return {
  profile = profiles[Startup.difficulty_tier("fw-balance-research-cost", "normal")],
  scaled_count = scaled,
  normalized_count = normalized,
}
