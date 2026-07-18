if not mods["aai-industry"] then
  return
end

local shared = require("prototypes.updates.recipe_tweaks.shared")

local function ingredient_name(ingredient)
  return ingredient.name or ingredient[1]
end

local function remove_from_ingredient_list(ingredients, removed_names)
  local filtered = {}
  for _, ingredient in pairs(ingredients or {}) do
    if not removed_names[ingredient_name(ingredient)] then
      filtered[#filtered + 1] = ingredient
    end
  end
  return filtered
end

local function remove_ingredients_everywhere(recipe_name, names)
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if not recipe then
    return
  end

  local removed_names = {}
  for _, name in ipairs(names) do
    removed_names[name] = true
  end

  recipe.ingredients = remove_from_ingredient_list(recipe.ingredients, removed_names)
  if recipe.normal then
    recipe.normal.ingredients = remove_from_ingredient_list(recipe.normal.ingredients, removed_names)
  end
  if recipe.expensive then
    recipe.expensive.ingredients = remove_from_ingredient_list(recipe.expensive.ingredients, removed_names)
  end
end

local function normalize_powered_offshore_pump()
  local offshore_pump = data.raw["offshore-pump"] and data.raw["offshore-pump"]["offshore-pump"]
  if not offshore_pump then
    return
  end

  if offshore_pump.energy_source and offshore_pump.energy_source.type == "electric" then
    offshore_pump.energy_source.usage_priority = offshore_pump.energy_source.usage_priority or "secondary-input"
    offshore_pump.energy_usage = offshore_pump.energy_usage or "90kW"
  end
end

local function lighten_aai_bootstrap_overlap()
  local remove_recipe_ingredient = shared.remove_recipe_ingredient

  -- AAI already deepens the opening with powered pumps, stone-heavy machines, and
  -- dedicated motor chains. Keep FluxWorks from piling its own bespoke fluid parts
  -- onto the same bootstrap surface before the full integration sweep lands.
  for _, recipe_name in ipairs({
    "pump",
    "offshore-pump",
    "steam-engine",
  }) do
    remove_ingredients_everywhere(recipe_name, { "fw-copper-tube" })
    remove_recipe_ingredient(recipe_name, "fw-copper-tube")
  end

  for _, recipe_name in ipairs({
    "chemical-plant",
    "oil-refinery",
    "pumpjack",
  }) do
    remove_ingredients_everywhere(recipe_name, { "fw-copper-tube", "fw-inline-filter" })
    remove_recipe_ingredient(recipe_name, "fw-copper-tube")
    remove_recipe_ingredient(recipe_name, "fw-inline-filter")
  end
end

local function deepen_aai_fluxworks_synergy()
  local patch_recipe_set = shared.patch_recipe_set

  -- Once AAI has already established the motorized machine ladder, FluxWorks
  -- should lean into those upgraded machines instead of staying off to the side.
  patch_recipe_set({
    { "fw-pressure-housing", "engine-unit", 1 },
    { "fw-flow-regulator", "engine-unit", 1 },
    { "fw-power-regulator", "electric-motor", 1 },
    { "fw-signal-conduit", "electric-motor", 1 },
    { "fw-field-winding", "electric-engine-unit", 1 },
    { "fw-harvester-head", "electric-motor", 2 },
    { "fw-rocket-engine", "engine-unit", 1 },
    { "fw-petrochemical-facility", "motor", 4 },
    { "fw-hydraulic-plant", "electric-motor", 4 },
    { "fw-hydraulic-manifold", "motor", 1 },
    { "fw-flux-quarry", "electric-engine-unit", 4 },
    { "lab", "burner-lab", 1 },
    { "electric-mining-drill", "fw-drive-module", 1 },
    { "electric-mining-drill", "fw-bearing", 1 },
    { "assembling-machine-2", "motor", 2 },
    { "assembling-machine-2", "fw-drive-module", 1 },
    { "assembling-machine-2", "fw-bearing", 1 },
    { "assembling-machine-2", "fw-circuit-contact", 2 },
    { "assembling-machine-3", "electric-engine-unit", 2 },
    { "assembling-machine-3", "fw-control-assembly", 1 },
    { "assembling-machine-3", "fw-chip-carrier", 1 },
    { "assembling-machine-3", "fw-signal-conduit", 1 },
    { "assembling-machine-3", "fw-transformer-core", 1 },
    { "chemical-plant", "engine-unit", 2 },
    { "chemical-plant", "fw-drive-module", 1 },
    { "oil-refinery", "engine-unit", 2 },
    { "oil-refinery", "electric-engine-unit", 2 },
    { "oil-refinery", "fw-drive-module", 2 },
    { "pumpjack", "engine-unit", 2 },
    { "pumpjack", "fw-drive-module", 2 },
    { "pumpjack", "fw-flow-regulator", 1 },
    { "pumpjack", "fw-bearing", 2 },
    { "big-mining-drill", "electric-engine-unit", 2 },
    { "big-mining-drill", "fw-control-assembly", 1 },
    { "big-mining-drill", "fw-flow-regulator", 1 },
    { "big-mining-drill", "fw-transformer-core", 1 },
    { "big-mining-drill", "fw-sensor-package", 1 },
    { "industrial-furnace", "engine-unit", 1 },
    { "industrial-furnace", "fw-foundry-lining", 1 },
    { "industrial-furnace", "fw-power-regulator", 1 },
    { "industrial-furnace", "fw-alumina-refractory", 2 },
    { "industrial-furnace", "fw-hydraulic-manifold", 1 },
  })
end

normalize_powered_offshore_pump()
lighten_aai_bootstrap_overlap()
deepen_aai_fluxworks_synergy()
