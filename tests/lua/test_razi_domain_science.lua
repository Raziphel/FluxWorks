-- Run in Lua 5.2+ from FluxWorks root.
_G.data={raw={item={},recipe={},technology={}}}
local mapping={
  {"fw-industrial-methods-science-pack","fw-industrial-methods-science","fw-industrial-district-project"},
  {"fw-systems-analysis-science-pack","fw-systems-analysis-science","fw-autonomous-network-project"},
  {"fw-flux-theory-science-pack","fw-flux-theory-science","fw-spectrum-control-project"},
  {"fw-planetary-convergence-science-pack","fw-planetary-convergence-science","fw-convergence-directive-project"},
}
for _,entries in ipairs(mapping) do
  local pack,owner,project=table.unpack(entries)
  data.raw.item[pack]={}
  data.raw.recipe[pack]={}
  data.raw.technology[owner]={effects={{type="unlock-recipe",recipe=pack}}}
  data.raw.technology[project]={unit={ingredients={{pack,1}}}}
end
data.raw.technology["razi-solaris-discovery"]={unit={ingredients={{"solaris-tech-card",1}}}}
local file="prototypes/validation/razi-domain-science.lua"
assert(pcall(dofile,file),"Valid optional Flux science contract must pass")
data.raw.technology["razi-solaris-discovery"].unit.ingredients={{"fw-flux-theory-science-pack",1}}
assert(not pcall(dofile,file),"Mandatory chapter Flux toll must be rejected")
data.raw.technology["razi-solaris-discovery"].unit.ingredients={{"solaris-tech-card",1}}
data.raw.technology["fw-flux-theory-science"].effects[#data.raw.technology["fw-flux-theory-science"].effects+1]={type="unlock-space-location",space_location="shattered-planet"}
assert(not pcall(dofile,file),"Duplicate destination unlock must be rejected")
print("Razi domain science: optional projects, chapter guard, location guard OK")
