local min = math.min
local floor = math.floor

local M = {}

local power_usages = {
  ["0W"] = 0,
  ["60kW"] = 1000,
  ["180kW"] = 3000,
  ["300kW"] = 5000,
  ["480kW"] = 8000,
  ["600kW"] = 10000,
  ["1.2MW"] = 20000,
  ["2.4MW"] = 40000,
  ["3.6MW"] = 40000 / 2.4 * 3.6,
  ["5MW"] = 40000 / 2.4 * 5,
  ["10MW"] = 40000 / 2.4 * 10,
  ["20MW"] = 40000 / 2.4 * 20,
  ["50MW"] = 40000 / 2.4 * 50,
}

local base_usage = 1000000 / 60

M.update_rate = 15
M.update_slots = 4
M.spoilage_item = "spoilage"

function M.compactify(n)
  n = floor(n)

  local suffix = 1
  while n >= 1000 do
    local new = floor(n / 100) / 10
    if n == new then
      return { "big-numbers.infinity" }
    end
    n = new
    suffix = suffix + 1
  end

  if suffix ~= 1 and floor(n) == n then
    n = tostring(n) .. ".0"
  end

  return { "big-numbers." .. suffix, n }
end

function M.open_inventory(player)
  if not storage.empty_gui_item then
    local inventory = game.create_inventory(1)
    inventory[1].set_stack("fw-memory-gui-item")
    inventory[1].allow_manual_label_change = false
    storage.empty_gui_item = inventory[1]
  end

  player.opened = nil
  player.opened = storage.empty_gui_item
  return player.opened
end

function M.update_display_text(unit_data, entity, localised_string)
  if unit_data.text then
    local render_object = rendering.get_object_by_id(unit_data.text)
    if render_object then
      render_object.text = localised_string
      return
    end
  end

  unit_data.text = rendering.draw_text({
    surface = entity.surface,
    target = entity,
    text = localised_string,
    alignment = "center",
    scale = 1.5,
    only_in_alt_mode = true,
    color = { r = 1, g = 1, b = 1 },
  }).id
end

function M.update_combinator(combinator, signal, count)
  local control = combinator.get_or_create_control_behavior()
  count = min(2147483647, count)

  control.get_section(1).set_slot(1, {
    value = signal,
    min = count,
    max = count,
    count = count,
  })
end

function M.update_power_usage(unit_data, count, divisor)
  local powersource = unit_data.powersource
  local scale = power_usages[settings.global["fw-memory-unit-power-usage"].value] or power_usages["300kW"]
  local power_usage = (math.ceil(count / (divisor or unit_data.stack_size or 1000)) ^ 0.35) * scale
  power_usage = power_usage + base_usage
  powersource.power_usage = power_usage
  powersource.electric_buffer_size = power_usage
end

function M.has_power(powersource, entity)
  if powersource.energy < powersource.electric_buffer_size * 0.9 then
    if powersource.energy ~= 0 then
      rendering.draw_sprite({
        sprite = "utility.electricity_icon",
        x_scale = 0.5,
        y_scale = 0.5,
        target = entity,
        surface = entity.surface,
        time_to_live = 30,
      })
    end
    return false
  end

  return not entity.to_be_deconstructed()
end

function M.is_spoilable(item_name)
  return prototypes.item[item_name].get_spoil_ticks() ~= 0
end

function M.can_emit_spoilage()
  return prototypes.item[M.spoilage_item] ~= nil
end

function M.emit_spoilage(entity, amount)
  if not (entity and entity.valid and amount and amount > 0 and M.can_emit_spoilage()) then
    return 0
  end

  entity.surface.create_trivial_smoke({
    name = "smoke-fast",
    position = entity.position,
  })
  entity.surface.create_entity({
    name = "spark-explosion-higher",
    position = entity.position,
  })

  local spilled = entity.surface.spill_item_stack({
    position = entity.position,
    stack = { name = M.spoilage_item, count = amount },
    enable_looted = false,
    force = entity.force_index,
    allow_belts = false,
    use_start_position_on_failure = true,
  })

  if spilled then
    rendering.draw_text({
      surface = entity.surface,
      target = entity,
      text = "Flux contamination",
      color = { r = 0.7, g = 0.95, b = 0.55 },
      scale = 1.0,
      time_to_live = 120,
      alignment = "center",
    })
  end

  return spilled and amount or 0
end

function M.combine_temperatures(first_count, first_temperature, second_count, second_temperature)
  if first_temperature == nil then
    return second_temperature
  end
  if second_temperature == nil then
    return first_temperature
  end
  if first_temperature == second_temperature then
    return first_temperature
  end

  local total_count = first_count + second_count
  return (first_temperature * first_count / total_count) + (second_temperature * second_count / total_count)
end

function M.destroy_entity(entity)
  if entity and entity.valid then
    entity.destroy()
  end
end

function M.memory_corruption(unit_number, unit_data)
  M.destroy_entity(unit_data.entity)
  M.destroy_entity(unit_data.powersource)
  M.destroy_entity(unit_data.combinator)

  game.print({ "memory-unit-corruption", unit_data.count or 0, unit_data.item or "nothing" })
  if unit_data.state_table then
    unit_data.state_table[unit_number] = nil
  else
    storage.units[unit_number] = nil
  end
end

function M.validity_check(unit_number, unit_data, force)
  if not unit_data.entity.valid or not unit_data.powersource.valid or not unit_data.combinator.valid then
    M.memory_corruption(unit_number, unit_data)
    return true
  end

  if not force and not M.has_power(unit_data.powersource, unit_data.entity) then
    return true
  end

  return false
end

return M
