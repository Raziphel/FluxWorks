-- Exclusively FluxWorks-owned factory settings. No global tech costs,
-- space-physics changes or per-tick entity updates.
local M = {}
local machines = {
  "fw-industrial-harvester", "fw-precision-synthesis-plant",
  "fw-chromatic-arc-foundry", "fw-convergence-synthesis-plant",
}
local project_research = {
  "fw-industrial-district-project", "fw-autonomous-network-project",
  "fw-spectrum-control-project", "fw-convergence-directive-project",
}
local energy = {efficient=0.75, standard=1, demanding=1.30}
local tempo = {rapid=0.75, standard=1, deliberate=1.30}
local research = {accelerated=0.75, standard=1, monumental=1.30}
local function profile(name, choices)
  local value = settings and settings.startup and settings.startup[name]
  return choices[value and value.value or "standard"] or 1
end
local function adjust_power(machine, multiplier)
  local text = machine and machine.energy_usage
  if type(text) ~= "string" then return false end
  local number, unit = text:match("^([%d%.]+)([kM]W)$")
  if not number or multiplier == 1 then return false end
  machine.energy_usage = string.format("%.3f%s", tonumber(number)*multiplier, unit)
  return true
end
function M.apply()
  local modified = 0
  local power = profile("fw-rp-industrial-power",energy)
  local count = profile("fw-rp-project-research",research)
  local speed = profile("fw-rp-process-tempo",tempo)
  for _,name in ipairs(machines) do
    local machine = data.raw["assembling-machine"] and data.raw["assembling-machine"][name]
    if adjust_power(machine,power) then modified=modified+1 end
  end
  if count ~= 1 then
    for _, name in ipairs(project_research) do
      local tech = data.raw.technology and data.raw.technology[name]
      local unit = tech and tech.unit
      if unit and type(unit.count) == "number" and unit.count > 0
        and not unit.count_formula then
        unit.count = math.max(1, math.floor(unit.count*count+0.5))
        modified=modified+1
      end
    end
  end
  if speed ~= 1 then
    for name,recipe in pairs(data.raw.recipe or {}) do
      if name:sub(1,12) == "fw-spectrum-" or name:sub(1,12) == "fw-industry-" then
        if type(recipe.energy_required) == "number" then
          recipe.energy_required = math.max(0.5, recipe.energy_required*speed)
          modified=modified+1
        end
      end
    end
  end
  return modified
end
return M
