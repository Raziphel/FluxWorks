local FluxValuation = require("prototypes.lib.flux-valuation")

local FLUX_COLOR_TO_FLUID = {
  purple = "fw-purple-flux",
  yellow = "fw-yellow-flux",
  red = "fw-red-flux",
  green = "fw-green-flux",
}

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
local qualities = FluxValuation.sorted_qualities(false)
local runtime_values = {}
for item_name, item in pairs(trusted_items) do
  local metadata = resolved_metadata[item_name]
  if FluxValuation.is_confident_value(metadata) then
    local value = recoverable_values[item_name] or resolved_values[item_name]
    local breakdown = resolved_breakdowns[item_name]
      or FluxValuation.simple_item_breakdown(item, resolved_values)
    local by_quality = {}
    local function record(quality_name, quality)
      local amounts = FluxValuation.extraction_amounts(
        FluxValuation.value_for_quality(value, quality, item_name),
        breakdown,
        metadata
      )
      by_quality[quality_name] = {
        purple = amounts.purple or 0,
        yellow = amounts.yellow or 0,
        red = amounts.red or 0,
        green = amounts.green or 0,
      }
    end
    record("normal")
    for _, quality in ipairs(qualities) do
      if FluxValuation.is_quality_recoverable(quality, item_name) then
        record(quality.name, quality)
      end
    end
    runtime_values[item_name] = by_quality
  end
end

data:extend({ {
  type = "mod-data",
  name = "fw-flux-extraction-values",
  data_type = "fluxworks.flux-extraction-values",
  data = runtime_values,
} })

log(("FluxWorks universal extraction: exported %d valued item types without generated recipes")
  :format(table_size(runtime_values)))
