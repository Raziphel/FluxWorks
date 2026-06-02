-- Flux transmutation chain.
-- If we rebalance later, do it here once and every recipe follows.

local TRANSMUTATION_BALANCE = {
  -- Defaults for any step that does not override values.
  defaults = {
    input_amount = 10,
    output_amount = 10,
    energy_required = 5,
    flux_refund = 1,
  },

  -- Ordered rough-material ladder from common -> rare.
  -- Upcycling is intentionally lossy and downcycling refunds less Flux than it
  -- costs to climb, so the loop can smooth shortages without printing resources.
  steps = {
    { from = "stone",       to = "coal",         input_amount = 12, output_amount = 10, flux_cost = 4,  flux_refund = 1, energy_required = 4 },
    { from = "coal",        to = "copper-ore",   input_amount = 12, output_amount = 10, flux_cost = 6,  flux_refund = 2, energy_required = 4 },
    { from = "copper-ore",  to = "iron-ore",     input_amount = 10, output_amount = 10, flux_cost = 4,  flux_refund = 1, energy_required = 4 },
    { from = "iron-ore",    to = "lead-ore",     input_amount = 10, output_amount = 9,  flux_cost = 8,  flux_refund = 3, energy_required = 5 },
    { from = "lead-ore",    to = "tin-ore",      input_amount = 10, output_amount = 9,  flux_cost = 8,  flux_refund = 3, energy_required = 5 },
    { from = "tin-ore",     to = "bauxite-ore",  input_amount = 10, output_amount = 8,  flux_cost = 10, flux_refund = 4, energy_required = 6 },
    { from = "bauxite-ore", to = "silicon-ore",  input_amount = 10, output_amount = 8,  flux_cost = 12, flux_refund = 4, energy_required = 6 },
    { from = "fw-sand",     to = "silicon-ore",  input_amount = 14, output_amount = 6,  flux_cost = 12, flux_refund = 3, energy_required = 6 },
    { from = "silicon-ore", to = "titanium-ore", input_amount = 10, output_amount = 7,  flux_cost = 18, flux_refund = 6, energy_required = 8 },
    { from = "titanium-ore", to = "uranium-ore", input_amount = 10, output_amount = 7,  flux_cost = 22, flux_refund = 7, energy_required = 9 },
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

local function to_upcycle_recipe(step, index)
  local defaults = TRANSMUTATION_BALANCE.defaults
  local input_amount = step.input_amount or defaults.input_amount
  local output_amount = step.output_amount or defaults.output_amount
  local energy_required = step.energy_required or defaults.energy_required
  local flux_cost = step.flux_cost or 1
  local suffix = letter_for(index)
  local name = "fw-" .. recipe_name_part(step.from) .. "-to-" .. recipe_name_part(step.to)

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
  local flux_refund = step.flux_refund
  if flux_refund == nil then
    flux_refund = defaults.flux_refund
  end
  local suffix = letter_for(index)
  local name = "fw-" .. recipe_name_part(step.to) .. "-to-" .. recipe_name_part(step.from)
  local results = {
    { type = "item", name = step.from, amount = output_amount },
  }
  if flux_refund > 0 then
    table.insert(results, { type = "fluid", name = "fw-purple-flux", amount = flux_refund })
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
    ingredients = {
      { type = "item", name = step.to, amount = input_amount },
    },
    results = results,
  }
end

for i, step in ipairs(TRANSMUTATION_BALANCE.steps) do
  if item_exists(step.from) and item_exists(step.to) then
    table.insert(recipes, to_upcycle_recipe(step, i))
    table.insert(recipes, to_downcycle_recipe(step, i))
  end
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
