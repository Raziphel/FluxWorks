local Startup = require("prototypes.lib.startup-settings")

local difficulty = Startup.difficulty_mode()
if difficulty == "normal" then
  return
end

local affect_fluid_systems = Startup.enabled("fw-difficulty-affects-fluid-systems", true)
local affect_control_systems = Startup.enabled("fw-difficulty-affects-control-systems", true)
local affect_late_machines = Startup.enabled("fw-difficulty-affects-late-machines", true)
local affect_orbital_recipes = Startup.enabled("fw-difficulty-affects-orbital-recipes", true)
local affect_science_recipes = Startup.enabled("fw-difficulty-affects-science-recipes", true)
local affect_flux_core_recipes = Startup.enabled("fw-difficulty-affects-flux-core-recipes", true)
local affect_crafting_time = Startup.enabled("fw-difficulty-affects-crafting-time", true)

local PROFILE = difficulty == "hard" and {
  fw_core = 1.6,
  harvesting = 1.75,
  synthesis = 1.95,
  condensing = 2.25,
  integrated = 1.65,
  science = 1.55,
  fluid = 1.6,
  control = 1.75,
  late = 1.95,
  orbital = 2.1,
  time = 1.35,
} or {
  fw_core = 0.78,
  harvesting = 0.72,
  synthesis = 0.68,
  condensing = 0.62,
  integrated = 0.8,
  science = 0.72,
  fluid = 0.8,
  control = 0.82,
  late = 0.78,
  orbital = 0.74,
  time = 0.8,
}

local SCIENCE_RECIPES = {
  ["automation-science-pack"] = true,
  ["logistic-science-pack"] = true,
  ["military-science-pack"] = true,
  ["chemical-science-pack"] = true,
  ["production-science-pack"] = true,
  ["utility-science-pack"] = true,
  ["space-science-pack"] = true,
  ["metallurgic-science-pack"] = true,
  ["electromagnetic-science-pack"] = true,
  ["agricultural-science-pack"] = true,
  ["cryogenic-science-pack"] = true,
  ["promethium-science-pack"] = true,
}

local FLUID_RECIPES = {
  ["engine-unit"] = true,
  ["electric-engine-unit"] = true,
  ["pipe-to-ground"] = true,
  ["storage-tank"] = true,
  ["pump"] = true,
  ["offshore-pump"] = true,
  ["steam-engine"] = true,
  ["steam-turbine"] = true,
  ["heat-exchanger"] = true,
  ["fluid-wagon"] = true,
  ["chemical-plant"] = true,
  ["oil-refinery"] = true,
  ["pumpjack"] = true,
  ["flamethrower-turret"] = true,
  ["centrifuge"] = true,
  ["electrolyser"] = true,
  ["cryogenic-plant"] = true,
  ["foundry"] = true,
  ["biochamber"] = true,
  ["recycler"] = true,
  ["crusher"] = true,
  ["thruster"] = true,
  ["infinity-pipe"] = true,
  ["casting-pipe-to-ground"] = true,
  ["heating-tower"] = true,
}

local CONTROL_RECIPES = {
  ["arithmetic-combinator"] = true,
  ["decider-combinator"] = true,
  ["constant-combinator"] = true,
  ["selector-combinator"] = true,
  ["programmable-speaker"] = true,
  ["power-switch"] = true,
  ["rail-signal"] = true,
  ["rail-chain-signal"] = true,
  ["train-stop"] = true,
  ["roboport"] = true,
  ["radar"] = true,
  ["beacon"] = true,
  ["small-electric-pole"] = true,
  ["medium-electric-pole"] = true,
  ["big-electric-pole"] = true,
  ["substation"] = true,
  ["accumulator"] = true,
  ["laser-turret"] = true,
  ["teslagun"] = true,
  ["tesla-turret"] = true,
  ["rocket-turret"] = true,
}

local LATE_RECIPES = {
  ["big-mining-drill"] = true,
  ["foundry"] = true,
  ["biochamber"] = true,
  ["cryogenic-plant"] = true,
  ["electromagnetic-plant"] = true,
  ["recycler"] = true,
  ["crusher"] = true,
  ["supercapacitor"] = true,
  ["superconductor"] = true,
  ["quantum-processor"] = true,
  ["fusion-generator"] = true,
  ["fusion-reactor"] = true,
  ["fusion-reactor-equipment"] = true,
  ["power-armor-mk2"] = true,
  ["mech-armor"] = true,
  ["spidertron"] = true,
  ["railgun"] = true,
  ["railgun-turret"] = true,
  ["railgun-ammo"] = true,
  ["teslagun"] = true,
  ["tesla-turret"] = true,
  ["tesla-ammo"] = true,
  ["biolab"] = true,
  ["promethium-science-pack"] = true,
}

local ORBITAL_RECIPES = {
  ["rocket-silo"] = true,
  ["satellite"] = true,
  ["space-platform-foundation"] = true,
  ["space-platform-starter-pack"] = true,
  ["space-platform-hub"] = true,
  ["cargo-landing-pad"] = true,
  ["cargo-bay"] = true,
  ["asteroid-collector"] = true,
  ["thruster"] = true,
}

local FLUID_INGREDIENTS = {
  ["fw-copper-tube"] = true,
  ["fw-flow-regulator"] = true,
  ["fw-thermal-buffer"] = true,
  ["fw-inline-filter"] = true,
  ["lead-plate"] = true,
}

local CONTROL_INGREDIENTS = {
  ["fw-signal-conduit"] = true,
  ["fw-circuit-contact"] = true,
  ["fw-circuit-substrate"] = true,
  ["fw-sensor-diode"] = true,
  ["fw-sensor-package"] = true,
  ["fw-transformer-core"] = true,
  ["fw-memory-die"] = true,
  ["fw-field-winding"] = true,
  ["fw-em-core"] = true,
  ["fw-logic-matrix"] = true,
  ["fw-lens-array"] = true,
}

local LATE_INGREDIENTS = {
  ["fw-pressure-housing"] = true,
  ["fw-power-regulator"] = true,
  ["fw-foundry-lining"] = true,
  ["fw-annealed-cermet"] = true,
  ["fw-composite-panel"] = true,
  ["fw-cermet"] = true,
  ["fw-cryo-coil"] = true,
  ["fw-rift-stabilizer"] = true,
  ["fw-resonance-substrate"] = true,
  ["fw-flux-resonance-cell"] = true,
  ["fw-flux-phase-manifold"] = true,
  ["fw-aquilo-cryogel"] = true,
  ["fw-fulgora-static-mesh"] = true,
  ["fw-vulcanus-slag-cermet"] = true,
  ["titanium-plate"] = true,
  ["silicon"] = true,
}

local ORBITAL_INGREDIENTS = {
  ["fw-rocket-engine"] = true,
  ["fw-rocket-avionics"] = true,
  ["fw-rocket-heatshield"] = true,
  ["fw-light-frame"] = true,
  ["fw-foundry-lining"] = true,
  ["fw-annealed-cermet"] = true,
  ["fw-pressure-housing"] = true,
  ["fw-signal-conduit"] = true,
  ["fw-em-core"] = true,
  ["titanium-plate"] = true,
}

local STRATEGIC_EXTERNAL_INGREDIENTS = {
  ["lead-plate"] = true,
  ["tin-plate"] = true,
  ["titanium-plate"] = true,
  ["silicon"] = true,
}

local function recipe_variants(recipe)
  local variants = { recipe }
  if recipe.normal then
    variants[#variants + 1] = recipe.normal
  end
  if recipe.expensive then
    variants[#variants + 1] = recipe.expensive
  end
  return variants
end

local function recipe_category(recipe)
  local category = recipe.category
  if type(category) ~= "string" or category == "" then
    category = recipe.normal and recipe.normal.category or category
  end
  if type(category) ~= "string" or category == "" then
    category = recipe.expensive and recipe.expensive.category or category
  end
  if type(category) ~= "string" or category == "" then
    return "crafting"
  end
  return category
end

local function entry_name(entry)
  return entry.name or entry[1]
end

local function entry_type(entry)
  return entry.type or "item"
end

local function is_fw_name(name)
  return type(name) == "string" and string.sub(name, 1, 3) == "fw-"
end

local function is_difficulty_scalable(recipe_name, entry)
  local name = entry_name(entry)
  local kind = entry_type(entry)
  if affect_science_recipes and SCIENCE_RECIPES[recipe_name] and (kind == "item" or kind == "fluid") then
    return true
  end
  if kind == "fluid" then
    return is_fw_name(name)
  end
  return kind == "item"
end

local function combine_multiplier(current, candidate)
  if candidate == nil or candidate == 1 then
    return current
  end

  if difficulty == "hard" then
    return math.max(current, candidate)
  end

  return math.min(current, candidate)
end

local function scaled_amount(amount, multiplier)
  if multiplier == 1 or type(amount) ~= "number" or amount <= 0 then
    return amount
  end

  if multiplier > 1 then
    return math.max(1, math.ceil(amount * multiplier))
  end

  return math.max(1, math.floor(amount * multiplier))
end

local function recipe_time_multiplier(recipe_name, category)
  if not affect_crafting_time then
    return 1
  end

  local multiplier = 1
  if affect_flux_core_recipes and is_fw_name(recipe_name) then
    multiplier = combine_multiplier(multiplier, PROFILE.time)
    if category == "fw-flux-condensing" then
      multiplier = combine_multiplier(multiplier, PROFILE.time + (difficulty == "hard" and 0.25 or -0.12))
    elseif category == "fw-flux-synthesis" then
      multiplier = combine_multiplier(multiplier, PROFILE.time + (difficulty == "hard" and 0.15 or -0.08))
    elseif category == "fw-flux-harvesting" then
      multiplier = combine_multiplier(multiplier, PROFILE.time + (difficulty == "hard" and 0.1 or -0.06))
    end
  end
  if affect_science_recipes and SCIENCE_RECIPES[recipe_name] then
    multiplier = combine_multiplier(multiplier, PROFILE.time + (difficulty == "hard" and 0.18 or -0.14))
  end
  if affect_orbital_recipes and ORBITAL_RECIPES[recipe_name] then
    multiplier = combine_multiplier(multiplier, PROFILE.time + (difficulty == "hard" and 0.22 or -0.1))
  end
  if affect_late_machines and LATE_RECIPES[recipe_name] then
    multiplier = combine_multiplier(multiplier, PROFILE.time + (difficulty == "hard" and 0.14 or -0.06))
  end
  return multiplier
end

local function ingredient_multiplier(recipe_name, category, ingredient)
  local name = entry_name(ingredient)
  local multiplier = 1

  if affect_flux_core_recipes and is_fw_name(recipe_name) then
    multiplier = combine_multiplier(multiplier, PROFILE.fw_core)
    if category == "fw-flux-harvesting" then
      multiplier = combine_multiplier(multiplier, PROFILE.harvesting)
    elseif category == "fw-flux-synthesis" then
      multiplier = combine_multiplier(multiplier, PROFILE.synthesis)
    elseif category == "fw-flux-condensing" then
      multiplier = combine_multiplier(multiplier, PROFILE.condensing)
    end
  end

  if affect_science_recipes and SCIENCE_RECIPES[recipe_name] then
    multiplier = combine_multiplier(multiplier, PROFILE.science)
  end

  if is_fw_name(name) or STRATEGIC_EXTERNAL_INGREDIENTS[name] then
    multiplier = combine_multiplier(multiplier, PROFILE.integrated)
  end

  if affect_fluid_systems and (FLUID_RECIPES[recipe_name] or FLUID_INGREDIENTS[name]) then
    multiplier = combine_multiplier(multiplier, PROFILE.fluid)
  end

  if affect_control_systems and (CONTROL_RECIPES[recipe_name] or CONTROL_INGREDIENTS[name]) then
    multiplier = combine_multiplier(multiplier, PROFILE.control)
  end

  if affect_late_machines and (LATE_RECIPES[recipe_name] or LATE_INGREDIENTS[name]) then
    multiplier = combine_multiplier(multiplier, PROFILE.late)
  end

  if affect_orbital_recipes and (ORBITAL_RECIPES[recipe_name] or ORBITAL_INGREDIENTS[name]) then
    multiplier = combine_multiplier(multiplier, PROFILE.orbital)
  end

  return multiplier
end

local function scale_ingredient_amounts(recipe_name, category, ingredients)
  for _, ingredient in pairs(ingredients or {}) do
    if is_difficulty_scalable(recipe_name, ingredient) then
      local multiplier = ingredient_multiplier(recipe_name, category, ingredient)
      if ingredient.amount then
        ingredient.amount = scaled_amount(ingredient.amount, multiplier)
      end
      if ingredient.amount_min then
        ingredient.amount_min = scaled_amount(ingredient.amount_min, multiplier)
      end
      if ingredient.amount_max then
        ingredient.amount_max = math.max(
          ingredient.amount_min or 1,
          scaled_amount(ingredient.amount_max, multiplier)
        )
      end
    end
  end
end

for recipe_name, recipe in pairs(data.raw.recipe or {}) do
  local category = recipe_category(recipe)

  for _, variant in ipairs(recipe_variants(recipe)) do
    scale_ingredient_amounts(recipe_name, category, variant.ingredients)
  end

  local time_multiplier = recipe_time_multiplier(recipe_name, category)
  if time_multiplier ~= 1 then
    for _, variant in ipairs(recipe_variants(recipe)) do
      if variant.energy_required then
        variant.energy_required = math.max(0.1, variant.energy_required * time_multiplier)
      end
    end
  end
end
