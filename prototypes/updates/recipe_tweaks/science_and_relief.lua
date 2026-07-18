return function(shared)
  local enable_machine_part_rehoming = shared.enable_machine_part_rehoming
  local patch_recipe_ingredient_spec = shared.patch_recipe_ingredient_spec
  local patch_recipe_set = shared.patch_recipe_set
  local remove_recipe_ingredient = shared.remove_recipe_ingredient
  local remove_many_recipe_ingredients = shared.remove_many_recipe_ingredients
  local replace_recipe_ingredient = shared.replace_recipe_ingredient
  local set_recipe_category = shared.set_recipe_category
  local set_recipe_subgroup = shared.set_recipe_subgroup

  -- Science was getting a little "throw every shiny part in the blender."
  -- This pulls it back into more deliberate lanes.
  local all_science_packs = {
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
  }

  local late_space_science_packs = {
    "metallurgic-science-pack",
    "electromagnetic-science-pack",
    "agricultural-science-pack",
    "cryogenic-science-pack",
    "promethium-science-pack",
  }

  for _, recipe_name in ipairs(all_science_packs) do
    remove_recipe_ingredient(recipe_name, "fw-glass-lens")
  end

  for _, recipe_name in ipairs(late_space_science_packs) do
    remove_recipe_ingredient(recipe_name, "fw-capacitor")
  end

  remove_recipe_ingredient("automation-science-pack", "copper-plate")
  remove_recipe_ingredient("automation-science-pack", "lead-plate")
  remove_recipe_ingredient("logistic-science-pack", "lead-plate")
  remove_recipe_ingredient("military-science-pack", "fw-gunpowder")
  remove_recipe_ingredient("chemical-science-pack", "fw-bearing")
  remove_recipe_ingredient("chemical-science-pack", "fw-solder-wire")
  remove_recipe_ingredient("production-science-pack", "fw-cermet")
  remove_recipe_ingredient("production-science-pack", "fw-coil-block")
  remove_recipe_ingredient("production-science-pack", "fw-pressure-housing")
  remove_recipe_ingredient("utility-science-pack", "fw-sensor-package")
  remove_recipe_ingredient("utility-science-pack", "fw-memory-die")
  remove_recipe_ingredient("utility-science-pack", "fw-capacitor")
  remove_recipe_ingredient("utility-science-pack", "fw-power-regulator")
  remove_recipe_ingredient("space-science-pack", "fw-light-frame")
  remove_recipe_ingredient("space-science-pack", "fw-transformer-core")
  remove_recipe_ingredient("space-science-pack", "fw-logic-matrix")
  remove_recipe_ingredient("metallurgic-science-pack", "fw-cermet")
  remove_recipe_ingredient("metallurgic-science-pack", "fw-annealed-cermet")
  remove_recipe_ingredient("metallurgic-science-pack", "fw-vulcanus-slag-cermet")
  remove_recipe_ingredient("metallurgic-science-pack", "fw-pressure-housing")
  remove_recipe_ingredient("metallurgic-science-pack", "fw-steel-beam")
  remove_recipe_ingredient("electromagnetic-science-pack", "fw-sensor-package")
  remove_recipe_ingredient("electromagnetic-science-pack", "fw-em-core")
  remove_recipe_ingredient("electromagnetic-science-pack", "fw-fulgora-static-mesh")
  remove_recipe_ingredient("electromagnetic-science-pack", "fw-coil-block")
  remove_recipe_ingredient("electromagnetic-science-pack", "fw-signal-conduit")
  remove_recipe_ingredient("electromagnetic-science-pack", "fw-transformer-core")
  remove_recipe_ingredient("agricultural-science-pack", "fw-inline-filter")
  remove_recipe_ingredient("agricultural-science-pack", "fw-gleba-spore-resin")
  remove_recipe_ingredient("cryogenic-science-pack", "fw-glass-lens")
  remove_recipe_ingredient("cryogenic-science-pack", "fw-thermal-buffer")
  remove_recipe_ingredient("cryogenic-science-pack", "fw-cryo-coil")
  remove_recipe_ingredient("cryogenic-science-pack", "fw-aquilo-cryogel")
  remove_recipe_ingredient("cryogenic-science-pack", "fw-power-regulator")
  remove_recipe_ingredient("cryogenic-science-pack", "fw-flow-regulator")
  remove_recipe_ingredient("promethium-science-pack", "fw-transformer-core")
  remove_recipe_ingredient("promethium-science-pack", "promethium-asteroid-chunk")
  remove_recipe_ingredient("promethium-science-pack", "fw-promethium-matrix")
  remove_recipe_ingredient("promethium-science-pack", "fw-rift-stabilizer")
  remove_recipe_ingredient("promethium-science-pack", "fw-logic-matrix")
  remove_recipe_ingredient("promethium-science-pack", "fw-aquilo-cryogel")
  remove_recipe_ingredient("promethium-science-pack", "fw-gleba-spore-resin")
  remove_recipe_ingredient("promethium-science-pack", "fw-fulgora-static-mesh")
  remove_recipe_ingredient("promethium-science-pack", "fw-vulcanus-slag-cermet")
  remove_recipe_ingredient("promethium-science-pack", "fw-flux-resonance-cell")
  remove_recipe_ingredient("promethium-science-pack", "fw-flux-phase-manifold")

  replace_recipe_ingredient("automation-science-pack", "copper-plate", { type = "item", name = "tin-plate", amount = 1 })
  replace_recipe_ingredient("military-science-pack", "stone-wall", { type = "item", name = "stone-wall", amount = 1 })
  replace_recipe_ingredient("space-science-pack", "carbon", { type = "item", name = "fw-carbon", amount = 1 })
  replace_recipe_ingredient("promethium-science-pack", "quantum-processor", { type = "item", name = "fw-logic-matrix", amount = 1 })

  patch_recipe_set({
    { "logistic-science-pack", "lead-plate", 1 },
    { "military-science-pack", "fw-gunpowder", 1 },
    { "chemical-science-pack", "fw-bearing", 1 },
    { "chemical-science-pack", "fw-solder-wire", 2 },
    { "production-science-pack", "fw-cermet", 1 },
    { "production-science-pack", "fw-pressure-housing", 1 },
    { "utility-science-pack", "fw-sensor-package", 1 },
    { "utility-science-pack", "fw-power-regulator", 1 },
    { "space-science-pack", "fw-light-frame", 1 },
    { "space-science-pack", "fw-transformer-core", 1 },
    { "metallurgic-science-pack", "fw-cermet", 1 },
    { "metallurgic-science-pack", "fw-steel-beam", 1 },
    { "electromagnetic-science-pack", "fw-lens-array", 1 },
    { "electromagnetic-science-pack", "fw-signal-conduit", 1 },
    { "electromagnetic-science-pack", "fw-transformer-core", 1 },
    { "agricultural-science-pack", "fw-inline-filter", 1 },
    { "agricultural-science-pack", "fw-resin", 1 },
    { "cryogenic-science-pack", "fw-flow-regulator", 1 },
    { "cryogenic-science-pack", "fw-power-regulator", 1 },
    { "promethium-science-pack", "promethium-asteroid-chunk", 4 },
    { "promethium-science-pack", "fw-promethium-matrix", 1 },
    { "promethium-science-pack", "fw-logic-matrix", 1 },
    { "promethium-science-pack", "fw-aquilo-cryogel", 1 },
    { "promethium-science-pack", "fw-gleba-spore-resin", 1 },
    { "promethium-science-pack", "fw-fulgora-static-mesh", 1 },
    { "promethium-science-pack", "fw-vulcanus-slag-cermet", 1 },
  })

  -- Complexity relief pass.
  -- Keep the later FluxWorks identity, but stop taxing the most common early and midgame crafts.
  remove_recipe_ingredient("electronic-circuit", "fw-circuit-contact")
  remove_many_recipe_ingredients({ "engine-unit", "electric-engine-unit" }, "fw-bearing")
  remove_recipe_ingredient("battery", "fw-ceramic-insulator")
  remove_many_recipe_ingredients({
    "fast-inserter",
    "filter-inserter",
    "assembling-machine-2",
    "electric-mining-drill",
    "medium-electric-pole",
  }, "fw-steel-beam")
  remove_recipe_ingredient("assembling-machine-2", "fw-circuit-substrate")
  remove_many_recipe_ingredients({
    "automation-science-pack",
    "logistic-science-pack",
    "military-science-pack",
    "chemical-science-pack",
  }, "fw-glass-lens")
  remove_many_recipe_ingredients({
    "module",
    "speed-module",
    "effectivity-module",
    "productivity-module",
    "quality-module",
    "speed-module-2",
    "effectivity-module-2",
    "productivity-module-2",
    "quality-module-2",
  }, "fw-memory-die")
  remove_many_recipe_ingredients({
    "electric-engine-unit",
    "flying-robot-frame",
    "construction-robot",
    "logistic-robot",
  }, "fw-sensor-package")
  remove_many_recipe_ingredients({
    "pipe-to-ground",
    "pump",
    "offshore-pump",
    "steam-engine",
  }, "fw-inline-filter")
  remove_many_recipe_ingredients({
    "fast-transport-belt",
    "fast-underground-belt",
    "fast-splitter",
    "rail",
    "rail-signal",
    "rail-chain-signal",
    "small-electric-pole",
    "medium-electric-pole",
    "arithmetic-combinator",
    "decider-combinator",
    "constant-combinator",
  }, "fw-copper-tube")

  -- Sneak the staged parts into machines where they actually make sense.
  patch_recipe_set({
    { "lab", "fw-lens-array", 1 },
    { "radar", "fw-lens-array", 1 },
    { "big-mining-drill", "fw-harvester-head", 2 },
    { "asteroid-collector", "fw-harvester-head", 1 },
    { "substation", "fw-power-regulator", 1 },
    { "electric-furnace", "fw-annealed-cermet", 1 },
    { "foundry", "fw-foundry-lining", 1 },
    { "foundry", "fw-annealed-cermet", 1 },
    { "biochamber", "fw-inline-filter", 1 },
    { "cryogenic-plant", "fw-cryo-coil", 1 },
    { "electromagnetic-plant", "fw-em-core", 1 },
    { "fw-flux-condenser", "fw-power-regulator", 2 },
    { "fw-flux-condenser", "fw-resonance-substrate", 2 },
    { "fw-flux-resonance-cell", "fw-field-winding", 1 },
    { "fw-flux-phase-manifold", "fw-em-core", 1 },
    { "fw-flux-metallic-synthesis", "fw-thermal-buffer", 1 },
  })

  -- A bunch of late parts were still pretending hand crafting was fine.
  -- No thanks. These belong to the real machine lanes now.
  if enable_machine_part_rehoming then
    for _, recipe_name in ipairs({
      "fw-field-winding",
      "fw-cryo-coil",
      "fw-thermal-buffer",
      "fw-em-core",
      "fw-logic-matrix",
      "fw-rift-stabilizer",
    }) do
      set_recipe_category(recipe_name, "fw-flux-synthesis")
    end

    patch_recipe_set({
      { "fw-field-winding", "fw-power-regulator", 1 },
      { "fw-field-winding", "fw-signal-conduit", 1 },
      { "fw-cryo-coil", "fw-power-regulator", 1 },
      { "fw-thermal-buffer", "fw-pressure-housing", 1 },
      { "fw-em-core", "fw-resonance-substrate", 1 },
      { "fw-logic-matrix", "fw-resonance-substrate", 1 },
      { "fw-logic-matrix", "fw-sensor-package", 1 },
      { "fw-rift-stabilizer", "fw-power-regulator", 1 },
      { "fw-harvester-head", "fw-coil-block", 1 },
      { "fw-harvester-head", "fw-signal-conduit", 1 },
      { "fw-resonance-substrate", "fw-lens-array", 1 },
      { "fw-condensed-flux-matrix", "fw-coil-block", 1 },
      { "fw-flux-phase-manifold", "fw-field-winding", 1 },
      { "fw-flux-phase-manifold", "fw-logic-matrix", 1 },
      { "fw-promethium-matrix", "fw-lens-array", 1 },
      { "fw-promethium-matrix", "fw-signal-conduit", 1 },
      { "fw-promethium-matrix", "fw-logic-matrix", 1 },
    })

    for _, recipe_name in ipairs({
      "fw-condensed-flux-matrix",
      "fw-flux-phase-manifold",
    }) do
      set_recipe_category(recipe_name, "fw-flux-condensing")
      set_recipe_subgroup(recipe_name, "fw-flux-condensing-core")
    end

    for _, recipe_name in ipairs({
      "fw-promethium-matrix",
      "fw-rift-stabilizer",
    }) do
      set_recipe_category(recipe_name, "fw-flux-condensing")
      set_recipe_subgroup(recipe_name, "fw-flux-condensing-promethium")
    end

    for _, patch in ipairs({
      { "fw-condensed-flux-matrix", "fw-purple-flux", 48 },
      { "fw-condensed-flux-matrix", "fw-yellow-flux", 36 },
      { "fw-condensed-flux-matrix", "fw-red-flux", 72 },
      { "fw-condensed-flux-matrix", "fw-green-flux", 24 },
      { "fw-flux-phase-manifold", "fw-purple-flux", 120 },
      { "fw-flux-phase-manifold", "fw-yellow-flux", 80 },
      { "fw-flux-phase-manifold", "fw-red-flux", 160 },
      { "fw-flux-phase-manifold", "fw-green-flux", 32 },
      { "fw-promethium-matrix", "fw-purple-flux", 48 },
      { "fw-promethium-matrix", "fw-yellow-flux", 40 },
      { "fw-promethium-matrix", "fw-red-flux", 60 },
      { "fw-promethium-matrix", "fw-green-flux", 24 },
      { "fw-rift-stabilizer", "fw-purple-flux", 90 },
      { "fw-rift-stabilizer", "fw-yellow-flux", 60 },
      { "fw-rift-stabilizer", "fw-red-flux", 90 },
      { "fw-rift-stabilizer", "fw-green-flux", 50 },
    }) do
      patch_recipe_ingredient_spec(patch[1], { type = "fluid", name = patch[2], amount = patch[3] })
    end
  end
end
