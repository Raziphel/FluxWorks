-- Settings affect only the four high-power Industrial Project upgrades.
-- Preserve footprints, power sources, crafting categories, and existing names.
local M = {}
local machines = {
  "fw-industrial-harvester",
  "fw-precision-synthesis-plant",
  "fw-chromatic-arc-foundry",
  "fw-convergence-synthesis-plant",
}
local multipliers = { efficient = 0.75, standard = 1, demanding = 1.3 }
function M.apply()
  local value = settings and settings.startup and settings.startup["fw-rp-industrial-power"]
  local factor = multipliers[value and value.value or "standard"] or 1
  if factor == 1 then return 0 end
  local adjusted = 0
  for _, name in ipairs(machines) do
    local machine = data.raw["assembling-machine"] and data.raw["assembling-machine"][name]
    local usage = machine and machine.energy_usage
    if type(usage) == "string" then
      local number, unit = usage:match("^([%d%.]+)([kM]W)$")
      if number and unit then
        machine.energy_usage = string.format("%.3f%s", tonumber(number) * factor, unit)
        adjusted = adjusted + 1
      end
    end
  end
  return adjusted
end
return M
