local FluxValues = require("prototypes.recipes.flux-values")
local Compatibility = require("prototypes.lib.compatibility-api")

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
  "item-with-label",
  "item-with-tags",
  "rail-planner",
}

M.EXCLUDED_ITEMS = {
  ["fw-flux-condenser"] = true,
  ["blueprint"] = true,
  ["blueprint-book"] = true,
  ["copy-paste-tool"] = true,
  ["cut-paste-tool"] = true,
  ["deconstruction-planner"] = true,
  ["upgrade-planner"] = true,
  ["selection-tool"] = true,
  ["spidertron-remote"] = true,
}
for item_name, excluded in pairs(Compatibility.recovery_exclusions) do
  if excluded then M.EXCLUDED_ITEMS[item_name] = true end
end

M.NON_CONVERTIBLE_ITEM_PATTERNS = {
  "^fw%-.*flux",
  "%-barrel$",
  "%-fuel%-cell$",
}

M.VALUE_OVERRIDES = FluxValues.item_values or {}
M.VALUE_LOCKS = FluxValues.item_value_locks or {}
M.FLUID_VALUE_OVERRIDES = FluxValues.fluid_values or {}
M.ITEM_COLOR_OVERRIDES = FluxValues.item_color_overrides or {}
M.FLUID_COLOR_OVERRIDES = FluxValues.fluid_color_overrides or {}
for item_name, value in pairs(Compatibility.item_values) do
  M.VALUE_OVERRIDES[item_name] = value
end
for item_name, value in pairs(Compatibility.item_value_locks) do
  M.VALUE_LOCKS[item_name] = value
end
for fluid_name, value in pairs(Compatibility.fluid_values) do
  M.FLUID_VALUE_OVERRIDES[fluid_name] = value
end
for item_name, spectrum in pairs(Compatibility.item_spectra) do
  M.ITEM_COLOR_OVERRIDES[item_name] = spectrum
end
for fluid_name, spectrum in pairs(Compatibility.fluid_spectra) do
  M.FLUID_COLOR_OVERRIDES[fluid_name] = spectrum
end
M.RECIPE_CATEGORY_VALUE_MULTIPLIERS = FluxValues.recipe_category_multipliers or {}
M.RECIPE_CATEGORY_TIME_MULTIPLIERS = FluxValues.recipe_category_time_multipliers or {}
M.RECIPE_CATEGORY_COLOR_WEIGHTS = FluxValues.recipe_category_color_weights or {}
M.RECIPE_PROCESS_COLOR_SHARE = FluxValues.recipe_process_color_share or 0.18
M.DEFAULT_TIME_VALUE = FluxValues.default_time_value or 4
M.COLOR_ORDER = { "purple", "yellow", "red", "green" }
M.VALUE_CONFIDENCE = {
  locked = "locked",
  anchored = "anchored",
  derived = "derived",
  inferred = "inferred",
  unknown = "unknown",
}
M.EXTRACTION_EFFICIENCY = {
  locked = 0.72,
  anchored = 0.68,
  derived = 0.62,
  inferred = 0,
  unknown = 0,
}
M.MAX_EXTRACTION_FLUID_PER_COLOR = 9000
M.FLUX_FLUID_TO_COLOR = {
  ["fw-purple-flux"] = "purple",
  ["fw-yellow-flux"] = "yellow",
  ["fw-red-flux"] = "red",
  ["fw-green-flux"] = "green",
}
M.COLOR_TO_FLUX_FLUID = {
  purple = "fw-purple-flux",
  yellow = "fw-yellow-flux",
  red = "fw-red-flux",
  green = "fw-green-flux",
}

local CONFIDENCE_RANK = {
  locked = 5,
  anchored = 4,
  derived = 3,
  inferred = 2,
  unknown = 1,
}

local function make_signature()
  return {
    purple = false,
    yellow = false,
    red = false,
    green = false,
  }
end

local function confidence_rank(confidence)
  return CONFIDENCE_RANK[confidence] or 0
end

local function weaker_confidence(a, b)
  if confidence_rank(a) <= confidence_rank(b) then
    return a
  end
  return b
end

local function stronger_confidence(a, b)
  if confidence_rank(a) >= confidence_rank(b) then
    return a
  end
  return b
end

local function clone_signature(signature)
  local copy = make_signature()
  if not signature then
    return copy
  end
  for _, color in ipairs(M.COLOR_ORDER) do
    copy[color] = signature[color] == true
  end
  return copy
end

local function normalize_signature(colors)
  local signature = make_signature()
  if type(colors) == "string" then
    signature[colors] = true
    return signature
  end
  if not colors then
    return signature
  end
  for _, color in ipairs(colors) do
    if signature[color] ~= nil then
      signature[color] = true
    end
  end
  return signature
end

local function merge_signatures(into, other)
  for _, color in ipairs(M.COLOR_ORDER) do
    if other and other[color] then
      into[color] = true
    end
  end
  return into
end

local function make_breakdown()
  return {
    purple = 0,
    yellow = 0,
    red = 0,
    green = 0,
  }
end

local function clone_breakdown(breakdown)
  local copy = make_breakdown()
  if not breakdown then
    return copy
  end
  for _, color in ipairs(M.COLOR_ORDER) do
    copy[color] = breakdown[color] or 0
  end
  return copy
end

local function add_to_breakdown(into, other, scale)
  local mul = scale or 1
  for _, color in ipairs(M.COLOR_ORDER) do
    into[color] = (into[color] or 0) + ((other and other[color] or 0) * mul)
  end
  return into
end

local function scale_breakdown(breakdown, scale)
  local scaled = make_breakdown()
  for _, color in ipairs(M.COLOR_ORDER) do
    scaled[color] = (breakdown[color] or 0) * scale
  end
  return scaled
end

local function total_breakdown_value(breakdown)
  local total = 0
  for _, color in ipairs(M.COLOR_ORDER) do
    total = total + (breakdown[color] or 0)
  end
  return total
end

local function round_breakdown_to_total(breakdown, target_total)
  local rounded = make_breakdown()
  local fractions = {}
  local running_total = 0
  local source_total = total_breakdown_value(breakdown)
  if source_total <= 0 then
    rounded.purple = math.max(0, target_total)
    return rounded
  end
  local normalization = source_total > 0 and (target_total / source_total) or 0

  for _, color in ipairs(M.COLOR_ORDER) do
    local raw = math.max(0, breakdown[color] or 0) * normalization
    local whole = math.floor(raw)
    rounded[color] = whole
    running_total = running_total + whole
    table.insert(fractions, { color = color, frac = raw - whole })
  end

  table.sort(fractions, function(a, b)
    if a.frac == b.frac then
      return a.color < b.color
    end
    return a.frac > b.frac
  end)

  local remainder = math.max(0, target_total - running_total)
  -- Some modded items legitimately resolve into the millions. Distributing one
  -- unit per loop made data-final-fixes scale with total value instead of the
  -- number of prototypes.
  if remainder >= #fractions and #fractions > 0 then
    local rounds = math.floor(remainder / #fractions)
    for _, fraction in ipairs(fractions) do
      rounded[fraction.color] = rounded[fraction.color] + rounds
    end
    remainder = remainder - (rounds * #fractions)
  end

  local index = 1
  while remainder > 0 and index <= #fractions do
    rounded[fractions[index].color] = rounded[fractions[index].color] + 1
    remainder = remainder - 1
    index = index + 1
  end

  return rounded
end

local function signatures_equal(a, b)
  for _, color in ipairs(M.COLOR_ORDER) do
    if (a and a[color] or false) ~= (b and b[color] or false) then
      return false
    end
  end
  return true
end

local function has_any_color(signature)
  for _, color in ipairs(M.COLOR_ORDER) do
    if signature and signature[color] then
      return true
    end
  end
  return false
end

local function signature_color_count(signature)
  local count = 0
  for _, color in ipairs(M.COLOR_ORDER) do
    if signature and signature[color] then
      count = count + 1
    end
  end
  return count
end

local function signature_is_only_color(signature, target_color)
  return signature_color_count(signature) == 1 and signature and signature[target_color] == true
end

local function find_item_prototype(item_name)
  for _, item_type in ipairs(M.ITEM_TYPES) do
    local item = data.raw[item_type] and data.raw[item_type][item_name]
    if item then
      return item
    end
  end
  return nil
end

local function find_fluid_prototype(fluid_name)
  return data.raw.fluid and data.raw.fluid[fluid_name] or nil
end

local function resolve_recipe_category(recipe)
  local category = recipe.categories and recipe.categories[1] or recipe.category
  if type(category) ~= "string" or category == "" then
    category = recipe.normal and ((recipe.normal.categories and recipe.normal.categories[1]) or recipe.normal.category) or category
  end
  if type(category) ~= "string" or category == "" then
    category = recipe.expensive and ((recipe.expensive.categories and recipe.expensive.categories[1]) or recipe.expensive.category) or category
  end
  if type(category) ~= "string" or category == "" then
    return "crafting"
  end
  return category
end

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

local function parse_energy_to_joules(energy)
  if type(energy) ~= "string" then
    return nil
  end
  local value, unit = string.match(energy, "^%s*([%d%.]+)%s*([kMGT]?J)%s*$")
  if not value or not unit then
    return nil
  end
  local scale = ({
    J = 1,
    kJ = 1000,
    MJ = 1000000,
    GJ = 1000000000,
    TJ = 1000000000000,
  })[unit]
  if not scale then
    return nil
  end
  return tonumber(value) * scale
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
  for _, pattern in pairs(M.NON_CONVERTIBLE_ITEM_PATTERNS) do
    if string.find(item.name, pattern) then
      return false
    end
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

function M.estimate_fluid_value(fluid)
  if not fluid then
    return nil
  end

  local value = 0.08
  local temp_span = math.max(0, (fluid.max_temperature or fluid.default_temperature or 15) - (fluid.default_temperature or 15))
  value = value + math.min(1.2, temp_span / 250)

  local heat_capacity = parse_energy_to_joules(fluid.heat_capacity)
  if heat_capacity then
    value = value + math.min(2.0, heat_capacity / 1000000)
  end

  if fluid.fuel_value then
    local fuel = parse_energy_to_joules(fluid.fuel_value)
    if fuel then
      value = value + math.min(4.0, fuel / 10000000)
    else
      value = value + 1.0
    end
  end

  if fluid.gas_temperature then
    value = value + 0.25
  end

  return math.max(0.02, math.min(12, value))
end

function M.quality_value_multiplier(quality, item_name)
  local quality_name = quality and quality.name or "normal"
  local item_overrides = item_name and Compatibility.item_quality_multipliers[item_name]
  if item_overrides and item_overrides[quality_name] then
    return item_overrides[quality_name]
  end
  if Compatibility.quality_multipliers[quality_name] then
    return Compatibility.quality_multipliers[quality_name]
  end
  local level = math.max(0, quality and quality.level or 0)
  -- Quality is costly enough that full material-value preservation would make
  -- extraction an economic trap. This premium is meaningful but deliberately
  -- smaller than the expected crafting cost of producing that quality.
  return math.min(8, 1 + (0.30 * level) + (0.05 * level * level))
end

function M.value_for_quality(base_value, quality, item_name)
  return math.max(
    1,
    math.floor(((base_value or 1) * M.quality_value_multiplier(quality, item_name)) + 0.5)
  )
end

function M.is_quality_recoverable(quality, item_name)
  local quality_name = quality and quality.name or "normal"
  if Compatibility.quality_exclusions[quality_name] then return false end
  local item_exclusions = item_name and Compatibility.item_quality_exclusions[item_name]
  return not (item_exclusions and item_exclusions[quality_name])
end

function M.sorted_qualities(include_normal)
  local qualities = {}
  for _, quality in pairs(data.raw.quality or {}) do
    if quality.name ~= "quality-unknown"
      and not Compatibility.quality_exclusions[quality.name]
      and (include_normal or quality.name ~= "normal")
    then
      table.insert(qualities, quality)
    end
  end

  table.sort(qualities, function(a, b)
    if (a.level or 0) == (b.level or 0) then
      return (a.order or a.name) < (b.order or b.name)
    end
    return (a.level or 0) < (b.level or 0)
  end)

  return qualities
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
        local probability = result.independent_probability or result.probability or 1
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

local function recipe_result_profile(recipe, item_name)
  local profile = {
    target_amount = 0,
    target_has_range = false,
    target_probability = 1,
    distinct_item_results = 0,
    distinct_non_target_item_results = 0,
    has_non_target_fluid_results = false,
    has_any_range = false,
  }

  local seen_item_names = {}
  local results = get_entries(recipe, "results")
  if results then
    for _, result in pairs(results) do
      local kind = entry_type(result)
      local name = entry_name(result)
      local probability = result.independent_probability or result.probability or 1
      local has_range = result.amount_min ~= nil or result.amount_max ~= nil

      if has_range then
        profile.has_any_range = true
      end

      if kind == "item" then
        if not seen_item_names[name] then
          seen_item_names[name] = true
          profile.distinct_item_results = profile.distinct_item_results + 1
          if name ~= item_name then
            profile.distinct_non_target_item_results = profile.distinct_non_target_item_results + 1
          end
        end

        if name == item_name then
          profile.target_amount = profile.target_amount + (entry_amount(result) * probability)
          if has_range then
            profile.target_has_range = true
          end
          profile.target_probability = math.min(profile.target_probability, probability)
        end
      elseif kind == "fluid" then
        profile.has_non_target_fluid_results = true
      end
    end
    return profile
  end

  local single = recipe.result or (recipe.normal and recipe.normal.result)
  if single == item_name then
    profile.target_amount = recipe.result_count or (recipe.normal and recipe.normal.result_count) or 1
    profile.distinct_item_results = 1
  end
  return profile
end

local function is_primary_valuation_recipe(recipe, item_name)
  local profile = recipe_result_profile(recipe, item_name)
  if profile.target_amount <= 0 then
    return false
  end

  if recipe.main_product and recipe.main_product ~= item_name then
    return false
  end

  if profile.target_has_range or profile.target_probability < 1 or profile.has_any_range then
    return false
  end

  if profile.has_non_target_fluid_results then
    return false
  end

  if profile.distinct_non_target_item_results > 0 then
    return false
  end

  local category = resolve_recipe_category(recipe)
  local recipe_name = recipe.name or ""
  for _, unsafe_fragment in ipairs({
    "recycl", "void", "creative", "free", "barrel", "canister",
    "unpack", "pack%-", "reverse", "uncraft", "disassembl",
  }) do
    if string.find(string.lower(recipe_name), unsafe_fragment)
      or string.find(string.lower(category), unsafe_fragment)
    then
      return false
    end
  end

  local ingredients = get_entries(recipe, "ingredients")
  if not ingredients or #ingredients == 0 then
    return false
  end
  for _, ingredient in pairs(ingredients) do
    if entry_amount(ingredient) <= 0 or ingredient.catalyst_amount then
      return false
    end
  end

  return true
end

local function base_item_value(item_name, item)
  if M.VALUE_LOCKS[item_name] then
    return M.VALUE_LOCKS[item_name]
  end

  if M.VALUE_OVERRIDES[item_name] then
    return M.VALUE_OVERRIDES[item_name]
  end

  return M.estimate_flux_value(item)
end

local function is_resource_anchored_item(item)
  -- A subgroup is presentation, not economic evidence. Third-party mods often
  -- put trophies, infinite resources, and generated intermediates here.
  return item
    and item.subgroup == "raw-resource"
    and (M.VALUE_LOCKS[item.name] ~= nil or M.VALUE_OVERRIDES[item.name] ~= nil)
end

local function override_floor_value(item_name)
  if M.VALUE_LOCKS[item_name] then
    return M.VALUE_LOCKS[item_name]
  end
  return M.VALUE_OVERRIDES[item_name]
end

local function explicit_value_confidence(item_name)
  if M.VALUE_LOCKS[item_name] then
    return M.VALUE_CONFIDENCE.locked
  end
  if M.VALUE_OVERRIDES[item_name] then
    return M.VALUE_CONFIDENCE.anchored
  end
  return nil
end

local function lookup_item_value(item_name, provider)
  if type(provider) == "function" then
    return provider(item_name)
  end
  if type(provider) == "table" then
    return provider[item_name]
  end
  return nil
end

local function ingredient_flux_cost(recipe, value_provider)
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
      local item_value = lookup_item_value(name, value_provider)
      if not item_value then
        local source_item = find_item_prototype(name)
        item_value = source_item and M.estimate_flux_value(source_item) or nil
      end
      if not item_value then
        return nil
      end
      total = total + (item_value * amount)
    elseif kind == "fluid" then
      local fluid_value = M.FLUID_VALUE_OVERRIDES[name]
      if not fluid_value then
        fluid_value = M.estimate_fluid_value(find_fluid_prototype(name))
      end
      if not fluid_value then
        return nil
      end
      total = total + (fluid_value * amount)
    end
  end
  local category = resolve_recipe_category(recipe)
  local mult = M.RECIPE_CATEGORY_VALUE_MULTIPLIERS[category] or 1
  local time_mult = M.RECIPE_CATEGORY_TIME_MULTIPLIERS[category] or 1
  local energy = recipe.energy_required or (recipe.normal and recipe.normal.energy_required) or 0.5
  return (total * mult) + (energy * M.DEFAULT_TIME_VALUE * time_mult)
end

local function collect_recipe_candidates(candidate_items)
  local primary_recipes_by_result = {}
  local fallback_recipes_by_result = {}

  for recipe_name, recipe in pairs(data.raw.recipe or {}) do
    local category = resolve_recipe_category(recipe)
    local excluded_category = string.find(string.lower(category), "recycl", 1, true)
      or string.find(string.lower(category), "void", 1, true)
    if not recipe.hidden
      and recipe_name ~= "fw-flux-condenser"
      and string.sub(recipe_name, 1, 12) ~= "fw-exchange-"
      and not excluded_category
    then
      local function register_result(name)
        if not name or not candidate_items[name] then
          return
        end
        fallback_recipes_by_result[name] = fallback_recipes_by_result[name] or {}
        table.insert(fallback_recipes_by_result[name], recipe)
        if is_primary_valuation_recipe(recipe, name) then
          primary_recipes_by_result[name] = primary_recipes_by_result[name] or {}
          table.insert(primary_recipes_by_result[name], recipe)
        end
      end

      local results = get_entries(recipe, "results")
      if results then
        local seen_result_names = {}
        for _, result in pairs(results) do
          if entry_type(result) == "item" then
            local name = entry_name(result)
            if name and not seen_result_names[name] then
              seen_result_names[name] = true
              register_result(name)
            end
          end
        end
      else
        register_result(recipe.result or (recipe.normal and recipe.normal.result))
      end
    end
  end

  return primary_recipes_by_result, fallback_recipes_by_result
end

local placed_entity_cache = {}

local function placed_entity(item)
  if not item or not item.place_result then return nil end
  if placed_entity_cache[item.place_result] ~= nil then
    return placed_entity_cache[item.place_result] or nil
  end
  for prototype_type, prototypes in pairs(data.raw) do
    if prototype_type ~= "item" and prototype_type ~= "recipe" then
      local prototype = prototypes[item.place_result]
      if prototype then
        placed_entity_cache[item.place_result] = prototype
        return prototype
      end
    end
  end
  placed_entity_cache[item.place_result] = false
  return nil
end

local function contains_any(text, fragments)
  local lowered = string.lower(text or "")
  for _, fragment in ipairs(fragments) do
    if string.find(lowered, fragment, 1, true) then return true end
  end
  return false
end

-- Built-in spectra predate the public compatibility API and use compact lists
-- such as { "green", "yellow" }. API registrations use weighted maps such as
-- { green = 0.7, yellow = 0.3 }. Keep both representations valid at the single
-- evaluator boundary so neither source silently loses its spectrum identity.
local function override_color_weight(spectrum, target_color)
  if not spectrum then return 0 end

  local weighted = spectrum[target_color]
  if type(weighted) == "number" then
    return math.max(0, weighted)
  end

  for _, color in ipairs(spectrum) do
    if color == target_color then
      return 1
    end
  end
  return 0
end

local function override_total_weight(spectrum)
  local total = 0
  for _, color in ipairs(M.COLOR_ORDER) do
    total = total + override_color_weight(spectrum, color)
  end
  return total
end

local function default_item_color_weights(item)
  local weights = make_breakdown()
  local override = M.ITEM_COLOR_OVERRIDES[item.name]
  if override then
    for _, color in ipairs(M.COLOR_ORDER) do
      weights[color] = override_color_weight(override, color)
    end
  else
    weights.purple = 0.35
    local searchable = (item.name or "") .. " " .. (item.subgroup or "")
    local entity = placed_entity(item)

    if item.fuel_value or item.type == "ammo" or item.type == "gun" then
      weights.red = weights.red + 1.6
    end
    if item.type == "module" or item.type == "tool" then
      weights.yellow = weights.yellow + 1.4
    end
    if item.spoil_ticks or item.spoil_result or item.plant_result then
      weights.green = weights.green + 2.0
    end

    if entity then
      if entity.energy_source or entity.energy_usage or entity.max_energy_usage then
        weights.red = weights.red + 0.8
      end
      if entity.circuit_wire_max_distance
        or entity.circuit_connector
        or entity.control_behavior
        or entity.module_slots
      then
        weights.yellow = weights.yellow + 1.0
      end
      if entity.crafting_categories or entity.resource_categories then
        weights.purple = weights.purple + 0.8
      end

      if entity.type == "agricultural-tower" or entity.type == "plant" then
        weights.green = weights.green + 2.2
      elseif entity.type == "electric-turret"
        or entity.type == "generator"
        or entity.type == "reactor"
        or entity.type == "fusion-reactor"
      then
        weights.red = weights.red + 1.5
      elseif entity.type == "arithmetic-combinator"
        or entity.type == "decider-combinator"
        or entity.type == "selector-combinator"
        or entity.type == "radar"
        or entity.type == "lab"
      then
        weights.yellow = weights.yellow + 1.7
      elseif entity.type == "container"
        or entity.type == "logistic-container"
        or entity.type == "storage-tank"
        or entity.type == "wall"
      then
        weights.purple = weights.purple + 1.5
      end
    end

    if contains_any(searchable, {
      "circuit", "computer", "processor", "sensor", "signal", "data", "logic", "chip", "electro",
    }) then
      weights.yellow = weights.yellow + 1.2
    end
    if contains_any(searchable, {
      "fuel", "rocket", "reactor", "thermal", "heat", "explosive", "ammo", "weapon",
    }) then
      weights.red = weights.red + 1.2
    end
    if contains_any(searchable, {
      "bio", "agric", "seed", "spore", "nutrient", "wood", "fish", "egg", "plant",
    }) then
      weights.green = weights.green + 1.4
    end
    if contains_any(searchable, {
      "plate", "ore", "brick", "concrete", "frame", "beam", "wall", "container", "structure",
    }) then
      weights.purple = weights.purple + 1.0
    end
  end

  local total = total_breakdown_value(weights)
  if total <= 0 then
    weights.purple = 1
    return weights
  end
  for _, color in ipairs(M.COLOR_ORDER) do
    weights[color] = weights[color] / total
  end
  return weights
end

local function default_item_color_signature(item)
  local signature = make_signature()
  if not item then return signature end
  local weights = default_item_color_weights(item)
  for _, color in ipairs(M.COLOR_ORDER) do
    signature[color] = (weights[color] or 0) >= 0.15
  end
  return signature
end

local function default_item_breakdown(item, known_values)
  local total = known_values[item.name] or M.VALUE_OVERRIDES[item.name] or M.estimate_flux_value(item)
  local weights = default_item_color_weights(item)
  local breakdown = make_breakdown()
  for _, color in ipairs(M.COLOR_ORDER) do
    breakdown[color] = total * (weights[color] or 0)
  end
  return round_breakdown_to_total(breakdown, math.max(1, math.floor(total + 0.5)))
end

function M.simple_item_breakdown(item, known_values)
  if not item then
    return make_breakdown()
  end
  return default_item_breakdown(item, known_values or {})
end

local function fluid_color_signature(fluid_name)
  local override = M.FLUID_COLOR_OVERRIDES[fluid_name]
  if override then
    local signature = make_signature()
    for _, color in ipairs(M.COLOR_ORDER) do
      signature[color] = override_color_weight(override, color) > 0
    end
    return signature
  end
  local flux_color = M.FLUX_FLUID_TO_COLOR[fluid_name]
  if flux_color then
    return normalize_signature({ flux_color })
  end
  local fluid = find_fluid_prototype(fluid_name)
  if fluid then
    local colors = {}
    local searchable = fluid_name .. " " .. (fluid.subgroup or "")
    local default_temperature = fluid.default_temperature or 15
    if fluid.fuel_value or default_temperature >= 200 then
      colors[#colors + 1] = "red"
    end
    if contains_any(searchable, {
      "bio", "nutrient", "spore", "sludge", "sewage", "blood", "fish", "algae",
    }) then
      colors[#colors + 1] = "green"
    end
    if fluid.gas_temperature
      or contains_any(searchable, {
        "acid", "oil", "gas", "electrolyte", "ammonia", "chlor", "resin", "solvent",
      })
    then
      colors[#colors + 1] = "yellow"
    end
    if contains_any(searchable, {
      "molten", "slurry", "brine", "mineral", "concrete", "metal",
    }) then
      colors[#colors + 1] = "purple"
    end
    if #colors > 0 then
      return normalize_signature(colors)
    end
  end
  return make_signature()
end

local function fluid_breakdown(fluid_name, amount)
  local value = M.FLUID_VALUE_OVERRIDES[fluid_name]
  if not value then
    value = M.estimate_fluid_value(find_fluid_prototype(fluid_name))
    if not value then
      return nil
    end
  end

  local total = value * amount
  local override = M.FLUID_COLOR_OVERRIDES[fluid_name]
  if override then
    local override_total = override_total_weight(override)
    local weighted = make_breakdown()
    if override_total <= 0 then
      return weighted
    end
    for _, color in ipairs(M.COLOR_ORDER) do
      weighted[color] = total * (override_color_weight(override, color) / override_total)
    end
    return weighted
  end

  local signature = fluid_color_signature(fluid_name)
  local colors = M.signature_to_ordered_colors(signature)
  local breakdown = make_breakdown()

  if #colors == 0 then
    return breakdown
  end

  if #colors == 1 then
    breakdown[colors[1]] = total
    return breakdown
  end

  local share = total / #colors
  for _, color in ipairs(colors) do
    breakdown[color] = share
  end
  return breakdown
end

local function item_color_signature(item_name, known_colors)
  local override = M.ITEM_COLOR_OVERRIDES[item_name]
  if override then
    local signature = make_signature()
    for _, color in ipairs(M.COLOR_ORDER) do
      signature[color] = override_color_weight(override, color) > 0
    end
    return signature
  end
  if known_colors[item_name] then
    return clone_signature(known_colors[item_name])
  end
  local item = find_item_prototype(item_name)
  if item then
    return default_item_color_signature(item)
  end
  return normalize_signature({ "purple" })
end

local function ingredient_color_signature(recipe, known_colors)
  local ingredients = get_entries(recipe, "ingredients")
  if not ingredients then
    return nil
  end

  local signature = make_signature()
  for _, ingredient in pairs(ingredients) do
    local kind = entry_type(ingredient)
    local name = entry_name(ingredient)
    if kind == "item" then
      merge_signatures(signature, item_color_signature(name, known_colors))
    elseif kind == "fluid" then
      merge_signatures(signature, fluid_color_signature(name))
    end
  end
  return signature
end

local function normalize_weight_breakdown(weights)
  local breakdown = make_breakdown()
  local total = 0
  for _, color in ipairs(M.COLOR_ORDER) do
    local amount = math.max(0, weights and weights[color] or 0)
    breakdown[color] = amount
    total = total + amount
  end
  if total <= 0 then
    return breakdown
  end
  for _, color in ipairs(M.COLOR_ORDER) do
    breakdown[color] = breakdown[color] / total
  end
  return breakdown
end

local function filter_weights_to_signature(weights, signature)
  local filtered = make_breakdown()
  local has_match = false

  for _, color in ipairs(M.COLOR_ORDER) do
    if signature and signature[color] then
      filtered[color] = weights[color] or 0
      if filtered[color] > 0 then
        has_match = true
      end
    end
  end

  if not has_match then
    return nil
  end

  return normalize_weight_breakdown(filtered)
end

local function recipe_category_color_weights(recipe)
  local category = resolve_recipe_category(recipe)
  local weights = M.RECIPE_CATEGORY_COLOR_WEIGHTS[category]
  if weights then
    return normalize_weight_breakdown(weights)
  end

  if string.find(category, "chem", 1, true) then
    return normalize_weight_breakdown({ yellow = 1 })
  end
  if string.find(category, "organic", 1, true) or string.find(category, "bio", 1, true) then
    return normalize_weight_breakdown({ green = 1 })
  end
  if string.find(category, "rocket", 1, true) then
    return normalize_weight_breakdown({ purple = 0.4, red = 0.6 })
  end
  if string.find(category, "smelt", 1, true) or string.find(category, "metal", 1, true) then
    return normalize_weight_breakdown({ purple = 0.9, red = 0.1 })
  end
  return normalize_weight_breakdown({ purple = 1 })
end

local function breakdowns_equal(a, b)
  for _, color in ipairs(M.COLOR_ORDER) do
    if math.floor((a and a[color] or 0) + 0.5) ~= math.floor((b and b[color] or 0) + 0.5) then
      return false
    end
  end
  return true
end

local function signature_from_breakdown(breakdown)
  local signature = make_signature()
  for _, color in ipairs(M.COLOR_ORDER) do
    if breakdown and (breakdown[color] or 0) > 0 then
      signature[color] = true
    end
  end
  return signature
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

function M.collect_extractable_items()
  return collect_items(function(item)
    -- Stateful vehicle/equipment items can contain inventories or grids that
    -- the prototype valuation cannot see. Everything else with a real item
    -- prototype can be destructively evaluated by the extractor.
    return M.is_valued_item(item) and item.type ~= "item-with-entity-data"
  end)
end

function M.is_confident_value(metadata)
  local confidence = metadata and metadata.confidence or M.VALUE_CONFIDENCE.unknown
  return confidence == M.VALUE_CONFIDENCE.locked
    or confidence == M.VALUE_CONFIDENCE.anchored
    or confidence == M.VALUE_CONFIDENCE.derived
end

function M.extraction_efficiency(metadata)
  local confidence = metadata and metadata.confidence or M.VALUE_CONFIDENCE.unknown
  return M.EXTRACTION_EFFICIENCY[confidence] or M.EXTRACTION_EFFICIENCY.unknown
end

function M.extraction_difficulty_multiplier()
  local setting = settings
    and settings.startup
    and settings.startup["fw-balance-condensing-difficulty"]
  local difficulty = setting and setting.value or "normal"
  if difficulty == "easy" then
    return 1.20
  end
  if difficulty == "hard" then
    return 0.75
  end
  return 1
end

function M.extraction_amounts(value, breakdown, metadata)
  local recovered_total = math.max(
    0.25,
    (value or 1) * M.extraction_efficiency(metadata) * M.extraction_difficulty_multiplier()
  )
  local source = clone_breakdown(breakdown)
  local source_total = total_breakdown_value(source)

  if source_total <= 0 then
    source.purple = 1
    source_total = 1
  end

  local amounts = make_breakdown()
  for _, color in ipairs(M.COLOR_ORDER) do
    local share = math.max(0, source[color] or 0) / source_total
    if share > 0 then
      local flux_fluid = M.COLOR_TO_FLUX_FLUID[color]
      local unit_value = M.FLUID_VALUE_OVERRIDES[flux_fluid] or 1
      amounts[color] = math.min(
        M.MAX_EXTRACTION_FLUID_PER_COLOR,
        (recovered_total * share) / unit_value
      )
    end
  end
  return amounts, recovered_total
end

function M.flux_unit_value(color)
  local fluid_name = M.COLOR_TO_FLUX_FLUID[color]
  return fluid_name and (M.FLUID_VALUE_OVERRIDES[fluid_name] or 1) or nil
end

function M.resolve_item_values(candidate_items)
  local values = {}
  local chosen_recipes = {}
  local metadata = {}
  local primary_recipes_by_result, fallback_recipes_by_result = collect_recipe_candidates(candidate_items)
  local visiting = {}

  local function resolve_item_value(item_name)
    if values[item_name] then
      return values[item_name]
    end

    if M.VALUE_LOCKS[item_name] then
      values[item_name] = M.VALUE_LOCKS[item_name]
      metadata[item_name] = {
        confidence = M.VALUE_CONFIDENCE.locked,
        source = "manual-lock",
      }
      return values[item_name]
    end

    if visiting[item_name] then
      return nil
    end

    visiting[item_name] = true

    local item = candidate_items[item_name] or find_item_prototype(item_name)
    local fallback_value = base_item_value(item_name, item)
    local override_floor = override_floor_value(item_name) or 0
    local explicit_confidence = explicit_value_confidence(item_name)

    if is_resource_anchored_item(item) then
      visiting[item_name] = nil
      values[item_name] = math.max(fallback_value or 1, override_floor)
      metadata[item_name] = {
        confidence = explicit_confidence or M.VALUE_CONFIDENCE.anchored,
        source = explicit_confidence and "manual-anchor" or "resource-anchor",
      }
      chosen_recipes[item_name] = nil
      return values[item_name]
    end

    local candidate_groups = {
      { recipes = primary_recipes_by_result[item_name], confidence = M.VALUE_CONFIDENCE.derived, source = "primary-recipe" },
      { recipes = fallback_recipes_by_result[item_name], confidence = M.VALUE_CONFIDENCE.inferred, source = "fallback-recipe" },
    }

    local best_value = nil
    local best_recipe = nil
    local best_metadata = nil

    for _, candidate_group in ipairs(candidate_groups) do
      local candidates = candidate_group.recipes
      if candidates and #candidates > 0 then
        for _, recipe in pairs(candidates) do
          local recipe_confidence = candidate_group.confidence
          local ingredient_failed = false
          for _, ingredient in pairs(get_entries(recipe, "ingredients") or {}) do
            if entry_type(ingredient) == "item" then
              local ingredient_name = entry_name(ingredient)
              local ingredient_value = resolve_item_value(ingredient_name)
              local ingredient_meta = metadata[ingredient_name]
              if not ingredient_value or not ingredient_meta or ingredient_meta.confidence == M.VALUE_CONFIDENCE.unknown then
                ingredient_failed = true
                break
              end
              recipe_confidence = weaker_confidence(recipe_confidence, ingredient_meta.confidence)
            elseif not M.FLUID_VALUE_OVERRIDES[entry_name(ingredient)] then
              -- Physical properties can provide a tooltip estimate, but they do
              -- not prove the economic value of an arbitrary modded fluid.
              recipe_confidence = weaker_confidence(
                recipe_confidence,
                M.VALUE_CONFIDENCE.inferred
              )
            end
          end

          if not ingredient_failed then
          local ing_cost = ingredient_flux_cost(recipe, resolve_item_value)
          if ing_cost then
            local out_amount = result_amount_for(recipe, item_name)
            if out_amount and out_amount > 0 then
              local derived = math.max(1, math.floor((ing_cost / out_amount) + 0.5))
              if override_floor > 0 then
                derived = math.max(derived, override_floor)
              end
              if not best_value or derived < best_value then
                best_value = derived
                best_recipe = recipe
                best_metadata = {
                  confidence = recipe_confidence,
                  source = candidate_group.source,
                }
              end
            end
          end
          end
        end
        if best_value then
          break
        end
      end
    end

    visiting[item_name] = nil

    values[item_name] = best_value or fallback_value
    chosen_recipes[item_name] = best_recipe
    metadata[item_name] = best_metadata or {
      confidence = explicit_confidence or M.VALUE_CONFIDENCE.unknown,
      source = explicit_confidence and "manual-anchor" or "heuristic-fallback",
    }
    if explicit_confidence then
      metadata[item_name].confidence = stronger_confidence(metadata[item_name].confidence, explicit_confidence)
      if metadata[item_name].source ~= "manual-lock" then
        metadata[item_name].source = "manual-anchor+" .. tostring(metadata[item_name].source)
      end
    end
    return values[item_name]
  end

  for item_name, _ in pairs(candidate_items) do
    resolve_item_value(item_name)
  end

  M._last_resolved_value_recipes = chosen_recipes
  M._last_resolution_metadata = metadata
  return values
end

function M.resolve_recoverable_values(candidate_items, resolved_values)
  local full_values = resolved_values or M.resolve_item_values(candidate_items)
  local chosen_recipes = M._last_resolved_value_recipes or {}
  local recoverable = {}
  local visiting = {}

  local function resolve(item_name)
    if recoverable[item_name] then
      return recoverable[item_name]
    end
    if visiting[item_name] then
      return nil
    end

    visiting[item_name] = true
    local item = candidate_items[item_name] or find_item_prototype(item_name)
    local recipe = chosen_recipes[item_name]
    local material_value = nil

    if recipe then
      local total = 0
      local complete = true
      for _, ingredient in pairs(get_entries(recipe, "ingredients") or {}) do
        local amount = entry_amount(ingredient)
        if entry_type(ingredient) == "item" then
          local ingredient_value = resolve(entry_name(ingredient))
          if not ingredient_value then
            complete = false
            break
          end
          total = total + (ingredient_value * amount)
        else
          local fluid_name = entry_name(ingredient)
          local fluid_value = M.FLUID_VALUE_OVERRIDES[fluid_name]
            or M.estimate_fluid_value(find_fluid_prototype(fluid_name))
          if not fluid_value then
            complete = false
            break
          end
          total = total + (fluid_value * amount)
        end
      end
      local output_amount = result_amount_for(recipe, item_name)
      if complete and output_amount > 0 then
        material_value = total / output_amount
      end
    end

    if not material_value then
      material_value = M.VALUE_LOCKS[item_name]
        or M.VALUE_OVERRIDES[item_name]
        or (item and M.estimate_flux_value(item))
        or 1
    end

    visiting[item_name] = nil
    recoverable[item_name] = math.max(0.25, math.min(full_values[item_name] or material_value, material_value))
    return recoverable[item_name]
  end

  for item_name, _ in pairs(candidate_items) do
    resolve(item_name)
  end
  return recoverable
end

function M.resolve_item_color_amounts(candidate_items, known_values)
  local primary_recipes_by_result, fallback_recipes_by_result = collect_recipe_candidates(candidate_items)
  local breakdowns = {}
  for item_name, item in pairs(candidate_items) do
    breakdowns[item_name] = default_item_breakdown(item, known_values or {})
  end

  local resolve_breakdown
  local function item_breakdown_by_name(item_name)
    if candidate_items[item_name] and resolve_breakdown then
      return resolve_breakdown(item_name)
    end
    if breakdowns[item_name] then
      return breakdowns[item_name]
    end
    local source_item = find_item_prototype(item_name)
    if source_item then
      return default_item_breakdown(source_item, known_values or {})
    end
    return nil
  end

  local recipe_choice_cache = {}
  local recipe_choice_visiting = {}
  local function choose_recipe(item_name)
    if recipe_choice_cache[item_name] ~= nil then
      return recipe_choice_cache[item_name]
    end
    if recipe_choice_visiting[item_name] then
      return nil
    end

    recipe_choice_visiting[item_name] = true
    local locked_choice = M._last_resolved_value_recipes and M._last_resolved_value_recipes[item_name]
    if locked_choice then
      recipe_choice_visiting[item_name] = nil
      recipe_choice_cache[item_name] = locked_choice
      return locked_choice
    end

    local candidates = primary_recipes_by_result[item_name] or fallback_recipes_by_result[item_name] or {}
    local best_recipe = nil
    local best_cost = nil

    for _, recipe in pairs(candidates) do
      local cost = ingredient_flux_cost(recipe, known_values or {})
      local out_amount = result_amount_for(recipe, item_name)
      if cost and out_amount and out_amount > 0 then
        local per_unit = cost / out_amount
        if not best_cost or per_unit < best_cost then
          best_cost = per_unit
          best_recipe = recipe
        end
      end
    end

    recipe_choice_visiting[item_name] = nil
    recipe_choice_cache[item_name] = best_recipe or false
    return recipe_choice_cache[item_name] or nil
  end

  local function derive_recipe_breakdown(recipe, item_name)
    local ingredients = get_entries(recipe, "ingredients")
    local cost = ingredient_flux_cost(recipe, known_values or {})
    local out_amount = result_amount_for(recipe, item_name)
    if not (ingredients and cost and out_amount and out_amount > 0) then
      return nil, nil
    end

    local ingredient_breakdown = make_breakdown()
    local ingredient_total = 0
    local inherited_signature = make_signature()

    for _, ingredient in pairs(ingredients) do
      local kind = entry_type(ingredient)
      local name = entry_name(ingredient)
      local amount = entry_amount(ingredient)
      if kind == "item" then
        local source = item_breakdown_by_name(name)
        if not source then
          return nil, nil
        end
        add_to_breakdown(ingredient_breakdown, source, amount)
        ingredient_total = ingredient_total + (total_breakdown_value(source) * amount)
        merge_signatures(inherited_signature, signature_from_breakdown(source))
      elseif kind == "fluid" then
        local source = fluid_breakdown(name, amount)
        if not source then
          return nil, nil
        end
        add_to_breakdown(ingredient_breakdown, source)
        ingredient_total = ingredient_total + total_breakdown_value(source)
        merge_signatures(inherited_signature, fluid_color_signature(name))
      end
    end

    local derived = make_breakdown()
    local process_share = ingredient_total > 0 and M.RECIPE_PROCESS_COLOR_SHARE or 1
    if ingredient_total > 0 then
      local ingredient_budget = cost * (1 - process_share)
      local ingredient_scale = ingredient_budget > 0 and (ingredient_budget / ingredient_total) or 0
      add_to_breakdown(derived, ingredient_breakdown, ingredient_scale / out_amount)
    end

    local process_budget = (cost * process_share) / out_amount
    local process_weights = recipe_category_color_weights(recipe)
    -- Process identity is allowed to introduce a new spectrum rather than only
    -- reinforcing ingredient colors.
    for _, color in ipairs(M.COLOR_ORDER) do
      derived[color] = derived[color] + ((process_weights[color] or 0) * process_budget)
    end

    return derived, cost / out_amount
  end

  local breakdown_cache = {}
  local breakdown_visiting = {}

  function resolve_breakdown(item_name)
    if breakdown_cache[item_name] then
      return breakdown_cache[item_name]
    end
    if breakdown_visiting[item_name] then
      return breakdowns[item_name]
    end

    breakdown_visiting[item_name] = true

    local item = candidate_items[item_name] or find_item_prototype(item_name)
    local total_value = known_values[item_name] or M.VALUE_OVERRIDES[item_name] or (item and M.estimate_flux_value(item)) or 1
    local explicit_spectrum = M.ITEM_COLOR_OVERRIDES[item_name] ~= nil
    local recipe = not explicit_spectrum and choose_recipe(item_name) or nil
    local derived = recipe and select(1, derive_recipe_breakdown(recipe, item_name)) or nil
    local resolved = derived or (item and default_item_breakdown(item, known_values or {})) or make_breakdown()
    local rounded = round_breakdown_to_total(resolved, math.max(1, math.floor(total_value + 0.5)))

    breakdown_visiting[item_name] = nil
    breakdown_cache[item_name] = rounded
    breakdowns[item_name] = rounded
    return rounded
  end

  for item_name, _ in pairs(candidate_items) do
    resolve_breakdown(item_name)
  end

  for item_name, item in pairs(candidate_items) do
    if not breakdowns[item_name] then
      breakdowns[item_name] = default_item_breakdown(item, known_values or {})
    end
  end

  return breakdowns
end

function M.resolve_item_colors(candidate_items, known_values)
  local breakdowns = M.resolve_item_color_amounts(candidate_items, known_values)
  local colors = {}
  for item_name, item in pairs(candidate_items) do
    local signature = make_signature()
    local breakdown = breakdowns[item_name]
    for _, color in ipairs(M.COLOR_ORDER) do
      if breakdown and (breakdown[color] or 0) > 0 then
        signature[color] = true
      end
    end
    if not has_any_color(signature) then
      signature = default_item_color_signature(item)
    end
    colors[item_name] = signature
  end
  return colors
end

function M.signature_to_ordered_colors(signature)
  local ordered = {}
  for _, color in ipairs(M.COLOR_ORDER) do
    if signature and signature[color] then
      table.insert(ordered, color)
    end
  end
  return ordered
end

return M
