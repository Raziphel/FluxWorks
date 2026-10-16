-- Planet-gated FluxWorks industrial discovery, using RaziLib's cycle-safe
-- tech graph. Never modifies native, K2SO or Razi-owned research prototypes.
local Graph=require("__razi_lib__/lib/technology_graph")
local M={}
local worlds={
  ["fw-vulcanus-pyrochemistry"]={"vulcanus"},
  ["fw-flux-metallurgy"]={"vulcanus"},
  ["fw-gleba-biochemistry"]={"gleba"},
  ["fw-flux-green-cultivation"]={"gleba"},
  ["fw-fulgora-electrochemistry"]={"fulgora"},
  ["fw-flux-resonance"]={"fulgora"},
  ["fw-aquilo-cryochemistry"]={"aquilo"},
  ["fw-flux-phase-engineering"]={"fulgora","aquilo"},
  ["fw-flux-convergence"]={"vulcanus","gleba","fulgora","aquilo"},
  ["fw-origin-infrastructure"]={"tenebris","vesta"},
}
local price={
  ["fw-harvester-systems"]=180,
  ["fw-flux-stabilization"]=240,
  ["fw-flux-yellow-catalysis"]=250,
  ["fw-flux-red-energetics"]=300,
  ["fw-flux-green-reclamation"]=300,
  ["fw-flux-structuring"]=420,
  ["fw-vulcanus-pyrochemistry"]=550,
  ["fw-gleba-biochemistry"]=550,
  ["fw-fulgora-electrochemistry"]=700,
  ["fw-flux-metallurgy"]=750,
  ["fw-flux-green-cultivation"]=750,
  ["fw-flux-resonance"]=850,
  ["fw-aquilo-cryochemistry"]=950,
  ["fw-flux-phase-engineering"]=1400,
  ["fw-flux-synthesis"]=1500,
  ["fw-flux-convergence"]=2400,
  ["fw-origin-infrastructure"]=3600,
}
local function index_discoveries(techs)
  local locations={}
  for name,tech in pairs(techs) do
    if tech.enabled~=false and not tech.hidden then
      for _,effect in ipairs(tech.effects or {}) do
        if effect.type=="unlock-space-location" and effect.space_location then
          local place=effect.space_location
          local existing=locations[place]
          if not existing or name=="planet-discovery-"..place
            or (existing~="planet-discovery-"..place and name<existing) then
            locations[place]=name
          end
        end
      end
    end
  end
  return locations
end
function M.apply()
  local techs=data.raw.technology or {}
  local worlds_by_tech=index_discoveries(techs)
  local linked,costed=0,0
  for technology,planets in pairs(worlds) do
    local tech=techs[technology]
    if tech and tech.enabled~=false then
      for _,planet in ipairs(planets) do
        local parent=worlds_by_tech[planet]
        if parent and Graph.add_prerequisite(techs,technology,parent) then
          linked=linked+1
        end
      end
    end
  end
  for name,count in pairs(price) do
    local tech=techs[name]
    local unit=tech and tech.unit
    if unit and type(unit.count)=="number" and not unit.count_formula then
      unit.count=count
      costed=costed+1
    end
  end
  -- Project-specific science remains an opt-in mastery reward; we never add
  -- a FluxWorks pack to another mod's chapter research.
  log(("FluxWorks Reborn research: %d planetary gates, %d paced technologies")
    :format(linked,costed))
  return linked,costed
end
M.worlds=worlds
M.prices=price
return M
