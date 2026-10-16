-- FluxWorks' independent world policy: opt-in additive ores only.
-- NEVER mutate native ore controls, enemy presets or third-party map generation.
local M={}
local targets={
  nauvis={"fw-crystalised-flux","fw-metallic-deposit","fw-mineral-deposit","fw-carbonic-deposit"},
  gleba={"fw-silica-vein"},
  aquilo={"fw-salt"},
}
local function enabled(name,default)
  local setting=settings and settings.startup and settings.startup[name]
  return setting==nil and default or (setting and setting.value)
end
function M.apply()
  local policy=settings and settings.startup and settings.startup["fw-world-policy"]
  local profile=settings and settings.startup and settings.startup["fw-design-profile"]
  local legacy=profile and profile.value=="legacy"
  if policy and policy.value=="off" and not legacy then return 0 end
  local changed=0
  for planet_name,resources in pairs(targets) do
    local planet=data.raw.planet and data.raw.planet[planet_name]
    local map=planet and planet.map_gen_settings
    if map then
      map.autoplace_controls=map.autoplace_controls or {}
      map.autoplace_settings=map.autoplace_settings or {}
      map.autoplace_settings.entity=map.autoplace_settings.entity or {}
      local entity=map.autoplace_settings.entity
      entity.settings=entity.settings or {}
      for _,name in ipairs(resources) do
        local resource=data.raw.resource and data.raw.resource[name]
        if resource and resource.autoplace then
          local control=resource.autoplace.control or name
          if not entity.settings[name] then
            entity.settings[name]={}
            changed=changed+1
          end
          if not map.autoplace_controls[control] then map.autoplace_controls[control]={} end
        end
      end
    end
  end
  -- Keep existing vanilla ore, enemy and custom-map settings exactly as found.
  log("FluxWorks independent industry: "..changed.." additive surface resource placements")
  return changed
end
M.targets=targets
M.apply()
return M
