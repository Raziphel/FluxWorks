-- Independent FluxWorks Industrial Programs. Additional specializations
-- work in vanilla Space Age, K2SO, and Razi; none owns another mod's story.
local Technology=require("__razi_lib__/lib/technology")
local Item=require("__razi_lib__/lib/item")
local Icon=require("prototypes.lib.industrial-icons")
local program_data={
  {key="chemical",spectrum="yellow",prerequisite="fw-flux-chemical-synthesis",cost=360,science={"automation-science-pack","logistic-science-pack","chemical-science-pack"},processes={
    {id="membrane-recovery",out="fw-inline-filter",yield=5,inputs={{type="item",name="fw-chemical-membrane",amount=1},{type="item",name="fw-metal-mesh",amount=2},{type="fluid",name="fw-yellow-flux",amount=24}}},
    {id="conductive-reclamation",out="fw-circuit-substrate",yield=5,inputs={{type="item",name="fw-chemical-membrane",amount=1},{type="item",name="fw-copper-tube",amount=2},{type="fluid",name="fw-yellow-flux",amount=28}}},
    {id="laminated-composites",out="fw-composite-panel",yield=4,inputs={{type="item",name="fw-chemical-membrane",amount=1},{type="item",name="fw-metal-mesh",amount=2},{type="fluid",name="fw-yellow-flux",amount=30}}},
    {id="sensor-packaging",out="fw-sensor-package",yield=3,inputs={{type="item",name="fw-chemical-membrane",amount=1},{type="item",name="fw-circuit-substrate",amount=2},{type="fluid",name="fw-yellow-flux",amount=32}}},
  }},
  {key="thermal",spectrum="red",prerequisite="fw-flux-metallurgy",cost=650,science={"automation-science-pack","logistic-science-pack","chemical-science-pack","production-science-pack"},processes={
    {id="refractory-recasting",out="fw-annealed-cermet",yield=4,inputs={{type="item",name="fw-thermal-core",amount=1},{type="item",name="fw-cermet",amount=2},{type="fluid",name="fw-red-flux",amount=40}}},
    {id="foundry-renewal",out="fw-foundry-lining",yield=5,inputs={{type="item",name="fw-thermal-core",amount=1},{type="item",name="fw-ceramic-casing",amount=2},{type="fluid",name="fw-red-flux",amount=45}}},
    {id="pressure-armature",out="fw-pressure-housing",yield=3,inputs={{type="item",name="fw-thermal-core",amount=1},{type="item",name="fw-steel-beam",amount=2},{type="fluid",name="fw-red-flux",amount=42}}},
    {id="winding-annealing",out="fw-field-winding",yield=4,inputs={{type="item",name="fw-thermal-core",amount=1},{type="item",name="fw-inductor-coil",amount=2},{type="fluid",name="fw-red-flux",amount=44}}},
  }},
  {key="biological",spectrum="green",prerequisite="fw-flux-green-cultivation",cost=730,science={"automation-science-pack","logistic-science-pack","chemical-science-pack","agricultural-science-pack"},processes={
    {id="fiber-polymerization",out="fw-resin",yield=5,inputs={{type="item",name="fw-living-fiber",amount=1},{type="item",name="bioflux",amount=1},{type="fluid",name="fw-green-flux",amount=40}}},
    {id="biofilter-regeneration",out="fw-inline-filter",yield=5,inputs={{type="item",name="fw-living-fiber",amount=1},{type="item",name="fw-metal-mesh",amount=1},{type="fluid",name="fw-green-flux",amount=35}}},
    {id="seal-cultivation",out="fw-reinforced-seal",yield=4,inputs={{type="item",name="fw-living-fiber",amount=1},{type="item",name="fw-rubber-sheet",amount=2},{type="fluid",name="fw-green-flux",amount=40}}},
    {id="nutrient-architecture",out="fw-nutrient-bed",yield=4,inputs={{type="item",name="fw-living-fiber",amount=1},{type="item",name="spoilage",amount=4},{type="fluid",name="fw-green-flux",amount=45}}},
  }},
  {key="phase",spectrum="purple",prerequisite="fw-flux-resonance",cost=950,science={"automation-science-pack","logistic-science-pack","chemical-science-pack","electromagnetic-science-pack"},processes={
    {id="memory-alignment",out="fw-memory-die",yield=3,inputs={{type="item",name="fw-phase-wafer",amount=1},{type="item",name="fw-microchip",amount=2},{type="fluid",name="fw-purple-flux",amount=45}}},
    {id="lattice-annealing",out="fw-flux-lattice",yield=3,inputs={{type="item",name="fw-phase-wafer",amount=1},{type="item",name="fw-metal-mesh",amount=2},{type="fluid",name="fw-purple-flux",amount=40}}},
    {id="resonance-propagation",out="fw-resonance-substrate",yield=3,inputs={{type="item",name="fw-phase-wafer",amount=1},{type="item",name="fw-sensor-package",amount=2},{type="fluid",name="fw-purple-flux",amount=55}}},
    {id="logic-interference",out="fw-logic-matrix",yield=3,inputs={{type="item",name="fw-phase-wafer",amount=1},{type="item",name="fw-memory-die",amount=2},{type="fluid",name="fw-purple-flux",amount=50}}},
  }},
}
local function exists(ingredient)
  if ingredient.type=="fluid" then return (data.raw.fluid or {})[ingredient.name]~=nil end
  return Item.optional(ingredient.name)~=nil
end
local function has_category(name)
  for _,machine in pairs(data.raw["assembling-machine"] or {}) do
    for _,category in ipairs(machine.crafting_categories or {}) do
      if category==name then return true end
    end
  end
end
local function lab_accepts(packs)
  for _,lab in pairs(data.raw.lab or {}) do
    local found={}
    for _,entry in ipairs(lab.inputs or {}) do found[entry]=true end
    local good=true
    for _,p in ipairs(packs) do if not found[p] then good=false end end
    if good then return true end
  end
end
local function apply()
  local switch=settings and settings.startup and settings.startup["fw-industrial-programs"]
  if switch and switch.value==false then return 0 end
  local built=0
  for _,group in ipairs(program_data) do
    local tech_name="fw-industrial-program-"..group.key
    local category=group.key=="thermal" and "fw-arc-smelting" or "fw-flux-synthesis"
    local techs=data.raw.technology or {}
    local science={}
    for _,pack in ipairs(group.science) do
      if Item.optional(pack) then science[#science+1]=pack end
    end
    if #science==#group.science and lab_accepts(science) and has_category(category)
      and techs[group.prerequisite] and not techs[tech_name] then
      local tech_icon=Icon.spectrum(Item.get(group.processes[1].out):raw(),group.spectrum,nil,"catalog")
      if tech_icon then
        data:extend({{
          type="technology",name=tech_name,icons=tech_icon,
          localised_name={"technology-name."..tech_name},
          localised_description={"technology-description.fw-industrial-program"},
          prerequisites={group.prerequisite},
          unit={count=group.cost,time=30,ingredients=(function()
            local out={}
            for _,pack in ipairs(science) do out[#out+1]={pack,1} end
            return out
          end)()},
          order="v[fw-industrial-program]-"..group.key,
          effects={},
        }})
        for _,spec in ipairs(group.processes) do
          local recipe_name="fw-industrial-program-"..group.key.."-"..spec.id
          local ok=Item.optional(spec.out)~=nil and (data.raw.recipe or {})[recipe_name]==nil
          for _,ing in ipairs(spec.inputs) do if not exists(ing) then ok=false end end
          if ok then
            local output=Item.get(spec.out):raw()
            local icons=Icon.spectrum(output,group.spectrum,nil,"catalog")
            if icons then
              data:extend({{
                type="recipe",name=recipe_name,icons=icons,
                localised_name={"recipe-name."..recipe_name},
                localised_description={"recipe-description.fw-industrial-program"},
                category=category,enabled=false,auto_recycle=false,
                allow_productivity=false,
                energy_required=18,ingredients=table.deepcopy(spec.inputs),
                subgroup=output.subgroup or "intermediate-product",
                order="v[fw-industrial-program]-"..group.key.."-"..spec.id,
                main_product=spec.out,
                results={{type="item",name=spec.out,amount=spec.yield}}
              }})
              Technology.get(tech_name):unlock(recipe_name)
              built=built+1
            end
          end
        end
      end
    end
  end
  log("FluxWorks independent industry: "..built.." specialist manufacturing recipes")
  return built
end
local built=apply()
return {groups=program_data,built=built}
