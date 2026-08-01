-- Exact API registrations are promises to another mod. Reapply them after
-- broad compatibility passes, which may replace an entire ingredient list.
local Recipe = require("__razi_lib__/lib/recipe")
local Compatibility = require("prototypes.lib.compatibility-api")

local ITEM_TYPES = {
  "item", "ammo", "capsule", "gun", "module", "armor", "tool",
  "repair-tool", "item-with-entity-data", "item-with-label", "item-with-tags",
  "rail-planner",
}

local function item_exists(item_name)
  for _, item_type in ipairs(ITEM_TYPES) do
    if data.raw[item_type] and data.raw[item_type][item_name] then return true end
  end
  return false
end

local function entry_name(entry)
  return entry.name or entry[1]
end

local applied = 0
for recipe_name, registration in pairs(Compatibility.recipe_parts) do
  local raw_recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if raw_recipe
    and not raw_recipe.hidden
    and not Compatibility.recipe_exclusions[recipe_name]
    and item_exists(registration.part)
  then
    local recipe = Recipe:get(recipe_name)
    local ingredients = recipe and recipe.ingredients
    if ingredients then
      local found
      for _, ingredient in pairs(ingredients) do
        if entry_name(ingredient) == registration.part then
          ingredient.amount = math.max(ingredient.amount or ingredient[2] or 0, registration.amount)
          ingredient[2] = nil
          found = true
          break
        end
      end
      if not found then
        ingredients[#ingredients + 1] = {
          type = "item",
          name = registration.part,
          amount = registration.amount,
        }
      end
      recipe:setIngredients(ingredients)
      applied = applied + 1
    end
  end
end

if applied > 0 then
  log(("FluxWorks compatibility API: finalized %d explicit recipe registrations"):format(applied))
end

return applied
