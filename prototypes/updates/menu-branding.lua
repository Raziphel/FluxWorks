local menu_branding = {}

-- Branding is appended to whichever simulations are already registered by
-- Factorio, Space Age, and other mods. Custom FluxWorks stage saves can replace
-- the playlist later without coupling the logo treatment to scene construction.
local branding_init = [[
  -- Menu simulations do not expose camera_surface_index consistently, and
  -- Space Age stages may use a planet or platform instead of nauvis. The stock
  -- Factorio logo is the reliable marker for the surface being presented.
  local camera_surface
  local factorio_logo
  for _, surface in pairs(game.surfaces) do
    factorio_logo = surface.find_entities_filtered{
      name = "factorio-logo-11tiles",
      limit = 1,
    }[1]
    if factorio_logo then
      camera_surface = surface
      break
    end
  end
  local camera_position = game.simulation.camera_position

  if camera_surface and factorio_logo and camera_position then
    -- Stock menu stages already contain their own Factorio logo. Lift that
    -- physical logo to make room, then add only the FluxWorks plate beneath it.
    local original_logo_position = factorio_logo.position
    if factorio_logo.valid then
      factorio_logo.teleport{
        original_logo_position.x,
        original_logo_position.y - 2.8,
      }
    end

    local fluxworks_position = {
      original_logo_position.x,
      original_logo_position.y - 0.15,
    }

    rendering.draw_sprite{
      sprite = "fw-menu-logo",
      surface = camera_surface,
      target = fluxworks_position,
      x_scale = 0.18,
      y_scale = 0.18,
      render_layer = "object",
    }
  end
]]

function menu_branding.apply(simulations)
  for _, simulation in pairs(simulations or {}) do
    simulation.init = (simulation.init or "") .. branding_init
  end
end

return menu_branding
