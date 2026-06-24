-- Worldgen notes for the mess we are making here.
-- Flux and promethium can show up anywhere, but the mixed deposits and weird specialty bits
-- should still lean toward planets that feel right for them.
local global_resource_names = {
  "fw-crystalised-flux",
}

if data.raw.resource and data.raw.resource["fw-promethium-impact"] then
  table.insert(global_resource_names, "fw-promethium-impact")
end

local nauvis_resource_names = {
  "fw-metallic-deposit",
  "fw-mineral-deposit",
  "fw-carbonic-deposit",
}

local planet_specific_resource_names = {
  aquilo = {
    "fw-salt",
    "fw-mineral-deposit",
  },
  gleba = {
    "fw-silica-vein",
    "fw-carbonic-deposit",
  },
  fulgora = {
    "fw-metallic-deposit",
  },
  vulcanus = {
    "fw-mineral-deposit",
    "fw-carbonic-deposit",
  },
}

local preset_control_defaults = {
  ["fw-metallic-deposit"] = { frequency = "normal", size = "big", richness = "very-good" },
  ["fw-mineral-deposit"] = { frequency = "normal", size = "normal", richness = "very-good" },
  ["fw-carbonic-deposit"] = { frequency = "normal", size = "normal", richness = "very-good" },
  ["fw-crystalised-flux"] = { frequency = "normal", size = "normal", richness = "normal" },
  ["fw-promethium-impact"] = { frequency = "very-low", size = "small", richness = "good" },
  ["fw-silica-vein"] = { frequency = "very-low", size = "small", richness = "normal" },
  ["fw-salt"] = { frequency = "very-low", size = "small", richness = "normal" },
}

local legacy_hidden_controls = {
  "fw-titanium-ore",
  "fw-lead-ore",
  "fw-bauxite-ore",
}

local vanilla_replaced_controls = {
  "iron-ore",
  "copper-ore",
  "coal",
  "stone",
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

local function unregister_resource_on_planet(planet, resource_name)
  if not ensure_map_gen_tables(planet) then
    return
  end
  planet.map_gen_settings.autoplace_controls[resource_name] = nil
  planet.map_gen_settings.autoplace_settings.entity.settings[resource_name] = nil
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
  for _, resource_name in pairs(legacy_hidden_controls) do
    unregister_resource_on_planet(data.raw.planet["nauvis"], resource_name)
  end
  for _, resource_name in pairs(vanilla_replaced_controls) do
    unregister_resource_on_planet(data.raw.planet["nauvis"], resource_name)
  end
end

for planet_name, resource_names in pairs(planet_specific_resource_names) do
  if data.raw.planet and data.raw.planet[planet_name] then
    register_resources_on_planet(data.raw.planet[planet_name], resource_names)
  end
end

-- Keep the preset sliders filled out so the worldgen UI does not look busted.
for _, preset_group in pairs(data.raw["map-gen-presets"] or {}) do
  if type(preset_group) == "table" then
    for _, preset in pairs(preset_group) do
      if type(preset) == "table" and preset.basic_settings and preset.basic_settings.autoplace_controls then
        local controls = preset.basic_settings.autoplace_controls
        local has_ore_profile = controls["iron-ore"] or controls["copper-ore"] or controls["stone"]
        if has_ore_profile then
          preset.basic_settings.starting_area = "normal"

          for _, resource_name in pairs(global_resource_names) do
            controls[resource_name] = controls[resource_name] or table.deepcopy(preset_control_defaults[resource_name] or { frequency = "normal", size = "normal", richness = "normal" })
          end
          for _, resource_name in pairs(nauvis_resource_names) do
            controls[resource_name] = controls[resource_name] or table.deepcopy(preset_control_defaults[resource_name] or { frequency = "normal", size = "normal", richness = "normal" })
          end
          for _, resource_names in pairs(planet_specific_resource_names) do
            for _, resource_name in pairs(resource_names) do
              controls[resource_name] = controls[resource_name] or table.deepcopy(preset_control_defaults[resource_name] or { frequency = "normal", size = "normal", richness = "normal" })
            end
          end
          for _, resource_name in pairs(legacy_hidden_controls) do
            controls[resource_name] = nil
          end
          for _, resource_name in pairs(vanilla_replaced_controls) do
            controls[resource_name] = nil
          end

          if controls["enemy-base"] then
            controls["enemy-base"].frequency = "very-low"
            controls["enemy-base"].size = "very-low"
            controls["enemy-base"].richness = "very-low"
          end
        end
      end
    end
  end
end

local default_preset_group = data.raw["map-gen-presets"] and data.raw["map-gen-presets"]["default"]
if default_preset_group then
  default_preset_group["fluxworks-default"] = {
    order = "a0",
    basic_settings = {
      starting_area = "normal",
      autoplace_controls = {
        ["enemy-base"] = { frequency = "very-low", size = "very-low", richness = "very-low" },
      },
    },
  }

  for resource_name, defaults in pairs(preset_control_defaults) do
    if data.raw.resource and data.raw.resource[resource_name] then
      default_preset_group["fluxworks-default"].basic_settings.autoplace_controls[resource_name] = table.deepcopy(defaults)
    end
  end
end

-- Hide the old standalone ore sliders.
-- If we are doing mixed deposits, the UI should commit to the bit.
for _, resource_name in pairs(legacy_hidden_controls) do
  local control = data.raw["autoplace-control"] and data.raw["autoplace-control"][resource_name]
  if control then
    control.hidden = true
  end
end

for _, resource_name in pairs(vanilla_replaced_controls) do
  local control = data.raw["autoplace-control"] and data.raw["autoplace-control"][resource_name]
  if control then
    control.hidden = true
  end
end
