-- The whole transmutation ladder lives here.
-- If this gets rebalanced later, I only want to do it one time and let the rest follow along.

local TRANSMUTATION_BALANCE = {
  default_unlock_technology = "fw-harvester-systems",

  -- Safe defaults for any step that does not get fancy.
  defaults = {
    input_amount = 12,
    output_amount = 10,
    energy_required = 4.5,
    flux_refund = 4,
    flux_fluid = "fw-purple-flux",
  },

  -- The Harvester's core job is pushing ores up the ladder with purple Flux,
  -- then breaking them back down for a partial purple refund when supply shifts.
  steps = {
    { from = "coal",         to = "copper-ore",   input_amount = 12, output_amount = 10, flux_cost = 6,  flux_refund = 3,  energy_required = 4.0 },
    { from = "copper-ore",   to = "iron-ore",     input_amount = 12, output_amount = 10, flux_cost = 8,  flux_refund = 4,  energy_required = 4.5 },
    { from = "iron-ore",     to = "lead-ore",     input_amount = 12, output_amount = 10, flux_cost = 12, flux_refund = 6,  energy_required = 5.5 },
    { from = "lead-ore",     to = "tin-ore",      input_amount = 12, output_amount = 10, flux_cost = 14, flux_refund = 7,  energy_required = 6.0 },
    { from = "tin-ore",      to = "bauxite-ore",  input_amount = 14, output_amount = 10, flux_cost = 18, flux_refund = 9,  energy_required = 6.5 },
    { from = "bauxite-ore",  to = "silicon-ore",  input_amount = 14, output_amount = 10, flux_cost = 22, flux_refund = 11, energy_required = 7.0 },
    { from = "silicon-ore",  to = "titanium-ore", input_amount = 16, output_amount = 8,  flux_cost = 30, flux_refund = 15, energy_required = 8.5 },
    { from = "titanium-ore", to = "uranium-ore",  input_amount = 18, output_amount = 8,  flux_cost = 42, flux_refund = 18, unlock_technology = "fw-flux-field-theory", energy_required = 10.5 },
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
