-- Final, explicit repairs for the first Nauvis playtest report. Keep these
-- after broad compatibility rewrites so dependency mods cannot restore them.
local function entry_name(entry)
  return type(entry) == "table" and (entry.name or entry[1]) or nil
end

local function remove_ingredient(recipe_name, ingredient_name)
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if not recipe then return end
  for _, ingredients in ipairs({ recipe.ingredients, recipe.normal and recipe.normal.ingredients,
    recipe.expensive and recipe.expensive.ingredients }) do
    for index = #(ingredients or {}), 1, -1 do
      if entry_name(ingredients[index]) == ingredient_name then table.remove(ingredients, index) end
    end
  end
end

local function replace_ingredient(recipe_name, old_name, replacement)
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if not recipe then return end
  for _, ingredients in ipairs({ recipe.ingredients, recipe.normal and recipe.normal.ingredients,
    recipe.expensive and recipe.expensive.ingredients }) do
    for index, ingredient in ipairs(ingredients or {}) do
      if entry_name(ingredient) == old_name then ingredients[index] = table.deepcopy(replacement) end
    end
  end
end

local function remove_unlock(technology_name, recipe_name)
  local technology = data.raw.technology and data.raw.technology[technology_name]
  if not technology then return end
  for index = #(technology.effects or {}), 1, -1 do
    local effect = technology.effects[index]
    if effect.type == "unlock-recipe" and effect.recipe == recipe_name then table.remove(technology.effects, index) end
  end
end

local function remove_science(technology_name, science_name)
  local technology = data.raw.technology and data.raw.technology[technology_name]
  local ingredients = technology and technology.unit and technology.unit.ingredients
  for index = #(ingredients or {}), 1, -1 do
    if entry_name(ingredients[index]) == science_name then table.remove(ingredients, index) end
  end
end

local function remove_prerequisite(technology_name, prerequisite_name)
  local technology = data.raw.technology and data.raw.technology[technology_name]
  for index = #((technology and technology.prerequisites) or {}), 1, -1 do
    if technology.prerequisites[index] == prerequisite_name then table.remove(technology.prerequisites, index) end
  end
end

local function add_prerequisite(technology_name, prerequisite_name)
  local technology = data.raw.technology and data.raw.technology[technology_name]
  if not (technology and data.raw.technology[prerequisite_name]) then return end
  technology.prerequisites = technology.prerequisites or {}
  for _, existing in ipairs(technology.prerequisites) do
    if existing == prerequisite_name then return end
  end
  technology.prerequisites[#technology.prerequisites + 1] = prerequisite_name
end

local function add_unlock(technology_name, recipe_name)
  local technology = data.raw.technology and data.raw.technology[technology_name]
  if not (technology and data.raw.recipe[recipe_name]) then return end
  technology.effects = technology.effects or {}
  for _, effect in ipairs(technology.effects) do
    if effect.type == "unlock-recipe" and effect.recipe == recipe_name then return end
  end
  technology.effects[#technology.effects + 1] = { type = "unlock-recipe", recipe = recipe_name }
end

-- Break the advanced-circuit <-> microchip loop.
replace_ingredient("fw-microchip", "advanced-circuit", {
  type = "item", name = "electronic-circuit", amount = 2,
})
-- Processed fuel already supplies the carbon feedstock for first-tier plastic.
remove_ingredient("plastic-bar", "carbon")
-- These are Nauvis-era branches and must not wait for Aquilo science.
remove_science("fw-propellant-synthesis", "cryogenic-science-pack")
remove_science("fw-flux-catalysis", "cryogenic-science-pack")

local electricity = data.raw.technology and data.raw.technology.electricity
if electricity and electricity.unit then electricity.unit.count = 10 end

-- AAI raises Automation to 100 packs and later compatibility can route it
-- through the electric drill. Preserve the familiar first automation step.
local automation = data.raw.technology and data.raw.technology.automation
if automation and automation.unit then
  automation.unit.count = 10
  automation.prerequisites = data.raw.technology.electricity and { "electricity" } or {}
end

-- The Crusher must establish silicon processing, never require the circuit
-- whose silicon ingredient it exists to bootstrap.
local crusher = data.raw.recipe and data.raw.recipe.crusher
if crusher then
  local ingredients = {
    { type = "item", name = "iron-plate", amount = 10 },
    { type = "item", name = "iron-gear-wheel", amount = 5 },
    { type = "item", name = "stone-brick", amount = 5 },
    { type = "item", name = "motor", amount = 2 },
  }
  crusher.ingredients = table.deepcopy(ingredients)
  if crusher.normal then crusher.normal.ingredients = table.deepcopy(ingredients) end
  if crusher.expensive then crusher.expensive.ingredients = table.deepcopy(ingredients) end
end
add_unlock("fw-comminution", "fw-silicon-beneficiation")
remove_unlock("fw-mineral-beneficiation", "fw-silicon-beneficiation")

-- Keep the furnace-style silicon recipe on its later electromechanical lane.
-- Early research uses the distinct Crusher beneficiation recipe instead.
for technology_name in pairs(data.raw.technology or {}) do
  if technology_name ~= "fw-electromechanical-systems" then
    remove_unlock(technology_name, "silicon")
  end
end
add_unlock("fw-electromechanical-systems", "silicon")

-- Primitive powder becomes relevant with the first ammunition technology;
-- the chemically processed recipe remains on Propellant Synthesis.
add_unlock("military", "fw-gunpowder-early")
for technology_name in pairs(data.raw.technology or {}) do
  if technology_name ~= "fw-propellant-synthesis" then
    remove_unlock(technology_name, "fw-gunpowder")
  end
end
add_unlock("fw-propellant-synthesis", "fw-gunpowder")
local firearm_magazine = data.raw.recipe and data.raw.recipe["firearm-magazine"]
if firearm_magazine then
  firearm_magazine.enabled = false
  local has_gunpowder = false
  for _, ingredient in ipairs(firearm_magazine.ingredients or {}) do
    if entry_name(ingredient) == "fw-gunpowder" then has_gunpowder = true end
  end
  if not has_gunpowder then
    firearm_magazine.ingredients[#firearm_magazine.ingredients + 1] = {
      type = "item", name = "fw-gunpowder", amount = 1,
    }
  end
  add_unlock("military", "firearm-magazine")
end

local iron_pole = data.raw.recipe and data.raw.recipe["small-iron-electric-pole"]
if iron_pole then
  iron_pole.ingredients = {
    { type = "item", name = "iron-stick", amount = 4 },
    { type = "item", name = "copper-cable", amount = 4 },
  }
end
local wooden_pole = data.raw.recipe and data.raw.recipe["small-electric-pole"]
if wooden_pole then
  local ingredients = {
    { type = "item", name = "wood", amount = 1 },
    { type = "item", name = "copper-cable", amount = 2 },
  }
  wooden_pole.ingredients = table.deepcopy(ingredients)
  if wooden_pole.normal then wooden_pole.normal.ingredients = table.deepcopy(ingredients) end
  if wooden_pole.expensive then wooden_pole.expensive.ingredients = table.deepcopy(ingredients) end
end

remove_ingredient("stone-wall", "fw-sensor-package")
remove_unlock("fw-precision-alloys", "fw-bearing")
remove_unlock("fw-precision-alloys", "fw-ceramic-insulator")

-- Bootstrap poles cannot consume a regulator that belongs to Flux synthesis.
-- Keep active regulation for the medium and large distribution tiers.
remove_ingredient("small-electric-pole", "fw-power-regulator")
remove_ingredient("small-iron-electric-pole", "fw-power-regulator")
remove_ingredient("burner-turbine", "fw-power-regulator")
remove_unlock("electricity", "fw-power-regulator")
local power_regulation = data.raw.technology and data.raw.technology["fw-power-regulation"]
if power_regulation then
  power_regulation.effects = power_regulation.effects or {}
  local has_regulator_unlock = false
  for _, effect in ipairs(power_regulation.effects) do
    if effect.type == "unlock-recipe" and effect.recipe == "fw-power-regulator" then has_regulator_unlock = true end
  end
  if not has_regulator_unlock then
    power_regulation.effects[#power_regulation.effects + 1] = {
      type = "unlock-recipe", recipe = "fw-power-regulator",
    }
  end
end

-- The first refinery creates the oil products needed for lubricant. Its shell
-- therefore uses ordinary engines; electric-engine upgrades belong downstream.
remove_ingredient("oil-refinery", "electric-engine-unit")
local refinery = data.raw.recipe and data.raw.recipe["oil-refinery"]
if refinery then
  for _, ingredient in ipairs(refinery.ingredients or {}) do
    if entry_name(ingredient) == "engine-unit" then ingredient.amount = math.max(ingredient.amount or 1, 4) end
  end
end

-- Restore a practical early-game envelope. Basic defense, visibility, steam,
-- and rail transport should introduce later FluxWorks disciplines, not wait
-- for complete sensing, elastomer, or fabrication branches.
remove_prerequisite("gun-turret", "fw-systems-integration")
remove_prerequisite("stone-wall", "fw-systems-integration")
remove_prerequisite("stone-wall", "fw-material-refinement")
remove_prerequisite("radar", "fw-signal-routing")
remove_prerequisite("military", "fw-material-foundations")
remove_prerequisite("military", "sulfur-processing")
remove_prerequisite("steam-power", "fluid-handling")
remove_prerequisite("steam-power", "fw-elastomer-engineering")
add_prerequisite("steam-power", "basic-fluid-handling")
remove_prerequisite("railway", "fw-metals-fabrication")
remove_prerequisite("railway", "fw-beam-engineering")

remove_ingredient("stone-wall", "fw-cermet")
remove_ingredient("small-lamp", "fw-signal-conduit")
remove_ingredient("radar", "fw-signal-conduit")
remove_ingredient("radar", "fw-power-regulator")
remove_ingredient("radar", "fw-lens-array")
add_unlock("electricity", "small-lamp")

-- Recipes presented as basic infrastructure and conventional military gear
-- use basic stock. Sensors, metal mesh, seals, and specialty alloys remain
-- meaningful ingredients for the later tiers that introduce them.
remove_ingredient("boiler", "fw-reinforced-seal")
for _, recipe_name in ipairs({ "rail", "locomotive", "cargo-wagon" }) do
  remove_ingredient(recipe_name, "bronze-plate")
  remove_ingredient(recipe_name, "fw-aluminum-beam")
end
for _, recipe_name in ipairs({
  "gun-turret", "concrete-wall", "steel-wall", "gate", "land-mine",
  "defender-capsule", "poison-capsule", "slowdown-capsule",
}) do remove_ingredient(recipe_name, "fw-sensor-package") end
for _, recipe_name in ipairs({
  "heavy-armor", "piercing-rounds-magazine", "shotgun", "shotgun-shell", "submachine-gun",
}) do remove_ingredient(recipe_name, "fw-metal-mesh") end
remove_ingredient("gate", "fw-cermet")
replace_ingredient("fw-gunpowder", "sulfur", {
  type = "item", name = "coal", amount = 1,
})
add_prerequisite("gate", "steel-processing")
add_prerequisite("steel-walls", "fw-beam-engineering")
add_prerequisite("defender", "electronics")
add_prerequisite("advanced-material-processing-2", "fw-electromechanical-systems")
remove_unlock("logistics-2", "fw-solder-wire")
remove_unlock("logistics-2", "fw-control-assembly")
remove_unlock("logistics-2", "fw-signal-conduit")
remove_ingredient("fast-splitter", "fw-signal-conduit")
add_unlock("fw-conductive-assembly", "fw-solder-alloy")
add_unlock("fw-conductive-assembly", "fw-solder-wire")

-- AAI's basic pipe milestone is the bridge from the first electrical research
-- to conventional steam power, not a late multi-discipline checkpoint.
local basic_fluids = data.raw.technology and data.raw.technology["basic-fluid-handling"]
if basic_fluids then
  basic_fluids.prerequisites = { "electricity" }
  if basic_fluids.unit then
    basic_fluids.unit.count = 10
    basic_fluids.unit.ingredients = { { "automation-science-pack", 1 } }
  end
end
local steam_power = data.raw.technology and data.raw.technology["steam-power"]
if steam_power and steam_power.unit then
  steam_power.unit.count = 20
  steam_power.unit.ingredients = { { "automation-science-pack", 1 } }
end

-- Fluid-fed drills are an early mining capability. Compatibility passes may
-- weave this node into later chemistry, so restore its final bootstrap shape.
local liquid_mining = data.raw.technology and data.raw.technology["fw-liquid-mining"]
if liquid_mining then
  liquid_mining.prerequisites = { "electric-mining-drill" }
  liquid_mining.unit = liquid_mining.unit or {}
  liquid_mining.unit.count = 20
  liquid_mining.unit.time = 15
  liquid_mining.unit.ingredients = { { "automation-science-pack", 1 } }
end

-- Electricity establishes only bootstrap electrical capability. Every more
-- advanced assembly remains on its dedicated technology lane.
for _, recipe_name in ipairs({
  "fw-transformer-core", "fw-control-assembly", "fw-capacitor", "fw-tinned-cable",
  "fw-inductor-coil", "bronze-plate", "fw-solder-alloy", "fw-circuit-substrate",
  "fw-chip-carrier", "fw-solder-wire", "fw-circuit-contact", "fw-silicon-wafer",
}) do remove_unlock("electricity", recipe_name) end

-- Crushing should immediately create a useful smelting lane. Retire the
-- one-purpose follow-up technology and redirect its dependants to crushing.
local dense_ore = data.raw.technology and data.raw.technology["fw-dense-ore-smelting"]
if dense_ore then
  for _, effect in ipairs(dense_ore.effects or {}) do
    if effect.type == "unlock-recipe" then add_unlock("fw-ore-crushing", effect.recipe) end
  end
  dense_ore.effects = {}
  dense_ore.prerequisites = {}
  dense_ore.hidden = true
  dense_ore.enabled = false
  for _, technology in pairs(data.raw.technology or {}) do
    for index = #(technology.prerequisites or {}), 1, -1 do
      if technology.prerequisites[index] == "fw-dense-ore-smelting" then
        technology.prerequisites[index] = "fw-ore-crushing"
      end
    end
  end
end

-- Precision Alloys became an empty duplicate after bearings and insulators
-- were moved to their real bootstrap owners.
local precision_alloys = data.raw.technology and data.raw.technology["fw-precision-alloys"]
if precision_alloys and #(precision_alloys.effects or {}) == 0 then
  precision_alloys.prerequisites = {}
  precision_alloys.hidden = true
  precision_alloys.enabled = false
  for _, technology in pairs(data.raw.technology or {}) do
    for index = #(technology.prerequisites or {}), 1, -1 do
      if technology.prerequisites[index] == "fw-precision-alloys" then
        technology.prerequisites[index] = "fw-metals-fabrication"
      end
    end
  end
end

-- Redirecting retired one-purpose nodes can converge on a prerequisite a
-- technology already had. Factorio requires each prerequisite exactly once.
for _, technology in pairs(data.raw.technology or {}) do
  local seen = {}
  for index = #(technology.prerequisites or {}), 1, -1 do
    local prerequisite = technology.prerequisites[index]
    if seen[prerequisite] then
      table.remove(technology.prerequisites, index)
    else
      seen[prerequisite] = true
    end
  end
end

-- Player-facing research numbers use clean five-step increments.
for name, technology in pairs(data.raw.technology or {}) do
  local unit = technology.unit
  if string.sub(name, 1, 3) == "fw-" and unit and not unit.count_formula then
    if type(unit.count) == "number" then unit.count = math.max(5, math.floor((unit.count + 2.5) / 5) * 5) end
    if type(unit.time) == "number" then unit.time = math.max(5, math.floor((unit.time + 2.5) / 5) * 5) end
  end
end

-- Promethium impacts are legible endgame deposits: even a capable drill needs
-- an established Matter Flux supply before it can extract their shards.
local promethium_impact = data.raw.resource and data.raw.resource["fw-promethium-impact"]
if promethium_impact and promethium_impact.minable then
  promethium_impact.minable.required_fluid = "fw-purple-flux"
  promethium_impact.minable.fluid_amount = 10
end

-- Keep the crushing family together and in geological order instead of
-- falling back to prototype-name order in Intermediate Products.
for index, ore_name in ipairs({ "iron", "copper", "tin", "lead", "bauxite", "titanium" }) do
  local order = string.format("b[crushed-ore]-%02d[%s]", index, ore_name)
  local item_name = "fw-crushed-" .. ore_name .. "-ore"
  local item = data.raw.item and data.raw.item[item_name]
  local recipe = data.raw.recipe and data.raw.recipe[item_name]
  local recycling = data.raw.recipe and data.raw.recipe[item_name .. "-recycling"]
  if item then item.order = order end
  if recipe then recipe.order = order end
  if recycling then recycling.order = order .. "-z[recycling]" end
end

-- Lead with the sulfuric-acid product rather than the chlorine reagent.
local acid_synthesis = data.raw.recipe and data.raw.recipe["fw-acid-synthesis"]
local sulfuric_acid = data.raw.fluid and data.raw.fluid["sulfuric-acid"]
if acid_synthesis and sulfuric_acid then
  acid_synthesis.icon = sulfuric_acid.icon
  acid_synthesis.icon_size = sulfuric_acid.icon_size
  acid_synthesis.icons = sulfuric_acid.icons and table.deepcopy(sulfuric_acid.icons) or nil
end

-- Preserve the richer rail bill while restoring a useful infrastructure batch.
local rail = data.raw.recipe and data.raw.recipe.rail
if rail then
  for _, result in ipairs(rail.results or {}) do
    if entry_name(result) == "rail" then result.amount = math.max(result.amount or 1, 4) end
  end
end

-- A 60 kW panel should not carry late-machine economics.
remove_ingredient("solar-panel", "fw-power-regulator")
remove_ingredient("solar-panel", "fw-copper-tube")

-- Keep the first fluid milestone focused on pipes, pumps, tanks, and barrels.
-- These recipes already have their own later technology owners.
for _, recipe_name in ipairs({
  "fw-cermet", "fw-composite-panel", "fw-pressure-housing", "fw-field-winding",
  "electric-engine-unit", "fw-coil-block", "lubricant", "fw-cryo-coil", "fw-thermal-buffer",
}) do
  remove_unlock("fluid-handling", recipe_name)
end

-- Underground pipes are an extension of the base pipe network, not a reason
-- to introduce a separate formed-metal intermediate.
remove_ingredient("pipe-to-ground", "fw-copper-tube")
remove_ingredient("storage-tank", "fw-thermal-buffer")

-- Keep mineable fuels with the other raw resources in the player catalog.
local coal = data.raw.item and data.raw.item.coal
if coal then coal.subgroup = "raw-resource"; coal.order = "a[coal]" end
local coal_recycling = data.raw.recipe and data.raw.recipe["coal-recycling"]
if coal_recycling then coal_recycling.subgroup = "raw-resource" end

-- Like the vanilla chemical/production packs, factory-scale domain science is
-- assembled in machines rather than by hand.
for _, recipe_name in ipairs({
  "fw-industrial-methods-science-pack", "fw-systems-analysis-science-pack",
}) do
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if recipe then recipe.category = "advanced-crafting"; recipe.categories = nil end
end

-- Second Nauvis playtest pass: foundational alloys must work in ordinary
-- furnaces, while regulated hardware belongs to the green-science assembler
-- lane rather than late specialist machines.
for _, recipe_name in ipairs({ "bronze-plate", "fw-solder-alloy" }) do
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if recipe then recipe.category = "smelting"; recipe.categories = nil end
end
for _, recipe_name in ipairs({ "fw-pressure-housing", "fw-flow-regulator" }) do
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if recipe then recipe.category = "advanced-crafting"; recipe.categories = nil end
end

local fluid_regulation = data.raw.technology and data.raw.technology["fw-fluid-regulation"]
if fluid_regulation then
  fluid_regulation.prerequisites = { "fw-metals-fabrication", "engine", "logistic-science-pack" }
  fluid_regulation.unit = fluid_regulation.unit or {}
  fluid_regulation.unit.ingredients = {
    { "automation-science-pack", 1 },
    { "logistic-science-pack", 1 },
  }
end
for technology_name in pairs(data.raw.technology or {}) do
  if technology_name ~= "fw-fluid-regulation" then
    remove_unlock(technology_name, "fw-pressure-housing")
    remove_unlock(technology_name, "fw-flow-regulator")
  end
end
add_unlock("fw-fluid-regulation", "fw-pressure-housing")
add_unlock("fw-fluid-regulation", "fw-flow-regulator")
add_prerequisite("railway", "fw-fluid-regulation")

-- Crushing is an actual processing upgrade: two raw ore become three crushed
-- ore, and three crushed ore become three plates (or two aluminum plates).
local crushed_plate_outputs = {
  ["iron-plate-from-crushed"] = 3,
  ["copper-plate-from-crushed"] = 3,
  ["tin-plate-from-crushed"] = 3,
  ["lead-plate-from-crushed"] = 3,
  ["titanium-plate-from-crushed"] = 3,
  ["aluminum-plate-from-crushed-bauxite"] = 2,
}
for recipe_name, amount in pairs(crushed_plate_outputs) do
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if recipe and recipe.results and recipe.results[1] then recipe.results[1].amount = amount end
end

-- Make each early component have one clear research owner.
remove_unlock("fw-structural-fabrication", "fw-iron-beam")
remove_unlock("fw-structural-fabrication", "fw-circuit-contact-leaded")
remove_unlock("fw-structural-fabrication", "fw-inline-filter")
add_unlock("fw-material-foundations", "fw-inline-filter")
add_unlock("fw-conductive-assembly", "fw-circuit-contact-leaded")
replace_ingredient("fw-inline-filter", "fw-rubber-sheet", {
  type = "item", name = "stone-brick", amount = 1,
})
replace_ingredient("fw-pressure-housing", "fw-cermet", {
  type = "item", name = "steel-plate", amount = 1,
})

for technology_name in pairs(data.raw.technology or {}) do
  if technology_name ~= "fw-structural-fabrication" then
    remove_unlock(technology_name, "fw-steel-beam")
  end
end
add_unlock("fw-structural-fabrication", "fw-steel-beam")

for _, recipe_name in ipairs({
  "fw-tinned-cable", "fw-circuit-substrate", "fw-chip-carrier", "fw-silicon-wafer",
}) do remove_unlock("logistics-2", recipe_name) end
for technology_name in pairs(data.raw.technology or {}) do
  if technology_name ~= "electronics" then remove_unlock(technology_name, "fw-tinned-cable") end
end
add_unlock("electronics", "fw-tinned-cable")
for recipe_name, owner in pairs({
  ["fw-solder-alloy"] = "electronics",
  ["fw-solder-wire"] = "advanced-circuit",
}) do
  for technology_name in pairs(data.raw.technology or {}) do
    if technology_name ~= owner then remove_unlock(technology_name, recipe_name) end
  end
  add_unlock(owner, recipe_name)
end

add_prerequisite("fw-mineral-beneficiation", "logistic-science-pack")
for _, prerequisite in ipairs({ "chemical-science-pack", "fw-industrial-methods-science" }) do
  add_prerequisite("fw-precision-ceramics-1", prerequisite)
end

-- Burner Mechanics is an automatic ten-plate compatibility trigger. Keep it
-- functional without leaving an isolated completed node in established saves.
local burner_mechanics = data.raw.technology and data.raw.technology["burner-mechanics"]
if burner_mechanics then burner_mechanics.hidden = true end

-- Aluminum beams are structural stock, not a glass composite.
local aluminum_beam = data.raw.recipe and data.raw.recipe["fw-aluminum-beam"]
if aluminum_beam then
  aluminum_beam.ingredients = { { type = "item", name = "aluminum-plate", amount = 2 } }
end

-- Use a silicon-facing research sprite for the silicon beneficiation node.
local mineral_beneficiation = data.raw.technology and data.raw.technology["fw-mineral-beneficiation"]
local silicon = data.raw.item and data.raw.item.silicon
if mineral_beneficiation and silicon then
  mineral_beneficiation.icon = silicon.icon
  mineral_beneficiation.icon_size = silicon.icon_size
  mineral_beneficiation.icons = silicon.icons and table.deepcopy(silicon.icons) or nil
end

-- Present fuels and all vanilla/Space Age barrels with their chemical peers.
local solid_fuel = data.raw.item and data.raw.item["solid-fuel"]
if solid_fuel then solid_fuel.subgroup = "fw-chemistry-petrochem"; solid_fuel.order = "d[petrochem]-h[solid-fuel]" end
for _, recipe_name in ipairs({
  "solid-fuel-from-heavy-oil", "solid-fuel-from-light-oil",
  "solid-fuel-from-petroleum-gas", "solid-fuel-from-ammonia", "solid-fuel-recycling",
}) do
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if recipe then recipe.subgroup = "fw-chemistry-petrochem" end
end
for _, item_name in ipairs({
  "water-barrel", "fluoroketone-hot-barrel", "fluoroketone-cold-barrel",
}) do
  local item = data.raw.item and data.raw.item[item_name]
  if item then item.subgroup = "fw-chemistry-barrels" end
end
for _, recipe_name in ipairs({
  "water-barrel", "empty-water-barrel",
  "fluoroketone-hot-barrel", "empty-fluoroketone-hot-barrel",
  "fluoroketone-cold-barrel", "empty-fluoroketone-cold-barrel",
  "water-barrel-recycling", "fluoroketone-hot-barrel-recycling",
  "fluoroketone-cold-barrel-recycling",
}) do
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if recipe then recipe.subgroup = "fw-chemistry-barrels" end
end

-- Player-facing crafting times use quarter-second increments rather than
-- belt-derived decimals that are difficult to read and plan around.
for recipe_name, recipe in pairs(data.raw.recipe or {}) do
  if string.sub(recipe_name, 1, 3) == "fw-" and type(recipe.energy_required) == "number" then
    recipe.energy_required = math.max(0.25, math.floor(recipe.energy_required * 4 + 0.5) / 4)
  end
end

-- Refined silicon is useful well beyond the first Crusher. Give it a dedicated
-- category shared by the Crusher, Industrial Furnace, and Arc Foundry without
-- allowing basic stone furnaces to perform beneficiation.
if not (data.raw["recipe-category"] and data.raw["recipe-category"]["fw-silicon-refining"]) then
  data:extend({ { type = "recipe-category", name = "fw-silicon-refining" } })
end
local silicon_beneficiation = data.raw.recipe and data.raw.recipe["fw-silicon-beneficiation"]
if silicon_beneficiation then
  silicon_beneficiation.category = "fw-silicon-refining"
  silicon_beneficiation.categories = nil
end
for _, spec in ipairs({
  { "assembling-machine", "crusher" },
  { "assembling-machine", "industrial-furnace" },
  { "assembling-machine", "fw-arc-foundry" },
}) do
  local machine = data.raw[spec[1]] and data.raw[spec[1]][spec[2]]
  if machine then
    machine.crafting_categories = machine.crafting_categories or {}
    local present = false
    for _, category in ipairs(machine.crafting_categories) do
      if category == "fw-silicon-refining" then present = true end
    end
    if not present then machine.crafting_categories[#machine.crafting_categories + 1] = "fw-silicon-refining" end
  end
end

-- Other planets may add placement conditions to the vanilla lightning
-- collector. Widen each numeric condition just enough to include the Shattered
-- Planet instead of deleting the other mod's restriction wholesale.
local shattered_planet = data.raw.planet and data.raw.planet["shattered-planet"]
local lightning_collector = data.raw["lightning-attractor"]
  and data.raw["lightning-attractor"]["lightning-collector"]
for _, condition in ipairs((lightning_collector and lightning_collector.surface_conditions) or {}) do
  local property = condition.property
  local surface_property = data.raw["surface-property"] and data.raw["surface-property"][property]
  local value = shattered_planet and shattered_planet.surface_properties
    and shattered_planet.surface_properties[property]
    or surface_property and surface_property.default_value
  if type(value) == "number" then
    if condition.min and value < condition.min then condition.min = value end
    if condition.max and value > condition.max then condition.max = value end
  end
end

-- Science Extra Trigger Techs 1.0.3 looks up a technology using each science
-- pack's item name. FluxWorks' public research nodes omit the trailing '-pack',
-- so provide compatibility aliases before that mod's final-fixes pass.
if mods["science-extra-trigger-techs"] then
  for _, pair in ipairs({
    { "fw-industrial-methods-science-pack", "fw-industrial-methods-science" },
    { "fw-systems-analysis-science-pack", "fw-systems-analysis-science" },
  }) do
    local alias_name, owner_name = pair[1], pair[2]
    local owner = data.raw.technology and data.raw.technology[owner_name]
    if owner and not data.raw.technology[alias_name] then
      data:extend({ {
        type = "technology",
        name = alias_name,
        icon = owner.icon,
        icon_size = owner.icon_size,
        icons = owner.icons and table.deepcopy(owner.icons) or nil,
        prerequisites = { owner_name },
        unit = table.deepcopy(owner.unit),
        effects = {},
        hidden = true,
        order = owner.order .. "-compat-trigger",
      } })
    end
  end
end
