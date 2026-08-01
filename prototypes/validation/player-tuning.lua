local Tuning = require("prototypes.updates.player-tuning")

if not Tuning.applied then
  error("FluxWorks player tuning was not applied during final fixes")
end
if Tuning.asteroid_definitions_tuned < 1 then
  error("FluxWorks asteroid-pressure setting did not find any hazardous asteroid definitions")
end
if Tuning.spoilable_prototypes_tuned < 1 then
  error("FluxWorks spoilage-pressure setting did not find any spoilable prototypes")
end

local constants = data.raw["utility-constants"] and data.raw["utility-constants"].default
local expected = Tuning.logistics_cooldown()
if not constants
  or constants.space_platform_dump_cooldown ~= expected.automatic
  or constants.space_platform_manual_dump_cooldown ~= expected.manual
then
  error("FluxWorks space-logistics setting was overwritten after its final compatibility pass")
end

if Tuning.asteroid_scale("normal") ~= 1
  or Tuning.spoilage_lifetime_scale("normal") ~= 1
  or Tuning.logistics_cooldown("normal").automatic ~= 30 * 60
  or Tuning.logistics_cooldown("normal").manual ~= 2 * 60
then
  error("FluxWorks normal player-tuning presets must preserve Space Age defaults")
end

if Tuning.asteroid_scale("hard") <= Tuning.asteroid_scale("normal")
  or Tuning.spoilage_lifetime_scale("hard") >= Tuning.spoilage_lifetime_scale("normal")
  or Tuning.logistics_cooldown("hard").automatic <= Tuning.logistics_cooldown("normal").automatic
then
  error("FluxWorks hard player-tuning presets must be harder than Space Age defaults")
end
