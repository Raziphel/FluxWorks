-- Resource placement for FluxWorks.
-- Flux is global; other ores stay on Nauvis.
local global_resource_names = {
  "fw-crystalised-flux",
}

local nauvis_resource_names = {
  "fw-titanium-ore",
  "fw-lead-ore",
  "fw-bauxite-ore",
  "fw-salt",
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

local function register_resources_on_planet(planet, resources)
  if not ensure_map_gen_tables(planet) then
    return
  end

  for _, resource_name in pairs(resources) do
    register_resource_on_planet(planet, resource_name)
  end
end

for _, planet in pairs(data.raw.planet or {}) do
  register_resources_on_planet(planet, global_resource_names)
end

if data.raw.planet and data.raw.planet["nauvis"] then
  register_resources_on_planet(data.raw.planet["nauvis"], nauvis_resource_names)
end

-- Keep preset sliders populated so worldgen UI stays consistent.
for _, preset_group in pairs(data.raw["map-gen-presets"] or {}) do
  if type(preset_group) == "table" then
    for _, preset in pairs(preset_group) do
      if type(preset) == "table" and preset.basic_settings and preset.basic_settings.autoplace_controls then
        local controls = preset.basic_settings.autoplace_controls
        local has_ore_profile = controls["iron-ore"] or controls["copper-ore"] or controls["stone"]
        if has_ore_profile then
          for _, resource_name in pairs(global_resource_names) do
            controls[resource_name] = controls[resource_name] or { frequency = "normal", size = "normal", richness = "normal" }
          end
          for _, resource_name in pairs(nauvis_resource_names) do
            controls[resource_name] = controls[resource_name] or { frequency = "normal", size = "normal", richness = "normal" }
          end
        end
      end
    end
  end
end
