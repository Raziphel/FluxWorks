local Startup = require("prototypes.lib.startup-settings")

local function entry_name(entry)
  return type(entry) == "table" and (entry.name or entry[1]) or nil
end

local function recipe_has(recipe_name, ingredient_name)
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  for _, ingredient in ipairs((recipe and recipe.ingredients) or {}) do
    if entry_name(ingredient) == ingredient_name then return true end
  end
  return false
end

local function tech_uses(technology_name, science_name)
  local technology = data.raw.technology and data.raw.technology[technology_name]
  for _, ingredient in ipairs((technology and technology.unit and technology.unit.ingredients) or {}) do
    if entry_name(ingredient) == science_name then return true end
  end
  return false
end

local function tech_unlocks(technology_name, recipe_name)
  local technology = data.raw.technology and data.raw.technology[technology_name]
  for _, effect in ipairs((technology and technology.effects) or {}) do
    if effect.type == "unlock-recipe" and effect.recipe == recipe_name then return true end
  end
  return false
end

local function assert_report(condition, message)
  if not condition then error("FluxWorks playtest-report regression: " .. message) end
end

local function tech_requires(technology_name, prerequisite_name)
  for _, prerequisite in ipairs((data.raw.technology[technology_name] or {}).prerequisites or {}) do
    if prerequisite == prerequisite_name then return true end
  end
  return false
end

local function unlock_count(recipe_name)
  local count = 0
  for _, technology in pairs(data.raw.technology or {}) do
    for _, effect in ipairs(technology.effects or {}) do
      if effect.type == "unlock-recipe" and effect.recipe == recipe_name then count = count + 1 end
    end
  end
  return count
end

assert_report(not recipe_has("fw-microchip", "advanced-circuit"), "microchips recreate the red-circuit cycle")
assert_report(not recipe_has("plastic-bar", "carbon"), "the first plastic recipe has redundant carbon")
assert_report(not tech_uses("fw-propellant-synthesis", "cryogenic-science-pack"), "propellant waits for Aquilo")
assert_report(not tech_uses("fw-flux-catalysis", "cryogenic-science-pack"), "Flux catalysis waits for Aquilo")
if not Startup.enabled("fw-skip-burner-stage", false) then
  assert_report(data.raw.technology.electricity.unit.count == 10, "Electricity is not a 10-pack bootstrap")
end
assert_report(not recipe_has("stone-wall", "fw-sensor-package"), "stone walls still require sensors")
assert_report(not recipe_has("steam-engine", "bronze-plate"), "bootstrap steam engine still requires bronze")
assert_report(not recipe_has("crusher", "electronic-circuit"), "crusher still requires its own silicon-gated circuit output")
assert_report(tech_unlocks("fw-comminution", "fw-silicon-beneficiation"),
  "Crusher research does not unlock the bootstrap silicon route")
assert_report(not tech_unlocks("fw-mineral-beneficiation", "fw-silicon-beneficiation"),
  "bootstrap silicon beneficiation still waits for the later mineral technology")
assert_report((data.raw.recipe["fw-carbon-refining"].categories or {})[1] == "basic-crushing",
  "refined carbon can still be selected by fuel-burning furnaces")
assert_report(data.raw.technology.automation.unit.count == 10,
  "Automation does not retain its 10-pack cost")
assert_report(not (function()
  for _, prerequisite in ipairs(data.raw.technology.automation.prerequisites or {}) do
    if prerequisite == "electric-mining-drill" then return true end
  end
  return false
end)(), "Automation still waits for electric mining drills")
assert_report(tech_unlocks("military", "fw-gunpowder-early"),
  "Military does not unlock primitive gunpowder")
assert_report((data.raw.recipe["fw-gunpowder"].categories or {})[1] == "chemistry",
  "regular gunpowder is not restricted to chemical machines")
for technology_name, technology in pairs(data.raw.technology or {}) do
  if technology_name ~= "fw-electromechanical-systems" then
    assert_report(not tech_unlocks(technology_name, "silicon"),
      "regular silicon is prematurely unlocked by " .. technology_name)
  end
  if technology_name ~= "fw-propellant-synthesis" then
    assert_report(not tech_unlocks(technology_name, "fw-gunpowder"),
      "chemical gunpowder is prematurely unlocked by " .. technology_name)
  end
end
assert_report(tech_unlocks("fw-electromechanical-systems", "silicon"),
  "electromechanical systems does not unlock regular silicon")
assert_report(tech_unlocks("fw-propellant-synthesis", "fw-gunpowder"),
  "propellant synthesis does not unlock chemical gunpowder")
assert_report(not recipe_has("small-electric-pole", "fw-ceramic-insulator"),
  "the wooden bootstrap pole still requires a later ceramic insulator")
assert_report(not tech_unlocks("fw-precision-alloys", "fw-bearing"), "bearings are unlocked twice")
assert_report(not tech_unlocks("fw-precision-alloys", "fw-ceramic-insulator"), "insulators are unlocked twice")
assert_report(not recipe_has("solar-panel", "fw-power-regulator"), "solar panels still use power regulators")
assert_report(not recipe_has("solar-panel", "fw-copper-tube"), "solar panels still use formed tubes")
assert_report(not data.raw.resource.stone.minable.required_fluid, "stone mining still requires fluid")
local liquid_mining = data.raw.technology["fw-liquid-mining"]
assert_report(liquid_mining.unit.count == 20, "Fluid mining is not an early 20-pack milestone")
local liquid_prerequisites = {}
for _, prerequisite in ipairs(liquid_mining.prerequisites or {}) do liquid_prerequisites[prerequisite] = true end
assert_report(liquid_prerequisites["electric-mining-drill"] and not liquid_prerequisites["oil-processing"],
  "Fluid mining does not follow electric mining directly")
assert_report(tech_uses("fw-liquid-mining", "automation-science-pack")
  and not tech_uses("fw-liquid-mining", "logistic-science-pack")
  and not tech_uses("fw-liquid-mining", "chemical-science-pack"),
  "Fluid mining is not automation-science only")
local enables_fluid_mining = false
for _, effect in ipairs(liquid_mining.effects or {}) do
  if effect.type == "mining-with-fluid" and effect.modifier == true then enables_fluid_mining = true end
end
assert_report(enables_fluid_mining, "Fluid mining does not enable fluid-fed drills")
assert_report(data.raw.recipe["fw-silicon-beneficiation"].categories[1] == "fw-silicon-refining",
  "Refined Silicon remains exclusive to the bootstrap crushing category")
for _, machine_name in ipairs({ "crusher", "industrial-furnace", "fw-arc-foundry" }) do
  local machine = data.raw["assembling-machine"] and data.raw["assembling-machine"][machine_name]
  local supports_silicon = false
  for _, category in ipairs((machine and machine.crafting_categories) or {}) do
    if category == "fw-silicon-refining" then supports_silicon = true end
  end
  assert_report(supports_silicon, machine_name .. " cannot process Refined Silicon")
end
assert_report(not recipe_has("pumpjack", "fw-alumina-refractory"), "pumpjacks still require alumina refractory")
assert_report(not recipe_has("oil-refinery", "lubricant"), "the refinery still requires its own lubricant output")
assert_report(not recipe_has("oil-refinery", "electric-engine-unit"),
  "the first refinery still requires lubricant-gated electric engines")
assert_report(not recipe_has("small-electric-pole", "fw-power-regulator"),
  "the wooden bootstrap pole still requires a power regulator")
assert_report(not recipe_has("small-iron-electric-pole", "fw-power-regulator"),
  "the iron bootstrap pole still requires a power regulator")
assert_report(not recipe_has("burner-turbine", "fw-power-regulator"),
  "the bootstrap turbine still requires a power regulator")
assert_report(not tech_unlocks("electricity", "fw-power-regulator"),
  "Electricity still unlocks the late power regulator")
assert_report(tech_unlocks("fw-power-regulation", "fw-power-regulator"),
  "Power Regulation does not unlock its regulator")
assert_report(data.raw.technology["fw-dense-ore-smelting"].hidden == true,
  "dense ore smelting remains a one-purpose delay after ore crushing")
assert_report(data.raw.technology["fw-precision-alloys"].hidden == true,
  "empty Precision Alloys research remains visible")
for _, recipe_name in ipairs({
  "iron-plate-from-crushed", "copper-plate-from-crushed", "tin-plate-from-crushed",
  "aluminum-plate-from-crushed-bauxite", "lead-plate-from-crushed", "titanium-plate-from-crushed",
}) do
  assert_report(tech_unlocks("fw-ore-crushing", recipe_name),
    "ore crushing does not immediately unlock useful smelting recipe " .. recipe_name)
end
for _, recipe_name in ipairs({
  "fw-transformer-core", "fw-control-assembly", "fw-capacitor", "fw-tinned-cable",
  "fw-inductor-coil", "bronze-plate", "fw-solder-alloy", "fw-circuit-substrate",
  "fw-chip-carrier", "fw-solder-wire", "fw-circuit-contact", "fw-silicon-wafer",
}) do
  assert_report(not tech_unlocks("electricity", recipe_name),
    "Electricity still unlocks advanced fabrication recipe " .. recipe_name)
end
assert_report(data.raw.resource["fw-promethium-impact"].minable.required_fluid == "fw-purple-flux",
  "promethium impacts can still be mined without endgame Flux handling")
assert_report(not recipe_has("fw-bearing", "engine-unit"), "bearings are still made from engines")
assert_report(not recipe_has("pipe-to-ground", "fw-copper-tube"), "underground pipes still use an unrelated tube")
assert_report(not recipe_has("storage-tank", "fw-thermal-buffer"), "basic storage tanks still require thermal buffers")
assert_report(data.raw.item.coal.subgroup == "raw-resource", "coal is not grouped with raw resources")
assert_report(data.raw.item["fw-salt"].subgroup == "raw-resource", "salt is not grouped with raw resources")
for _, deposit_name in ipairs({ "fw-metallic-deposit", "fw-mineral-deposit", "fw-carbonic-deposit" }) do
  assert_report(data.raw.resource[deposit_name].subgroup == "raw-resource",
    deposit_name .. " is left in the unsorted filter group")
end
assert_report(recipe_has("pipe", "lead-plate") and not recipe_has("pipe", "iron-plate"),
  "the primary pipe family has not been restored to lead")
if Startup.enabled("fw-skip-burner-stage", false) then
  assert_report(data.raw.recipe["automation-science-pack"].categories[1] == "crafting",
    "skip-burner automation science cannot be handcrafted")
  for _, recipe_name in ipairs({ "burner-inserter", "burner-mining-drill" }) do
    assert_report(data.raw.recipe[recipe_name].enabled ~= false and not data.raw.recipe[recipe_name].hidden,
      recipe_name .. " is unobtainable in skip-burner mode")
  end
end
for setting_name in pairs(data.raw["string-setting"] or {}) do
  assert_report(not string.match(setting_name, "^fw%-worldgen%-.+%-profile$"),
    "redundant resource profile setting remains: " .. setting_name)
end
local industrial_science = data.raw.recipe["fw-industrial-methods-science-pack"]
local systems_science = data.raw.recipe["fw-systems-analysis-science-pack"]
assert_report((industrial_science.categories and industrial_science.categories[1]) == "advanced-crafting",
  "industrial methods science can still be handcrafted")
assert_report((systems_science.categories and systems_science.categories[1]) == "advanced-crafting",
  "systems analysis science can still be handcrafted")
for _, recipe_name in ipairs({
  "fw-cermet", "fw-composite-panel", "fw-pressure-housing", "fw-field-winding",
  "electric-engine-unit", "fw-coil-block", "lubricant", "fw-cryo-coil", "fw-thermal-buffer",
}) do
  assert_report(not tech_unlocks("fluid-handling", recipe_name),
    "fluid handling still unlocks unrelated recipe " .. recipe_name)
end

for _, recipe_name in ipairs({ "bronze-plate", "fw-solder-alloy" }) do
  assert_report(data.raw.recipe[recipe_name].categories[1] == "smelting",
    recipe_name .. " still requires a specialist furnace")
end
for _, recipe_name in ipairs({ "fw-pressure-housing", "fw-flow-regulator" }) do
  assert_report(data.raw.recipe[recipe_name].categories[1] == "advanced-crafting",
    recipe_name .. " still requires an endgame specialist machine")
  assert_report(tech_unlocks("fw-fluid-regulation", recipe_name) and unlock_count(recipe_name) == 1,
    recipe_name .. " does not have Fluid Regulation as its single owner")
end
assert_report(not tech_uses("fw-fluid-regulation", "chemical-science-pack"),
  "Fluid Regulation still waits for chemical science")
assert_report(tech_requires("railway", "fw-fluid-regulation"),
  "Railway does not establish the regulator branch it consumes")

for recipe_name, amount in pairs({
  ["iron-plate-from-crushed"] = 3,
  ["copper-plate-from-crushed"] = 3,
  ["tin-plate-from-crushed"] = 3,
  ["lead-plate-from-crushed"] = 3,
  ["titanium-plate-from-crushed"] = 3,
  ["aluminum-plate-from-crushed-bauxite"] = 2,
}) do
  assert_report(data.raw.recipe[recipe_name].results[1].amount == amount,
    recipe_name .. " lost its crushing yield advantage")
end

assert_report(data.raw.technology["burner-mechanics"].hidden == true,
  "automatic Burner Mechanics remains as an isolated visible technology")
assert_report(tech_requires("fw-mineral-beneficiation", "logistic-science-pack"),
  "Mineral Beneficiation consumes green science without requiring its unlock")
assert_report(tech_unlocks("fw-material-foundations", "fw-iron-beam") and unlock_count("fw-iron-beam") == 1,
  "Iron Beam does not have Material Foundations as its single owner")
assert_report(tech_unlocks("fw-material-foundations", "fw-inline-filter") and unlock_count("fw-inline-filter") == 1,
  "Inline Filter does not have Material Foundations as its single owner")
assert_report(tech_unlocks("fw-conductive-assembly", "fw-circuit-contact-leaded")
  and unlock_count("fw-circuit-contact-leaded") == 1,
  "Leaded Circuit Contact is not reserved for Conductive Assembly")
assert_report(tech_unlocks("fw-structural-fabrication", "fw-steel-beam") and unlock_count("fw-steel-beam") == 1,
  "Steel Beam does not have Structural Fabrication as its single owner")
assert_report(tech_unlocks("electronics", "fw-solder-alloy") and unlock_count("fw-solder-alloy") == 1,
  "Solder Alloy does not have Electronics as its single owner")
assert_report(tech_unlocks("advanced-circuit", "fw-solder-wire") and unlock_count("fw-solder-wire") == 1,
  "Solder Wire does not have Advanced Circuits as its single owner")

for _, recipe_name in ipairs({
  "fw-tinned-cable", "fw-circuit-substrate", "fw-chip-carrier", "fw-silicon-wafer",
}) do
  assert_report(not tech_unlocks("logistics-2", recipe_name),
    "Logistics 2 still unlocks unrelated recipe " .. recipe_name)
end
assert_report(tech_requires("fw-precision-ceramics-1", "chemical-science-pack")
  and tech_requires("fw-precision-ceramics-1", "fw-industrial-methods-science"),
  "Precision Ceramics 1 lacks its science-pack technology prerequisites")

for _, ore_name in ipairs({ "iron", "copper", "tin", "lead", "bauxite", "titanium" }) do
  assert_report(data.raw.item["fw-crushed-" .. ore_name .. "-ore"].icon_size == 256,
    "crushed " .. ore_name .. " ore icon is outside the unified 256px family")
end
assert_report(data.raw.technology["fw-mineral-beneficiation"].icon == data.raw.item.silicon.icon,
  "Mineral Beneficiation still presents a carbon icon")
assert_report(data.raw.item["solid-fuel"].subgroup == "fw-chemistry-petrochem",
  "Solid Fuel remains in the Energy tab")
for _, barrel_name in ipairs({ "water-barrel", "fluoroketone-hot-barrel", "fluoroketone-cold-barrel" }) do
  assert_report(data.raw.item[barrel_name].subgroup == "fw-chemistry-barrels",
    barrel_name .. " remains outside Chemistry barrels")
end
assert_report(not recipe_has("fw-aluminum-beam", "glass"), "Aluminum Beam still consumes glass")
assert_report(data.raw.item["fw-elastomer-matrix"].icon ~= data.raw.item["fw-rubber-sheet"].icon,
  "Elastomer Matrix still shares the Rubber Sheet icon")
assert_report(not data.raw.technology["fw-aai-bulk-storage"],
  "FluxWorks still duplicates AAI's bulk-storage unlock technology")
for recipe_name, recipe in pairs(data.raw.recipe or {}) do
  if string.sub(recipe_name, 1, 3) == "fw-" and type(recipe.energy_required) == "number" then
    assert_report(math.abs(recipe.energy_required * 4 - math.floor(recipe.energy_required * 4 + 0.5)) < 0.0001,
      recipe_name .. " has a crafting time outside quarter-second increments")
  end
end

if mods["science-extra-trigger-techs"] then
  for _, technology_name in ipairs({
    "fw-industrial-methods-science-pack", "fw-systems-analysis-science-pack",
  }) do
    assert_report(data.raw.technology[technology_name],
      "Science Extra Trigger Techs compatibility alias is missing: " .. technology_name)
  end
end
