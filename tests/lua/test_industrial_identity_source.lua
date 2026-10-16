-- Source contract for the two gameplay identities, without executable Factorio.
local function read(path)
  local f=assert(io.open(path,"rb"))
  local text=f:read("*a")
  f:close()
  return text
end
local manifest=read("info.json")
assert(manifest:find('"version": "0.6.1"',1,true))
assert(not manifest:find('"razi-protocol >= ',1,true))
local boot=read("data-final-fixes.lua")
assert(boot:find('require("prototypes.identity.four-works-charter")',1,true))
assert(boot:find('require("prototypes.identity.seven-foundries")',1,true))
local charter=read("prototypes/identity/four-works-charter.lua")
assert(charter:find("Icons.badge(",1,true))
assert(charter:find("fw-four-works-charter.png",1,true))
local foundry=read("prototypes/identity/seven-foundries.lua")
assert(foundry:find('if not (mods and mods["razi-protocol"]) then return M end',1,true))
assert(foundry:find("local artwork=Icons.galaxy",1,true))
for _,system in ipairs({"calidus","solaris","nyxaris","vibrant",
  "vespera","beetlejuice","umbra"}) do
  assert(foundry:find('system="'..system..'"',1,true))
end
assert(foundry:find("fw-foundry-reconcile-",1,true))
assert(foundry:find("foundry.record,amount=6",1,true))
assert(foundry:find('name="fw-foundry-folio-inner"',1,true))
assert(foundry:find('name="fw-foundry-folio-outer"',1,true))
local val=read("prototypes/validation/industrial-identity.lua")
assert(val:find("Surplus foundry records have no usable recycling path",1,true))
local guide=read("scripts/fluxworks-guide.lua")
assert(not guide:find("game.active_mods",1,true))
assert(guide:find("script.active_mods",1,true))
local locale=read("locale/en/base.cfg")
assert(not locale:find("[space-location-description]",1,true),
  "Standalone FluxWorks must not author Razi's planet description")
assert(not locale:find("Place and fully charge the singularity here to win",1,true))
print("FluxWorks identity, source ownership, records, icons and lore pass")
