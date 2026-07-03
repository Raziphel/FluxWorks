return function(shared)
  local enable_core_material_replacements = shared.enable_core_material_replacements
  local patch_many_recipes = shared.patch_many_recipes
  local patch_recipe_set = shared.patch_recipe_set
  local remove_recipe_ingredient = shared.remove_recipe_ingredient
  local replace_many_recipe_ingredients = shared.replace_many_recipe_ingredients
  local replace_recipe_ingredient = shared.replace_recipe_ingredient

  -- Bigger rebuild pass.
  -- Some recipes should stop pretending FluxWorks is just garnish and actually lean on the fabricated parts.
  if enable_core_material_replacements then

    -- Pipe-adjacent stuff should actually look pipe-adjacent, just with our tubing instead of raw plates-only nonsense.
    replace_many_recipe_ingredients({
      "engine-unit",
      "electric-engine-unit",
    }, "pipe", { type = "item", name = "fw-copper-tube", amount = 2 })

    replace_many_recipe_ingredients({
      "pump",
      "offshore-pump",
      "steam-engine",
    }, "pipe", { type = "item", name = "fw-copper-tube", amount = 1 })

    replace_many_recipe_ingredients({
      "storage-tank",
      "pipe-to-ground",
      "heat-exchanger",
      "steam-turbine",
      "fluid-wagon",
    }, "pipe", { type = "item", name = "fw-copper-tube", amount = 2 })

    replace_many_recipe_ingredients({
      "chemical-plant",
      "pumpjack",
      "flamethrower-turret",
    }, "pipe", { type = "item", name = "fw-copper-tube", amount = 2 })

    replace_many_recipe_ingredients({
      "oil-refinery",
    }, "pipe", { type = "item", name = "fw-copper-tube", amount = 4 })

    -- Mechanical bits graduate from "gear everywhere" to "yeah bearings exist."
    replace_many_recipe_ingredients({
      "fast-transport-belt",
      "express-transport-belt",
      "turbo-transport-belt",
      "fast-underground-belt",
      "express-underground-belt",
      "turbo-underground-belt",
      "fast-inserter",
      "filter-inserter",
      "stack-inserter",
      "stack-filter-inserter",
      "bulk-inserter",
      "engine-unit",
    }, "iron-gear-wheel", { type = "item", name = "fw-bearing", amount = 1 })

    replace_many_recipe_ingredients({
      "fast-splitter",
      "express-splitter",
      "turbo-splitter",
      "car",
      "locomotive",
      "cargo-wagon",
      "fluid-wagon",
      "artillery-wagon",
    }, "iron-gear-wheel", { type = "item", name = "fw-bearing", amount = 2 })

    replace_many_recipe_ingredients({
      "tank",
      "spidertron",
    }, "iron-gear-wheel", { type = "item", name = "fw-bearing", amount = 4 })

    -- Big frame-y stuff should use beams. Nice and simple.
    replace_many_recipe_ingredients({
      "electric-mining-drill",
      "assembling-machine-2",
      "medium-electric-pole",
      "rail-signal",
      "rail-chain-signal",
      "train-stop",
      "rail-ramp",
      "rail-support",
    }, "steel-plate", { type = "item", name = "fw-steel-beam", amount = 1 })

    replace_many_recipe_ingredients({
      "assembling-machine-3",
      "pumpjack",
      "chemical-plant",
      "electric-furnace",
      "car",
      "cargo-wagon",
      "fluid-wagon",
    }, "steel-plate", { type = "item", name = "fw-steel-beam", amount = 2 })

    replace_many_recipe_ingredients({
      "oil-refinery",
      "locomotive",
      "tank",
      "artillery-wagon",
    }, "steel-plate", { type = "item", name = "fw-steel-beam", amount = 4 })

    -- Power storage and robot bits get pushed toward real capacitor hardware.
    replace_many_recipe_ingredients({
      "flying-robot-frame",
      "construction-robot",
      "logistic-robot",
      "laser-turret",
      "personal-roboport-equipment",
    }, "battery", { type = "item", name = "fw-capacitor", amount = 2 })

    replace_many_recipe_ingredients({
      "personal-roboport-mk2-equipment",
      "battery-mk2-equipment",
      "fission-reactor-equipment",
      "fusion-reactor-equipment",
    }, "battery", { type = "item", name = "fw-capacitor", amount = 4 })

    -- Once the factory grows up, the control network should look like it did too.
    patch_many_recipes({
      "arithmetic-combinator",
      "decider-combinator",
      "constant-combinator",
      "selector-combinator",
      "programmable-speaker",
      "power-switch",
      "rail-signal",
      "rail-chain-signal",
      "train-stop",
      "roboport",
    }, "fw-signal-conduit", 1)

    patch_many_recipes({
      "arithmetic-combinator",
      "decider-combinator",
      "constant-combinator",
      "selector-combinator",
      "programmable-speaker",
      "rail-signal",
      "rail-chain-signal",
      "radar",
      "rocket-turret",
      "tesla-turret",
    }, "fw-circuit-contact", 1)

    patch_many_recipes({
      "small-electric-pole",
      "medium-electric-pole",
      "big-electric-pole",
      "substation",
      "power-switch",
      "accumulator",
      "laser-turret",
      "teslagun",
    }, "fw-ceramic-insulator", 1)

    patch_recipe_set({
      { "accumulator", "fw-power-regulator", 1 },
      { "substation", "fw-transformer-core", 1 },
      { "roboport", "fw-power-regulator", 1 },
      { "radar", "fw-power-regulator", 1 },
      { "power-switch", "fw-circuit-substrate", 1 },
      { "programmable-speaker", "fw-circuit-substrate", 1 },
      { "arithmetic-combinator", "fw-circuit-substrate", 1 },
      { "decider-combinator", "fw-circuit-substrate", 1 },
      { "constant-combinator", "fw-circuit-substrate", 1 },
      { "selector-combinator", "fw-circuit-substrate", 1 },
      { "rail-signal", "fw-sensor-diode", 1 },
      { "rail-chain-signal", "fw-sensor-diode", 1 },
      { "train-stop", "fw-sensor-package", 1 },
    })

    -- Coherence pass.
    -- Keep neighboring recipes speaking the same material language so nothing feels like a weird one-off prank.

    -- Also: fluid handling should still come from pipes.
    -- We are layering on top, not pretending the whole family got reinvented overnight.
    replace_recipe_ingredient("engine-unit", "fw-copper-tube", { type = "item", name = "pipe", amount = 2 })
    replace_recipe_ingredient("electric-engine-unit", "fw-copper-tube", { type = "item", name = "pipe", amount = 2 })
    replace_recipe_ingredient("pump", "fw-copper-tube", { type = "item", name = "pipe", amount = 1 })
    replace_recipe_ingredient("offshore-pump", "fw-copper-tube", { type = "item", name = "pipe", amount = 3 })
    replace_recipe_ingredient("steam-engine", "fw-copper-tube", { type = "item", name = "pipe", amount = 5 })
    replace_recipe_ingredient("pipe-to-ground", "fw-copper-tube", { type = "item", name = "pipe", amount = 10 })
    replace_recipe_ingredient("heat-exchanger", "fw-copper-tube", { type = "item", name = "pipe", amount = 10 })
    replace_recipe_ingredient("steam-turbine", "fw-copper-tube", { type = "item", name = "pipe", amount = 20 })
    replace_recipe_ingredient("fluid-wagon", "fw-copper-tube", { type = "item", name = "pipe", amount = 8 })
    replace_recipe_ingredient("chemical-plant", "fw-copper-tube", { type = "item", name = "pipe", amount = 5 })
    replace_recipe_ingredient("pumpjack", "fw-copper-tube", { type = "item", name = "pipe", amount = 10 })
    replace_recipe_ingredient("flamethrower-turret", "fw-copper-tube", { type = "item", name = "pipe", amount = 10 })
    replace_recipe_ingredient("oil-refinery", "fw-copper-tube", { type = "item", name = "pipe", amount = 10 })

    for _, recipe_name in ipairs({
      "pipe-to-ground",
      "storage-tank",
      "pump",
      "offshore-pump",
      "chemical-plant",
      "oil-refinery",
      "pumpjack",
      "engine-unit",
      "electric-engine-unit",
    }) do
      remove_recipe_ingredient(recipe_name, "lead-plate")
    end

    for _, recipe_name in ipairs({
      "pump",
      "offshore-pump",
    }) do
      remove_recipe_ingredient(recipe_name, "electronic-circuit")
    end

    remove_recipe_ingredient("engine-unit", "fw-pressure-housing")

    patch_recipe_set({
      { "engine-unit", "fw-copper-tube", 1 },
      { "electric-engine-unit", "fw-copper-tube", 1 },
      { "pipe-to-ground", "fw-copper-tube", 1 },
      { "storage-tank", "fw-copper-tube", 2 },
      { "pump", "fw-copper-tube", 1 },
      { "offshore-pump", "fw-copper-tube", 1 },
      { "steam-engine", "fw-copper-tube", 1 },
      { "steam-turbine", "fw-copper-tube", 2 },
      { "heat-exchanger", "fw-copper-tube", 2 },
      { "fluid-wagon", "fw-copper-tube", 2 },
      { "chemical-plant", "fw-copper-tube", 2 },
      { "oil-refinery", "fw-copper-tube", 4 },
      { "pumpjack", "fw-copper-tube", 2 },
      { "flamethrower-turret", "fw-copper-tube", 2 },
      { "centrifuge", "fw-copper-tube", 2 },
      { "electrolyser", "fw-copper-tube", 2 },
      { "cryogenic-plant", "fw-copper-tube", 4 },
      { "foundry", "fw-copper-tube", 2 },
      { "biochamber", "fw-copper-tube", 2 },
      { "recycler", "fw-copper-tube", 1 },
      { "thruster", "fw-copper-tube", 4 },
      { "infinity-pipe", "fw-copper-tube", 1 },
      { "casting-pipe-to-ground", "fw-copper-tube", 1 },
    })

    patch_recipe_set({
      { "storage-tank", "fw-flow-regulator", 1 },
      { "pump", "fw-flow-regulator", 1 },
      { "offshore-pump", "fw-flow-regulator", 1 },
      { "fluid-wagon", "fw-flow-regulator", 1 },
      { "steam-turbine", "fw-thermal-buffer", 1 },
      { "heat-exchanger", "fw-thermal-buffer", 1 },
      { "heating-tower", "fw-thermal-buffer", 1 },
      { "infinity-pipe", "fw-flow-regulator", 1 },
      { "electrolyser", "fw-flow-regulator", 1 },
      { "centrifuge", "fw-flow-regulator", 1 },
    })
  end
end
