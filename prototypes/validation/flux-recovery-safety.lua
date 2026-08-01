local FluxValuation = require("prototypes.lib.flux-valuation")

local prefix = "fw-extract-flux-from-"
local metadata = FluxValuation._final_metadata or {}
local values = FluxValuation._final_recoverable_values or {}
local breakdowns = FluxValuation._final_breakdowns or {}
local dominant_counts = { purple = 0, yellow = 0, red = 0, green = 0 }
local quality_recipe_counts = { normal = 0 }
local expected_quality_recipe_counts = { normal = 0 }
for _, quality in ipairs(FluxValuation.sorted_qualities(false)) do
  quality_recipe_counts[quality.name] = 0
  expected_quality_recipe_counts[quality.name] = 0
end
for item_name, _ in pairs(breakdowns) do
  local item_metadata = metadata[item_name]
  if FluxValuation.is_confident_value(item_metadata) then
    expected_quality_recipe_counts.normal = expected_quality_recipe_counts.normal + 1
    for _, quality in ipairs(FluxValuation.sorted_qualities(false)) do
      if FluxValuation.is_quality_recoverable(quality, item_name) then
        expected_quality_recipe_counts[quality.name] =
          expected_quality_recipe_counts[quality.name] + 1
      end
    end
  end
end

for recipe_name, recipe in pairs(data.raw.recipe or {}) do
  if string.sub(recipe_name, 1, #prefix) == prefix then
    local ingredient = recipe.ingredients and recipe.ingredients[1]
    local item_name = ingredient and (ingredient.name or ingredient[1])
    local quality = ingredient
      and ingredient.quality
      and data.raw.quality
      and data.raw.quality[ingredient.quality]
      or nil
    local quality_name = quality and quality.name or "normal"
    quality_recipe_counts[quality_name] = (quality_recipe_counts[quality_name] or 0) + 1
    if not item_name then
      error("Flux recovery safety failure: " .. recipe_name .. " has no source item")
    end
    if not FluxValuation.is_confident_value(metadata[item_name]) then
      error(
        "Flux recovery safety failure: "
          .. recipe_name
          .. " was generated from an inferred or unknown valuation"
      )
    end
    if recipe.allow_productivity ~= false or recipe.allow_quality ~= false then
      error(
        "Flux recovery safety failure: "
          .. recipe_name
          .. " permits productivity or quality multiplication"
      )
    end

    local amounts, recovered_budget = FluxValuation.extraction_amounts(
      FluxValuation.value_for_quality(values[item_name], quality, item_name),
      breakdowns[item_name],
      metadata[item_name]
    )
    local returned_value = 0
    local capped = false
    local dominant_color
    local dominant_value = -1
    for _, color in ipairs(FluxValuation.COLOR_ORDER) do
      returned_value = returned_value
        + ((amounts[color] or 0) * (FluxValuation.flux_unit_value(color) or 1))
      capped = capped or (amounts[color] or 0) >= FluxValuation.MAX_EXTRACTION_FLUID_PER_COLOR
      if (breakdowns[item_name][color] or 0) > dominant_value then
        dominant_value = breakdowns[item_name][color] or 0
        dominant_color = color
      end
    end
    if returned_value > recovered_budget * 1.001 then
      error("Flux recovery safety failure: " .. recipe_name .. " creates spectrum value")
    end
    if not capped and math.abs(returned_value - recovered_budget) > 0.02 then
      error("Flux recovery safety failure: " .. recipe_name .. " loses spectrum value")
    end
    dominant_counts[dominant_color] = dominant_counts[dominant_color] + 1
  end
end

for quality_name, count in pairs(quality_recipe_counts) do
  local expected = expected_quality_recipe_counts[quality_name] or 0
  if count ~= expected then
    error(
      ("Flux quality recovery failure: %s has %d recipes, expected %d")
        :format(quality_name, count, expected)
    )
  end
end

for color, count in pairs(dominant_counts) do
  if count < 5 then
    error(
      "Flux spectrum identity failure: "
        .. color
        .. " is dominant for only "
        .. count
        .. " trusted recoveries"
    )
  end
end

log(
  ("FluxWorks trusted recovery dominance: purple=%d yellow=%d red=%d green=%d")
    :format(
      dominant_counts.purple,
      dominant_counts.yellow,
      dominant_counts.red,
      dominant_counts.green
    )
)
