-- Run with a real sibling ../RaziLib checkout, not a replacement shim.
dofile("tests/lua/support/razi_lib_bootstrap.lua").install()
local Settings=require("__razi_lib__/lib/settings")
local Icons=require("__razi_lib__/lib/icons")
local Technology=require("__razi_lib__/lib/technology")
local Recipe=require("__razi_lib__/lib/recipe")
local Graph=require("__razi_lib__/lib/technology_graph")
local Validation=require("__razi_lib__/lib/validation")
local Collections=require("__razi_lib__/lib/collections")
_G.settings={startup={["fw-rp-galactic-industry"]={value=false}}}
assert(Settings.enabled("fw-rp-galactic-industry",true)==false)
assert(Settings.enabled("fw-rp-missing",true)==true)
local opt=Settings.string("fw-rp-test","startup","normal",{"normal","hard"},"a")
assert(opt.default_value=="normal" and opt.type=="string-setting")
local base={icon="path/to/base.png",icon_size=64}
local original=base.icon
local graphics=require("prototypes.lib.industrial-icons")
local generated=graphics.galaxy(base,"purple","yellow","vibrant")
assert(#generated==4 and base.icon==original and base.icons==nil)
assert(generated[4].icon:find("fw-vibrant-industry.png",1,true))
local upgraded=graphics.project(base,"convergence")
assert(#upgraded==2 and upgraded[2].shift[1]==17)
local twice=graphics.project({icons=upgraded},"industrial-harvester")
assert(#twice==2 and twice[2].icon:find("industrial-harvester",1,true))
_G.data={raw={recipe={
  ["test-output"]={ingredients={{type="item",name="a",amount=3}},
    results={{type="item",name="b",amount=1}}}
},technology={
  ["start"]={effects={}},
  ["next"]={effects={},prerequisites={"start"},unit={ingredients={{"automation-science-pack",1}}}},
},item={},tool={}}}
assert(Recipe.produces("test-output","b"))
Recipe.get("test-output"):each_variant(function(v) v.ingredients[1].amount=5 end)
assert(data.raw.recipe["test-output"].ingredients[1].amount==5)
Technology.get("next"):unlock("test-output"):unlock("test-output")
assert(#data.raw.technology.next.effects==1)
assert(Validation.unlock("next","test-output"))
assert(Graph.reaches(data.raw.technology,"next","start"))
assert(not Graph.add_prerequisite(data.raw.technology,"start","next"))
assert(#data.raw.technology.start.effects==0)
local prereqs={"start","start"}
Collections.append_unique(prereqs,"next")
assert(#prereqs==3)
print("Genuine RaziLib 1.2 APIs: settings, icons, recipes, technology and graph pass")
