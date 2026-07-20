local FluxValuation = require("prototypes.lib.flux-valuation")

local function clone_flux_markup(value)
  if value <= 8 then
    return 1.40
  end
  if value <= 24 then
    return 1.60
  end
  if value <= 60 then
    return 1.85
  end
  return 2.20
end

local function clone_fallback_time(value)
  if value <= 8 then
    return 1.8
  end
  if value <= 24 then
    return 3.5
  end
  if value <= 60 then
    return 5.5
  end
  return 8.5
end

local function recipe_entries(recipe, field)
  if recipe[field] then
    return recipe[field]
  end
  if recipe.normal and recipe.normal[field] then
    return recipe.normal[field]
  end
  return nil
end

local function recipe_entry_type(entry)
  return entry.type or "item"
end

local function recipe_entry_name(entry)
  return entry.name or entry[1]
end

local function recipe_energy(recipe)
  return recipe.energy_required or (recipe.normal and recipe.normal.energy_required) or 0.5
end

local function recipe_makes_item(recipe, item_name)
  local results = recipe_entries(recipe, "results")
  if results then
    for _, result in pairs(results) do
      if recipe_entry_type(result) == "item" and recipe_entry_name(result) == item_name then
        return true
      end
    end
    return false
  end
  return recipe.result == item_name or (recipe.normal and recipe.normal.result == item_name)
end

local function original_recipe_time(item_name)
  local best = nil
  for recipe_name, recipe in pairs(data.raw.recipe or {}) do
    if not recipe.hidden and recipe_name ~= "fw-flux-condenser" and string.sub(recipe_name, 1, 12) ~= "fw-exchange-" and recipe_makes_item(recipe, item_name) then
      local energy = recipe_energy(recipe)
      if energy and energy > 0 and (not best or energy < best) then
        best = energy
      end
    end
  end
  return best
end

local function recipe_icon_from_item(item_name)
  local item = data.raw.item[item_name]
    or data.raw.ammo[item_name]
    or data.raw.capsule[item_name]
    or data.raw.gun[item_name]
    or data.raw.module[item_name]
    or data.raw.armor[item_name]
    or data.raw.tool[item_name]
    or data.raw["repair-tool"][item_name]
    or data.raw["item-with-entity-data"][item_name]

  if not item then
    return nil
  end

  if item.icons then
    return { icons = table.deepcopy(item.icons) }
  end

  if item.icon then
    return {
      icon = item.icon,
      icon_size = item.icon_size or 64,
      icon_mipmaps = item.icon_mipmaps,
    }
  end

  return nil
end

local CONDENSER_EXCLUDED_ITEMS = {
  ["iron-ore"] = true,
  ["copper-ore"] = true,
  ["coal"] = true,
  ["stone"] = true,
  ["iron-plate"] = true,
  ["copper-plate"] = true,
  ["steel-plate"] = true,
  ["stone-brick"] = true,
  ["plastic-bar"] = true,
  ["sulfur"] = true,
  ["battery"] = true,
  ["copper-cable"] = true,
  ["electronic-circuit"] = true,
  ["advanced-circuit"] = true,
  ["processing-unit"] = true,
  ["engine-unit"] = true,
  ["electric-engine-unit"] = true,
  ["foundation"] = true,
  ["fw-universal-collapse-core"] = true,
  ["fw-genesis-ark"] = true,
  ["fw-origin-singularity"] = true,
}

local CONDENSER_EXCLUDED_SUBGROUPS = {
  ["raw-material"] = true,
}

local function item_is_complex_enough(item_name, item, base_value)
  if CONDENSER_EXCLUDED_ITEMS[item_name] then
    return false
  end
  if item and item.subgroup and CONDENSER_EXCLUDED_SUBGROUPS[item.subgroup] then
    return false
  end
  if string.match(item_name, "%-science%-pack$") then
    return false
  end
  if item and item.place_result then
    return true
  end
  if string.sub(item_name, 1, 3) == "fw-" then
    return true
  end
  return (base_value or 0) >= 120 and (original_recipe_time(item_name) or 0) >= 3
end

local FLUX_COLOR_TO_FLUID = {
  purple = "fw-purple-flux",
  yellow = "fw-yellow-flux",
  red = "fw-red-flux",
  green = "fw-green-flux",
}

local function normalized_clone_breakdown(flux_breakdown)
  local breakdown = {}
  local total = 0

  for _, color in ipairs(FluxValuation.COLOR_ORDER) do
    local amount = math.max(0, (flux_breakdown and flux_breakdown[color]) or 0)
    breakdown[color] = amount
    total = total + amount
  end

  if total <= 0 then
    for _, color in ipairs(FluxValuation.COLOR_ORDER) do
      breakdown[color] = 1
    end
    return breakdown, #FluxValuation.COLOR_ORDER
  end

  for _, color in ipairs(FluxValuation.COLOR_ORDER) do
    -- Every condenser recipe should consume all four spectra, even if the
    -- valued item leans heavily toward one branch.
    breakdown[color] = breakdown[color] + 1
    total = total + 1
  end

  return breakdown, total
end

local function round_breakdown_to_total(breakdown, target_total)
  local rounded = {
    purple = 0,
    yellow = 0,
    red = 0,
    green = 0,
  }
  local fractions = {}
  local running_total = 0

  for _, color in ipairs(FluxValuation.COLOR_ORDER) do
    local raw = math.max(0, breakdown[color] or 0)
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
  local index = 1
  while remainder > 0 and index <= #fractions do
    rounded[fractions[index].color] = rounded[fractions[index].color] + 1
    remainder = remainder - 1
    index = index + 1
    if index > #fractions and remainder > 0 then
      index = 1
    end
  end

  return rounded
end

local function scaled_flux_ingredients(flux_breakdown, required_flux)
  local ingredients = {}
  local normalized_breakdown, total = normalized_clone_breakdown(flux_breakdown)

  local scaled = {}
  for _, color in ipairs(FluxValuation.COLOR_ORDER) do
    scaled[color] = ((normalized_breakdown[color] or 0) / total) * required_flux
  end
  local rounded = round_breakdown_to_total(scaled, required_flux)

  for _, color in ipairs(FluxValuation.COLOR_ORDER) do
    -- Matter composition always needs the complete spectrum. The valuation
    -- breakdown controls the ratio, while one unit preserves every color's
    -- physical role even when the resolved contribution rounds to zero.
    local amount = math.max(1, rounded[color] or 0)
    table.insert(ingredients, {
      type = "fluid",
      name = FLUX_COLOR_TO_FLUID[color],
      amount = amount,
    })
  end

  return ingredients
end

local function flux_ingredient_tags(flux_breakdown)
  local tags = {}
  local normalized_breakdown = normalized_clone_breakdown(flux_breakdown)
  for _, color in ipairs(FluxValuation.COLOR_ORDER) do
    if (normalized_breakdown[color] or 0) > 0 then
      table.insert(tags, "[fluid=" .. FLUX_COLOR_TO_FLUID[color] .. "]")
    end
  end
  return table.concat(tags)
end

local function make_clone_recipe(item_name, item, flux_value, flux_breakdown)
  local energy = ((item.subgroup ~= "raw-resource" and original_recipe_time(item_name)) or clone_fallback_time(flux_value)) * 8
  local required_flux = math.max(1, math.floor((flux_value * clone_flux_markup(flux_value)) + 0.5))
  local ingredients = scaled_flux_ingredients(flux_breakdown or {}, required_flux)
  local results = {
    { type = "item", name = item_name, amount = 1 },
  }

  local recipe = {
    type = "recipe",
    name = "fw-exchange-from-flux-" .. item_name,
    category = "fw-flux-condensing",
    subgroup = "fw-flux-exchange",
    order = "z-a[" .. item_name .. "]",
    enabled = false,
    hidden = false,
    hide_from_player_crafting = true,
    hide_from_stats = false,
    hide_from_signal_gui = true,
    hidden_in_factoriopedia = false,
    allow_productivity = false,
    allow_quality = false,
    energy_required = energy,
    localised_name = { "", flux_ingredient_tags(flux_breakdown or {}), " -> [item=" .. item_name .. "] ", { "item-name." .. item_name } },
    ingredients = ingredients,
    results = results,
    main_product = item_name,
  }
  local icon = recipe_icon_from_item(item_name)
  if icon then
    recipe.icons = icon.icons
    recipe.icon = icon.icon
    recipe.icon_size = icon.icon_size
    recipe.icon_mipmaps = icon.icon_mipmaps
  end
  return recipe
end

local generated = {}
local generated_names = {}
local seen_items = {}
local convertible_items = {}

for item_name, item in pairs(FluxValuation.collect_convertible_items()) do
  if not seen_items[item_name] then
    seen_items[item_name] = true
    convertible_items[item_name] = item
  end
end

local resolved_values = FluxValuation.resolve_item_values(convertible_items)
local resolved_breakdowns = FluxValuation.resolve_item_color_amounts(convertible_items, resolved_values)
local resolved_metadata = FluxValuation._last_resolution_metadata or {}

for item_name, item in pairs(convertible_items) do
  local base_value = resolved_values[item_name] or FluxValuation.estimate_flux_value(item)
  local flux_breakdown = resolved_breakdowns[item_name]
  local metadata = resolved_metadata[item_name]
  if FluxValuation.is_confident_value(metadata) and item_is_complex_enough(item_name, item, base_value) then
    local clone_recipe = make_clone_recipe(item_name, item, base_value, flux_breakdown)
    table.insert(generated, clone_recipe)
    table.insert(generated_names, clone_recipe.name)
  end
end

data:extend(generated)

local tech = data.raw.technology and data.raw.technology["fw-flux-synthesis"]
if tech then
  tech.effects = tech.effects or {}
  table.insert(tech.effects, { type = "unlock-recipe", recipe = "fw-flux-condenser" })
  for _, recipe_name in pairs(generated_names) do
    table.insert(tech.effects, { type = "unlock-recipe", recipe = recipe_name })
  end
end
