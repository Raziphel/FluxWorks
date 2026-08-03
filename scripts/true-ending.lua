local M = {}
local Startup = require("prototypes.lib.startup-settings")

local STRUCTURE_NAME = "fw-origin-singularity"
local POWER_NAME = "fw-origin-singularity-power-interface"
local SURFACE_NAME = "shattered-planet"
local origin_difficulty = Startup.difficulty_tier("fw-balance-origin-singularity-difficulty", "normal")
local ACTIVATION_ENERGY = ({
  easy = 30000000000,
  normal = 120000000000,
  hard = 240000000000,
})[origin_difficulty] or 120000000000
local PROCESS_INTERVAL = 30
local BAR_LEFT_TOP = { x = 3.0, y = -1.9 }
local BAR_RIGHT_BOTTOM = { x = 3.35, y = 1.9 }

local function structures()
  storage.fw_true_ending_structures = storage.fw_true_ending_structures or {}
  return storage.fw_true_ending_structures
end

local function finished_forces()
  storage.fw_true_ending_finished_forces = storage.fw_true_ending_finished_forces or {}
  return storage.fw_true_ending_finished_forces
end

local function disable_original_victory()
  if remote.interfaces["space_finish_script"] then
    remote.call("space_finish_script", "set_no_victory", true)
  end
end

local function is_shattered_surface(surface)
  return surface and surface.valid and surface.name == SURFACE_NAME
end

local function destroy_render(entry, key)
  if entry[key] then
    local render_object = rendering.get_object_by_id(entry[key])
    if render_object then
      render_object.destroy()
    end
    entry[key] = nil
  end
end

local function cleanup_entry(unit_number)
  local entry = storage.fw_true_ending_structures and storage.fw_true_ending_structures[unit_number]
  if not entry then
    return
  end

  destroy_render(entry, "text")
  destroy_render(entry, "progress_background")
  destroy_render(entry, "progress_fill")
  if entry.powersource and entry.powersource.valid then
    entry.powersource.destroy()
  end
  storage.fw_true_ending_structures[unit_number] = nil
end

local function set_idle_power(entry)
  entry.powersource.electric_buffer_size = 1
end

local function set_activation_power(entry)
  entry.powersource.electric_buffer_size = ACTIVATION_ENERGY
end

local function charge_ratio(entry)
  if not (entry and entry.powersource and entry.powersource.valid) then
    return 0
  end

  return math.max(0, math.min(1, (entry.powersource.energy or 0) / ACTIVATION_ENERGY))
end

local function current_status(entry)
  if entry.finished then
    return "Singularity stabilized"
  end

  if not is_shattered_surface(entry.entity.surface) then
    return "Build on the Shattered Planet"
  end

  local percent = string.format("%.1f", charge_ratio(entry) * 100)
  return "Charging origin singularity: " .. percent .. "%"
end

local function update_progress_bar(entry)
  local surface = entry.entity.surface
  local position = entry.entity.position

  if not entry.progress_background then
    entry.progress_background = rendering.draw_rectangle({
      surface = surface,
      filled = true,
      color = { r = 0.06, g = 0.08, b = 0.1, a = 0.75 },
      left_top = { position.x + BAR_LEFT_TOP.x, position.y + BAR_LEFT_TOP.y },
      right_bottom = { position.x + BAR_RIGHT_BOTTOM.x, position.y + BAR_RIGHT_BOTTOM.y },
      only_in_alt_mode = true,
      draw_on_ground = false,
    }).id
  end

  destroy_render(entry, "progress_fill")

  local ratio = charge_ratio(entry)
  local bottom = position.y + BAR_RIGHT_BOTTOM.y
  local top = bottom - ((BAR_RIGHT_BOTTOM.y - BAR_LEFT_TOP.y) * ratio)
  entry.progress_fill = rendering.draw_rectangle({
    surface = surface,
    filled = true,
    color = is_shattered_surface(entry.entity.surface) and { r = 0.95, g = 0.35, b = 0.16, a = 0.95 } or { r = 0.25, g = 0.35, b = 0.42, a = 0.7 },
    left_top = { position.x + BAR_LEFT_TOP.x + 0.04, top },
    right_bottom = { position.x + BAR_RIGHT_BOTTOM.x - 0.04, bottom - 0.04 },
    only_in_alt_mode = true,
    draw_on_ground = false,
  }).id
end

local function update_display_text(entry)
  local text = current_status(entry)
  if entry.text then
    local render_object = rendering.get_object_by_id(entry.text)
    if render_object then
      render_object.text = text
      update_progress_bar(entry)
      return
    end
  end

  entry.text = rendering.draw_text({
    surface = entry.entity.surface,
    target = entry.entity,
    target_offset = { 0, -3.25 },
    text = text,
    alignment = "center",
    scale = 1.0,
    only_in_alt_mode = true,
    color = { r = 0.95, g = 0.9, b = 0.75 },
  }).id
  update_progress_bar(entry)
end

local function add_structure(entity)
  if not (entity and entity.valid and entity.unit_number) then
    return
  end

  local powersource = entity.surface.create_entity({
    name = POWER_NAME,
    position = entity.position,
    force = entity.force,
    quality = entity.quality,
  })
  powersource.destructible = false

  local entry = {
    unit_number = entity.unit_number,
    entity = entity,
    powersource = powersource,
    finished = false,
  }
  structures()[entity.unit_number] = entry

  if is_shattered_surface(entity.surface) then
    set_activation_power(entry)
  else
    set_idle_power(entry)
  end
  update_display_text(entry)
end

local function complete_victory(force)
  if not (force and force.valid) then
    return
  end

  local finished = finished_forces()
  if finished[force.name] then
    return
  end
  finished[force.name] = true

  game.reset_game_state()
  game.enable_galaxy_of_fame_button = true
  force.print("The Origin Singularity stabilizes. The Shattered Planet yields at last.")
  game.set_game_state({
    game_finished = true,
    player_won = true,
    can_continue = true,
    victorious_force = force,
  })
end

local function on_created(event)
  local entity = event.created_entity or event.entity
  if not (entity and entity.valid and entity.name == STRUCTURE_NAME) then
    return
  end

  add_structure(entity)
  if not is_shattered_surface(entity.surface) then
    entity.force.print("The Origin Singularity can only be awakened on the Shattered Planet.")
  end
end

local function on_removed(event)
  local entity = event.entity
  if not (entity and entity.name == STRUCTURE_NAME and entity.unit_number) then
    return
  end

  cleanup_entry(entity.unit_number)
end

local function rescan_structures()
  local seen = {}

  for _, surface in pairs(game.surfaces) do
    for _, entity in pairs(surface.find_entities_filtered({ name = STRUCTURE_NAME })) do
      seen[entity.unit_number] = true
      if not structures()[entity.unit_number] then
        add_structure(entity)
      end
    end
  end

  for unit_number, entry in pairs(structures()) do
    if not seen[unit_number] or not entry.entity.valid then
      cleanup_entry(unit_number)
    end
  end
end

local function process_structures()
  for _, entry in pairs(structures()) do
    if not entry.entity.valid then
      cleanup_entry(entry.unit_number)
    elseif entry.finished then
      update_display_text(entry)
    elseif is_shattered_surface(entry.entity.surface) then
      set_activation_power(entry)
      if (entry.powersource.energy or 0) >= ACTIVATION_ENERGY * 0.999 then
        entry.finished = true
        entry.entity.surface.create_entity({ name = "big-explosion", position = entry.entity.position })
        entry.entity.surface.create_entity({ name = "spark-explosion-higher", position = entry.entity.position })
        update_display_text(entry)
        complete_victory(entry.entity.force)
      else
        update_display_text(entry)
      end
    else
      entry.powersource.energy = 0
      set_idle_power(entry)
      update_display_text(entry)
    end
  end
end

function M.register_events(registrar)
  registrar:on_event({
    defines.events.on_built_entity,
    defines.events.on_robot_built_entity,
    defines.events.script_raised_built,
    defines.events.script_raised_revive,
    defines.events.on_space_platform_built_entity,
  }, on_created)

  registrar:on_event({
    defines.events.on_player_mined_entity,
    defines.events.on_robot_mined_entity,
    defines.events.on_entity_died,
    defines.events.script_raised_destroy,
    defines.events.on_space_platform_mined_entity,
  }, on_removed)

  registrar:on_nth_tick(PROCESS_INTERVAL, process_structures)
end

function M.on_init()
  disable_original_victory()
  finished_forces()
  structures()
  rescan_structures()
end

function M.on_configuration_changed()
  disable_original_victory()
  finished_forces()
  structures()
  rescan_structures()
end

return M
