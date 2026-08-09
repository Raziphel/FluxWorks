if not mods["aai-industry"] then
  return function() end
end

return function()

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

local function remove_recipe_everywhere(recipe_name)
  for _, technology in pairs(data.raw.technology or {}) do
    local retained_effects = {}
    for _, effect in pairs(technology.effects or {}) do
      if effect.type ~= "unlock-recipe" or effect.recipe ~= recipe_name then
        retained_effects[#retained_effects + 1] = effect
      end
    end
    technology.effects = retained_effects
  end

  if data.raw.recipe then
    data.raw.recipe[recipe_name] = nil
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
  local set_recipe_ingredients = shared.set_recipe_ingredients
  local replace_recipe_ingredient = shared.replace_recipe_ingredient

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
    { "electric-mining-drill", "fw-bearing", 1 },
    { "assembling-machine-2", "motor", 2 },
    { "assembling-machine-2", "fw-bearing", 1 },
    { "assembling-machine-2", "fw-circuit-contact", 2 },
    { "assembling-machine-3", "electric-engine-unit", 2 },
    { "assembling-machine-3", "fw-control-assembly", 1 },
    { "assembling-machine-3", "fw-chip-carrier", 1 },
    { "assembling-machine-3", "fw-signal-conduit", 1 },
    { "assembling-machine-3", "fw-transformer-core", 1 },
    { "chemical-plant", "engine-unit", 2 },
    { "chemical-plant", "electric-motor", 1 },
    { "oil-refinery", "electric-motor", 2 },
    { "pumpjack", "engine-unit", 2 },
    { "pumpjack", "electric-motor", 2 },
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
    { "concrete-gate", "electric-motor", 1 },
    { "steel-gate", "fw-control-assembly", 1 },
    { "steel-wall", "fw-steel-beam", 2 },
  })

  -- Use AAI's raw-material lane as the actual beginning of FluxWorks processing,
  -- rather than maintaining duplicate stone-to-sand and tablet branches.
  local sand_recipe = data.raw.recipe and data.raw.recipe["sand"]
  if sand_recipe then
    -- Sand is crushed stone, so it should require the crusher instead of being
    -- available as a half-second character craft.
    sand_recipe.categories = { "basic-crushing" }
    sand_recipe.category = nil
    if sand_recipe.normal then sand_recipe.normal.categories = { "basic-crushing" }; sand_recipe.normal.category = nil end
    if sand_recipe.expensive then sand_recipe.expensive.categories = { "basic-crushing" }; sand_recipe.expensive.category = nil end
  end
  replace_recipe_ingredient("fw-circuit-contact", "iron-plate", {
    type = "item",
    name = "stone-tablet",
    amount = 1,
  })
  replace_recipe_ingredient("fw-inductor-coil", "iron-plate", {
    type = "item",
    name = "stone-tablet",
    amount = 1,
  })
  replace_recipe_ingredient("fw-capacitor", "aluminum-plate", {
    type = "item",
    name = "glass",
    amount = 1,
  })
  replace_recipe_ingredient("fw-cermet", "stone-brick", {
    type = "item",
    name = "stone-tablet",
    amount = 4,
  })
  replace_recipe_ingredient("fw-fired-ceramic", "stone-brick", {
    type = "item",
    name = "stone-tablet",
    amount = 4,
  })

  -- Keep shared-machine recipes legible: each one shows the machine it upgrades
  -- from and the AAI/FluxWorks assemblies responsible for the new capability.
  set_recipe_ingredients("steam-engine", {
    { type = "item", name = "iron-plate", amount = 10 },
    { type = "item", name = "electric-motor", amount = 3 },
    { type = "item", name = "iron-gear-wheel", amount = 2 },
    { type = "item", name = "pipe", amount = 5 },
  })
  set_recipe_ingredients("electric-mining-drill", {
    { type = "item", name = "burner-mining-drill", amount = 1 },
    { type = "item", name = "electric-motor", amount = 4 },
    { type = "item", name = "fw-bearing", amount = 1 },
    { type = "item", name = "fw-steel-beam", amount = 1 },
  })
  set_recipe_ingredients("lab", {
    { type = "item", name = "burner-lab", amount = 1 },
    { type = "item", name = "electronic-circuit", amount = 10 },
    { type = "item", name = "fw-glass-lens", amount = 2 },
    { type = "item", name = "fw-steel-beam", amount = 1 },
  })
  set_recipe_ingredients("industrial-furnace", {
    { type = "item", name = "electric-furnace", amount = 1 },
    { type = "item", name = "engine-unit", amount = 1 },
    { type = "item", name = "fw-foundry-lining", amount = 1 },
    { type = "item", name = "fw-power-regulator", amount = 1 },
    { type = "item", name = "fw-hydraulic-manifold", amount = 1 },
  })
  set_recipe_ingredients("area-mining-drill", {
    { type = "item", name = "electric-mining-drill", amount = 1 },
    { type = "item", name = "electric-engine-unit", amount = 8 },
    { type = "item", name = "fw-steel-beam", amount = 4 },
    { type = "item", name = "fw-harvester-head", amount = 2 },
    { type = "item", name = "fw-sensor-package", amount = 2 },
  })

  local function add_prerequisite(technology_name, prerequisite_name)
    local technology = data.raw.technology and data.raw.technology[technology_name]
    if not technology or not data.raw.technology[prerequisite_name] then return end
    technology.prerequisites = technology.prerequisites or {}
    for _, existing in pairs(technology.prerequisites) do
      if existing == prerequisite_name then return end
    end
    technology.prerequisites[#technology.prerequisites + 1] = prerequisite_name
  end

  add_prerequisite("sand-processing", "fw-comminution")
  local fuel_processing = data.raw.technology and data.raw.technology["fuel-processing"]
  if fuel_processing and fuel_processing.enabled ~= false and not fuel_processing.hidden then
    for _, replacement in ipairs({
      { "fw-carbon-washing", "coal", 1 },
      { "fw-rubber-sheet", "coal", 1 },
      { "plastic-bar", "coal", 1 },
      { "explosives", "coal", 1 },
      { "fw-yellow-polymer-alignment", "coal", 1 },
    }) do
      replace_recipe_ingredient(replacement[1], replacement[2], {
        type = "item",
        name = "processed-fuel",
        amount = replacement[3],
      })
    end

    -- Blend AAI's dense processed fuel into petroleum fuel production without
    -- erasing Space Age's solid-fuel logistics entirely.
    replace_recipe_ingredient("rocket-fuel", "solid-fuel", {
      type = "item",
      name = "solid-fuel",
      amount = 8,
    })
    patch_recipe_set({
      { "rocket-fuel", "processed-fuel", 2 },
      { "fw-red-rocket-fuel-overdrive", "processed-fuel", 2 },
    })
    add_prerequisite("fw-petrochemical-engineering", "fuel-processing")
  end
end

normalize_powered_offshore_pump()
remove_recipe_everywhere("electronic-circuit-wood")
lighten_aai_bootstrap_overlap()
deepen_aai_fluxworks_synergy()
end
