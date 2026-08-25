local function patch_gun_turret_power()
  local gun_turret = data.raw["ammo-turret"] and data.raw["ammo-turret"]["gun-turret"]
  if not gun_turret then
    return
  end

  gun_turret.energy_source = {
    type = "electric",
    usage_priority = "secondary-input",
    buffer_capacity = "240kJ",
    input_flow_limit = "1MW",
    drain = "20kW",
  }
  gun_turret.energy_per_shot = "24kJ"
end

local function patch_offshore_pump_power()
  local offshore_pump = data.raw["offshore-pump"] and data.raw["offshore-pump"]["offshore-pump"]
  if not offshore_pump then
    return
  end

  offshore_pump.energy_source = { type = "void" }
  offshore_pump.energy_usage = "60kW"
end

patch_gun_turret_power()
patch_offshore_pump_power()
