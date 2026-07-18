return function(shared)
  local enable_orbital_and_planetary_integration = shared.enable_orbital_and_planetary_integration
  local enable_combat_recipe_integration = shared.enable_combat_recipe_integration
  local patch_recipe_ingredients = shared.patch_recipe_ingredients
  local patch_recipe_ingredient_spec = shared.patch_recipe_ingredient_spec
  local patch_many_recipes = shared.patch_many_recipes
  local patch_recipe_set = shared.patch_recipe_set
  local remove_recipe_ingredient = shared.remove_recipe_ingredient
  local replace_recipe_ingredient = shared.replace_recipe_ingredient

  -- Start with the obvious stuff.
  -- Green circuits stay mostly normal. Red/blue chips get dragged into our goofy little electronics ladder.
  patch_recipe_set({
    { "electronic-circuit", "fw-circuit-contact", 1 },
    { "advanced-circuit", "fw-solder-wire", 1 },
    { "advanced-circuit", "fw-chip-carrier", 1 },
    { "advanced-circuit", "fw-microchip", 1 },
    { "processing-unit", "fw-microchip", 1 },
    { "processing-unit", "fw-memory-die", 1 },
    { "engine-unit", "fw-bearing", 1 },
    { "electric-engine-unit", "fw-bearing", 1 },
    { "flying-robot-frame", "fw-light-frame", 1 },
    { "low-density-structure", "fw-light-frame", 1 },
    { "battery", "fw-ceramic-insulator", 1 },
    { "accumulator", "fw-capacitor", 2 },
    { "firearm-magazine", "fw-gunpowder", 1 },
    { "piercing-rounds-magazine", "firearm-magazine", 1 },
    { "piercing-rounds-magazine", "fw-gunpowder", 1 },
    { "uranium-rounds-magazine", "piercing-rounds-magazine", 1 },
    { "uranium-rounds-magazine", "fw-gunpowder", 1 },
    { "lab", "fw-glass", 4 },
    { "lab", "fw-ceramic-insulator", 2 },
    { "biolab", "fw-glass", 20 },
    { "biolab", "fw-capacitor", 8 },
    { "fast-inserter", "fw-steel-beam", 1 },
    { "filter-inserter", "fw-steel-beam", 1 },
    { "stack-inserter", "fw-aluminum-beam", 1 },
    { "stack-filter-inserter", "fw-aluminum-beam", 1 },
    { "bulk-inserter", "fw-aluminum-beam", 1 },
    { "assembling-machine-2", "fw-steel-beam", 1 },
    { "assembling-machine-2", "fw-circuit-substrate", 1 },
    { "assembling-machine-3", "fw-aluminum-beam", 2 },
    { "assembling-machine-3", "fw-inductor-coil", 2 },
    { "electric-mining-drill", "fw-steel-beam", 1 },
    { "electric-furnace", "fw-composite-panel", 2 },
    { "electric-furnace", "fw-inductor-coil", 1 },
    { "medium-electric-pole", "fw-steel-beam", 1 },
    { "substation", "fw-aluminum-beam", 2 },
    { "substation", "fw-inductor-coil", 1 },
    { "radar", "fw-circuit-substrate", 2 },
    { "solar-panel", "fw-glass", 2 },
    { "solar-panel", "fw-copper-tube", 2 },
    { "laser-turret", "fw-capacitor", 1 },
    { "laser-turret", "fw-inductor-coil", 2 },
    { "speed-module", "fw-ribbon-cable", 1 },
    { "module", "fw-solder-wire", 1 },
    { "module", "fw-chip-carrier", 1 },
    { "speed-module", "fw-microchip", 1 },
    { "effectivity-module", "fw-ribbon-cable", 1 },
    { "productivity-module", "fw-sensor-package", 1 },
    { "productivity-module", "fw-memory-die", 1 },
    { "effectivity-module-2", "fw-microchip", 1 },
    { "productivity-module-2", "fw-memory-die", 1 },
    { "speed-module-3", "fw-memory-die", 1 },
    { "productivity-module-3", "fw-memory-die", 2 },
    { "quality-module", "fw-chip-carrier", 1 },
    { "quality-module-3", "fw-memory-die", 1 },
    { "chemical-plant", "fw-inline-filter", 1 },
    { "oil-refinery", "fw-inline-filter", 2 },
    { "pumpjack", "fw-inline-filter", 1 },
    { "beacon", "fw-transformer-core", 2 },
    { "beacon", "fw-sensor-package", 2 },
    { "roboport", "fw-ribbon-cable", 2 },
    { "lab", "fw-glass-lens", 2 },
  })

  -- Now do the wider "yeah this should probably use our parts" pass.
  patch_recipe_ingredients("rocket-silo", "fw-composite-panel", 6)
  patch_recipe_ingredients("rocket-silo", "fw-transformer-core", 4)
  patch_recipe_ingredients("satellite", "fw-glass-lens", 4)
  patch_recipe_ingredients("satellite", "fw-sensor-package", 4)
  patch_recipe_ingredients("fission-reactor", "fw-cermet", 8)
  patch_recipe_ingredients("heat-pipe", "fw-cermet", 1)
  patch_recipe_ingredients("centrifuge", "fw-inline-filter", 2)
  patch_recipe_ingredients("nuclear-reactor", "fw-cermet", 8)
  patch_recipe_ingredients("rocket-fuel", "fw-inline-filter", 1)
  patch_recipe_ingredients("utility-science-pack", "fw-sensor-package", 1)
  patch_recipe_ingredients("production-science-pack", "fw-cermet", 1)
  replace_recipe_ingredient("flamethrower-ammo", "crude-oil", { type = "fluid", name = "fw-napalm", amount = 40 })

  -- Space Age gets the same treatment. No free pass just because it is in space.
  if enable_orbital_and_planetary_integration then
    patch_recipe_ingredients("electromagnetic-plant", "fw-transformer-core", 4)
    patch_recipe_ingredients("electromagnetic-plant", "fw-ribbon-cable", 6)
    patch_recipe_ingredients("electromagnetic-plant", "fw-sensor-package", 4)
    patch_recipe_ingredients("electromagnetic-plant", "fw-memory-die", 2)
    patch_recipe_ingredients("foundry", "fw-cermet", 8)
    patch_recipe_ingredients("foundry", "fw-composite-panel", 4)
    patch_recipe_ingredients("recycler", "fw-inline-filter", 3)
    patch_recipe_ingredients("recycler", "fw-cermet", 2)
    patch_recipe_ingredients("biochamber", "fw-inline-filter", 2)
    patch_recipe_ingredients("cryogenic-plant", "fw-transformer-core", 4)
    patch_recipe_ingredients("cryogenic-plant", "fw-cermet", 4)
    patch_recipe_ingredients("cryogenic-plant", "fw-memory-die", 1)

    patch_recipe_ingredients("supercapacitor", "fw-capacitor", 2)
    patch_recipe_ingredients("supercapacitor", "fw-ribbon-cable", 2)
    patch_recipe_ingredients("superconductor", "fw-ribbon-cable", 2)
    patch_recipe_ingredients("superconductor", "fw-cermet", 1)
    patch_recipe_ingredients("quantum-processor", "fw-sensor-package", 2)
    patch_recipe_ingredients("quantum-processor", "fw-glass-lens", 2)
    patch_recipe_ingredients("quantum-processor", "fw-ribbon-cable", 2)
    patch_recipe_ingredients("quantum-processor", "fw-memory-die", 2)
    patch_recipe_ingredients("holmium-plate", "fw-inline-filter", 1)
    patch_recipe_ingredients("tungsten-carbide", "fw-cermet", 1)
    patch_recipe_ingredients("carbon-fiber", "fw-inline-filter", 1)
    patch_recipe_ingredients("carbon-fiber", "fw-composite-panel", 1)

    patch_recipe_ingredients("space-platform-foundation", "fw-composite-panel", 4)
    patch_recipe_ingredients("space-platform-foundation", "fw-cermet", 2)
    patch_recipe_ingredients("space-platform-starter-pack", "fw-transformer-core", 3)
    patch_recipe_ingredients("space-platform-starter-pack", "fw-sensor-package", 3)
    patch_recipe_ingredients("space-platform-starter-pack", "fw-memory-die", 2)
    patch_recipe_ingredients("space-platform-starter-pack", "fw-rocket-engine", 2)
    patch_recipe_ingredients("asteroid-collector", "fw-inline-filter", 2)
    patch_recipe_ingredients("asteroid-collector", "fw-cermet", 2)
    patch_recipe_ingredients("cargo-landing-pad", "fw-composite-panel", 4)
    patch_recipe_ingredients("cargo-bay", "fw-inline-filter", 2)
    patch_recipe_ingredients("thruster", "fw-cermet", 2)
    patch_recipe_ingredients("thruster", "fw-rocket-engine", 2)
    patch_recipe_ingredients("space-platform-hub", "fw-transformer-core", 2)
    patch_recipe_ingredients("space-platform-hub", "fw-memory-die", 2)
    patch_recipe_ingredients("space-platform-hub", "fw-rocket-engine", 1)

    patch_recipe_ingredients("electromagnetic-science-pack", "fw-sensor-package", 1)
    patch_recipe_ingredients("metallurgic-science-pack", "fw-cermet", 1)
    patch_recipe_ingredients("agricultural-science-pack", "fw-inline-filter", 1)
    patch_recipe_ingredients("cryogenic-science-pack", "fw-glass-lens", 1)
    patch_recipe_ingredients("promethium-science-pack", "fw-transformer-core", 1)
  end

  -- Resource-driven integration pass: lead for fluid systems, titanium for high-tier structures.
  patch_recipe_ingredients("pipe-to-ground", "lead-plate", 2)
  patch_recipe_ingredients("storage-tank", "lead-plate", 4)
  patch_recipe_ingredients("pump", "lead-plate", 2)
  patch_recipe_ingredients("chemical-plant", "lead-plate", 2)
  patch_recipe_ingredients("oil-refinery", "lead-plate", 4)

  patch_recipe_ingredients("heat-exchanger", "titanium-plate", 4)
  patch_recipe_ingredients("heat-pipe", "titanium-plate", 1)
  patch_recipe_ingredients("centrifuge", "titanium-plate", 4)
  patch_recipe_ingredients("nuclear-reactor", "titanium-plate", 12)
  patch_recipe_ingredients("rocket-silo", "titanium-plate", 20)
  patch_recipe_ingredients("satellite", "titanium-plate", 8)
  patch_recipe_ingredients("beacon", "titanium-plate", 6)
  patch_recipe_ingredients("fusion-reactor-equipment", "titanium-plate", 20)
  patch_recipe_ingredients("power-armor-mk2", "titanium-plate", 30)
  patch_recipe_ingredients("fusion-reactor-equipment", "fw-rocket-engine", 2)
  patch_recipe_ingredients("power-armor-mk2", "fw-rocket-engine", 2)

  patch_recipe_ingredients("space-platform-foundation", "titanium-plate", 4)
  patch_recipe_ingredients("thruster", "titanium-plate", 6)
  patch_recipe_ingredients("space-platform-hub", "titanium-plate", 8)
  patch_recipe_ingredients("cargo-landing-pad", "titanium-plate", 8)
  patch_recipe_ingredients("asteroid-collector", "titanium-plate", 4)
  patch_recipe_ingredients("electromagnetic-plant", "titanium-plate", 6)
  patch_recipe_ingredients("cryogenic-plant", "titanium-plate", 6)

  -- Additional material-chain rebalance: use refined products in component recipes.
  patch_recipe_set({
    { "electronic-circuit", "silicon", 1 },
    { "advanced-circuit", "silicon", 1 },
    { "processing-unit", "silicon", 1 },
    { "solar-panel", "silicon", 2 },
    { "accumulator", "silicon", 1 },
    { "flying-robot-frame", "aluminum-plate", 2 },
    { "low-density-structure", "aluminum-plate", 2 },
    { "roboport", "aluminum-plate", 4 },
    { "personal-roboport-equipment", "aluminum-plate", 4 },
    { "exoskeleton-equipment", "aluminum-plate", 8 },
    { "battery", "lead-plate", 1 },
    { "accumulator", "lead-plate", 1 },
    { "explosives", "fw-salt", 1 },
    { "grenade", "tin-plate", 1 },
    { "cluster-grenade", "tin-plate", 2 },
    { "rocket", "tin-plate", 1 },
    { "explosive-rocket", "tin-plate", 1 },
    { "firearm-magazine", "tin-plate", 1 },
    { "piercing-rounds-magazine", "tin-plate", 1 },
    { "uranium-rounds-magazine", "tin-plate", 1 },
    { "engine-unit", "lead-plate", 1 },
    { "electric-engine-unit", "lead-plate", 1 },
    { "steam-engine", "bronze-plate", 1 },
    { "steam-turbine", "bronze-plate", 2 },
    { "rail", "bronze-plate", 1 },
    { "car", "bronze-plate", 2 },
    { "locomotive", "bronze-plate", 4 },
    { "cargo-wagon", "bronze-plate", 3 },
    { "fluid-wagon", "bronze-plate", 3 },
    { "tank", "bronze-plate", 6 },
    { "pumpjack", "lead-plate", 2 },
    { "offshore-pump", "lead-plate", 2 },
    { "pump", "electronic-circuit", 1 },
    { "offshore-pump", "electronic-circuit", 2 },
    { "laser-turret", "silicon", 2 },
    { "radar", "aluminum-plate", 2 },
    { "modular-armor", "aluminum-plate", 6 },
    { "flamethrower-turret", "lead-plate", 6 },
    { "artillery-turret", "titanium-plate", 12 },
    { "personal-roboport-mk2-equipment", "titanium-plate", 8 },
    { "spidertron", "titanium-plate", 20 },
    { "railgun", "titanium-plate", 12 },
    { "railgun-turret", "titanium-plate", 20 },
    { "rocket-silo", "silicon", 16 },
    { "thruster", "silicon", 6 },
    { "space-platform-hub", "silicon", 6 },
    { "space-platform-foundation", "lead-plate", 4 },
    { "cargo-landing-pad", "lead-plate", 6 },
    { "electromagnetic-plant", "silicon", 8 },
    { "quantum-processor", "silicon", 4 },
    { "superconductor", "silicon", 2 },
    { "railgun", "silicon", 6 },
    { "carbon-fiber", "carbon", 2 },
    { "plastic-bar", "carbon", 1 },
  })

  -- Small coherence pass for chemistry and fire-control surfaces.
  if enable_combat_recipe_integration then
    remove_recipe_ingredient("poison-capsule", "fw-sensor-package")
    remove_recipe_ingredient("slowdown-capsule", "fw-sensor-package")
    remove_recipe_ingredient("cliff-explosives", "fw-sensor-package")
  end

  patch_recipe_set({
    { "flamethrower-turret", "fw-flow-regulator", 1 },
    { "electrolyte", "fw-resin", 1 },
    { "electrolyte", "fw-inline-filter", 1 },
    { "lithium", "fw-inline-filter", 1 },
    { "lithium", "fw-lens-array", 1 },
    { "fluoroketone", "fw-thermal-buffer", 1 },
    { "fluoroketone", "fw-flow-regulator", 1 },
    { "fluoroketone-cooling", "fw-cryo-coil", 1 },
    { "superconductor", "fw-rubber-sheet", 1 },
    { "superconductor", "fw-cryo-coil", 1 },
    { "supercapacitor", "fw-power-regulator", 1 },
    { "supercapacitor", "fw-coil-block", 1 },
    { "fusion-power-cell", "fw-thermal-buffer", 1 },
    { "fusion-power-cell", "fw-power-regulator", 1 },
    { "fission-reactor-equipment", "fw-pressure-housing", 2 },
    { "fission-reactor-equipment", "fw-flow-regulator", 1 },
    { "battery-mk2-equipment", "fw-power-regulator", 1 },
    { "battery-mk2-equipment", "fw-capacitor", 2 },
  })

  if enable_combat_recipe_integration then
    patch_recipe_set({
      { "poison-capsule", "fw-inline-filter", 1 },
      { "slowdown-capsule", "fw-resin", 1 },
    })
  end

  for _, patch in ipairs({
    { "electrolyte", "fw-yellow-flux", 8 },
    { "lithium", "fw-yellow-flux", 12 },
    { "fluoroketone", "fw-red-flux", 18 },
    { "fluoroketone-cooling", "fw-green-flux", 10 },
  }) do
    patch_recipe_ingredient_spec(patch[1], { type = "fluid", name = patch[2], amount = patch[3] })
  end

  -- Wide integration pass across base game + Space Age surfaces.
  patch_many_recipes({
    "fast-transport-belt",
    "express-transport-belt",
    "turbo-transport-belt",
    "fast-underground-belt",
    "express-underground-belt",
    "turbo-underground-belt",
    "fast-splitter",
    "express-splitter",
    "turbo-splitter",
  }, "fw-steel-beam", 1)

  patch_many_recipes({
    "bulk-inserter",
    "stack-inserter",
    "stack-filter-inserter",
    "filter-inserter",
  }, "fw-circuit-substrate", 1)

  patch_many_recipes({
    "assembling-machine-2",
    "assembling-machine-3",
    "electric-furnace",
    "recycler",
    "foundry",
  }, "fw-composite-panel", 1)

  if enable_combat_recipe_integration then
    patch_many_recipes({
      "laser-turret",
      "flamethrower-turret",
      "artillery-turret",
      "tank",
      "car",
    }, "fw-cermet", 2)
  end

  patch_many_recipes({
    "locomotive",
    "cargo-wagon",
    "fluid-wagon",
    "artillery-wagon",
    "train-stop",
    "rail-signal",
    "rail-chain-signal",
    "rail",
    "rail-ramp",
    "rail-support",
  }, "fw-steel-beam", 1)

  patch_many_recipes({
    "steam-engine",
    "steam-turbine",
  }, "fw-transformer-core", 1)

  patch_many_recipes({
    "chemical-plant",
    "oil-refinery",
    "centrifuge",
    "pumpjack",
    "offshore-pump",
    "electrolyser",
    "cryogenic-plant",
    "biochamber",
  }, "fw-inline-filter", 1)

  patch_many_recipes({
    "electric-engine-unit",
    "flying-robot-frame",
    "construction-robot",
    "logistic-robot",
    "roboport",
    "beacon",
    "radar",
  }, "fw-sensor-package", 1)

  patch_many_recipes({
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
  }, "fw-memory-die", 1)

  patch_many_recipes({
    "automation-science-pack",
    "logistic-science-pack",
    "military-science-pack",
    "chemical-science-pack",
    "production-science-pack",
    "utility-science-pack",
    "space-science-pack",
    "metallurgic-science-pack",
    "electromagnetic-science-pack",
    "agricultural-science-pack",
    "cryogenic-science-pack",
    "promethium-science-pack",
  }, "fw-glass-lens", 1)

  patch_many_recipes({
    "rocket-silo",
    "satellite",
    "space-platform-foundation",
    "space-platform-starter-pack",
    "thruster",
    "space-platform-hub",
    "cargo-landing-pad",
    "asteroid-collector",
  }, "fw-rocket-engine", 1)

  -- Space Age deep integration pass: orbital hardware and late-game planetary systems.
  if enable_orbital_and_planetary_integration then
    patch_many_recipes({
      "thruster",
      "space-platform-hub",
      "space-platform-starter-pack",
      "cargo-landing-pad",
      "asteroid-collector",
      "cargo-bay",
    }, "fw-rocket-avionics", 1)

    patch_many_recipes({
      "thruster",
      "space-platform-hub",
      "space-platform-starter-pack",
      "space-platform-foundation",
      "cargo-landing-pad",
    }, "fw-rocket-heatshield", 1)

    patch_many_recipes({
      "electromagnetic-science-pack",
      "metallurgic-science-pack",
      "agricultural-science-pack",
      "cryogenic-science-pack",
      "promethium-science-pack",
    }, "fw-capacitor", 1)

    if enable_incomplete_rocket_parts then
      for _, recipe_name in ipairs({
        "space-platform-hub",
        "cargo-landing-pad",
      }) do
        remove_recipe_ingredient(recipe_name, "fw-rocket-engine")
        remove_recipe_ingredient(recipe_name, "fw-rocket-avionics")
        remove_recipe_ingredient(recipe_name, "fw-rocket-heatshield")
        patch_recipe_ingredients(recipe_name, "incomplete-rocket-part", 1)
      end

      remove_recipe_ingredient("space-platform-starter-pack", "fw-rocket-avionics")
      remove_recipe_ingredient("space-platform-starter-pack", "fw-rocket-heatshield")
      patch_recipe_ingredients("space-platform-starter-pack", "incomplete-rocket-part", 1)
    end

    patch_many_recipes({
      "cryogenic-plant",
      "fusion-generator",
      "fusion-reactor",
    }, "fw-spectral-reservoir", 1)

    patch_many_recipes({
      "space-platform-hub",
      "cargo-bay",
    }, "fw-rift-exchange-gate", 1)

    patch_many_recipes({
      "fusion-generator",
      "fusion-reactor",
      "fusion-reactor-equipment",
      "power-armor-mk2",
    }, "fw-transformer-core", 2)

    patch_many_recipes({
      "fusion-generator",
      "fusion-reactor",
      "fusion-reactor-equipment",
      "power-armor-mk2",
    }, "fw-cermet", 2)

    patch_many_recipes({
      "biolab",
      "electromagnetic-plant",
      "cryogenic-plant",
      "foundry",
      "recycler",
      "crusher",
    }, "fw-sensor-package", 1)
  end

  -- Extra-wide integration pass: intermediates, combat, logistics, and utility.
  patch_many_recipes({
    "electronic-circuit",
    "advanced-circuit",
    "processing-unit",
    "module",
    "speed-module",
    "effectivity-module",
    "productivity-module",
    "quality-module",
  }, "fw-circuit-contact", 1)

  patch_many_recipes({
    "small-electric-pole",
    "medium-electric-pole",
    "big-electric-pole",
    "substation",
    "power-switch",
    "programmable-speaker",
    "arithmetic-combinator",
    "decider-combinator",
    "constant-combinator",
    "selector-combinator",
  }, "fw-copper-tube", 1)

  patch_many_recipes({
    "steel-furnace",
    "electric-furnace",
    "assembling-machine-2",
    "assembling-machine-3",
    "chemical-plant",
    "oil-refinery",
    "centrifuge",
    "lab",
  }, "fw-steel-beam", 1)

  patch_many_recipes({
    "storage-tank",
    "pump",
    "offshore-pump",
    "pipe-to-ground",
    "heat-exchanger",
    "heat-pipe",
    "steam-engine",
    "steam-turbine",
  }, "fw-inline-filter", 1)

  patch_many_recipes({
    "repair-pack",
    "radar",
    "beacon",
    "roboport",
    "construction-robot",
    "logistic-robot",
    "personal-roboport-equipment",
    "personal-roboport-mk2-equipment",
  }, "fw-solder-wire", 1)

  patch_many_recipes({
    "logistic-chest-active-provider",
    "logistic-chest-passive-provider",
    "logistic-chest-storage",
    "logistic-chest-buffer",
    "logistic-chest-requester",
    "requester-chest",
    "buffer-chest",
  }, "fw-chip-carrier", 1)

  patch_many_recipes({
    "gate",
    "wall",
    "stone-wall",
    "laser-turret",
    "flamethrower-turret",
    "artillery-turret",
    "land-mine",
  }, "fw-cermet", 1)

  if enable_combat_recipe_integration then
    patch_many_recipes({
      "grenade",
      "cluster-grenade",
      "rocket",
      "explosive-rocket",
      "cannon-shell",
      "explosive-cannon-shell",
      "shotgun-shell",
      "piercing-shotgun-shell",
      "firearm-magazine",
      "piercing-rounds-magazine",
      "uranium-rounds-magazine",
    }, "fw-gunpowder", 1)

    -- Do not make the first ammo tier annoying for no reason.
    -- It just wants the gunpowder bit, not a whole side quest in metal parts.
    remove_recipe_ingredient("firearm-magazine", "tin-plate")

    patch_many_recipes({
      "defender-capsule",
      "distractor-capsule",
      "destroyer-capsule",
      "poison-capsule",
      "slowdown-capsule",
      "cliff-explosives",
    }, "fw-sensor-package", 1)
  end

  patch_many_recipes({
    "locomotive",
    "cargo-wagon",
    "fluid-wagon",
    "artillery-wagon",
    "rail",
    "rail-ramp",
    "rail-support",
    "rail-signal",
    "rail-chain-signal",
    "train-stop",
  }, "fw-aluminum-beam", 1)

  patch_many_recipes({
    "pumpjack",
    "centrifuge",
    "electrolyser",
    "electromagnetic-plant",
    "cryogenic-plant",
    "foundry",
    "biochamber",
    "recycler",
    "crusher",
  }, "fw-transformer-core", 1)

  patch_many_recipes({
    "accumulator",
    "fusion-generator",
    "fusion-reactor",
    "fusion-reactor-equipment",
    "battery-mk2-equipment",
    "exoskeleton-equipment",
    "energy-shield-mk2-equipment",
  }, "fw-capacitor", 1)

  patch_many_recipes({
    "power-armor",
    "power-armor-mk2",
    "modular-armor",
    "mech-armor",
    "night-vision-equipment",
    "belt-immunity-equipment",
    "battery-equipment",
    "battery-mk2-equipment",
  }, "fw-composite-panel", 1)

  patch_many_recipes({
    "space-platform-starter-pack",
    "space-platform-foundation",
    "thruster",
    "space-platform-hub",
    "asteroid-collector",
    "cargo-bay",
    "cargo-landing-pad",
  }, "fw-light-frame", 1)
end
