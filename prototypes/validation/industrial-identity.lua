-- Validate the independence boundary and the optional Razi industrial layer.
-- Registry modules were already executed before this final data-stage pass.
local standalone=require("prototypes.identity.four-works-charter")
local razi=require("prototypes.identity.seven-foundries")
local techs=data.raw.technology or {}
local recipes=data.raw.recipe or {}
local items=data.raw.item or {}
local function unlock(technology,recipe)
  local found=0
  for _,effect in ipairs((technology and technology.effects) or {}) do
    if effect.type=="unlock-recipe" and effect.recipe==recipe then found=found+1 end
  end
  return found==1
end
local function inputs(name,limit)
  local recipe=assert(recipes[name],"Missing FluxWorks identity recipe "..name)
  local fluid_count=0
  assert(recipe.enabled==false and not recipe.allow_productivity,
    "FluxWorks identity recipe bypasses research/productivity "..name)
  local ingredients=recipe.ingredients or {}
  assert(#ingredients>0 and #ingredients<=limit,
    "Factory charter would exceed physical ingredient slots: "..name)
  for _,entry in ipairs(ingredients) do
    assert(entry.amount and entry.amount>0, "Invalid identity feedstock "..name)
    if entry.type=="fluid" then
      fluid_count=fluid_count+1
      assert((data.raw.fluid or {})[entry.name],"Unknown Flux source "..entry.name)
    else
      assert((items[entry.name] or (data.raw.tool or {})[entry.name]),
        "Unknown industrial material "..entry.name)
    end
  end
  assert(fluid_count<=2, "Too many Flux pipes on "..name)
end
local charter=techs["fw-four-works-charter"]
if charter then
  assert(charter.icons and charter.icons[1].icon:find("fw-four-works-charter.png",1,true),
    "Standalone industrial Charter lost its unique emblem")
  for _,spec in ipairs(standalone.spec.processes) do
    local name="fw-charter-"..spec.id
    inputs(name,6)
    assert(unlock(charter,name),"Charter did not unlock its craftable reward "..name)
  end
end
local hosted=mods and mods["razi-protocol"]~=nil
if not hosted then
  assert(razi.count==nil and #razi.registrations==0,
    "Seven Foundries must be inert without Razi Protocol")
  assert(not techs["fw-foundry-atlas"],"Razi Atlas appeared in standalone FluxWorks")
end
local seen={}
for _,record in ipairs(razi.registrations or {}) do
  assert(hosted,"Seven Foundries operation registered without Razi")
  assert(not seen[record.spec.system],"Duplicate Razi industrial field system")
  seen[record.spec.system]=true
  assert(items[record.record],"No physical industrial calibration record "..record.record)
  inputs(record.recipe,3)
  assert(unlock(techs[record.technology],record.recipe),
    "Razi field report tech has no corresponding operation")
end
if razi.atlas then
  assert(#razi.registrations>=4,"The Atlas requires four real source worlds")
  local atlas=assert(techs["fw-foundry-atlas"])
  assert(atlas.icon and atlas.icon:find("fw-seven-foundries-atlas.png",1,true),
    "Atlas uses the wrong identity emblem")
  for _,folio in ipairs({"fw-foundry-folio-inner","fw-foundry-folio-outer"}) do
    assert(items[folio],"Atlas folio item was not registered "..folio)
    inputs(folio,4)
    assert(unlock(atlas,folio),"Atlas research cannot assemble folio "..folio)
  end
  inputs("fw-foundry-atlas-convergence",3)
  assert(unlock(atlas,"fw-foundry-atlas-convergence"),
    "Seven Foundries Atlas lacks its final industrial payoff")
end
log(("FluxWorks identity: charter=%s, Razi field records=%d, atlas=%s")
  :format(tostring(charter~=nil),#(razi.registrations or {}),tostring(razi.atlas or false)))
return true
