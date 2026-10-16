-- Optional industrial production from native, *installed* planet resources.
-- This is a data-stage-only factory catalogue, never a world/route patch.
local M = {}
local spectra = {
  purple={fluid="fw-purple-flux",base="fw-flux-resonance"},
  yellow={fluid="fw-yellow-flux",base="fw-flux-chemical-synthesis"},
  red={fluid="fw-red-flux",base="fw-flux-metallurgy"},
  green={fluid="fw-green-flux",base="fw-flux-green-cultivation"},
}
local item_types={"item","tool","module","capsule","ammo"}
local function item(name)
  for _,kind in ipairs(item_types) do
    local obj=data.raw[kind] and data.raw[kind][name]
    if obj and obj.hidden~=true then return obj end
  end
end
local function world(name)
  return data.raw.planet and data.raw.planet[name]
    or data.raw["space-location"] and data.raw["space-location"][name]
end
local function exists(name,kind)
  return kind=="fluid" and data.raw.fluid and data.raw.fluid[name] or item(name)
end
local function produced_index()
  local out={}
  for _,recipe in pairs(data.raw.recipe or {}) do
    if recipe.result then out[recipe.result]=true end
    for _,variant in ipairs({recipe,recipe.normal or {},recipe.expensive or {}}) do
      for _,result in ipairs(variant.results or {}) do
        local name=result.name or result[1]
        if name then out[name]=true end
      end
    end
  end
  for _,kind in ipairs({"resource","simple-entity","asteroid-chunk","asteroid"}) do
    for _,obj in pairs(data.raw[kind] or {}) do
      local minable=obj.minable or {}
      if minable.result then out[minable.result]=true end
      for _,entry in ipairs(minable.results or {}) do
        local name=entry.name or entry[1]
        if name then out[name]=true end
      end
    end
  end
  return out
end
local function discovery_index()
  local found={}
  for name,tech in pairs(data.raw.technology or {}) do
    if tech.hidden~=true and tech.enabled~=false then
      for _,effect in ipairs(tech.effects or {}) do
        if effect.type=="unlock-space-location" and effect.space_location then
          local dest=effect.space_location
          local existing=found[dest]
          if not existing or name=="planet-discovery-"..dest or name<existing then
            found[dest]=name
          end
        end
      end
    end
  end
  return found
end
local function actual_arrival(name,index)
  local techs=data.raw.technology or {}
  local gate=index[name]
  if gate and techs[gate] and techs[gate].enabled~=false then return gate end
  local conventional="planet-discovery-"..name
  if techs[conventional] and techs[conventional].enabled~=false then return conventional end
end
local function pick(candidates,producer)
  for _,name in ipairs(candidates or {}) do
    if item(name) and producer[name] then return name end
  end
end
local function layers(product,colour,partner)
  local icons
  if product.icons then icons=table.deepcopy(product.icons)
  elseif product.icon then icons={{icon=product.icon,icon_size=product.icon_size or 64}}
  else return end
  local function badge(c,x)
    icons[#icons+1]={icon="__FluxWorksAssets__/graphics/icons/fluids/flux-"..c..".png",
      icon_size=256,scale=0.065,shift={x,16}}
  end
  badge(colour,partner and -13 or 14)
  if partner then badge(partner,13) end
  return icons
end
local function has_unlock(tech,recipe)
  for _,effect in ipairs(tech.effects or {}) do
    if effect.type=="unlock-recipe" and effect.recipe==recipe then return true end
  end
end
local function accepted_science()
  local candidates={"automation-science-pack","logistic-science-pack","chemical-science-pack"}
  local known={}
  for _,lab in pairs(data.raw.lab or {}) do
    local set={}
    for _,entry in ipairs(lab.inputs or {}) do set[entry]=true end
    if #candidates>0 and set[candidates[1]] and set[candidates[2]] and set[candidates[3]] then
      for _,name in ipairs(candidates) do
        if item(name) then known[#known+1]={name,1} end
      end
      if #known==3 then return known end
    end
  end
  -- Strictly skip if a common lab cannot accept all packs. Never create
  -- silently unresearchable technologies in an unusually modified modpack.
end
local function available_categories()
  local found={}
  for _,machine in pairs(data.raw["assembling-machine"] or {}) do
    if machine.fixed_recipe==nil then
      local count=0
      for _,box in ipairs(machine.fluid_boxes or {}) do
        if box.production_type=="input" or box.production_type=="input-output" then
          count=count+1
        end
      end
      for _,category in ipairs(machine.crafting_categories or {}) do
        found[category]=math.max(found[category] or 0,count)
      end
    end
  end
  return found
end
local function normalize_name(spec)
  return "fw-"..spec.family.."-"..spec.id
end
function M.register(specs,setting_name)
  local setting=settings and settings.startup and settings.startup[setting_name]
  if setting and setting.value==false then return 0,0 end
  local recipes=data.raw.recipe or {}
  local techs=data.raw.technology or {}
  local products=produced_index()
  local arrivals=discovery_index()
  local science=accepted_science()
  local machines=available_categories()
  if not science then
    log("FluxWorks planetary industry: no common research laboratory")
    return 0,#specs
  end
  local built,skipped=0,0
  for index,spec in ipairs(specs) do
    local name=normalize_name(spec)
    local recipe_name=name.."-process"
    local tech_name=name.."-engineering"
    local discipline=spectra[spec.spectrum]
    local destination=spec.world and world(spec.world)
    local arrival=spec.world and actual_arrival(spec.world,arrivals)
    local second=spec.secondworld and world(spec.secondworld)
    local second_arrival=spec.secondworld and actual_arrival(spec.secondworld,arrivals)
    local native=pick(spec.native,products)
    local other=spec.secondworld and pick(spec.second_native,products)
    local kr_part=spec.k2 and pick(spec.k2,products)
    local output=item(spec.product)
    local feed=item(spec.feed)
    local category=spec.category or (spec.spectrum=="red" and "fw-arc-smelting" or "fw-flux-synthesis")
    local partner=spec.partner
    local fluid_inputs=1+(partner and 1 or 0)
    local valid=discipline and destination and arrival and output and feed and native
      and machines[category] and machines[category]>=fluid_inputs
      and data.raw["recipe-category"] and data.raw["recipe-category"][category]
      and data.raw.fluid and data.raw.fluid[discipline.fluid]
      and techs[discipline.base] and techs[discipline.base].enabled~=false
      and (not partner or spectra[partner] and data.raw.fluid[spectra[partner].fluid])
      and (not spec.secondworld or second and second_arrival and other)
      and (not spec.k2 or mods and mods["Krastorio2-spaced-out"] and kr_part)
      and spec.product~=native and spec.product~=spec.feed
    if valid then
      local picture=layers(output,spec.spectrum,partner)
      if picture and not recipes[recipe_name] and not techs[tech_name] then
        local ingredients={
          {type="item",name=native,amount=spec.native_count or 4},
          {type="item",name=spec.feed,amount=spec.feed_count or 2},
          {type="fluid",name=discipline.fluid,amount=spec.flux_count or 35},
        }
        if other then ingredients[#ingredients+1]={type="item",name=other,amount=spec.second_count or 2} end
        if kr_part then ingredients[#ingredients+1]={type="item",name=kr_part,amount=spec.k2_count or 2} end
        if partner then ingredients[#ingredients+1]={type="fluid",name=spectra[partner].fluid,amount=20} end
        if #ingredients<=6 then
          local prerequisites={arrival,discipline.base}
          if second_arrival and second_arrival~=arrival then
            prerequisites[#prerequisites+1]=second_arrival
          end
          local target=table.deepcopy(picture)
          data:extend({{
            type="recipe",name=recipe_name,icons=picture,
            localised_name={"recipe-name."..recipe_name},
            localised_description={"recipe-description.fw-galaxy-industrial-process"},
            category=category,subgroup=output.subgroup or "intermediate-product",
            order=string.format("zzz[flux-galaxy]-%03d",index),
            enabled=false,auto_recycle=false,allow_productivity=false,
            energy_required=spec.duration or 15,
            ingredients=ingredients,
            results={{type="item",name=spec.product,amount=spec.yield or 3}},
            main_product=spec.product,
          },{
            type="technology",name=tech_name,icons=target,
            localised_name={"technology-name."..tech_name},
            localised_description={"technology-description.fw-galaxy-industrial-technology"},
            prerequisites=prerequisites,
            unit={count=spec.cost or 350,time=30,ingredients=table.deepcopy(science)},
            effects={{type="unlock-recipe",recipe=recipe_name}},
            order=string.format("zzz[flux-galaxy]-%03d",index),
          }})
          built=built+1
        else skipped=skipped+1 end
      elseif recipes[recipe_name] and techs[tech_name] then
        if not has_unlock(techs[tech_name],recipe_name) then
          techs[tech_name].effects=techs[tech_name].effects or {}
          techs[tech_name].effects[#techs[tech_name].effects+1]={
            type="unlock-recipe",recipe=recipe_name}
        end
      else skipped=skipped+1 end
    else skipped=skipped+1 end
  end
  log("FluxWorks planetary "..setting_name..": "..built.." added, "..skipped.." guarded skips")
  return built,skipped
end
return M
