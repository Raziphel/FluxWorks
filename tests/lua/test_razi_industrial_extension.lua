-- Offline prototype mock for the extra factory recipes and settings.
dofile("tests/lua/support/razi_lib_bootstrap.lua").install()
local function copy(x)
  if type(x) ~= "table" then return x end
  local result = {}
  for k,v in pairs(x) do result[copy(k)] = copy(v) end
  return result
end
table.deepcopy = copy
local items = {"fw-foundry-lining","steel-plate","fw-carbon","fw-resin","fw-metal-mesh",
"copper-plate","fw-circuit-substrate","fw-reinforced-seal","fw-rubber-sheet",
"fw-inline-filter","fw-nutrient-bed","fw-cermet","fw-resonance-substrate",
"fw-sensor-package","fw-flux-lattice","fw-thermal-buffer","fw-ceramic-casing",
"fw-annealed-cermet","fw-aquilo-cryogel","fw-capacitor"}
local techs = {"fw-flux-metallurgy","fw-flux-resonance","fw-flux-chemical-synthesis",
"fw-flux-green-cultivation","fw-cross-planetary-industrial-convergence",
"fw-aquilo-thermal-symbiosis"}
local fluids = {"fw-red-flux","fw-purple-flux","fw-yellow-flux","fw-green-flux"}
local function world(depth, missing)
  _G.settings = {startup = {["fw-rp-industrial-depth"] = {value = depth}}}
  _G.log = function() end
  local raw = {recipe={},technology={},item={},fluid={},["recipe-category"]={},
    ["item-subgroup"]={}}
  for _,name in ipairs(items) do
    if name ~= missing then raw.item[name] = {icon="__base__/graphics/icons/iron-plate.png",
      icon_size=64,subgroup="intermediate-product"} end
  end
  for _,name in ipairs(techs) do raw.technology[name]={effects={}} end
  for _,name in ipairs(fluids) do raw.fluid[name]={} end
  for _,name in ipairs({"fw-arc-smelting","fw-flux-synthesis"}) do raw["recipe-category"][name]={} end
  for _,name in ipairs({"purple","yellow","red","green"}) do raw["item-subgroup"]["fw-flux-"..name]={} end
  _G.data={raw=raw}
  function data:extend(prototypes)
    for _,p in ipairs(prototypes) do assert(not raw[p.type][p.name]);raw[p.type][p.name]=p end
  end
  return raw
end
local raw=world("expanded")
dofile("prototypes/recipes/razi-industrial-extension.lua")
local count,paired=0,0
for name,recipe in pairs(raw.recipe) do
  count=count+1
  assert(recipe.enabled==false and recipe.allow_productivity==false)
  assert(recipe.icons and #recipe.icons>=2)
  if #recipe.icons==3 then paired=paired+1 end
  local fluid_count=0
  for _,input in ipairs(recipe.ingredients) do
    assert(input.amount>0)
    if input.type=="fluid" then fluid_count=fluid_count+1;assert(raw.fluid[input.name])
    else assert(raw.item[input.name]) end
  end
  assert(fluid_count<=2)
  local found=0
  for _,tech in pairs(raw.technology) do
    for _,effect in ipairs(tech.effects) do
      if effect.type=="unlock-recipe" and effect.recipe==name then found=found+1 end
    end
  end
  assert(found==1,"Exactly one research unlock for "..name)
end
assert(count==8 and paired==5)
dofile("prototypes/recipes/razi-industrial-extension.lua")
local repeated=0
for _ in pairs(raw.recipe) do repeated=repeated+1 end
assert(repeated==8)
local core=world("core")
dofile("prototypes/recipes/razi-industrial-extension.lua")
assert(next(core.recipe)==nil)
local missing=world("expanded","fw-aquilo-cryogel")
dofile("prototypes/recipes/razi-industrial-extension.lua")
assert(not missing.recipe["fw-industry-thermal-buffer-lamination"])
assert(missing.recipe["fw-industry-living-filtration"])
_G.settings={startup={["fw-rp-industrial-power"]={value="efficient"}}}
raw["assembling-machine"]={["fw-precision-synthesis-plant"]={energy_usage="7.2MW"}}
local balance=dofile("prototypes/updates/razi-industrial-balance.lua")
assert(balance.apply()==1)
assert(raw["assembling-machine"]["fw-precision-synthesis-plant"].energy_usage=="5.400MW")
print("FluxWorks industrial extension: eight recipes, five chromatic paths, guards and power OK")
