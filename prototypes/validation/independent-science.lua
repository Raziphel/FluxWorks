local science={
  {"fw-industrial-methods-science-pack","fw-industrial-methods-science"},
  {"fw-systems-analysis-science-pack","fw-systems-analysis-science"},
  {"fw-flux-theory-science-pack","fw-flux-theory-science"},
  {"fw-planetary-convergence-science-pack","fw-planetary-convergence-science"},
}
local technologies=data.raw.technology or {}
local items=data.raw.item or {}
local recipes=data.raw.recipe or {}
local function consumes(recipe,item)
  for _,e in ipairs((recipe and recipe.ingredients) or {}) do
    if (e.name or e[1])==item then return true end
  end
end
for _,entry in ipairs(science) do
  local name,techName=entry[1],entry[2]
  local item,recipe,tech=items[name],recipes[name],technologies[techName]
  assert(item and recipe and tech,
    "Independent FluxWorks science prototype incomplete: "..name)
  assert(recipe.enabled==false, "Specialist research bottle must be unlocked: "..name)
  local unlocked=false
  for _,effect in ipairs(tech.effects or {}) do
    if effect.type=="unlock-recipe" and effect.recipe==name then unlocked=true end
  end
  assert(unlocked,"Missing specialist science unlock: "..name)
end
-- The native game never has to consume a FluxWorks science pack. Earlier
-- standalone versions could inject these into base research as a global toll.
local invasive={
  ["fw-industrial-methods-science-pack"]=true,
  ["fw-systems-analysis-science-pack"]=true,
  ["fw-flux-theory-science-pack"]=true,
  ["fw-planetary-convergence-science-pack"]=true,
}
if not ((settings.startup or {})["fw-enable-legacy-technology-overhaul"]
  and settings.startup["fw-enable-legacy-technology-overhaul"].value) then
  for name,tech in pairs(technologies) do
    if name:sub(1,3)~="fw-" then
      for _,entry in ipairs((tech.unit and tech.unit.ingredients) or {}) do
        assert(not invasive[entry.name or entry[1]],
          "External research acquired mandatory FluxWorks science: "..name)
      end
    end
  end
end
log("FluxWorks independent science: four owned research domains verified")
return true
