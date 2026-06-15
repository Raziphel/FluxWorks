local FluxValuation = require("prototypes.lib.flux-valuation")

local function format_number(value)
  local text = tostring(math.floor((value or 0) + 0.5))
  local formatted = text
  repeat
    formatted, replacements = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
  until replacements == 0
  return formatted
end

local COLOR_ICONS = {
  purple = "[fluid=fw-purple-flux]",
  yellow = "[fluid=fw-yellow-flux]",
  red = "[fluid=fw-red-flux]",
  green = "[fluid=fw-green-flux]",
}

local function add_flux_value_to_item_tooltip(item, value, breakdown)
  local line = { "", "\n[color=210,210,210]" }
  local any = false
  for _, color in ipairs(FluxValuation.COLOR_ORDER) do
    local amount = breakdown and breakdown[color] or 0
    if amount and amount > 0 then
      any = true
      table.insert(line, COLOR_ICONS[color])
      table.insert(line, " ")
      table.insert(line, format_number(amount))
      table.insert(line, "  ")
    end
  end
  if not any then
    table.insert(line, COLOR_ICONS.purple)
    table.insert(line, " ")
    table.insert(line, format_number(value))
    table.insert(line, "  ")
  end
  table.insert(line, "Flux Value: ")
  table.insert(line, format_number(value))
  table.insert(line, "[/color]")
  if item.localised_description then
    item.localised_description = { "", item.localised_description, line }
  else
    item.localised_description = line
  end
end

local valued_items = FluxValuation.collect_valued_items()
local resolved_values = FluxValuation.resolve_item_values(valued_items)
local resolved_breakdowns = FluxValuation.resolve_item_color_amounts(valued_items, resolved_values)

for item_name, item in pairs(valued_items) do
  local value = resolved_values[item_name] or FluxValuation.estimate_flux_value(item)
  local breakdown = resolved_breakdowns[item_name]
  add_flux_value_to_item_tooltip(item, value, breakdown)
end
