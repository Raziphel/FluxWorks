-- Flux transmutation chain.
-- If we rebalance later, do it here once and every recipe follows.

local TRANSMUTATION_BALANCE = {
  -- Defaults for any step that doesn't override values.
  defaults = {
    input_amount = 10,
    output_amount = 10,
    energy_required = 5,
  },

  -- Ordered chain from common -> rare.
  -- Add/remove/reorder here and both upcycle/downcycle stay in sync.
  steps = {
    -- Item amounts stay fixed at 10 -> 10.
    -- Only flux cost/refund scales by tier.
    { from = "stone",       to = "coal",         flux_cost = 1, flux_refund = 1 },
    { from = "coal",        to = "copper-ore",   flux_cost = 2, flux_refund = 2 },
    { from = "copper-ore",  to = "iron-ore",     flux_cost = 3, flux_refund = 3 },
    { from = "iron-ore",    to = "lead-ore",     flux_cost = 4, flux_refund = 4 },
    { from = "lead-ore",    to = "bauxite-ore",  flux_cost = 5, flux_refund = 5 },
    { from = "bauxite-ore", to = "uranium-ore",  flux_cost = 6, flux_refund = 6 },
    { from = "uranium-ore", to = "titanium-ore", flux_cost = 7, flux_refund = 7 },
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
    subgroup = "fw-transmutation-upcycle",
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
    subgroup = "fw-transmutation-downcycle",
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
