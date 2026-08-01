local FluxValuation = require("prototypes.lib.flux-valuation")

local FLUX_COLOR_TO_FLUID = {
  purple = "fw-purple-flux",
  yellow = "fw-yellow-flux",
  red = "fw-red-flux",
  green = "fw-green-flux",
}

local function recipe_icon_from_item(item)
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

local function extraction_time(value)
  return math.min(30, math.max(1, 1.5 + (math.sqrt(math.max(1, value)) * 0.55)))
end

local function make_extraction_recipe(item_name, item, value, breakdown, metadata, quality)
  local quality_name = quality and quality.name
  local quality_value = FluxValuation.value_for_quality(value, quality, item_name)
  local amounts = FluxValuation.extraction_amounts(quality_value, breakdown, metadata)
  local results = {}
  local tags = {}

  for _, color in ipairs(FluxValuation.COLOR_ORDER) do
    local amount = amounts[color] or 0
    if amount > 0 then
      results[#results + 1] = {
        type = "fluid",
        name = FLUX_COLOR_TO_FLUID[color],
        amount = amount,
      }
      tags[#tags + 1] = "[fluid=" .. FLUX_COLOR_TO_FLUID[color] .. "]"
    end
  end

  local recipe_name = "fw-extract-flux-from-" .. item_name
  if quality_name and quality_name ~= "normal" then
    recipe_name = recipe_name .. "-quality-" .. quality_name
  end

  local ingredient = { type = "item", name = item_name, amount = 1 }
  if quality_name and quality_name ~= "normal" then
    ingredient.quality = quality_name
  end

  local quality_label = ""
  if quality_name and quality_name ~= "normal" then
    quality_label = { "", "[quality=" .. quality_name .. "] ", quality.localised_name or quality_name, " " }
  end

  local recipe = {
    type = "recipe",
    name = recipe_name,
    category = "fw-flux-extraction",
    subgroup = "fw-flux-exchange",
    order = "z-e[" .. item_name .. "]-[" .. (quality_name or "normal") .. "]",
    enabled = false,
    hidden = false,
    hide_from_player_crafting = true,
    hide_from_stats = false,
    hide_from_signal_gui = true,
    hidden_in_factoriopedia = false,
    allow_productivity = false,
    allow_quality = false,
    allow_decomposition = false,
    energy_required = extraction_time(value),
    localised_name = {
      "",
      quality_label,
      "[item=" .. item_name .. "] ",
      { "item-name." .. item_name },
      " -> ",
      table.concat(tags),
    },
    ingredients = {
      ingredient,
    },
    results = results,
  }

  local icon = recipe_icon_from_item(item)
  if icon then
    recipe.icons = icon.icons
    recipe.icon = icon.icon
    recipe.icon_size = icon.icon_size
    recipe.icon_mipmaps = icon.icon_mipmaps
  end
  return recipe
end

-- The old category contained both dynamic matter creation and hand-authored endgame
-- assembly. Move those authored recipes to the Synthesis Plant before turning
-- the old machine into a dedicated, one-way extractor.
for recipe_name, recipe in pairs(data.raw.recipe or {}) do
  if recipe.category == "fw-flux-condensing" and recipe_name ~= "fw-flux-condenser" then
    recipe.category = "fw-flux-synthesis"
  end
end

local extractable_items = FluxValuation.collect_extractable_items()
log("FluxWorks valuation: resolving final item values")
local resolved_values = FluxValuation.resolve_item_values(extractable_items)
log("FluxWorks valuation: resolving recoverable material floors")
local recoverable_values = FluxValuation.resolve_recoverable_values(extractable_items, resolved_values)
local resolved_metadata = FluxValuation._last_resolution_metadata or {}
local trusted_items = {}
for item_name, item in pairs(extractable_items) do
  if FluxValuation.is_confident_value(resolved_metadata[item_name]) then
    trusted_items[item_name] = item
  end
end
log("FluxWorks valuation: resolving Flux spectrum breakdowns")
local resolved_breakdowns = FluxValuation.resolve_item_color_amounts(trusted_items, resolved_values)
FluxValuation._final_values = resolved_values
FluxValuation._final_recoverable_values = recoverable_values
FluxValuation._final_breakdowns = resolved_breakdowns
FluxValuation._final_metadata = resolved_metadata
local generated = {}
local generated_names = {}
local qualities = FluxValuation.sorted_qualities(false)

for item_name, item in pairs(trusted_items) do
  local metadata = resolved_metadata[item_name]
  if FluxValuation.is_confident_value(metadata) then
    local value = recoverable_values[item_name] or resolved_values[item_name]
    local breakdown = resolved_breakdowns[item_name]
      or FluxValuation.simple_item_breakdown(item, resolved_values)
    local normal_recipe = make_extraction_recipe(item_name, item, value, breakdown, metadata)
    generated[#generated + 1] = normal_recipe
    generated_names[#generated_names + 1] = normal_recipe.name

    for _, quality in ipairs(qualities) do
      if FluxValuation.is_quality_recoverable(quality, item_name) then
        local recipe = make_extraction_recipe(item_name, item, value, breakdown, metadata, quality)
        generated[#generated + 1] = recipe
        generated_names[#generated_names + 1] = recipe.name
      end
    end
  end
end

data:extend(generated)
log(
  ("FluxWorks quality recovery: generated %d recipes across %d quality tiers")
    :format(#generated, #qualities + 1)
)

local technology = data.raw.technology and data.raw.technology["fw-flux-synthesis"]
if technology then
  technology.effects = technology.effects or {}
  for _, recipe_name in ipairs(generated_names) do
    technology.effects[#technology.effects + 1] = {
      type = "unlock-recipe",
      recipe = recipe_name,
    }
  end
end
