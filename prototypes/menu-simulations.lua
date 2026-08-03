local centered_logo_init = [[
      local surface = game.surfaces.nauvis
      local logo = surface.find_entities_filtered{
        name = "factorio-logo-11tiles",
        limit = 1,
      }[1]
      local anchor = logo and logo.position or { x = 0, y = 0 }

      -- These scenes were authored in the map editor. Strip every persisted
      -- player body as well as the editor controller: menu simulations are
      -- camera scenes, and an avatar saved into the stage must never appear.
      for _, player in pairs(game.players) do
        local character = player.character
        -- Space Age saves can persist remote-view state independently from
        -- the controller. Exit it explicitly or its surface selector remains
        -- visible behind the title menu even after switching to spectator.
        player.exit_remote_view()
        player.disable_space_map = true
        player.toggle_menu_leaves_remote_view = true
        player.set_controller{type = defines.controllers.spectator}
        if character and character.valid then
          character.destroy()
        end
        player.clear_cursor()
      end

      -- Also remove unowned character entities left behind by editor saves or
      -- by a previous authoring controller.
      for _, character in pairs(surface.find_entities_filtered{type = "character"}) do
        if character.valid then character.destroy() end
      end

      if logo then
        logo.destructible = false
      end

      local camera_position = {
        anchor.x,
        anchor.y + 9.75,
      }
      local camera_player = game.players[1]
      if not camera_player then
        camera_player = game.simulation.create_test_player{
          name = "FluxWorks menu camera",
        }
      end
      local camera_character = camera_player.character
      camera_player.exit_remote_view()
      camera_player.disable_space_map = true
      camera_player.toggle_menu_leaves_remote_view = true
      camera_player.set_controller{type = defines.controllers.spectator}
      if camera_character and camera_character.valid then
        camera_character.destroy()
      end
      camera_player.teleport(camera_position, surface)
      game.simulation.camera_player = camera_player
      game.simulation.camera_surface_index = surface.index
      game.simulation.camera_position = camera_position
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
