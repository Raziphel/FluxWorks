local function item_entry_name(entry)
  if type(entry) ~= "table" then
    return nil
  end

  return entry.name or entry[1]
end

local function item_entry_type(entry)
  if type(entry) ~= "table" then
    return nil
  end

  return entry.type
end

local function is_item_ingredient(entry, expected_name)
  local entry_name = item_entry_name(entry)
  if not entry_name then
    return false
  end

  local entry_type = item_entry_type(entry)
  if entry_type ~= nil then
    return entry_type == "item" and entry_name == expected_name
  end

  return entry_name == expected_name
end

local function item_has_terminal_role(item)
  return item.place_result ~= nil
    or item.place_as_tile ~= nil
    or item.placed_as_equipment_result ~= nil
    or item.fuel_value ~= nil
    or item.burnt_result ~= nil
end

local function collect_recipe_uses(item_name)
  local uses = {}

  for recipe_name, recipe in pairs(data.raw.recipe or {}) do
    -- Recycling is a disposal path, not a reason for an intermediate to exist.
    if not string.match(recipe_name, "%-recycling$") then
      for _, ingredient in pairs(recipe.ingredients or {}) do
        if is_item_ingredient(ingredient, item_name) then
          uses[#uses + 1] = recipe_name
          break
        end
      end
    end
  end

  table.sort(uses)
  return uses
end

if data.raw.item["fw-copper-tube"] or data.raw.recipe["fw-copper-tube"] then
  error("Retired duplicate intermediate fw-copper-tube is still present")
end

local function collect_technology_uses(item_name)
  local uses = {}

  for technology_name, technology in pairs(data.raw.technology or {}) do
    local trigger = technology.research_trigger
    if trigger and trigger.type == "craft-item" and trigger.item == item_name then
      uses[#uses + 1] = technology_name
    end

    local ingredients = technology.unit and technology.unit.ingredients or {}
    for _, ingredient in pairs(ingredients) do
      if is_item_ingredient(ingredient, item_name) then
        if not (trigger and trigger.type == "craft-item" and trigger.item == item_name) then
          uses[#uses + 1] = technology_name
        end
        break
      end
    end
  end

  table.sort(uses)
  return uses
end

for item_name, item in pairs(data.raw.item or {}) do
  if string.sub(item_name, 1, 3) == "fw-" and not item_has_terminal_role(item) then
    local recipe_uses = collect_recipe_uses(item_name)
    local technology_uses = collect_technology_uses(item_name)

    if #recipe_uses == 0 and #technology_uses == 0 then
      error(("Unused FluxWorks item: %s in subgroup %s has no recipe consumers and no technology use"):format(
        item_name,
        item.subgroup or "<none>"
      ))
    end
  end
end
