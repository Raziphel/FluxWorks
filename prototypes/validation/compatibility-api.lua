local Compatibility = require("prototypes.lib.compatibility-api")

local ITEM_TYPES = {
  "item", "ammo", "capsule", "gun", "module", "armor", "tool",
  "repair-tool", "item-with-entity-data", "item-with-label", "item-with-tags",
  "rail-planner",
}

local function item_exists(item_name)
  for _, item_type in ipairs(ITEM_TYPES) do
    if data.raw[item_type] and data.raw[item_type][item_name] then return true end
  end
  return false
end

local unresolved = {}
local function count_entries(entries)
  local count = 0
  for _, _ in pairs(entries) do count = count + 1 end
  return count
end

local function check_item_targets(registry, label)
  for item_name, _ in pairs(registry) do
    if not item_exists(item_name) then
      unresolved[#unresolved + 1] = label .. ":" .. item_name
    end
  end
end

check_item_targets(Compatibility.item_values, "item-value")
check_item_targets(Compatibility.item_value_locks, "item-lock")
check_item_targets(Compatibility.item_spectra, "item-spectrum")
check_item_targets(Compatibility.item_quality_multipliers, "item-quality")
check_item_targets(Compatibility.item_quality_exclusions, "item-quality-exclusion")
check_item_targets(Compatibility.recovery_exclusions, "recovery-exclusion")

for fluid_name, _ in pairs(Compatibility.fluid_values) do
  if not (data.raw.fluid and data.raw.fluid[fluid_name]) then
    unresolved[#unresolved + 1] = "fluid-value:" .. fluid_name
  end
end
for fluid_name, _ in pairs(Compatibility.fluid_spectra) do
  if not (data.raw.fluid and data.raw.fluid[fluid_name]) then
    unresolved[#unresolved + 1] = "fluid-spectrum:" .. fluid_name
  end
end
for quality_name, _ in pairs(Compatibility.quality_multipliers) do
  if not (data.raw.quality and data.raw.quality[quality_name]) then
    unresolved[#unresolved + 1] = "quality:" .. quality_name
  end
end
for quality_name, _ in pairs(Compatibility.quality_exclusions) do
  if not (data.raw.quality and data.raw.quality[quality_name]) then
    unresolved[#unresolved + 1] = "quality-exclusion:" .. quality_name
  end
end
for item_name, qualities in pairs(Compatibility.item_quality_multipliers) do
  for quality_name, _ in pairs(qualities) do
    if not (data.raw.quality and data.raw.quality[quality_name]) then
      unresolved[#unresolved + 1] = "item-quality:" .. item_name .. ":" .. quality_name
    end
  end
end
for item_name, qualities in pairs(Compatibility.item_quality_exclusions) do
  for quality_name, _ in pairs(qualities) do
    if not (data.raw.quality and data.raw.quality[quality_name]) then
      unresolved[#unresolved + 1] =
        "item-quality-exclusion:" .. item_name .. ":" .. quality_name
    end
  end
end
for recipe_name, registration in pairs(Compatibility.recipe_parts) do
  if not (data.raw.recipe and data.raw.recipe[recipe_name]) then
    unresolved[#unresolved + 1] = "recipe:" .. recipe_name
  end
  if not item_exists(registration.part) then
    unresolved[#unresolved + 1] = "recipe-part:" .. registration.part
  end
end
for _, family in ipairs(Compatibility.recipe_families) do
  if not item_exists(family.part) then
    unresolved[#unresolved + 1] = "recipe-family-part:" .. family.name .. ":" .. family.part
  end
end

if #unresolved > 0 then
  table.sort(unresolved)
  log("FluxWorks compatibility API: unresolved optional targets: " .. table.concat(unresolved, ", "))
end

log(
  ("FluxWorks compatibility API: %d families, %d explicit recipes, %d unresolved targets")
    :format(
      #Compatibility.recipe_families,
      count_entries(Compatibility.recipe_parts),
      #unresolved
    )
)
