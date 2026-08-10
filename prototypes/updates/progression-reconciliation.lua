-- Run this last. Earlier compatibility passes can move either side of an unlock.
local MAX_RECONCILIATION_PASSES = 12

local function entry_name(entry)
  return type(entry) == "table" and (entry.name or entry[1]) or nil
end

local function is_fluxworks(name)
  return type(name) == "string" and string.sub(name, 1, 3) == "fw-"
end

local function has_unlock(technology, recipe_name)
  for _, effect in pairs((technology and technology.effects) or {}) do
    if effect.type == "unlock-recipe" and effect.recipe == recipe_name then return true end
  end
  return false
end

local function add_unlock(technology, recipe_name)
  technology.effects = technology.effects or {}
  if not has_unlock(technology, recipe_name) then
    technology.effects[#technology.effects + 1] = { type = "unlock-recipe", recipe = recipe_name }
  end
end

local function set_ingredients(recipe_name, ingredients)
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if not recipe then return end
  recipe.ingredients = ingredients
  if recipe.normal then recipe.normal.ingredients = table.deepcopy(ingredients) end
  if recipe.expensive then recipe.expensive.ingredients = table.deepcopy(ingredients) end
end

local function canonical_producer(item_name)
  local recipe = data.raw.recipe and data.raw.recipe[item_name]
  if not recipe then return nil end
  for _, result in pairs(recipe.results or {}) do
    if entry_name(result) == item_name then return recipe end
  end
  return nil
end

local function has_enabled_producer(item_name)
  for _, recipe in pairs(data.raw.recipe or {}) do
    if recipe.enabled ~= false and not recipe.hidden then
      for _, result in pairs(recipe.results or {}) do
        if entry_name(result) == item_name then return true end
      end
    end
  end
  return false
end

local function is_progression_recipe(recipe_name, recipe)
  if is_fluxworks(recipe_name) then return true end
  for _, ingredient in pairs(recipe.ingredients or {}) do
    if is_fluxworks(entry_name(ingredient)) then return true end
  end
  return false
end

-- Bearings arrive with the first electric drill, not after it.
set_ingredients("fw-bearing", {
  { type = "item", name = "iron-plate", amount = 3 },
  { type = "item", name = "iron-gear-wheel", amount = 1 },
})
set_ingredients("electric-mining-drill", {
  { type = "item", name = "burner-mining-drill", amount = 1 },
  { type = "item", name = "electronic-circuit", amount = 3 },
  { type = "item", name = "fw-bearing", amount = 2 },
})

local drill_technology = data.raw.technology and data.raw.technology["electric-mining-drill"]
if drill_technology then
  add_unlock(drill_technology, "fw-bearing")
end

-- Enabled recipes cannot depend on a part that still needs research.
for _, recipe in pairs(data.raw.recipe or {}) do
  if recipe.enabled ~= false and not recipe.hidden then
    local function strip_locked_fluxworks(ingredients)
      if not ingredients then return end
      for index = #ingredients, 1, -1 do
        local name = entry_name(ingredients[index])
        local producer = is_fluxworks(name) and data.raw.recipe[name] or nil
        if producer and producer.enabled == false and not has_enabled_producer(name) then
          table.remove(ingredients, index)
        end
      end
    end
    strip_locked_fluxworks(recipe.ingredients)
    strip_locked_fluxworks(recipe.normal and recipe.normal.ingredients)
    strip_locked_fluxworks(recipe.expensive and recipe.expensive.ingredients)
  end
end

local function build_unlockers()
  local result = {}
  for technology_name, technology in pairs(data.raw.technology or {}) do
    for _, effect in pairs(technology.effects or {}) do
      if effect.type == "unlock-recipe" and data.raw.recipe[effect.recipe] then
        result[effect.recipe] = result[effect.recipe] or {}
        result[effect.recipe][#result[effect.recipe] + 1] = technology_name
      end
    end
  end
  for _, names in pairs(result) do table.sort(names) end
  return result
end

local reach_cache = {}
local function technology_reaches(technology_name, possible_ancestor, visiting)
  if technology_name == possible_ancestor then return true end
  reach_cache[technology_name] = reach_cache[technology_name] or {}
  if reach_cache[technology_name][possible_ancestor] ~= nil then
    return reach_cache[technology_name][possible_ancestor]
  end
  visiting = visiting or {}
  if visiting[technology_name] then return false end
  visiting[technology_name] = true
  local technology = data.raw.technology[technology_name]
  for _, prerequisite in pairs((technology and technology.prerequisites) or {}) do
    if technology_reaches(prerequisite, possible_ancestor, visiting) then
      visiting[technology_name] = nil
      reach_cache[technology_name][possible_ancestor] = true
      return true
    end
  end
  visiting[technology_name] = nil
  reach_cache[technology_name][possible_ancestor] = false
  return false
end

local function add_prerequisite(technology, prerequisite_name)
  technology.prerequisites = technology.prerequisites or {}
  for _, existing in pairs(technology.prerequisites) do
    if existing == prerequisite_name then return false end
  end
  technology.prerequisites[#technology.prerequisites + 1] = prerequisite_name
  reach_cache = {}
  return true
end

-- One repaired unlock can make another recipe valid, so settle the graph in passes.
for _ = 1, MAX_RECONCILIATION_PASSES do
  local changed = false
  local unlockers = build_unlockers()
  reach_cache = {}

  for consumer_recipe_name, consumer_recipe in pairs(data.raw.recipe or {}) do
    if consumer_recipe.enabled == false
      and not consumer_recipe.hidden
      and is_progression_recipe(consumer_recipe_name, consumer_recipe)
    then
      for _, consumer_technology_name in ipairs(unlockers[consumer_recipe_name] or {}) do
        local consumer_technology = data.raw.technology[consumer_technology_name]
        for _, ingredient in pairs(consumer_recipe.ingredients or {}) do
          local ingredient_name = entry_name(ingredient)
          local producer_recipe = canonical_producer(ingredient_name)

          if producer_recipe and producer_recipe.enabled == false then
            local available = false
            local producer_unlockers = unlockers[ingredient_name] or {}
            for _, producer_technology_name in ipairs(producer_unlockers) do
              if technology_reaches(consumer_technology_name, producer_technology_name) then
                available = true
                break
              end
            end

            if not available then
              local safe_prerequisite = nil
              for _, producer_technology_name in ipairs(producer_unlockers) do
                if not technology_reaches(producer_technology_name, consumer_technology_name) then
                  safe_prerequisite = producer_technology_name
                  break
                end
              end

              if safe_prerequisite then
                changed = add_prerequisite(consumer_technology, safe_prerequisite) or changed
              else
                add_unlock(consumer_technology, ingredient_name)
                changed = true
              end
            end
          end
        end
      end
    end
  end

  if not changed then break end
end
