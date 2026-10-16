-- Offline test for six physical culture bootstrap paths.
local parents={lead="iron-bacteria",bauxite="copper-bacteria",tin="copper-bacteria",
  silicon="iron-bacteria",titanium="iron-bacteria",salt="copper-bacteria"}
_G.data={raw={technology={["bacteria-cultivation"]={effects={}}},recipe={}}}
for key,parent in pairs(parents) do
  local name="fw-"..key.."-bacteria-seeding"
  data.raw.recipe[name]={category="organic",enabled=false,allow_productivity=false,
    ingredients={{type="item",name=parent,amount=3},{type="item",name="bioflux",amount=2}},
    results={{type="item",name="fw-"..key.."-bacteria",amount=2}}}
  table.insert(data.raw.technology["bacteria-cultivation"].effects,
    {type="unlock-recipe",recipe=name})
end
local script="prototypes/validation/razi-bacteria-seeding.lua"
assert(pcall(dofile,script))
data.raw.recipe["fw-titanium-bacteria-seeding"].ingredients[1].name="fw-titanium-bacteria"
assert(not pcall(dofile,script),"Recursive culture seed must fail")
data.raw.recipe["fw-titanium-bacteria-seeding"].ingredients[1].name="iron-bacteria"
table.remove(data.raw.technology["bacteria-cultivation"].effects,1)
assert(not pcall(dofile,script),"Missing culture research unlock must fail")
print("Six Gleba culture bootstrap recipes: native parents, nonrecursive and unlock guards OK")
