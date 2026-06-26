local M = {}

local GATE_NAME = "fw-rift-exchange-gate"
local POWER_NAME = "fw-rift-exchange-power-interface"
local GUI_NAME = "fw_rift_exchange_gui"
local PROCESS_INTERVAL = 30
local CYCLE_ENERGY = 3000000000
local CYCLE_POWER_USAGE = 150000000
local BAR_LEFT_TOP = { x = 2.45, y = -1.5 }
local BAR_RIGHT_BOTTOM = { x = 2.75, y = 1.5 }
local WILDCARD_IDS = {
  [""] = true,
  anything = true,
  everything = true,
  each = true,
}

local TARGET_STATES = { "Any", "Empty", "Full" }

local function ensure_state()
  storage.rift_exchange = storage.rift_exchange or {}
end

local function destroy_render_text(entry)
  if entry.text then
    local render_object = rendering.get_object_by_id(entry.text)
    if render_object then
      render_object.destroy()
    end
    entry.text = nil
  end

  if entry.progress_background then
    local render_object = rendering.get_object_by_id(entry.progress_background)
    if render_object then
      render_object.destroy()
    end
    entry.progress_background = nil
  end

  if entry.progress_fill then
    local render_object = rendering.get_object_by_id(entry.progress_fill)
    if render_object then
      render_object.destroy()
    end
    entry.progress_fill = nil
  end
end

local function cleanup_entry(unit_number)
  local entry = storage.rift_exchange and storage.rift_exchange[unit_number]
  if not entry then
    return
  end

  destroy_render_text(entry)
  if entry.powersource and entry.powersource.valid then
    entry.powersource.destroy()
  end
  storage.rift_exchange[unit_number] = nil
end

local function set_idle_power(entry)
  entry.powersource.electric_buffer_size = 1
end

local function set_cycle_power(entry)
  entry.powersource.electric_buffer_size = CYCLE_ENERGY
end

local function current_status(entry)
  if entry.active then
    if not (entry.target_unit_number and storage.rift_exchange[entry.target_unit_number]) then
      return "Lost target"
    end
    return string.format("Charging %.1f%%", (entry.powersource.energy / CYCLE_ENERGY) * 100)
  end
  return "Idle"
end

local function charge_ratio(entry)
  if not (entry and entry.powersource and entry.powersource.valid) then
    return 0
  end

  return math.max(0, math.min(1, (entry.powersource.energy or 0) / CYCLE_ENERGY))
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

  if entry.progress_fill then
    local render_object = rendering.get_object_by_id(entry.progress_fill)
    if render_object then
      render_object.destroy()
    end
    entry.progress_fill = nil
  end

  local ratio = charge_ratio(entry)
  local bottom = position.y + BAR_RIGHT_BOTTOM.y
  local top = bottom - ((BAR_RIGHT_BOTTOM.y - BAR_LEFT_TOP.y) * ratio)
  entry.progress_fill = rendering.draw_rectangle({
    surface = surface,
    filled = true,
    color = entry.active and { r = 0.16, g = 0.9, b = 1.0, a = 0.95 } or { r = 0.25, g = 0.35, b = 0.42, a = 0.7 },
    left_top = { position.x + BAR_LEFT_TOP.x + 0.04, top },
    right_bottom = { position.x + BAR_RIGHT_BOTTOM.x - 0.04, bottom - 0.04 },
    only_in_alt_mode = true,
    draw_on_ground = false,
  }).id
end

local function update_display_text(entry)
  local text = entry.active and "Warping" or (entry.destination_name ~= "" and entry.destination_name or "Unset")
  if entry.text then
    local render_object = rendering.get_object_by_id(entry.text)
    if render_object then
      render_object.text = text
      return
    end
  end

  entry.text = rendering.draw_text({
    surface = entry.entity.surface,
    target = entry.entity,
    text = text,
    alignment = "center",
    scale = 1.1,
    only_in_alt_mode = true,
    color = { r = 0.75, g = 0.95, b = 1.0 },
  }).id
  update_progress_bar(entry)
end

local function inventory_state_matches(entry, target_entry)
  local target_inventory = target_entry.entity.get_inventory(defines.inventory.chest)
  local state = string.lower(entry.target_state or "Any")
  if state == "any" then
    return true
  elseif state == "empty" then
    return target_inventory.is_empty()
  elseif state == "full" then
    return target_inventory.is_full()
  end
  return true
end

local function link_ids_match(entry, target_entry)
  local a = string.lower(entry.link_id or "")
  local b = string.lower(target_entry.link_id or "")
  if WILDCARD_IDS[a] or WILDCARD_IDS[b] then
    return true
  end
  return a == b
end

local function quality_matches(entry, target_entry)
  return entry.entity.quality.name == target_entry.entity.quality.name
end

local function candidate_sorter(left, right)
  return left.entity.unit_number < right.entity.unit_number
end

local function surface_label(surface)
  if surface.planet and surface.planet.prototype and surface.planet.prototype.localised_name then
    return surface.planet.prototype.localised_name
  end

  if surface.platform and surface.platform.name and surface.platform.name ~= "" then
    return { "", surface.platform.name, " (", surface.name, ")" }
  end

  if surface.localised_name then
    return surface.localised_name
  end

  if surface.name and surface.name ~= "" then
    return surface.name
  end

  return "Unknown surface"
end

local function find_destination_surfaces()
  local destinations = {}

  for _, surface in pairs(game.surfaces) do
    table.insert(destinations, {
      name = surface.name,
      label = surface_label(surface),
    })
  end

  table.sort(destinations, function(left, right)
    return left.name < right.name
  end)

  local names = {}
  local labels = {}
  for _, destination in ipairs(destinations) do
    table.insert(names, destination.name)
    table.insert(labels, destination.label)
  end

  return names, labels
end

local function find_target(entry)
  local candidates = {}
  for unit_number, candidate in pairs(storage.rift_exchange) do
    if unit_number ~= entry.unit_number
      and candidate.entity.valid
      and (entry.destination_name == "" or candidate.entity.surface.name == entry.destination_name)
      and not candidate.active
      and quality_matches(entry, candidate)
      and link_ids_match(entry, candidate)
      and inventory_state_matches(entry, candidate)
    then
      table.insert(candidates, candidate)
    end
  end

  table.sort(candidates, candidate_sorter)
  return candidates[1]
end

local function swap_inventories(source_inventory, destination_inventory)
  for i = 1, math.min(#source_inventory, #destination_inventory) do
    source_inventory[i].swap_stack(destination_inventory[i])
  end
end

local function play_surface_pulse(surface, position)
  surface.create_entity({ name = "spark-explosion-higher", position = position })
  surface.create_entity({ name = "explosion-hit", position = position })
  surface.create_trivial_smoke({ name = "smoke-fast", position = position })
end

local function play_teleport_effect(entry, target)
  if entry and entry.entity and entry.entity.valid then
    play_surface_pulse(entry.entity.surface, entry.entity.position)
  end

  if target and target.entity and target.entity.valid then
    play_surface_pulse(target.entity.surface, target.entity.position)
  end
end

local function start_cycle(entry)
  if entry.active then
    return
  end

  local target = find_target(entry)
  if not target then
    entry.last_message = "No valid target"
    return
  end

  entry.active = true
  entry.target_unit_number = target.unit_number
  entry.started_tick = game.tick
  entry.stalled_ticks = 0
  entry.last_energy = 0
  entry.last_message = "Cycle started"
  set_cycle_power(entry)
  update_display_text(entry)
end

local function complete_cycle(entry)
  local target = entry.target_unit_number and storage.rift_exchange[entry.target_unit_number] or nil
  if not (target and target.entity.valid and link_ids_match(entry, target) and quality_matches(entry, target)) then
    entry.last_message = "Target unavailable"
  else
    local source_inventory = entry.entity.get_inventory(defines.inventory.chest)
    local target_inventory = target.entity.get_inventory(defines.inventory.chest)
    swap_inventories(source_inventory, target_inventory)
    play_teleport_effect(entry, target)
    entry.last_message = "Teleport complete"
  end

  entry.active = false
  entry.target_unit_number = nil
  entry.started_tick = nil
  entry.stalled_ticks = 0
  entry.last_energy = 0
  entry.powersource.energy = 0
  set_idle_power(entry)
  update_display_text(entry)
end

local function add_gate(entity, tags)
  ensure_state()

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
    destination_name = tags and tags.destination_name or "",
    link_id = tags and tags.link_id or "",
    target_state = tags and tags.target_state or "Any",
    auto_activate = tags and tags.auto_activate or false,
    active = false,
    target_unit_number = nil,
    started_tick = nil,
    last_message = "Idle",
  }
  storage.rift_exchange[entity.unit_number] = entry
  set_idle_power(entry)
  update_display_text(entry)
end

local function extract_tags(event)
  local inventory = event.consumed_items
  return (event.tags and (event.tags.rift_exchange or event.tags))
    or (inventory
      and not inventory.is_empty()
      and inventory[1].valid_for_read
      and inventory[1].is_item_with_tags
      and inventory[1].tags
      and inventory[1].tags.rift_exchange)
    or nil
end

local function on_created(event)
  local entity = event.created_entity or event.entity
  if not (entity and entity.valid and entity.name == GATE_NAME) then
    return
  end

  add_gate(entity, extract_tags(event))
end

local function on_removed(event)
  local entity = event.entity
  if not (entity and entity.valid and entity.name == GATE_NAME) then
    return
  end

  local entry = storage.rift_exchange and storage.rift_exchange[entity.unit_number]
  if entry and event.buffer then
    event.buffer.clear()
    event.buffer.insert({
      name = GATE_NAME,
      count = 1,
      quality = entity.quality.name,
      tags = {
        rift_exchange = {
          destination_name = entry.destination_name,
          link_id = entry.link_id,
          target_state = entry.target_state,
          auto_activate = entry.auto_activate,
        },
      },
    })
  end

  cleanup_entry(entity.unit_number)
end

local function rescan_gates()
  ensure_state()

  local seen = {}
  for _, surface in pairs(game.surfaces) do
    for _, entity in pairs(surface.find_entities_filtered({ name = GATE_NAME })) do
      seen[entity.unit_number] = true
      if not storage.rift_exchange[entity.unit_number] then
        add_gate(entity)
      end
    end
  end

  for unit_number, entry in pairs(storage.rift_exchange) do
    if not seen[unit_number] or not entry.entity.valid then
      cleanup_entry(unit_number)
    end
  end
end

local function process_gates()
  for _, entry in pairs(storage.rift_exchange or {}) do
    if not entry.entity.valid then
      cleanup_entry(entry.unit_number)
    elseif entry.active then
      local current_energy = entry.powersource.energy or 0
      if not (entry.target_unit_number and storage.rift_exchange[entry.target_unit_number]) then
        entry.active = false
        entry.target_unit_number = nil
        entry.started_tick = nil
        entry.stalled_ticks = 0
        entry.last_energy = 0
        entry.last_message = "Target unavailable"
        entry.powersource.energy = 0
        set_idle_power(entry)
        update_display_text(entry)
      elseif entry.powersource.energy >= CYCLE_ENERGY * 0.999 then
        complete_cycle(entry)
      else
        if current_energy <= (entry.last_energy or 0) + 1000 then
          entry.stalled_ticks = (entry.stalled_ticks or 0) + 1
          if entry.stalled_ticks >= 4 then
            entry.last_message = "Insufficient power"
          end
        else
          entry.stalled_ticks = 0
          if entry.last_message == "Insufficient power" then
            entry.last_message = "Cycle started"
          end
        end
        entry.last_energy = current_energy
        update_progress_bar(entry)
      end
    elseif entry.auto_activate and entry.entity.get_inventory(defines.inventory.chest).is_full() then
      start_cycle(entry)
    else
      update_progress_bar(entry)
    end
  end
end

local function dropdown_index_for(entry, names)
  for index, name in ipairs(names) do
    if name == entry.destination_name then
      return index
    end
  end
  return 1
end

local function update_gui(gui)
  local entry = storage.rift_exchange[gui.tags.unit_number]
  if not entry then
    gui.destroy()
    return
  end

  local names = gui.tags.destination_names or {}
  gui.controls.target_state.selected_index = (entry.target_state == "Empty" and 2) or (entry.target_state == "Full" and 3) or 1
  gui.controls.teleport_when_full.state = entry.auto_activate
  gui.controls.link_id.text = entry.link_id or ""
  gui.controls.destination.selected_index = dropdown_index_for(entry, names)
  gui.controls.power.caption = string.format("Power draw: %.1f MW", CYCLE_POWER_USAGE / 1000000)
  gui.controls.buffer.caption = string.format("Charge: %.1f / %.1f MJ", (entry.powersource.energy or 0) / 1000000, CYCLE_ENERGY / 1000000)
  gui.controls.status.caption = current_status(entry)
  gui.controls.message.caption = entry.last_message or ""
  gui.controls.progress.value = charge_ratio(entry)
end

function M.register_events(registrar)
  registrar.on_event({
    defines.events.on_built_entity,
    defines.events.on_robot_built_entity,
    defines.events.script_raised_built,
    defines.events.script_raised_revive,
    defines.events.on_space_platform_built_entity,
  }, on_created)

  registrar.on_event({
    defines.events.on_player_mined_entity,
    defines.events.on_robot_mined_entity,
    defines.events.on_entity_died,
    defines.events.script_raised_destroy,
    defines.events.on_space_platform_mined_entity,
  }, on_removed)

  registrar.on_nth_tick(PROCESS_INTERVAL, process_gates)

  registrar.on_nth_tick(15, function()
    for _, player in pairs(game.connected_players) do
      local gui = player.gui.relative[GUI_NAME]
      if gui then
        update_gui(gui)
      end
    end
  end)

  registrar.on_event(defines.events.on_gui_opened, function(event)
    if event.gui_type ~= defines.gui_type.entity or not event.entity or event.entity.name ~= GATE_NAME then
      return
    end

    local player = game.get_player(event.player_index)
    local entry = storage.rift_exchange[event.entity.unit_number]
    if not entry then
      return
    end

    local names, labels = find_destination_surfaces()
    if #names == 0 then
      names = { "" }
      labels = { "" }
    end

    local frame = player.gui.relative.add({
      type = "frame",
      name = GUI_NAME,
      caption = { "entity-name.fw-rift-exchange-gate" },
      direction = "vertical",
      anchor = {
        gui = defines.relative_gui_type.container_gui,
        position = defines.relative_gui_position.right,
      },
    })
    frame.style.width = 280
    frame.tags = { unit_number = event.entity.unit_number, destination_names = names }

    local inner = frame.add({ type = "frame", style = "inside_shallow_frame_with_padding", direction = "vertical", name = "controls" })
    inner.style.vertically_stretchable = true
    inner.add({ type = "label", caption = "Controls" }).style.font = "default-bold"

    inner.add({ type = "label", caption = "Link ID" })
    local link = inner.add({ type = "textfield", name = "link_id", text = entry.link_id or "" })
    link.tags = { unit_number = event.entity.unit_number }

    inner.add({ type = "label", caption = "Target state" })
    local target_state = inner.add({ type = "drop-down", name = "target_state", items = TARGET_STATES })
    target_state.tags = { unit_number = event.entity.unit_number }

    inner.add({ type = "label", caption = "Destination" })
    local destination = inner.add({ type = "drop-down", name = "destination", items = labels })
    destination.tags = { unit_number = event.entity.unit_number, destination_names = names }

    local checkbox = inner.add({
      type = "checkbox",
      name = "teleport_when_full",
      caption = "Teleport when full",
      state = entry.auto_activate or false,
    })
    checkbox.tags = { unit_number = event.entity.unit_number }

    inner.add({ type = "button", name = "activate", caption = "Activate" }).tags = { unit_number = event.entity.unit_number }
    inner.add({ type = "progressbar", name = "progress" }).style.width = 230
    inner.add({ type = "label", name = "power", caption = "" })
    inner.add({ type = "label", name = "buffer", caption = "" })
    inner.add({ type = "label", name = "status", caption = "" })
    inner.add({ type = "label", name = "message", caption = "" })

    update_gui(frame)
  end)

  registrar.on_event(defines.events.on_gui_closed, function(event)
    local player = game.get_player(event.player_index)
    local gui = player.gui.relative[GUI_NAME]
    if gui then
      gui.destroy()
    end
  end)

  registrar.on_event(defines.events.on_gui_click, function(event)
    local element = event.element
    if not (element and element.valid and element.tags and element.tags.unit_number) then
      return
    end

    if element.name == "activate" then
      local entry = storage.rift_exchange[element.tags.unit_number]
      if entry then
        start_cycle(entry)
      end
    end
  end)

  registrar.on_event(defines.events.on_gui_checked_state_changed, function(event)
    local element = event.element
    if not (element and element.valid and element.tags and element.tags.unit_number and element.name == "teleport_when_full") then
      return
    end

    local entry = storage.rift_exchange[element.tags.unit_number]
    if entry then
      entry.auto_activate = element.state
    end
  end)

  registrar.on_event(defines.events.on_gui_text_changed, function(event)
    local element = event.element
    if not (element and element.valid and element.tags and element.tags.unit_number and element.name == "link_id") then
      return
    end

    local entry = storage.rift_exchange[element.tags.unit_number]
    if entry then
      entry.link_id = element.text or ""
      update_display_text(entry)
    end
  end)

  registrar.on_event(defines.events.on_gui_selection_state_changed, function(event)
    local element = event.element
    if not (element and element.valid and element.tags and element.tags.unit_number) then
      return
    end

    local entry = storage.rift_exchange[element.tags.unit_number]
    if not entry then
      return
    end

    if element.name == "target_state" then
      entry.target_state = TARGET_STATES[element.selected_index] or "Any"
    elseif element.name == "destination" then
      local names = element.tags.destination_names or {}
      entry.destination_name = names[element.selected_index] or ""
      update_display_text(entry)
    end
  end)
end

function M.on_init()
  rescan_gates()
end

function M.on_configuration_changed()
  rescan_gates()
end

return M
