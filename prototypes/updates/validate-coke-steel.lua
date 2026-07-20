local function contains(entries, name)
  for _, entry in ipairs(entries or {}) do
    local entry_name = type(entry) == "table" and (entry.name or entry.recipe or entry[1]) or entry
    if entry_name == name then
      return true
    end
  end
  return false
end

local coke = data.raw.item and data.raw.item["fw-coke"]
local coke_recipe = data.raw.recipe and data.raw.recipe["fw-coke"]
local purification = data.raw.recipe and data.raw.recipe["fw-coke-purification"]
local steel = data.raw.recipe and data.raw.recipe["steel-plate"]
if not (coke and coke_recipe and purification and steel) then
  error("FluxWorks coke and steel production chain is incomplete")
end

if coke.icons or coke.icon ~= "__Krastorio2Assets__/icons/items/coke.png" then
  error("FluxWorks coke must use its clean single-image coke icon")
end
if not contains(coke_recipe.ingredients, "coal") or not contains(coke_recipe.results, "fw-coke") then
  error("FluxWorks coke carbonization recipe drifted")
end
if not contains(steel.ingredients, "iron-plate") or not contains(steel.ingredients, "fw-coke") then
  error("FluxWorks steel must be batch-smelted from iron plate and metallurgical coke")
end
if not contains(purification.ingredients, "fw-coke") or not contains(purification.results, "fw-carbon") then
  error("FluxWorks coke needs a post-steel refined-carbon use")
end
if not contains(data.raw.technology["steel-processing"].effects, "fw-coke") then
  error("Steel processing must unlock coke carbonization")
end
