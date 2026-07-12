return function(shared)
  local enable_orbital_and_planetary_integration = shared.enable_orbital_and_planetary_integration
  local patch_many_recipes = shared.patch_many_recipes
  local patch_recipe_set = shared.patch_recipe_set
  local remove_recipe_ingredient = shared.remove_recipe_ingredient
  local set_recipe_category = shared.set_recipe_category
  local set_recipe_ingredients = shared.set_recipe_ingredients

  -- The base crusher is the bootstrap for the whole comminution lane.
  -- Keep it in a steel-era envelope and leave the heavier Flux parts to its upgrades.
  set_recipe_ingredients("crusher", {
    { type = "item", name = "steel-plate", amount = 8 },
    { type = "item", name = "iron-gear-wheel", amount = 6 },
    { type = "item", name = "electronic-circuit", amount = 4 },
    { type = "item", name = "pipe", amount = 4 },
    { type = "item", name = "stone-brick", amount = 10 },
  })

  -- Keep the control family broad, sure, but stop shoving every single control part into every single recipe.
  remove_recipe_ingredient("train-stop", "fw-sensor-package")
  patch_recipe_set({
    { "train-stop", "fw-circuit-substrate", 1 },
    { "train-stop", "fw-signal-conduit", 1 },
    { "radar", "fw-signal-conduit", 1 },
    { "radar", "fw-sensor-diode", 1 },
    { "beacon", "fw-field-winding", 1 },
    { "lightning-collector", "fw-power-regulator", 1 },
    { "lightning-collector", "fw-fulgora-static-mesh", 1 },
    { "heating-tower", "fw-vulcanus-slag-cermet", 1 },
    { "electromagnetic-science-pack", "fw-power-regulator", 1 },
  })

  -- Final high-tier cleanup.
  -- Orbital, sensing, thermal, and field hardware should feel like actual families, not lonely patch notes.
  if enable_orbital_and_planetary_integration then
    -- Keep the prep chemistry flexible, but let the capstones live on the proper planet machine lanes.
    for _, recipe_name in ipairs({
      "fw-electrolyte-conditioning",
      "fw-lithium-adsorption",
    }) do
      set_recipe_category(recipe_name, "chemistry-or-cryogenics")
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
      { "chemical-plant", "fw-reinforced-seal", 1 },
      { "oil-refinery", "fw-reinforced-seal", 2 },
      { "electrolyser", "fw-reinforced-seal", 1 },
      { "heat-exchanger", "fw-reinforced-seal", 1 },
      { "steam-turbine", "fw-hydraulic-actuator", 1 },
      { "biolab", "fw-logic-matrix", 1 },
      { "rocket-silo", "fw-pressure-housing", 2 },
      { "rocket-silo", "fw-hydraulic-manifold", 1 },
      { "satellite", "fw-logic-matrix", 1 },
      { "space-platform-foundation", "fw-foundry-lining", 1 },
      { "space-platform-starter-pack", "fw-power-regulator", 1 },
      { "space-platform-hub", "fw-em-core", 1 },
      { "cargo-bay", "fw-pressure-housing", 1 },
      { "cargo-bay", "fw-hydraulic-actuator", 1 },
      { "asteroid-collector", "fw-flow-regulator", 1 },
      { "thruster", "fw-pressure-housing", 1 },
      { "thruster", "fw-hydraulic-manifold", 1 },
      { "pumpjack", "fw-servo-valve", 1 },
      { "offshore-pump", "fw-servo-valve", 1 },
      { "fluid-wagon", "fw-hydraulic-actuator", 1 },
      { "storage-tank", "fw-hydraulic-manifold", 1 },
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
      { "superconductor", "fw-polymer-binder", 1 },
      { "supercapacitor", "fw-polymer-binder", 1 },
      { "quantum-processor", "fw-chlorinated-binder-stock", 1 },
      { "fusion-power-cell", "fw-reactor-dopant", 1 },
      { "fusion-power-cell", "fw-reactor-coolant-cartridge", 1 },
    })

    -- Steel pipe should be the pressure-rated utility lane, not a cosmetic duplicate of the renamed lead pipe.
    patch_recipe_set({
      { "heat-exchanger", "fw-kr-steel-pipe", 4 },
      { "steam-turbine", "fw-kr-steel-pipe", 6 },
      { "fluid-wagon", "fw-kr-steel-pipe", 4 },
      { "nuclear-reactor", "fw-kr-steel-pipe", 8 },
      { "fission-reactor", "fw-kr-steel-pipe", 8 },
      { "fusion-reactor", "fw-kr-steel-pipe", 10 },
      { "fusion-generator", "fw-kr-steel-pipe", 8 },
      { "cryogenic-plant", "fw-kr-steel-pipe", 4 },
      { "thruster", "fw-kr-steel-pipe", 6 },
    })
  end
end
