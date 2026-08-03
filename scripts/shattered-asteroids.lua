local M = {}
local Startup = require("prototypes.lib.startup-settings")

local SURFACE_NAME = "shattered-planet"
local CHECK_INTERVAL = 60
local IMPACT_CHECK_INTERVAL = 10
local MIN_SPAWN_DISTANCE = 88
local MAX_SPAWN_DISTANCE = 118
local TARGET_SEARCH_RADIUS = 56

local PRESSURE = ({
  easy = {
    first_delay = 60 * 35, wave_delay = { 60 * 24, 60 * 36 }, small_count = { 1, 2 },
    medium_chance = 0.10, background_delay = { 60 * 90, 60 * 140 }, unattended_cap = 8,
  },
  normal = {
    first_delay = 60 * 20, wave_delay = { 60 * 12, 60 * 20 }, small_count = { 2, 4 },
    medium_chance = 0.22, background_delay = { 60 * 45, 60 * 75 }, unattended_cap = 18,
  },
  hard = {
    first_delay = 60 * 12, wave_delay = { 60 * 7, 60 * 12 }, small_count = { 3, 6 },
    medium_chance = 0.38, background_delay = { 60 * 25, 60 * 45 }, unattended_cap = 28,
  },
})[Startup.difficulty_tier("fw-balance-shattered-asteroid-pressure", "normal")]

local UNATTENDED_ENABLED = Startup.enabled("fw-enable-unattended-shattered-asteroids", true)

local SMALL_ASTEROIDS = {
  "small-metallic-asteroid",
  "small-carbonic-asteroid",
  "small-oxide-asteroid",
}

local MEDIUM_ASTEROIDS = {
  "medium-metallic-asteroid",
  "medium-carbonic-asteroid",
  "medium-oxide-asteroid",
}

local ALL_ASTEROIDS = {
  "small-metallic-asteroid",
  "small-carbonic-asteroid",
  "small-oxide-asteroid",
  "medium-metallic-asteroid",
  "medium-carbonic-asteroid",
  "medium-oxide-asteroid",
}

local function state()
  storage.fw_shattered_asteroids = storage.fw_shattered_asteroids or {}
  local asteroid_state = storage.fw_shattered_asteroids
  asteroid_state.next_wave_tick = asteroid_state.next_wave_tick or (game.tick + PRESSURE.first_delay)
  asteroid_state.waves = asteroid_state.waves or 0
  asteroid_state.active = asteroid_state.active or {}
  return asteroid_state
end

local function active_players(surface)
  local players = {}

  for _, player in pairs(game.connected_players) do
    if player.valid and player.physical_surface == surface then
      players[#players + 1] = player
    end
  end

  return players
end

local function is_viable_target(entity)
  return entity.valid
    and entity.health
    and entity.type ~= "character"
    and entity.type ~= "construction-robot"
    and entity.type ~= "logistic-robot"
end

local function choose_target(surface, player)
  local position = player.physical_position
  local candidates = surface.find_entities_filtered {
    position = position,
    radius = TARGET_SEARCH_RADIUS,
    force = player.force,
  }
  local viable = {}

  for _, entity in ipairs(candidates) do
    if is_viable_target(entity) then
      viable[#viable + 1] = entity
    end
  end

  if #viable > 0 then
    local entity = viable[math.random(#viable)]
    return { x = entity.position.x, y = entity.position.y }
  end

  return { x = position.x, y = position.y }
end

local function asteroid_name(use_medium)
  local family = use_medium and MEDIUM_ASTEROIDS or SMALL_ASTEROIDS
  return family[math.random(#family)]
end

local function spawn_asteroid(surface, target, wave_angle, use_medium, asteroid_state)
  local angle = wave_angle + (math.random() - 0.5) * 0.28
  local distance = MIN_SPAWN_DISTANCE + math.random() * (MAX_SPAWN_DISTANCE - MIN_SPAWN_DISTANCE)
  local spawn_position = {
    x = target.x + math.cos(angle) * distance,
    y = target.y + math.sin(angle) * distance,
  }
  -- The selected target is already a specific player structure. Aim at its
  -- actual position: the former ten-tile scatter made almost every asteroid
  -- visibly pass the building it was supposed to threaten.
  local dx = target.x - spawn_position.x
  local dy = target.y - spawn_position.y
  local magnitude = math.sqrt(dx * dx + dy * dy)
  local speed = use_medium and 0.062 or (0.078 + math.random() * 0.018)

  if magnitude == 0 then
    return nil
  end

  local asteroid = surface.create_entity {
    name = asteroid_name(use_medium),
    position = spawn_position,
    velocity = {
      x = dx / magnitude * speed,
      y = dy / magnitude * speed,
    },
    force = game.forces.enemy,
  }

  if asteroid then
    asteroid_state.active[#asteroid_state.active + 1] = {
      entity = asteroid,
      target = { x = target.x, y = target.y },
      damage = use_medium and 500 or 125,
      radius = use_medium and 1.4 or 0.8,
      expires = game.tick + math.ceil(magnitude / speed) + 300,
    }
  end

  return asteroid
end

local function resolve_impacts()
  local asteroid_state = state()

  for index = #asteroid_state.active, 1, -1 do
    local flight = asteroid_state.active[index]
    local asteroid = flight.entity
    local finished = not (asteroid and asteroid.valid)

    if not finished then
      local surface = asteroid.surface
      local impact_target = nil
      local candidates = surface.find_entities_filtered {
        position = asteroid.position,
        radius = flight.radius,
        force = game.forces.player,
      }

      for _, candidate in ipairs(candidates) do
        if is_viable_target(candidate) then
          impact_target = candidate
          break
        end
      end

      local dx = asteroid.position.x - flight.target.x
      local dy = asteroid.position.y - flight.target.y
      local reached_target = dx * dx + dy * dy <= flight.radius * flight.radius

      if impact_target then
        impact_target.damage(flight.damage, game.forces.enemy, "physical")
        if asteroid.valid then asteroid.die(game.forces.player) end
        finished = true
      elseif reached_target or game.tick >= flight.expires then
        asteroid.die(game.forces.player)
        finished = true
      end
    end

    if finished then
      table.remove(asteroid_state.active, index)
    end
  end
end

local function launch_wave(surface, players, asteroid_state)
  local target_player = players[math.random(#players)]
  local target = choose_target(surface, target_player)
  asteroid_state.last_target = target
  local angle = math.random() * math.pi * 2
  local small_count = math.random(PRESSURE.small_count[1], PRESSURE.small_count[2])
  local include_medium = asteroid_state.waves >= 3 and math.random() < PRESSURE.medium_chance

  for _ = 1, small_count do
    spawn_asteroid(surface, target, angle, false, asteroid_state)
  end

  if include_medium then
    spawn_asteroid(surface, target, angle, true, asteroid_state)
  end

  asteroid_state.waves = asteroid_state.waves + 1

end

local function background_target(surface, asteroid_state)
  if asteroid_state.last_target then
    return asteroid_state.last_target
  end

  local position = game.forces.player.get_spawn_position(surface)
  return { x = position.x, y = position.y }
end

local function launch_background_asteroid(surface, asteroid_state)
  -- Unattended surfaces should feel alive, but must never accumulate an
  -- unbounded number of moving entities while nobody is there to fight them.
  local asteroid_count = surface.count_entities_filtered {
    name = ALL_ASTEROIDS,
    force = game.forces.enemy,
  }

  if asteroid_count >= PRESSURE.unattended_cap then
    return
  end

  local target = background_target(surface, asteroid_state)
  local angle = math.random() * math.pi * 2
  spawn_asteroid(surface, target, angle, false, asteroid_state)

  -- Rare pairs keep the sky from feeling mechanically uniform without making
  -- unattended activity resemble a full combat wave.
  if asteroid_count + 1 < PRESSURE.unattended_cap and math.random() < 0.12 then
    spawn_asteroid(surface, target, angle, false, asteroid_state)
  end
end

local function process_asteroid_storm(event)
  local asteroid_state = state()

  if event.tick < asteroid_state.next_wave_tick then
    return
  end

  local surface = game.surfaces[SURFACE_NAME]
  if not surface then
    asteroid_state.next_wave_tick = event.tick + PRESSURE.first_delay
    return
  end

  local players = active_players(surface)
  if #players == 0 then
    if UNATTENDED_ENABLED then
      launch_background_asteroid(surface, asteroid_state)
    end
    asteroid_state.next_wave_tick = event.tick + math.random(PRESSURE.background_delay[1], PRESSURE.background_delay[2])
    return
  end

  launch_wave(surface, players, asteroid_state)
  asteroid_state.next_wave_tick = event.tick + math.random(PRESSURE.wave_delay[1], PRESSURE.wave_delay[2])
end

function M.register_events(registrar)
  registrar:on_nth_tick(CHECK_INTERVAL, process_asteroid_storm)
  registrar:on_nth_tick(IMPACT_CHECK_INTERVAL, resolve_impacts)
end

function M.on_init()
  state()
end

function M.on_configuration_changed()
  state()
end

return M
