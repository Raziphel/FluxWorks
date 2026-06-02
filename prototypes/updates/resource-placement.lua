-- Resource placement rules for FluxWorks.
-- Flux can appear everywhere; ore deposits stay on Nauvis.
local global_resource_names = {
  "fw-crystalised-flux",
}

local nauvis_resource_names = {
  "fw-metallic-deposit",
  "fw-mineral-deposit",
  "fw-carbonic-deposit",
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

-- Keep worldgen preset sliders populated so the UI stays consistent.
for _, preset_group in pairs(data.raw["map-gen-presets"] or {}) do
  if type(preset_group) == "table" then
    for _, preset in pairs(preset_group) do
      if type(preset) == "table" and preset.basic_settings and preset.basic_settings.autoplace_controls then
        local controls = preset.basic_settings.autoplace_controls
        local has_ore_profile = controls["iron-ore"] or controls["copper-ore"] or controls["stone"]
        if has_ore_profile then
          preset.basic_settings.starting_area = "normal"

          for _, resource_name in pairs(global_resource_names) do
            controls[resource_name] = controls[resource_name] or { frequency = "normal", size = "normal", richness = "normal" }
          end
          for _, resource_name in pairs(nauvis_resource_names) do
            controls[resource_name] = controls[resource_name] or { frequency = "normal", size = "normal", richness = "normal" }
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
        ["fw-metallic-deposit"] = { frequency = "normal", size = "big", richness = "very-good" },
        ["fw-mineral-deposit"] = { frequency = "normal", size = "normal", richness = "very-good" },
        ["fw-carbonic-deposit"] = { frequency = "normal", size = "normal", richness = "good" },
        ["fw-crystalised-flux"] = { frequency = "normal", size = "normal", richness = "normal" },
      },
    },
  }
end

-- Hide legacy standalone ore sliders globally so only mixed-deposit sliders are shown.
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
