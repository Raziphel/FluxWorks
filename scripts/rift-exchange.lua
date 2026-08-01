local Shared = require("scripts.memory-shared")

local M = {}

local ITEM_GATE_NAME = "fw-rift-exchange-gate"
local ITEM_POWER_NAME = "fw-rift-exchange-power-interface"
local FLUID_GATE_NAME = "fw-rift-exchange-fluid-gate"
local FLUID_POWER_NAME = "fw-rift-exchange-fluid-power-interface"
local GUI_NAME = "fw_rift_exchange_gui"
local PROCESS_INTERVAL = 30
local CYCLE_ENERGY = 10000000000
local CYCLE_POWER_USAGE = 1000000000
local BAR_LEFT_TOP = { x = 2.45, y = -1.5 }
local BAR_RIGHT_BOTTOM = { x = 2.75, y = 1.5 }
local CONTAMINATION_INTERVAL = 60 * 25
local WILDCARD_IDS = {
  [""] = true,
  anything = true,
  everything = true,
  each = true,
}

local GATE_CONFIGS = {
  [ITEM_GATE_NAME] = {
    kind = "item",
    power_name = ITEM_POWER_NAME,
    storage_name = defines.inventory.chest,
  },
  [FLUID_GATE_NAME] = {
    kind = "fluid",
    power_name = FLUID_POWER_NAME,
    storage_name = 1,
  },
}

local ACTIVATION_MODES = { "manual", "full", "signal" }
local ACTIVATION_MODE_ITEMS = {
  { "mod-gui.fw-rift-activation-manual" },
  { "mod-gui.fw-rift-activation-full" },
  { "mod-gui.fw-rift-activation-signal" },
}

local surface_label

local function gate_text(key, ...)
  return { "mod-gui." .. key, ... }
end

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
      return gate_text("fw-rift-status-lost-target")
    end
    return gate_text("fw-rift-status-charging", string.format("%.1f", (entry.powersource.energy / CYCLE_ENERGY) * 100))
  end
  return gate_text("fw-rift-status-idle")
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
  local text = gate_text("fw-rift-display-unset")
  if entry.active then
    text = gate_text("fw-rift-display-warping")
  elseif entry.destination_name ~= "" then
    local surface = game.get_surface(entry.destination_name)
    text = surface and surface_label(surface) or entry.destination_name
  end
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

local function activation_mode_index(entry)
  for index, mode in ipairs(ACTIVATION_MODES) do
    if mode == entry.activation_mode then
      return index
    end
  end
  return 1
end

local function is_gate_full(entry)
  if entry.mode == "fluid" then
    local capacity = entry.entity.get_fluid_capacity(1) or 0
    return capacity > 0 and entry.entity.get_fluid_count() >= capacity * 0.99
  end

  local inventory = entry.entity.get_inventory(defines.inventory.chest)
  return inventory and inventory.is_full()
end

local function has_signal_trigger(entry)
  local signals = entry.entity.get_signals(
    defines.wire_connector_id.circuit_red,
    defines.wire_connector_id.circuit_green
  )

  if not signals then
    return false
  end

  for _, signal in ipairs(signals) do
    if (signal.count or 0) > 0 then
      return true
    end
  end

  return false
end

local function should_auto_start(entry)
  if entry.activation_mode == "signal" then
    return has_signal_trigger(entry)
  elseif entry.activation_mode == "full" then
    return is_gate_full(entry)
  end
  return false
end

local function mode_matches(entry, target_entry)
  return entry.mode == target_entry.mode
end

local function fluid_contents_snapshot(entity)
  local contents = entity.get_fluid_contents() or {}
  for fluid_name, amount in pairs(contents) do
    if amount and amount > 0 then
      local fluid = entity.get_fluid(1)
      local temperature = fluid and fluid.temperature or nil
      return fluid_name, amount, temperature
    end
  end
  local fluid = entity.get_fluid(1)
  local temperature = fluid and fluid.temperature or nil
  return nil, 0, temperature
end

local function swap_fluids(source_entity, target_entity)
  local source_name, source_amount, source_temperature = fluid_contents_snapshot(source_entity)
  local target_name, target_amount, target_temperature = fluid_contents_snapshot(target_entity)

  if source_name and source_amount > 0 then
    source_entity.remove_fluid(1, source_amount)
  end
  if target_name and target_amount > 0 then
    target_entity.remove_fluid(1, target_amount)
  end

  if target_name and target_amount > 0 then
    source_entity.add_fluid(1, {
      name = target_name,
      amount = target_amount,
      temperature = target_temperature,
    })
  end
  if source_name and source_amount > 0 then
    target_entity.add_fluid(1, {
      name = source_name,
      amount = source_amount,
      temperature = source_temperature,
    })
  end
end

local function candidate_sorter(left, right)
  return left.entity.unit_number < right.entity.unit_number
end

surface_label = function(surface)
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
      and mode_matches(entry, candidate)
      and (entry.destination_name == "" or candidate.entity.surface.name == entry.destination_name)
      and not candidate.active
      and quality_matches(entry, candidate)
      and link_ids_match(entry, candidate)
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
    entry.last_message = gate_text("fw-rift-message-no-valid-target")
    return
  end

  entry.active = true
  entry.target_unit_number = target.unit_number
  entry.started_tick = game.tick
  entry.stalled_ticks = 0
  entry.last_energy = 0
  entry.last_message = gate_text("fw-rift-message-cycle-started")
  set_cycle_power(entry)
  update_display_text(entry)
end

local function complete_cycle(entry)
  local target = entry.target_unit_number and storage.rift_exchange[entry.target_unit_number] or nil
  if not (target and target.entity.valid and mode_matches(entry, target) and link_ids_match(entry, target) and quality_matches(entry, target)) then
    entry.last_message = gate_text("fw-rift-message-target-unavailable")
  else
    if entry.mode == "fluid" then
      swap_fluids(entry.entity, target.entity)
    else
      local source_inventory = entry.entity.get_inventory(defines.inventory.chest)
      local target_inventory = target.entity.get_inventory(defines.inventory.chest)
      swap_inventories(source_inventory, target_inventory)
    end
    play_teleport_effect(entry, target)
    entry.last_message = gate_text("fw-rift-message-teleport-complete")
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
  local config = GATE_CONFIGS[entity.name]
  if not config then
    return
  end

  local powersource = entity.surface.create_entity({
    name = config.power_name,
    position = entity.position,
    force = entity.force,
    quality = entity.quality,
  })
  powersource.destructible = false

  local entry = {
    unit_number = entity.unit_number,
    entity = entity,
    mode = config.kind,
    config = config,
    powersource = powersource,
    destination_name = tags and tags.destination_name or "",
    link_id = tags and tags.link_id or "",
    activation_mode = (tags and tags.activation_mode) or ((tags and tags.auto_activate) and "full") or "manual",
    active = false,
    target_unit_number = nil,
    started_tick = nil,
    last_message = gate_text("fw-rift-message-idle"),
  }
  storage.rift_exchange[entity.unit_number] = entry
  set_idle_power(entry)
  if entry.mode == "fluid" and tags and tags.name and (tags.count or 0) > 0 then
    entity.add_fluid(1, {
      name = tags.name,
      amount = tags.count or 0,
      temperature = tags.temperature,
    })
  end
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
  if not (entity and entity.valid and GATE_CONFIGS[entity.name]) then
    return
  end

  add_gate(entity, extract_tags(event))
end

local function on_removed(event)
  local entity = event.entity
  if not (entity and entity.valid and GATE_CONFIGS[entity.name]) then
    return
  end

  local entry = storage.rift_exchange and storage.rift_exchange[entity.unit_number]
  if entry and event.buffer then
    local tags = {
      destination_name = entry.destination_name,
      link_id = entry.link_id,
      activation_mode = entry.activation_mode,
    }
    if entry.mode == "fluid" then
      local fluid_name, fluid_amount, fluid_temperature = fluid_contents_snapshot(entity)
      if fluid_name and fluid_amount > 0 then
        tags.name = fluid_name
        tags.count = fluid_amount
        tags.temperature = fluid_temperature
      end
    end
    event.buffer.clear()
    event.buffer.insert({
      name = entity.name,
      count = 1,
      quality = entity.quality.name,
      tags = {
        rift_exchange = tags,
      },
    })
  end

  cleanup_entry(entity.unit_number)
end

local function rescan_gates()
  ensure_state()

  local seen = {}
  for _, surface in pairs(game.surfaces) do
    for _, gate_name in pairs({ ITEM_GATE_NAME, FLUID_GATE_NAME }) do
      for _, entity in pairs(surface.find_entities_filtered({ name = gate_name })) do
        seen[entity.unit_number] = true
        if not storage.rift_exchange[entity.unit_number] then
          add_gate(entity)
        end
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
        entry.last_message = gate_text("fw-rift-message-target-unavailable")
        entry.powersource.energy = 0
        set_idle_power(entry)
        update_display_text(entry)
      elseif entry.powersource.energy >= CYCLE_ENERGY * 0.999 then
        complete_cycle(entry)
      else
        if current_energy <= (entry.last_energy or 0) + 1000 then
          entry.stalled_ticks = (entry.stalled_ticks or 0) + 1
          if entry.stalled_ticks >= 4 then
            entry.last_message = gate_text("fw-rift-message-insufficient-power")
            if entry.mode == "item" and Shared.can_emit_spoilage() and game.tick >= (entry.next_contamination_tick or 0) then
              local inventory = entry.entity.get_inventory(defines.inventory.chest)
              local stored = inventory and inventory.get_item_count() or 0
              if stored > 0 then
                local amount = math.max(4, math.min(18, math.ceil(stored / 8)))
                if Shared.emit_spoilage(entry.entity, amount) > 0 then
                  entry.next_contamination_tick = game.tick + CONTAMINATION_INTERVAL
                end
              end
            end
          end
        else
          entry.stalled_ticks = 0
          entry.last_message = gate_text("fw-rift-message-cycle-started")
        end
        entry.last_energy = current_energy
        update_progress_bar(entry)
      end
    elseif should_auto_start(entry) then
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

local function format_storage_amount(amount)
  if amount >= 1000000 then
    return string.format("%.1fM", amount / 1000000)
  elseif amount >= 1000 then
    return string.format("%.1fk", amount / 1000)
  end
  return tostring(math.floor(amount))
end

local function format_energy_amount(amount)
  if amount >= 1000000000 then
    return string.format("%.1f GJ", amount / 1000000000)
  elseif amount >= 1000000 then
    return string.format("%.1f MJ", amount / 1000000)
  elseif amount >= 1000 then
    return string.format("%.1f kJ", amount / 1000)
  end
  return string.format("%.0f J", amount)
end

local function format_power_amount(amount)
  if amount >= 1000000000 then
    return string.format("%.1f GW", amount / 1000000000)
  elseif amount >= 1000000 then
    return string.format("%.1f MW", amount / 1000000)
  elseif amount >= 1000 then
    return string.format("%.1f kW", amount / 1000)
  end
  return string.format("%.0f W", amount)
end

local function stack_sprite(stack)
  if stack and stack.valid_for_read then
    return "item/" .. stack.name
  end
  return nil
end

local function stack_tooltip(stack)
  if stack and stack.valid_for_read then
    return { "", { "item-name." .. stack.name }, " x", tostring(stack.count) }
  end
  return gate_text("fw-rift-empty-slot")
end

local function occupied_slot_count(inventory)
  if not inventory then
    return 0
  end

  local occupied = 0
  for i = 1, #inventory do
    local stack = inventory[i]
    if stack and stack.valid_for_read then
      occupied = occupied + 1
    end
  end
  return occupied
end

local function build_item_storage_panel(parent, entry)
  local storage_frame = parent.add({
    type = "frame",
    name = "storage_frame",
    direction = "vertical",
    style = "inside_shallow_frame_with_padding",
  })
  storage_frame.style.top_margin = 6

  storage_frame.add({ type = "label", name = "storage_title", caption = gate_text("fw-rift-item-storage-title") }).style.font = "default-bold"
  storage_frame.add({ type = "label", name = "storage_summary", caption = "" })

  local chest_frame = storage_frame.add({
    type = "frame",
    name = "chest_frame",
    direction = "vertical",
    style = "slot_button_deep_frame",
  })
  chest_frame.style.top_margin = 4
  chest_frame.style.padding = 8

  local inventory_grid = chest_frame.add({
    type = "table",
    name = "inventory_grid",
    column_count = 8,
  })
  inventory_grid.style.horizontal_spacing = 2
  inventory_grid.style.vertical_spacing = 2

  local inventory = entry.entity.get_inventory(defines.inventory.chest)
  for i = 1, 48 do
    local stack = inventory and inventory[i] or nil
    local slot = inventory_grid.add({
      type = "sprite-button",
      name = "slot_" .. i,
      style = "inventory_slot",
      sprite = stack_sprite(stack),
    })
    slot.enabled = false
    slot.number = stack and stack.valid_for_read and stack.count or 0
    slot.tooltip = stack_tooltip(stack)
  end

  return storage_frame
end

local function build_fluid_storage_panel(parent, entry)
  local storage_frame = parent.add({
    type = "frame",
    name = "storage_frame",
    direction = "vertical",
    style = "inside_shallow_frame_with_padding",
  })
  storage_frame.style.top_margin = 6

  storage_frame.add({ type = "label", name = "storage_title", caption = gate_text("fw-rift-fluid-storage-title") }).style.font = "default-bold"
  storage_frame.add({ type = "label", name = "storage_summary", caption = "" })

  local meter_flow = storage_frame.add({ type = "flow", name = "meter_flow", direction = "horizontal" })
  meter_flow.style.vertical_align = "center"
  meter_flow.style.horizontal_spacing = 10

  local fluid_icon = meter_flow.add({
    type = "sprite",
    name = "fluid_icon",
  })
  fluid_icon.resize_to_sprite = false
  fluid_icon.style.size = { 40, 40 }

  local meter_stack = meter_flow.add({ type = "flow", name = "meter_stack", direction = "vertical" })
  meter_stack.style.vertical_spacing = 2
  meter_stack.add({ type = "progressbar", name = "fluid_fill", value = 0 }).style.width = 250
  meter_stack.add({ type = "label", name = "fluid_state", caption = "" })

  return storage_frame
end

local function build_gui(player, entry, names, labels)
  local existing = player.gui.screen[GUI_NAME]
  if existing then
    existing.destroy()
  end

  local frame = player.gui.screen.add({
    type = "frame",
    name = GUI_NAME,
    caption = { "entity-name." .. entry.entity.name },
    direction = "vertical",
  })
  frame.style.width = 520
  frame.auto_center = true
  frame.tags = {
    unit_number = entry.unit_number,
    destination_names = names,
  }
  player.opened = frame

  local content = frame.add({
    type = "frame",
    name = "content_frame",
    direction = "vertical",
    style = "inside_shallow_frame_with_padding",
  })
  local content_flow = content.add({ type = "flow", name = "content_flow", direction = "vertical" })
  content_flow.style.vertical_spacing = 6

  local preview = content_flow.add({ type = "entity-preview", name = "entity_preview", style = "fw_memory_entity_preview" })
  preview.entity = entry.entity
  preview.visible = true
  preview.style.height = 160

  local settings = content_flow.add({ type = "frame", name = "settings", direction = "vertical", style = "inside_shallow_frame_with_padding" })
  local controls = settings.add({ type = "flow", name = "controls", direction = "vertical" })
  controls.style.vertical_spacing = 4
  controls.add({ type = "label", caption = gate_text("fw-rift-controls") }).style.font = "default-bold"

  controls.add({ type = "label", caption = gate_text("fw-rift-link-id") })
  local link = controls.add({ type = "textfield", name = "link_id", text = entry.link_id or "" })
  link.tags = { unit_number = entry.unit_number }

  controls.add({ type = "label", caption = gate_text("fw-rift-destination") })
  local destination = controls.add({ type = "drop-down", name = "destination", items = labels })
  destination.tags = { unit_number = entry.unit_number, destination_names = names }

  controls.add({ type = "label", caption = gate_text("fw-rift-activation-mode") })
  local activation_mode = controls.add({ type = "drop-down", name = "activation_mode", items = ACTIVATION_MODE_ITEMS })
  activation_mode.tags = { unit_number = entry.unit_number }

  controls.add({ type = "button", name = "activate", caption = gate_text("fw-rift-activate") }).tags = { unit_number = entry.unit_number }
  controls.add({ type = "progressbar", name = "progress", value = 0 }).style.width = 280
  controls.add({ type = "label", name = "power", caption = "" })
  controls.add({ type = "label", name = "buffer", caption = "" })
  controls.add({ type = "label", name = "status", caption = "" })
  controls.add({ type = "label", name = "message", caption = "" })

  if entry.mode == "fluid" then
    build_fluid_storage_panel(content_flow, entry)
  else
    build_item_storage_panel(content_flow, entry)
  end

  return frame
end

local function update_gui(gui)
  local entry = storage.rift_exchange[gui.tags.unit_number]
  if not entry then
    gui.destroy()
    return
  end

  local names = gui.tags.destination_names or {}
  if entry.destination_name == "" and names[1] then
    entry.destination_name = names[1]
    update_display_text(entry)
  end
  local controls = gui.content_frame.content_flow.settings.controls
  controls.activation_mode.selected_index = activation_mode_index(entry)
  controls.link_id.text = entry.link_id or ""
  controls.destination.selected_index = dropdown_index_for(entry, names)
  controls.power.caption = gate_text("fw-rift-power-draw", format_power_amount(CYCLE_POWER_USAGE))
  controls.buffer.caption = gate_text("fw-rift-charge", format_energy_amount(entry.powersource.energy or 0), format_energy_amount(CYCLE_ENERGY))
  controls.status.caption = current_status(entry)
  controls.message.caption = entry.last_message or ""
  controls.progress.value = charge_ratio(entry)

  local storage_frame = gui.content_frame.content_flow.storage_frame
  if storage_frame then
    if entry.mode == "fluid" then
      local fluid_name, fluid_amount, fluid_temperature = fluid_contents_snapshot(entry.entity)
      local capacity = entry.entity.get_fluid_capacity(1) or 0
      storage_frame.storage_summary.caption = gate_text("fw-rift-fluid-storage-summary", format_storage_amount(fluid_amount), format_storage_amount(capacity))
      storage_frame.meter_flow.fluid_icon.sprite = fluid_name and ("fluid/" .. fluid_name) or nil
      storage_frame.meter_flow.fluid_icon.tooltip = fluid_name and { "fluid-name." .. fluid_name } or gate_text("fw-rift-no-fluid")
      storage_frame.meter_flow.meter_stack.fluid_fill.value = capacity > 0 and math.max(0, math.min(1, fluid_amount / capacity)) or 0
      storage_frame.meter_flow.meter_stack.fluid_state.caption = fluid_name and gate_text("fw-rift-fluid-state", fluid_temperature and string.format("%.0f", fluid_temperature) or "?", format_storage_amount(fluid_amount)) or gate_text("fw-rift-no-fluid")
    else
      local inventory = entry.entity.get_inventory(defines.inventory.chest)
      local stored = occupied_slot_count(inventory)
      local capacity = inventory and #inventory or 0
      storage_frame.storage_summary.caption = gate_text("fw-rift-item-storage-summary", format_storage_amount(stored), format_storage_amount(capacity))

      local grid = storage_frame.inventory_grid
      if grid then
        for i = 1, 48 do
          local slot = grid["slot_" .. i]
          if slot then
            local stack = inventory and inventory[i] or nil
            slot.sprite = stack_sprite(stack)
            slot.number = stack and stack.valid_for_read and stack.count or 0
            slot.tooltip = stack_tooltip(stack)
          end
        end
      end
    end
  end
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
      local gui = player.gui.screen[GUI_NAME]
      if gui then
        update_gui(gui)
      end
    end
  end)

  registrar.on_event(defines.events.on_gui_opened, function(event)
    if event.gui_type ~= defines.gui_type.entity or not event.entity or not GATE_CONFIGS[event.entity.name] then
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

    local frame = build_gui(player, entry, names, labels)
    update_gui(frame)
  end)

  registrar.on_event(defines.events.on_gui_closed, function(event)
    local player = game.get_player(event.player_index)
    if event.gui_type == defines.gui_type.custom then
      local gui = player.gui.screen[GUI_NAME]
      if gui then
        gui.destroy()
      end
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

    if element.name == "activation_mode" then
      entry.activation_mode = ACTIVATION_MODES[element.selected_index] or "manual"
    elseif element.name == "destination" then
      local names = select(1, find_destination_surfaces())
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
