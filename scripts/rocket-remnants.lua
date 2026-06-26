local M = {}

local function verify_whitelist()
  storage.platform_type_whitelist = storage.platform_type_whitelist or { player = {} }
  storage.platform_type_whitelist["player"]["space-platform-starter-pack"] = true
end

if not remote.interfaces["rocket-reusability"] then
  remote.add_interface("rocket-reusability", {
    add_whitelist = function(starter_pack_name, force_name)
      verify_whitelist()
      local resolved_force = force_name or "player"
      storage.platform_type_whitelist[resolved_force] = storage.platform_type_whitelist[resolved_force] or {}
      storage.platform_type_whitelist[resolved_force][starter_pack_name] = true
    end,
    remove_whitelist = function(starter_pack_name, force_name)
      verify_whitelist()
      local resolved_force = force_name or "player"
      if storage.platform_type_whitelist[resolved_force] then
        storage.platform_type_whitelist[resolved_force][starter_pack_name] = nil
      end
    end,
    is_whitelisted = function(starter_pack_name, force_name)
      verify_whitelist()
      local resolved_force = force_name or "player"
      return storage.platform_type_whitelist[resolved_force]
        and storage.platform_type_whitelist[resolved_force][starter_pack_name]
        or false
    end,
  })
end

if not commands.commands["reset-whitelist"] then
  commands.add_command("reset-whitelist", "Resets the whitelist for space platform starter packs. Can cause unpredictable behavior with other mods, but useful for removing mods.", function()
    storage.platform_type_whitelist = { player = { ["space-platform-starter-pack"] = true } }
  end)
end

local function on_rocket_launched(event)
  if not (event.rocket_silo and event.rocket_silo.valid) then
    return
  end

  verify_whitelist()

  local surface = event.rocket_silo.surface
  local planet
  for _, test_planet in pairs(game.planets) do
    if test_planet.surface == surface then
      planet = test_planet
      break
    end
  end

  if not planet then
    return
  end

  local force = event.rocket_silo.force
  if not force.is_space_platforms_unlocked() then
    return
  end

  if not force.technologies["rocket-chunk-processing"].researched then
    return
  end

  local platform_candidates = {}
  local priority_candidates = {}

  for _, platform in pairs(force.platforms) do
    if platform.surface and platform.space_location and platform.space_location.name == planet.prototype.name then
      platform_candidates[#platform_candidates + 1] = platform

      local candidates = platform.surface.find_entities_filtered({ name = "remnant-beacon" })
      if #candidates > 0 then
        local remnant_beacon = candidates[1]
        if remnant_beacon.valid and (
          remnant_beacon.status == defines.entity_status.working
          or remnant_beacon.status == defines.entity_status.low_power
        ) then
          priority_candidates[#priority_candidates + 1] = platform
        end
      end
    end
  end

  if #platform_candidates == 0 then
    return
  end

  local target_candidates = #priority_candidates > 0 and priority_candidates or platform_candidates
  local target = target_candidates[math.random(1, #target_candidates)]

  local x_pos = math.random(-40, 40)
  local y_pos = -40
  local found_empty_space = false
  while not found_empty_space do
    local result = target.surface.get_tile(x_pos, y_pos)
    if result.name ~= "empty-space" then
      y_pos = y_pos - 10
    else
      found_empty_space = true
      y_pos = y_pos - 50
    end
  end

  target.surface.create_entity({ name = "used-rocket-asteroid", position = { x_pos, y_pos } })
end

function M.register_events(registrar)
  registrar.on_event(defines.events.on_rocket_launched, on_rocket_launched)
end

function M.on_init()
  verify_whitelist()
end

function M.on_configuration_changed()
  verify_whitelist()
end

return M
