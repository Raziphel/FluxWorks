-- Run in Lua 5.2+ from FluxWorks root.
local module=dofile("prototypes/updates/razi-domain-science-rewire.lua")
_G.log=function() end
local techs={
 ["fw-compressed-foundry"]={prerequisites={"fw-flux-theory-science","fw-flux-extraction"}},
 ["fw-flux-extraction"]={prerequisites={"fw-industrial-methods-science"}},
 ["fw-convergence-directive-project"]={prerequisites={"fw-planetary-convergence-science","fw-spectrum-control-project"}},
 ["fw-flux-theory-science"]={prerequisites={"fw-industrial-methods-science"}},
 ["razi-vibrant-discovery"]={prerequisites={"fw-flux-theory-science"}},
}
_G.data={raw={technology=techs}}
assert(module.apply()==2,"Only normal FluxWorks research should lose mandatory pack gates")
assert(#techs["fw-compressed-foundry"].prerequisites==1)
assert(#techs["fw-flux-extraction"].prerequisites==0)
assert(#techs["fw-convergence-directive-project"].prerequisites==2)
assert(#techs["fw-flux-theory-science"].prerequisites==1)
assert(#techs["razi-vibrant-discovery"].prerequisites==1)
assert(module.apply()==0,"Second reconciliation pass should be idempotent")
print("Flux science rewire: host ownership, opt-in projects and idempotency pass")
