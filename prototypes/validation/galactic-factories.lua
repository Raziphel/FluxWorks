-- Guard the final optional industrial graph without touching source planets.
local prefixes={"fw-planet-","fw-k2-galaxy-","fw-freight-"}
local function owned(name)
  for _,prefix in ipairs(prefixes) do
    if name:sub(1,#prefix)==prefix then return true end
  end
end
local function item(name)
  for _,kind in ipairs({"item","tool","capsule","ammo","module"}) do
    if data.raw[kind] and data.raw[kind][name] then return true end
  end
end
local recipes=data.raw.recipe or {}
local techs=data.raw.technology or {}
for name,recipe in pairs(recipes) do
  if owned(name) and name:sub(-8)=="-process" then
    local tech_name=name:sub(1,-9).."-engineering"
    local tech=techs[tech_name]
    assert(tech and tech.unit, "FluxWorks planet factory has no research owner "..name)
    local unlocked=false
    for _,effect in ipairs(tech.effects or {}) do
      if effect.type=="unlock-recipe" and effect.recipe==name then unlocked=true end
    end
    assert(unlocked,"FluxWorks galaxy recipe has no tech unlock "..name)
    assert(recipe.enabled==false and recipe.allow_productivity==false
      and recipe.auto_recycle==false, "Galaxy recipes must be optional and non-duplicating: "..name)
    assert(#(recipe.ingredients or {})<=6,"Galaxy recipe has excessive inputs "..name)
    local fluids,has_flux=0,false
    for _,ing in ipairs(recipe.ingredients or {}) do
      assert(ing.amount and ing.amount>0,"Bad planet input amount in "..name)
      if ing.type=="fluid" then
        fluids=fluids+1
        assert(data.raw.fluid and data.raw.fluid[ing.name],"Unknown planet fluid "..tostring(ing.name))
        if ing.name:match("^fw%-%a+%-flux$") then has_flux=true end
      else
        assert(item(ing.name),"Unknown planet material "..tostring(ing.name))
      end
    end
    assert(fluids<=2 and has_flux,"Invalid Flux plumbing in "..name)
    local output=recipe.main_product
    assert(item(output),"Planet recipe has invalid output "..name)
    local yields=false
    for _,entry in ipairs(recipe.results or {}) do
      if entry.name==output and entry.amount>0 then yields=true end
    end
    assert(yields,"Missing main product yield "..name)
  end
end
