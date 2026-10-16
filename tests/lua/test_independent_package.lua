-- Static regression: independent science must not demand a second planet.
local io=io
local function read(name)
  local f=assert(io.open(name,"rb"))
  local text=f:read("*a");f:close();return text
end
local manifest=read("info.json")
assert(not manifest:find('"razi-protocol >= ',1,true))
local d=read("prototypes/validation/domain-science.lua")
assert(d:find('independent-science',1,true))
local world=read("prototypes/updates/resource-placement.lua")
assert(not world:find("enemy-base",1,true))
assert(not world:find("unregister_resource_on_planet",1,true))
local cultured=read("prototypes/updates/planetary-self-sufficiency.lua")
assert(not cultured:find("rock.minable.results[#rock.minable.results",1,true))
local program=read("prototypes/overhaul/independent-programs.lua")
assert(program:find('fw-industrial-program-',1,true))
local controller=read("control.lua")
assert(not controller:find('razi-protocol',1,true))
print("FluxWorks independent package contracts preserved")
