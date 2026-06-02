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
    { from = "bauxite-ore", to = "tin-ore",      flux_cost = 6, flux_refund = 6 },
    { from = "tin-ore",     to = "silicon-ore",  flux_cost = 7, flux_refund = 7 },
    { from = "silicon-ore", to = "uranium-ore",  flux_cost = 8, flux_refund = 8 },
    { from = "uranium-ore", to = "titanium-ore", flux_cost = 9, flux_refund = 9 },
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
    enabled = false,
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
    enabled = false,
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
data:extend({ flux_source_recipe })

-- Gate the full transmutation chain behind mid-game processing progression.
local transmutation_tech = data.raw.technology and (
  data.raw.technology["fw-liquid-mining"]
  or data.raw.technology["fw-material-foundations"]
  or data.raw.technology["fw-comminution"]
)
if transmutation_tech then
  transmutation_tech.effects = transmutation_tech.effects or {}
  if not has_unlock_effect(transmutation_tech.effects, flux_source_recipe.name) then
    table.insert(transmutation_tech.effects, { type = "unlock-recipe", recipe = flux_source_recipe.name })
  end
  for _, recipe in ipairs(recipes) do
    if not has_unlock_effect(transmutation_tech.effects, recipe.name) then
      table.insert(transmutation_tech.effects, { type = "unlock-recipe", recipe = recipe.name })
    end
  end
end
