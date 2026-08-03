local FluxValuation = require("prototypes.lib.flux-valuation")

local prefix = "fw-extract-flux-from-"
local metadata = FluxValuation._final_metadata or {}
local breakdowns = FluxValuation._final_breakdowns or {}
local runtime_data = data.raw["mod-data"] and data.raw["mod-data"]["fw-flux-extraction-values"]
if not runtime_data then error("Flux recovery safety failure: runtime valuation map is missing") end

for recipe_name in pairs(data.raw.recipe or {}) do
  if string.sub(recipe_name, 1, #prefix) == prefix then
    error("Flux recovery safety failure: obsolete generated recipe remains: " .. recipe_name)
  end
end

local dominant_counts = { purple = 0, yellow = 0, red = 0, green = 0 }
local item_count = 0
for item_name, quality_values in pairs(runtime_data.data or {}) do
  item_count = item_count + 1
  if not FluxValuation.is_confident_value(metadata[item_name]) then
    error("Flux recovery safety failure: runtime map contains uncertain item " .. item_name)
  end
  if not quality_values.normal then
    error("Flux recovery safety failure: runtime map lacks normal quality for " .. item_name)
  end

  local dominant_color
  local dominant_value = -1
  for _, color in ipairs(FluxValuation.COLOR_ORDER) do
    local amount = quality_values.normal[color] or 0
    if amount < 0 or amount > FluxValuation.MAX_EXTRACTION_FLUID_PER_COLOR then
      error("Flux recovery safety failure: invalid " .. color .. " amount for " .. item_name)
    end
    if (breakdowns[item_name][color] or 0) > dominant_value then
      dominant_value = breakdowns[item_name][color] or 0
      dominant_color = color
    end
  end
  dominant_counts[dominant_color] = dominant_counts[dominant_color] + 1
end

for color, count in pairs(dominant_counts) do
  if count < 5 then
    error("Flux spectrum identity failure: " .. color .. " is dominant for only " .. count .. " trusted recoveries")
  end
end

log(("FluxWorks universal recovery: %d item types; dominance purple=%d yellow=%d red=%d green=%d")
  :format(item_count, dominant_counts.purple, dominant_counts.yellow, dominant_counts.red, dominant_counts.green))
