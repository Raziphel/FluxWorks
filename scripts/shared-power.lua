local M = {}

function M.create_hidden_interface(surface, force, position, name)
  local power = surface.create_entity({
    name = name,
    position = position,
    force = force,
    create_build_effect_smoke = false,
  })

  if power then
    power.destructible = false
    power.minable = false
    power.operable = false
  end

  return power
end

function M.consume(power_entity, joules)
  if not (power_entity and power_entity.valid) then
    return false
  end

  local available = power_entity.energy or 0
  if available < joules then
    power_entity.energy = 0
    return false
  end

  power_entity.energy = available - joules
  return true
end

function M.destroy(power_entity)
  if power_entity and power_entity.valid then
    power_entity.destroy()
  end
end

return M
