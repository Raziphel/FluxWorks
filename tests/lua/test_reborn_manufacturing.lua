-- Pure Lua smoke/regression for the Reborn 53-recipe bill, no RaziLib shim.
_G.log=function() end
table.deepcopy=function(v)
  if type(v)~="table" then return v end
  local o={}
  for k,entry in pairs(v) do o[k]=table.deepcopy(entry) end
  return o
end
local designs=dofile("prototypes/overhaul/bill-of-materials.lua")
local raws={recipe={},item={},fluid={}}
_G.data={raw=raws}
_G.settings={startup={["fw-rp-factory-design"]={value="reborn"}}}
for _,spec in ipairs(designs) do
  raws.recipe[spec.name]={
    name=spec.name,ingredients={{type="item",name="old-bill",amount=999}},
    results={{type="item",name=spec.name,amount=2}},enabled=false
  }
  raws.item[spec.name]={}
  for _,input in ipairs(spec.inputs) do
    raws[input.type][input.name]={}
  end
end
assert(#designs>=73)
local transform=dofile("prototypes/overhaul/rework-recipes.lua")
local applied=transform.apply()
assert(applied==#designs)
local maxInputs,maxFluids=0,0
for _,spec in ipairs(designs) do
  local recipe=raws.recipe[spec.name]
  assert(#recipe.ingredients==#spec.inputs)
  assert(recipe.results[1].amount==2,"Existing item outputs must be preserved")
  maxInputs=math.max(maxInputs,#recipe.ingredients)
  local fluids=0
  for _,source in ipairs(recipe.ingredients) do
    if source.type=="fluid" then fluids=fluids+1 end
  end
  maxFluids=math.max(maxFluids,fluids)
end
assert(maxInputs<=6 and maxFluids<=2)
settings.startup["fw-rp-factory-design"].value="legacy"
raws.recipe[designs[1].name].ingredients={{type="item",name="legacy-bill",amount=8}}
assert(transform.apply()==0)
assert(raws.recipe[designs[1].name].ingredients[1].name=="legacy-bill")
print("FluxWorks Reborn: 73 canonical recipes, 2 physical ports, legacy switch and output preservation OK")
