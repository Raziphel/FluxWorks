-- Run from FluxWorks repo root in Lua 5.2+.
local name="prototypes.updates.razi-industry-tech-clarity"
_G.log=function() end
_G.data={raw={technology={
  ["fw-shattered-expedition-planning"]={prerequisites={}},
  ["fw-shattered-platform-hardening"]={prerequisites={"fw-shattered-expedition-planning"}},
  ["fw-shattered-landing-protocols"]={prerequisites={"fw-shattered-platform-hardening"}},
  ["fw-shattered-necessary"]={prerequisites={}},
  ["razi-live-industry"]={prerequisites={"fw-shattered-necessary"}},
}}}
package.path="./?.lua;./?/init.lua;"..package.path
local module=require(name)
assert(module.apply()==3,"Only orphaned campaign tech should be hidden")
assert(data.raw.technology["fw-shattered-expedition-planning"].hidden)
assert(data.raw.technology["fw-shattered-platform-hardening"].hidden)
assert(data.raw.technology["fw-shattered-landing-protocols"].hidden)
assert(not data.raw.technology["fw-shattered-necessary"].hidden)
assert(module.apply()==3,"Idempotent classification")
print("Razi legacy research graph: preserved needed nodes and hid old campaign")
