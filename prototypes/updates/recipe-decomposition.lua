-- Keep Factorio's useful "Total raw" summary readable. FluxWorks has long,
-- intentionally interconnected component chains; recursively flattening those
-- chains turns ordinary recipe tooltips into a wall of fractional ores and
-- Flux materials. Recipes stop decomposing at the first FluxWorks integration
-- seam while ordinary vanilla-only chains keep their normal behaviour.

local function entry_name(entry)
  return entry and (entry.name or entry[1])
end

local function is_fluxworks_name(name)
  return type(name) == "string" and string.sub(name, 1, 3) == "fw-"
end

local function entries_touch_fluxworks(entries)
  for _, entry in pairs(entries or {}) do
    if is_fluxworks_name(entry_name(entry)) then
      return true
    end
  end
  return false
end

local function recipe_touches_fluxworks(recipe)
  if is_fluxworks_name(recipe.name) then
    return true
  end
  if entries_touch_fluxworks(recipe.ingredients) or entries_touch_fluxworks(recipe.results) then
    return true
  end
  if recipe.normal then
    return entries_touch_fluxworks(recipe.normal.ingredients)
      or entries_touch_fluxworks(recipe.normal.results)
  end
  return false
end

for _, recipe in pairs(data.raw.recipe or {}) do
  if recipe_touches_fluxworks(recipe) then
    recipe.allow_decomposition = false
    if recipe.normal then recipe.normal.allow_decomposition = false end
    if recipe.expensive then recipe.expensive.allow_decomposition = false end
  end
end

return recipe_touches_fluxworks
