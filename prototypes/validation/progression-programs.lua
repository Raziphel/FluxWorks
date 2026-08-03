local stems = {
  "fw-precision-ceramics",
  "fw-pressure-systems",
  "fw-control-miniaturization",
  "fw-polymer-throughput",
  "fw-spectral-hardware",
  "fw-cryogenic-reclamation",
  "fw-orbital-recovery",
  "fw-actinide-closure-methods",
}

local seen_icons = {}
local count = 0

for _, stem in ipairs(stems) do
  for tier = 1, 3 do
    local name = stem .. "-" .. tier
    local technology = data.raw.technology and data.raw.technology[name]
    if not technology then error("Missing progression program technology: " .. name) end
    if #(technology.effects or {}) == 0 then error("Progression program has no tangible benefit: " .. name) end
    if tier > 1 then
      local expected = stem .. "-" .. (tier - 1)
      local chained = false
      for _, prerequisite in pairs(technology.prerequisites or {}) do
        if prerequisite == expected then chained = true break end
      end
      if not chained then error(name .. " does not follow " .. expected) end
    end
    if seen_icons[technology.icon] then error(name .. " shares progression art with " .. seen_icons[technology.icon]) end
    seen_icons[technology.icon] = name
    count = count + 1
  end
end

if count ~= 24 then error("FluxWorks progression program count drifted from 24") end
