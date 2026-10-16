-- The old Origin Forge remains a physical endgame industrial machine,
-- not a separate victory condition. Its assembler-3 prototype has no fluid
-- inlets, so all these recipes deliberately use solid-only feedstocks.
local Technology=require("__razi_lib__/lib/technology")
local Icons=require("prototypes.lib.industrial-icons")
local recipes={
  {id="refractory-recasting",out="fw-annealed-cermet",yield=6,
   inputs={{"fw-thermal-core",2},{"fw-convergence-chassis",1},{"fw-cermet",3}}},
  {id="photonic-logic",out="fw-logic-matrix",yield=4,
   inputs={{"fw-chemical-membrane",2},{"fw-phase-wafer",2},{"fw-logic-matrix",2}}},
  {id="living-seal-engineering",out="fw-reinforced-seal",yield=6,
   inputs={{"fw-living-fiber",3},{"fw-thermal-core",1},{"fw-resin",3}}},
  {id="quantum-assembly",out="fw-quantum-computer",yield=2,
   inputs={{"fw-convergence-chassis",2},{"fw-logic-matrix",2},{"processing-unit",4}}},
}
local output={}
local machines=data.raw["assembling-machine"] or {}
local forge=machines["fw-origin-forge"]
local category=data.raw["recipe-category"] and data.raw["recipe-category"]["fw-origin-forging"]
local research=data.raw.technology and data.raw.technology["fw-origin-infrastructure"]
if not (forge and category and research) then
  log("FluxWorks Reborn: no staffed Origin Forge technology; capstone recipes unavailable")
  return output
end
local Item=require("__razi_lib__/lib/item")
for _,spec in ipairs(recipes) do
  local product=Item.optional(spec.out)
  local ingredients={}
  local valid=product~=nil
  for _,source in ipairs(spec.inputs) do
    local name=source[1]
    if not Item.optional(name) then
      if name=="processing-unit" and Item.optional("kr-processing-unit") then
        name="kr-processing-unit"
      else
        valid=false
      end
    end
    ingredients[#ingredients+1]={type="item",name=name,amount=source[2]}
  end
  local name="fw-reborn-forge-"..spec.id
  if valid and not (data.raw.recipe or {})[name] then
    local art=Icons.spectrum(product:raw(),"purple","red","catalog")
    if art then
      data:extend({{
        type="recipe",name=name,icons=art,enabled=false,
        category="fw-origin-forging",energy_required=40,
        subgroup="fw-flux-systems",order="w[reborn]-"..spec.id,
        allow_productivity=false,auto_recycle=false,
        ingredients=ingredients,
        results={{type="item",name=spec.out,amount=spec.yield}},
        main_product=spec.out
      }})
      Technology.get("fw-origin-infrastructure"):unlock(name)
      output[#output+1]=name
    end
  end
end
log("FluxWorks Reborn: "..#output.." endgame forge processes enabled")
return output
