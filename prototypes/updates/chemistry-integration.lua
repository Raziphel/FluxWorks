local function add_fluid_to_turret(turret_name, fluid_name, damage_modifier)
  local turret = data.raw["fluid-turret"] and data.raw["fluid-turret"][turret_name]
  local fluids = turret and turret.attack_parameters and turret.attack_parameters.fluids
  if not fluids then
    return
  end

  for _, fluid in pairs(fluids) do
    if fluid.type == fluid_name then
      fluid.damage_modifier = damage_modifier or fluid.damage_modifier
      return
    end
  end

  table.insert(fluids, {
    type = fluid_name,
    damage_modifier = damage_modifier or 1,
  })
end

add_fluid_to_turret("flamethrower-turret", "fw-napalm", 1.45)
