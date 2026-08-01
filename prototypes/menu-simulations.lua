local centered_logo_init = [[
      local surface = game.surfaces.nauvis
      local logo = surface.find_entities_filtered{
        name = "factorio-logo-11tiles",
        limit = 1,
      }[1]
      local anchor = logo and logo.position or { x = 0, y = 0 }

      if logo then
        logo.destructible = false
      end

      game.simulation.camera_surface_index = surface.index
      game.simulation.camera_position = {
        anchor.x,
        anchor.y + 9.75,
      }
      game.simulation.camera_zoom = 1
      game.tick_paused = false
]]

local durations = {
  ["fw-menu-sorting-ores.zip"] = 60 * 20,
}

local simulations = {}
for _, filename in ipairs(require("menu-simulations.manifest")) do
  local name = filename:gsub("%.zip$", ""):gsub("[^%w_%-]", "-")
  simulations[name] = {
    checkboard = false,
    save = "__FluxWorks__/menu-simulations/" .. filename,
    length = durations[filename] or 60 * 30,
    init = centered_logo_init,
  }
end

return simulations
