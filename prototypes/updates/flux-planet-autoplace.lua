local function ensure_autoplace_on_planet(planet)
  if type(planet) ~= "table" then
    return
  end

  planet.map_gen_settings = planet.map_gen_settings or {}
  planet.map_gen_settings.autoplace_controls = planet.map_gen_settings.autoplace_controls or {}
  planet.map_gen_settings.autoplace_settings = planet.map_gen_settings.autoplace_settings or {}
  planet.map_gen_settings.autoplace_settings.entity = planet.map_gen_settings.autoplace_settings.entity or {}
  planet.map_gen_settings.autoplace_settings.entity.settings = planet.map_gen_settings.autoplace_settings.entity.settings or {}

  planet.map_gen_settings.autoplace_controls["fw-flux"] = planet.map_gen_settings.autoplace_controls["fw-flux"] or {}
  planet.map_gen_settings.autoplace_settings.entity.settings["fw-flux"] = planet.map_gen_settings.autoplace_settings.entity.settings["fw-flux"] or {}
end

for _, preset_group in pairs(data.raw["map-gen-presets"] or {}) do
  if type(preset_group) == "table" then
    for _, preset in pairs(preset_group) do
      if type(preset) == "table" and preset.basic_settings and preset.basic_settings.autoplace_controls then
        preset.basic_settings.autoplace_controls["fw-flux"] = preset.basic_settings.autoplace_controls["fw-flux"] or { frequency = "normal", size = "normal", richness = "normal" }
      end
    end
  end
end

for _, planet in pairs(data.raw["planet"] or {}) do
  ensure_autoplace_on_planet(planet)
end
