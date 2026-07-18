-- Structural progression audit for the final, fully-integrated prototype graph.
-- Keep this generic: specific balance promises belong in validate-progression-ladders.lua.

local ITEM_TYPES = {
  "item", "tool", "ammo", "capsule", "module", "armor", "gun",
  "item-with-inventory", "item-with-tags", "item-with-label", "item-with-entity-data",
  "selection-tool", "blueprint", "blueprint-book", "copy-paste-tool",
  "deconstruction-item", "upgrade-item", "rail-planner", "spidertron-remote",
  "space-platform-starter-pack",
}

local function entry_name(entry)
  return type(entry) == "table" and (entry.name or entry[1]) or nil
end

local function item_prototype(name)
  for _, prototype_type in ipairs(ITEM_TYPES) do
    if data.raw[prototype_type] and data.raw[prototype_type][name] then
      return data.raw[prototype_type][name]
    end
  end
  return nil
end

local function item_exists(name)
  return item_prototype(name) ~= nil
end

local function is_fluxworks(name)
  return type(name) == "string" and string.sub(name, 1, 3) == "fw-"
end

local function fail(message)
  error("FluxWorks progression graph failure: " .. message)
end

local unlockers = {}
for technology_name, technology in pairs(data.raw.technology or {}) do
  for _, prerequisite in pairs(technology.prerequisites or {}) do
    if not data.raw.technology[prerequisite] then
      fail(technology_name .. " references missing prerequisite " .. prerequisite)
    end
  end

  for _, ingredient in pairs((technology.unit and technology.unit.ingredients) or {}) do
    local science_name = entry_name(ingredient)
    if science_name and not item_exists(science_name) then
      fail(technology_name .. " requires missing science item " .. science_name)
    end
  end

  for _, effect in pairs(technology.effects or {}) do
    if effect.type == "unlock-recipe" then
      if not (data.raw.recipe and data.raw.recipe[effect.recipe]) then
        fail(technology_name .. " unlocks missing recipe " .. tostring(effect.recipe))
      end
      unlockers[effect.recipe] = unlockers[effect.recipe] or {}
      unlockers[effect.recipe][#unlockers[effect.recipe] + 1] = technology_name
    end
  end
end

-- Technology cycles make a branch permanently unreachable even though every individual
-- prerequisite exists. Check all technologies because FluxWorks deliberately rewires base techs.
local visiting = {}
local visited = {}
local stack = {}

local function visit_technology(name)
  if visited[name] then
    return
  end
  if visiting[name] then
    local cycle = {}
    local in_cycle = false
    for _, stack_name in ipairs(stack) do
      if stack_name == name then
        in_cycle = true
      end
      if in_cycle then
        cycle[#cycle + 1] = stack_name
      end
    end
    cycle[#cycle + 1] = name
    fail("technology prerequisite cycle: " .. table.concat(cycle, " -> "))
  end

  visiting[name] = true
  stack[#stack + 1] = name
  for _, prerequisite in pairs(data.raw.technology[name].prerequisites or {}) do
    visit_technology(prerequisite)
  end
  stack[#stack] = nil
  visiting[name] = nil
  visited[name] = true
end

for technology_name in pairs(data.raw.technology or {}) do
  visit_technology(technology_name)
end

local category_machines = { crafting = true }
local machine_types = { "assembling-machine", "furnace", "rocket-silo" }
for _, prototype_type in ipairs(machine_types) do
  for _, machine in pairs(data.raw[prototype_type] or {}) do
    for _, category in pairs(machine.crafting_categories or {}) do
      category_machines[category] = true
    end
  end
end

local produced_items = {}
local produced_fluids = {}
local producers = {}
for recipe_name, recipe in pairs(data.raw.recipe or {}) do
  for _, result in pairs(recipe.results or {}) do
    local name = entry_name(result)
    local result_type = result.type or "item"
    if name then
      producers[name] = producers[name] or {}
      producers[name][#producers[name] + 1] = recipe_name
      if result_type == "fluid" then
        produced_fluids[name] = true
      else
        produced_items[name] = true
      end
    end
  end

  if is_fluxworks(recipe_name) and not recipe.hidden then
    local category = recipe.category or "crafting"
    if not category_machines[category] then
      fail(recipe_name .. " uses category " .. category .. " but no machine can craft it")
    end
    if recipe.enabled == false and not unlockers[recipe_name] then
      fail(recipe_name .. " is disabled but no technology unlocks it")
    end
  end
end

local mined_items = {}
local mined_fluids = {}
for _, resource in pairs(data.raw.resource or {}) do
  local minable = resource.minable or {}
  if minable.result then
    mined_items[minable.result] = true
  end
  for _, result in pairs(minable.results or {}) do
    local name = entry_name(result)
    if name then
      if result.type == "fluid" then
        mined_fluids[name] = true
      else
        mined_items[name] = true
      end
    end
  end
end

local ancestor_cache = {}
local function technology_reaches(technology_name, possible_ancestor)
  if technology_name == possible_ancestor then
    return true
  end
  ancestor_cache[technology_name] = ancestor_cache[technology_name] or {}
  local cached = ancestor_cache[technology_name][possible_ancestor]
  if cached ~= nil then
    return cached
  end

  ancestor_cache[technology_name][possible_ancestor] = false
  local technology = data.raw.technology[technology_name]
  for _, prerequisite in pairs((technology and technology.prerequisites) or {}) do
    if technology_reaches(prerequisite, possible_ancestor) then
      ancestor_cache[technology_name][possible_ancestor] = true
      return true
    end
  end
  return false
end

local function producer_available_by(producer_recipe_name, consumer_technology_name)
  local producer_recipe = data.raw.recipe[producer_recipe_name]
  if producer_recipe.enabled ~= false then
    return true
  end
  for _, producer_technology_name in ipairs(unlockers[producer_recipe_name] or {}) do
    if technology_reaches(consumer_technology_name, producer_technology_name) then
      return true
    end
  end
  return false
end

-- Check temporal obtainability, not just existence. A recipe can be structurally valid and still
-- be impossible when every producer for one of its FluxWorks ingredients unlocks later.
for recipe_name, recipe in pairs(data.raw.recipe or {}) do
  if is_fluxworks(recipe_name) and recipe.enabled == false and unlockers[recipe_name] then
    for _, ingredient in pairs(recipe.ingredients or {}) do
      local name = entry_name(ingredient)
      local ingredient_type = ingredient.type or "item"
      local owned_item = ingredient_type ~= "fluid" and item_prototype(name) or nil
      local naturally_available = ingredient_type == "fluid" and mined_fluids[name] or mined_items[name]
      if is_fluxworks(name) and not naturally_available and not (owned_item and owned_item.hidden) then
        local available = false
        for _, consumer_technology_name in ipairs(unlockers[recipe_name]) do
          for _, producer_recipe_name in ipairs(producers[name] or {}) do
            if producer_available_by(producer_recipe_name, consumer_technology_name) then
              available = true
              break
            end
          end
          if available then
            break
          end
        end
        if not available then
          fail(recipe_name .. " unlocks before its ingredient " .. name .. " is obtainable")
        end
      end
    end
  end
end

-- Every FluxWorks-owned ingredient must have a real source in the final graph. Base/modded
-- ingredients are intentionally left to their owning mods and the targeted compat validators.
for recipe_name, recipe in pairs(data.raw.recipe or {}) do
  if is_fluxworks(recipe_name) then
    for _, ingredient in pairs(recipe.ingredients or {}) do
      local name = entry_name(ingredient)
      local ingredient_type = ingredient.type or "item"
      if is_fluxworks(name) then
        local owned_item = ingredient_type ~= "fluid" and item_prototype(name) or nil
        local exists = ingredient_type == "fluid"
          and data.raw.fluid and data.raw.fluid[name]
          or item_exists(name)
        local produced = ingredient_type == "fluid"
          and (produced_fluids[name] or mined_fluids[name])
          or (produced_items[name] or mined_items[name])
        if not exists then
          fail(recipe_name .. " uses missing " .. ingredient_type .. " " .. name)
        end
        if not produced and not (owned_item and owned_item.hidden) then
          fail(recipe_name .. " uses unobtainable " .. ingredient_type .. " " .. name)
        end
      end
    end
  end
end

-- Lane contracts make the spectrum legible and prevent future source recipes drifting into
-- the wrong fluid family during broad integration passes.
local lane_fluids = {
  purple = "fw-purple-flux",
  yellow = "fw-yellow-flux",
  red = "fw-red-flux",
  green = "fw-green-flux",
}

for recipe_name, recipe in pairs(data.raw.recipe or {}) do
  for lane, expected_fluid in pairs(lane_fluids) do
    local prefix = "fw-" .. lane .. "-flux-from-"
    if string.sub(recipe_name, 1, #prefix) == prefix then
      local found = false
      for _, result in pairs(recipe.results or {}) do
        if entry_name(result) == expected_fluid and result.type == "fluid" then
          found = true
        end
      end
      if not found then
        fail(recipe_name .. " violates the " .. lane .. " source-lane contract")
      end
    end
  end
end
