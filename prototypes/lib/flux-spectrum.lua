local M = {}

M.ITEM_TYPES = {
  "item",
  "tool",
  "ammo",
  "capsule",
  "module",
  "armor",
}

function M.item_exists(name)
  for _, item_type in ipairs(M.ITEM_TYPES) do
    if data.raw[item_type] and data.raw[item_type][name] then
      return true
    end
  end
  return false
end

function M.fluid_exists(name)
  return data.raw.fluid and data.raw.fluid[name] ~= nil
end

function M.category_exists(name)
  return data.raw["recipe-category"] and data.raw["recipe-category"][name] ~= nil
end

function M.bio_category()
  return M.category_exists("biochamber") and "biochamber" or "chemistry"
end

function M.add_unlock(unlocks, technology_name, recipe_name)
  unlocks[technology_name] = unlocks[technology_name] or {}
  table.insert(unlocks[technology_name], recipe_name)
end

function M.publish(recipes, unlocks)
  if recipes and #recipes > 0 then
    data:extend(recipes)
  end

  for technology_name, recipe_names in pairs(unlocks or {}) do
    local tech = data.raw.technology and data.raw.technology[technology_name]
    if tech and #recipe_names > 0 then
      tech.effects = tech.effects or {}
      local seen = {}
      for _, effect in pairs(tech.effects) do
        if effect.type == "unlock-recipe" then
          seen[effect.recipe] = true
        end
      end
      for _, recipe_name in ipairs(recipe_names) do
        if not seen[recipe_name] then
          table.insert(tech.effects, { type = "unlock-recipe", recipe = recipe_name })
        end
      end
    end
  end
end

return M
