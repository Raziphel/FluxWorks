-- FluxWorks 1.0: one exact, bounded production graph.
-- These IDs exist for their industrial purpose only, no retired source chains.
local function item(n,a) return {type="item",name=n,amount=a} end
local function fluid(n,a) return {type="fluid",name=n,amount=a} end
local F={p="fw-purple-flux",y="fw-yellow-flux",r="fw-red-flux",g="fw-green-flux"}
local recipes={
  {id="fw-salvaged-flux",out="fw-crystalised-flux",yield=3,category="chemistry",
   inputs={item("stone",8),item("sulfur",2),fluid("water",50)},time=8,
   tech="fw-flux-stabilization"},
  {id="fw-flux-catalyst",inputs={item("fw-crystalised-flux",2),item("electronic-circuit",1)},
   time=5,tech="fw-flux-stabilization"},
  {id="fw-stabilized-flux-crystal",inputs={item("fw-crystalised-flux",3),
    item("fw-flux-catalyst",1),fluid(F.p,25)},time=9,category="fw-flux-synthesis",
    tech="fw-flux-resonance"},
  {id="fw-chemical-membrane",inputs={item("plastic-bar",3),
    item("electronic-circuit",2),fluid(F.y,25)},time=10,category="chemistry",
    yield=2,tech="fw-flux-chemical-synthesis"},
  {id="fw-thermal-core",inputs={item("steel-plate",4),item("stone-brick",3),
    fluid(F.r,25)},time=12,category="fw-arc-smelting",yield=2,
    tech="fw-flux-metallurgy"},
  {id="fw-living-fiber",inputs={item("bioflux",2),item("plastic-bar",2),
    fluid(F.g,30)},time=14,category="fw-flux-synthesis",yield=3,
    tech="fw-flux-green-cultivation"},
  {id="fw-phase-wafer",inputs={item("processing-unit",1),
    item("holmium-plate",1),fluid(F.p,35)},time=15,
    category="fw-flux-synthesis",yield=2,tech="fw-flux-resonance"},
  {id="fw-flux-lattice",inputs={item("fw-stabilized-flux-crystal",1),
    item("steel-plate",2),fluid(F.y,25)},time=12,
    category="fw-flux-synthesis",yield=2,tech="fw-flux-resonance"},
  {id="fw-annealed-cermet",inputs={item("fw-thermal-core",1),
    item("steel-plate",4),fluid(F.r,35)},time=18,category="fw-arc-smelting",
    yield=3,tech="fw-flux-metallurgy"},
  {id="fw-resonance-substrate",inputs={item("fw-phase-wafer",1),
    item("electronic-circuit",2),fluid(F.p,35)},time=14,
    category="fw-flux-synthesis",yield=2,tech="fw-flux-resonance"},
  {id="fw-convergence-chassis",inputs={
    item("fw-chemical-membrane",1),item("fw-thermal-core",1),
    item("fw-phase-wafer",1),item("fw-living-fiber",1)},time=24,
    category="fw-flux-synthesis",tech="fw-flux-convergence"},
  {id="fw-condensed-flux-matrix",inputs={item("fw-convergence-chassis",1),
    item("fw-flux-lattice",2),fluid(F.p,45),fluid(F.r,35)},
    time=28,category="fw-flux-synthesis",tech="fw-flux-convergence"},
  {id="fw-flux-resonance-cell",inputs={item("fw-phase-wafer",1),
    item("fw-flux-catalyst",1),fluid(F.p,30)},time=18,
    category="fw-flux-synthesis",tech="fw-flux-convergence"},
  {id="fw-flux-phase-manifold",inputs={item("fw-flux-resonance-cell",2),
    item("fw-convergence-chassis",1),fluid(F.p,55)},
    time=24,category="fw-flux-synthesis",tech="fw-flux-convergence"},
  {id="fw-quantum-computer",inputs={item("processing-unit",4),
    item("fw-phase-wafer",2),fluid(F.p,40)},time=30,
    category="fw-flux-synthesis",tech="fw-flux-convergence"},
  -- Harvesters condition and reclaim physical Flux materials, without
  -- becoming a back door for dozens of custom ores.
  {id="fw-focused-harvest-catalyst",out="fw-flux-catalyst",yield=3,
    category="fw-flux-harvesting",
    inputs={item("fw-crystalised-flux",5),item("copper-plate",2)},
    time=12,tech="fw-flux-stabilization"},
  {id="fw-focused-harvest-lattice",out="fw-flux-lattice",yield=3,
    category="fw-flux-harvesting",
    inputs={item("fw-stabilized-flux-crystal",2),item("steel-plate",2)},
    time=16,tech="fw-flux-resonance"},
  -- The Convergence Forge is not a ceremonial machine. It gets only three
  -- solid-feedstock applications with no mystery resources.
  {id="fw-focused-forge-electronics",out="fw-quantum-computer",yield=4,
    category="fw-origin-forging",
    inputs={item("fw-phase-wafer",2),item("fw-condensed-flux-matrix",1),
      item("processing-unit",2)},
    time=36,tech="fw-origin-infrastructure"},
  {id="fw-focused-forge-refractory",out="fw-annealed-cermet",yield=7,
    category="fw-origin-forging",
    inputs={item("fw-thermal-core",2),item("fw-convergence-chassis",1),
      item("steel-plate",4)},
    time=38,tech="fw-origin-infrastructure"},
  {id="fw-focused-forge-stabilization",out="fw-stabilized-flux-crystal",yield=10,
    category="fw-origin-forging",
    inputs={item("fw-condensed-flux-matrix",2),item("fw-flux-catalyst",2),
      item("processing-unit",3)},
    time=38,tech="fw-origin-infrastructure"},
  -- Three machinery families, one extractor, one capstone and useful logistics.
  {id="fw-flux-condenser",inputs={item("steel-plate",20),
    item("advanced-circuit",10),item("stone-brick",12)},time=12,
    tech="fw-flux-stabilization"},
  {id="fw-flux-harvester",inputs={item("steel-plate",24),
    item("electric-engine-unit",8),item("advanced-circuit",12)},
    time=18,tech="fw-flux-stabilization"},
  {id="fw-synthesis-plant",inputs={item("steel-plate",28),
    item("engine-unit",6),item("advanced-circuit",16)},time=16,
    tech="fw-flux-stabilization"},
  {id="fw-arc-foundry",inputs={item("steel-plate",35),
    item("electric-engine-unit",10),item("concrete",20)},time=18,
    tech="fw-flux-metallurgy"},
  {id="fw-origin-forge",inputs={item("fw-synthesis-plant",1),
    item("fw-arc-foundry",1),item("fw-convergence-chassis",3),
    item("low-density-structure",20)},
    time=65,tech="fw-origin-infrastructure"},

}

local M={designs=recipes}
local function item_proto(name)
  for _,kind in ipairs({"item","tool","module","ammo","capsule"}) do
    local proto=(data.raw[kind] or {})[name]
    if proto then return proto end
  end
end
local function exists(n,kind)
  return kind=="fluid" and (data.raw.fluid or {})[n] or item_proto(n)
end
local function accepted_category(category,fluid_count)
  if not (data.raw["recipe-category"] or {})[category] then return false end
  for _,k in ipairs({"assembling-machine","furnace"}) do
    for _,machine in pairs(data.raw[k] or {}) do
      for _,cat in ipairs(machine.crafting_categories or {}) do
        if cat==category and not machine.fixed_recipe then
          if fluid_count==0 then return true end
          local ports=0
          for _,box in ipairs(machine.fluid_boxes or {}) do
            if box.production_type=="input" or box.production_type=="input-output" then
              ports=ports+1
            end
          end
          if ports>=fluid_count then return true end
        end
      end
    end
  end
end
function M.apply()
  local added={}
  for _,spec in ipairs(recipes) do
    local name=spec.id
    assert(not (data.raw.recipe or {})[name],"Duplicate FluxWorks recipe "..name)
    local out=spec.out or name
    local output=assert(item_proto(out),"Missing focused output "..out)
    local category=spec.category or "crafting"
    local fluid_count=0
    for _,input in ipairs(spec.inputs) do
      assert(exists(input.name,input.type),"Missing source "..input.name.." in "..name)
      if input.type=="fluid" then fluid_count=fluid_count+1 end
    end
    assert(#spec.inputs<=5 and fluid_count<=2 and accepted_category(category,fluid_count),
      "No buildable machine/ports for "..name)
    local technology=assert((data.raw.technology or {})[spec.tech],
      "Missing core research "..spec.tech)
    local recipe={
      type="recipe",name=name,category=category,enabled=false,
      energy_required=spec.time or 10,subgroup=output.subgroup or "fw-flux-systems",
      order="z[fw-focused]-"..name,ingredients=table.deepcopy(spec.inputs),
      results={{type="item",name=out,amount=spec.yield or 1}},
      main_product=out,allow_productivity=false,auto_recycle=false,
      allow_decomposition=false
    }
    if output.icons then recipe.icons=table.deepcopy(output.icons)
    elseif output.icon then recipe.icon=output.icon;recipe.icon_size=output.icon_size or 64
    else error("Missing output icon for "..out) end
    added[#added+1]=recipe
    technology.effects=technology.effects or {}
    technology.effects[#technology.effects+1]={type="unlock-recipe",recipe=name}
  end
  data:extend(added)
  M.count=#added
  log("FluxWorks: loaded "..M.count.." real manufacturing recipes")
  return M.count
end
return M
