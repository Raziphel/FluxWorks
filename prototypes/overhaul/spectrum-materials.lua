-- FluxWorks 0.4: five original, deliberately manufactured spectral components.
-- RaziLib owns the unlock mechanics; Razi owns location and chapter progression.
local Technology=require("__razi_lib__/lib/technology")
local signatures={
  {name="fw-chemical-membrane", label="Catalytic Separation Membrane", category="fw-flux-synthesis",tech="fw-flux-chemical-synthesis",time=9,yield=2,inputs={{type="item",name="fw-inline-filter",amount=2},{type="item",name="fw-circuit-substrate",amount=1},{type="fluid",name="fw-yellow-flux",amount=35}}},
  {name="fw-thermal-core", label="Chromatic Thermal Core", category="fw-arc-smelting",tech="fw-flux-metallurgy",time=13,yield=2,inputs={{type="item",name="fw-cermet",amount=2},{type="item",name="fw-foundry-lining",amount=1},{type="fluid",name="fw-red-flux",amount=40}}},
  {name="fw-phase-wafer", label="Phase Alignment Wafer", category="fw-flux-synthesis",tech="fw-flux-resonance",time=13,yield=2,inputs={{type="item",name="fw-stabilized-flux-crystal",amount=2},{type="item",name="fw-circuit-substrate",amount=2},{type="fluid",name="fw-purple-flux",amount=30}}},
  {name="fw-living-fiber", label="Cultured Living Fiber", category="fw-flux-synthesis",tech="fw-flux-green-cultivation",time=14,yield=3,inputs={{type="item",name="fw-resin",amount=3},{type="item",name="bioflux",amount=2},{type="fluid",name="fw-green-flux",amount=45}}},
  {name="fw-convergence-chassis", label="Four-Spectrum Convergence Chassis", category="fw-flux-synthesis",tech="fw-flux-convergence",time=40,yield=1,inputs={{type="item",name="fw-chemical-membrane",amount=1},{type="item",name="fw-thermal-core",amount=1},{type="item",name="fw-phase-wafer",amount=1},{type="item",name="fw-living-fiber",amount=1},{type="fluid",name="fw-purple-flux",amount=50},{type="fluid",name="fw-green-flux",amount=35}}},
}
local function source_available(entry)
  if entry.type=="fluid" then return data.raw.fluid and data.raw.fluid[entry.name] end
  for _,kind in ipairs({"item","tool","module","ammo","capsule"}) do
    if data.raw[kind] and data.raw[kind][entry.name] then return true end
  end
end
for _,spec in ipairs(signatures) do
  assert(data.raw.technology and data.raw.technology[spec.tech],
    "FluxWorks Reborn signature technology missing: "..spec.tech)
  assert(data.raw["recipe-category"] and data.raw["recipe-category"][spec.category],
    "FluxWorks Reborn signature category missing: "..spec.category)
  for _,input in ipairs(spec.inputs) do
    -- The convergence recipe is registered after the other four new items.
    assert(source_available(input),"FluxWorks Reborn missing real ingredient: "..input.name)
  end
  if data.raw.item and data.raw.item[spec.name] then
    error("FluxWorks Reborn signature item collision: "..spec.name)
  end
  local icon="__FluxWorksAssets__/graphics/icons/industrial/"..spec.name..".png"
  data:extend({
    {type="item",name=spec.name,icon=icon,icon_size=128,
     subgroup="fw-flux-systems",order="v[reborn]-"..spec.name,
     stack_size=100,weight=5000},
    {type="recipe",name=spec.name,icon=icon,icon_size=128,
     category=spec.category,enabled=false,auto_recycle=false,
     allow_productivity=false,energy_required=spec.time,
     subgroup="fw-flux-systems",order="v[reborn]-"..spec.name,
     ingredients=table.deepcopy(spec.inputs),
     results={{type="item",name=spec.name,amount=spec.yield}},
     main_product=spec.name}
  })
  Technology.get(spec.tech):unlock(spec.name)
end
return signatures
