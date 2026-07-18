return function(shared)
  local enable_orbital_and_planetary_integration = shared.enable_orbital_and_planetary_integration
  local enable_combat_recipe_integration = shared.enable_combat_recipe_integration
  local patch_many_recipes = shared.patch_many_recipes
  local patch_recipe_set = shared.patch_recipe_set
  local remove_recipe_ingredient = shared.remove_recipe_ingredient

  -- Time to back off a little.
  -- We still want the FluxWorks flavor, just not smeared on absolutely everything.
  for _, recipe_name in ipairs({
    "steam-engine",
    "steam-turbine",
    "pumpjack",
    "centrifuge",
    "electrolyser",
    "electromagnetic-plant",
    "cryogenic-plant",
    "foundry",
    "biochamber",
    "recycler",
    "crusher",
    "fusion-generator",
    "fusion-reactor",
    "fusion-reactor-equipment",
    "power-armor-mk2",
    "rocket-silo",
    "space-platform-starter-pack",
    "space-platform-hub",
  }) do
    remove_recipe_ingredient(recipe_name, "fw-transformer-core")
  end

  for _, recipe_name in ipairs({
    "electric-engine-unit",
    "flying-robot-frame",
    "construction-robot",
    "logistic-robot",
    "roboport",
    "beacon",
    "radar",
    "biolab",
    "electromagnetic-plant",
    "cryogenic-plant",
    "foundry",
    "recycler",
    "crusher",
    "satellite",
  }) do
    remove_recipe_ingredient(recipe_name, "fw-sensor-package")
  end

  for _, recipe_name in ipairs({
    "module",
    "speed-module",
    "effectivity-module",
    "productivity-module",
    "quality-module",
    "speed-module-2",
    "effectivity-module-2",
    "productivity-module-2",
    "quality-module-2",
    "speed-module-3",
    "effectivity-module-3",
    "productivity-module-3",
    "quality-module-3",
    "processing-unit",
    "quantum-processor",
    "space-platform-starter-pack",
    "space-platform-hub",
  }) do
    remove_recipe_ingredient(recipe_name, "fw-memory-die")
  end

  for _, recipe_name in ipairs({
    "rocket-silo",
    "satellite",
    "space-platform-foundation",
    "space-platform-starter-pack",
    "thruster",
    "space-platform-hub",
    "cargo-landing-pad",
    "asteroid-collector",
  }) do
    remove_recipe_ingredient(recipe_name, "fw-rocket-engine")
    remove_recipe_ingredient(recipe_name, "fw-rocket-avionics")
    remove_recipe_ingredient(recipe_name, "fw-rocket-heatshield")
  end

  for _, recipe_name in ipairs({
    "space-platform-foundation",
    "space-platform-starter-pack",
    "thruster",
    "space-platform-hub",
    "asteroid-collector",
    "cargo-bay",
    "cargo-landing-pad",
  }) do
    remove_recipe_ingredient(recipe_name, "fw-light-frame")
  end

  for _, recipe_name in ipairs({
    "rocket-silo",
    "satellite",
    "beacon",
    "fusion-reactor-equipment",
    "power-armor-mk2",
    "space-platform-foundation",
    "thruster",
    "space-platform-hub",
    "cargo-landing-pad",
    "asteroid-collector",
    "electromagnetic-plant",
    "cryogenic-plant",
  }) do
    remove_recipe_ingredient(recipe_name, "titanium-plate")
  end

  for _, recipe_name in ipairs({
    "assembling-machine-2",
    "assembling-machine-3",
    "electric-furnace",
    "recycler",
    "crusher",
    "foundry",
    "power-armor",
    "power-armor-mk2",
    "modular-armor",
    "mech-armor",
    "night-vision-equipment",
    "belt-immunity-equipment",
    "battery-equipment",
    "battery-mk2-equipment",
  }) do
    remove_recipe_ingredient(recipe_name, "fw-composite-panel")
  end

  for _, recipe_name in ipairs({
    "oil-refinery",
    "chemical-plant",
    "centrifuge",
    "pumpjack",
    "offshore-pump",
    "electrolyser",
    "cryogenic-plant",
    "biochamber",
    "storage-tank",
    "pump",
    "pipe-to-ground",
    "heat-exchanger",
    "heat-pipe",
    "steam-engine",
    "steam-turbine",
  }) do
    remove_recipe_ingredient(recipe_name, "fw-inline-filter")
  end

  -- Higher-tier pass.
  -- This is the part where the expensive toys start admitting they should use the nice parts.
  if enable_orbital_and_planetary_integration then
    patch_recipe_set({
      { "engine-unit", "fw-pressure-housing", 1 },
      { "electric-engine-unit", "fw-flow-regulator", 1 },
      { "centrifuge", "fw-pressure-housing", 1 },
      { "electrolyser", "fw-pressure-housing", 1 },
      { "recycler", "fw-pressure-housing", 1 },
      { "big-mining-drill", "fw-pressure-housing", 2 },
      { "big-mining-drill", "fw-flow-regulator", 1 },
      { "foundry", "fw-power-regulator", 1 },
      { "foundry", "fw-foundry-lining", 1 },
      { "fw-arc-foundry", "fw-foundry-lining", 2 },
      { "electric-furnace", "fw-foundry-lining", 1 },
      { "biochamber", "fw-flow-regulator", 1 },
      { "biochamber", "fw-gleba-spore-resin", 1 },
      { "cryogenic-plant", "fw-power-regulator", 1 },
      { "electromagnetic-plant", "fw-power-regulator", 1 },
      { "supercapacitor", "fw-power-regulator", 1 },
      { "superconductor", "fw-cryo-coil", 1 },
      { "superconductor", "fw-aquilo-cryogel", 1 },
      { "superconductor", "fw-fulgora-static-mesh", 1 },
      { "supercapacitor", "fw-fulgora-static-mesh", 1 },
      { "quantum-processor", "fw-em-core", 1 },
      { "quantum-processor", "fw-logic-matrix", 1 },
      { "quantum-processor", "fw-resonance-substrate", 1 },
      { "thruster", "fw-annealed-cermet", 2 },
      { "space-platform-hub", "fw-annealed-cermet", 2 },
      { "cargo-landing-pad", "fw-annealed-cermet", 2 },
      { "space-platform-starter-pack", "fw-annealed-cermet", 1 },
      { "space-platform-foundation", "fw-annealed-cermet", 1 },
      { "asteroid-collector", "fw-annealed-cermet", 1 },
      { "rocket-silo", "fw-power-regulator", 2 },
      { "rocket-silo", "fw-logic-matrix", 1 },
      { "satellite", "fw-lens-array", 2 },
      { "satellite", "fw-sensor-package", 1 },
      { "fusion-generator", "fw-rift-stabilizer", 1 },
      { "fusion-reactor", "fw-rift-stabilizer", 1 },
      { "fusion-reactor-equipment", "fw-rift-stabilizer", 1 },
      { "power-armor-mk2", "fw-rift-stabilizer", 1 },
      { "mech-armor", "fw-rift-stabilizer", 1 },
      { "fusion-generator", "fw-aquilo-cryogel", 1 },
      { "fusion-generator", "fw-fulgora-static-mesh", 1 },
      { "fusion-reactor", "fw-vulcanus-slag-cermet", 1 },
      { "fusion-reactor", "fw-fulgora-static-mesh", 1 },
      { "fusion-reactor-equipment", "fw-aquilo-cryogel", 1 },
      { "fusion-reactor-equipment", "fw-vulcanus-slag-cermet", 1 },
      { "mech-armor", "fw-aquilo-cryogel", 1 },
      { "mech-armor", "fw-vulcanus-slag-cermet", 1 },
      { "teslagun", "fw-fulgora-static-mesh", 1 },
      { "tesla-turret", "fw-fulgora-static-mesh", 2 },
      { "tesla-ammo", "fw-fulgora-static-mesh", 1 },
      { "railgun", "fw-vulcanus-slag-cermet", 1 },
      { "railgun-turret", "fw-vulcanus-slag-cermet", 2 },
      { "railgun-ammo", "fw-vulcanus-slag-cermet", 1 },
      { "biolab", "fw-gleba-spore-resin", 1 },
      { "foundry", "fw-vulcanus-slag-cermet", 1 },
      { "cryogenic-plant", "fw-aquilo-cryogel", 1 },
      { "electromagnetic-plant", "fw-fulgora-static-mesh", 1 },
      { "fusion-generator", "fw-flux-resonance-cell", 1 },
      { "fusion-reactor", "fw-flux-resonance-cell", 1 },
      { "fusion-reactor-equipment", "fw-flux-resonance-cell", 1 },
      { "fusion-generator", "fw-flux-phase-manifold", 1 },
      { "fusion-reactor", "fw-flux-phase-manifold", 2 },
      { "fusion-reactor-equipment", "fw-flux-phase-manifold", 1 },
      { "power-armor-mk2", "fw-logic-matrix", 1 },
      { "mech-armor", "fw-logic-matrix", 1 },
      { "mech-armor", "fw-resonance-substrate", 2 },
      { "mech-armor", "fw-flux-resonance-cell", 1 },
      { "promethium-science-pack", "fw-flux-resonance-cell", 1 },
      { "promethium-science-pack", "fw-flux-phase-manifold", 1 },
      { "centrifuge", "fw-isotope-matrix", 1 },
      { "centrifuge", "fw-shielded-fuel-casing", 1 },
      { "centrifuge", "fw-moderator-lattice", 1 },
      { "nuclear-reactor", "fw-isotope-matrix", 2 },
      { "nuclear-reactor", "fw-control-rod-assembly", 2 },
      { "nuclear-reactor", "fw-moderator-lattice", 2 },
      { "nuclear-reactor", "fw-reactor-coolant-cartridge", 1 },
      { "fission-reactor", "fw-isotope-matrix", 2 },
      { "fission-reactor", "fw-control-rod-assembly", 2 },
      { "fission-reactor", "fw-moderator-lattice", 2 },
      { "fission-reactor", "fw-reactor-coolant-cartridge", 1 },
      { "fusion-generator", "fw-isotope-matrix", 1 },
      { "fusion-generator", "fw-control-rod-assembly", 1 },
      { "fusion-generator", "fw-reactor-coolant-cartridge", 1 },
      { "fusion-reactor", "fw-reactor-dopant", 1 },
      { "fusion-reactor", "fw-control-rod-assembly", 1 },
      { "fusion-reactor", "fw-shielded-fuel-casing", 2 },
      { "fusion-reactor", "fw-reactor-coolant-cartridge", 1 },
      { "fusion-reactor-equipment", "fw-reactor-dopant", 1 },
      { "fusion-reactor-equipment", "fw-control-rod-assembly", 1 },
      { "fusion-reactor-equipment", "fw-shielded-fuel-casing", 1 },
      { "fusion-reactor-equipment", "fw-reactor-coolant-cartridge", 1 },
      { "nuclear-fuel", "fw-reactor-dopant", 1 },
      { "nuclear-fuel", "fw-reactor-coolant-cartridge", 1 },
      { "atomic-bomb", "fw-reactor-dopant", 1 },
      { "atomic-bomb", "fw-moderator-lattice", 1 },
      { "promethium-science-pack", "fw-reactor-dopant", 1 },
    })
  end

  -- Whole-game cleanup pass.
  -- Thread the newer parts in where they belong, but keep the counts sane so the factory does not turn into soup.
  patch_many_recipes({
    "fast-splitter",
    "express-splitter",
    "turbo-splitter",
    "bulk-inserter",
    "stack-inserter",
    "stack-filter-inserter",
    "train-stop",
    "rail-signal",
    "rail-chain-signal",
    "roboport",
  }, "fw-signal-conduit", 1)

  patch_many_recipes({
    "substation",
    "beacon",
    "power-switch",
    "electromagnetic-plant",
    "teslagun",
    "tesla-turret",
  }, "fw-field-winding", 1)

  patch_many_recipes({
    "storage-tank",
    "heat-exchanger",
    "heat-pipe",
    "nuclear-reactor",
    "fission-reactor-equipment",
    "fusion-reactor",
    "fusion-reactor-equipment",
  }, "fw-thermal-buffer", 1)

  patch_many_recipes({
    "fluid-wagon",
    "car",
    "tank",
    "spidertron",
    "locomotive",
    "cargo-wagon",
    "artillery-wagon",
  }, "fw-bearing", 1)

  patch_many_recipes({
    "fluid-wagon",
    "locomotive",
    "car",
    "tank",
    "spidertron",
  }, "fw-flow-regulator", 1)

  patch_many_recipes({
    "radar",
    "rocket-turret",
    "tesla-turret",
    "railgun-turret",
    "artillery-turret",
    "spidertron",
  }, "fw-lens-array", 1)

  patch_many_recipes({
    "satellite",
    "rocket-turret",
    "tesla-turret",
    "railgun-turret",
    "quantum-processor",
    "space-platform-hub",
  }, "fw-lens-array", 1)

  patch_recipe_set({
    { "spidertron", "fw-logic-matrix", 1 },
    { "spidertron", "fw-em-core", 1 },
    { "mech-armor", "fw-em-core", 1 },
    { "personal-laser-defense-equipment", "fw-coil-block", 1 },
    { "discharge-defense-equipment", "fw-coil-block", 1 },
    { "battery-equipment", "fw-power-regulator", 1 },
    { "night-vision-equipment", "fw-lens-array", 1 },
    { "energy-shield-equipment", "fw-ceramic-casing", 1 },
    { "energy-shield-mk2-equipment", "fw-ceramic-casing", 1 },
    { "fusion-generator", "fw-em-core", 1 },
    { "fusion-reactor", "fw-field-winding", 1 },
    { "fusion-reactor-equipment", "fw-field-winding", 1 },
    { "space-platform-foundation", "fw-foundry-lining", 1 },
    { "thruster", "fw-thermal-buffer", 1 },
    { "cargo-landing-pad", "fw-pressure-housing", 1 },
  })

  if enable_combat_recipe_integration then
    patch_recipe_set({
      { "rocket-turret", "fw-pressure-housing", 1 },
      { "rocket-turret", "fw-power-regulator", 1 },
      { "teslagun", "fw-em-core", 1 },
      { "tesla-turret", "fw-em-core", 1 },
      { "railgun", "fw-power-regulator", 1 },
      { "railgun-turret", "fw-power-regulator", 1 },
      { "railgun-turret", "fw-em-core", 1 },
    })
  end
end
