local StartingWreckage = {}

local function loadout()
  local setting = settings.startup["fw-starting-crash-loadout"]
  return setting and setting.value or "normal"
end

local function set_items(remote_type, replacements)
  local interface = remote.interfaces.freeplay
  local setter = "set_" .. remote_type .. "_items"
  if not interface or not interface[setter] then return end

  local items = {}
  for item_name, count in pairs(replacements) do
    if prototypes.item[item_name] then items[item_name] = count end
  end
  remote.call("freeplay", setter, items)
end

local function add_items(remote_type, additions)
  local interface = remote.interfaces.freeplay
  local getter = "get_" .. remote_type .. "_items"
  local setter = "set_" .. remote_type .. "_items"
  if not interface or not interface[getter] or not interface[setter] then return end

  local items = remote.call("freeplay", getter)
  for item_name, count in pairs(additions) do
    if prototypes.item[item_name] then
      items[item_name] = (items[item_name] or 0) + count
    end
  end
  remote.call("freeplay", setter, items)
end

local function add_crash_field()
  local interface = remote.interfaces.freeplay
  if not interface or not interface.get_ship_parts or not interface.set_ship_parts then return end
  if interface.get_disable_crashsite and remote.call("freeplay", "get_disable_crashsite") then return end
  if interface.get_init_ran and remote.call("freeplay", "get_init_ran") then return end

  local parts = remote.call("freeplay", "get_ship_parts")

  local extra_parts = {
    -- Heavy hull sections stay close to the main fuselage.
    {
      name = "crash-site-spaceship-wreck-big-1",
      repeat_count = 4,
      max_distance = 52,
      min_separation = 5,
      angle_deviation = 0.07,
      fire_count = 3,
      explosion_count = 3,
    },
    {
      name = "crash-site-spaceship-wreck-big-2",
      repeat_count = 4,
      max_distance = 60,
      min_separation = 5,
      angle_deviation = 0.08,
      fire_count = 3,
      explosion_count = 4,
    },

    -- Successively lighter debris stretches farther down the impact trail.
    {
      name = "crash-site-spaceship-wreck-medium",
      variations = 3,
      repeat_count = 4,
      max_distance = 94,
      min_separation = 3,
      angle_deviation = 0.11,
      fire_count = 2,
      explosion_count = 2,
    },
    {
      name = "crash-site-spaceship-wreck-small",
      variations = 6,
      repeat_count = 6,
      max_distance = 148,
      min_separation = 2,
      angle_deviation = 0.2,
      fire_count = 1,
      explosion_count = 1,
    },

    -- Cargo pods make the expanded starter supplies visible among the wreckage.
    {
      name = "crash-site-chest-1",
      repeat_count = 6,
      max_distance = 112,
      min_separation = 4,
      angle_deviation = 0.14,
      fire_count = 1,
      explosion_count = 1,
    },
    {
      name = "crash-site-chest-2",
      repeat_count = 6,
      max_distance = 132,
      min_separation = 4,
      angle_deviation = 0.18,
      fire_count = 1,
      explosion_count = 1,
    },
    {
      name = "crash-site-fire-smoke",
      repeat_count = 20,
      max_distance = 142,
      angle_deviation = 0.22,
      scale_lifetime = true,
    },
  }

  for _, part in ipairs(extra_parts) do
    parts[#parts + 1] = part
  end
  remote.call("freeplay", "set_ship_parts", parts)
end

function StartingWreckage.on_init()
  if game.tick >= 2 or not remote.interfaces.freeplay then return end

  local selected_loadout = loadout()

  if selected_loadout == "hard" then
    -- Keep only the means to defend yourself. Everything else must be rebuilt.
    set_items("created", {
      pistol = 1,
      ["firearm-magazine"] = 10,
    })
    set_items("ship", {})
    set_items("debris", {})
    return
  end

  -- Complete a small powered starter base without replacing the early game.
  add_items("ship", {
    boiler = 1,
    ["steam-engine"] = 1,
  })

  add_items("debris", {
    ["offshore-pump"] = 1,
    ["stone-furnace"] = 6,
    ["burner-inserter"] = 16,
    ["small-electric-pole"] = 24,
    ["copper-cable"] = 50,
    pipe = 30,
    ["pipe-to-ground"] = 6,
    coal = 100,
    ["repair-pack"] = 8,
    ["iron-plate"] = 50,
    ["copper-plate"] = 40,
    ["firearm-magazine"] = 12,
    wood = 50,
    ["solar-panel"] = 8,
    accumulator = 6,
  })

  if selected_loadout == "easy" then
    -- The matching 6x6 grid allows the reactor and roboport to fit together.
    add_items("created", {
      ["modular-armor"] = 1,
      ["construction-robot"] = 10,
      ["personal-roboport-equipment"] = 1,
      ["fission-reactor-equipment"] = 1,
      ["repair-pack"] = 20,
    })
  end

  add_crash_field()
end

return StartingWreckage
