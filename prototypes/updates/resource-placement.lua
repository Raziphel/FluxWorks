-- Resource placement for FluxWorks.
-- Each resource has its own planet list so tuning spawn locations is easy.

local resource_planets = {
  ["fw-crystalised-flux"] = {
    "nauvis",
  },
  ["fw-titanium-ore"] = {
    "nauvis",
  },
  ["fw-lead-ore"] = {
    "nauvis",
  },
  ["fw-tin-ore"] = {
    "nauvis",
  },
  ["fw-aluminum-ore"] = {
    "nauvis",
  },
  ["fw-bauxite-ore"] = {
    "nauvis",
  },
  ["fw-salt"] = {
    "nauvis",
  },
  ["fw-silica-ore"] = {
    "nauvis",
  },
  ["fw-graphite-ore"] = {
    "nauvis",
  },
  ["fw-diamond-ore"] = {
    "nauvis",
  },
}

local function ensure_map_gen_tables(planet)
  if type(planet) ~= "table" then
    return false
  end

  planet.map_gen_settings = planet.map_gen_settings or {}
  planet.map_gen_settings.autoplace_controls = planet.map_gen_settings.autoplace_controls or {}
  planet.map_gen_settings.autoplace_settings = planet.map_gen_settings.autoplace_settings or {}
  planet.map_gen_settings.autoplace_settings.entity = planet.map_gen_settings.autoplace_settings.entity or {}
  planet.map_gen_settings.autoplace_settings.entity.settings = planet.map_gen_settings.autoplace_settings.entity.settings or {}
  return true
end

local function register_resource_on_planet(planet, resource_name)
  planet.map_gen_settings.autoplace_controls[resource_name] = planet.map_gen_settings.autoplace_controls[resource_name] or {}
  planet.map_gen_settings.autoplace_settings.entity.settings[resource_name] = planet.map_gen_settings.autoplace_settings.entity.settings[resource_name] or {}
end

local function register_resources_on_planet(planet_name, resources)
  local planet = data.raw.planet and data.raw.planet[planet_name]
  if not ensure_map_gen_tables(planet) then
    return
  end

  for _, resource_name in pairs(resources) do
    register_resource_on_planet(planet, resource_name)
  end
end

-- Build a reverse map so each planet gets all resources assigned to it.
local planet_resources = {}
for resource_name, planets in pairs(resource_planets) do
  for _, planet_name in pairs(planets) do
    planet_resources[planet_name] = planet_resources[planet_name] or {}
    table.insert(planet_resources[planet_name], resource_name)
  end
end

for planet_name, resources in pairs(planet_resources) do
  register_resources_on_planet(planet_name, resources)
end

-- Keep preset sliders populated so worldgen UI stays consistent.
for _, preset_group in pairs(data.raw["map-gen-presets"] or {}) do
  if type(preset_group) == "table" then
    for _, preset in pairs(preset_group) do
      if type(preset) == "table" and preset.basic_settings and preset.basic_settings.autoplace_controls then
        local controls = preset.basic_settings.autoplace_controls
        local has_ore_profile = controls["iron-ore"] or controls["copper-ore"] or controls["stone"]
        if has_ore_profile then
          for resource_name, _ in pairs(resource_planets) do
            controls[resource_name] = controls[resource_name] or { frequency = "normal", size = "normal", richness = "normal" }
          end
        end
      end
    end
  end
end
