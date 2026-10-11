-- K2SO intentionally replaces several original Space Age materials with its
-- kr- variants. Reconcile FluxWorks-owned recipes after all data-stage edits,
-- including recipes created by late FluxWorks generation.
if not mods["Krastorio2-spaced-out"] then return end

local aliases = {
  oxygen = "kr-oxygen",
  hydrogen = "kr-hydrogen",
  chlorine = "kr-chlorine",
  sand = "kr-sand",
  glass = "kr-glass",
  silicon = "kr-silicon",
  lithium = "kr-lithium",
  ammonia = "kr-ammonia",
}

local function compatible_name(name, prototype_type)
  local alternate = aliases[name]
  if alternate and data.raw[prototype_type] and data.raw[prototype_type][alternate] then
    return alternate
  end
  return name
end

local function normalize(entries)
  for _, entry in ipairs(entries or {}) do
    local original = entry.name or entry[1]
    local kind = entry.type == "fluid" and "fluid" or "item"
    local replacement = compatible_name(original, kind)
    if replacement ~= original then
      entry.name = replacement
      entry[1] = nil
    end
  end
end

for recipe_name, recipe in pairs(data.raw.recipe or {}) do
  if recipe_name:sub(1, 3) == "fw-" then
    normalize(recipe.ingredients)
    normalize(recipe.results)
    if recipe.normal then
      normalize(recipe.normal.ingredients)
      normalize(recipe.normal.results)
    end
    if recipe.expensive then
      normalize(recipe.expensive.ingredients)
      normalize(recipe.expensive.results)
    end
    if recipe.main_product then
      recipe.main_product = compatible_name(recipe.main_product, "item")
    end
  end
end

-- The early sand/glass trigger technologies are still FluxWorks-owned but
-- K2SO's finished items have changed identity.
for tech_name, technology in pairs(data.raw.technology or {}) do
  if tech_name:sub(1, 3) == "fw-"
    or tech_name == "sand-processing" or tech_name == "glass-processing" then
    local trigger = technology.research_trigger
    if trigger and trigger.type == "craft-item" and trigger.item then
      trigger.item = compatible_name(trigger.item, "item")
    end
  end
end
