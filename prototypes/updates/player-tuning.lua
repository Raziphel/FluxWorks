local Startup = require("prototypes.lib.startup-settings")

local M = {
  applied = false,
  asteroid_definitions_tuned = 0,
  spoilable_prototypes_tuned = 0,
}

local asteroid_scales = { easy = 0.65, normal = 1.00, hard = 1.25 }
local spoilage_lifetime_scales = { easy = 2.00, normal = 1.00, hard = 0.75 }
local logistics_cooldowns = {
  easy = { automatic = 10 * 60, manual = 30 },
  normal = { automatic = 30 * 60, manual = 2 * 60 },
  hard = { automatic = 45 * 60, manual = 3 * 60 },
}

local function mode(setting_name)
  return Startup.difficulty_tier(setting_name, "normal")
end

function M.asteroid_scale(selected_mode)
  return asteroid_scales[selected_mode or mode("fw-balance-asteroid-pressure")]
end


function M.spoilage_lifetime_scale(selected_mode)
  return spoilage_lifetime_scales[selected_mode or mode("fw-balance-spoilage-pressure")]
end

function M.logistics_cooldown(selected_mode)
  return logistics_cooldowns[selected_mode or mode("fw-balance-space-logistics")]
end

local function tune_spawn_definitions(definitions, scale)
  local tuned = 0
  for _, definition in pairs(definitions or {}) do
    -- Asteroid chunks are orbital resources, not incoming hazards. Preserve
    -- their supply while scaling only damaging asteroid traffic.
    if definition.type ~= "asteroid-chunk" then
      if definition.probability then
        definition.probability = definition.probability * scale
        tuned = tuned + 1
      end
      for _, point in pairs(definition.spawn_points or {}) do
        if point.probability then
          point.probability = point.probability * scale
          tuned = tuned + 1
        end
      end
    end
  end
  return tuned
end

local function tune_asteroids()
  local scale = M.asteroid_scale()
  local tuned = 0
  for _, prototype_type in ipairs({ "planet", "space-location", "space-connection" }) do
    for _, prototype in pairs(data.raw[prototype_type] or {}) do
      tuned = tuned + tune_spawn_definitions(prototype.asteroid_spawn_definitions, scale)
    end
  end
  M.asteroid_definitions_tuned = tuned
end

local function tune_space_logistics()
  local constants = data.raw["utility-constants"] and data.raw["utility-constants"].default
  if not constants then
    error("FluxWorks space logistics setting requires the default utility constants prototype")
  end

  local cooldown = M.logistics_cooldown()
  constants.space_platform_dump_cooldown = cooldown.automatic
  constants.space_platform_manual_dump_cooldown = cooldown.manual
end

local function tune_spoilage()
  local scale = M.spoilage_lifetime_scale()
  local tuned = 0
  for _, prototypes in pairs(data.raw) do
    for _, prototype in pairs(prototypes) do
      if type(prototype) == "table" and prototype.spoil_ticks and prototype.spoil_ticks > 0 then
        prototype.spoil_ticks = math.max(1, math.floor(prototype.spoil_ticks * scale + 0.5))
        tuned = tuned + 1
      end
    end
  end
  M.spoilable_prototypes_tuned = tuned
end

function M.apply()
  tune_asteroids()
  tune_space_logistics()
  tune_spoilage()
  M.applied = true
end

return M
