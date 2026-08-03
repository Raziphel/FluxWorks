local planet = data.raw.planet and data.raw.planet["shattered-planet"]
local lightning = data.raw.lightning and data.raw.lightning["fw-ion-lightning"]
local collector_item = data.raw.item and data.raw.item["lightning-collector"]
local collector_entity = data.raw["lightning-attractor"] and data.raw["lightning-attractor"]["lightning-collector"]

if not (planet and planet.lightning_properties) then
  error("Shattered Planet must have a real ion-lightning climate")
end

if not lightning or lightning.damage.amount < 150 or lightning.energy ~= "1500MJ" then
  error("Shattered Planet ion lightning lost its high-energy hazard identity")
end

if planet.lightning_properties.lightning_types[1] ~= "fw-ion-lightning" then
  error("Shattered Planet is not using FluxWorks ion lightning")
end

local fulgora = data.raw.planet and data.raw.planet.fulgora
if not (fulgora and fulgora.lightning_properties) then
  error("Fulgora lightning baseline is unavailable")
end

if planet.lightning_properties.lightnings_per_chunk_per_tick
  <= fulgora.lightning_properties.lightnings_per_chunk_per_tick
then
  error("Shattered Planet ion lightning must be denser than Fulgora lightning")
end

local expedition = data.raw.technology and data.raw.technology["fw-shattered-expedition-planning"]
local requires_collector = false
for _, prerequisite in pairs((expedition and expedition.prerequisites) or {}) do
  if prerequisite == "lightning-collector" then requires_collector = true end
end
if not requires_collector then
  error("Shattered expedition planning must require lightning collectors")
end

if not collector_item or collector_item.place_result ~= "lightning-collector" then
  error("Lightning collectors must remain directly placeable expedition equipment")
end
if not collector_entity or collector_entity.surface_conditions then
  error("Lightning collectors must be placeable on Shattered Planet land")
end

for _, tile_name in ipairs({
  "fw-shattered-red-land",
  "fw-shattered-purple-land",
  "fw-shattered-yellow-land",
  "fw-shattered-green-land",
}) do
  local tile = data.raw.tile and data.raw.tile[tile_name]
  local layers = tile and tile.collision_mask and tile.collision_mask.layers or {}
  if layers.object or layers.item or layers.player then
    error("Shattered Planet land blocks lightning-collector placement: " .. tile_name)
  end
end
