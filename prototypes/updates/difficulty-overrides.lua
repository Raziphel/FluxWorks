local Startup = require("prototypes.lib.startup-settings")

local DIFFICULTY_SETTINGS = {
  "fw-balance-flux-core-difficulty",
  "fw-balance-harvesting-difficulty",
  "fw-balance-synthesis-difficulty",
  "fw-balance-condensing-difficulty",
  "fw-balance-petrochemistry-difficulty",
  "fw-balance-hydraulics-difficulty",
  "fw-balance-atomic-enrichment-difficulty",
  "fw-balance-integrated-recipes-difficulty",
  "fw-balance-science-recipes-difficulty",
  "fw-balance-fluid-systems-difficulty",
  "fw-balance-control-systems-difficulty",
  "fw-balance-late-machines-difficulty",
  "fw-balance-orbital-recipes-difficulty",
  "fw-balance-crafting-time-difficulty",
  "fw-balance-origin-singularity-difficulty",
}

local function tier(name)
  return Startup.difficulty_tier(name, "normal")
end

local function has_any_overrides()
  for _, name in ipairs(DIFFICULTY_SETTINGS) do
    if tier(name) ~= "normal" then
      return true
    end
  end
  return false
end

if not has_any_overrides() then
  return
end

local function tier_multiplier(name, easy_value, hard_value)
  local value = tier(name)
  if value == "easy" then
    return easy_value
  end
  if value == "hard" then
    return hard_value
  end
  return 1
end

local PROFILE = {
  fw_core = tier_multiplier("fw-balance-flux-core-difficulty", 0.72, 1.45),
  harvesting = tier_multiplier("fw-balance-harvesting-difficulty", 0.68, 1.62),
  synthesis = tier_multiplier("fw-balance-synthesis-difficulty", 0.62, 1.82),
  condensing = tier_multiplier("fw-balance-condensing-difficulty", 0.58, 2.05),
  petrochem = tier_multiplier("fw-balance-petrochemistry-difficulty", 0.70, 1.55),
  hydraulics = tier_multiplier("fw-balance-hydraulics-difficulty", 0.68, 1.62),
  atomic = tier_multiplier("fw-balance-atomic-enrichment-difficulty", 0.64, 1.78),
  integrated = tier_multiplier("fw-balance-integrated-recipes-difficulty", 0.78, 1.36),
  science = tier_multiplier("fw-balance-science-recipes-difficulty", 0.76, 1.34),
  fluid = tier_multiplier("fw-balance-fluid-systems-difficulty", 0.80, 1.36),
  control = tier_multiplier("fw-balance-control-systems-difficulty", 0.78, 1.42),
  late = tier_multiplier("fw-balance-late-machines-difficulty", 0.70, 1.62),
  orbital = tier_multiplier("fw-balance-orbital-recipes-difficulty", 0.68, 1.82),
  time = tier_multiplier("fw-balance-crafting-time-difficulty", 0.82, 1.24),
  origin = tier_multiplier("fw-balance-origin-singularity-difficulty", 0.25, 2.00),
}

local function tier_time_adjust(name, easy_delta, hard_delta)
  local value = tier(name)
  if value == "easy" then
    return PROFILE.time + easy_delta
  end
  if value == "hard" then
    return PROFILE.time + hard_delta
  end
  return 1
end

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
  ["landing-pad-unloading-bay"] = true,
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
  local category = recipe.categories and recipe.categories[1] or recipe.category
  if type(category) ~= "string" or category == "" then
    category = recipe.normal and ((recipe.normal.categories and recipe.normal.categories[1]) or recipe.normal.category) or category
  end
  if type(category) ~= "string" or category == "" then
    category = recipe.expensive and ((recipe.expensive.categories and recipe.expensive.categories[1]) or recipe.expensive.category) or category
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
  if SCIENCE_RECIPES[recipe_name] and (kind == "item" or kind == "fluid") then
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
  if current == 1 then
    return candidate
  end
  if math.abs(candidate - 1) > math.abs(current - 1) then
    return candidate
  end
  return current
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
  local multiplier = 1

  if is_fw_name(recipe_name) then
    multiplier = combine_multiplier(multiplier, PROFILE.time)
    if category == "fw-flux-condensing" then
      multiplier = combine_multiplier(multiplier, tier_time_adjust("fw-balance-crafting-time-difficulty", -0.18, 0.38))
    elseif category == "fw-flux-synthesis" then
      multiplier = combine_multiplier(multiplier, tier_time_adjust("fw-balance-crafting-time-difficulty", -0.12, 0.22))
    elseif category == "fw-flux-harvesting" then
      multiplier = combine_multiplier(multiplier, tier_time_adjust("fw-balance-crafting-time-difficulty", -0.10, 0.16))
    elseif category == "fw-petrochemistry" then
      multiplier = combine_multiplier(multiplier, tier_time_adjust("fw-balance-crafting-time-difficulty", -0.06, 0.10))
    elseif category == "fw-hydraulics" then
      multiplier = combine_multiplier(multiplier, tier_time_adjust("fw-balance-crafting-time-difficulty", -0.08, 0.12))
    elseif category == "fw-atomic-enrichment" then
      multiplier = combine_multiplier(multiplier, tier_time_adjust("fw-balance-crafting-time-difficulty", -0.10, 0.18))
    end
  end
  if SCIENCE_RECIPES[recipe_name] then
    multiplier = combine_multiplier(multiplier, tier_time_adjust("fw-balance-crafting-time-difficulty", -0.18, 0.26))
  end
  if ORBITAL_RECIPES[recipe_name] then
    multiplier = combine_multiplier(multiplier, tier_time_adjust("fw-balance-crafting-time-difficulty", -0.14, 0.30))
  end
  if LATE_RECIPES[recipe_name] then
    multiplier = combine_multiplier(multiplier, tier_time_adjust("fw-balance-crafting-time-difficulty", -0.10, 0.20))
  end
  return multiplier
end

local function ingredient_multiplier(recipe_name, category, ingredient)
  local name = entry_name(ingredient)
  local multiplier = 1

  if is_fw_name(recipe_name) then
    multiplier = combine_multiplier(multiplier, PROFILE.fw_core)
    if category == "fw-origin-forging" then
      multiplier = combine_multiplier(multiplier, PROFILE.origin)
    elseif category == "fw-flux-harvesting" then
      multiplier = combine_multiplier(multiplier, PROFILE.harvesting)
    elseif category == "fw-flux-synthesis" then
      multiplier = combine_multiplier(multiplier, PROFILE.synthesis)
    elseif category == "fw-flux-condensing" then
      multiplier = combine_multiplier(multiplier, PROFILE.condensing)
    elseif category == "fw-petrochemistry" then
      multiplier = combine_multiplier(multiplier, PROFILE.petrochem)
    elseif category == "fw-hydraulics" then
      multiplier = combine_multiplier(multiplier, PROFILE.hydraulics)
    elseif category == "fw-atomic-enrichment" then
      multiplier = combine_multiplier(multiplier, PROFILE.atomic)
    end
  end

  if SCIENCE_RECIPES[recipe_name] then
    multiplier = combine_multiplier(multiplier, PROFILE.science)
  end

  if is_fw_name(name) or STRATEGIC_EXTERNAL_INGREDIENTS[name] then
    multiplier = combine_multiplier(multiplier, PROFILE.integrated)
  end

  if FLUID_RECIPES[recipe_name] or FLUID_INGREDIENTS[name] then
    multiplier = combine_multiplier(multiplier, PROFILE.fluid)
  end

  if CONTROL_RECIPES[recipe_name] or CONTROL_INGREDIENTS[name] then
    multiplier = combine_multiplier(multiplier, PROFILE.control)
  end

  if LATE_RECIPES[recipe_name] or LATE_INGREDIENTS[name] then
    multiplier = combine_multiplier(multiplier, PROFILE.late)
  end

  if ORBITAL_RECIPES[recipe_name] or ORBITAL_INGREDIENTS[name] then
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

  -- Extraction always consumes exactly one evaluated object. Its startup
  -- difficulty is already represented in the shared recovery-yield function.
  if category ~= "fw-flux-extraction" then
    for _, variant in ipairs(recipe_variants(recipe)) do
      scale_ingredient_amounts(recipe_name, category, variant.ingredients)
    end
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
