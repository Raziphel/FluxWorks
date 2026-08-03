return function(shared)
  local enable_orbital_and_planetary_integration = shared.enable_orbital_and_planetary_integration
  local patch_many_recipes = shared.patch_many_recipes
  local patch_recipe_set = shared.patch_recipe_set
  local remove_recipe_ingredient = shared.remove_recipe_ingredient
  local set_recipe_category = shared.set_recipe_category
  local set_recipe_ingredients = shared.set_recipe_ingredients

  -- The base crusher bootstraps comminution and stays within the steel-era envelope.
  set_recipe_ingredients("crusher", {
    { type = "item", name = "steel-plate", amount = 8 },
    { type = "item", name = "iron-gear-wheel", amount = 6 },
    { type = "item", name = "electronic-circuit", amount = 4 },
    { type = "item", name = "motor", amount = 2 },
    { type = "item", name = "stone-brick", amount = 10 },
  })

  -- Control equipment uses representative assemblies rather than the complete control catalog.
  remove_recipe_ingredient("train-stop", "fw-sensor-package")
  patch_recipe_set({
    { "train-stop", "fw-circuit-substrate", 1 },
    { "train-stop", "fw-signal-conduit", 1 },
    { "radar", "fw-signal-conduit", 1 },
    { "radar", "fw-lens-array", 1 },
    { "beacon", "fw-field-winding", 1 },
    { "lightning-collector", "fw-power-regulator", 1 },
    { "lightning-collector", "fw-fulgora-static-mesh", 1 },
    { "heating-tower", "fw-vulcanus-slag-cermet", 1 },
    { "electromagnetic-science-pack", "fw-power-regulator", 1 },
  })

  -- Orbital, sensing, thermal, and field hardware use consistent component families.
  if enable_orbital_and_planetary_integration then
    -- Keep the prep chemistry flexible, but let the capstones live on the proper planet machine lanes.
    for _, recipe_name in ipairs({
      "fw-electrolyte-conditioning",
      "fw-lithium-adsorption",
    }) do
      set_recipe_category(recipe_name, { "chemistry", "cryogenics" })
    end

    for _, recipe_name in ipairs({
      "fw-fluoroketone-synthesis",
      "fw-aquilo-cryogel",
      "fw-superconductor-bath",
    }) do
      set_recipe_category(recipe_name, "cryogenics")
    end

    set_recipe_category("fw-gleba-spore-resin", "organic")

    for _, recipe_name in ipairs({
      "fw-fulgora-static-mesh",
      "fw-supercapacitor-conditioning",
    }) do
      set_recipe_category(recipe_name, "electromagnetics")
    end

    set_recipe_category("fw-vulcanus-slag-cermet", "metallurgy")

    patch_many_recipes({
      "rocket-silo",
      "satellite",
      "space-platform-foundation",
      "space-platform-starter-pack",
      "space-platform-hub",
      "cargo-landing-pad",
      "cargo-bay",
      "asteroid-collector",
      "thruster",
    }, "fw-signal-conduit", 1)

    patch_many_recipes({
      "rocket-silo",
      "satellite",
      "space-platform-hub",
      "cargo-bay",
      "asteroid-collector",
      "biolab",
      "radar",
      "rocket-turret",
      "railgun-turret",
      "tesla-turret",
    }, "fw-lens-array", 1)

    patch_many_recipes({
      "nuclear-reactor",
      "fission-reactor",
      "fusion-reactor",
      "fusion-generator",
      "cryogenic-plant",
      "electromagnetic-plant",
      "foundry",
      "thruster",
    }, "fw-field-winding", 1)

    patch_many_recipes({
      "heat-exchanger",
      "heat-pipe",
      "steam-turbine",
      "nuclear-reactor",
      "fission-reactor",
      "fusion-reactor",
      "fusion-generator",
      "thruster",
    }, "fw-foundry-lining", 1)

    patch_recipe_set({
      { "electrolyser", "fw-reinforced-seal", 1 },
      { "heat-exchanger", "fw-reinforced-seal", 1 },
      { "steam-turbine", "fw-hydraulic-manifold", 1 },
      { "biolab", "fw-logic-matrix", 1 },
      { "rocket-silo", "fw-pressure-housing", 2 },
      { "rocket-silo", "fw-hydraulic-manifold", 1 },
      { "satellite", "fw-logic-matrix", 1 },
      { "space-platform-foundation", "fw-foundry-lining", 1 },
      { "space-platform-starter-pack", "fw-power-regulator", 1 },
      { "space-platform-hub", "fw-em-core", 1 },
      { "cargo-bay", "fw-pressure-housing", 1 },
      { "cargo-bay", "fw-hydraulic-manifold", 1 },
      { "asteroid-collector", "fw-flow-regulator", 1 },
      { "thruster", "fw-pressure-housing", 1 },
      { "thruster", "fw-hydraulic-manifold", 1 },
      { "fluid-wagon", "fw-hydraulic-manifold", 1 },
      { "nuclear-reactor", "fw-hydraulic-manifold", 1 },
      { "fission-reactor", "fw-thermal-buffer", 1 },
      { "fission-reactor", "fw-hydraulic-manifold", 1 },
      { "nuclear-reactor", "fw-thermal-buffer", 1 },
      { "fusion-reactor", "fw-em-core", 1 },
      { "fusion-reactor", "fw-hydraulic-manifold", 1 },
      { "fusion-generator", "fw-logic-matrix", 1 },
      { "fusion-generator", "fw-hydraulic-manifold", 1 },
      { "cryogenic-plant", "fw-thermal-buffer", 1 },
      { "cryogenic-plant", "fw-hydraulic-manifold", 1 },
      { "electromagnetic-plant", "fw-em-core", 1 },
      { "foundry", "fw-foundry-lining", 1 },
      { "rocket-turret", "fw-signal-conduit", 1 },
      { "railgun-turret", "fw-logic-matrix", 1 },
      { "tesla-turret", "fw-field-winding", 1 },
      { "mech-armor", "fw-em-core", 1 },
      { "spidertron", "fw-signal-conduit", 1 },
      { "superconductor", "fw-reinforced-seal", 1 },
      { "supercapacitor", "fw-reinforced-seal", 1 },
      { "quantum-processor", "fw-reinforced-seal", 1 },
      { "fusion-power-cell", "fw-reactor-dopant", 1 },
      { "fusion-power-cell", "fw-reactor-coolant-cartridge", 1 },
    })

    -- Space Age machines and orbital hardware still need to feel specialized,
    -- but not like every machine needs a sushi bus.
    set_recipe_ingredients("rocket-silo", {
      { type = "item", name = "steel-plate", amount = 1000 },
      { type = "item", name = "concrete", amount = 1000 },
      { type = "item", name = "pipe", amount = 100 },
      { type = "item", name = "processing-unit", amount = 200 },
      { type = "item", name = "electric-engine-unit", amount = 200 },
      { type = "item", name = "fw-composite-panel", amount = 6 },
      { type = "item", name = "fw-power-regulator", amount = 2 },
    })

    set_recipe_ingredients("space-platform-foundation", {
      { type = "item", name = "steel-plate", amount = 20 },
      { type = "item", name = "copper-cable", amount = 20 },
      { type = "item", name = "fw-composite-panel", amount = 4 },
      { type = "item", name = "fw-annealed-cermet", amount = 1 },
      { type = "item", name = "fw-foundry-lining", amount = 1 },
      { type = "item", name = "fw-signal-conduit", amount = 1 },
    })

    set_recipe_ingredients("cargo-landing-pad", {
      { type = "item", name = "concrete", amount = 200 },
      { type = "item", name = "steel-plate", amount = 25 },
      { type = "item", name = "processing-unit", amount = 10 },
      { type = "item", name = "fw-composite-panel", amount = 4 },
      { type = "item", name = "fw-pressure-housing", amount = 1 },
      { type = "item", name = "fw-signal-conduit", amount = 1 },
    })

    set_recipe_ingredients("cargo-bay", {
      { type = "item", name = "steel-plate", amount = 20 },
      { type = "item", name = "low-density-structure", amount = 20 },
      { type = "item", name = "processing-unit", amount = 5 },
      { type = "item", name = "fw-rocket-avionics", amount = 1 },
      { type = "item", name = "fw-pressure-housing", amount = 1 },
      { type = "item", name = "fw-hydraulic-manifold", amount = 1 },
    })

    -- Factorio 2.1's unloading extension is active cargo-handling machinery,
    -- not four passive chests bolted onto a cargo bay.
    set_recipe_ingredients("landing-pad-unloading-bay", {
      { type = "item", name = "cargo-bay", amount = 1 },
      { type = "item", name = "bulk-inserter", amount = 4 },
      { type = "item", name = "electric-engine-unit", amount = 8 },
      { type = "item", name = "fw-bearing", amount = 4 },
      { type = "item", name = "fw-hydraulic-manifold", amount = 2 },
      { type = "item", name = "fw-signal-conduit", amount = 2 },
    })

    set_recipe_ingredients("asteroid-collector", {
      { type = "item", name = "low-density-structure", amount = 20 },
      { type = "item", name = "electric-engine-unit", amount = 8 },
      { type = "item", name = "processing-unit", amount = 5 },
      { type = "item", name = "fw-harvester-head", amount = 1 },
      { type = "item", name = "fw-flow-regulator", amount = 1 },
      { type = "item", name = "fw-annealed-cermet", amount = 1 },
      { type = "item", name = "fw-pressure-housing", amount = 1 },
    })

    set_recipe_ingredients("thruster", {
      { type = "item", name = "steel-plate", amount = 10 },
      { type = "item", name = "processing-unit", amount = 10 },
      { type = "item", name = "electric-engine-unit", amount = 5 },
      { type = "item", name = "fw-annealed-cermet", amount = 2 },
      { type = "item", name = "fw-thermal-buffer", amount = 1 },
      { type = "item", name = "fw-pressure-housing", amount = 1 },
      { type = "item", name = "pipe", amount = 6 },
    })

    set_recipe_ingredients("foundry", {
      { type = "item", name = "tungsten-carbide", amount = 50 },
      { type = "item", name = "steel-plate", amount = 50 },
      { type = "item", name = "refined-concrete", amount = 20 },
      { type = "fluid", name = "lubricant", amount = 20 },
      { type = "item", name = "fw-cermet", amount = 8 },
      { type = "item", name = "fw-foundry-lining", amount = 1 },
      { type = "item", name = "fw-vulcanus-slag-cermet", amount = 1 },
    })

    set_recipe_ingredients("electromagnetic-plant", {
      { type = "item", name = "holmium-plate", amount = 150 },
      { type = "item", name = "steel-plate", amount = 50 },
      { type = "item", name = "processing-unit", amount = 50 },
      { type = "item", name = "refined-concrete", amount = 50 },
      { type = "item", name = "fw-ribbon-cable", amount = 6 },
      { type = "item", name = "fw-em-core", amount = 1 },
      { type = "item", name = "fw-fulgora-static-mesh", amount = 1 },
    })

    set_recipe_ingredients("cryogenic-plant", {
      { type = "item", name = "refined-concrete", amount = 40 },
      { type = "item", name = "superconductor", amount = 20 },
      { type = "item", name = "processing-unit", amount = 20 },
      { type = "item", name = "lithium-plate", amount = 20 },
      { type = "item", name = "fw-cryo-coil", amount = 1 },
      { type = "item", name = "fw-aquilo-cryogel", amount = 1 },
      { type = "item", name = "fw-thermal-buffer", amount = 1 },
      { type = "item", name = "pipe", amount = 4 },
    })

    set_recipe_ingredients("biochamber", {
      { type = "item", name = "nutrients", amount = 5 },
      { type = "item", name = "pentapod-egg", amount = 1 },
      { type = "item", name = "iron-plate", amount = 20 },
      { type = "item", name = "electronic-circuit", amount = 5 },
      { type = "item", name = "fw-inline-filter", amount = 2 },
      { type = "item", name = "fw-gleba-spore-resin", amount = 1 },
    })

    set_recipe_ingredients("biolab", {
      { type = "item", name = "lab", amount = 1 },
      { type = "item", name = "biter-egg", amount = 10 },
      { type = "item", name = "refined-concrete", amount = 25 },
      { type = "item", name = "capture-robot-rocket", amount = 2 },
      { type = "item", name = "uranium-235", amount = 3 },
      { type = "item", name = "fw-gleba-spore-resin", amount = 1 },
      { type = "item", name = "fw-logic-matrix", amount = 1 },
    })

    set_recipe_ingredients("nuclear-reactor", {
      { type = "item", name = "concrete", amount = 500 },
      { type = "item", name = "steel-plate", amount = 500 },
      { type = "item", name = "advanced-circuit", amount = 500 },
      { type = "item", name = "copper-plate", amount = 500 },
      { type = "item", name = "titanium-plate", amount = 12 },
      { type = "item", name = "fw-isotope-matrix", amount = 2 },
      { type = "item", name = "fw-control-rod-assembly", amount = 2 },
      { type = "item", name = "fw-reactor-coolant-cartridge", amount = 1 },
    })
  end

  set_recipe_ingredients("radar", {
    { type = "item", name = "electronic-circuit", amount = 5 },
    { type = "item", name = "iron-gear-wheel", amount = 5 },
    { type = "item", name = "iron-plate", amount = 10 },
    { type = "item", name = "fw-signal-conduit", amount = 1 },
    { type = "item", name = "fw-lens-array", amount = 1 },
  })

  set_recipe_ingredients("substation", {
    { type = "item", name = "steel-plate", amount = 10 },
    { type = "item", name = "advanced-circuit", amount = 5 },
    { type = "item", name = "copper-cable", amount = 6 },
    { type = "item", name = "fw-aluminum-beam", amount = 2 },
    { type = "item", name = "fw-power-regulator", amount = 1 },
    { type = "item", name = "fw-transformer-core", amount = 1 },
  })

  set_recipe_ingredients("oil-refinery", {
    { type = "item", name = "iron-gear-wheel", amount = 10 },
    { type = "item", name = "stone-brick", amount = 10 },
    { type = "item", name = "electronic-circuit", amount = 10 },
    { type = "item", name = "pipe", amount = 10 },
    { type = "item", name = "fw-copper-tube", amount = 4 },
    { type = "item", name = "fw-steel-beam", amount = 2 },
    { type = "item", name = "fw-inline-filter", amount = 2 },
  })

  set_recipe_ingredients("steam-turbine", {
    { type = "item", name = "iron-gear-wheel", amount = 50 },
    { type = "item", name = "copper-plate", amount = 50 },
    { type = "item", name = "bronze-plate", amount = 2 },
    { type = "item", name = "pipe", amount = 20 },
  })

  set_recipe_ingredients("lab", {
    { type = "item", name = "electronic-circuit", amount = 10 },
    { type = "item", name = "iron-gear-wheel", amount = 10 },
    { type = "item", name = "transport-belt", amount = 4 },
    { type = "item", name = "glass", amount = 4 },
    { type = "item", name = "fw-glass-lens", amount = 2 },
    { type = "item", name = "fw-steel-beam", amount = 1 },
  })

  set_recipe_ingredients("recycler", {
    { type = "item", name = "processing-unit", amount = 6 },
    { type = "item", name = "steel-plate", amount = 20 },
    { type = "item", name = "iron-gear-wheel", amount = 40 },
    { type = "item", name = "concrete", amount = 20 },
    { type = "item", name = "fw-inline-filter", amount = 3 },
    { type = "item", name = "fw-cermet", amount = 2 },
  })

  set_recipe_ingredients("flamethrower-turret", {
    { type = "item", name = "steel-plate", amount = 30 },
    { type = "item", name = "iron-gear-wheel", amount = 15 },
    { type = "item", name = "engine-unit", amount = 5 },
    { type = "item", name = "lead-plate", amount = 6 },
    { type = "item", name = "pipe", amount = 10 },
    { type = "item", name = "fw-flow-regulator", amount = 1 },
  })

  set_recipe_ingredients("superconductor", {
    { type = "item", name = "holmium-plate", amount = 1 },
    { type = "item", name = "copper-plate", amount = 1 },
    { type = "item", name = "plastic-bar", amount = 1 },
    { type = "fluid", name = "light-oil", amount = 5 },
    { type = "item", name = "fw-ribbon-cable", amount = 2 },
    { type = "item", name = "fw-cryo-coil", amount = 1 },
    { type = "item", name = "fw-aquilo-cryogel", amount = 1 },
  })

  set_recipe_ingredients("supercapacitor", {
    { type = "item", name = "holmium-plate", amount = 2 },
    { type = "item", name = "superconductor", amount = 2 },
    { type = "item", name = "electronic-circuit", amount = 4 },
    { type = "fluid", name = "electrolyte", amount = 10 },
    { type = "item", name = "fw-capacitor", amount = 2 },
    { type = "item", name = "fw-power-regulator", amount = 1 },
    { type = "item", name = "fw-fulgora-static-mesh", amount = 1 },
  })

  set_recipe_ingredients("quantum-processor", {
    { type = "item", name = "processing-unit", amount = 1 },
    { type = "item", name = "superconductor", amount = 1 },
    { type = "item", name = "lithium-plate", amount = 2 },
    { type = "fluid", name = "fluoroketone-cold", amount = 10 },
    { type = "item", name = "silicon", amount = 4 },
    { type = "item", name = "fw-em-core", amount = 1 },
    { type = "item", name = "fw-logic-matrix", amount = 1 },
    { type = "item", name = "fw-resonance-substrate", amount = 1 },
  })

  set_recipe_ingredients("fw-rocket-engine", {
    { type = "item", name = "engine-unit", amount = 1 },
    { type = "item", name = "electric-engine-unit", amount = 1 },
    { type = "item", name = "aluminum-plate", amount = 2 },
    { type = "item", name = "titanium-plate", amount = 2 },
    { type = "item", name = "fw-light-frame", amount = 1 },
    { type = "item", name = "fw-bearing", amount = 2 },
  })

  set_recipe_ingredients("fw-logic-matrix", {
    { type = "item", name = "fw-em-core", amount = 1 },
    { type = "item", name = "fw-microchip", amount = 1 },
    { type = "item", name = "fw-sensor-package", amount = 1 },
    { type = "item", name = "processing-unit", amount = 1 },
    { type = "item", name = "fw-resonance-substrate", amount = 1 },
    { type = "item", name = "fw-lens-array", amount = 1 },
  })

  set_recipe_ingredients("fw-synthesis-plant", {
    { type = "item", name = "chemical-plant", amount = 2 },
    { type = "item", name = "fw-pressure-housing", amount = 3 },
    { type = "item", name = "fw-flow-regulator", amount = 2 },
    { type = "item", name = "fw-circuit-substrate", amount = 3 },
    { type = "item", name = "fw-cermet", amount = 4 },
    { type = "item", name = "advanced-circuit", amount = 6 },
  })

  set_recipe_ingredients("fw-flux-harvester", {
    { type = "item", name = "crusher", amount = 1 },
    { type = "item", name = "chemical-plant", amount = 1 },
    { type = "item", name = "fw-pressure-housing", amount = 1 },
    { type = "item", name = "fw-flow-regulator", amount = 1 },
    { type = "item", name = "fw-harvester-head", amount = 1 },
    { type = "item", name = "fw-cermet", amount = 6 },
  })

  set_recipe_ingredients("fw-flux-condenser", {
    { type = "item", name = "fw-annealed-cermet", amount = 8 },
    { type = "item", name = "fw-resonance-substrate", amount = 4 },
    { type = "item", name = "fw-harvester-head", amount = 2 },
    { type = "item", name = "fw-condensed-flux-matrix", amount = 6 },
    { type = "item", name = "fw-flux-resonance-cell", amount = 4 },
    { type = "item", name = "fw-flux-phase-manifold", amount = 2 },
    { type = "item", name = "fw-em-core", amount = 2 },
  })

  -- Infrastructure, utility, and combat recipes stay specialized without
  -- becoming exhaustive lists of every upstream part.
  set_recipe_ingredients("heat-exchanger", {
    { type = "item", name = "steel-plate", amount = 20 },
    { type = "item", name = "copper-plate", amount = 100 },
    { type = "item", name = "pipe", amount = 10 },
    { type = "item", name = "fw-foundry-lining", amount = 1 },
    { type = "item", name = "fw-reinforced-seal", amount = 1 },
  })

  set_recipe_ingredients("centrifuge", {
    { type = "item", name = "concrete", amount = 100 },
    { type = "item", name = "steel-plate", amount = 50 },
    { type = "item", name = "advanced-circuit", amount = 100 },
    { type = "item", name = "iron-gear-wheel", amount = 100 },
    { type = "item", name = "titanium-plate", amount = 4 },
    { type = "item", name = "fw-isotope-matrix", amount = 1 },
    { type = "item", name = "fw-control-rod-assembly", amount = 1 },
  })

  set_recipe_ingredients("fluid-wagon", {
    { type = "item", name = "storage-tank", amount = 1 },
    { type = "item", name = "pipe", amount = 8 },
    { type = "item", name = "fw-steel-beam", amount = 1 },
    { type = "item", name = "fw-bearing", amount = 1 },
    { type = "item", name = "fw-hydraulic-manifold", amount = 1 },
  })

  set_recipe_ingredients("accumulator", {
    { type = "item", name = "iron-plate", amount = 2 },
    { type = "item", name = "battery", amount = 5 },
    { type = "item", name = "fw-capacitor", amount = 2 },
    { type = "item", name = "silicon", amount = 1 },
    { type = "item", name = "fw-ceramic-insulator", amount = 1 },
    { type = "item", name = "fw-power-regulator", amount = 1 },
  })

  set_recipe_ingredients("power-switch", {
    { type = "item", name = "iron-plate", amount = 5 },
    { type = "item", name = "copper-cable", amount = 5 },
    { type = "item", name = "electronic-circuit", amount = 2 },
    { type = "item", name = "fw-field-winding", amount = 1 },
    { type = "item", name = "fw-signal-conduit", amount = 1 },
    { type = "item", name = "fw-circuit-substrate", amount = 1 },
  })

  set_recipe_ingredients("programmable-speaker", {
    { type = "item", name = "iron-plate", amount = 3 },
    { type = "item", name = "copper-cable", amount = 5 },
    { type = "item", name = "electronic-circuit", amount = 4 },
    { type = "item", name = "advanced-circuit", amount = 2 },
    { type = "item", name = "fw-signal-conduit", amount = 1 },
    { type = "item", name = "fw-circuit-contact", amount = 1 },
  })

  set_recipe_ingredients("roboport", {
    { type = "item", name = "steel-plate", amount = 45 },
    { type = "item", name = "iron-gear-wheel", amount = 45 },
    { type = "item", name = "advanced-circuit", amount = 45 },
    { type = "item", name = "battery", amount = 20 },
    { type = "item", name = "fw-ribbon-cable", amount = 2 },
    { type = "item", name = "fw-signal-conduit", amount = 1 },
    { type = "item", name = "fw-power-regulator", amount = 1 },
  })

  set_recipe_ingredients("big-mining-drill", {
    { type = "item", name = "electric-mining-drill", amount = 1 },
    { type = "item", name = "tungsten-carbide", amount = 20 },
    { type = "item", name = "electric-engine-unit", amount = 10 },
    { type = "item", name = "advanced-circuit", amount = 10 },
    { type = "item", name = "fw-harvester-head", amount = 2 },
    { type = "item", name = "fw-pressure-housing", amount = 2 },
    { type = "item", name = "fw-flow-regulator", amount = 1 },
  })

  set_recipe_ingredients("stack-inserter", {
    { type = "item", name = "bulk-inserter", amount = 1 },
    { type = "item", name = "processing-unit", amount = 1 },
    { type = "item", name = "carbon-fiber", amount = 2 },
    { type = "item", name = "fw-aluminum-beam", amount = 1 },
    { type = "item", name = "fw-signal-conduit", amount = 1 },
    { type = "item", name = "fw-bearing", amount = 1 },
  })

  set_recipe_ingredients("railgun", {
    { type = "item", name = "tungsten-plate", amount = 10 },
    { type = "item", name = "superconductor", amount = 10 },
    { type = "item", name = "quantum-processor", amount = 20 },
    { type = "fluid", name = "fluoroketone-cold", amount = 10 },
    { type = "item", name = "titanium-plate", amount = 12 },
    { type = "item", name = "fw-vulcanus-slag-cermet", amount = 1 },
    { type = "item", name = "fw-power-regulator", amount = 1 },
  })

  set_recipe_ingredients("rocket-turret", {
    { type = "item", name = "rocket-launcher", amount = 4 },
    { type = "item", name = "processing-unit", amount = 4 },
    { type = "item", name = "carbon-fiber", amount = 20 },
    { type = "item", name = "steel-plate", amount = 20 },
    { type = "item", name = "fw-lens-array", amount = 1 },
    { type = "item", name = "fw-pressure-housing", amount = 1 },
    { type = "item", name = "fw-signal-conduit", amount = 1 },
  })

  set_recipe_ingredients("railgun-turret", {
    { type = "item", name = "quantum-processor", amount = 100 },
    { type = "item", name = "tungsten-plate", amount = 30 },
    { type = "item", name = "superconductor", amount = 50 },
    { type = "fluid", name = "fluoroketone-cold", amount = 100 },
    { type = "item", name = "fw-vulcanus-slag-cermet", amount = 2 },
    { type = "item", name = "fw-lens-array", amount = 1 },
    { type = "item", name = "fw-logic-matrix", amount = 1 },
  })

  set_recipe_ingredients("teslagun", {
    { type = "item", name = "holmium-plate", amount = 10 },
    { type = "item", name = "superconductor", amount = 10 },
    { type = "item", name = "plastic-bar", amount = 30 },
    { type = "fluid", name = "electrolyte", amount = 100 },
    { type = "item", name = "fw-fulgora-static-mesh", amount = 1 },
    { type = "item", name = "fw-field-winding", amount = 1 },
    { type = "item", name = "fw-em-core", amount = 1 },
  })

  set_recipe_ingredients("tesla-turret", {
    { type = "item", name = "teslagun", amount = 1 },
    { type = "item", name = "supercapacitor", amount = 10 },
    { type = "item", name = "processing-unit", amount = 10 },
    { type = "item", name = "superconductor", amount = 50 },
    { type = "item", name = "fw-fulgora-static-mesh", amount = 2 },
    { type = "item", name = "fw-field-winding", amount = 1 },
    { type = "item", name = "fw-em-core", amount = 1 },
  })

  set_recipe_ingredients("artillery-turret", {
    { type = "item", name = "tungsten-plate", amount = 60 },
    { type = "item", name = "refined-concrete", amount = 60 },
    { type = "item", name = "processing-unit", amount = 10 },
    { type = "item", name = "electric-engine-unit", amount = 8 },
    { type = "item", name = "fw-cermet", amount = 2 },
    { type = "item", name = "fw-pressure-housing", amount = 1 },
    { type = "item", name = "fw-signal-conduit", amount = 1 },
    { type = "item", name = "fw-hydraulic-manifold", amount = 1 },
  })

  set_recipe_ingredients("artillery-wagon", {
    { type = "item", name = "cargo-wagon", amount = 1 },
    { type = "item", name = "engine-unit", amount = 60 },
    { type = "item", name = "tungsten-plate", amount = 60 },
    { type = "item", name = "processing-unit", amount = 10 },
    { type = "item", name = "fw-bearing", amount = 1 },
    { type = "item", name = "fw-pressure-housing", amount = 1 },
    { type = "item", name = "fw-hydraulic-manifold", amount = 1 },
  })

  set_recipe_ingredients("power-armor-mk2", {
    { type = "item", name = "power-armor", amount = 1 },
    { type = "item", name = "processing-unit", amount = 60 },
    { type = "item", name = "electric-engine-unit", amount = 40 },
    { type = "item", name = "low-density-structure", amount = 30 },
    { type = "item", name = "battery", amount = 40 },
    { type = "item", name = "fw-rocket-engine", amount = 2 },
    { type = "item", name = "fw-cermet", amount = 2 },
    { type = "item", name = "fw-logic-matrix", amount = 1 },
  })

  set_recipe_ingredients("mech-armor", {
    { type = "item", name = "power-armor-mk2", amount = 1 },
    { type = "item", name = "holmium-plate", amount = 200 },
    { type = "item", name = "processing-unit", amount = 100 },
    { type = "item", name = "superconductor", amount = 50 },
    { type = "item", name = "supercapacitor", amount = 50 },
    { type = "item", name = "fw-rift-stabilizer", amount = 1 },
    { type = "item", name = "fw-flux-resonance-cell", amount = 1 },
    { type = "item", name = "fw-em-core", amount = 1 },
  })

  set_recipe_ingredients("spidertron", {
    { type = "item", name = "exoskeleton-equipment", amount = 4 },
    { type = "item", name = "fission-reactor-equipment", amount = 2 },
    { type = "item", name = "rocket-turret", amount = 1 },
    { type = "item", name = "radar", amount = 2 },
    { type = "item", name = "titanium-plate", amount = 20 },
    { type = "item", name = "fw-bearing", amount = 1 },
    { type = "item", name = "fw-logic-matrix", amount = 1 },
    { type = "item", name = "fw-em-core", amount = 1 },
  })

  set_recipe_ingredients("fw-reinforced-seal", {
    { type = "item", name = "fw-chlorinated-binder-stock", amount = 1 },
    { type = "item", name = "fw-elastomer-matrix", amount = 2 },
    { type = "item", name = "lead-plate", amount = 1 },
    { type = "item", name = "fw-ceramic-insulator", amount = 1 },
    { type = "item", name = "fw-carbon", amount = 1 },
    { type = "item", name = "fw-salt", amount = 1 },
  })

  set_recipe_ingredients("fw-hydraulic-manifold", {
    { type = "item", name = "fw-flow-regulator", amount = 1 },
    { type = "item", name = "bronze-plate", amount = 1 },
    { type = "item", name = "fw-pressure-housing", amount = 1 },
    { type = "item", name = "fw-copper-tube", amount = 4 },
    { type = "item", name = "fw-reinforced-seal", amount = 1 },
    { type = "item", name = "fw-elastomer-matrix", amount = 1 },
    { type = "item", name = "electric-engine-unit", amount = 1 },
    { type = "item", name = "fw-capacitor", amount = 1 },
    { type = "item", name = "fw-signal-conduit", amount = 1 },
    { type = "item", name = "fw-power-regulator", amount = 1 },
  })

end
