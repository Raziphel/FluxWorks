-- Companion science validation after Razi's final industrial bridge.
-- Four FluxWorks science bottles exist as specialist rewards, but none may
-- become a fifth compulsory progression system.
local packs = {
  ["fw-industrial-methods-science-pack"]="fw-industrial-methods-science",
  ["fw-systems-analysis-science-pack"]="fw-systems-analysis-science",
  ["fw-flux-theory-science-pack"]="fw-flux-theory-science",
  ["fw-planetary-convergence-science-pack"]="fw-planetary-convergence-science",
}
local projects = {
  ["fw-industrial-district-project"]="fw-industrial-methods-science-pack",
  ["fw-autonomous-network-project"]="fw-systems-analysis-science-pack",
  ["fw-spectrum-control-project"]="fw-flux-theory-science-pack",
  ["fw-convergence-directive-project"]="fw-planetary-convergence-science-pack",
}
local function name_of(entry)
  return entry and (entry.name or entry[1])
end
local function consumed(technology,pack)
  for _,ingredient in ipairs(technology and technology.unit and technology.unit.ingredients or {}) do
    if name_of(ingredient)==pack then return true end
  end
  return false
end
local function unlocks(technology,recipe)
  for _,effect in ipairs(technology and technology.effects or {}) do
    if effect.type=="unlock-recipe" and effect.recipe==recipe then return true end
  end
  return false
end
for pack,unlock in pairs(packs) do
  assert(data.raw.item and data.raw.item[pack],
    "Missing optional FluxWorks specialist science item: "..pack)
  assert(data.raw.recipe and data.raw.recipe[pack],
    "Missing optional FluxWorks specialist science recipe: "..pack)
  assert(unlocks(data.raw.technology and data.raw.technology[unlock],pack),
    "FluxWorks specialist science has no recipe unlock: "..pack)
end
for project,pack in pairs(projects) do
  local tech = data.raw.technology and data.raw.technology[project]
  assert(tech and consumed(tech,pack),
    "FluxWorks project lost its own specialist science pack: "..project)
end
for name,tech in pairs(data.raw.technology or {}) do
  for pack in pairs(packs) do
    if consumed(tech,pack) and projects[name]~=pack then
      error("Razi-hosted normal research may not require FluxWorks science: " .. name .. "/" .. pack)
    end
  end
end
for name,tech in pairs(data.raw.technology or {}) do
  if name:sub(1,3)=="fw-" then
    for _,effect in ipairs(tech.effects or {}) do
      assert(not (effect.type=="unlock-space-location"
        and effect.space_location=="shattered-planet"),
        "FluxWorks must not unlock Razi's Shattered Planet location: "..name)
    end
  end
end
