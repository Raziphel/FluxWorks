local Shared = require("scripts.memory-shared")

local M = {}

local VAULT_NAME = "fw-phase-vault"
local PACKED_NAME = "fw-phase-vault-packed"
local POWER_NAME = "fw-phase-vault-power-interface"
local COMBINATOR_NAME = "fw-phase-vault-combinator"
local GUI_NAME = "fw_phase_vault_gui"
local COMBINATOR_SHIFT_X = 2.25
local COMBINATOR_SHIFT_Y = 1.75
local CONTAMINATION_INTERVAL = 60 * 20

local function ensure_state()
  storage.phase_vault_units = storage.phase_vault_units or {}
end

local function destroy_render_text(entry)
  if entry.text then
    local render_object = rendering.get_object_by_id(entry.text)
    if render_object then
      render_object.destroy()
    end
    entry.text = nil
  end
end

local function cleanup_entry(unit_number)
  local entry = storage.phase_vault_units and storage.phase_vault_units[unit_number]
  if not entry then
    return
  end

  destroy_render_text(entry)
  Shared.destroy_entity(entry.powersource)
  Shared.destroy_entity(entry.combinator)
  storage.phase_vault_units[unit_number] = nil
end

local function update_unit_exterior(unit_data, inventory_count)
  unit_data.previous_inventory_count = inventory_count
  local total_count = unit_data.count + inventory_count
  local signal = { type = "item", name = unit_data.item, quality = unit_data.quality or "normal" }

  Shared.update_combinator(unit_data.combinator, signal, total_count)
  Shared.update_display_text(unit_data, unit_data.entity, Shared.compactify(total_count))
  Shared.update_power_usage(unit_data, total_count)
end

local function set_filter(unit_data)
  local inventory = unit_data.inventory
  local item = unit_data.item
  local quality = unit_data.quality

  for i = 1, #inventory do
    local stack = inventory[i]
    local filter = { name = item, quality = quality }

    if not inventory.set_filter(i, filter) or (stack.valid_for_read and (stack.name ~= item or stack.quality.name ~= quality)) then
      unit_data.entity.surface.spill_item_stack({
        position = unit_data.entity.position,
        stack = stack,
        enable_looted = true,
        force = unit_data.entity.force_index,
        allow_belts = false,
        use_start_position_on_failure = true,
      })
      stack.clear()
      inventory.set_filter(i, filter)
    end
  end
end

local function detect_item(unit_data)
  local inventory = unit_data.inventory
  for i = 1, #inventory do
    local stack = inventory[i]
    if stack.valid_for_read then
      if Shared.is_spoilable(stack.name) then
        return false
      end

      unit_data.item = stack.name
      unit_data.quality = stack.quality.name
      unit_data.stack_size = stack.prototype.stack_size
      unit_data.comfortable = unit_data.stack_size * #inventory / 2
      set_filter(unit_data)
      return true
    end
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

  local inventory_count = unit_data.inventory.get_item_count({
    name = unit_data.item,
    quality = unit_data.quality,
  })

  if inventory_count > unit_data.comfortable then
    local amount_removed = unit_data.inventory.remove({
      name = unit_data.item,
      count = inventory_count - unit_data.comfortable,
      quality = unit_data.quality,
    })
    unit_data.count = unit_data.count + amount_removed
    inventory_count = inventory_count - amount_removed
    changed = true
  elseif inventory_count < unit_data.comfortable then
    if unit_data.previous_inventory_count ~= inventory_count then
      changed = true
    end

    local to_add = math.min(unit_data.comfortable - inventory_count, unit_data.count)
    if to_add ~= 0 then
      local amount_added = unit_data.entity.insert({
        name = unit_data.item,
        count = to_add,
        quality = unit_data.quality,
      })
      unit_data.count = unit_data.count - amount_added
      inventory_count = inventory_count + amount_added
    end
  end

  if force or changed then
    unit_data.inventory.sort_and_merge()
    update_unit_exterior(unit_data, inventory_count)
  end
end

local function vault_load(unit_data)
  if not unit_data.item then
    return 0
  end

  return unit_data.count + unit_data.inventory.get_item_count({
    name = unit_data.item,
    quality = unit_data.quality,
  })
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

  local total_count = vault_load(unit_data)
  if total_count < unit_data.comfortable * 3 then
    return
  end

  local ratio = powersource.energy / powersource.electric_buffer_size
  if ratio > 0.35 then
    return
  end

  local amount = math.max(2, math.min(12, math.ceil(total_count / math.max(unit_data.stack_size or 1, 1) / 8)))
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
    position = { position.x + COMBINATOR_SHIFT_X, position.y + COMBINATOR_SHIFT_Y },
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

local function add_vault(entity, tags)
  ensure_state()

  local powersource, combinator = build_helper_entities(entity)
  local unit_data = {
    entity = entity,
    count = 0,
    powersource = powersource,
    combinator = combinator,
    quality = "normal",
    inventory = entity.get_inventory(defines.inventory.chest),
    lag_id = math.random(0, Shared.update_slots - 1),
    state_table = storage.phase_vault_units,
  }
  storage.phase_vault_units[entity.unit_number] = unit_data

  if tags and tags.name and prototypes.item[tags.name] then
    unit_data.count = tags.count or 0
    unit_data.item = tags.name
    unit_data.quality = tags.quality or "normal"
    unit_data.stack_size = prototypes.item[tags.name].stack_size
    unit_data.comfortable = unit_data.stack_size * #unit_data.inventory / 2
    set_filter(unit_data)
    update_unit(unit_data, entity.unit_number, true)
  else
    Shared.update_power_usage(unit_data, 0)
  end
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

local function on_created(event)
  local entity = event.created_entity or event.entity
  if not (entity and entity.valid and entity.name == VAULT_NAME) then
    return
  end

  add_vault(entity, extract_tags(event))
end

local function on_destroyed(event)
  local entity = event.entity
  if not (entity and entity.valid and entity.name == VAULT_NAME) then
    return
  end

  local unit_data = storage.phase_vault_units and storage.phase_vault_units[entity.unit_number]
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
      tags = {
        name = unit_data.item,
        count = unit_data.count,
        quality = unit_data.quality,
      },
      custom_description = {
        "",
        Shared.compactify(unit_data.count),
        " ",
        prototypes.item[unit_data.item].localised_name,
      },
    })
  end

  cleanup_entry(entity.unit_number)
end

local function pre_mined(event)
  local entity = event.entity
  if not (entity and entity.valid and entity.name == VAULT_NAME) then
    return
  end

  local unit_data = storage.phase_vault_units and storage.phase_vault_units[entity.unit_number]
  if not (unit_data and unit_data.item) then
    return
  end

  local in_inventory = unit_data.inventory.get_item_count({
    name = unit_data.item,
    quality = unit_data.quality,
  })

  if in_inventory > 0 then
    unit_data.count = unit_data.count + unit_data.inventory.remove({
      name = unit_data.item,
      count = in_inventory,
      quality = unit_data.quality,
    })
  end
end

local function rescan_vaults()
  ensure_state()

  local seen = {}
  for _, surface in pairs(game.surfaces) do
    for _, entity in pairs(surface.find_entities_filtered({ name = VAULT_NAME })) do
      seen[entity.unit_number] = true
      if not storage.phase_vault_units[entity.unit_number] then
        add_vault(entity)
      end
    end
  end

  for unit_number, unit_data in pairs(storage.phase_vault_units) do
    if not seen[unit_number] or not unit_data.entity.valid then
      cleanup_entry(unit_number)
    end
  end
end

local function update_gui(gui, fresh_gui)
  local unit_data = storage.phase_vault_units[gui.tags.unit_number]
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
    inventory_count = unit_data.inventory.get_item_count({
      name = unit_data.item,
      quality = unit_data.quality,
    })

    if fresh_gui or not entity.to_be_deconstructed() then
      content_flow.storage_flow.content_sprite.sprite = "item/" .. unit_data.item
      content_flow.storage_flow.current_storage.caption = {
        "",
        { "", "[font=default-semibold][color=255,230,192]", prototypes.item[unit_data.item].localised_name },
        { "", ":[/color][/font] ", Shared.compactify(count + inventory_count) },
      }
    end
  end

  local visible = unit_data.item ~= nil
  content_flow.storage_flow.visible = visible
  content_flow.storage_separator.visible = visible
  content_flow.io_flow.visible = visible
  content_flow.no_input_item.visible = not visible

  content_flow.electric_flow.electricity.value = powersource.energy / math.max(powersource.electric_buffer_size, 1)
  content_flow.electric_flow.consumption.caption = string.format("%.2fMW/%.2fMW", powersource.energy * 60 / 1000000, powersource.electric_buffer_size * 60 / 1000000)
  if unit_data.item then
    Shared.update_power_usage(unit_data, count + inventory_count)
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
    local invalid_name = nil
    for i = 1, #unit_data.inventory do
      local stack = unit_data.inventory[i]
      if stack.valid_for_read and Shared.is_spoilable(stack.name) then
        invalid_name = stack.name
        break
      end
    end

    if invalid_name then
      status = { "entity-status.cannot-store", prototypes.item[invalid_name].localised_name }
    else
      status = { "entity-status.no-input-item" }
    end
    sprite = "utility/status_not_working"
  elseif powersource.energy < powersource.electric_buffer_size * 0.9 then
    if unit_data.item and vault_load(unit_data) >= unit_data.comfortable * 3 then
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

local function bulk_io(event, element)
  local player = game.get_player(event.player_index)
  if player.controller_type == defines.controllers.remote then
    return
  end

  local inventory = player.get_main_inventory()
  if not inventory then
    return
  end

  local unit_data = storage.phase_vault_units[element.tags.unit_number]
  if not (unit_data and unit_data.item) then
    return
  end

  local count = (event.button == defines.mouse_button_type.right) and unit_data.stack_size * #inventory or unit_data.stack_size

  if element.name == "bulk_insert" then
    local amount_removed = inventory.remove({
      name = unit_data.item,
      count = count,
      quality = unit_data.quality,
    })
    unit_data.count = unit_data.count + amount_removed
  else
    local inventory_count = unit_data.inventory.get_item_count({
      name = unit_data.item,
      quality = unit_data.quality,
    })
    count = math.min(count, inventory_count + unit_data.count)
    if count == 0 then
      return
    end

    local amount_inserted = inventory.insert({
      name = unit_data.item,
      count = count,
      quality = unit_data.quality,
    })
    unit_data.count = unit_data.count - amount_inserted
    if unit_data.count < 0 then
      unit_data.inventory.remove({
        name = unit_data.item,
        count = -unit_data.count,
        quality = unit_data.quality,
      })
      unit_data.count = 0
    end
  end

  update_unit(unit_data, element.tags.unit_number, true)
end

local function prime_unit(event, element)
  local player = game.get_player(event.player_index)
  local stack = player.cursor_stack
  if not stack.valid_for_read then
    return
  end

  if Shared.is_spoilable(stack.name) then
    player.create_local_flying_text({
      text = { "entity-status.cannot-store", stack.prototype.localised_name },
      create_at_cursor = true,
    })
    return
  end

  local unit_data = storage.phase_vault_units[element.tags.unit_number]
  unit_data.count = stack.count
  unit_data.item = stack.name
  unit_data.quality = stack.quality.name
  unit_data.stack_size = stack.prototype.stack_size
  unit_data.comfortable = unit_data.stack_size * #unit_data.inventory / 2
  set_filter(unit_data)
  stack.clear()

  update_unit(unit_data, element.tags.unit_number, true)
  update_gui(player.gui.relative[GUI_NAME], true)
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
    for unit_number, unit_data in pairs(storage.phase_vault_units or {}) do
      if unit_data.lag_id == smooth_ups then
        maybe_emit_contamination(unit_data, event.tick)
        update_unit(unit_data, unit_number)
      end
    end
  end)

  registrar.on_nth_tick(2, function()
    for _, player in pairs(game.connected_players) do
      if player.opened_gui_type == defines.gui_type.item then
        local gui = player.gui.relative[GUI_NAME]
        if gui then
          update_gui(gui)
        end
      end
    end
  end)

  registrar.on_event(defines.events.on_player_changed_surface, function(event)
    local player = game.get_player(event.player_index)
    if player.opened_gui_type == defines.gui_type.item then
      local gui = player.gui.relative[GUI_NAME]
      if gui then
        gui.destroy()
      end
    end
  end)

  registrar.on_event(defines.events.on_gui_opened, function(event)
    if event.gui_type ~= defines.gui_type.entity or not event.entity or event.entity.name ~= VAULT_NAME then
      return
    end

    local player = game.get_player(event.player_index)
    Shared.open_inventory(player)

    local main_frame = player.gui.relative.add({
      type = "frame",
      name = GUI_NAME,
      caption = { "entity-name.fw-phase-vault" },
      direction = "vertical",
      anchor = {
        gui = defines.relative_gui_type.item_with_inventory_gui,
        position = defines.relative_gui_position.right,
      },
    })
    main_frame.style.width = 448
    main_frame.tags = { unit_number = event.entity.unit_number }

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

    content_flow.add({ type = "line", name = "storage_separator" })

    local io_flow = content_flow.add({ type = "flow", name = "io_flow", direction = "horizontal" })
    io_flow.style.vertical_align = "center"
    local bulk_insert = io_flow.add({ type = "sprite-button", name = "bulk_insert", style = "inventory_slot", sprite = "fw-bulk-insert" })
    bulk_insert.tags = { unit_number = event.entity.unit_number }
    local bulk_extract = io_flow.add({ type = "sprite-button", name = "bulk_extract", style = "inventory_slot", sprite = "fw-bulk-extract" })
    bulk_extract.tags = { unit_number = event.entity.unit_number }

    local no_input_item = content_flow.add({ type = "sprite-button", name = "no_input_item", style = "inventory_slot" })
    no_input_item.tags = { unit_number = event.entity.unit_number }

    update_gui(main_frame, true)
  end)

  registrar.on_event(defines.events.on_gui_closed, function(event)
    local player = game.get_player(event.player_index)
    if event.gui_type == defines.gui_type.item then
      local gui = player.gui.relative[GUI_NAME]
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

    if element.name == "bulk_insert" or element.name == "bulk_extract" then
      bulk_io(event, element)
    elseif element.name == "no_input_item" then
      prime_unit(event, element)
    end
  end)
end

function M.on_init()
  rescan_vaults()
end

function M.on_configuration_changed()
  rescan_vaults()
end

return M
