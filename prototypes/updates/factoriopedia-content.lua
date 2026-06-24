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
  recipe_name = "fw-silica-beneficiation",
  tile_name = "refined-concrete",
  zoom = 1.15,
  camera_y = 0.25,
  items = {
    { name = "silicon-ore", count = 30 },
    { name = "fw-sand", count = 12 },
    { name = "fw-flux-catalyst", count = 5 },
  },
  fluids = {
    { name = "water", amount = 150 },
    { name = "fw-yellow-flux", amount = 90 },
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
  recipe_name = "fw-promethium-primer",
  tile_name = "black-refined-concrete",
  zoom = 0.82,
  camera_y = 0.3,
  items = {
    { name = "fw-promethium-shard", count = 18 },
    { name = "fw-stabilized-flux-crystal", count = 4 },
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
    'game.forces.player.recipes["fw-silica-beneficiation"].enabled = true',
    'game.forces.player.recipes["fw-annealed-cermet"].enabled = true',
    'game.forces.player.recipes["fw-condensed-flux-matrix"].enabled = true',
    'harvester.set_recipe("fw-silica-beneficiation")',
    'foundry.set_recipe("fw-annealed-cermet")',
    'synth.set_recipe("fw-condensed-flux-matrix")',
    'harvester.insert{name = "silicon-ore", count = 30}',
    'harvester.insert{name = "fw-sand", count = 12}',
    'harvester.insert{name = "fw-flux-catalyst", count = 5}',
    'harvester.insert_fluid{name = "water", amount = 150}',
    'harvester.insert_fluid{name = "fw-yellow-flux", amount = 90}',
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
    'game.forces.player.recipes["fw-promethium-primer"].enabled = true',
    'synth.set_recipe("fw-condensed-flux-matrix")',
    'condenser.set_recipe("fw-promethium-primer")',
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
      name = "mixed-deposit-planning",
      tag = "[entity=fw-mineral-deposit]",
      category = "fluxworks",
      order = "c",
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
      name = "flux-processing-ladder",
      tag = "[entity=fw-flux-harvester]",
      category = "fluxworks",
      order = "d",
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
      order = "e",
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
      tag = "[item=fw-promethium-primer]",
      category = "fluxworks",
      order = "f",
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
      order = "g",
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
  })
end

return content
