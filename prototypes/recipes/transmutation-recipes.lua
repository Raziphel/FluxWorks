-- Flux transmutation chain.
-- If we rebalance later, do it here once and every recipe follows.

local TRANSMUTATION_BALANCE = {
  default_unlock_technology = "fw-liquid-mining",

  -- Defaults for any step that does not override values.
  defaults = {
    input_amount = 10,
    output_amount = 10,
    energy_required = 5,
    flux_refund = 1,
    flux_fluid = "fw-purple-flux",
  },

  -- Ordered rough-material ladder from common -> rare. Early recipes are simple
  -- shortage smoothing, while deeper transmutation spends catalysts and
  -- spectrum-conditioned Flux so rare ores are not printed from easy materials.
  steps = {
    { from = "stone",       to = "coal",         input_amount = 14, output_amount = 10, flux_cost = 6,  flux_refund = 1,  energy_required = 4 },
    { from = "coal",        to = "copper-ore",   input_amount = 10, output_amount = 10, flux_cost = 8,  flux_refund = 2,  energy_required = 4, secondary_fluids = { { name = "crude-oil", amount = 10 } } },
    { from = "copper-ore",  to = "iron-ore",     input_amount = 10, output_amount = 10, flux_cost = 6,  flux_refund = 1,  energy_required = 4, secondary_fluids = { { name = "crude-oil", amount = 8 } } },
    { from = "iron-ore",    to = "lead-ore",     input_amount = 10, output_amount = 10, flux_cost = 14, flux_refund = 4,  energy_required = 6,  unlock_technology = "fw-flux-catalysis", catalyst_amount = 1, catalyst_return_probability = 0.90, secondary_fluids = { { name = "crude-oil", amount = 12 } } },
    { from = "lead-ore",    to = "tin-ore",      input_amount = 10, output_amount = 10, flux_cost = 16, flux_refund = 5,  energy_required = 6,  unlock_technology = "fw-flux-catalysis", catalyst_amount = 1, catalyst_return_probability = 0.88, secondary_fluids = { { name = "crude-oil", amount = 14 } } },
    { from = "tin-ore",     to = "bauxite-ore",  input_amount = 10, output_amount = 10, flux_cost = 20, flux_refund = 6,  energy_required = 7,  unlock_technology = "fw-flux-catalysis", catalyst_amount = 1, catalyst_return_probability = 0.85, secondary_fluids = { { name = "crude-oil", amount = 18 } } },
    { from = "bauxite-ore", to = "silicon-ore",  input_amount = 10, output_amount = 10, flux_cost = 24, flux_refund = 7,  energy_required = 7,  unlock_technology = "fw-flux-catalysis", catalyst_amount = 1, catalyst_return_probability = 0.82, secondary_fluids = { { name = "crude-oil", amount = 22 } } },
    { from = "silicon-ore", to = "titanium-ore", input_amount = 10, output_amount = 10, flux_cost = 30, flux_refund = 9,  energy_required = 9,  unlock_technology = "fw-flux-field-theory", flux_fluid = "fw-red-flux",    catalyst_amount = 1, catalyst_return_probability = 0.75, secondary_fluids = { { name = "crude-oil", amount = 28 }, { name = "fw-green-flux", amount = 10 } } },
    { from = "titanium-ore", to = "uranium-ore", input_amount = 10, output_amount = 10, flux_cost = 36, flux_refund = 10, energy_required = 10, unlock_technology = "fw-flux-field-theory", flux_fluid = "fw-yellow-flux", catalyst_amount = 1, catalyst_return_probability = 0.70, secondary_fluids = { { name = "crude-oil", amount = 36 }, { name = "fw-red-flux", amount = 12 } } },
  },
}

data:extend({
  {
    type = "item-subgroup",
    name = "fw-transmutation-upcycle",
    group = "intermediate-products",
    order = "z[fw-transmutation]-a",
  },
  {
    type = "item-subgroup",
    name = "fw-transmutation-downcycle",
    group = "intermediate-products",
    order = "z[fw-transmutation]-b",
  },
})

local recipes = {}
local unlocks_by_technology = {}

local function item_exists(name)
  return data.raw.item and data.raw.item[name]
end

local flux_source_recipe = {
  type = "recipe",
  name = "fw-purple-flux-reclamation",
  localised_name = { "fluid-name.fw-purple-flux" },
  category = "chemistry",
  subgroup = "fw-transmutation-upcycle",
  order = "a[chemistry]-a0[fw-purple-flux-reclamation]",
  enabled = false,
  energy_required = 3,
  ingredients = {
    { type = "item", name = "fw-crystalised-flux", amount = 2 },
    { type = "fluid", name = "water", amount = 40 },
  },
  results = {
    { type = "fluid", name = "fw-purple-flux", amount = 80 },
  },
  main_product = "fw-purple-flux",
}

local function has_unlock_effect(effects, recipe_name)
  for _, effect in pairs(effects or {}) do
    if effect.type == "unlock-recipe" and effect.recipe == recipe_name then
      return true
    end
  end
  return false
end

local function letter_for(index)
  return string.char(string.byte("a") + index - 1)
end

local function recipe_name_part(item_name)
  return string.gsub(item_name, "^fw%-", "")
end

local function step_unlock_technology(step)
  return step.unlock_technology or TRANSMUTATION_BALANCE.default_unlock_technology
end

local function add_recipe_unlock(technology_name, recipe_name)
  unlocks_by_technology[technology_name] = unlocks_by_technology[technology_name] or {}
  table.insert(unlocks_by_technology[technology_name], recipe_name)
end

local function add_catalyst_ingredient(ingredients, step)
  if step.catalyst_amount then
    table.insert(ingredients, { type = "item", name = "fw-flux-catalyst", amount = step.catalyst_amount })
  end
end

local function add_catalyst_return(results, step)
  if step.catalyst_amount then
    table.insert(results, {
      type = "item",
      name = "fw-flux-catalyst",
      amount = step.catalyst_amount,
      probability = step.catalyst_return_probability or 1,
    })
  end
end

local function add_secondary_fluids(ingredients, step)
  for _, fluid in ipairs(step.secondary_fluids or {}) do
    table.insert(ingredients, { type = "fluid", name = fluid.name, amount = fluid.amount })
  end
end

local function to_upcycle_recipe(step, index)
  local defaults = TRANSMUTATION_BALANCE.defaults
  local input_amount = step.input_amount or defaults.input_amount
  local output_amount = step.output_amount or defaults.output_amount
  local energy_required = step.energy_required or defaults.energy_required
  local flux_cost = step.flux_cost or 1
  local flux_fluid = step.flux_fluid or defaults.flux_fluid
  local suffix = letter_for(index)
  local name = "fw-" .. recipe_name_part(step.from) .. "-to-" .. recipe_name_part(step.to)
  local ingredients = {
    { type = "item", name = step.from, amount = input_amount },
    { type = "fluid", name = flux_fluid, amount = flux_cost },
  }
  local results = {
    { type = "item", name = step.to, amount = output_amount },
  }
  add_secondary_fluids(ingredients, step)
  add_catalyst_ingredient(ingredients, step)
  add_catalyst_return(results, step)

  return {
    type = "recipe",
    name = name,
    localised_name = { "", { "item-name." .. step.from }, " -> ", { "item-name." .. step.to } },
    category = "chemistry",
    subgroup = "fw-transmutation-upcycle",
    order = "a[chemistry]-a" .. suffix .. "[" .. name .. "]",
    enabled = false,
    allow_productivity = false,
    energy_required = energy_required,
    main_product = step.to,
    ingredients = ingredients,
    results = results,
  }
end

local function to_downcycle_recipe(step, index)
  local defaults = TRANSMUTATION_BALANCE.defaults
  local input_amount = step.output_amount or defaults.output_amount
  local output_amount = step.input_amount or defaults.input_amount
  local energy_required = step.energy_required or defaults.energy_required
  local flux_refund = step.flux_refund
  if flux_refund == nil then
    flux_refund = defaults.flux_refund
  end
  local flux_fluid = step.flux_fluid or defaults.flux_fluid
  local suffix = letter_for(index)
  local name = "fw-" .. recipe_name_part(step.to) .. "-to-" .. recipe_name_part(step.from)
  local ingredients = {
    { type = "item", name = step.to, amount = input_amount },
  }
  local results = {
    { type = "item", name = step.from, amount = output_amount },
  }
  add_catalyst_ingredient(ingredients, step)
  add_catalyst_return(results, step)
  if flux_refund > 0 then
    table.insert(results, { type = "fluid", name = flux_fluid, amount = flux_refund })
  end

  return {
    type = "recipe",
    name = name,
    localised_name = { "", { "item-name." .. step.to }, " -> ", { "item-name." .. step.from } },
    category = "chemistry",
    subgroup = "fw-transmutation-downcycle",
    order = "a[chemistry]-b" .. suffix .. "[" .. name .. "]",
    enabled = false,
    allow_productivity = false,
    energy_required = energy_required,
    main_product = step.from,
    ingredients = ingredients,
    results = results,
  }
end

for i, step in ipairs(TRANSMUTATION_BALANCE.steps) do
  if item_exists(step.from) and item_exists(step.to) then
    local upcycle_recipe = to_upcycle_recipe(step, i)
    local downcycle_recipe = to_downcycle_recipe(step, i)
    table.insert(recipes, upcycle_recipe)
    table.insert(recipes, downcycle_recipe)
    add_recipe_unlock(step_unlock_technology(step), upcycle_recipe.name)
    add_recipe_unlock(step_unlock_technology(step), downcycle_recipe.name)
  end
end

data:extend(recipes)
data:extend({ flux_source_recipe })

-- Gate each tier behind the Flux system that makes it practical.
local transmutation_tech = data.raw.technology and (
  data.raw.technology["fw-liquid-mining"]
  or data.raw.technology["fw-material-foundations"]
  or data.raw.technology["fw-comminution"]
)

local function technology_for(name)
  if not data.raw.technology then
    return nil
  end
  return data.raw.technology[name]
end

local function unlock_recipes_on_technology(technology, recipe_names)
  if not technology then
    return
  end
  technology.effects = technology.effects or {}
  for _, recipe_name in ipairs(recipe_names) do
    if not has_unlock_effect(technology.effects, recipe_name) then
      table.insert(technology.effects, { type = "unlock-recipe", recipe = recipe_name })
    end
  end
end

if transmutation_tech then
  transmutation_tech.effects = transmutation_tech.effects or {}
  if not has_unlock_effect(transmutation_tech.effects, flux_source_recipe.name) then
    table.insert(transmutation_tech.effects, { type = "unlock-recipe", recipe = flux_source_recipe.name })
  end
end

for technology_name, recipe_names in pairs(unlocks_by_technology) do
  unlock_recipes_on_technology(technology_for(technology_name) or transmutation_tech, recipe_names)
end
