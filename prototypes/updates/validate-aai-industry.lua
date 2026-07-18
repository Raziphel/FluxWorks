if not mods["aai-industry"] then
  return
end

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

local offshore_pump = data.raw["offshore-pump"] and data.raw["offshore-pump"]["offshore-pump"]
assert_true(offshore_pump ~= nil, "AAI Industry integration failure: missing offshore-pump prototype")
assert_true(
  offshore_pump.energy_source ~= nil and offshore_pump.energy_source.type == "electric",
  "AAI Industry integration failure: offshore-pump should remain electrically powered when AAI is active"
)

for _, assertion in ipairs({
  { "fw-glass", "glass", "FluxWorks glassworking should build on AAI's glass lane once the dependency is required" },
  { "fw-circuit-substrate", "stone-tablet", "substrates should consume AAI stone processing instead of leaving that branch ornamental" },
  { "fw-drive-module", "motor", "mechanical intermediates should lean on AAI's motor branch" },
  { "fw-pressure-housing", "engine-unit", "pressure-rated structure should explicitly sit on AAI's engine branch instead of feeling like a static shell" },
  { "fw-control-assembly", "electric-motor", "control hardware should pull from AAI's powered assembly lane" },
  { "fw-transformer-core", "electric-motor", "mid-tier electrical hardware should inherit AAI's motorized progression" },
  { "fw-signal-conduit", "electric-motor", "signal-routing hardware should show the shared AAI electric motor spine instead of only passive conductors" },
  { "fw-flow-regulator", "engine-unit", "regulated fluid hardware should use AAI's engine assemblies instead of treating motion as abstract" },
  { "fw-power-regulator", "electric-motor", "powered regulators should visibly consume AAI's electric motor branch" },
  { "fw-field-winding", "electric-engine-unit", "late electromagnetic hardware should promote the full AAI electric engine chain into FluxWorks machinery" },
  { "fw-harvester-head", "electric-motor", "the quarry head should visibly consume AAI motor hardware instead of pretending the cutting assembly is static" },
  { "fw-rocket-engine", "engine-unit", "rocket engines should visibly inherit the lower AAI engine ladder instead of skipping straight to the electric engine shell" },
  { "fw-petrochemical-facility", "motor", "petrochemical plants should show the shared AAI motor backbone in their frame" },
  { "fw-hydraulic-plant", "electric-motor", "hydraulic plants should consume AAI's powered actuation parts directly" },
  { "fw-hydraulic-manifold", "motor", "hydraulic manifolds should visibly inherit AAI's mechanical actuator layer" },
  { "fw-flow-regulator", "fw-drive-module", "fluid control should now sit on top of the AAI-fed drive branch" },
  { "fw-flux-quarry", "electric-motor", "late extraction should still reflect the required AAI motor infrastructure" },
  { "fw-flux-quarry", "electric-engine-unit", "late extraction should also pay the full electric engine cost once AAI is active" },
  { "lab", "burner-lab", "the electric lab should visibly upgrade out of AAI's burner lab instead of pretending the branch vanished" },
  { "electric-mining-drill", "fw-drive-module", "AAI's powered mining transition should visibly feed into the FluxWorks drive branch" },
  { "electric-mining-drill", "fw-bearing", "AAI's early motorized extraction should also pay off the FluxWorks bearing branch" },
  { "assembling-machine-2", "motor", "midgame assemblers should still acknowledge AAI's motor branch before they reach FluxWorks-specific machine parts" },
  { "assembling-machine-2", "fw-drive-module", "midgame assembly should bridge from AAI motors into FluxWorks machine-part progression" },
  { "assembling-machine-2", "fw-bearing", "midgame assembly should also consume a real mechanical part instead of only the raw motor" },
  { "assembling-machine-2", "fw-circuit-contact", "midgame assembly should also pick up the first FluxWorks contact-casting branch instead of leaving AAI electronics isolated" },
  { "assembling-machine-3", "electric-engine-unit", "top-tier assemblers should show the full powered AAI machine spine instead of only custom Flux parts" },
  { "assembling-machine-3", "fw-control-assembly", "top-tier assemblers should consume powered control hardware from the shared AAI-Flux ladder" },
  { "assembling-machine-3", "fw-chip-carrier", "advanced assembly should pull in the FluxWorks packaging branch once AAI has already deepened the base machine line" },
  { "assembling-machine-3", "fw-signal-conduit", "advanced assembly should also reflect the shared signal-routing ladder instead of stopping at plain control shells" },
  { "assembling-machine-3", "fw-transformer-core", "advanced assembly should promote the shared motorized control backbone into full power-routing hardware" },
  { "chemical-plant", "engine-unit", "chemical processing should sit on real engine hardware once AAI's machine ladder is present" },
  { "chemical-plant", "fw-drive-module", "chemical processing should inherit AAI's motorized machine chain and FluxWorks drive hardware together" },
  { "oil-refinery", "engine-unit", "refinery progression should still acknowledge the base AAI engine ladder before the full electric engine tier takes over" },
  { "oil-refinery", "electric-engine-unit", "refinery progression should use powered engine assemblies instead of skipping from pipes to Flux controls" },
  { "oil-refinery", "fw-drive-module", "refinery progression should sit on top of AAI motors and FluxWorks machine-control parts together" },
  { "pumpjack", "engine-unit", "pumpjacks should continue to acknowledge AAI's engine ladder even after FluxWorks adds its own machine parts" },
  { "pumpjack", "fw-drive-module", "pumpjacks should graduate from raw AAI motors into the FluxWorks drive branch" },
  { "pumpjack", "fw-flow-regulator", "fluid extraction should consume FluxWorks regulation once the AAI-powered machine base already exists" },
  { "pumpjack", "fw-bearing", "pumpjacks should also cash in the FluxWorks bearing branch instead of stopping at generic driven parts" },
  { "big-mining-drill", "fw-flow-regulator", "late extraction should also inherit the shared regulation branch instead of only the control shell" },
  { "big-mining-drill", "electric-engine-unit", "late extraction should keep the full AAI powered-engine tax visible instead of flattening back to control boxes" },
  { "big-mining-drill", "fw-control-assembly", "late extraction should visibly inherit the shared motor-and-control ladder" },
  { "big-mining-drill", "fw-transformer-core", "late extraction should promote the shared AAI motor backbone into real FluxWorks power-routing hardware" },
  { "big-mining-drill", "fw-sensor-package", "late extraction should also consume the FluxWorks sensing branch so the head feels instrumented instead of brute-force" },
  { "industrial-furnace", "engine-unit", "AAI's top furnace should still pay for driven industrial hardware before FluxWorks adds foundry refinements" },
  { "industrial-furnace", "fw-foundry-lining", "AAI's top furnace should acknowledge the FluxWorks refractory branch instead of ending on plain vanilla shelling" },
  { "industrial-furnace", "fw-power-regulator", "AAI's top furnace should also use the shared powered-control branch once both mods are present" },
  { "industrial-furnace", "fw-alumina-refractory", "AAI's top furnace should visibly consume the FluxWorks alumina branch instead of leaving that refractory tier ornamental" },
  { "industrial-furnace", "fw-hydraulic-manifold", "AAI's top furnace should also inherit the shared high-pressure plantwork once both mods are active" },
}) do
  assert_recipe_has_ingredient(assertion[1], assertion[2], assertion[3])
end
