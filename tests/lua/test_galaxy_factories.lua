-- Run with lua tests/lua/test_galaxy_factories.lua in the FluxWorks root.
dofile("tests/lua/support/razi_lib_bootstrap.lua").install()
local function copy(x)
  if type(x)~="table" then return x end
  local out={}
  for k,v in pairs(x) do out[copy(k)]=copy(v) end
  return out
end
table.deepcopy=copy
_G.log=function() end
_G.mods={["razi-protocol"]="2.1.118",["Krastorio2-spaced-out"]="2.1.0"}
_G.settings={startup={["fw-rp-galactic-industry"]={value=true},
  ["fw-rp-k2so-galaxy-industry"]={value=true},
  ["fw-rp-interplanetary-factories"]={value=true}}}
local raw={item={},tool={},recipe={},technology={},planet={},fluid={},
 ["recipe-category"]={},["assembling-machine"]={},lab={}}
_G.data={raw=raw}
function data:extend(definitions)
  for _,p in ipairs(definitions) do
    local kind=assert(raw[p.type],"Unexpected generated prototype type "..p.type)
    assert(not kind[p.name],"Prototype collision: "..p.name)
    kind[p.name]=p
  end
end
for _,name in ipairs({"automation-science-pack","logistic-science-pack",
  "chemical-science-pack"}) do raw.tool[name]={icon="science.png",icon_size=64} end
raw.lab.lab={inputs={"automation-science-pack","logistic-science-pack","chemical-science-pack"}}
for _,name in ipairs({"bioflux","tungsten-carbide","fw-resin","fw-metal-mesh",
    "fw-annealed-cermet","fw-cermet","fw-nutrient-bed","kr-biomass"}) do
  raw.item[name]={icon="example.png",icon_size=64,subgroup="intermediate-product"}
end
for _,name in ipairs({"bioflux","tungsten-carbide","fw-resin","fw-cermet","kr-biomass"}) do
  raw.recipe["original-"..name]={results={{type="item",name=name,amount=1}}}
end
for _,name in ipairs({"gleba","vulcanus","nauvis"}) do raw.planet[name]={} end
for _,name in ipairs({"gleba","vulcanus"}) do
  raw.technology["planet-discovery-"..name]={
    effects={{type="unlock-space-location",space_location=name}}
  }
end
for _,name in ipairs({"fw-flux-green-cultivation","fw-flux-metallurgy",
  "fw-flux-stabilization"}) do raw.technology[name]={} end
for _,name in ipairs({"fw-red-flux","fw-green-flux"}) do raw.fluid[name]={} end
for _,name in ipairs({"fw-arc-smelting","fw-flux-synthesis"}) do
  raw["recipe-category"][name]={}
end
raw["assembling-machine"].plant={crafting_categories={"fw-arc-smelting","fw-flux-synthesis"},
  fluid_boxes={{production_type="input"},{production_type="input"}}}
local lib=dofile("prototypes/compat/galactic-industry-framework.lua")
local specs={{id="gleba-reclamation",family="planet",world="gleba",native={"bioflux"},
  feed="fw-resin",product="fw-nutrient-bed",spectrum="green"},
 {id="uninstalled",family="planet",world="missing-world",native={"bioflux"},
  feed="fw-resin",product="fw-nutrient-bed",spectrum="green"}}
local built,skipped=lib.register(specs,"fw-rp-galactic-industry")
assert(built==1 and skipped==1)
assert(raw.recipe["fw-planet-gleba-reclamation-process"])
assert(raw.technology["fw-planet-gleba-reclamation-engineering"])
assert(raw.recipe["original-bioflux"].results[1].amount==1)
assert(#raw.technology["planet-discovery-gleba"].effects==1)
assert(select(1,lib.register(specs,"fw-rp-galactic-industry"))==0)
-- Verify a two-world freight recipe demands both arrivals.
local pairs={{id="forge",family="freight",world="vulcanus",secondworld="gleba",
  native={"tungsten-carbide"},second_native={"bioflux"},
  product="fw-annealed-cermet",feed="fw-cermet",spectrum="red"}}
assert(select(1,lib.register(pairs,"fw-rp-interplanetary-factories"))==1)
local freight=raw.technology["fw-freight-forge-engineering"]
assert(#freight.prerequisites==3)
settings.startup["fw-rp-interplanetary-factories"].value=false
assert(select(1,lib.register(pairs,"fw-rp-interplanetary-factories"))==0)
-- K2SO hybrid recipes need real K2SO material, and no native world edits.
local hybrids={{id="biomass",family="k2-galaxy",world="gleba",native={"bioflux"},
 k2={"kr-biomass"},product="fw-nutrient-bed",feed="fw-resin",spectrum="green"}}
assert(select(1,lib.register(hybrids,"fw-rp-k2so-galaxy-industry"))==1)
-- A renamed source material is still usable when its item declares the
-- actual home planet. Do not fall back to unrelated ordinary resources.
raw.planet.ribbonia={}
raw.technology["planet-discovery-ribbonia"]={
 effects={{type="unlock-space-location",space_location="ribbonia"}}
}
raw.item["ribbonia-prism"]={icon="prism.png",icon_size=64,
 default_import_location="ribbonia"}
raw.recipe["original-ribbonia-prism"]={
 results={{type="item",name="ribbonia-prism",amount=1}}
}
raw.technology["fw-flux-resonance"]={}
raw.fluid["fw-purple-flux"]={}
local recovered={{id="ribbonia-source",family="planet",world="ribbonia",
 native={"old-ribbonia-crystal"},product="fw-annealed-cermet",
 feed="fw-cermet",spectrum="purple"}}
assert(select(1,lib.register(recovered,"fw-rp-galactic-industry"))==1)
local resolved=raw.recipe["fw-planet-ribbonia-source-process"]
assert(resolved.ingredients[1].name=="ribbonia-prism")

dofile("prototypes/validation/galactic-factories.lua")
print("Galaxy factory guards: installed world, missing world, freight, K2SO, source preservation OK")
