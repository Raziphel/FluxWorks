if not mods["aai-industry"] then
  return
end

local Startup = require("prototypes.lib.startup-settings")
local skip_burner_stage = Startup.enabled("fw-skip-burner-stage", false)

local function ingredient_name(ingredient)
  return ingredient.name or ingredient[1]
end

local function recipe_has_ingredient(recipe_name, expected_ingredient)
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if not recipe then
    return false
  end

  for _, ingredient_set in ipairs({
    recipe.ingredients,
    recipe.normal and recipe.normal.ingredients or nil,
    recipe.expensive and recipe.expensive.ingredients or nil,
  }) do
    for _, ingredient in pairs(ingredient_set or {}) do
      if ingredient_name(ingredient) == expected_ingredient then
        return true
      end
    end
  end

  return false
end

local function assert_true(condition, message)
  if not condition then
    error(message)
  end
end

local function assert_recipe_lacks_ingredient(recipe_name, forbidden_ingredient, reason)
  if recipe_has_ingredient(recipe_name, forbidden_ingredient) then
    error(("AAI Industry integration failure: %s still depends on %s (%s)"):format(
      recipe_name,
      forbidden_ingredient,
      reason
    ))
  end
end

local function assert_recipe_has_ingredient(recipe_name, required_ingredient, reason)
  if not recipe_has_ingredient(recipe_name, required_ingredient) then
    error(("AAI Industry integration failure: %s is missing %s (%s)"):format(
      recipe_name,
      required_ingredient,
      reason
    ))
  end
end

local function recipe_ingredient_count(recipe_name)
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  return recipe and #(recipe.ingredients or {}) or 0
end

local function technology_has_prerequisite(technology_name, prerequisite_name)
  local technology = data.raw.technology and data.raw.technology[technology_name]
  for _, prerequisite in pairs(technology and technology.prerequisites or {}) do
    if prerequisite == prerequisite_name then return true end
  end
  return false
end

local function technology_unlocks_recipe(recipe_name)
  for _, technology in pairs(data.raw.technology or {}) do
    for _, effect in pairs(technology.effects or {}) do
      if effect.type == "unlock-recipe" and effect.recipe == recipe_name then
        return true
      end
    end
  end
  return false
end

local offshore_pump = data.raw["offshore-pump"] and data.raw["offshore-pump"]["offshore-pump"]
assert_true(offshore_pump ~= nil, "AAI Industry integration failure: missing offshore-pump prototype")
assert_true(
  offshore_pump.energy_source ~= nil and offshore_pump.energy_source.type == "electric",
  "AAI Industry integration failure: offshore-pump should remain electrically powered when AAI is active"
)
assert_true(
  not (data.raw.recipe and data.raw.recipe["electronic-circuit-wood"]),
  "AAI Industry integration failure: the alternate wood electronic-circuit recipe should be removed"
)
assert_true(
  not technology_unlocks_recipe("electronic-circuit-wood"),
  "AAI Industry integration failure: no technology should retain the removed wood electronic-circuit unlock"
)
assert_true(
  not (data.raw.item and data.raw.item["fw-drive-module"])
    and not (data.raw.recipe and data.raw.recipe["fw-drive-module"])
    and not technology_unlocks_recipe("fw-drive-module"),
  "AAI Industry integration failure: the retired Industrial Drive Module should not survive as an item, recipe, or unlock"
)

for _, assertion in ipairs({
  { "crusher", "motor", "the comminution machine should use AAI's established motor instead of a duplicate FluxWorks drive item" },
  { "fw-circuit-substrate", "stone-tablet", "substrates should consume AAI stone processing instead of leaving that branch ornamental" },
  { "fw-pressure-housing", "engine-unit", "pressure-rated structure should explicitly sit on AAI's engine branch instead of feeling like a static shell" },
  { "fw-control-assembly", "electric-motor", "control hardware should pull from AAI's powered assembly lane" },
  { "fw-transformer-core", "electric-motor", "mid-tier electrical hardware should inherit AAI's motorized progression" },
  { "fw-signal-conduit", "electric-motor", "signal-routing hardware should show the shared AAI electric motor spine instead of only passive conductors" },
  { "fw-flow-regulator", "electric-motor", "regulated fluid hardware should use AAI's powered actuator branch instead of treating motion as abstract" },
  { "fw-power-regulator", "electric-motor", "powered regulators should visibly consume AAI's electric motor branch" },
  { "fw-field-winding", "electric-engine-unit", "late electromagnetic hardware should promote the full AAI electric engine chain into FluxWorks machinery" },
  { "fw-harvester-head", "electric-motor", "the quarry head should visibly consume AAI motor hardware instead of pretending the cutting assembly is static" },
  { "fw-rocket-engine", "engine-unit", "rocket engines should visibly inherit the lower AAI engine ladder instead of skipping straight to the electric engine shell" },
  { "fw-petrochemical-facility", "motor", "petrochemical plants should show the shared AAI motor backbone in their frame" },
  { "fw-hydraulic-plant", "electric-motor", "hydraulic plants should consume AAI's powered actuation parts directly" },
  { "fw-hydraulic-manifold", "motor", "hydraulic manifolds should visibly inherit AAI's mechanical actuator layer" },
  { "fw-flux-quarry", "electric-motor", "late extraction should still reflect the required AAI motor infrastructure" },
  { "fw-flux-quarry", "electric-engine-unit", "late extraction should also pay the full electric engine cost once AAI is active" },
  { "lab", "burner-lab", "the electric lab should visibly upgrade out of AAI's burner lab instead of pretending the branch vanished" },
  { "electric-mining-drill", "fw-bearing", "AAI's early motorized extraction should also pay off the FluxWorks bearing branch" },
  { "assembling-machine-2", "motor", "midgame assemblers should still acknowledge AAI's motor branch before they reach FluxWorks-specific machine parts" },
  { "assembling-machine-2", "fw-bearing", "midgame assembly should also consume a real mechanical part instead of only the raw motor" },
  { "assembling-machine-2", "fw-circuit-contact", "midgame assembly should also pick up the first FluxWorks contact-casting branch instead of leaving AAI electronics isolated" },
  { "assembling-machine-3", "electric-engine-unit", "top-tier assemblers should show the full powered AAI machine spine instead of only custom Flux parts" },
  { "assembling-machine-3", "fw-control-assembly", "top-tier assemblers should consume powered control hardware from the shared AAI-Flux ladder" },
  { "assembling-machine-3", "fw-transformer-core", "advanced assembly should promote the shared motorized control backbone into full power-routing hardware" },
  { "chemical-plant", "engine-unit", "chemical processing should sit on real engine hardware once AAI's machine ladder is present" },
  { "chemical-plant", "electric-motor", "chemical processing should inherit AAI's powered machine chain" },
  { "oil-refinery", "electric-motor", "refinery progression should sit on top of AAI's powered machine chain" },
  { "pumpjack", "engine-unit", "pumpjacks should continue to acknowledge AAI's engine ladder even after FluxWorks adds its own machine parts" },
  { "pumpjack", "electric-motor", "pumpjacks should graduate into AAI's powered actuator branch" },
  { "pumpjack", "fw-flow-regulator", "fluid extraction should consume FluxWorks regulation once the AAI-powered machine base already exists" },
  { "pumpjack", "fw-bearing", "pumpjacks should also cash in the FluxWorks bearing branch instead of stopping at generic driven parts" },
  { "big-mining-drill", "electric-engine-unit", "late extraction should keep the full AAI powered-engine tax visible instead of flattening back to control boxes" },
  { "big-mining-drill", "fw-harvester-head", "late extraction should use one complete FluxWorks extraction assembly instead of repeating its control, regulation, and sensing subcomponents" },
  { "industrial-furnace", "engine-unit", "AAI's top furnace should still pay for driven industrial hardware before FluxWorks adds foundry refinements" },
  { "industrial-furnace", "fw-foundry-lining", "AAI's top furnace should acknowledge the FluxWorks refractory branch instead of ending on plain vanilla shelling" },
  { "industrial-furnace", "fw-power-regulator", "AAI's top furnace should also use the shared powered-control branch once both mods are present" },
  { "industrial-furnace", "fw-hydraulic-manifold", "AAI's top furnace should also inherit the shared high-pressure plantwork once both mods are active" },
  { "fw-circuit-contact", "stone-tablet", "FluxWorks contacts should promote AAI stone tablets into the first electrical substrate layer" },
  { "fw-inductor-coil", "stone-tablet", "FluxWorks inductors should wind around AAI's shaped ceramic electrical backing" },
  { "fw-capacitor", "glass", "FluxWorks capacitors should use AAI glass as their dielectric layer" },
  { "fw-cermet", "stone-tablet", "FluxWorks cermet should begin with AAI's shaped ceramic stock rather than raw masonry" },
  { "fw-fired-ceramic", "stone-tablet", "FluxWorks fired ceramics should refine AAI tablets into engineered ceramic bodies" },
  { "concrete-gate", "electric-motor", "AAI concrete gates should use powered actuation hardware" },
  { "steel-gate", "fw-control-assembly", "AAI steel gates should graduate into FluxWorks control hardware" },
  { "steel-wall", "fw-steel-beam", "AAI steel defenses should consume FluxWorks structural fabrication" },
  { "area-mining-drill", "fw-steel-beam", "AAI area mining should upgrade into FluxWorks structural hardware" },
  { "area-mining-drill", "fw-harvester-head", "AAI area mining should use the FluxWorks extraction head rather than raw plates" },
  { "area-mining-drill", "fw-sensor-package", "AAI area mining should inherit FluxWorks instrumentation" },
}) do
  if not (skip_burner_stage and assertion[2] == "burner-lab") then
    assert_recipe_has_ingredient(assertion[1], assertion[2], assertion[3])
  end
end

for _, compact_recipe in ipairs({
  "steam-engine",
  "electric-mining-drill",
  "lab",
  "industrial-furnace",
  "area-mining-drill",
}) do
  assert_true(
    recipe_ingredient_count(compact_recipe) <= 5,
    ("AAI Industry integration failure: %s grew beyond five ingredient types"):format(compact_recipe)
  )
end

assert_recipe_lacks_ingredient(
  "fw-circuit-contact",
  "iron-plate",
  "AAI stone tablets replace the redundant raw iron backing in the shared electronics lane"
)
assert_true(
  data.raw.recipe["sand"] and (((data.raw.recipe["sand"].categories or {})[1]) or data.raw.recipe["sand"].category) == "basic-crushing",
  "AAI Industry integration failure: sand should require a crusher rather than character crafting"
)
assert_true(
  technology_has_prerequisite("sand-processing", "fw-comminution"),
  "AAI Industry integration failure: crusher research should precede sand processing"
)
local fuel_processing = data.raw.technology and data.raw.technology["fuel-processing"]
if fuel_processing and fuel_processing.enabled ~= false and not fuel_processing.hidden then
  for _, assertion in ipairs({
    { "fw-carbon-washing", "refined carbon preparation" },
    { "fw-rubber-sheet", "early elastomer feedstock" },
    { "plastic-bar", "petrochemical polymer feedstock" },
    { "explosives", "dense chemical explosive feedstock" },
    { "fw-yellow-polymer-alignment", "Flux-aligned polymer feedstock" },
    { "rocket-fuel", "conventional rocket-fuel blending" },
    { "fw-red-rocket-fuel-overdrive", "Flux-overdriven rocket-fuel blending" },
  }) do
    assert_recipe_has_ingredient(
      assertion[1],
      "processed-fuel",
      "enabled AAI fuel processing should feed " .. assertion[2]
    )
  end
  assert_true(
    technology_has_prerequisite("fw-petrochemical-engineering", "fuel-processing"),
    "AAI Industry integration failure: petrochemical engineering should build on enabled AAI fuel processing"
  )
end
