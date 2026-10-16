-- The Seven Foundries: opt-in Razi world flavor for independent FluxWorks.
-- This module creates source-owned technology, recipes, and calibration items.
-- It does NOT alter Razi's worlds, arrivals, science, quests or victory.
local M={registrations={},reports={}}
if not (mods and mods["razi-protocol"]) then return M end
local sw=(settings.startup or {})["fw-razi-seven-foundries"]
if sw and sw.value==false then return M end

local Item=require("__razi_lib__/lib/item")
local Tech=require("__razi_lib__/lib/technology")
local specs={
  {system="calidus",worlds={{"nauvis",{"iron-plate"}}},
    feed="fw-chemical-membrane",product="fw-metal-mesh",yield=8,
    fluid="fw-yellow-flux",base="fw-flux-chemical-synthesis",cost=350},
  {system="solaris",worlds={{"vulcanus",{"tungsten-carbide"}}},
    feed="fw-thermal-core",product="fw-annealed-cermet",yield=5,
    fluid="fw-red-flux",base="fw-flux-metallurgy",cost=500},
  {system="nyxaris",worlds={{"gleba",{"bioflux"}}},
    feed="fw-living-fiber",product="fw-resin",yield=8,
    fluid="fw-green-flux",base="fw-flux-green-cultivation",cost=550},
  {system="vibrant",worlds={{"fulgora",{"holmium-plate"}}},
    feed="fw-phase-wafer",product="fw-resonance-substrate",yield=5,
    fluid="fw-purple-flux",base="fw-flux-resonance",cost=640},
  {system="vespera",worlds={{"aquilo",{"ice"}}},
    feed="fw-thermal-core",product="fw-cryo-coil",yield=5,
    fluid="fw-purple-flux",base="fw-flux-phase-engineering",cost=750},
  {system="beetlejuice",worlds={
    {"secretas",{"gold-plate"}},{"linox",{"rare-earth-powder","linox-rare-earth-powder"}},
    {"ferrum",{"rare-earth-magnet","ferrum-rare-earth-magnet"}}},
    feed="fw-phase-wafer",product="fw-quantum-computer",yield=3,
    fluid="fw-purple-flux",base="fw-flux-resonance",cost=890},
  {system="umbra",worlds={
    {"tenebris",{"chitosan"}},{"vesta",{"supermagnet"}}},
    feed="fw-convergence-chassis",product="fw-flux-phase-manifold",yield=3,
    fluid="fw-purple-flux",base="fw-flux-convergence",cost=1100},
}
local function item(name)
  return name and Item.optional(name)~=nil
end
local function producers()
  local found={}
  for _,recipe in pairs(data.raw.recipe or {}) do
    if recipe.result then found[recipe.result]=true end
    for _,branch in ipairs({recipe,recipe.normal or {},recipe.expensive or {}}) do
      for _,v in ipairs(branch.results or {}) do found[v.name or v[1]]=true end
    end
  end
  for _,kind in ipairs({"resource","simple-entity","asteroid-chunk"}) do
    for _,proto in pairs(data.raw[kind] or {}) do
      local mining=proto.minable or {}
      if mining.result then found[mining.result]=true end
      for _,v in ipairs(mining.results or {}) do found[v.name or v[1]]=true end
    end
  end
  return found
end
local function index_arrivals()
  local list={}
  for name,technology in pairs(data.raw.technology or {}) do
    if technology.enabled~=false and not technology.hidden then
      for _,effect in ipairs(technology.effects or {}) do
        if effect.type=="unlock-space-location" and effect.space_location then
          local dest=effect.space_location
          local old=list[dest]
          if not old or name=="planet-discovery-"..dest or name<old then list[dest]=name end
        end
      end
    end
  end
  return list
end
local function research_lab()
  local science={"automation-science-pack","logistic-science-pack","chemical-science-pack"}
  for _,pack in ipairs(science) do if not item(pack) then return end end
  for _,lab in pairs(data.raw.lab or {}) do
    local accepts={}
    for _,n in ipairs(lab.inputs or {}) do accepts[n]=true end
    if accepts[science[1]] and accepts[science[2]] and accepts[science[3]] then
      return {{science[1],1},{science[2],1},{science[3],1}}
    end
  end
end
local function machine(category,fluid_count)
  if not (data.raw["recipe-category"] or {})[category] then return false end
  for _,obj in pairs(data.raw["assembling-machine"] or {}) do
    if not obj.fixed_recipe then
      local assigned=false
      for _,v in ipairs(obj.crafting_categories or {}) do if v==category then assigned=true end end
      if assigned then
        local ports=0
        for _,b in ipairs(obj.fluid_boxes or {}) do
          if b.production_type=="input" or b.production_type=="input-output" then
            ports=ports+1
          end
        end
        if ports>=fluid_count then return true end
      end
    end
  end
end
local function destination(spec,produced,arrivals)
  for _,record in ipairs(spec.worlds) do
    local planet=record[1]
    local is_real=(data.raw.planet or {})[planet] or (data.raw["space-location"] or {})[planet]
    local arriving=planet=="nauvis" and "fw-flux-stabilization" or arrivals[planet]
    if is_real and arriving and (data.raw.technology or {})[arriving] then
      for _,native in ipairs(record[2]) do
        if item(native) and produced[native] then return planet,native,arriving end
      end
    end
  end
end
function M.register()
  local techs=data.raw.technology or {}
  local recipes=data.raw.recipe or {}
  local produced=producers()
  local arrivals=index_arrivals()
  local science=research_lab()
  if not science then
    log("FluxWorks Seven Foundries: missing common research laboratory")
    return 0
  end
  local ready={}
  for _,spec in ipairs(specs) do
    local planet,native,arrival=destination(spec,produced,arrivals)
    local category=spec.system=="solaris" and "fw-arc-smelting" or "fw-flux-synthesis"
    if planet and native and techs[spec.base] and techs[spec.base].enabled~=false
      and item(spec.feed) and item(spec.product)
      and (data.raw.fluid or {})[spec.fluid] and machine(category,1) then
      local record="fw-foundry-record-"..spec.system
      local recipe="fw-foundry-operation-"..spec.system
      local tech="fw-foundry-commission-"..spec.system
      if not (data.raw.item or {})[record] and not recipes[recipe] and not techs[tech] then
        ready[#ready+1]={spec=spec,planet=planet,native=native,
          arrival=arrival,category=category,record=record,recipe=recipe,technology=tech}
      end
    end
  end
  local built=0
  for _,foundry in ipairs(ready) do
    local s=foundry.spec
    local badge="__FluxWorksAssets__/graphics/icons/system-badges/fw-"..s.system.."-industry.png"
    local prerequisites={foundry.arrival}
    if foundry.arrival~=s.base then prerequisites[#prerequisites+1]=s.base end
    data:extend({
      {type="item",name=foundry.record,icon=badge,icon_size=128,
        localised_name={"item-name."..foundry.record},
        localised_description={"item-description.fw-foundry-record"},
        subgroup="fw-flux-systems",order="zy[seven-foundries]-"..s.system,
        stack_size=30,weight=1000},
      {type="recipe",name=foundry.recipe,icon=badge,icon_size=128,
        localised_name={"recipe-name."..foundry.recipe},
        localised_description={"recipe-description."..foundry.recipe},
        subgroup="fw-flux-systems",order="zy[seven-foundries]-"..s.system,
        category=foundry.category,enabled=false,energy_required=30,
        auto_recycle=false,allow_productivity=false,
        ingredients={{type="item",name=foundry.native,amount=5},
          {type="item",name=s.feed,amount=2},
          {type="fluid",name=s.fluid,amount=45}},
        results={{type="item",name=s.product,amount=s.yield},
          {type="item",name=foundry.record,amount=1}},
        main_product=foundry.record},
      {type="technology",name=foundry.technology,icon=badge,icon_size=128,
        localised_name={"technology-name."..foundry.technology},
        localised_description={"technology-description."..foundry.technology},
        prerequisites=prerequisites,
        unit={count=s.cost,time=35,ingredients=table.deepcopy(science)},
        effects={{type="unlock-recipe",recipe=foundry.recipe}},
        order="zy[seven-foundries]-"..s.system}
    })
    M.registrations[#M.registrations+1]=foundry
    M.reports[#M.reports+1]=foundry.record
    built=built+1
  end

  -- An Atlas is worthwhile even when optional planet packs provide only some
  -- systems. Four different real field records are the minimum foundation.
  if #M.registrations>=4 and item("fw-convergence-chassis")
    and item("fw-condensed-flux-matrix") and item("fw-quantum-computer")
    and machine("fw-origin-forging",0)
    and not techs["fw-foundry-atlas"] and not recipes["fw-foundry-atlas-convergence"] then
    local icon="__FluxWorksAssets__/graphics/icons/system-badges/fw-deep-space-industry.png"
    local ingredients={{type="item",name="fw-convergence-chassis",amount=2}}
    local prerequisites={}
    for _,foundry in ipairs(M.registrations) do
      ingredients[#ingredients+1]={type="item",name=foundry.record,amount=1}
      prerequisites[#prerequisites+1]=foundry.technology
    end
    if techs["fw-origin-infrastructure"] then
      prerequisites[#prerequisites+1]="fw-origin-infrastructure"
    end
    -- The Origin Forge has a finite item-input count. Never exceed it.
    if #ingredients<=10 then
      data:extend({
        {type="recipe",name="fw-foundry-atlas-convergence",icon=icon,icon_size=128,
          localised_name={"recipe-name.fw-foundry-atlas-convergence"},
          localised_description={"recipe-description.fw-foundry-atlas-convergence"},
          category="fw-origin-forging",subgroup="fw-flux-systems",
          order="zz[seven-foundries]-atlas",enabled=false,
          auto_recycle=false,allow_productivity=false,energy_required=90,
          ingredients=ingredients,
          results={{type="item",name="fw-condensed-flux-matrix",amount=10},
            {type="item",name="fw-quantum-computer",amount=4}},
          main_product="fw-condensed-flux-matrix"},
        {type="technology",name="fw-foundry-atlas",icon=icon,icon_size=128,
          localised_name={"technology-name.fw-foundry-atlas"},
          localised_description={"technology-description.fw-foundry-atlas"},
          prerequisites=prerequisites,
          unit={count=2600,time=50,ingredients=table.deepcopy(science)},
          effects={{type="unlock-recipe",recipe="fw-foundry-atlas-convergence"}},
          order="zz[seven-foundries]-atlas"}
      })
      M.atlas=true
    end
  end
  log("FluxWorks Seven Foundries: "..built..
    " Razi field operations and atlas="..tostring(M.atlas or false))
  return built
end
M.specs=specs
M.count=M.register()
return M
