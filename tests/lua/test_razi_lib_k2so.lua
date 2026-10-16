-- Run with a real sibling RaziLib checkout and Lua 5.2+.
dofile("tests/lua/support/razi_lib_bootstrap.lua").install()
local function copy(value)
  if type(value)~="table" then return value end
  local result={}
  for key,item in pairs(value) do result[copy(key)]=copy(item) end
  return result
end
table.deepcopy=copy
_G.mods={["Krastorio2-spaced-out"]="2.1.0"}
_G.settings={startup={["fw-enable-k2so-integration"]={value=true}}}
_G.log=function() end
local raw={item={},tool={},fluid={},recipe={},technology={}}
_G.data={raw=raw}
function data:extend(prototypes)
  for _,p in ipairs(prototypes) do
    assert(not raw[p.type][p.name],"Duplicate "..p.name)
    raw[p.type][p.name]=p
  end
end
local function item(name)
  raw.item[name]={name=name,icon="test/"..name..".png",icon_size=64}
end
local function tech(name)
  raw.technology[name]={name=name,
    unit={count=100,time=30,ingredients={{"automation-science-pack",1}}},
    prerequisites={},effects={}}
end
for _,name in ipairs({"kr-advanced-tech-card","kr-matter-tech-card",
  "kr-singularity-tech-card"}) do item(name) end
for _,name in ipairs({"fw-cross-planetary-industrial-convergence",
  "fw-planetary-convergence-science","fw-shattered-expedition-planning",
  "fw-origin-infrastructure","fw-flux-synthesis",
  "fw-industrial-methods-science","fw-systems-analysis-science",
  "fw-vulcanus-industrial-symbiosis"}) do tech(name) end
tech("kr-matter-cube")
for _,name in ipairs({"fw-memory-die","kr-ai-core","kr-imersium-plate",
  "kr-imersite-crystal","kr-charged-matter-stabilizer","kr-matter-cube",
  "fw-stabilized-flux-crystal","fw-crystalised-flux","fw-flux-catalyst",
  "fw-metal-mesh","kr-steel-beam","kr-electronic-components",
  "fw-sensor-package","battery","fw-industrial-methods-science-pack",
  "fw-systems-analysis-science-pack","fw-vulcanus-slag-cermet",
  "tungsten-carbide","fw-cermet"}) do item(name) end
for _,name in ipairs({"fw-purple-flux","fw-yellow-flux","fw-red-flux"}) do
  raw.fluid[name]={name=name}
end
raw.recipe["fw-quantum-computer"]={
  ingredients={{type="item",name="fw-memory-die",amount=4}},
  normal={ingredients={{type="item",name="fw-memory-die",amount=2}}},
  expensive={ingredients={{type="item",name="fw-memory-die",amount=8}}},
}
dofile("prototypes/compat/k2so.lua")
local swapped=raw.recipe["fw-quantum-computer"]
assert(swapped.ingredients[1].name=="kr-ai-core"
  and swapped.normal.ingredients[1].name=="kr-ai-core"
  and swapped.expensive.ingredients[1].name=="kr-ai-core",
  "RaziLib recipe variant edits must include normal and expensive")
assert(swapped.ingredients[1].amount==1,"K2SO must preserve declared replacement quantity")
local techs=raw.technology
assert(#techs["fw-cross-planetary-industrial-convergence"].unit.ingredients==2)
assert(#techs["fw-planetary-convergence-science"].unit.ingredients==2)
assert(techs["fw-origin-infrastructure"].prerequisites[1]=="kr-matter-cube")
assert(raw.recipe["fw-k2so-imersite-resonance"])
local fluids=0
for _,ingredient in ipairs(raw.recipe["fw-k2so-imersite-resonance"].ingredients) do
  if ingredient.type=="fluid" then fluids=fluids+1 end
end
assert(fluids<=2,"K2SO crystal variant cannot use more than two fluid ports")
dofile("prototypes/compat/k2so.lua")
assert(#techs["fw-cross-planetary-industrial-convergence"].unit.ingredients==2)
assert(#techs["fw-origin-infrastructure"].prerequisites==1)
for _,name in ipairs({"fw-k2so-imersite-resonance"}) do
  local count=0
  for _,effect in ipairs(techs["fw-flux-synthesis"].effects) do
    if effect.type=="unlock-recipe" and effect.recipe==name then count=count+1 end
  end
  assert(count==1,"Duplicate K2SO research unlock")
end
dofile("prototypes/compat/k2so-science.lua")
assert(raw.recipe["fw-k2so-industrial-standards"])
assert(raw.recipe["fw-k2so-systems-benchmarking"])
assert(raw.recipe["fw-k2so-industrial-standards"].icons[1].icon
  ==raw.item["fw-industrial-methods-science-pack"].icon)
dofile("prototypes/compat/k2so-planetary.lua")
assert(raw.recipe["fw-k2so-vulcanus-imersium-cermet"])
assert(techs["fw-vulcanus-industrial-symbiosis"].effects[1].recipe
  =="fw-k2so-vulcanus-imersium-cermet")
settings.startup["fw-enable-k2so-integration"].value=false
local n=0
for _ in pairs(raw.recipe) do n=n+1 end
dofile("prototypes/compat/k2so-science.lua")
dofile("prototypes/compat/k2so-planetary.lua")
local after=0
for _ in pairs(raw.recipe) do after=after+1 end
assert(n==after,"Disabled compatibility must not register new prototypes")
print("Genuine RaziLib K2SO: variants, science, icons, unlocks and opt-out pass")
