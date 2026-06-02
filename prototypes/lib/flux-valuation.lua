local FluxValues = require("prototypes.recipes.flux-values")

local M = {}

M.ITEM_TYPES = {
  "item",
  "ammo",
  "capsule",
  "gun",
  "module",
  "armor",
  "item-with-entity-data",
  "repair-tool",
  "tool",
}

M.EXCLUDED_ITEMS = {
  ["fw-flux-condenser"] = true,
  ["fw-purple-flux-barrel"] = true,
  ["blueprint"] = true,
  ["blueprint-book"] = true,
  ["copy-paste-tool"] = true,
  ["cut-paste-tool"] = true,
  ["deconstruction-planner"] = true,
  ["upgrade-planner"] = true,
  ["selection-tool"] = true,
  ["spidertron-remote"] = true,
}

M.VALUE_OVERRIDES = FluxValues.item_values or {}
M.FLUID_VALUE_OVERRIDES = FluxValues.fluid_values or {}
M.RECIPE_CATEGORY_VALUE_MULTIPLIERS = FluxValues.recipe_category_multipliers or {}
M.RECIPE_CATEGORY_TIME_MULTIPLIERS = FluxValues.recipe_category_time_multipliers or {}
M.DEFAULT_TIME_VALUE = FluxValues.default_time_value or 4

local function is_hidden(item)
  if item.hidden then
    return true
  end
  for _, flag in pairs(item.flags or {}) do
    if flag == "hidden" then
      return true
    end
  end
  return false
end

function M.is_valued_item(item)
  if not item or not item.name then
    return false
  end
  if M.EXCLUDED_ITEMS[item.name] then
    return false
  end
  if item.parameter then
    return false
  end
  if item.subgroup == "parameters" then
    return false
  end
  if string.find(item.name, "-remote$", 1, false) then
    return false
  end
  if is_hidden(item) then
    return false
  end
  if not item.stack_size or item.stack_size < 1 then
    return false
  end
  return true
end

function M.is_convertible(item)
  if not M.is_valued_item(item) then
    return false
  end
  if item.type == "item-with-entity-data" then
    return false
  end
  return item.stack_size >= 2
end

function M.estimate_flux_value(item)
  if M.VALUE_OVERRIDES[item.name] then
    return M.VALUE_OVERRIDES[item.name]
  end

  local value = math.max(1, math.floor(120 / math.max(1, item.stack_size)))

  if item.subgroup == "raw-resource" then
    value = value + 3
  end

  if item.place_result then
    value = value + 8
  end

  if item.place_as_tile then
    value = value + 2
  end

  if item.fuel_value then
    value = value + 4
  end

  if item.type == "item-with-entity-data" then
    value = value + 6
  end

  return math.min(2000, math.max(1, value))
end

local function get_entries(recipe, field)
  if recipe[field] then
    return recipe[field]
  end
  if recipe.normal and recipe.normal[field] then
    return recipe.normal[field]
  end
  return nil
end

local function entry_amount(entry)
  if entry.amount then
    return entry.amount
  end
  if entry.amount_min and entry.amount_max then
    return (entry.amount_min + entry.amount_max) / 2
  end
  if entry[2] then
    return entry[2]
  end
  return 1
end

local function entry_type(entry)
  if entry.type then
    return entry.type
  end
  return "item"
end

local function entry_name(entry)
  if entry.name then
    return entry.name
  end
  return entry[1]
end

local function result_amount_for(recipe, item_name)
  local total = 0
  local results = get_entries(recipe, "results")
  if results then
    for _, result in pairs(results) do
      if entry_type(result) == "item" and entry_name(result) == item_name then
        local probability = result.probability or 1
        total = total + (entry_amount(result) * probability)
      end
    end
    return total
  end

  local single = recipe.result or (recipe.normal and recipe.normal.result)
  if single == item_name then
    local count = recipe.result_count or (recipe.normal and recipe.normal.result_count) or 1
    return count
  end
  return 0
end

local function ingredient_flux_cost(recipe, known_values)
  local ingredients = get_entries(recipe, "ingredients")
  if not ingredients then
    return nil
  end

  local total = 0
  for _, ingredient in pairs(ingredients) do
    local kind = entry_type(ingredient)
    local name = entry_name(ingredient)
    local amount = entry_amount(ingredient)
    if kind == "item" then
      local item_value = known_values[name]
      if not item_value then
        return nil
      end
      total = total + (item_value * amount)
    elseif kind == "fluid" then
      local fluid_value = M.FLUID_VALUE_OVERRIDES[name]
      if not fluid_value then
        return nil
      end
      total = total + (fluid_value * amount)
    end
  end
  local category = recipe.category or (recipe.normal and recipe.normal.category) or "crafting"
  local mult = M.RECIPE_CATEGORY_VALUE_MULTIPLIERS[category] or 1
  local time_mult = M.RECIPE_CATEGORY_TIME_MULTIPLIERS[category] or 1
  local energy = recipe.energy_required or (recipe.normal and recipe.normal.energy_required) or 0.5
  return (total * mult) + (energy * M.DEFAULT_TIME_VALUE * time_mult)
end

local function collect_items(predicate)
  local items = {}
  local seen = {}
  for _, item_type in pairs(M.ITEM_TYPES) do
    for _, item in pairs(data.raw[item_type] or {}) do
      if predicate(item) and not seen[item.name] then
        seen[item.name] = true
        items[item.name] = item
      end
    end
  end
  return items
end

function M.collect_valued_items()
  return collect_items(M.is_valued_item)
end

function M.collect_convertible_items()
  return collect_items(M.is_convertible)
end

function M.resolve_item_values(candidate_items)
  local values = {}
  for name, value in pairs(M.VALUE_OVERRIDES) do
    values[name] = value
  end

  local recipes_by_result = {}
  for recipe_name, recipe in pairs(data.raw.recipe or {}) do
    if not recipe.hidden and recipe_name ~= "fw-flux-condenser" and string.sub(recipe_name, 1, 12) ~= "fw-exchange-" and recipe.category ~= "recycling" then
      local results = get_entries(recipe, "results")
      if results then
        local seen_result_names = {}
        for _, result in pairs(results) do
          if entry_type(result) == "item" then
            local name = entry_name(result)
            if name and candidate_items[name] and not seen_result_names[name] then
              seen_result_names[name] = true
              recipes_by_result[name] = recipes_by_result[name] or {}
              table.insert(recipes_by_result[name], recipe)
            end
          end
        end
      else
        local single = recipe.result or (recipe.normal and recipe.normal.result)
        if single and candidate_items[single] then
          recipes_by_result[single] = recipes_by_result[single] or {}
          table.insert(recipes_by_result[single], recipe)
        end
      end
    end
  end

  local changed = true
  local pass = 0
  while changed and pass < 30 do
    changed = false
    pass = pass + 1
    for item_name, _ in pairs(candidate_items) do
      if not values[item_name] then
        local candidates = recipes_by_result[item_name] or {}
        local best = nil
        for _, recipe in pairs(candidates) do
          local ing_cost = ingredient_flux_cost(recipe, values)
          if ing_cost then
            local out_amount = result_amount_for(recipe, item_name)
            if out_amount and out_amount > 0 then
              local derived = math.max(1, math.floor((ing_cost / out_amount) + 0.5))
              if not best or derived < best then
                best = derived
              end
            end
          end
        end
        if best then
          values[item_name] = best
          changed = true
        end
      end
    end
  end

  for item_name, item in pairs(candidate_items) do
    if item.subgroup ~= "raw-resource" then
      local candidates = recipes_by_result[item_name] or {}
      local best = nil
      for _, recipe in pairs(candidates) do
        local ing_cost = ingredient_flux_cost(recipe, values)
        if ing_cost then
          local out_amount = result_amount_for(recipe, item_name)
          if out_amount and out_amount > 0 then
            local derived = math.max(1, math.floor((ing_cost / out_amount) + 0.5))
            if not best or derived < best then
              best = derived
            end
          end
        end
      end
      if best and (not values[item_name] or best > values[item_name]) then
        values[item_name] = best
      end
    end
  end

  return values
end

return M
