-- Reborn replaces the old 200-line ingredient-toll assumptions with actual
-- manufacturing, transport and machine contracts. No source-mod prototypes.
local profile=(settings.startup or {})["fw-rp-factory-design"]
if profile and profile.value=="legacy" then return end
local source=require("prototypes.overhaul.rework-recipes")
local machines=require("prototypes.overhaul.machine-specialization")
local Graph=require("__razi_lib__/lib/technology_graph")
local techs=data.raw.technology or {}
local recipes=data.raw.recipe or {}
local items=data.raw.item or {}
local signatureNames={
  "fw-chemical-membrane","fw-thermal-core","fw-phase-wafer",
  "fw-living-fiber","fw-convergence-chassis",
}
local function unlocked(name)
  for _,tech in pairs(techs) do
    for _,effect in ipairs(tech.effects or {}) do
      if effect.type=="unlock-recipe" and effect.recipe==name then return true end
    end
  end
end
local function source_available(entry)
  if entry.type=="fluid" then
    return data.raw.fluid and data.raw.fluid[entry.name]
  end
  for _,kind in ipairs({"item","tool","ammo","capsule","module"}) do
    if data.raw[kind] and data.raw[kind][entry.name] then return true end
  end
end
local function recipe_integrity(name,recipe)
  assert(recipe and recipe.enabled==false,"Missing gated recipe "..name)
  local inputs=recipe.ingredients or (recipe.normal and recipe.normal.ingredients)
  assert(inputs and #inputs<=6,"Reborn recipe exceeds six physical ingredients: "..name)
  local fluids=0
  for _,ingredient in ipairs(inputs) do
    assert(ingredient.amount and ingredient.amount>0,
      "Bad physical ingredient quantity in "..name)
    assert(source_available(ingredient),"Missing true source for "..name..": "..ingredient.name)
    if ingredient.type=="fluid" then fluids=fluids+1 end
  end
  assert(fluids<=2,"Reborn recipe has more than two fluid inlets: "..name)
  assert(unlocked(name),"Reborn recipe has no research unlock: "..name)
end
for _,name in ipairs(signatureNames) do
  assert(items[name] and items[name].icon_size==128,"Missing new manufacturing item "..name)
  recipe_integrity(name,recipes[name])
end
local rewritten=0
for _,spec in ipairs(source.designs) do
  local recipe=recipes[spec.name]
  if recipe then
    local actual=recipe.ingredients or {}
    local expected_count=#spec.inputs
    local k2=source.k2_fidelity[spec.name]
    if k2 and mods and mods["Krastorio2-spaced-out"]
      and data.raw.item and data.raw.item[k2.name]
      and (not (settings.startup or {})["fw-enable-k2so-integration"]
        or settings.startup["fw-enable-k2so-integration"].value~=false) then
      expected_count=expected_count+1
    end
    local good=#actual==expected_count
    if good then
      for i,expected in ipairs(spec.inputs) do
        local item=actual[i]
        local alias=expected.name:sub(1,3)=="kr-" and expected.name
          or "kr-"..expected.name
        if not item or (item.name~=expected.name and item.name~=alias)
          or item.amount~=expected.amount or item.type~=expected.type then
          good=false
          break
        end
      end
    end
    if good and expected_count>#spec.inputs then
      local actual_k2=actual[#actual]
      good=actual_k2 and actual_k2.name==k2.name and actual_k2.amount==k2.amount
    end
    if good then
      assert(#actual<=6,"Reborn old recipe stayed too broad "..spec.name)
      local count=0
      for _,ingredient in ipairs(actual) do
        if ingredient.type=="fluid" then count=count+1 end
      end
      assert(count<=2,"Reborn machine cannot pipe enough fluids "..spec.name)
      rewritten=rewritten+1
    end
  end
end
assert(rewritten>=35,
  "FluxWorks Reborn overhaul did not register enough factory reconstruction: "
    ..rewritten.." of "..#source.designs)
local machineIndex=data.raw["assembling-machine"] or {}
local checked=0
for name,spec in pairs(machines.profiles) do
  local machine=machineIndex[name]
  if machine then
    assert(machine.crafting_speed==spec.speed,
      "Reborn machine doctrine mismatch: "..name)
    checked=checked+1
  end
end
assert(checked>=9,"Too few industrial machine archetypes were rebuilt")
local convergence=recipes["fw-convergence-synthesis-plant"]
assert(convergence,"Final Convergence machine recipe missing")
local chassis=0
for _,ingredient in ipairs(convergence.ingredients or {}) do
  if ingredient.name=="fw-convergence-chassis" then chassis=ingredient.amount end
end
assert(chassis==2,"Convergence machine bypasses four-spectrum manufacturing")
local forge=machineIndex["fw-origin-forge"]
assert(forge,"Convergence Forge has no actual assembling entity")
local category=false
for _,entry in ipairs(forge.crafting_categories or {}) do
  if entry=="fw-origin-forging" then category=true end
end
assert(category,"Late Forge cannot run its specialized recipes")
for _,id in ipairs({"refractory-recasting","photonic-logic",
  "living-seal-engineering","quantum-assembly"}) do
  local name="fw-reborn-forge-"..id
  if recipes[name] then recipe_integrity(name,recipes[name]) end
end
local cycle=Graph.find_cycle(techs)
if cycle then
  -- Don't hide cycles, but don't assume they came from this mod either.
  -- Only reject cycles actually containing a FluxWorks research identifier.
  for _,name in ipairs(cycle) do
    assert(name:sub(1,3)~="fw-",
      "FluxWorks Reborn technology prerequisite cycle: "..table.concat(cycle," -> "))
  end
end
log(("FluxWorks Reborn validator: %d original recipes and %d machine archetypes")
  :format(rewritten,checked))
return true
