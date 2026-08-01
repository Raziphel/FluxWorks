local Startup = require("prototypes.lib.startup-settings")

local M = {}

-- Factorio's base expression uses width * 0.5 as the aerodynamic drag
-- coefficient. Preserve the rest of the physics model and tune only that
-- width penalty so thrust, mass, reverse travel, and the low-speed floor keep
-- behaving exactly like Space Age.
local width_drag_coefficients = {
  easy = 0.15,
  normal = 0.50,
  hard = 0.70,
}

function M.mode()
  return Startup.difficulty_tier("fw-balance-space-platform-drag", "normal")
end

function M.width_drag_coefficient(mode)
  return width_drag_coefficients[mode or M.mode()] or width_drag_coefficients.normal
end

function M.expression(mode)
  local coefficient = M.width_drag_coefficient(mode)
  return ("(thrust / (1 + weight / 10000000) - ((1500 * speed * speed + 1500 * abs(speed)) * (width * %.2f) + 10000) * sign(speed)) / weight / 60")
    :format(coefficient)
end

function M.apply()
  local constants = data.raw["utility-constants"] and data.raw["utility-constants"].default
  if not constants then
    error("FluxWorks space-platform drag setting requires the default utility constants prototype")
  end

  constants.space_platform_acceleration_expression = M.expression()
end

return M
