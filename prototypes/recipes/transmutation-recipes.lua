-- Flux transmutation chain.
-- Tune values in TRANSMUTATION_BALANCE to change costs, rates, and refunds.

local TRANSMUTATION_BALANCE = {
  -- Global defaults used when a step does not override a value.
  defaults = {
    input_amount = 10,
    output_amount = 10,
    energy_required = 5,
  },

  -- Ordered chain from common -> rare.
  -- Add/remove/reorder steps here.
  steps = {
    -- Core metals chain.
    { from = "stone",        to = "coal",         flux_cost = 1, flux_refund = 1, output_amount = 9 },
    { from = "coal",         to = "copper-ore",   flux_cost = 1, flux_refund = 1, output_amount = 8 },
    { from = "copper-ore",   to = "iron-ore",     flux_cost = 1, flux_refund = 1, output_amount = 8 },
    { from = "iron-ore",     to = "tin-ore",      flux_cost = 2, flux_refund = 1, output_amount = 7 },
    { from = "tin-ore",      to = "lead-ore",     flux_cost = 2, flux_refund = 1, output_amount = 6 },
    { from = "lead-ore",     to = "bauxite-ore",  flux_cost = 3, flux_refund = 2, output_amount = 5 },
    { from = "bauxite-ore",  to = "aluminum-ore", flux_cost = 2, flux_refund = 1, output_amount = 5 },
    { from = "aluminum-ore", to = "uranium-ore",  flux_cost = 3, flux_refund = 2, output_amount = 4 },
    { from = "uranium-ore",  to = "titanium-ore", flux_cost = 8, flux_refund = 2, output_amount = 3 },

    -- Silicon branch.
    { from = "stone",        to = "silica",       flux_cost = 2, flux_refund = 1, output_amount = 7 },
    { from = "silica",       to = "silicon",      flux_cost = 3, flux_refund = 1, output_amount = 5 },
    { from = "silicon",      to = "silicon-wafer",flux_cost = 4, flux_refund = 2, output_amount = 4 },

    -- Carbon branch.
    { from = "coal",         to = "flake-graphite", flux_cost = 2, flux_refund = 1, output_amount = 7 },
    { from = "flake-graphite", to = "graphite",   flux_cost = 2, flux_refund = 1, output_amount = 6 },
    { from = "graphite",     to = "rough-diamond",flux_cost = 6, flux_refund = 2, output_amount = 3 },
    { from = "rough-diamond",to = "diamond",      flux_cost = 8, flux_refund = 2, output_amount = 2 },
  },
}

local recipes = {}

local function letter_for(index)
  return string.char(string.byte("a") + index - 1)
end

local function to_upcycle_recipe(step, index)
  local defaults = TRANSMUTATION_BALANCE.defaults
  local input_amount = step.input_amount or defaults.input_amount
  local output_amount = step.output_amount or defaults.output_amount
  local energy_required = step.energy_required or defaults.energy_required
  local flux_cost = step.flux_cost or 1
  local suffix = letter_for(index)
  local name = "fw-" .. step.from .. "-to-" .. step.to

  return {
    type = "recipe",
    name = name,
    localised_name = { "", { "item-name." .. step.from }, " -> ", { "item-name." .. step.to } },
    category = "chemistry",
    subgroup = "fluid-recipes",
    order = "a[chemistry]-a" .. suffix .. "[" .. name .. "]",
    enabled = true,
    energy_required = energy_required,
    main_product = step.to,
    ingredients = {
      { type = "item", name = step.from, amount = input_amount },
      { type = "fluid", name = "fw-purple-flux", amount = flux_cost },
    },
    results = {
      { type = "item", name = step.to, amount = output_amount },
    },
  }
end

local function to_downcycle_recipe(step, index)
  local defaults = TRANSMUTATION_BALANCE.defaults
  local input_amount = step.output_amount or defaults.output_amount
  local output_amount = step.input_amount or defaults.input_amount
  local energy_required = step.energy_required or defaults.energy_required
  local flux_refund = step.flux_refund or 1
  local suffix = letter_for(index)
  local name = "fw-" .. step.to .. "-to-" .. step.from

  return {
    type = "recipe",
    name = name,
    localised_name = { "", { "item-name." .. step.to }, " -> ", { "item-name." .. step.from } },
    category = "chemistry",
    subgroup = "fluid-recipes",
    order = "a[chemistry]-b" .. suffix .. "[" .. name .. "]",
    enabled = true,
    energy_required = energy_required,
    main_product = step.from,
    ingredients = {
      { type = "item", name = step.to, amount = input_amount },
    },
    results = {
      { type = "item", name = step.from, amount = output_amount },
      { type = "fluid", name = "fw-purple-flux", amount = flux_refund },
    },
  }
end

for i, step in ipairs(TRANSMUTATION_BALANCE.steps) do
  table.insert(recipes, to_upcycle_recipe(step, i))
  table.insert(recipes, to_downcycle_recipe(step, i))
end

data:extend(recipes)
