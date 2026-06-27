local Shared = require("scripts.memory-shared")

local M = {}

local RESERVOIR_NAME = "fw-spectral-reservoir"
local PACKED_NAME = "fw-spectral-reservoir-packed"
local POWER_NAME = "fw-spectral-reservoir-power-interface"
local COMBINATOR_NAME = "fw-spectral-reservoir-combinator"
local GUI_NAME = "fw_spectral_reservoir_gui"
local FLUID_DIVISOR = 1000
local CONTAMINATION_INTERVAL = 60 * 20

local function ensure_state()
  storage.spectral_reservoir_units = storage.spectral_reservoir_units or {}
end

local function destroy_render_text(entry)
  if entry.text then
    local render_object = rendering.get_object_by_id(entry.text)
    if render_object then
      render_object.destroy()
    end
    entry.text = nil
  end
  if entry.animation then
    local animation = rendering.get_object_by_id(entry.animation)
    if animation then
      animation.destroy()
    end
    entry.animation = nil
  end
end

local function cleanup_entry(unit_number)
  local entry = storage.spectral_reservoir_units and storage.spectral_reservoir_units[unit_number]
  if not entry then
    return
  end

  destroy_render_text(entry)
  Shared.destroy_entity(entry.powersource)
  Shared.destroy_entity(entry.combinator)
  storage.spectral_reservoir_units[unit_number] = nil
end

local function render_fluid_animation(unit_data, fluid_name)
  local fluid = prototypes.fluid[fluid_name]
  if not fluid then
    return
  end

  if unit_data.animation then
    local animation = rendering.get_object_by_id(unit_data.animation)
    if animation then
      animation.destroy()
    end
  end

  local color = fluid.base_color
  unit_data.animation = rendering.draw_animation({
    animation = "fw-spectral-reservoir-fluid-animation",
    tint = {
      math.min(0.9, color.r + 0.2),
      math.min(0.9, color.g + 0.2),
      math.min(0.9, color.b + 0.2),
    },
    render_layer = "higher-object-above",
    target = unit_data.entity,
    surface = unit_data.entity.surface_index,
  }).id
end

local function update_unit_exterior(unit_data, inventory_count)
  unit_data.previous_inventory_count = inventory_count
  local total_count = unit_data.count + inventory_count

  if inventory_count > 0 then
    local visible = unit_data.entity.fluidbox[1]
    local temperature = Shared.combine_temperatures(unit_data.count, unit_data.temperature, inventory_count, visible.temperature)
    visible.temperature = temperature
    unit_data.temperature = temperature
  end

  Shared.update_combinator(unit_data.combinator, { type = "fluid", name = unit_data.item, quality = "normal" }, total_count)
  Shared.update_display_text(unit_data, unit_data.entity, Shared.compactify(total_count))
  Shared.update_power_usage(unit_data, total_count, FLUID_DIVISOR)
end

local function detect_item(unit_data)
  local fluid = unit_data.entity.fluidbox[1]
  if fluid then
    unit_data.entity.fluidbox.set_filter(1, { name = fluid.name, force = true })
    unit_data.item = fluid.name
    unit_data.temperature = fluid.temperature
    render_fluid_animation(unit_data, fluid.name)
    return true
  end
  return false
end

local function update_unit(unit_data, unit_number, force)
  if Shared.validity_check(unit_number, unit_data, force) then
    return
  end

  local changed = false
  if unit_data.item == nil then
    changed = detect_item(unit_data)
  end

  if unit_data.item == nil then
    return
  end

  local inventory_count = unit_data.entity.get_fluid_count(unit_data.item)
  if inventory_count > unit_data.comfortable then
    local amount_removed = unit_data.entity.remove_fluid({
      name = unit_data.item,
      amount = inventory_count - unit_data.comfortable,
    })
    unit_data.temperature = Shared.combine_temperatures(unit_data.count, unit_data.temperature, amount_removed, unit_data.entity.fluidbox[1].temperature)
    unit_data.count = unit_data.count + amount_removed
    inventory_count = inventory_count - amount_removed
    changed = true
  elseif inventory_count < unit_data.comfortable then
    if unit_data.previous_inventory_count ~= inventory_count then
      changed = true
    end

    local to_add = math.min(unit_data.comfortable - inventory_count, unit_data.count)
    if to_add > 0.001 then
      local amount_added = unit_data.entity.insert_fluid({
        name = unit_data.item,
        amount = to_add,
        temperature = unit_data.temperature,
      })
      unit_data.count = unit_data.count - amount_added
      inventory_count = inventory_count + amount_added
    end
  end

  if force or changed then
    update_unit_exterior(unit_data, inventory_count)
  end
end

local function reservoir_load(unit_data)
  if not unit_data.item then
    return 0
  end

  return unit_data.count + unit_data.entity.get_fluid_count(unit_data.item)
end

local function maybe_emit_contamination(unit_data, tick)
  if not (unit_data.item and Shared.can_emit_spoilage()) then
    return
  end

  if tick < (unit_data.next_contamination_tick or 0) then
    return
  end

  local powersource = unit_data.powersource
  if not (powersource and powersource.valid and powersource.electric_buffer_size > 0) then
    return
  end

  local total_count = reservoir_load(unit_data)
  if total_count < unit_data.comfortable * 3 then
    return
  end

  local ratio = powersource.energy / powersource.electric_buffer_size
  if ratio > 0.35 then
    return
  end

  local amount = math.max(4, math.min(20, math.ceil(total_count / 25000)))
  if Shared.emit_spoilage(unit_data.entity, amount) > 0 then
    unit_data.next_contamination_tick = tick + CONTAMINATION_INTERVAL
  end
end

local function build_helper_entities(entity)
  local position = entity.position
  local surface = entity.surface
  local force = entity.force

  local combinator = surface.create_entity({
    name = COMBINATOR_NAME,
    position = { position.x, position.y - 1.25 },
    force = force,
    quality = entity.quality,
  })
  combinator.operable = false
  combinator.destructible = false

  local powersource = surface.create_entity({
    name = POWER_NAME,
    position = position,
    force = force,
    quality = entity.quality,
  })
  powersource.destructible = false

  return powersource, combinator
end

local function extract_tags(event)
  local inventory = event.consumed_items
  return event.tags
    or (inventory
      and not inventory.is_empty()
      and inventory[1].valid_for_read
      and inventory[1].is_item_with_tags
      and inventory[1].tags)
    or nil
end

local function add_reservoir(entity, tags)
  ensure_state()

  local powersource, combinator = build_helper_entities(entity)
  local unit_data = {
    entity = entity,
    comfortable = 0.5 * entity.fluidbox.get_capacity(1),
    powersource = powersource,
    combinator = combinator,
    count = 0,
    lag_id = math.random(0, Shared.update_slots - 1),
    state_table = storage.spectral_reservoir_units,
  }
  storage.spectral_reservoir_units[entity.unit_number] = unit_data

  if tags and tags.name then
    unit_data.count = tags.count or 0
    unit_data.temperature = tags.temperature
    unit_data.item = tags.name
    entity.fluidbox.set_filter(1, { name = tags.name, force = true })
    render_fluid_animation(unit_data, tags.name)
    update_unit(unit_data, entity.unit_number, true)
  else
    Shared.update_power_usage(unit_data, 0, FLUID_DIVISOR)
  end
end

local function on_created(event)
  local entity = event.created_entity or event.entity
  if not (entity and entity.valid and entity.name == RESERVOIR_NAME) then
    return
  end

  add_reservoir(entity, extract_tags(event))
end

local function on_destroyed(event)
  local entity = event.entity
  if not (entity and entity.valid and entity.name == RESERVOIR_NAME) then
    return
  end

  local unit_data = storage.spectral_reservoir_units and storage.spectral_reservoir_units[entity.unit_number]
  if not unit_data then
    return
  end

  destroy_render_text(unit_data)

  if event.buffer and unit_data.item and unit_data.count ~= 0 then
    event.buffer.clear()
    event.buffer.insert({
      name = PACKED_NAME,
      count = 1,
      quality = entity.quality.name,
      health = entity.health / entity.max_health,
      tags = {
        name = unit_data.item,
        count = unit_data.count,
        temperature = unit_data.temperature,
      },
      custom_description = {
        "",
        Shared.compactify(unit_data.count),
        " ",
        prototypes.fluid[unit_data.item].localised_name,
        " @ ",
        string.format("%.2f", unit_data.temperature or 15),
        " C",
      },
    })
  end

  cleanup_entry(entity.unit_number)
end

local function pre_mined(event)
  local entity = event.entity
  if not (entity and entity.valid and entity.name == RESERVOIR_NAME) then
    return
  end

  local unit_data = storage.spectral_reservoir_units and storage.spectral_reservoir_units[entity.unit_number]
  if not (unit_data and unit_data.item) then
    return
  end

  local in_inventory = entity.get_fluid_count(unit_data.item)
  if in_inventory > 0 then
    local temperature = entity.fluidbox[1].temperature
    local new_count = unit_data.count + entity.remove_fluid({ name = unit_data.item, amount = in_inventory })
    unit_data.temperature = Shared.combine_temperatures(unit_data.count, unit_data.temperature, in_inventory, temperature)
    unit_data.count = new_count
  end
end

local function rescan_reservoirs()
  ensure_state()

  local seen = {}
  for _, surface in pairs(game.surfaces) do
    for _, entity in pairs(surface.find_entities_filtered({ name = RESERVOIR_NAME })) do
      seen[entity.unit_number] = true
      if not storage.spectral_reservoir_units[entity.unit_number] then
        add_reservoir(entity)
      end
    end
  end

  for unit_number, unit_data in pairs(storage.spectral_reservoir_units) do
    if not seen[unit_number] or not unit_data.entity.valid then
      cleanup_entry(unit_number)
    end
  end
end

local function update_gui(gui, fresh_gui)
  local unit_data = storage.spectral_reservoir_units[gui.tags.unit_number]
  if not unit_data then
    gui.destroy()
    return
  end

  local content_flow = gui.content_frame.content_flow
  local entity = unit_data.entity
  local powersource = unit_data.powersource
  if not (entity.valid and powersource.valid) then
    return
  end

  local count = unit_data.count
  local inventory_count = 0
  if unit_data.item then
    inventory_count = entity.get_fluid_count(unit_data.item)
    if fresh_gui or not entity.to_be_deconstructed() then
      local localised_name = prototypes.fluid[unit_data.item].localised_name
      content_flow.storage_flow.content_sprite.sprite = "fluid/" .. unit_data.item
      content_flow.storage_flow.current_storage.caption = {
        "",
        { "", "[font=default-semibold][color=255,230,192]", localised_name },
        { "", ":[/color][/font] ", Shared.compactify(count + inventory_count) },
      }

      local temperature = 0
      if inventory_count ~= 0 then
        temperature = Shared.combine_temperatures(unit_data.count, unit_data.temperature, inventory_count, entity.fluidbox[1].temperature)
      end
      content_flow.temperature.caption = {
        "",
        { "", "[font=default-semibold][color=255,230,192]", { "description.fluid-temperature", localised_name } },
        ":[/color][/font] " .. string.format("%.2f", temperature) .. " C",
      }
    end
  end

  local visible = unit_data.item ~= nil
  content_flow.storage_flow.visible = visible
  content_flow.temperature.visible = visible

  content_flow.electric_flow.electricity.value = powersource.energy / math.max(powersource.electric_buffer_size, 1)
  content_flow.electric_flow.consumption.caption = string.format("%.2fMW/%.2fMW", powersource.energy * 60 / 1000000, powersource.electric_buffer_size * 60 / 1000000)
  if unit_data.item then
    Shared.update_power_usage(unit_data, count + inventory_count, FLUID_DIVISOR)
  end

  local status
  local sprite
  if entity.to_be_deconstructed() then
    status = { "entity-status.marked-for-deconstruction" }
    sprite = "utility/status_not_working"
    content_flow.electric_flow.consumption.caption = ""
  elseif powersource.energy == 0 then
    status = { "entity-status.no-power" }
    sprite = "utility/status_not_working"
  elseif not unit_data.item then
    status = { "entity-status.no-input-fluid" }
    sprite = "utility/status_not_working"
  elseif powersource.energy < powersource.electric_buffer_size * 0.9 then
    if unit_data.item and reservoir_load(unit_data) >= unit_data.comfortable * 3 then
      status = "Flux leak risk"
    else
      status = { "entity-status.low-power" }
    end
    sprite = "utility/status_yellow"
  else
    status = { "entity-status.working" }
    sprite = "utility/status_working"
  end

  content_flow.status_flow.status_text.caption = status
  content_flow.status_flow.status_sprite.sprite = sprite
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
  }, on_destroyed)

  registrar.on_event({
    defines.events.on_pre_player_mined_item,
    defines.events.on_robot_pre_mined,
    defines.events.on_marked_for_deconstruction,
    defines.events.on_space_platform_pre_mined,
  }, pre_mined)

  registrar.on_nth_tick(Shared.update_rate, function(event)
    local smooth_ups = event.tick % Shared.update_slots
    for unit_number, unit_data in pairs(storage.spectral_reservoir_units or {}) do
      if unit_data.lag_id == smooth_ups then
        maybe_emit_contamination(unit_data, event.tick)
        update_unit(unit_data, unit_number)
      end
    end
  end)

  registrar.on_nth_tick(2, function()
    for _, player in pairs(game.connected_players) do
      if player.opened_gui_type == defines.gui_type.custom then
        local gui = player.gui.screen[GUI_NAME]
        if gui then
          update_gui(gui)
        end
      end
    end
  end)

  registrar.on_event(defines.events.on_player_changed_surface, function(event)
    local player = game.get_player(event.player_index)
    if player.opened_gui_type == defines.gui_type.custom then
      local gui = player.gui.screen[GUI_NAME]
      if gui then
        gui.destroy()
      end
    end
  end)

  registrar.on_event(defines.events.on_gui_opened, function(event)
    if event.gui_type ~= defines.gui_type.entity or not event.entity or event.entity.name ~= RESERVOIR_NAME then
      return
    end

    local player = game.get_player(event.player_index)
    local main_frame = player.gui.screen.add({
      type = "frame",
      name = GUI_NAME,
      caption = { "entity-name.fw-spectral-reservoir" },
      direction = "vertical",
    })
    main_frame.style.width = 448
    main_frame.tags = { unit_number = event.entity.unit_number }
    main_frame.auto_center = true
    player.opened = main_frame

    local content_frame = main_frame.add({ type = "frame", name = "content_frame", direction = "vertical", style = "inside_shallow_frame_with_padding" })
    local content_flow = content_frame.add({ type = "flow", name = "content_flow", direction = "vertical" })
    content_flow.style.vertical_spacing = 8
    content_flow.style.margin = { -4, 0, -4, 0 }
    content_flow.style.vertical_align = "center"

    local electric_flow = content_flow.add({ type = "flow", name = "electric_flow", direction = "horizontal" })
    electric_flow.style.vertical_align = "center"
    electric_flow.style.horizontal_align = "right"
    electric_flow.style.width = 400
    electric_flow.style.bottom_margin = -32
    electric_flow.add({ type = "label", name = "consumption" }).style.right_margin = 4
    electric_flow.add({ type = "progressbar", name = "electricity", style = "electric_satisfaction_progressbar" }).style.width = 150

    local status_flow = content_flow.add({ type = "flow", name = "status_flow", direction = "horizontal" })
    status_flow.style.vertical_align = "center"
    status_flow.style.top_margin = 4
    local status_sprite = status_flow.add({ type = "sprite", name = "status_sprite" })
    status_sprite.resize_to_sprite = false
    status_sprite.style.size = { 16, 16 }
    status_flow.add({ type = "label", name = "status_text" })

    local entity_preview = content_flow.add({ type = "entity-preview", name = "entity_preview", style = "fw_memory_entity_preview" })
    entity_preview.entity = event.entity
    entity_preview.visible = true
    entity_preview.style.height = 155

    local storage_flow = content_flow.add({ type = "flow", name = "storage_flow", direction = "horizontal" })
    storage_flow.style.vertical_align = "center"
    local content_sprite = storage_flow.add({ type = "sprite", name = "content_sprite" })
    content_sprite.resize_to_sprite = false
    content_sprite.style.size = { 32, 32 }
    storage_flow.add({ type = "label", name = "current_storage" })
    content_flow.add({ type = "label", name = "temperature" })

    update_gui(main_frame, true)
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
end

function M.on_init()
  rescan_reservoirs()
end

function M.on_configuration_changed()
  rescan_reservoirs()
end

return M
