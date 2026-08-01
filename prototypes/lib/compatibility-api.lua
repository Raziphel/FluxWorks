-- Public data-stage API for mods that want deterministic FluxWorks integration.
--
-- Usage from a dependent mod:
--   local fluxworks = require("__FluxWorks__/prototypes/lib/compatibility-api")
--   fluxworks.register_item_value("my-alloy", 240, { locked = true })
--   fluxworks.register_item_spectrum("my-alloy", { purple = 0.7, yellow = 0.3 })
--
-- Registrations are consumed during FluxWorks' data-final-fixes pass.
local existing = rawget(_G, "fluxworks_compatibility_api")
if existing then return existing end

local M = {
  item_values = {},
  item_value_locks = {},
  item_spectra = {},
  item_quality_multipliers = {},
  item_quality_exclusions = {},
  fluid_values = {},
  fluid_spectra = {},
  quality_multipliers = {},
  quality_exclusions = {},
  recovery_exclusions = {},
  recipe_exclusions = {},
  recipe_families = {},
  recipe_parts = {},
}
rawset(_G, "fluxworks_compatibility_api", M)

local FLUX_KEYS = {
  purple = "purple", matter = "purple",
  yellow = "yellow", chemical = "yellow",
  red = "red", fuel = "red",
  green = "green", bio = "green",
}
local MAX_QUALITY_MULTIPLIER = 8
local recipe_family_index = {}

-- Public names make integrations read like the in-game terminology. Compact
-- color aliases are also accepted when a table benefits from shorter keys.
M.flux = {
  matter = "matter",
  chemical = "chemical",
  fuel = "fuel",
  bio = "bio",
}

local function require_name(value, label)
  if type(value) ~= "string" or value == "" then
    error("FluxWorks compatibility API: " .. label .. " must be a non-empty string")
  end
end

local function require_positive_number(value, label)
  if type(value) ~= "number" or value <= 0 then
    error("FluxWorks compatibility API: " .. label .. " must be a positive number")
  end
end

local function copy_spectrum(spectrum)
  if type(spectrum) ~= "table" then
    error("FluxWorks compatibility API: spectrum must be a table")
  end
  local copy = {}
  local total = 0
  for flux_name, share in pairs(spectrum) do
    local color = FLUX_KEYS[string.lower(tostring(flux_name))]
    if not color then
      error(
        "FluxWorks compatibility API: unknown Flux kind " .. tostring(flux_name)
          .. " (use matter, chemical, fuel, or bio)"
      )
    end
    if type(share) ~= "number" or share < 0 then
      error("FluxWorks compatibility API: spectrum shares must be non-negative numbers")
    end
    copy[color] = (copy[color] or 0) + share
    total = total + share
  end
  if total <= 0 then
    error("FluxWorks compatibility API: spectrum must contain a positive share")
  end
  return copy
end

function M.register_item_value(item_name, value, options)
  require_name(item_name, "item name")
  require_positive_number(value, "item value")
  options = options or {}
  if options.locked then
    M.item_value_locks[item_name] = value
    M.item_values[item_name] = nil
  else
    M.item_values[item_name] = value
  end
end

function M.register_item_spectrum(item_name, spectrum)
  require_name(item_name, "item name")
  M.item_spectra[item_name] = copy_spectrum(spectrum)
end

function M.register_item_quality_multiplier(item_name, quality_name, multiplier)
  require_name(item_name, "item name")
  require_name(quality_name, "quality name")
  require_positive_number(multiplier, "item quality multiplier")
  if multiplier > MAX_QUALITY_MULTIPLIER then
    error("FluxWorks compatibility API: item quality multiplier cannot exceed 8")
  end
  M.item_quality_multipliers[item_name] = M.item_quality_multipliers[item_name] or {}
  M.item_quality_multipliers[item_name][quality_name] = multiplier
end

function M.exclude_item_quality(item_name, quality_name)
  require_name(item_name, "item name")
  require_name(quality_name, "quality name")
  if quality_name == "normal" then
    error("FluxWorks compatibility API: exclude the item from recovery instead of excluding normal quality")
  end
  M.item_quality_exclusions[item_name] = M.item_quality_exclusions[item_name] or {}
  M.item_quality_exclusions[item_name][quality_name] = true
end

function M.register_fluid_value(fluid_name, value)
  require_name(fluid_name, "fluid name")
  require_positive_number(value, "fluid value")
  M.fluid_values[fluid_name] = value
end

function M.register_fluid_spectrum(fluid_name, spectrum)
  require_name(fluid_name, "fluid name")
  M.fluid_spectra[fluid_name] = copy_spectrum(spectrum)
end

function M.register_fluid(definition)
  if type(definition) ~= "table" then
    error("FluxWorks compatibility API: fluid definition must be a table")
  end
  require_name(definition.name, "fluid definition name")
  if definition.value ~= nil then
    M.register_fluid_value(definition.name, definition.value)
  end
  if definition.spectrum ~= nil then
    M.register_fluid_spectrum(definition.name, definition.spectrum)
  end
end

function M.register_fluids(definitions)
  if type(definitions) ~= "table" then
    error("FluxWorks compatibility API: fluid definitions must be a table")
  end
  for _, definition in ipairs(definitions) do M.register_fluid(definition) end
end

function M.register_quality_multiplier(quality_name, multiplier)
  require_name(quality_name, "quality name")
  require_positive_number(multiplier, "quality multiplier")
  if multiplier > MAX_QUALITY_MULTIPLIER then
    error("FluxWorks compatibility API: quality multiplier cannot exceed 8")
  end
  M.quality_multipliers[quality_name] = multiplier
end

function M.exclude_quality_from_recovery(quality_name)
  require_name(quality_name, "quality name")
  if quality_name == "normal" then
    error("FluxWorks compatibility API: normal quality cannot be globally excluded")
  end
  M.quality_exclusions[quality_name] = true
end

function M.exclude_from_recovery(item_name)
  require_name(item_name, "item name")
  M.recovery_exclusions[item_name] = true
end

function M.exclude_recipe(recipe_name)
  require_name(recipe_name, "recipe name")
  M.recipe_exclusions[recipe_name] = true
end

function M.register_recipe_family(definition)
  if type(definition) ~= "table" then
    error("FluxWorks compatibility API: recipe family must be a table")
  end
  require_name(definition.name, "recipe family name")
  require_name(definition.part, "recipe family part")
  if definition.ingredient_amount ~= nil then
    require_positive_number(definition.ingredient_amount, "recipe family ingredient amount")
  end
  if definition.min_ingredients ~= nil then
    require_positive_number(definition.min_ingredients, "recipe family minimum ingredients")
  end
  if definition.max_ingredients ~= nil then
    require_positive_number(definition.max_ingredients, "recipe family maximum ingredients")
  end
  if definition.min_ingredients and definition.max_ingredients
    and definition.min_ingredients > definition.max_ingredients
  then
    error("FluxWorks compatibility API: recipe family ingredient bounds are inverted")
  end
  local has_selector = definition.item_names or definition.item_name_patterns
    or definition.item_types or definition.entity_types or definition.types
    or definition.subgroups or definition.subgroup_patterns
  if not has_selector then
    error("FluxWorks compatibility API: recipe family must provide at least one selector")
  end
  local copy = table.deepcopy(definition)
  local index = recipe_family_index[definition.name]
  if index then
    M.recipe_families[index] = copy
  else
    M.recipe_families[#M.recipe_families + 1] = copy
    recipe_family_index[definition.name] = #M.recipe_families
  end
end

function M.register_recipe_families(definitions)
  if type(definitions) ~= "table" then
    error("FluxWorks compatibility API: recipe family definitions must be a table")
  end
  for _, definition in ipairs(definitions) do M.register_recipe_family(definition) end
end

function M.register_recipe_part(recipe_name, part_name, amount)
  require_name(recipe_name, "recipe name")
  require_name(part_name, "recipe part")
  if amount ~= nil then require_positive_number(amount, "recipe part amount") end
  M.recipe_parts[recipe_name] = {
    part = part_name,
    amount = amount or 1,
  }
end

function M.register_recipe_parts(definitions)
  if type(definitions) ~= "table" then
    error("FluxWorks compatibility API: recipe part definitions must be a table")
  end
  for _, definition in ipairs(definitions) do
    if type(definition) ~= "table" then
      error("FluxWorks compatibility API: recipe part definition must be a table")
    end
    M.register_recipe_part(
      definition.recipe or definition.name,
      definition.part,
      definition.amount
    )
  end
end

function M.register_item(definition)
  if type(definition) ~= "table" then
    error("FluxWorks compatibility API: item definition must be a table")
  end
  require_name(definition.name, "item definition name")
  if definition.value then
    M.register_item_value(definition.name, definition.value, { locked = definition.locked })
  end
  if definition.spectrum then M.register_item_spectrum(definition.name, definition.spectrum) end
  if definition.exclude_recovery then M.exclude_from_recovery(definition.name) end
  for quality_name, multiplier in pairs(definition.quality_multipliers or {}) do
    M.register_item_quality_multiplier(definition.name, quality_name, multiplier)
  end
  for _, quality_name in ipairs(definition.excluded_qualities or {}) do
    M.exclude_item_quality(definition.name, quality_name)
  end
end

function M.register_items(definitions)
  if type(definitions) ~= "table" then
    error("FluxWorks compatibility API: item definitions must be a table")
  end
  for _, definition in ipairs(definitions) do M.register_item(definition) end
end

function M.exclude_items_from_recovery(item_names)
  if type(item_names) ~= "table" then
    error("FluxWorks compatibility API: recovery exclusion list must be a table")
  end
  for _, item_name in ipairs(item_names) do M.exclude_from_recovery(item_name) end
end

function M.exclude_recipes(recipe_names)
  if type(recipe_names) ~= "table" then
    error("FluxWorks compatibility API: recipe exclusion list must be a table")
  end
  for _, recipe_name in ipairs(recipe_names) do M.exclude_recipe(recipe_name) end
end

-- The easiest integration path: describe the mod in one table. All individual
-- helpers remain public for small or conditional registrations.
function M.register(definition)
  if type(definition) ~= "table" then
    error("FluxWorks compatibility API: compatibility definition must be a table")
  end
  M.register_items(definition.items or {})
  M.register_fluids(definition.fluids or {})
  M.register_recipe_parts(definition.recipe_parts or {})
  M.register_recipe_families(definition.recipe_families or {})
  M.exclude_items_from_recovery(definition.exclude_items or {})
  M.exclude_recipes(definition.exclude_recipes or {})
  for quality_name, multiplier in pairs(definition.quality_multipliers or {}) do
    M.register_quality_multiplier(quality_name, multiplier)
  end
  for _, quality_name in ipairs(definition.exclude_qualities or {}) do
    M.exclude_quality_from_recovery(quality_name)
  end
  return M
end

function M.snapshot()
  return table.deepcopy({
    item_values = M.item_values,
    item_value_locks = M.item_value_locks,
    item_spectra = M.item_spectra,
    item_quality_multipliers = M.item_quality_multipliers,
    item_quality_exclusions = M.item_quality_exclusions,
    fluid_values = M.fluid_values,
    fluid_spectra = M.fluid_spectra,
    quality_multipliers = M.quality_multipliers,
    quality_exclusions = M.quality_exclusions,
    recovery_exclusions = M.recovery_exclusions,
    recipe_exclusions = M.recipe_exclusions,
    recipe_families = M.recipe_families,
    recipe_parts = M.recipe_parts,
  })
end

return M
