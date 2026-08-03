local function entry_name(entry)
  return entry and (entry.name or entry[1])
end

local function find_entry(entries, expected_name)
  for _, entry in pairs(entries or {}) do
    if entry_name(entry) == expected_name then
      return entry
    end
  end
end

local unloading_bay = data.raw.recipe and data.raw.recipe["landing-pad-unloading-bay"]
if unloading_bay then
  local expected_ingredients = {
    "cargo-bay",
    "bulk-inserter",
    "electric-engine-unit",
    "fw-bearing",
    "fw-hydraulic-manifold",
    "fw-signal-conduit",
  }

  for _, ingredient_name in ipairs(expected_ingredients) do
    if not find_entry(unloading_bay.ingredients, ingredient_name) then
      error("Factorio 2.1 unloading bay must use " .. ingredient_name)
    end
  end

  for _, obsolete_name in ipairs({ "steel-chest", "processing-unit" }) do
    if find_entry(unloading_bay.ingredients, obsolete_name) then
      error("Factorio 2.1 unloading bay retained obsolete generic ingredient " .. obsolete_name)
    end
  end
end

-- Factorio 2.1 deliberately changed pistols to recycle into themselves. Keep
-- compatibility passes from restoring the old free iron-plate conversion.
local pistol_recycling = data.raw.recipe and data.raw.recipe["pistol-recycling"]
if pistol_recycling and not find_entry(pistol_recycling.results, "pistol") then
  error("Factorio 2.1 pistol recycling must return pistols, not component materials")
end
