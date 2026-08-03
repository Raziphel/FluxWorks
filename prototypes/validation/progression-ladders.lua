local Startup = require("prototypes.lib.startup-settings")

local function has_unlock_effect(effects, recipe_name)
  for _, effect in pairs(effects or {}) do
    if effect.type == "unlock-recipe" and effect.recipe == recipe_name then
      return true
    end
  end

  return false
end

local function has_space_location_unlock(effects, location_name)
  for _, effect in pairs(effects or {}) do
    if effect.type == "unlock-space-location" and effect.space_location == location_name then
      return true
    end
  end

  return false
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

local function assert_recipe_unlocks(tech_name, recipe_names)
  local tech = data.raw.technology and data.raw.technology[tech_name]
  if not tech then
    error("Missing technology for progression validation: " .. tech_name)
  end

  for _, recipe_name in ipairs(recipe_names) do
    if not has_unlock_effect(tech.effects, recipe_name) then
      error(("Progression ladder failure: %s does not unlock %s"):format(tech_name, recipe_name))
    end
  end
end

local function assert_recipe_does_not_unlock(tech_name, recipe_names)
  local tech = data.raw.technology and data.raw.technology[tech_name]
  if not tech then
    error("Missing technology for progression validation: " .. tech_name)
  end

  for _, recipe_name in ipairs(recipe_names) do
    if has_unlock_effect(tech.effects, recipe_name) then
      error(("Progression ladder failure: %s should not unlock %s"):format(tech_name, recipe_name))
    end
  end
end

local function assert_true(condition, message)
  if not condition then
    error(message)
  end
end

local function assert_recipe_category(recipe_name, expected_category, reason)
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if not recipe then
    error("Missing recipe for progression validation: " .. recipe_name)
  end

  local actual_category = (recipe.categories and recipe.categories[1]) or recipe.category or "crafting"
  if actual_category ~= expected_category then
    error(("Progression ladder failure: %s uses %s instead of %s (%s)"):format(
      recipe_name,
      actual_category,
      expected_category,
      reason
    ))
  end
end

local function assert_tech_has_prerequisite(tech_name, required_prerequisite, reason)
  local tech = data.raw.technology and data.raw.technology[tech_name]
  if not tech then
    error("Missing technology for progression validation: " .. tech_name)
  end

  for _, prerequisite in ipairs(tech.prerequisites or {}) do
    if prerequisite == required_prerequisite then
      return
    end
  end

  error(("Progression ladder failure: %s is missing prerequisite %s (%s)"):format(
    tech_name,
    required_prerequisite,
    reason
  ))
end

local function assert_recipe_lacks_ingredients(recipe_name, forbidden_ingredients, reason)
  for _, forbidden_ingredient in ipairs(forbidden_ingredients) do
    if recipe_has_ingredient(recipe_name, forbidden_ingredient) then
      error(("Progression ladder failure: %s still depends on %s (%s)"):format(
        recipe_name,
        forbidden_ingredient,
        reason
      ))
    end
  end
end

local function assert_recipe_has_ingredient(recipe_name, required_ingredient, reason)
  if not recipe_has_ingredient(recipe_name, required_ingredient) then
    error(("Progression ladder failure: %s is missing %s (%s)"):format(
      recipe_name,
      required_ingredient,
      reason
    ))
  end
end

local function assert_tech_uses_only_science(tech_name, expected_science_packs, reason)
  local tech = data.raw.technology and data.raw.technology[tech_name]
  if not tech then
    error("Missing technology for progression validation: " .. tech_name)
  end

  local expected = {}
  for _, science_name in ipairs(expected_science_packs) do
    expected[science_name] = true
  end

  for _, ingredient in ipairs((tech.unit and tech.unit.ingredients) or {}) do
    local science_name = ingredient.name or ingredient[1]
    if not expected[science_name] then
      error(("Progression ladder failure: %s still depends on %s (%s)"):format(
        tech_name,
        science_name,
        reason
      ))
    end
  end
end

local function assert_tech_uses_exact_science(tech_name, expected_science_packs, reason)
  local tech = data.raw.technology and data.raw.technology[tech_name]
  if not tech then
    error("Missing technology for progression validation: " .. tech_name)
  end

  local actual_science = {}
  for _, ingredient in ipairs((tech.unit and tech.unit.ingredients) or {}) do
    actual_science[#actual_science + 1] = ingredient.name or ingredient[1]
  end

  if #actual_science ~= #expected_science_packs then
    error(("Progression ladder failure: %s uses %d sciences instead of %d (%s)"):format(
      tech_name,
      #actual_science,
      #expected_science_packs,
      reason
    ))
  end

  for index, expected_name in ipairs(expected_science_packs) do
    if actual_science[index] ~= expected_name then
      error(("Progression ladder failure: %s uses %s instead of %s at slot %d (%s)"):format(
        tech_name,
        tostring(actual_science[index]),
        expected_name,
        index,
        reason
      ))
    end
  end
end

assert_recipe_unlocks("fw-petrochemical-engineering", {
  "fw-petrochemical-facility",
})
assert_recipe_unlocks("fw-reactive-binders", {
  "fw-chlorinated-binder-stock",
})
assert_recipe_unlocks("fw-elastomer-engineering", {
  "fw-elastomer-matrix",
})
assert_recipe_unlocks("fw-elastomer-engineering", {
  "fw-reinforced-seal",
})
assert_recipe_unlocks("fw-hydraulic-systems", {
  "fw-hydraulic-plant",
  "fw-hydraulic-tube-drawing",
  "fw-hydraulic-filter-pressing",
  "fw-hydraulic-housing-forming",
  "fw-hydraulic-seal-compression",
})
assert_recipe_unlocks("fw-fluid-control-architecture", {
  "fw-hydraulic-manifold",
  "fw-hydraulic-regulator-calibration",
})
assert_recipe_unlocks("fw-material-foundations", {
  "fw-metal-mesh",
  "fw-alumina-refractory",
})
assert_recipe_unlocks("fw-ore-crushing", {
  "fw-crushed-iron-ore",
  "fw-crushed-copper-ore",
  "fw-crushed-tin-ore",
  "fw-crushed-bauxite-ore",
  "fw-crushed-lead-ore",
  "fw-crushed-titanium-ore",
})
assert_recipe_unlocks("fw-dense-ore-smelting", {
  "iron-plate-from-crushed",
  "copper-plate-from-crushed",
  "tin-plate-from-crushed",
  "aluminum-plate-from-crushed-bauxite",
  "lead-plate-from-crushed",
  "titanium-plate-from-crushed",
})
assert_recipe_unlocks("fw-structural-fabrication", {
  "fw-iron-beam",
})
assert_recipe_unlocks("fw-structural-fabrication", {
  "fw-circuit-contact-leaded",
})
assert_recipe_unlocks("fw-structural-fabrication", {
  "fw-copper-tube",
  "fw-inline-filter",
})
assert_recipe_unlocks("fw-systems-integration", {
  "fw-sensor-package",
})
assert_recipe_unlocks("fw-advanced-fabrication", {
  "fw-light-frame",
})
assert_recipe_unlocks("fw-propellant-synthesis", {
  "fw-gunpowder",
})
assert_recipe_unlocks("fw-cryogenic-control", {
  "fw-thermal-buffer",
})
assert_recipe_unlocks("fw-logic-weaving", {
  "fw-logic-matrix",
})
assert_recipe_unlocks("fw-arc-recasting", {
  "fw-arc-cermet-densification",
  "fw-arc-glass-recast",
})
assert_recipe_unlocks("fw-reactive-powders", {
  "fw-synthesized-gunpowder",
})
assert_recipe_does_not_unlock("fw-advanced-fabrication", {
  "fw-gunpowder",
})
assert_recipe_does_not_unlock("fw-industrial-expansion", {
  "fw-arc-cermet-densification",
  "fw-arc-glass-recast",
  "fw-synthesized-gunpowder",
})
assert_recipe_does_not_unlock("fw-electromagnetic-architecture", {
  "fw-logic-matrix",
})

assert_recipe_lacks_ingredients(
  "fw-petrochemical-facility",
  {
    "fw-reinforced-seal",
    "fw-hydraulic-manifold",
    "fw-elastomer-matrix",
  },
  "the petrochemical bootstrap must not consume products from deeper petrochem or hydraulic tiers"
)
assert_recipe_lacks_ingredients(
  "fw-hydraulic-plant",
  {
    "fw-hydraulic-manifold",
  },
  "the first hydraulic machine must bootstrap the branch instead of requiring later hydraulic parts"
)
assert_recipe_lacks_ingredients(
  "fw-flow-regulator",
  {
    "fw-reinforced-seal",
    "fw-hydraulic-manifold",
  },
  "core control hardware must stay craftable before the dedicated hydraulic lane opens"
)
assert_recipe_lacks_ingredients(
  "fw-copper-tube",
  {
    "tin-plate",
    "bronze-plate",
    "fw-solder-alloy",
  },
  "early tube forming should stay on guaranteed bootstrap metals instead of depending on the later conductive alloy lane"
)
assert_recipe_lacks_ingredients(
  "fw-metal-mesh",
  {
    "tin-plate",
    "bronze-plate",
  },
  "material foundations should stay on early structural metals instead of requiring later alloy handling"
)
assert_recipe_has_ingredient(
  "fw-reinforced-seal",
  "fw-elastomer-matrix",
  "seal production should consume the dedicated elastomer branch instead of jumping straight from raw latex to end products"
)
assert_recipe_has_ingredient(
  "fw-reinforced-seal",
  "fw-chlorinated-binder-stock",
  "pressure seals should visibly consume the chlorinated binder stage so petrochem has a real mid-tier payoff"
)
assert_recipe_has_ingredient(
  "fw-hydraulic-manifold",
  "fw-elastomer-matrix",
  "hydraulic hardware should inherit the petrochemical elastomer branch instead of bypassing it"
)
assert_recipe_has_ingredient(
  "fw-fired-ceramic",
  "fw-alumina-refractory",
  "bauxite should feed the ceramic branch so mineral deposits matter beyond flat aluminum smelting"
)
for _, salt_consumer in ipairs({ "battery" }) do
  assert_recipe_has_ingredient(
    salt_consumer,
    "fw-salt",
    "salt should serve as an electrolyte and mineral-separation reagent beyond chlorine production"
  )
end
assert_recipe_has_ingredient(
  "fw-ceramic-insulator",
  "stone-tablet",
  "early insulators should use AAI's shaped ceramic body"
)
assert_recipe_has_ingredient(
  "fw-ceramic-insulator",
  "glass",
  "early insulators should use a simple glass glaze"
)
assert_recipe_lacks_ingredients(
  "fw-ceramic-insulator",
  { "stone-brick", "silicon", "lead-plate", "fw-alumina-refractory" },
  "early electrical insulation should remain a compact ceramic recipe"
)
assert_recipe_has_ingredient(
  "fw-foundry-lining",
  "fw-alumina-refractory",
  "the refractory branch should carry forward into high-heat foundry hardware"
)
assert_recipe_has_ingredient(
  "fw-glass-lens",
  "lead-plate",
  "lead should matter in the optical lane instead of disappearing after early plates"
)
assert_recipe_has_ingredient(
  "fw-sensor-package",
  "tin-plate",
  "tin should stay relevant in the precision-control lane instead of vanishing after basic conductors"
)
assert_recipe_has_ingredient(
  "fw-transformer-core",
  "bronze-plate",
  "the conductive metals lane should remain visible in heavier electrical hardware"
)
local foundational_fluid_recipes = {
  "pipe-to-ground",
  "storage-tank",
  "pump",
  "offshore-pump",
  "chemical-plant",
  "oil-refinery",
}

if not mods["aai-industry"] then
  foundational_fluid_recipes[#foundational_fluid_recipes + 1] = "pumpjack"
end

for _, recipe_name in ipairs(foundational_fluid_recipes) do
  assert_recipe_lacks_ingredients(
    recipe_name,
    {
      "fw-pressure-housing",
      "fw-flow-regulator",
      "fw-reinforced-seal",
      "fw-hydraulic-manifold",
    },
    "foundational fluid infrastructure should not get stranded behind the later control and hydraulics ladder"
  )
end

assert_recipe_unlocks("fw-isotope-conditioning", {
})
assert_recipe_unlocks("fw-fuel-fabrication", {
  "fw-atomic-enricher",
  "fw-shielded-fuel-casing",
  "fw-fuel-pellet-bundle",
  "fw-precision-uranium-assay",
})
assert_recipe_unlocks("fw-lattice-moderation", {
  "fw-moderator-lattice",
  "fw-isotope-matrix",
  "fw-reactor-grade-fuel-cell",
  "fw-flux-isotope-separation",
})
assert_recipe_unlocks("fw-reactor-doping", {
  "fw-reactor-dopant",
})
assert_recipe_unlocks("fw-reactor-safeguards", {
  "fw-control-rod-assembly",
  "fw-reactor-coolant-cartridge",
})
assert_recipe_unlocks("fw-actinide-recovery", {
  "fw-spent-fuel-reconditioning",
  "fw-depleted-cell-dissolution",
})
assert_recipe_unlocks("fw-actinide-sorting", {
  "fw-radioactive-scrap-sorting",
  "fw-isotope-recovery",
})
assert_recipe_unlocks("fw-actinide-reforging", {
  "fw-actinide-matrix-seeding",
  "fw-scrap-lattice-recasting",
  "fw-pellet-bundle-reprocessing",
})
assert_recipe_unlocks("fw-reactor-instrumentation", {
  "fw-nuclear-fuel-overdrive",
  "fw-actinide-dopant-refining",
  "fw-fusion-cell-doping",
})
assert_recipe_does_not_unlock("fw-isotope-conditioning", {
  "fw-atomic-enricher",
  "fw-shielded-fuel-casing",
  "fw-fuel-pellet-bundle",
  "fw-moderator-lattice",
  "fw-isotope-matrix",
  "fw-reactor-grade-fuel-cell",
})
assert_recipe_does_not_unlock("fw-reactor-doping", {
  "fw-control-rod-assembly",
  "fw-reactor-coolant-cartridge",
})
assert_recipe_does_not_unlock("fw-actinide-recovery", {
  "fw-radioactive-scrap-sorting",
  "fw-isotope-recovery",
  "fw-actinide-matrix-seeding",
  "fw-scrap-lattice-recasting",
  "fw-pellet-bundle-reprocessing",
})
assert_tech_has_prerequisite(
  "fw-arc-recasting",
  "fw-industrial-expansion",
  "arc recasting should branch from the industrial expansion anchor instead of bypassing it"
)
assert_tech_has_prerequisite(
  "fw-reactive-powders",
  "fw-industrial-expansion",
  "reactive powders should sit inside the expanded industrial chemistry step"
)
assert_tech_has_prerequisite(
  "fw-fuel-fabrication",
  "fw-isotope-conditioning",
  "fuel fabrication should be the first concrete payoff of the atomic conditioning gateway"
)
assert_tech_has_prerequisite(
  "fw-lattice-moderation",
  "fw-isotope-conditioning",
  "moderation hardware should branch from the same atomic conditioning gateway"
)
assert_tech_has_prerequisite(
  "fw-reactor-safeguards",
  "fw-reactor-doping",
  "reactor safeguards should follow reactor dopant theory instead of bypassing it"
)
assert_tech_has_prerequisite(
  "fw-reactor-doping",
  "fw-fuel-fabrication",
  "reactor doping should visibly build on the fuel-fabrication branch because its core recipe consumes pellet and casing work"
)
assert_tech_has_prerequisite(
  "fw-reactor-doping",
  "fw-lattice-moderation",
  "reactor doping should visibly depend on isotope matrices and lattice work instead of pretending they are optional"
)
assert_tech_has_prerequisite(
  "fw-actinide-recovery",
  "fw-reactor-safeguards",
  "actinide recovery should require the reactor-protection branch because the first recovery loop consumes coolant and control hardware"
)
assert_tech_has_prerequisite(
  "fw-actinide-recovery",
  "fw-lattice-moderation",
  "actinide recovery should inherit the lattice branch because reconditioning and reuse revolve around moderator and matrix stock"
)
assert_tech_has_prerequisite(
  "fw-actinide-sorting",
  "fw-actinide-recovery",
  "sorting recovered actinides should require the recovery gateway"
)
assert_tech_has_prerequisite(
  "fw-actinide-reforging",
  "fw-actinide-recovery",
  "actinide reforging should be a deeper recovery branch, not a side unlock"
)
assert_tech_has_prerequisite(
  "fw-reactor-instrumentation",
  "fw-actinide-sorting",
  "reactor instrumentation should sit after recovered actinide analysis, not before it"
)
assert_tech_has_prerequisite(
  "fw-reactor-instrumentation",
  "fw-actinide-reforging",
  "reactor instrumentation should wait for both recycling sub-branches to mature"
)
assert_tech_has_prerequisite(
  "fw-reactor-instrumentation",
  "fw-reactor-safeguards",
  "reactor instrumentation should visibly inherit the control-and-cooling branch rather than skipping straight from recovery to overdrive"
)
assert_recipe_unlocks("fw-aquilo-cryochemistry", {
  "fw-electrolyte-conditioning",
  "fw-lithium-adsorption",
  "fw-fluoroketone-synthesis",
  "fw-aquilo-cryogel",
})
assert_recipe_unlocks("fw-gleba-biochemistry", {
  "fw-nutrient-bed",
  "fw-gleba-spore-resin",
})
assert_recipe_unlocks("fw-fulgora-electrochemistry", {
  "fw-fulgora-static-mesh",
})
assert_recipe_unlocks("fw-vulcanus-pyrochemistry", {
  "fw-vulcanus-slag-cermet",
})
assert_recipe_unlocks("fw-superconductive-systems", {
  "fw-superconductor-bath",
  "fw-supercapacitor-conditioning",
})
assert_recipe_unlocks("fw-flux-synthesis", {
  "fw-flux-condenser",
  "fw-flux-metallic-synthesis",
})
assert_recipe_unlocks("fw-spectral-fluid-retention", {
  "fw-reservoir-lining",
  "fw-thermal-phase-gasket",
  "fw-spectral-reservoir",
})
assert_recipe_unlocks("fw-fusion-lattices", {
  "fw-fusion-power-cell-conditioning",
})

assert_recipe_does_not_unlock("fw-flux-convergence", {
  "fw-flux-metallic-synthesis",
  "fw-reservoir-lining",
})
assert_recipe_does_not_unlock("fw-rift-harmonics", {
  "fw-thermal-phase-gasket",
})

assert_recipe_lacks_ingredients(
  "fw-atomic-enricher",
  {
    "fw-isotope-matrix",
    "fw-fuel-pellet-bundle",
    "fw-moderator-lattice",
    "fw-control-rod-assembly",
    "fw-reactor-coolant-cartridge",
    "fw-reactor-dopant",
    "fw-recovered-actinides",
  },
  "the atomic branch machine must unlock before the isotope and reactor-part products it exists to make"
)
assert_recipe_lacks_ingredients(
  "fw-reactor-grade-fuel-cell",
  {
    "fw-reactor-dopant",
    "fw-reactor-coolant-cartridge",
  },
  "the first upgraded fuel-cell recipe must come online before the deeper reactor-doping layer"
)

assert_recipe_category(
  "fw-aquilo-cryogel",
  "cryogenics",
  "Aquilo capstones should land on the cryogenic machine lane"
)
assert_recipe_category(
  "fw-gleba-spore-resin",
  "organic",
  "Gleba capstones should land on the biochamber lane"
)
assert_recipe_category(
  "fw-fulgora-static-mesh",
  "electromagnetics",
  "Fulgora capstones should land on the electromagnetic plant lane"
)
assert_recipe_category(
  "fw-vulcanus-slag-cermet",
  "metallurgy",
  "Vulcanus capstones should land on the foundry lane"
)
assert_recipe_category(
  "fw-superconductor-bath",
  "cryogenics",
  "late cold-field convergence should stay on the cryogenic lane"
)
assert_recipe_category(
  "fw-supercapacitor-conditioning",
  "electromagnetics",
  "late charged-field convergence should stay on the electromagnetic lane"
)

for _, prerequisite in ipairs({
  "fw-aquilo-cryochemistry",
  "fw-gleba-biochemistry",
  "fw-fulgora-electrochemistry",
  "fw-vulcanus-pyrochemistry",
}) do
  assert_tech_has_prerequisite(
    "fw-flux-convergence",
    prerequisite,
    "the convergence tech should visibly sit on all four planet reward branches"
  )
end

assert_tech_has_prerequisite(
  "fw-rift-logistics",
  "fw-fulgora-electrochemistry",
  "late rift logistics should explicitly inherit the Fulgora field-control branch"
)

assert_tech_has_prerequisite(
  "fw-flux-resonance",
  "fw-harvester-systems",
  "basic resonance hardware must remain available before Flux Theory Science"
)

assert_tech_has_prerequisite(
  "fw-flux-purple-transmutation",
  "fw-flux-theory-science",
  "ore transmutation is a signature Matter Flux reward of Flux Theory Science"
)

assert_recipe_unlocks("fw-flux-purple-transmutation", {
  "fw-coal-to-copper-ore",
  "fw-copper-ore-to-iron-ore",
  "fw-iron-ore-to-lead-ore",
  "fw-purple-flux-from-material-iron-plate",
  "fw-purple-flux-from-material-steel-plate",
})
assert_recipe_unlocks("fw-flux-yellow-catalysis", {
  "fw-yellow-flux-from-sulfur",
  "fw-yellow-flux-from-plastic-bar",
  "fw-yellow-flux-from-fw-resin",
})
assert_recipe_unlocks("fw-flux-chemical-synthesis", {
  "fw-yellow-acid-catalysis",
  "fw-yellow-lubricant-alignment",
  "fw-yellow-polymer-alignment",
})
assert_recipe_unlocks("fw-flux-red-energetics", { "fw-red-solid-fuel-overdrive" })
assert_recipe_unlocks("fw-flux-thermal-networks", { "fw-red-rocket-fuel-overdrive" })
assert_recipe_unlocks("fw-flux-metallurgy", { "fw-red-steel-flash-smelting" })
assert_recipe_unlocks("fw-flux-green-reclamation", {
  "fw-green-flux-from-spoilage",
  "fw-green-flux-from-nutrients",
  "fw-green-flux-from-raw-fish",
  "fw-green-nutrient-reclamation",
})
assert_recipe_unlocks("fw-flux-green-cultivation", { "fw-green-bioflux-propagation" })
assert_recipe_unlocks("fw-flux-green-propagation", { "fw-green-seedbank-propagation" })

for _, recipe_name in ipairs({
  "fw-green-flux-from-spoilage",
  "fw-green-nutrient-reclamation",
  "fw-green-bioflux-propagation",
  "fw-green-seedbank-propagation",
}) do
  assert_recipe_category(recipe_name, "organic", "Green Flux belongs on the biochamber lane")
end

if Startup.enabled("fw-enable-recipe-integration", true)
  and Startup.enabled("fw-enable-orbital-and-planetary-integration", true) then
  assert_recipe_has_ingredient(
    "rocket-silo",
    "fw-power-regulator",
    "orbital hardware should still reflect late control hardware when integration is enabled"
  )
  assert_recipe_has_ingredient(
    "superconductor",
    "fw-aquilo-cryogel",
    "late superconductors should visibly consume the Aquilo branch after the integration sweep"
  )
  assert_recipe_has_ingredient(
    "supercapacitor",
    "fw-fulgora-static-mesh",
    "late capacitors should visibly consume the Fulgora branch after the integration sweep"
  )
  assert_recipe_has_ingredient(
    "quantum-processor",
    "fw-logic-matrix",
    "late computation parts should still depend on the Flux control branch once integrated"
  )
  assert_recipe_has_ingredient(
    "fusion-power-cell",
    "fw-reactor-dopant",
    "fusion power cells should reflect the atomic late-game branch once integration is enabled"
  )
  assert_recipe_has_ingredient(
    "fusion-power-cell",
    "fw-reactor-coolant-cartridge",
    "fusion power cells should consume the atomic thermal-control branch once integration is enabled"
  )
end

local space_age_symbiosis_contracts = {
  { technology = "fw-orbital-flux-industrialization", recipe = "fw-orbital-flux-chunk-sorting" },
  { technology = "fw-vulcanus-industrial-symbiosis", recipe = "fw-vulcanus-red-carbide-sintering" },
  { technology = "fw-vulcanus-industrial-symbiosis", recipe = "fw-vulcanus-flux-casting" },
  { technology = "fw-gleba-regenerative-symbiosis", recipe = "fw-gleba-green-carbon-fiber-cultivation" },
  { technology = "fw-fulgora-electromagnetic-symbiosis", recipe = "fw-fulgora-yellow-holmium-reclamation" },
  { technology = "fw-aquilo-thermal-symbiosis", recipe = "fw-aquilo-red-ammonia-cracking" },
  { technology = "fw-cross-planetary-industrial-convergence", recipe = "fw-converged-quantum-processor" },
}

for _, contract in ipairs(space_age_symbiosis_contracts) do
  assert_recipe_unlocks(contract.technology, { contract.recipe })
end

for technology_name, prerequisite_name in pairs({
  ["advanced-material-processing-2"] = "fw-ceramic-engineering",
  ["automation-3"] = "fw-systems-integration",
  ["electric-energy-distribution-2"] = "fw-power-regulation",
  ["robotics"] = "fw-signal-architecture",
  ["advanced-asteroid-processing"] = "fw-orbital-flux-industrialization",
  ["turbo-transport-belt"] = "fw-vulcanus-industrial-symbiosis",
  ["stack-inserter"] = "fw-gleba-regenerative-symbiosis",
  ["tesla-weapons"] = "fw-fulgora-electromagnetic-symbiosis",
  ["fusion-reactor"] = "fw-cross-planetary-industrial-convergence",
}) do
  assert_tech_has_prerequisite(
    technology_name,
    prerequisite_name,
    "major Space Age rewards should pass through their matching FluxWorks overhaul branch"
  )
end

for _, prerequisite_name in ipairs({
  "fw-vulcanus-industrial-symbiosis",
  "fw-gleba-regenerative-symbiosis",
  "fw-fulgora-electromagnetic-symbiosis",
  "fw-aquilo-thermal-symbiosis",
}) do
  assert_tech_has_prerequisite(
    "fw-cross-planetary-industrial-convergence",
    prerequisite_name,
    "cross-planetary convergence must visibly inherit all four planetary disciplines"
  )
end

local shattered_campaign_contracts = {
  { technology = "fw-shattered-vulcanus-bridgehead", recipe = "fw-shattered-red-bridgehead-forging" },
  { technology = "fw-shattered-gleba-bridgehead", recipe = "fw-shattered-green-bridgehead-cultivation" },
  { technology = "fw-shattered-fulgora-bridgehead", recipe = "fw-shattered-yellow-bridgehead-reclamation" },
  { technology = "fw-shattered-aquilo-bridgehead", recipe = "fw-shattered-purple-bridgehead-annealing" },
  { technology = "fw-shattered-vent-harmonics", recipe = "fw-shattered-vent-spectrum-condensation" },
  { technology = "fw-shattered-network-logistics", recipe = "fw-shattered-rift-coupler-array" },
  { technology = "fw-shattered-origin-survey", recipe = "fw-shattered-origin-survey-lattice" },
  { technology = "fw-ion-storm-capture", recipe = "fw-ion-storm-harmonic-core" },
}

for _, contract in ipairs(shattered_campaign_contracts) do
  assert_recipe_unlocks(contract.technology, { contract.recipe })
  local recipe = assert(data.raw.recipe[contract.recipe], "missing Shattered campaign recipe: " .. contract.recipe)
  local main_product = assert(recipe.main_product, "Shattered campaign recipe needs an explicit main product: " .. contract.recipe)
  for _, ingredient in ipairs(recipe.ingredients or {}) do
    assert(
      ingredient.name ~= main_product,
      "Shattered campaign recipes must manufacture from upstream stock, not consume their own product: " .. contract.recipe
    )
  end
end
assert_recipe_unlocks("fw-shattered-network-logistics", { "fw-model-lattice" })
assert_recipe_unlocks("fw-shattered-origin-survey", { "fw-harmonic-lattice-core" })

local function recipe_has_category(recipe, expected_category)
  if recipe.category == expected_category then return true end
  for _, category in pairs(recipe.categories or {}) do
    if category == expected_category then return true end
  end
  return false
end

local foundation_recipes = {}
for recipe_name, recipe in pairs(data.raw.recipe or {}) do
  if not recipe_has_category(recipe, "recycling") then
    for _, result in ipairs(recipe.results or {}) do
      if (result.name or result[1]) == "foundation" then
        foundation_recipes[#foundation_recipes + 1] = recipe_name
        break
      end
    end
  end
end
table.sort(foundation_recipes)
assert(
  #foundation_recipes == 1 and foundation_recipes[1] == "foundation",
  "Foundation must have one canonical manufacturing recipe; found: " .. table.concat(foundation_recipes, ", ")
)

for _, prerequisite_name in ipairs({
  "promethium-science-pack",
  "fw-cross-planetary-industrial-convergence",
  "fw-rift-harmonics",
  "fw-fusion-lattices",
}) do
  assert_tech_has_prerequisite(
    "fw-shattered-expedition-planning",
    prerequisite_name,
    "the Shattered expedition must begin after Promethium and the complete planetary Flux campaign"
  )
end

for _, prerequisite_name in ipairs({
  "fw-shattered-vulcanus-bridgehead",
  "fw-shattered-gleba-bridgehead",
  "fw-shattered-fulgora-bridgehead",
  "fw-shattered-aquilo-bridgehead",
}) do
  assert_tech_has_prerequisite(
    "fw-shattered-vent-harmonics",
    prerequisite_name,
    "vent harmonics must inherit every specialized planetary bridgehead"
  )
end

assert_tech_has_prerequisite(
  "fw-origin-infrastructure",
  "fw-shattered-origin-survey",
  "origin construction should follow the Shattered survey campaign"
)
assert_tech_has_prerequisite(
  "fw-storm-megastructures",
  "fw-ion-storm-capture",
  "storm megastructures should require a captured harmonic core"
)
assert_recipe_does_not_unlock("fw-rift-harmonics", { "fw-model-lattice" })
assert_recipe_does_not_unlock("fw-origin-infrastructure", { "fw-harmonic-lattice-core" })

local promethium_technology = data.raw.technology and data.raw.technology["promethium-science-pack"]
local expedition_technology = data.raw.technology and data.raw.technology["fw-shattered-expedition-planning"]
assert_true(
  promethium_technology and not has_space_location_unlock(promethium_technology.effects, "shattered-planet"),
  "Progression ladder failure: Promethium science should not directly unlock the Shattered Planet"
)
assert_true(
  expedition_technology and has_space_location_unlock(expedition_technology.effects, "shattered-planet"),
  "Progression ladder failure: the Shattered expedition must unlock the Shattered Planet"
)
