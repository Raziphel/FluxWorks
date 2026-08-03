local M = {}

local EXTRACTOR = "fw-flux-condenser"
local POWER = "fw-flux-condenser-power-interface"
local PROCESS_INTERVAL = 15
local ENERGY_PER_CYCLE = 1875000
local outputs = {
  purple = { entity = "fw-flux-condenser-purple-output", fluid = "fw-purple-flux" },
  yellow = { entity = "fw-flux-condenser-yellow-output", fluid = "fw-yellow-flux" },
  red = { entity = "fw-flux-condenser-red-output", fluid = "fw-red-flux" },
  green = { entity = "fw-flux-condenser-green-output", fluid = "fw-green-flux" },
}

local function valid(entity)
  return entity and entity.valid
end

local function destroy_render(id)
  if not id then return end
  local object = rendering.get_object_by_id(id)
  if object then object.destroy() end
end

local function cleanup(unit_number)
  local entry = storage.flux_extractors and storage.flux_extractors[unit_number]
  if not entry then return end
  destroy_render(entry.animation)
  destroy_render(entry.glow)
  for _, output in pairs(entry.outputs or {}) do
    if valid(output) then output.destroy() end
  end
  if valid(entry.power) then entry.power.destroy() end
  storage.flux_extractors[unit_number] = nil
end

local function register(entity)
  if not (valid(entity) and entity.name == EXTRACTOR and entity.unit_number) then return end
  storage.flux_extractors = storage.flux_extractors or {}
  cleanup(entity.unit_number)
  local entry = { entity = entity, outputs = {} }
  for color, definition in pairs(outputs) do
    entry.outputs[color] = entity.surface.create_entity({
      name = definition.entity, position = entity.position, force = entity.force,
      create_build_effect_smoke = false,
    })
  end
  entry.power = entity.surface.create_entity({
    name = POWER, position = entity.position, force = entity.force,
    create_build_effect_smoke = false,
  })
  -- Electric energy interfaces spawn with a charged buffer. Universal
  -- extraction must never receive a free startup cycle.
  entry.power.energy = 0
  storage.flux_extractors[entity.unit_number] = entry
end

local function start_animation(entry)
  if entry.animation then return end
  entry.animation = rendering.draw_animation({
    animation = "fw-flux-condenser-working-animation", target = entry.entity,
    surface = entry.entity.surface_index, render_layer = "object",
  }).id
  entry.glow = rendering.draw_animation({
    animation = "fw-flux-condenser-working-glow", target = entry.entity,
    surface = entry.entity.surface_index, render_layer = "higher-object-above",
    tint = { 0.78, 0.28, 1.0, 0.9 },
  }).id
end

local function stop_animation(entry)
  destroy_render(entry.animation)
  destroy_render(entry.glow)
  entry.animation = nil
  entry.glow = nil
end

local function process(entry)
  if not valid(entry.entity) then return false end
  local inventory = entry.entity.get_inventory(defines.inventory.chest)
  local valuation_data = prototypes.mod_data["fw-flux-extraction-values"]
  valuation_data = valuation_data and valuation_data.data or {}
  local stack, amounts
  for index = 1, #inventory do
    local candidate = inventory[index]
    if candidate.valid_for_read then
      local valuation = valuation_data[candidate.name]
      local quality_name = candidate.quality and candidate.quality.name or "normal"
      local candidate_amounts = valuation and valuation[quality_name]
      if candidate_amounts then
        stack = candidate
        amounts = candidate_amounts
        break
      end
    end
  end
  if not stack then stop_animation(entry); return true end
  if not (valid(entry.power) and entry.power.energy >= ENERGY_PER_CYCLE) then
    stop_animation(entry)
    return true
  end

  for color, amount in pairs(amounts) do
    local tank = entry.outputs[color]
    if amount > 0 and (not valid(tank) or tank.get_fluid_count(outputs[color].fluid) + amount > 10000) then
      stop_animation(entry)
      return true
    end
  end

  entry.power.energy = entry.power.energy - ENERGY_PER_CYCLE
  for color, amount in pairs(amounts) do
    if amount > 0 then entry.outputs[color].insert_fluid({ name = outputs[color].fluid, amount = amount }) end
  end
  stack.count = stack.count - 1
  start_animation(entry)
  return true
end

function M.register_events(registrar)
  registrar:on_init(function()
    storage.flux_extractors = {}
    for _, surface in pairs(game.surfaces) do
      for _, entity in pairs(surface.find_entities_filtered({ name = EXTRACTOR })) do register(entity) end
    end
  end)
  registrar:on_configuration_changed(function()
    storage.flux_extractors = storage.flux_extractors or {}
    for _, surface in pairs(game.surfaces) do
      for _, entity in pairs(surface.find_entities_filtered({ name = EXTRACTOR })) do
        local entry = storage.flux_extractors[entity.unit_number]
        if not entry then
          register(entity)
        elseif valid(entry.power) then
          -- Clear legacy precharged buffers from saves made before the
          -- extractor's power contract was enforced.
          entry.power.energy = 0
        end
      end
    end
  end)
  registrar:on_event({
    defines.events.on_built_entity, defines.events.on_robot_built_entity,
    defines.events.script_raised_built, defines.events.script_raised_revive,
    defines.events.on_space_platform_built_entity,
  }, function(event) register(event.entity or event.created_entity) end)
  registrar:on_event({
    defines.events.on_player_mined_entity, defines.events.on_robot_mined_entity,
    defines.events.on_entity_died, defines.events.script_raised_destroy,
    defines.events.on_space_platform_mined_entity,
  }, function(event)
    local entity = event.entity
    if entity and entity.name == EXTRACTOR and entity.unit_number then cleanup(entity.unit_number) end
  end)
  registrar:on_nth_tick(PROCESS_INTERVAL, function()
    for unit_number, entry in pairs(storage.flux_extractors or {}) do
      if not process(entry) then cleanup(unit_number) end
    end
  end)
end

return M
