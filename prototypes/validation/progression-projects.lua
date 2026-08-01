local milestones = require("prototypes.technology.progression-projects")

local obsolete_items = {
  "fw-industrial-district-charter",
  "fw-autonomous-network-charter",
  "fw-spectrum-control-charter",
  "fw-convergence-directive",
}

local function contains(entries, name)
  for _, entry in ipairs(entries or {}) do
    local entry_name = type(entry) == "table" and (entry.name or entry[1]) or entry
    if entry_name == name then return true end
  end
  return false
end

for _, name in ipairs(obsolete_items) do
  if data.raw.item and data.raw.item[name] then
    error("Obsolete progression charter item still exists: " .. name)
  end
  if data.raw.recipe and data.raw.recipe[name] then
    error("Obsolete progression charter recipe still exists: " .. name)
  end
end

for index, milestone in ipairs(milestones) do
  local technology = data.raw.technology and data.raw.technology[milestone.technology]
  if not technology then
    error("Missing FluxWorks research milestone: " .. milestone.technology)
  end
  if technology.research_trigger then
    error(milestone.technology .. " must use laboratory research, not a craft trigger")
  end
  if not technology.unit or not technology.unit.count or technology.unit.count <= 0 then
    error(milestone.technology .. " has no laboratory science cost")
  end
  if not contains(technology.unit.ingredients, milestone.sciences[#milestone.sciences]) then
    error(milestone.technology .. " does not consume its matching domain science pack")
  end
  if not contains(technology.prerequisites, milestone.domain) then
    error(milestone.technology .. " must follow its domain-science technology")
  end
  if not technology.effects or #technology.effects == 0 then
    error(milestone.technology .. " has no permanent research reward")
  end

  local previous = milestones[index - 1]
  if previous and not contains(technology.prerequisites, previous.technology) then
    error(milestone.technology .. " must follow " .. previous.technology)
  end
end
