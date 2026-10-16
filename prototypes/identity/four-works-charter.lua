-- The Four Works: FluxWorks' own industrial charter. Independent of Razi.
-- Manufacturing reward rather than a second victory/planet progression system.
local M={}
local spec={
  tech="fw-four-works-charter",
  prerequisites={
    "fw-industrial-program-chemical","fw-industrial-program-thermal",
    "fw-industrial-program-biological","fw-industrial-program-phase",
    "fw-flux-convergence",
  },
  processes={
    {id="precision-logic",category="fw-flux-synthesis",result="fw-logic-matrix",yield=4,time=24,
      ingredients={{"fw-chemical-membrane",2},{"fw-phase-wafer",2},{"@fw-purple-flux",35}}},
    {id="refractory-continuity",category="fw-arc-smelting",result="fw-foundry-lining",yield=6,time=22,
      ingredients={{"fw-thermal-core",2},{"fw-annealed-cermet",2},{"@fw-red-flux",40}}},
    {id="regenerative-assembly",category="fw-flux-synthesis",result="fw-reinforced-seal",yield=8,time=26,
      ingredients={{"fw-living-fiber",2},{"fw-chemical-membrane",2},{"@fw-green-flux",40}}},
    {id="harmonic-matrix",category="fw-flux-synthesis",result="fw-condensed-flux-matrix",yield=3,time=38,
      ingredients={{"fw-chemical-membrane",1},{"fw-thermal-core",1},
        {"fw-phase-wafer",1},{"fw-living-fiber",1},
        {"@fw-purple-flux",30},{"@fw-green-flux",30}}},
  }
}
local Item=require("__razi_lib__/lib/item")
local Technology=require("__razi_lib__/lib/technology")
local function item(name) return Item.optional(name)~=nil end
local function exists(input)
  local name=input[1]
  return name:sub(1,1)=="@" and (data.raw.fluid or {})[name:sub(2)]~=nil
    or item(name)
end
local function labs_accept(packs)
  for _,lab in pairs(data.raw.lab or {}) do
    local inputs={}
    for _,v in ipairs(lab.inputs or {}) do inputs[v]=true end
    local good=true
    for _,name in ipairs(packs) do if not inputs[name] then good=false end end
    if good then return true end
  end
end
local function category_is_buildable(category,fluids)
  if not (data.raw["recipe-category"] or {})[category] then return false end
  for _,machine in pairs(data.raw["assembling-machine"] or {}) do
    local has=false
    for _,x in ipairs(machine.crafting_categories or {}) do
      if x==category then has=true end
    end
    if has then
      local ports=0
      for _,box in ipairs(machine.fluid_boxes or {}) do
        if box.production_type=="input" or box.production_type=="input-output" then ports=ports+1 end
      end
      if ports>=fluids then return true end
    end
  end
end
function M.register()
  local sw=(settings.startup or {})["fw-four-works-charter"]
  if sw and sw.value==false then return 0 end
  local techs=data.raw.technology or {}
  if techs[spec.tech] then return 0 end
  for _,name in ipairs(spec.prerequisites) do
    if not techs[name] or techs[name].enabled==false or techs[name].hidden then
      log("FluxWorks Charter: prerequisite unavailable "..name)
      return 0
    end
  end
  local sciences={"automation-science-pack","logistic-science-pack","chemical-science-pack",
    "production-science-pack","utility-science-pack"}
  for _,name in ipairs(sciences) do if not item(name) then return 0 end end
  if not labs_accept(sciences) then
    log("FluxWorks Charter: no installed laboratory supports required sciences")
    return 0
  end
  local recipes={}
  for _,process in ipairs(spec.processes) do
    if not item(process.result) then return 0 end
    local ingredients,ports={},0
    for _,input in ipairs(process.ingredients) do
      if not exists(input) then
        log("FluxWorks Charter: material unavailable "..input[1])
        return 0
      end
      local fluid=input[1]:sub(1,1)=="@"
      if fluid then ports=ports+1 end
      ingredients[#ingredients+1]={type=fluid and "fluid" or "item",
        name=fluid and input[1]:sub(2) or input[1],amount=input[2]}
    end
    if #ingredients>6 or ports>2 or not category_is_buildable(process.category,ports) then
      log("FluxWorks Charter: manufacturing category unavailable "..process.category)
      return 0
    end
    local name="fw-charter-"..process.id
    if (data.raw.recipe or {})[name] then return 0 end
    recipes[#recipes+1]={
      type="recipe",name=name,enabled=false,
      icon="__FluxWorksAssets__/graphics/icons/upgrade-badges/fw-convergence.png",
      icon_size=128,
      localised_name={"recipe-name."..name},
      localised_description={"recipe-description."..name},
      category=process.category,subgroup="fw-flux-systems",
      order="zz[charter]-"..process.id,
      energy_required=process.time,allow_productivity=false,auto_recycle=false,
      ingredients=ingredients,
      results={{type="item",name=process.result,amount=process.yield}},
      main_product=process.result,
    }
  end
  local ingredients={}
  for _,name in ipairs(sciences) do ingredients[#ingredients+1]={name,1} end
  data:extend({{
    type="technology",name=spec.tech,
    icon="__FluxWorksAssets__/graphics/icons/upgrade-badges/fw-convergence.png",
    icon_size=128,
    localised_name={"technology-name."..spec.tech},
    localised_description={"technology-description."..spec.tech},
    prerequisites=table.deepcopy(spec.prerequisites),
    unit={count=1700,time=45,ingredients=ingredients},
    effects={},order="zz[fluxworks]-a[charter]",
  }})
  data:extend(recipes)
  for _,recipe in ipairs(recipes) do Technology.get(spec.tech):unlock(recipe.name) end
  log("FluxWorks: Four Works charter grants "..#recipes.." manufacturing processes")
  return #recipes
end
M.spec=spec
M.count=M.register()
return M
