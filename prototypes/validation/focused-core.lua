-- The new core replaces the legacy "all ores and every research" contracts.
-- Run after normalization, in *both* Razi and standalone configurations.
local Focused=require("prototypes.focused.prune")
local mode=(settings.startup or {})["fw-design-profile"]
assert(not mode or mode.value~="legacy","Focused validator invoked in legacy profile")
local raw=data.raw
local designs=Focused.recipes
local actives={}
for _,spec in ipairs(designs) do
  assert(not actives[spec.id],"Duplicate focused recipe: "..spec.id)
  actives[spec.id]=true
  local recipe=assert((raw.recipe or {})[spec.id],
    "Focused FluxWorks core has no recipe "..spec.id)
  assert(not recipe.hidden and recipe.enabled==false,
    "Focused recipe is neither playable nor researched: "..spec.id)
  assert(#(recipe.ingredients or {})<=5,"Core recipe requires excess inputs "..spec.id)
  local fluids=0
  for _,ing in ipairs(recipe.ingredients or {}) do
    assert(ing.amount>0,"Invalid ingredient quantity in "..spec.id)
    if ing.type=="fluid" then
      fluids=fluids+1
      assert((raw.fluid or {})[ing.name],"Unknown Flux fluid in "..spec.id)
    else
      local exists=false
      for _,kind in ipairs({"item","tool","module","ammo","capsule"}) do
        if (raw[kind] or {})[ing.name] then exists=true end
      end
      assert(exists,"Missing real ingredient "..ing.name.." in "..spec.id)
    end
  end
  assert(fluids<=2,"Physical machine cannot handle "..spec.id)
  local tech=assert((raw.technology or {})[spec.tech],
    "Focused manufacturing technology absent: "..spec.tech)
  assert(not tech.hidden,"Core technology was retired: "..spec.tech)
  local has_unlock=false
  for _,effect in ipairs(tech.effects or {}) do
    if effect.type=="unlock-recipe" and effect.recipe==spec.id then
      has_unlock=true
    end
  end
  assert(has_unlock,"Focused recipe cannot be researched: "..spec.id)
end
assert(#designs==26,"Focused production catalogue unexpectedly expanded")
local retired=0
for name,proto in pairs(raw.resource or {}) do
  if name:sub(1,3)=="fw-" then
    assert(not proto.autoplace,
      "Focused mode generated a retired FluxWorks ore deposit: "..name)
    local control=(raw["autoplace-control"] or {})[name]
    assert(not control or control.hidden,
      "Focused mode still shows a retired ore slider: "..name)
    retired=retired+1
  end
end
assert(retired>=5,"Old ore and rift prototypes unexpectedly missing; migration review needed")
for _,name in ipairs({"fw-crushed-lead-ore","fw-crushed-tin-ore",
  "fw-crushed-bauxite-ore","fw-crushed-titanium-ore",
  "lead-ore","tin-ore","titanium-ore","aluminum-plate","bronze-plate",
  "fw-industrial-district-project"}) do
  local old=(raw.item or {})[name] or (raw.technology or {})[name]
  if old then assert(old.hidden,"Legacy production should not be visible: "..name) end
end
for name,recipe in pairs(raw.recipe or {}) do
  if name:sub(1,3)=="fw-" and not actives[name] and not recipe.hidden then
    assert(name:match("^fw%-charter%-")
      or name:match("^fw%-foundry%-") and mods and mods["razi-protocol"],
      "Uncurated FluxWorks crafting recipe escaped focused mode: "..name)
  end
end
local techs=raw.technology or {}
for _,name in ipairs({"fw-flux-stabilization","fw-flux-chemical-synthesis",
  "fw-flux-metallurgy","fw-flux-green-cultivation","fw-flux-resonance",
  "fw-flux-convergence","fw-origin-infrastructure"}) do
  local tech=techs[name]
  assert(tech and not tech.hidden and tech.unit,
    "Essential FluxWorks engineering research disappeared: "..name)
  for _,pack in ipairs(tech.unit.ingredients or {}) do
    local n=pack.name or pack[1]
    assert(n:sub(1,3)~="fw-",
      "Core engineering may not demand legacy FluxWorks science: "..name)
  end
end
local charter=techs["fw-four-works-charter"]
if charter then
  for _,parent in ipairs(charter.prerequisites or {}) do
    assert(techs[parent] and not techs[parent].hidden,
      "Four Works Charter relies on retired technology: "..parent)
  end
end
log("FluxWorks focused-mode: 26 curated recipes, seven engineering tiers, zero new resource veins")
return true
