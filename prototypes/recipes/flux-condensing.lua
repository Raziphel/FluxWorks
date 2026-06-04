local FluxValuation = require("prototypes.lib.flux-valuation")

local function clone_flux_markup(value)
  if value <= 8 then
    return 1.10
  end
  if value <= 24 then
    return 1.20
  end
  if value <= 60 then
    return 1.35
  end
  return 1.55
end

local function clone_fallback_time(value)
  if value <= 8 then
    return 0.8
  end
  if value <= 24 then
    return 1.6
  end
  if value <= 60 then
    return 2.8
  end
  return 4.2
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

local function quality_suffix(quality)
  if not quality or quality.name == "normal" then
    return ""
  end
  return "-" .. quality.name
end

local function quality_order(quality)
  if not quality or quality.name == "normal" then
    return "a[normal]"
  end
  return "b[" .. (quality.order or quality.name) .. "]"
end

local function quality_item_tag(item_name, quality)
  if not quality or quality.name == "normal" then
    return "[item=" .. item_name .. "]"
  end
  return "[item=" .. item_name .. ",quality=" .. quality.name .. "]"
end

local function quality_recipe_name(item_name, quality)
  return "fw-exchange-from-flux" .. quality_suffix(quality) .. "-" .. item_name
end

local function make_clone_recipe(item_name, item, flux_value, quality)
  local energy = ((item.subgroup ~= "raw-resource" and original_recipe_time(item_name)) or clone_fallback_time(flux_value)) * 5
  local required_flux = math.max(1, math.floor((flux_value * clone_flux_markup(flux_value)) + 0.5))
  local ingredients = {
    { type = "fluid", name = "fw-purple-flux", amount = required_flux },
    { type = "item", name = item_name, amount = 1 },
  }
  local results = {
    { type = "item", name = item_name, amount = 2 },
  }

  if quality and quality.name ~= "normal" then
    ingredients[2].quality = quality.name
    results[1].quality = quality.name
  end

  local recipe = {
    type = "recipe",
    name = quality_recipe_name(item_name, quality),
    category = "fw-flux-condensing",
    subgroup = "fw-flux-exchange",
    order = "z-a[" .. item_name .. "]-" .. quality_order(quality),
    enabled = false,
    hidden = false,
    hide_from_player_crafting = true,
    hide_from_stats = false,
    hide_from_signal_gui = true,
    hidden_in_factoriopedia = false,
    allow_productivity = false,
    allow_quality = false,
    energy_required = energy,
    localised_name = { "", quality_item_tag(item_name, quality), " + [fluid=fw-purple-flux] -> ", quality_item_tag(item_name, quality), " ", { "item-name." .. item_name } },
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

for item_name, item in pairs(convertible_items) do
  local base_value = resolved_values[item_name] or FluxValuation.estimate_flux_value(item)
  local clone_recipe = make_clone_recipe(item_name, item, base_value)
  table.insert(generated, clone_recipe)
  table.insert(generated_names, clone_recipe.name)

  for _, quality in pairs(FluxValuation.sorted_qualities(false)) do
    local quality_value = FluxValuation.value_for_quality(base_value, quality)
    local quality_clone_recipe = make_clone_recipe(item_name, item, quality_value, quality)
    table.insert(generated, quality_clone_recipe)
    table.insert(generated_names, quality_clone_recipe.name)
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
