-- The whole transmutation ladder lives here.
-- If this gets rebalanced later, I only want to do it one time and let the rest follow along.

local TRANSMUTATION_BALANCE = {
  default_unlock_technology = "fw-flux-catalysis",

  -- Safe defaults for any step that does not get fancy.
  defaults = {
    input_amount = 10,
    output_amount = 10,
    energy_required = 5,
    flux_refund = 1,
    flux_fluid = "fw-purple-flux",
  },

  -- Rough material ladder from common -> rare.
  -- Early steps are just there to smooth out shortages.
  -- Deep steps are where we start charging real Flux and catalyst costs so rare ores are not magically free.
  steps = {
    { from = "stone",       to = "coal",         input_amount = 14, output_amount = 10, flux_cost = 6,  flux_refund = 1,  energy_required = 4 },
    { from = "coal",        to = "copper-ore",   input_amount = 10, output_amount = 10, flux_cost = 8,  flux_refund = 2,  energy_required = 4, secondary_fluids = { { name = "crude-oil", amount = 10 } } },
    { from = "copper-ore",  to = "iron-ore",     input_amount = 10, output_amount = 10, flux_cost = 6,  flux_refund = 1,  energy_required = 4, secondary_fluids = { { name = "crude-oil", amount = 8 } } },
    { from = "iron-ore",    to = "lead-ore",     input_amount = 12, output_amount = 10, flux_cost = 16, flux_refund = 3,  flux_fluid = "fw-yellow-flux", unlock_technology = "fw-flux-yellow-catalysis", catalyst_amount = 1, catalyst_return_probability = 0.88, energy_required = 6.5, secondary_fluids = { { name = "crude-oil", amount = 12 } } },
    { from = "lead-ore",    to = "tin-ore",      input_amount = 12, output_amount = 10, flux_cost = 18, flux_refund = 4,  flux_fluid = "fw-yellow-flux", unlock_technology = "fw-flux-yellow-catalysis", catalyst_amount = 1, catalyst_return_probability = 0.85, energy_required = 7, secondary_fluids = { { name = "crude-oil", amount = 14 } } },
    { from = "tin-ore",     to = "bauxite-ore",  input_amount = 12, output_amount = 10, flux_cost = 22, flux_refund = 5,  flux_fluid = "fw-yellow-flux", unlock_technology = "fw-flux-yellow-catalysis", catalyst_amount = 1, catalyst_return_probability = 0.82, energy_required = 7.5, secondary_fluids = { { name = "crude-oil", amount = 18 } } },
    { from = "bauxite-ore", to = "silicon-ore",  input_amount = 14, output_amount = 10, flux_cost = 28, flux_refund = 6,  flux_fluid = "fw-red-flux", unlock_technology = "fw-flux-red-energetics", catalyst_amount = 1, catalyst_return_probability = 0.78, energy_required = 8.5, secondary_fluids = { { name = "crude-oil", amount = 22 } } },
    { from = "silicon-ore", to = "titanium-ore", input_amount = 16, output_amount = 8,  flux_cost = 38, flux_refund = 7,  flux_fluid = "fw-green-flux", unlock_technology = "fw-flux-green-reclamation", catalyst_amount = 2, catalyst_return_probability = 0.72, energy_required = 10.5, secondary_fluids = { { name = "crude-oil", amount = 30 } } },
    { from = "titanium-ore", to = "uranium-ore", input_amount = 18, output_amount = 8,  flux_cost = 48, flux_refund = 8,  flux_fluid = "fw-red-flux", unlock_technology = "fw-flux-field-theory", catalyst_amount = 2, catalyst_return_probability = 0.66, energy_required = 12, secondary_fluids = { { name = "crude-oil", amount = 38 } } },
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
    category = "fw-flux-harvesting",
    subgroup = "fw-transmutation-upcycle",
    order = "a[harvesting]-a" .. suffix .. "[" .. name .. "]",
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
    category = "fw-flux-harvesting",
    subgroup = "fw-transmutation-downcycle",
    order = "a[harvesting]-b" .. suffix .. "[" .. name .. "]",
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

-- Each tier should unlock when the matching Flux lane actually makes it reasonable.
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

for technology_name, recipe_names in pairs(unlocks_by_technology) do
  unlock_recipes_on_technology(technology_for(technology_name) or transmutation_tech, recipe_names)
end
