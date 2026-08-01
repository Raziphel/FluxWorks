local Startup = require("prototypes.lib.startup-settings")

if not Startup.enabled("fw-enable-recipe-integration", true) then
  return
end

if not Startup.enabled("fw-enable-fulgora-scrap-integration", true) then
  return
end

local scrap_recycling = data.raw.recipe and data.raw.recipe["scrap-recycling"]
if not scrap_recycling then
  return
end

-- Match Space Age's scrap doctrine: recover useful manufactured parts, then
-- recycle those parts further when their constituent materials are needed.
local fluxworks_component_results = {
  { type = "item", name = "fw-circuit-substrate", amount = 1, probability = 0.025 },
  { type = "item", name = "fw-glass-lens", amount = 1, probability = 0.025 },
  { type = "item", name = "fw-inductor-coil", amount = 1, probability = 0.020 },
  { type = "item", name = "fw-capacitor", amount = 1, probability = 0.015 },
  { type = "item", name = "fw-ceramic-insulator", amount = 1, probability = 0.015 },
  { type = "item", name = "fw-composite-panel", amount = 1, probability = 0.012 },
  { type = "item", name = "fw-light-frame", amount = 1, probability = 0.008 },
  { type = "item", name = "fw-pressure-housing", amount = 1, probability = 0.006 },
  { type = "item", name = "fw-foundry-lining", amount = 1, probability = 0.004 },
}

local function append_components(results)
  if not results then return end

  local existing = {}
  for _, result in ipairs(results) do
    existing[result.name or result[1]] = true
  end
  for _, result in ipairs(fluxworks_component_results) do
    if data.raw.item[result.name] and not existing[result.name] then
      results[#results + 1] = table.deepcopy(result)
    end
  end
end

append_components(scrap_recycling.results)
append_components(scrap_recycling.normal and scrap_recycling.normal.results)
append_components(scrap_recycling.expensive and scrap_recycling.expensive.results)
