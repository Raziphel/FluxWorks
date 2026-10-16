-- FluxWorks 0.7: radical *default* industrial simplification.
-- Retired prototypes remain to avoid deleting existing saved inventories.
-- Nothing in this module changes a non-FluxWorks recipe or planet discovery.
local M={}
local function raw(kind,name) return (data.raw[kind] or {})[name] end
local function available(kind,name)
  if kind=="fluid" then return raw("fluid",name)~=nil end
  for _,t in ipairs({"item","tool","module","ammo","capsule","item-with-entity-data"}) do
    if raw(t,name) then return true end
  end
  return false
end
local function item(n,a) return {type="item",name=n,amount=a or 1} end
local function fluid(n,a) return {type="fluid",name=n,amount=a or 20} end
local F={p="fw-purple-flux",y="fw-yellow-flux",r="fw-red-flux",g="fw-green-flux"}
-- These are the only permanent manufactured inputs that define FluxWorks.
-- Four fluids, a shared crystalline catalyst economy, and four signatures.
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
  {id="fw-convergence-synthesis-plant",inputs={
    item("fw-synthesis-plant",1),item("fw-arc-foundry",1),
    item("fw-convergence-chassis",2),item("processing-unit",12)},
    time=45,tech="fw-flux-convergence"},
  {id="fw-origin-forge",inputs={item("fw-convergence-synthesis-plant",1),
    item("fw-convergence-chassis",3),item("low-density-structure",20)},
    time=65,tech="fw-origin-infrastructure"},
  {id="fw-phase-vault",inputs={item("steel-chest",8),
    item("processing-unit",8),item("fw-phase-wafer",2)},
    time=18,tech="fw-flux-convergence"},
  {id="fw-spectral-reservoir",inputs={item("storage-tank",4),
    item("processing-unit",6),item("fw-chemical-membrane",3)},
    time=20,tech="fw-flux-convergence"},
  {id="fw-rift-exchange-gate",inputs={item("fw-phase-vault",1),
    item("fw-flux-phase-manifold",2),item("processing-unit",10)},
    time=45,tech="fw-origin-infrastructure"},
  {id="fw-rift-exchange-fluid-gate",inputs={item("fw-spectral-reservoir",1),
    item("fw-flux-phase-manifold",2),item("processing-unit",10)},
    time=45,tech="fw-origin-infrastructure"},
}
local techs={
  {id="fw-flux-stabilization",requires={"chemical-science-pack"},
    sciences={"automation-science-pack","logistic-science-pack","chemical-science-pack"},count=120},
  {id="fw-flux-chemical-synthesis",requires={"fw-flux-stabilization"},
    sciences={"automation-science-pack","logistic-science-pack","chemical-science-pack"},count=200},
  {id="fw-flux-metallurgy",requires={"fw-flux-stabilization","metallurgic-science-pack"},
    sciences={"automation-science-pack","logistic-science-pack","metallurgic-science-pack"},count=350},
  {id="fw-flux-green-cultivation",requires={"fw-flux-stabilization","agricultural-science-pack"},
    sciences={"automation-science-pack","logistic-science-pack","agricultural-science-pack"},count=350},
  {id="fw-flux-resonance",requires={"fw-flux-stabilization","electromagnetic-science-pack"},
    sciences={"automation-science-pack","chemical-science-pack","electromagnetic-science-pack"},count=400},
  {id="fw-flux-convergence",requires={"fw-flux-chemical-synthesis","fw-flux-metallurgy",
    "fw-flux-green-cultivation","fw-flux-resonance"},
    sciences={"automation-science-pack","metallurgic-science-pack",
    "agricultural-science-pack","electromagnetic-science-pack","utility-science-pack"},count=700},
  {id="fw-origin-infrastructure",requires={"fw-flux-convergence","cryogenic-science-pack"},
    sciences={"automation-science-pack","electromagnetic-science-pack",
    "cryogenic-science-pack","utility-science-pack"},count=900},
}
local mappings={
  ["fw-chemical-membrane"]="fw-chemical-membrane",
  ["fw-phase-wafer"]="fw-phase-wafer",
  ["fw-thermal-core"]="fw-thermal-core",
  ["fw-living-fiber"]="fw-living-fiber",
  ["fw-convergence-chassis"]="fw-convergence-chassis",
}
local keepItems={
  "fw-crystalised-flux","fw-flux-catalyst","fw-stabilized-flux-crystal",
  "fw-flux-lattice","fw-annealed-cermet","fw-resonance-substrate",
  "fw-condensed-flux-matrix","fw-flux-resonance-cell","fw-flux-phase-manifold",
  "fw-quantum-computer","fw-chemical-membrane","fw-thermal-core",
  "fw-living-fiber","fw-phase-wafer","fw-convergence-chassis",
  "fw-flux-condenser","fw-flux-harvester","fw-synthesis-plant",
  "fw-arc-foundry","fw-convergence-synthesis-plant","fw-origin-forge",
  "fw-phase-vault","fw-spectral-reservoir","fw-rift-exchange-gate",
  "fw-rift-exchange-fluid-gate",
  -- Preserve invisible packed state/scripting tokens used by saved equipment.
  "fw-phase-vault-packed","fw-spectral-reservoir-packed","fw-memory-gui-item"
}
local function list(s)
  local r={} for _,x in ipairs(s) do r[x]=true end return r
end
local keep=list(keepItems)
local function belongs_to_mod(name)
  return type(name)=="string" and name:sub(1,3)=="fw-"
end
local function present(name)
  return available("item",name)
end
local function resolve_item(name)
  if present(name) then return name end
  local aliases={["holmium-plate"]="kr-rare-metals",["bioflux"]="nutrients",
    ["electric-engine-unit"]="engine-unit"}
  if aliases[name] and present(aliases[name]) then return aliases[name] end
  return nil
end
local function add_unlock(tech,recipe_name)
  for _,effect in ipairs(tech.effects or {}) do
    if effect.type=="unlock-recipe" and effect.recipe==recipe_name then return end
  end
  tech.effects=tech.effects or {}
  tech.effects[#tech.effects+1]={type="unlock-recipe",recipe=recipe_name}
end
local function replace_recipe(spec)
  local name=spec.id
  if not spec.out then spec.out=name end
  assert(present(spec.out),"Focused FluxWorks output absent: "..spec.out)
  assert(raw("recipe-category",spec.category or "crafting"),
    "Focused category absent: "..(spec.category or "crafting"))
  local inputs={}
  for _,input in ipairs(spec.inputs) do
    local resolved=input.type=="fluid" and input.name or resolve_item(input.name)
    assert(resolved and available(input.type,resolved),
      "Focused FluxWorks source unavailable: "..input.name)
    inputs[#inputs+1]={type=input.type,name=resolved,amount=input.amount}
  end
  assert(#inputs<=5,"Focused industry needs maximum five feeds: "..name)
  local recipe=raw("recipe",name)
  if not recipe then
    recipe={type="recipe",name=name,enabled=false,
      icon="__FluxWorksAssets__/graphics/icons/items/crystallized-flux.png",
      icon_size=64,
      subgroup="fw-flux-systems",order="a[focused]-"..name}
    data:extend({recipe})
    recipe=assert(raw("recipe",name))
  end
  recipe.category=spec.category or "crafting"
  recipe.ingredients=table.deepcopy(inputs)
  recipe.results={{type="item",name=spec.out,amount=spec.yield or 1}}
  recipe.main_product=spec.out
  recipe.enabled=false
  recipe.hidden=false
  recipe.allow_decomposition=false
  recipe.auto_recycle=false
  recipe.energy_required=spec.time or 10
  if recipe.normal then
    recipe.normal.ingredients=table.deepcopy(inputs)
    recipe.normal.results=table.deepcopy(recipe.results)
    recipe.normal.enabled=false
  end
  if recipe.expensive then
    recipe.expensive.ingredients=table.deepcopy(inputs)
    recipe.expensive.results=table.deepcopy(recipe.results)
    recipe.expensive.enabled=false
  end
  local tech=assert(raw("technology",spec.tech),"Missing lean research "..spec.tech)
  add_unlock(tech,name)
  return name
end
local function no_custom_patches()
  -- No FluxWorks-specific ore veins, mixed deposits, salt, promethium shards
  -- or crystal rifts generate in new chunks. Existing maps aren't destroyed.
  local removed=0
  local lost={}
  for name,proto in pairs(data.raw.resource or {}) do
    if belongs_to_mod(name) then
      lost[name]=true
      if proto.autoplace then
        proto.autoplace=nil
        removed=removed+1
      end
    end
  end
  for _,planet in pairs(data.raw.planet or {}) do
    local map=planet.map_gen_settings or {}
    local settings=map.autoplace_settings or {}
    for name in pairs(lost) do
      if settings.entity and settings.entity.settings then
        settings.entity.settings[name]=nil
      end
      if map.autoplace_controls then map.autoplace_controls[name]=nil end
    end
  end
  return removed,lost
end
local function prune_old_graph(activeRecipes)
  local removedItems,removedRecipes,removedTech=0,0,0
  -- Retain all old IDs in data.raw for save compatibility; hide them, and
  -- explicitly remove their recipe unlock effects from the playable research.
  for name,recipe in pairs(data.raw.recipe or {}) do
    if belongs_to_mod(name) and not activeRecipes[name] then
      recipe.enabled=false
      recipe.hidden=true
      if recipe.normal then recipe.normal.enabled=false end
      if recipe.expensive then recipe.expensive.enabled=false end
      removedRecipes=removedRecipes+1
    end
  end
  for name,proto in pairs(data.raw.item or {}) do
    if belongs_to_mod(name) and not keep[name]
      and not name:match("^fw%-foundry%-record%-")
      and not name:match("^fw%-foundry%-folio%-") then
      proto.hidden=true
      removedItems=removedItems+1
    end
  end
  local activeTech={}
  for _,record in ipairs(techs) do activeTech[record.id]=true end
  activeTech["fw-four-works-charter"]=true
  if mods and mods["razi-protocol"] then
    for name in pairs(data.raw.technology or {}) do
      if name:match("^fw%-foundry%-commission%-") or name=="fw-foundry-atlas" then
        activeTech[name]=true
      end
    end
  end
  for name,tech in pairs(data.raw.technology or {}) do
    if belongs_to_mod(name) then
      if activeTech[name] then
        tech.hidden=false
        local good={}
        for _,effect in ipairs(tech.effects or {}) do
          if effect.type~="unlock-recipe" or activeRecipes[effect.recipe] then
            good[#good+1]=effect
          end
        end
        tech.effects=good
      else
        tech.hidden=true
        removedTech=removedTech+1
      end
    end
  end
  -- No external tech may be made unresearchable by an old hidden FluxWorks
  -- prerequisite left by legacy compatibility passes.
  for name,tech in pairs(data.raw.technology or {}) do
    if not activeTech[name] and tech.prerequisites then
      local cleaned={}
      for _,p in ipairs(tech.prerequisites) do
        if not (belongs_to_mod(p) and not activeTech[p]) then
          cleaned[#cleaned+1]=p
        end
      end
      tech.prerequisites=cleaned
    end
  end
  return removedItems,removedRecipes,removedTech
end
local function rewrite_charter(active)
  local charter=raw("technology","fw-four-works-charter")
  if not charter then return end
  charter.prerequisites={"fw-flux-chemical-synthesis",
    "fw-flux-metallurgy","fw-flux-green-cultivation",
    "fw-flux-resonance","fw-flux-convergence"}
  local forms={
    ["fw-charter-precision-logic"]={
      item("fw-phase-wafer",2),item("processing-unit",2),fluid(F.p,40)},
    ["fw-charter-refractory-continuity"]={
      item("fw-thermal-core",2),item("steel-plate",5),fluid(F.r,45)},
    ["fw-charter-regenerative-assembly"]={
      item("fw-living-fiber",2),item("fw-chemical-membrane",1),fluid(F.g,45)},
    ["fw-charter-harmonic-matrix"]={
      item("fw-convergence-chassis",2),item("fw-flux-lattice",2),
      fluid(F.p,40),fluid(F.y,30)},
  }
  for name,ingredients in pairs(forms) do
    local recipe=raw("recipe",name)
    if recipe then
      recipe.ingredients=ingredients
      recipe.enabled=false
      recipe.hidden=false
      active[name]=true
      add_unlock(charter,name)
    end
  end
end
local function rewrite_foundries(active)
  if not (mods and mods["razi-protocol"]) then return end
  for name,recipe in pairs(data.raw.recipe or {}) do
    if name:match("^fw%-foundry%-operation%-")
      or name:match("^fw%-foundry%-reconcile%-")
      or name:match("^fw%-foundry%-folio%-")
      or name=="fw-foundry-atlas-convergence" then
      active[name]=true
    end
  end
end
local function apply()
  local mode=(settings.startup or {})["fw-design-profile"]
  if mode and mode.value=="legacy" then
    log("FluxWorks: using compatibility industry, preserved for existing saves")
    return {legacy=true}
  end
  local removedResources=no_custom_patches()
  -- The legacy compatibility pass may have registered six decorative mineral
  -- bacteria and recipes earlier. The reduced factory must not require them.

  local techMap={}
  for _,record in ipairs(techs) do
    local tech=assert(raw("technology",record.id),
      "Focused FluxWorks missing core research: "..record.id)
    techMap[record.id]=tech
    tech.prerequisites=table.deepcopy(record.requires)
    tech.unit={count=record.count,time=30,ingredients={}}
    for _,pack in ipairs(record.sciences) do
      assert(present(pack),"Focused science missing "..pack)
      tech.unit.ingredients[#tech.unit.ingredients+1]={pack,1}
    end
    tech.effects={}
  end
  local active={}
  for _,spec in ipairs(recipes) do
    active[replace_recipe(spec)]=true
  end
  rewrite_charter(active)
  rewrite_foundries(active)
  local retiredItems,retiredRecipes,retiredTechnologies=prune_old_graph(active)
  -- Focused industry is for factories and trade, not alternative space
  -- scenarios. Legacy resources are still present in saves, but no new ores.
  M.report={active=#recipes,retiredItems=retiredItems,
    retiredRecipes=retiredRecipes,retiredTechnologies=retiredTechnologies,
    decommissionedResourceTypes=removedResources}
  log(("FluxWorks Focused: %d working recipes, %d retired items, %d retired recipes,"
    .." %d retired technologies, %d resource deposits disabled"):format(
    M.report.active,retiredItems,retiredRecipes,retiredTechnologies,
    removedResources))
  return M.report
end
M.recipes=recipes
M.technologies=techs
M.keep=keep
M.apply=apply
return M
