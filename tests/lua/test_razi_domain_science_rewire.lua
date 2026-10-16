-- Razi research and native worlds must not acquire mandatory Flux bottles.
_G.log=function() end
_G.data={raw={tool={["automation-science-pack"]={}},technology={
  ["fw-flux-theory-science"]={unit={ingredients={{"automation-science-pack",1}}}},
  ["fw-industrial-district-project"]={unit={ingredients={{"fw-industrial-methods-science-pack",1}}}},
  ["fw-industrial-methods-science"]={unit={ingredients={{"automation-science-pack",1}}}},
  ["fw-other-machine"]={prerequisites={"fw-industrial-methods-science"},unit={ingredients={{"fw-flux-theory-science-pack",1},{"automation-science-pack",1}}}},
  ["razi-nauvis-chapter"]={unit={ingredients={{"fw-flux-theory-science-pack",1}}}},
}}}
local module=dofile("prototypes/updates/razi-domain-science-rewire.lua")
assert(module.apply()==3)
assert(#data.raw.technology["fw-other-machine"].prerequisites==0)
assert(#data.raw.technology["fw-other-machine"].unit.ingredients==1)
assert(data.raw.technology["razi-nauvis-chapter"].unit.ingredients[1][1]=="automation-science-pack")
assert(data.raw.technology["fw-industrial-district-project"].unit.ingredients[1][1]=="fw-industrial-methods-science-pack")
assert(module.apply()==0)
print("Flux science campaign ownership and idempotence pass")
