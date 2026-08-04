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

assert_report(not recipe_has("fw-microchip", "advanced-circuit"), "microchips recreate the red-circuit cycle")
assert_report(not recipe_has("plastic-bar", "carbon"), "the first plastic recipe has redundant carbon")
assert_report(not tech_uses("fw-propellant-synthesis", "cryogenic-science-pack"), "propellant waits for Aquilo")
assert_report(not tech_uses("fw-flux-catalysis", "cryogenic-science-pack"), "Flux catalysis waits for Aquilo")
if not Startup.enabled("fw-skip-burner-stage", false) then
  assert_report(data.raw.technology.electricity.unit.count == 10, "Electricity is not a 10-pack bootstrap")
end
assert_report(not recipe_has("stone-wall", "fw-sensor-package"), "stone walls still require sensors")
assert_report(not tech_unlocks("fw-precision-alloys", "fw-bearing"), "bearings are unlocked twice")
assert_report(not tech_unlocks("fw-precision-alloys", "fw-ceramic-insulator"), "insulators are unlocked twice")
assert_report(not recipe_has("solar-panel", "fw-power-regulator"), "solar panels still use power regulators")
assert_report(not recipe_has("solar-panel", "fw-copper-tube"), "solar panels still use formed tubes")
assert_report(not data.raw.resource.stone.minable.required_fluid, "stone mining still requires fluid")
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
