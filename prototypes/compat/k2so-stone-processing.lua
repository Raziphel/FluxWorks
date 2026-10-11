-- K2SO already provides Stone Processing, Sand and Glass. Do not leave a
-- second, cheaper FluxWorks path around the existing K2SO research milestone.
local Startup = require("prototypes.lib.startup-settings")
if not mods["Krastorio2-spaced-out"]
  or Startup.enabled("fw-enable-early-industry-overhaul", false) then
  return
end

local owner = assert(data.raw.technology and data.raw.technology["kr-stone-processing"],
  "K2SO compatibility expected its native kr-stone-processing technology")

-- Retain the prototypes for migration safety, but make K2SO the only active
-- early Stone Processing owner in expansion mode.
local retired = {
  ["sand-processing"] = true,
  ["glass-processing"] = true,
}
for tech_name in pairs(retired) do
  local technology = data.raw.technology and data.raw.technology[tech_name]
  if technology then
    technology.hidden = true
    technology.enabled = false
    technology.effects = {}
    technology.prerequisites = {}
    technology.research_trigger = nil
    technology.unit = nil
  end
end
for _, recipe_name in ipairs({ "sand", "glass" }) do
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if recipe then
    recipe.hidden = true
    recipe.hidden_in_factoriopedia = true
    recipe.enabled = false
  end
end

-- Retarget only nodes already depending on the now-retired technology. This
-- preserves each mod's other prerequisites and does not invent new gates.
for _, technology in pairs(data.raw.technology or {}) do
  local updated, seen = {}, {}
  for _, prerequisite in ipairs(technology.prerequisites or {}) do
    local actual = retired[prerequisite] and owner.name or prerequisite
    if actual ~= technology.name and not seen[actual] then
      updated[#updated + 1] = actual
      seen[actual] = true
    end
  end
  if technology.prerequisites then technology.prerequisites = updated end
end
