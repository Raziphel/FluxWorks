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

local CONFIDENCE_LABELS = {
  locked = "Locked",
  anchored = "Anchored",
  derived = "Derived",
  inferred = "Estimated",
  unknown = "Unknown",
}

local function clone_flux_markup(value)
  if value <= 8 then
    return 1.25
  end
  if value <= 24 then
    return 1.40
  end
  if value <= 60 then
    return 1.60
  end
  return 1.85
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

local function normalized_clone_breakdown(breakdown)
  local normalized = {}
  local total = 0

  for _, color in ipairs(FluxValuation.COLOR_ORDER) do
    local amount = math.max(0, (breakdown and breakdown[color]) or 0)
    normalized[color] = amount
    total = total + amount
  end

  if total <= 0 then
    for _, color in ipairs(FluxValuation.COLOR_ORDER) do
      normalized[color] = 1
    end
    return normalized, #FluxValuation.COLOR_ORDER
  end

  for _, color in ipairs(FluxValuation.COLOR_ORDER) do
    normalized[color] = normalized[color] + 1
    total = total + 1
  end

  return normalized, total
end

local function condenser_flux_amounts(value, breakdown)
  local required_flux = math.max(1, math.floor((value * clone_flux_markup(value)) + 0.5))
  local normalized, total = normalized_clone_breakdown(breakdown)
  local scaled = {}

  for _, color in ipairs(FluxValuation.COLOR_ORDER) do
    scaled[color] = ((normalized[color] or 0) / total) * required_flux
  end

  return round_breakdown_to_total(scaled, required_flux)
end

local function add_flux_value_to_item_tooltip(item, value, breakdown)
  local line = { "", "\n[color=210,210,210]" }
  local required_amounts = condenser_flux_amounts(value, breakdown)

  for _, color in ipairs(FluxValuation.COLOR_ORDER) do
    local amount = required_amounts[color] or 0
    if amount and amount > 0 then
      table.insert(line, COLOR_ICONS[color])
      table.insert(line, " ")
      table.insert(line, format_number(amount))
      table.insert(line, "  ")
    end
  end
  table.insert(line, "[/color]")
  if item.localised_description then
    item.localised_description = { "", item.localised_description, line }
  else
    item.localised_description = line
  end
end

local function add_flux_status_to_item_tooltip(item, metadata)
  local confidence = metadata and metadata.confidence or FluxValuation.VALUE_CONFIDENCE.unknown
  local label = CONFIDENCE_LABELS[confidence] or "Unknown"
  local line

  if confidence == FluxValuation.VALUE_CONFIDENCE.unknown then
    line = {
      "",
      "\n[color=255,190,120]Flux valuation: Unknown[/color] ",
      "[color=200,200,200](needs a compatibility pass before clone costs are trusted)[/color]",
    }
  elseif confidence == FluxValuation.VALUE_CONFIDENCE.inferred then
    line = {
      "",
      "\n[color=255,220,150]Flux valuation: ",
      label,
      "[/color] [color=200,200,200](using a partial or messy recipe path; review if this looks off)[/color]",
    }
  else
    line = {
      "",
      "\n[color=180,220,255]Flux valuation: ",
      label,
      "[/color]",
    }
  end

  if item.localised_description then
    item.localised_description = { "", item.localised_description, line }
  else
    item.localised_description = line
  end
end

local valued_items = FluxValuation.collect_valued_items()
local resolved_values = FluxValuation.resolve_item_values(valued_items)
local resolved_breakdowns = FluxValuation.resolve_item_color_amounts(valued_items, resolved_values)
local resolved_metadata = FluxValuation._last_resolution_metadata or {}

for item_name, item in pairs(valued_items) do
  local value = resolved_values[item_name] or FluxValuation.estimate_flux_value(item)
  local breakdown = resolved_breakdowns[item_name]
  local metadata = resolved_metadata[item_name]
  if metadata and metadata.confidence ~= FluxValuation.VALUE_CONFIDENCE.unknown then
    add_flux_value_to_item_tooltip(item, value, breakdown)
  end
  add_flux_status_to_item_tooltip(item, metadata)
end
