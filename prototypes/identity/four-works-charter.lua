-- An independent mastery tier: four production rewards, no campaign.
local M={recipes={}}
local sw=(settings.startup or {})["fw-four-works-charter"]
if sw and sw.value==false then return M end
local technology={
  type="technology",name="fw-four-works-charter",
  icon="__FluxWorksAssets__/graphics/icons/identity/fw-four-works-charter.png",
  icon_size=128,
  prerequisites={"fw-flux-convergence"},
  unit={count=1200,time=45,ingredients={
    {"automation-science-pack",1},{"production-science-pack",1},
    {"utility-science-pack",1},{"metallurgic-science-pack",1},
    {"agricultural-science-pack",1},{"electromagnetic-science-pack",1}}},
  effects={},order="z[fw]-h[charter]"
}
local recipes={
  {name="fw-charter-precision-logic",category="fw-flux-synthesis",out="fw-resonance-substrate",amount=5,
   ingredients={{type="item",name="fw-phase-wafer",amount=2},{type="item",name="processing-unit",amount=2},{type="fluid",name="fw-purple-flux",amount=40}}},
  {name="fw-charter-refractory-continuity",category="fw-arc-smelting",out="fw-annealed-cermet",amount=6,
   ingredients={{type="item",name="fw-thermal-core",amount=2},{type="item",name="steel-plate",amount=6},{type="fluid",name="fw-red-flux",amount=40}}},
  {name="fw-charter-regenerative-assembly",category="fw-flux-synthesis",out="fw-living-fiber",amount=7,
   ingredients={{type="item",name="fw-living-fiber",amount=2},{type="item",name="plastic-bar",amount=2},{type="fluid",name="fw-green-flux",amount=50}}},
  {name="fw-charter-harmonic-matrix",category="fw-flux-synthesis",out="fw-condensed-flux-matrix",amount=3,
   ingredients={{type="item",name="fw-convergence-chassis",amount=1},{type="item",name="fw-flux-lattice",amount=2},{type="fluid",name="fw-purple-flux",amount=35},{type="fluid",name="fw-yellow-flux",amount=35}}},
}
local function output_proto(name) return (data.raw.item or {})[name] end
for _,spec in ipairs(recipes) do
  local p=assert(output_proto(spec.out))
  local icons=p.icons and table.deepcopy(p.icons) or {{icon=p.icon,icon_size=p.icon_size or 64}}
  icons[#icons+1]={icon=technology.icon,icon_size=128,scale=0.14,shift={12,12}}
  local entry={type="recipe",name=spec.name,icons=icons,
    localised_name={"recipe-name."..spec.name},
    localised_description={"recipe-description."..spec.name},
    category=spec.category,enabled=false,subgroup="fw-flux-systems",
    energy_required=28,allow_productivity=false,auto_recycle=false,
    ingredients=spec.ingredients,
    results={{type="item",name=spec.out,amount=spec.amount}},
    main_product=spec.out}
  technology.effects[#technology.effects+1]={type="unlock-recipe",recipe=spec.name}
  M.recipes[#M.recipes+1]=entry
end
data:extend({technology})
data:extend(M.recipes)
return M
