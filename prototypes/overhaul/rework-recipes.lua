local M={}
local designs=require("prototypes.overhaul.bill-of-materials")
local replaceable={silicon="kr-silicon",glass="kr-glass",lithium="kr-lithium",
  sand="kr-sand",oxygen="kr-oxygen",hydrogen="kr-hydrogen"}
local function resolve(entry)
  local name=entry.name
  local kind=entry.type=="fluid" and "fluid" or "item"
  local function exists(key)
    if kind=="fluid" then return data.raw.fluid and data.raw.fluid[key] end
    for _,category in ipairs({"item","tool","module","ammo","capsule"}) do
      if data.raw[category] and data.raw[category][key] then return true end
    end
  end
  if exists(name) then return table.deepcopy(entry) end
  local alternate=replaceable[name]
  if alternate and exists(alternate) then
    local copy=table.deepcopy(entry);copy.name=alternate;return copy
  end
end
local function check_cycles(specs)
  local recipe_by_output={}
  for _,spec in ipairs(specs) do recipe_by_output[spec.name]=spec end
  local visiting,completed={},{}
  local function visit(name)
    if completed[name] then return end
    if visiting[name] then error("FluxWorks Reborn production cycle at "..name) end
    visiting[name]=true
    local spec=recipe_by_output[name]
    for _,input in ipairs(spec and spec.inputs or {}) do
      if input.type~="fluid" and recipe_by_output[input.name] then visit(input.name) end
    end
    visiting[name]=nil;completed[name]=true
  end
  for name in pairs(recipe_by_output) do visit(name) end
end
function M.apply()
  check_cycles(designs)
  local profile=settings and settings.startup and settings.startup["fw-rp-factory-design"]
  if profile and profile.value=="legacy" then return 0 end
  local altered,missing=0,{}
  for _,spec in ipairs(designs) do
    local recipe=data.raw.recipe and data.raw.recipe[spec.name]
    local ingredients={}
    if not recipe then
      missing[#missing+1]=spec.name
    else
      local valid=true
      for _,ingredient in ipairs(spec.inputs) do
        local resolved=resolve(ingredient)
        if not resolved then valid=false;break end
        ingredients[#ingredients+1]=resolved
      end
      if valid then
        assert(#ingredients<=6,"Reborn bill exceeds assembler ingredient capacity: "..spec.name)
        local fluids=0
        for _,input in ipairs(ingredients) do
          if input.type=="fluid" then fluids=fluids+1 end
        end
        assert(fluids<=2,"Reborn factory recipe exceeds physical pipe ports: "..spec.name)
        recipe.ingredients=table.deepcopy(ingredients)
        if recipe.normal then recipe.normal.ingredients=table.deepcopy(ingredients) end
        if recipe.expensive then recipe.expensive.ingredients=table.deepcopy(ingredients) end
        recipe.energy_required=spec.time
        if recipe.normal then recipe.normal.energy_required=spec.time end
        if recipe.expensive then recipe.expensive.energy_required=spec.time end
        altered=altered+1
      else
        missing[#missing+1]=spec.name..":source-resource"
      end
    end
  end
  log(("FluxWorks Reborn: redesigned %d/%d original factory bills; %d guarded skips")
      :format(altered,#designs,#missing))
  for _,name in ipairs(missing) do log("FluxWorks Reborn skipped "..name) end
  return altered,missing
end
M.designs=designs
return M
