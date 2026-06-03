local FluxValuation = require("prototypes.lib.flux-valuation")

local function format_number(value)
  local text = tostring(math.floor((value or 0) + 0.5))
  local formatted = text
  repeat
    formatted, replacements = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
  until replacements == 0
  return formatted
end

local function add_flux_value_to_item_tooltip(item, value)
  local line = { "", "\n[color=170,120,255][fluid=fw-purple-flux] Flux Value: ", format_number(value), " (normal quality)[/color]" }
  local quality_lines = {}
  for _, quality in pairs(FluxValuation.sorted_qualities(false)) do
    table.insert(quality_lines, "[quality=" .. quality.name .. "] " .. format_number(FluxValuation.value_for_quality(value, quality)))
  end
  if #quality_lines > 0 then
    line = { "", line, "\n[color=170,120,255]Quality: ", table.concat(quality_lines, "  "), "[/color]" }
  end
  if item.localised_description then
    item.localised_description = { "", item.localised_description, line }
  else
    item.localised_description = line
  end
end

local valued_items = FluxValuation.collect_valued_items()
local resolved_values = FluxValuation.resolve_item_values(valued_items)

for item_name, item in pairs(valued_items) do
  local value = resolved_values[item_name] or FluxValuation.estimate_flux_value(item)
  add_flux_value_to_item_tooltip(item, value)
end
