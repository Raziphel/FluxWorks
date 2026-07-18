require("__base__/prototypes/factoriopedia-util")

local content = {
  simulations = {},
}

local simulations = content.simulations

local function make_recipe_machine_simulation(args)
  local tile_name = args.tile_name or "refined-concrete"
  local setup_lines = {
    "game.simulation.camera_alt_info = true",
    "game.simulation.camera_zoom = " .. (args.zoom or 1),
    "game.simulation.camera_position = {" .. (args.camera_x or 0) .. ", " .. (args.camera_y or 0) .. "}",
    "",
    "for x = -8, 8 do",
    "  for y = -6, 6 do",
    '    game.surfaces[1].set_tiles{{position = {x, y}, name = "' .. tile_name .. '"}}',
    "  end",
    "end",
    "",
    'game.surfaces[1].create_entity{name = "substation", position = {0, -4}, force = "player"}',
  }

  for _, line in ipairs(args.extra_setup or {}) do
    setup_lines[#setup_lines + 1] = line
  end

  setup_lines[#setup_lines + 1] = ""
  setup_lines[#setup_lines + 1] = 'local machine = game.surfaces[1].create_entity{name = "' .. args.machine_name .. '", position = {0, 0}, force = "player"}'
  setup_lines[#setup_lines + 1] = 'game.forces.player.recipes["' .. args.recipe_name .. '"].enabled = true'
  setup_lines[#setup_lines + 1] = 'machine.set_recipe("' .. args.recipe_name .. '")'

  for _, item in ipairs(args.items or {}) do
    setup_lines[#setup_lines + 1] = 'machine.insert{name = "' .. item.name .. '", count = ' .. item.count .. '}'
  end

  for _, fluid in ipairs(args.fluids or {}) do
    setup_lines[#setup_lines + 1] = 'machine.insert_fluid{name = "' .. fluid.name .. '", amount = ' .. fluid.amount .. '}'
  end

  for _, line in ipairs(args.post_setup or {}) do
    setup_lines[#setup_lines + 1] = line
  end

  return {
    init = "[[\n" .. table.concat(setup_lines, "\n") .. "\n  ]]",
    update = args.update,
  }
end

local function make_story_focus_simulation(args)
  local lines = {
    'require("__core__/lualib/story")',
    "game.simulation.camera_alt_info = true",
    "game.simulation.camera_zoom = " .. (args.zoom or 1),
    "game.simulation.camera_position = {" .. (args.camera_x or 0) .. ", " .. (args.camera_y or 0) .. "}",
    'player = game.simulation.create_test_player{name = "' .. (args.player_name or "Flux Instructor") .. '"}',
    "player.teleport({" .. (args.player_x or 0) .. ", " .. (args.player_y or 4) .. "})",
    "game.simulation.camera_player = player",
    "game.simulation.camera_player_cursor_position = player.position",
    "",
  }

  for _, line in ipairs(args.setup_lines or {}) do
    lines[#lines + 1] = line
  end

  lines[#lines + 1] = ""
  lines[#lines + 1] = "local story_table ="
  lines[#lines + 1] = "{"
  lines[#lines + 1] = "  {"
  lines[#lines + 1] = "    {"
  lines[#lines + 1] = '      name = "start",'
  lines[#lines + 1] = "      condition = story_elapsed_check(0.5)"
  lines[#lines + 1] = "    },"

  for _, focus in ipairs(args.focuses or {}) do
    local speed = focus.speed or 0.2
    local hold = focus.hold or 1.25
    lines[#lines + 1] = "    {"
    lines[#lines + 1] = "      condition = function()"
    lines[#lines + 1] = "        return game.simulation.move_cursor({position = {" .. focus.x .. ", " .. focus.y .. "}, speed = " .. speed .. "})"
    lines[#lines + 1] = "      end,"
    lines[#lines + 1] = "      action = function()"
    lines[#lines + 1] = "        player.update_selected_entity(game.simulation.camera_player_cursor_position)"
    for _, action_line in ipairs(focus.action_lines or {}) do
      lines[#lines + 1] = "        " .. action_line
    end
    lines[#lines + 1] = "      end"
    lines[#lines + 1] = "    },"
    lines[#lines + 1] = "    { condition = story_elapsed_check(" .. hold .. ") },"
  end

  lines[#lines + 1] = "    {"
  lines[#lines + 1] = "      condition = function()"
  lines[#lines + 1] = "        return game.simulation.move_cursor({position = player.position, speed = 0.2})"
  lines[#lines + 1] = "      end,"
  lines[#lines + 1] = "      action = function()"
  lines[#lines + 1] = "        player.update_selected_entity(game.simulation.camera_player_cursor_position)"
  lines[#lines + 1] = "      end"
  lines[#lines + 1] = "    },"
  lines[#lines + 1] = "    {"
  lines[#lines + 1] = "      condition = story_elapsed_check(1.5),"
  lines[#lines + 1] = "      action = function()"
  lines[#lines + 1] = '        story_jump_to(storage.story, "start")'
  lines[#lines + 1] = "      end"
  lines[#lines + 1] = "    }"
  lines[#lines + 1] = "  }"
  lines[#lines + 1] = "}"
  lines[#lines + 1] = "tip_story_init(story_table)"

  return {
    init = "[[\n" .. table.concat(lines, "\n") .. "\n  ]]",
  }
end

simulations.fw_crystalised_flux = {
  hide_factoriopedia_gradient = true,
  init = make_resource("fw-crystalised-flux"),
}

simulations.fw_metallic_deposit = {
  hide_factoriopedia_gradient = true,
  init = make_resource("fw-metallic-deposit"),
}

simulations.fw_mineral_deposit = {
  hide_factoriopedia_gradient = true,
  init = make_resource("fw-mineral-deposit"),
}

simulations.fw_carbonic_deposit = {
  hide_factoriopedia_gradient = true,
  init = make_resource("fw-carbonic-deposit"),
}

simulations.fw_promethium_impact = {
  hide_factoriopedia_gradient = true,
  init = make_resource("fw-promethium-impact"),
}

simulations.fw_silica_vein = {
  hide_factoriopedia_gradient = true,
  init = make_resource("fw-silica-vein"),
}

simulations.fw_flux_quarry =
{
  init =
  [[
    game.simulation.camera_zoom = 0.72
    game.simulation.camera_position = {0, 0.8}

    for x = -8, 8 do
      for y = -8, 8 do
        game.surfaces[1].set_tiles{{position = {x, y}, name = "dirt-7"}}
      end
    end

    local patch_positions =
    {
      {-3.5, -2.5}, {-2.5, -2.5}, {-1.5, -2.5}, {-0.5, -2.5}, {0.5, -2.5}, {1.5, -2.5}, {2.5, -2.5},
      {-4.5, -1.5}, {-3.5, -1.5}, {-2.5, -1.5}, {-1.5, -1.5}, {-0.5, -1.5}, {0.5, -1.5}, {1.5, -1.5}, {2.5, -1.5}, {3.5, -1.5},
      {-4.5, -0.5}, {-3.5, -0.5}, {-2.5, -0.5}, {-1.5, -0.5}, {-0.5, -0.5}, {0.5, -0.5}, {1.5, -0.5}, {2.5, -0.5}, {3.5, -0.5},
      {-3.5, 0.5}, {-2.5, 0.5}, {-1.5, 0.5}, {-0.5, 0.5}, {0.5, 0.5}, {1.5, 0.5}, {2.5, 0.5},
      {-2.5, 1.5}, {-1.5, 1.5}, {-0.5, 1.5}, {0.5, 1.5}, {1.5, 1.5}
    }

    for _, position in pairs(patch_positions) do
      game.surfaces[1].create_entity{name = "fw-crystalised-flux", position = position, amount = 1200}
    end

    game.surfaces[1].create_entity{name = "substation", position = {5, 0}, force = "player"}
    game.surfaces[1].create_entity{name = "solar-panel", position = {6.5, -2}, force = "player"}
    game.surfaces[1].create_entity{name = "solar-panel", position = {6.5, 0}, force = "player"}
    game.surfaces[1].create_entity{name = "accumulator", position = {6.5, 2}, force = "player"}
    game.surfaces[1].create_entity{name = "fw-flux-quarry", position = {0, 0}, force = "player"}
  ]]
}

simulations.fw_flux_harvester = make_recipe_machine_simulation({
  machine_name = "fw-flux-harvester",
  recipe_name = "fw-iron-ore-to-lead-ore",
  tile_name = "refined-concrete",
  zoom = 1.15,
  camera_y = 0.25,
  items = {
    { name = "iron-ore", count = 36 },
  },
  fluids = {
    { name = "fw-purple-flux", amount = 120 },
  },
  extra_setup = {
    'game.surfaces[1].create_entity{name = "storage-tank", position = {-3, 0}, force = "player"}',
    'game.surfaces[1].create_entity{name = "storage-tank", position = {3, 0}, force = "player"}',
    'game.surfaces[1].create_entity{name = "steel-chest", position = {-3, 2}, force = "player"}',
    'game.surfaces[1].create_entity{name = "steel-chest", position = {3, 2}, force = "player"}',
  },
})

simulations.fw_arc_foundry = make_recipe_machine_simulation({
  machine_name = "fw-arc-foundry",
  recipe_name = "fw-annealed-cermet",
  tile_name = "hazard-concrete-left",
  zoom = 0.95,
  camera_y = 0.15,
  items = {
    { name = "fw-cermet", count = 20 },
    { name = "fw-foundry-lining", count = 10 },
    { name = "titanium-plate", count = 10 },
  },
  fluids = {
    { name = "fw-red-flux", amount = 180 },
  },
  extra_setup = {
    'game.surfaces[1].create_entity{name = "pipe", position = {-3, 1}, force = "player"}',
    'game.surfaces[1].create_entity{name = "pipe", position = {3, 1}, force = "player"}',
    'game.surfaces[1].create_entity{name = "steel-chest", position = {-4, -1}, force = "player"}',
    'game.surfaces[1].create_entity{name = "steel-furnace", position = {4, -1}, force = "player"}',
  },
})

simulations.fw_synthesis_plant = make_recipe_machine_simulation({
  machine_name = "fw-synthesis-plant",
  recipe_name = "fw-condensed-flux-matrix",
  tile_name = "refined-concrete",
  zoom = 0.9,
  camera_y = 0.2,
  items = {
    { name = "fw-stabilized-flux-crystal", count = 20 },
    { name = "fw-flux-lattice", count = 6 },
    { name = "fw-flux-catalyst", count = 4 },
  },
  fluids = {
    { name = "fw-purple-flux", amount = 180 },
    { name = "fw-yellow-flux", amount = 180 },
    { name = "fw-red-flux", amount = 360 },
    { name = "fw-green-flux", amount = 100 },
  },
  extra_setup = {
    'game.surfaces[1].create_entity{name = "pipe", position = {-3, 2}, force = "player"}',
    'game.surfaces[1].create_entity{name = "pipe", position = {3, 2}, force = "player"}',
    'game.surfaces[1].create_entity{name = "steel-chest", position = {-4, -2}, force = "player"}',
    'game.surfaces[1].create_entity{name = "steel-chest", position = {4, -2}, force = "player"}',
  },
})

simulations.fw_flux_condenser = make_recipe_machine_simulation({
  machine_name = "fw-flux-condenser",
  recipe_name = "fw-promethium-matrix",
  tile_name = "black-refined-concrete",
  zoom = 0.82,
  camera_y = 0.3,
  items = {
    { name = "fw-promethium-shard", count = 24 },
    { name = "fw-stabilized-flux-crystal", count = 4 },
    { name = "fw-lens-array", count = 4 },
    { name = "fw-signal-conduit", count = 4 },
    { name = "fw-flux-resonance-cell", count = 4 },
    { name = "fw-aquilo-cryogel", count = 4 },
    { name = "fw-gleba-spore-resin", count = 4 },
    { name = "fw-flux-catalyst", count = 4 },
  },
  fluids = {
    { name = "fw-purple-flux", amount = 192 },
    { name = "fw-yellow-flux", amount = 156 },
    { name = "fw-red-flux", amount = 252 },
    { name = "fw-green-flux", amount = 120 },
  },
  extra_setup = {
    'game.surfaces[1].create_entity{name = "storage-tank", position = {-4, 0}, force = "player"}',
    'game.surfaces[1].create_entity{name = "storage-tank", position = {4, 0}, force = "player"}',
    'game.surfaces[1].create_entity{name = "steel-chest", position = {-4, 3}, force = "player"}',
    'game.surfaces[1].create_entity{name = "steel-chest", position = {4, 3}, force = "player"}',
  },
})

simulations.fw_petrochemical_facility = make_recipe_machine_simulation({
  machine_name = "fw-petrochemical-facility",
  recipe_name = "fw-reinforced-seal",
  tile_name = "refined-concrete",
  zoom = 0.78,
  camera_y = 0.2,
  items = {
    { name = "fw-resin", count = 20 },
  },
  fluids = {
    { name = "fw-latex", amount = 200 },
    { name = "sulfuric-acid", amount = 200 },
    { name = "fw-chlorine", amount = 160 },
  },
  extra_setup = {
    'game.surfaces[1].create_entity{name = "pipe", position = {-2, 3}, force = "player"}',
    'game.surfaces[1].create_entity{name = "pipe", position = {0, 3}, force = "player"}',
    'game.surfaces[1].create_entity{name = "pipe", position = {2, 3}, force = "player"}',
    'game.surfaces[1].create_entity{name = "storage-tank", position = {0, -4}, force = "player"}',
    'game.surfaces[1].create_entity{name = "steel-chest", position = {3, 2}, force = "player"}',
  },
})

simulations.fw_hydraulic_plant = make_recipe_machine_simulation({
  machine_name = "fw-hydraulic-plant",
  recipe_name = "fw-hydraulic-manifold",
  tile_name = "hazard-concrete-right",
  zoom = 0.9,
  camera_y = 0.1,
  items = {
    { name = "fw-flow-regulator", count = 10 },
    { name = "fw-pressure-housing", count = 10 },
    { name = "fw-copper-tube", count = 20 },
    { name = "fw-reinforced-seal", count = 10 },
    { name = "fw-capacitor", count = 10 },
  },
  extra_setup = {
    'game.surfaces[1].create_entity{name = "pipe", position = {-1, 2}, force = "player"}',
    'game.surfaces[1].create_entity{name = "pipe", position = {1, 2}, force = "player"}',
    'game.surfaces[1].create_entity{name = "steel-chest", position = {-3, 1}, force = "player"}',
    'game.surfaces[1].create_entity{name = "steel-chest", position = {3, 1}, force = "player"}',
  },
})

simulations.fw_atomic_enricher = make_recipe_machine_simulation({
  machine_name = "fw-atomic-enricher",
  recipe_name = "fw-reactor-grade-fuel-cell",
  tile_name = "black-refined-concrete",
  zoom = 0.72,
  camera_y = 0.15,
  items = {
    { name = "fw-fuel-pellet-bundle", count = 10 },
    { name = "fw-isotope-matrix", count = 10 },
    { name = "fw-moderator-lattice", count = 10 },
    { name = "fw-shielded-fuel-casing", count = 10 },
  },
  fluids = {
    { name = "sulfuric-acid", amount = 200 },
  },
  extra_setup = {
    'game.surfaces[1].create_entity{name = "pipe", position = {-3, 0}, force = "player"}',
    'game.surfaces[1].create_entity{name = "storage-tank", position = {-4, 0}, force = "player"}',
    'game.surfaces[1].create_entity{name = "steel-chest", position = {4, 0}, force = "player"}',
  },
})

simulations.fw_green_flux_biology = make_recipe_machine_simulation({
  machine_name = "biochamber",
  recipe_name = "fw-green-flux-from-spoilage",
  tile_name = "artificial-yumako-soil",
  zoom = 0.88,
  camera_y = 0.15,
  items = {
    { name = "spoilage", count = 24 },
  },
  fluids = {
    { name = "water", amount = 120 },
  },
  extra_setup = {
    'game.surfaces[1].create_entity{name = "pipe", position = {-2, 2}, force = "player"}',
    'game.surfaces[1].create_entity{name = "storage-tank", position = {-3, 2}, force = "player"}',
    'game.surfaces[1].create_entity{name = "steel-chest", position = {3, 1}, force = "player"}',
  },
})

simulations.fw_planetary_chemistry = make_recipe_machine_simulation({
  machine_name = "chemical-plant",
  recipe_name = "fw-aquilo-cryogel",
  tile_name = "refined-concrete",
  zoom = 0.9,
  camera_y = 0.15,
  items = {
    { name = "fw-salt", count = 10 },
    { name = "lithium", count = 10 },
    { name = "ice", count = 36 },
    { name = "fw-thermal-buffer", count = 10 },
  },
  fluids = {
    { name = "fluoroketone-cold", amount = 160 },
    { name = "fw-yellow-flux", amount = 120 },
    { name = "fw-green-flux", amount = 100 },
  },
  extra_setup = {
    'game.surfaces[1].create_entity{name = "pipe", position = {-2, 1}, force = "player"}',
    'game.surfaces[1].create_entity{name = "pipe", position = {2, 1}, force = "player"}',
    'game.surfaces[1].create_entity{name = "storage-tank", position = {-3, 1}, force = "player"}',
    'game.surfaces[1].create_entity{name = "steel-chest", position = {3, 1}, force = "player"}',
  },
})

simulations.fw_superconductive_systems = make_recipe_machine_simulation({
  machine_name = "chemical-plant",
  recipe_name = "fw-superconductor-bath",
  tile_name = "refined-concrete",
  zoom = 0.84,
  camera_y = 0.15,
  items = {
    { name = "holmium-plate", count = 10 },
    { name = "aluminum-plate", count = 10 },
    { name = "tin-plate", count = 10 },
    { name = "plastic-bar", count = 10 },
    { name = "fw-rubber-sheet", count = 10 },
    { name = "fw-cryo-coil", count = 10 },
    { name = "fw-aquilo-cryogel", count = 10 },
    { name = "fw-fulgora-static-mesh", count = 10 },
  },
  fluids = {
    { name = "light-oil", amount = 100 },
    { name = "fw-purple-flux", amount = 120 },
    { name = "fw-yellow-flux", amount = 160 },
    { name = "fw-red-flux", amount = 120 },
    { name = "fw-green-flux", amount = 100 },
  },
  extra_setup = {
    'game.surfaces[1].create_entity{name = "pipe", position = {-3, 1}, force = "player"}',
    'game.surfaces[1].create_entity{name = "pipe", position = {3, 1}, force = "player"}',
    'game.surfaces[1].create_entity{name = "storage-tank", position = {-4, 1}, force = "player"}',
    'game.surfaces[1].create_entity{name = "steel-chest", position = {4, 1}, force = "player"}',
  },
})

simulations.fw_flux_convergence = make_recipe_machine_simulation({
  machine_name = "fw-flux-condenser",
  recipe_name = "fw-rift-stabilizer",
  tile_name = "black-refined-concrete",
  zoom = 0.82,
  camera_y = 0.2,
  items = {
    { name = "fw-flux-phase-manifold", count = 4 },
    { name = "fw-promethium-matrix", count = 4 },
    { name = "fw-resonance-substrate", count = 4 },
    { name = "fw-logic-matrix", count = 4 },
    { name = "fw-signal-conduit", count = 8 },
    { name = "fw-aquilo-cryogel", count = 4 },
    { name = "fw-gleba-spore-resin", count = 4 },
    { name = "fw-fulgora-static-mesh", count = 4 },
    { name = "fw-vulcanus-slag-cermet", count = 4 },
  },
  fluids = {
    { name = "fw-purple-flux", amount = 1400 },
    { name = "fw-yellow-flux", amount = 1120 },
    { name = "fw-red-flux", amount = 2080 },
    { name = "fw-green-flux", amount = 840 },
  },
  extra_setup = {
    'game.surfaces[1].create_entity{name = "pipe", position = {-3, 2}, force = "player"}',
    'game.surfaces[1].create_entity{name = "pipe", position = {3, 2}, force = "player"}',
    'game.surfaces[1].create_entity{name = "storage-tank", position = {-4, 2}, force = "player"}',
    'game.surfaces[1].create_entity{name = "steel-chest", position = {4, -1}, force = "player"}',
  },
})

simulations.fw_tip_flux_rift_extraction = make_story_focus_simulation({
  zoom = 0.72,
  camera_y = 0.8,
  player_y = 6.5,
  setup_lines = {
    "for x = -8, 8 do",
    "  for y = -8, 8 do",
    '    game.surfaces[1].set_tiles{{position = {x, y}, name = "dirt-7"}}',
    "  end",
    "end",
    "local patch_positions = {",
    "  {-3.5, -2.5}, {-2.5, -2.5}, {-1.5, -2.5}, {-0.5, -2.5}, {0.5, -2.5}, {1.5, -2.5}, {2.5, -2.5},",
    "  {-4.5, -1.5}, {-3.5, -1.5}, {-2.5, -1.5}, {-1.5, -1.5}, {-0.5, -1.5}, {0.5, -1.5}, {1.5, -1.5}, {2.5, -1.5}, {3.5, -1.5},",
    "  {-4.5, -0.5}, {-3.5, -0.5}, {-2.5, -0.5}, {-1.5, -0.5}, {-0.5, -0.5}, {0.5, -0.5}, {1.5, -0.5}, {2.5, -0.5}, {3.5, -0.5},",
    "  {-3.5, 0.5}, {-2.5, 0.5}, {-1.5, 0.5}, {-0.5, 0.5}, {0.5, 0.5}, {1.5, 0.5}, {2.5, 0.5},",
    "  {-2.5, 1.5}, {-1.5, 1.5}, {-0.5, 1.5}, {0.5, 1.5}, {1.5, 1.5}",
    "}",
    "for _, position in pairs(patch_positions) do",
    '  game.surfaces[1].create_entity{name = "fw-crystalised-flux", position = position, amount = 1200}',
    "end",
    'game.surfaces[1].create_entity{name = "substation", position = {5, 0}, force = "player"}',
    'game.surfaces[1].create_entity{name = "solar-panel", position = {6.5, -2}, force = "player"}',
    'game.surfaces[1].create_entity{name = "solar-panel", position = {6.5, 0}, force = "player"}',
    'game.surfaces[1].create_entity{name = "accumulator", position = {6.5, 2}, force = "player"}',
    'game.surfaces[1].create_entity{name = "fw-flux-quarry", position = {0, 0}, force = "player"}',
  },
  focuses = {
    { x = 0, y = 0, hold = 1.75 },
    { x = 2.5, y = -1.5, hold = 1.75 },
    { x = 5, y = 0, hold = 1.25 },
  },
})

simulations.fw_tip_processing_ladder = make_story_focus_simulation({
  zoom = 0.7,
  camera_y = 0.2,
  player_y = 5.5,
  setup_lines = {
    "for x = -14, 14 do",
    "  for y = -7, 7 do",
    '    game.surfaces[1].set_tiles{{position = {x, y}, name = "refined-concrete"}}',
    "  end",
    "end",
    'game.surfaces[1].create_entity{name = "substation", position = {-5, -4}, force = "player"}',
    'game.surfaces[1].create_entity{name = "substation", position = {5, -4}, force = "player"}',
    'local harvester = game.surfaces[1].create_entity{name = "fw-flux-harvester", position = {-5, 0}, force = "player"}',
    'local foundry = game.surfaces[1].create_entity{name = "fw-arc-foundry", position = {0, 0}, force = "player"}',
    'local synth = game.surfaces[1].create_entity{name = "fw-synthesis-plant", position = {6, 0}, force = "player"}',
    'game.forces.player.recipes["fw-iron-ore-to-lead-ore"].enabled = true',
    'game.forces.player.recipes["fw-annealed-cermet"].enabled = true',
    'game.forces.player.recipes["fw-condensed-flux-matrix"].enabled = true',
    'harvester.set_recipe("fw-iron-ore-to-lead-ore")',
    'foundry.set_recipe("fw-annealed-cermet")',
    'synth.set_recipe("fw-condensed-flux-matrix")',
    'harvester.insert{name = "iron-ore", count = 36}',
    'harvester.insert_fluid{name = "fw-purple-flux", amount = 120}',
    'foundry.insert{name = "fw-cermet", count = 20}',
    'foundry.insert{name = "fw-foundry-lining", count = 10}',
    'foundry.insert{name = "titanium-plate", count = 10}',
    'foundry.insert_fluid{name = "fw-red-flux", amount = 180}',
    'synth.insert{name = "fw-stabilized-flux-crystal", count = 20}',
    'synth.insert{name = "fw-flux-lattice", count = 6}',
    'synth.insert{name = "fw-flux-catalyst", count = 4}',
    'synth.insert_fluid{name = "fw-purple-flux", amount = 180}',
    'synth.insert_fluid{name = "fw-yellow-flux", amount = 180}',
    'synth.insert_fluid{name = "fw-red-flux", amount = 360}',
    'synth.insert_fluid{name = "fw-green-flux", amount = 100}',
  },
  focuses = {
    { x = -5, y = 0, hold = 1.75 },
    { x = 0, y = 0, hold = 1.75 },
    { x = 6, y = 0, hold = 1.75 },
  },
})

simulations.fw_tip_synthesis_cloning = make_story_focus_simulation({
  zoom = 0.78,
  camera_y = 0.3,
  player_y = 5.5,
  setup_lines = {
    "for x = -12, 12 do",
    "  for y = -7, 7 do",
    '    game.surfaces[1].set_tiles{{position = {x, y}, name = "black-refined-concrete"}}',
    "  end",
    "end",
    'game.surfaces[1].create_entity{name = "substation", position = {0, -4}, force = "player"}',
    'local synth = game.surfaces[1].create_entity{name = "fw-synthesis-plant", position = {-4, 0}, force = "player"}',
    'local condenser = game.surfaces[1].create_entity{name = "fw-flux-condenser", position = {4, 0}, force = "player"}',
    'game.forces.player.recipes["fw-condensed-flux-matrix"].enabled = true',
    'game.forces.player.recipes["fw-promethium-matrix"].enabled = true',
    'synth.set_recipe("fw-condensed-flux-matrix")',
    'condenser.set_recipe("fw-promethium-matrix")',
    'synth.insert{name = "fw-stabilized-flux-crystal", count = 20}',
    'synth.insert{name = "fw-flux-lattice", count = 6}',
    'synth.insert{name = "fw-flux-catalyst", count = 4}',
    'synth.insert_fluid{name = "fw-purple-flux", amount = 180}',
    'synth.insert_fluid{name = "fw-yellow-flux", amount = 180}',
    'synth.insert_fluid{name = "fw-red-flux", amount = 360}',
    'synth.insert_fluid{name = "fw-green-flux", amount = 100}',
    'condenser.insert{name = "fw-promethium-shard", count = 18}',
    'condenser.insert{name = "fw-stabilized-flux-crystal", count = 4}',
    'condenser.insert{name = "fw-flux-resonance-cell", count = 4}',
    'condenser.insert{name = "fw-aquilo-cryogel", count = 4}',
    'condenser.insert{name = "fw-gleba-spore-resin", count = 4}',
    'condenser.insert{name = "fw-flux-catalyst", count = 4}',
    'condenser.insert_fluid{name = "fw-purple-flux", amount = 192}',
    'condenser.insert_fluid{name = "fw-yellow-flux", amount = 156}',
    'condenser.insert_fluid{name = "fw-red-flux", amount = 252}',
    'condenser.insert_fluid{name = "fw-green-flux", amount = 120}',
  },
  focuses = {
    { x = -4, y = 0, hold = 1.75 },
    { x = 4, y = 0, hold = 1.75 },
    { x = 0, y = 0, hold = 1.0 },
  },
})

simulations.fw_phase_vault = make_story_focus_simulation({
  zoom = 0.82,
  camera_y = 0.3,
  player_y = 5.5,
  setup_lines = {
    "for x = -8, 8 do",
    "  for y = -8, 8 do",
    '    game.surfaces[1].set_tiles{{position = {x, y}, name = "refined-concrete"}}',
    "  end",
    "end",
    'game.surfaces[1].create_entity{name = "substation", position = {4, -3}, force = "player"}',
    'game.surfaces[1].create_entity{name = "stack-inserter", position = {-2, 0}, direction = defines.direction.east, force = "player"}',
    'game.surfaces[1].create_entity{name = "stack-inserter", position = {2, 0}, direction = defines.direction.west, force = "player"}',
    'game.surfaces[1].create_entity{name = "steel-chest", position = {-3, 0}, force = "player"}',
    'game.surfaces[1].create_entity{name = "steel-chest", position = {3, 0}, force = "player"}',
    'game.surfaces[1].create_entity{name = "fw-phase-vault", position = {0, 0}, force = "player"}',
  },
  focuses = {
    { x = 0, y = 0, hold = 1.9 },
    { x = -3, y = 0, hold = 1.2 },
    { x = 3, y = 0, hold = 1.2 },
  },
})

simulations.fw_spectral_reservoir = make_story_focus_simulation({
  zoom = 0.9,
  camera_y = 0.2,
  player_y = 5,
  setup_lines = {
    "for x = -8, 8 do",
    "  for y = -8, 8 do",
    '    game.surfaces[1].set_tiles{{position = {x, y}, name = "blue-refined-concrete"}}',
    "  end",
    "end",
    'game.surfaces[1].create_entity{name = "substation", position = {4, -3}, force = "player"}',
    'game.surfaces[1].create_entity{name = "pipe", position = {0, -2}, force = "player"}',
    'game.surfaces[1].create_entity{name = "pipe", position = {0, 2}, force = "player"}',
    'game.surfaces[1].create_entity{name = "pipe", position = {-2, 0}, force = "player"}',
    'game.surfaces[1].create_entity{name = "pipe", position = {2, 0}, force = "player"}',
    'local reservoir = game.surfaces[1].create_entity{name = "fw-spectral-reservoir", position = {0, 0}, force = "player"}',
    'reservoir.insert_fluid{name = "fw-green-flux", amount = 90000}',
  },
  focuses = {
    { x = 0, y = 0, hold = 1.9 },
    { x = 0, y = -2, hold = 1.1 },
    { x = 2, y = 0, hold = 1.1 },
  },
})

simulations.fw_rift_exchange_gate = make_story_focus_simulation({
  zoom = 0.48,
  camera_y = -0.1,
  player_y = 7.5,
  setup_lines = {
    "for x = -14, 14 do",
    "  for y = -14, 14 do",
    '    game.surfaces[1].set_tiles{{position = {x, y}, name = "black-refined-concrete"}}',
    "  end",
    "end",
    'game.surfaces[1].create_entity{name = "substation", position = {6, -5}, force = "player"}',
    'game.surfaces[1].create_entity{name = "stack-inserter", position = {-5.5, 0}, direction = defines.direction.east, force = "player"}',
    'game.surfaces[1].create_entity{name = "stack-inserter", position = {5.5, 0}, direction = defines.direction.west, force = "player"}',
    'game.surfaces[1].create_entity{name = "steel-chest", position = {-7, 0}, force = "player"}',
    'game.surfaces[1].create_entity{name = "steel-chest", position = {7, 0}, force = "player"}',
    'game.surfaces[1].create_entity{name = "fw-rift-exchange-gate", position = {0, 0}, force = "player"}',
  },
  focuses = {
    { x = 0, y = 0, hold = 2.1 },
    { x = -7, y = 0, hold = 1.2 },
    { x = 7, y = 0, hold = 1.2 },
  },
})

simulations.fw_rift_exchange_fluid_gate = make_story_focus_simulation({
  zoom = 0.46,
  camera_y = -0.1,
  player_y = 7.5,
  setup_lines = {
    "for x = -14, 14 do",
    "  for y = -14, 14 do",
    '    game.surfaces[1].set_tiles{{position = {x, y}, name = "blue-refined-concrete"}}',
    "  end",
    "end",
    'game.surfaces[1].create_entity{name = "substation", position = {6, -5}, force = "player"}',
    'game.surfaces[1].create_entity{name = "pipe", position = {-0.5, -6}, force = "player"}',
    'game.surfaces[1].create_entity{name = "pipe", position = {0.5, 6}, force = "player"}',
    'local gate = game.surfaces[1].create_entity{name = "fw-rift-exchange-fluid-gate", position = {0, 0}, force = "player"}',
    'gate.insert_fluid{name = "fw-purple-flux", amount = 160000}',
  },
  focuses = {
    { x = 0, y = 0, hold = 2.1 },
    { x = -0.5, y = -6, hold = 1.15 },
    { x = 0.5, y = 6, hold = 1.15 },
  },
})

simulations.fw_orbital_salvage =
{
  hide_factoriopedia_gradient = true,
  init =
  [[
    require("__core__/lualib/story")
    game.simulation.camera_position = {0, 0}

    for x = -8, 8 do
      for y = -3, 3 do
        game.surfaces[1].set_tiles{{position = {x, y}, name = "empty-space"}}
      end
    end

    for x = -1, 0 do
      for y = -1, 0 do
        game.surfaces[1].set_chunk_generated_status({x, y}, defines.chunk_generated_status.entities)
      end
    end

    local story_table =
    {
      {
        {
          name = "start",
          action = function() game.surfaces[1].create_entity{name = "used-rocket-asteroid", position = {0, 0}, velocity = {0, 0.012}} end
        },
        {
          condition = story_elapsed_check(15),
          action = function() story_jump_to(storage.story, "start") end
        }
      }
    }
    tip_story_init(story_table)
  ]]
}

if mods["space-age"] then
  data:extend({
    {
      type = "tips-and-tricks-item-category",
      name = "fluxworks",
      order = "m-[fluxworks]",
    },
    {
      type = "tips-and-tricks-item",
      name = "fluxworks-overview",
      category = "fluxworks",
      order = "a",
      is_title = true,
      trigger = {
        type = "research",
        technology = "fw-flux-extraction",
      },
      skip_trigger = {
        type = "build-entity",
        entity = "fw-flux-harvester",
        count = 1,
        match_type_only = true,
      },
      simulation = simulations.fw_flux_quarry,
    },
    {
      type = "tips-and-tricks-item",
      name = "flux-rift-extraction",
      tag = "[entity=fw-flux-quarry]",
      category = "fluxworks",
      order = "b",
      indent = 1,
      trigger = {
        type = "research",
        technology = "fw-flux-extraction",
      },
      skip_trigger = {
        type = "build-entity",
        entity = "fw-flux-quarry",
        count = 1,
        match_type_only = true,
      },
      simulation = simulations.fw_tip_flux_rift_extraction,
    },
    {
      type = "tips-and-tricks-item",
      name = "shattered-flux-source",
      tag = "[planet=shattered-planet]",
      category = "fluxworks",
      order = "c",
      indent = 1,
      trigger = {
        type = "research",
        technology = "fw-flux-extraction",
      },
      skip_trigger = {
        type = "research",
        technology = "fw-flux-synthesis",
      },
      simulation = simulations.fw_tip_flux_rift_extraction,
    },
    {
      type = "tips-and-tricks-item",
      name = "flux-lore-and-spectra",
      tag = "[fluid=fw-purple-flux]",
      category = "fluxworks",
      order = "c1",
      indent = 1,
      trigger = {
        type = "research",
        technology = "fw-flux-extraction",
      },
      skip_trigger = {
        type = "research",
        technology = "fw-harvester-systems",
      },
      simulation = simulations.fw_tip_flux_rift_extraction,
    },
    {
      type = "tips-and-tricks-item",
      name = "mixed-deposit-planning",
      tag = "[entity=fw-mineral-deposit]",
      category = "fluxworks",
      order = "d",
      indent = 1,
      trigger = {
        type = "research",
        technology = "fw-material-foundations",
      },
      skip_trigger = {
        type = "build-entity",
        entity = "electric-mining-drill",
        count = 12,
        match_type_only = true,
      },
      simulation = simulations.fw_mineral_deposit,
    },
    {
      type = "tips-and-tricks-item",
      name = "early-processing-bootstrap",
      tag = "[recipe=crusher]",
      category = "fluxworks",
      order = "e",
      indent = 1,
      trigger = {
        type = "research",
        technology = "fw-comminution",
      },
      skip_trigger = {
        type = "research",
        technology = "fw-tube-forming",
      },
      simulation = simulations.fw_tip_processing_ladder,
    },
    {
      type = "tips-and-tricks-item",
      name = "flux-processing-ladder",
      tag = "[entity=fw-flux-harvester]",
      category = "fluxworks",
      order = "f",
      indent = 1,
      trigger = {
        type = "research",
        technology = "fw-harvester-systems",
      },
      skip_trigger = {
        type = "build-entity",
        entity = "fw-arc-foundry",
        count = 1,
        match_type_only = true,
      },
      simulation = simulations.fw_tip_processing_ladder,
    },
    {
      type = "tips-and-tricks-item",
      name = "flux-synthesis-and-cloning",
      tag = "[entity=fw-flux-condenser]",
      category = "fluxworks",
      order = "h",
      indent = 1,
      trigger = {
        type = "research",
        technology = "fw-flux-synthesis",
      },
      skip_trigger = {
        type = "build-entity",
        entity = "fw-flux-condenser",
        count = 1,
        match_type_only = true,
      },
      simulation = simulations.fw_tip_synthesis_cloning,
    },
    {
      type = "tips-and-tricks-item",
      name = "promethium-ramp",
      tag = "[item=fw-promethium-matrix]",
      category = "fluxworks",
      order = "i",
      indent = 1,
      trigger = {
        type = "research",
        technology = "fw-flux-overdrive",
      },
      skip_trigger = {
        type = "build-entity",
        entity = "fw-flux-condenser",
        count = 1,
        match_type_only = true,
      },
      simulation = simulations.fw_tip_synthesis_cloning,
    },
    {
      type = "tips-and-tricks-item",
      name = "flux-orbital-salvage",
      tag = "[item=remnant-beacon]",
      category = "fluxworks",
      order = "i",
      indent = 1,
      trigger = {
        type = "research",
        technology = "rocket-chunk-processing",
      },
      skip_trigger = {
        type = "build-entity",
        entity = "remnant-beacon",
        count = 1,
        match_type_only = true,
      },
      simulation = simulations.fw_orbital_salvage,
    },
    {
      type = "tips-and-tricks-item",
      name = "petrochem-and-hydraulics",
      tag = "[entity=fw-petrochemical-facility]",
      category = "fluxworks",
      order = "j",
      indent = 1,
      trigger = {
        type = "research",
        technology = "fw-petrochemical-engineering",
      },
      skip_trigger = {
        type = "research",
        technology = "fw-fluid-control-architecture",
      },
      simulation = simulations.fw_petrochemical_facility,
    },
    {
      type = "tips-and-tricks-item",
      name = "atomic-enrichment-loop",
      tag = "[entity=fw-atomic-enricher]",
      category = "fluxworks",
      order = "k",
      indent = 1,
      trigger = {
        type = "research",
        technology = "fw-isotope-conditioning",
      },
      skip_trigger = {
        type = "research",
        technology = "fw-reactor-instrumentation",
      },
      simulation = simulations.fw_atomic_enricher,
    },
    {
      type = "tips-and-tricks-item",
      name = "deep-storage-and-rift-logistics",
      tag = "[item=fw-phase-vault]",
      category = "fluxworks",
      order = "l",
      indent = 1,
      trigger = {
        type = "research",
        technology = "fw-deep-phase-storage",
      },
      skip_trigger = {
        type = "build-entity",
        entity = "fw-rift-exchange-gate",
        count = 1,
        match_type_only = true,
      },
      simulation = simulations.fw_orbital_salvage,
    },
    {
      type = "tips-and-tricks-item",
      name = "green-flux-recovery",
      tag = "[fluid=fw-green-flux]",
      category = "fluxworks",
      order = "m",
      indent = 1,
      trigger = {
        type = "research",
        technology = "fw-flux-green-reclamation",
      },
      skip_trigger = {
        type = "research",
        technology = "fw-flux-green-propagation",
      },
      simulation = simulations.fw_green_flux_biology,
    },
    {
      type = "tips-and-tricks-item",
      name = "planetary-chemistry-rewards",
      tag = "[item=fw-aquilo-cryogel]",
      category = "fluxworks",
      order = "n",
      indent = 1,
      trigger = {
        type = "research",
        technology = "fw-aquilo-cryochemistry",
      },
      skip_trigger = {
        type = "research",
        technology = "fw-promethium-stabilization",
      },
      simulation = simulations.fw_planetary_chemistry,
    },
    {
      type = "tips-and-tricks-item",
      name = "thermal-and-superconductive-infrastructure",
      tag = "[item=superconductor]",
      category = "fluxworks",
      order = "o",
      indent = 1,
      trigger = {
        type = "research",
        technology = "fw-superconductive-systems",
      },
      skip_trigger = {
        type = "research",
        technology = "fw-fusion-lattices",
      },
      simulation = simulations.fw_superconductive_systems,
    },
    {
      type = "tips-and-tricks-item",
      name = "shattered-island-traversal",
      tag = "[planet=shattered-planet]",
      category = "fluxworks",
      order = "p",
      indent = 1,
      trigger = {
        type = "research",
        technology = "fw-flux-convergence",
      },
      skip_trigger = {
        type = "research",
        technology = "fw-rift-harmonics",
      },
      simulation = simulations.fw_flux_convergence,
    },
    {
      type = "tips-and-tricks-item",
      name = "shattered-bridgeheads",
      tag = "[planet=shattered-planet]",
      category = "fluxworks",
      order = "q",
      indent = 1,
      trigger = {
        type = "research",
        technology = "fw-flux-convergence",
      },
      skip_trigger = {
        type = "research",
        technology = "fw-rift-harmonics",
      },
      simulation = simulations.fw_flux_convergence,
    },
    {
      type = "tips-and-tricks-item",
      name = "shattered-convergence-network",
      tag = "[item=fw-rift-stabilizer]",
      category = "fluxworks",
      order = "r",
      indent = 1,
      trigger = {
        type = "research",
        technology = "fw-rift-harmonics",
      },
      simulation = simulations.fw_flux_convergence,
    },
    {
      type = "tips-and-tricks-item",
      name = "shattered-origin-projects",
      tag = "[entity=fw-origin-singularity]",
      category = "fluxworks",
      order = "r1",
      indent = 1,
      trigger = {
        type = "research",
        technology = "fw-rift-harmonics",
      },
      simulation = simulations.fw_flux_convergence,
    },
    {
      type = "tips-and-tricks-item",
      name = "shattered-vent-biomes",
      tag = "[planet=shattered-planet]",
      category = "fluxworks",
      order = "s",
      indent = 1,
      trigger = {
        type = "research",
        technology = "fw-flux-convergence",
      },
      skip_trigger = {
        type = "research",
        technology = "fw-rift-harmonics",
      },
      simulation = simulations.fw_flux_convergence,
    },
    {
      type = "tips-and-tricks-item",
      name = "shattered-origin-revelation",
      tag = "[planet=shattered-planet]",
      category = "fluxworks",
      order = "t",
      indent = 1,
      trigger = {
        type = "research",
        technology = "fw-flux-convergence",
      },
      skip_trigger = {
        type = "research",
        technology = "fw-rift-harmonics",
      },
      simulation = simulations.fw_flux_convergence,
    },
    {
      type = "tips-and-tricks-item",
      name = "flux-convergence-and-rift-control",
      tag = "[item=fw-rift-stabilizer]",
      category = "fluxworks",
      order = "u",
      indent = 1,
      trigger = {
        type = "research",
        technology = "fw-flux-convergence",
      },
      skip_trigger = {
        type = "research",
        technology = "fw-rift-harmonics",
      },
      simulation = simulations.fw_flux_convergence,
    },
  })
end

return content
