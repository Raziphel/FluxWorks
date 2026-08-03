local M = {}

local SURFACE_NAME = "shattered-planet"
local SURFACE_WIDTH = 3200
local SURFACE_HEIGHT = 3200
local HALF_WIDTH = SURFACE_WIDTH / 2
local HALF_HEIGHT = SURFACE_HEIGHT / 2

local function is_shattered_surface(surface)
  return surface and surface.valid and surface.name == SURFACE_NAME
end

local function chunk_is_out_of_bounds(chunk_position)
  local min_x = chunk_position.x * 32
  local min_y = chunk_position.y * 32
  local max_x = min_x + 31
  local max_y = min_y + 31

  return max_x < -HALF_WIDTH
    or min_x >= HALF_WIDTH
    or max_y < -HALF_HEIGHT
    or min_y >= HALF_HEIGHT
end

local function apply_surface_bounds(surface)
  if not is_shattered_surface(surface) then
    return
  end

  local map_gen_settings = surface.map_gen_settings
  local changed = false

  if map_gen_settings.width ~= SURFACE_WIDTH then
    map_gen_settings.width = SURFACE_WIDTH
    changed = true
  end

  if map_gen_settings.height ~= SURFACE_HEIGHT then
    map_gen_settings.height = SURFACE_HEIGHT
    changed = true
  end

  if changed then
    surface.map_gen_settings = map_gen_settings
  end
end

local function trim_surface_chunks(surface)
  if not is_shattered_surface(surface) then
    return
  end

  local chunks_to_delete = {}

  for chunk in surface.get_chunks() do
    if chunk_is_out_of_bounds(chunk) then
      chunks_to_delete[#chunks_to_delete + 1] = { x = chunk.x, y = chunk.y }
    end
  end

  for _, chunk in ipairs(chunks_to_delete) do
    surface.delete_chunk(chunk)
  end
end

local function enforce_surface(surface)
  apply_surface_bounds(surface)
  trim_surface_chunks(surface)
end

local function enforce_existing_surface()
  local surface = game.surfaces[SURFACE_NAME]
  if surface then
    enforce_surface(surface)
  end
end

function M.register_events(registrar)
  registrar:on_event(defines.events.on_surface_created, function(event)
    local surface = game.surfaces[event.surface_index]
    if surface then
      enforce_surface(surface)
    end
  end)

  registrar:on_event(defines.events.on_chunk_generated, function(event)
    local surface = event.surface
    if is_shattered_surface(surface) and chunk_is_out_of_bounds(event.position) then
      surface.delete_chunk(event.position)
    end
  end)
end

function M.on_init()
  enforce_existing_surface()
end

function M.on_configuration_changed()
  enforce_existing_surface()
end

return M
