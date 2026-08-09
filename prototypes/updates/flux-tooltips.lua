local FluxValuation = require("prototypes.lib.flux-valuation")

local function format_number(value)
  local rounded = math.floor(((value or 0) * 10) + 0.5) / 10
  local text = rounded < 10 and tostring(rounded) or tostring(math.floor(rounded + 0.5))
  local formatted = text
  repeat
    formatted, replacements = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
  until replacements == 0
  return formatted
end

-- Recipe integration passes may reapply the internal condensing category after the dynamic
-- extractor recipes are created. Keep authored assembly in the Synthesis Plant.
for recipe_name, recipe in pairs(data.raw.recipe or {}) do
  if recipe.category == "fw-flux-condensing" and recipe_name ~= "fw-flux-condenser" then
    recipe.category = "fw-flux-synthesis"
  end
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

local function localised_string_near_engine_limit(value)
  if type(value) ~= "table" then return false end
  if #value >= 180 then return true end
  for _, child in pairs(value) do
    if localised_string_near_engine_limit(child) then return true end
  end
  return false
end

local function append_tooltip(item, line)
  -- Factorio caps a LocalisedString at 200 parameters. Some quality mods build
  -- descriptions close to that ceiling, so nesting them inside another tooltip
  -- makes an otherwise valid item fail prototype validation.
  if localised_string_near_engine_limit(item.localised_description) then return end
  if item.localised_description then
    item.localised_description = { "", item.localised_description, line }
  else
    item.localised_description = line
  end
end

local function add_flux_value_to_item_tooltip(item, value, breakdown, metadata)
  local confidence = metadata and metadata.confidence or FluxValuation.VALUE_CONFIDENCE.unknown
  local prefix = "\n[color=180,220,255]Recoverable Flux: [/color][color=210,210,210]"
  local line = { "", prefix }
  local required_amounts = FluxValuation.extraction_amounts(value, breakdown, metadata)

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
  local quality_parts = {}
  for _, quality in ipairs(FluxValuation.sorted_qualities(false)) do
    quality_parts[#quality_parts + 1] = "[quality=" .. quality.name .. "] "
      .. format_number(FluxValuation.quality_value_multiplier(quality, item.name))
      .. "x"
  end
  if #quality_parts > 0 then
    table.insert(
      line,
      "\n[color=180,220,255]Quality recovery: [/color]" .. table.concat(quality_parts, "  ")
    )
  end
  append_tooltip(item, line)
end

local function add_flux_status_to_item_tooltip(item, metadata)
  local confidence = metadata and metadata.confidence or FluxValuation.VALUE_CONFIDENCE.unknown
  local label = CONFIDENCE_LABELS[confidence] or "Unknown"
  local line

  if confidence == FluxValuation.VALUE_CONFIDENCE.unknown then
    line = {
      "",
      "\n[color=255,190,120]Flux valuation: Unknown[/color] ",
      "[color=200,200,200](extraction disabled until compatibility data provides a trustworthy value)[/color]",
    }
  elseif confidence == FluxValuation.VALUE_CONFIDENCE.inferred then
    line = {
      "",
      "\n[color=255,220,150]Flux valuation: ",
      label,
      "[/color] [color=200,200,200](extraction disabled; the available recipe path is ambiguous)[/color]",
    }
  else
    line = {
      "",
      "\n[color=180,220,255]Flux valuation: ",
      label,
      "[/color]",
    }
  end

  append_tooltip(item, line)
end

local valued_items = FluxValuation.collect_valued_items()
local resolved_values = FluxValuation._final_values or {}
local recoverable_values = FluxValuation._final_recoverable_values or {}
local resolved_metadata = FluxValuation._final_metadata or {}
local resolved_breakdowns = FluxValuation._final_breakdowns or {}

for item_name, item in pairs(valued_items) do
  local value = resolved_values[item_name] or FluxValuation.estimate_flux_value(item)
  local breakdown = resolved_breakdowns[item_name] or FluxValuation.simple_item_breakdown(item, resolved_values)
  local metadata = resolved_metadata[item_name]
  if FluxValuation.is_confident_value(metadata) then
    add_flux_value_to_item_tooltip(item, recoverable_values[item_name] or value, breakdown, metadata)
  end
  add_flux_status_to_item_tooltip(item, metadata)
end
