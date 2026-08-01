local setting = settings.startup["fw-starting-crash-loadout"]
if not setting or setting.value ~= "easy" then return end

-- Vanilla modular armor is 5x5: a 4x4 reactor and 2x2 roboport cannot coexist.
-- This grid belongs only to the easy bot-start loadout and leaves other armor alone.
data:extend({
  {
    type = "equipment-grid",
    name = "fw-easy-start-equipment-grid",
    width = 6,
    height = 6,
    equipment_categories = { "armor" },
  },
})

local modular_armor = data.raw.armor and data.raw.armor["modular-armor"]
if modular_armor then
  modular_armor.equipment_grid = "fw-easy-start-equipment-grid"
end
