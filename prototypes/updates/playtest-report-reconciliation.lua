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
  liquid_mining.prerequisites = { "basic-fluid-handling" }
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
