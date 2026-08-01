local Drag = require("prototypes.updates.space-platform-drag")

local constants = data.raw["utility-constants"] and data.raw["utility-constants"].default
if not constants then
  error("FluxWorks platform-drag validation could not find the default utility constants")
end

local expected = Drag.expression()
if constants.space_platform_acceleration_expression ~= expected then
  error("FluxWorks platform-drag setting was overwritten after its final compatibility pass")
end

if Drag.width_drag_coefficient("normal") ~= 0.50
  or Drag.width_drag_coefficient("hard") <= Drag.width_drag_coefficient("normal")
then
  error("FluxWorks platform drag must preserve the base penalty on Normal and increase it on Hard")
end
