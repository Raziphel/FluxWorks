local item_sounds = require("__base__.prototypes.item_sounds")
local sounds = require("__base__.prototypes.entity.sounds")
local util = require("util")
local advanced_foundry_path = "__finely-crafted-graphics__/graphics/advanced-foundry/"
local gravity_assembler_path = "__finely-crafted-graphics__/graphics/gravity-assembler/"
local quantum_stabilizer_path = "__finely-crafted-graphics__/graphics/quantum-stabilizer/"

local electromagnetic_pipe_pictures = require("__space-age__.prototypes.entity.electromagnetic-plant-pictures").pipe_pictures

local function working_light(intensity, size, shift, color)
  return {
    light = {
      intensity = intensity,
      size = size,
      shift = shift,
      color = color,
    },
  }
end

local function flux_harvester_icons()
  return {
    { icon = quantum_stabilizer_path .. "quantum-stabilizer-icon.png", icon_size = 64 },
    {
      icon = "__FluxWorksAssets__/graphics/icons/items/flux.png",
      icon_size = 64,
      scale = 0.28,
      shift = { 9, 9 },
    },
  }
end

local function make_harvester_fluid_boxes()
  return {
    {
      production_type = "input",
      pipe_picture = electromagnetic_pipe_pictures,
      pipe_covers = pipecoverspictures(),
      volume = 200,
      pipe_connections = { { flow_direction = "input-output", direction = defines.direction.south, position = { 0, 2 } } },
      secondary_draw_orders = { north = -1 },
    },
    {
      production_type = "output",
      pipe_picture = electromagnetic_pipe_pictures,
      pipe_covers = pipecoverspictures(),
      volume = 200,
      pipe_connections = { { flow_direction = "input-output", direction = defines.direction.east, position = { 2, 0 } } },
      secondary_draw_orders = { north = -1 },
    },
    {
      production_type = "input",
      pipe_picture = electromagnetic_pipe_pictures,
      pipe_covers = pipecoverspictures(),
      volume = 200,
      pipe_connections = { { flow_direction = "input-output", direction = defines.direction.north, position = { 0, -2 } } },
      secondary_draw_orders = { north = -1 },
    },
    {
      production_type = "output",
      pipe_picture = electromagnetic_pipe_pictures,
      pipe_covers = pipecoverspictures(),
      volume = 200,
      pipe_connections = { { flow_direction = "input-output", direction = defines.direction.west, position = { -2, 0 } } },
      secondary_draw_orders = { north = -1 },
    },
  }
end

local function make_medium_fluid_boxes()
  return {
    {
      production_type = "input",
      pipe_picture = electromagnetic_pipe_pictures,
      pipe_covers = pipecoverspictures(),
      volume = 200,
      pipe_connections = { { flow_direction = "input-output", direction = defines.direction.south, position = { -0.5, 1.5 } } },
      secondary_draw_orders = { north = -1 },
    },
    {
      production_type = "output",
      pipe_picture = electromagnetic_pipe_pictures,
      pipe_covers = pipecoverspictures(),
      volume = 200,
      pipe_connections = { { flow_direction = "input-output", direction = defines.direction.east, position = { 1.5, -0.5 } } },
      secondary_draw_orders = { north = -1 },
    },
    {
      production_type = "input",
      pipe_picture = electromagnetic_pipe_pictures,
      pipe_covers = pipecoverspictures(),
      volume = 200,
      pipe_connections = { { flow_direction = "input-output", direction = defines.direction.north, position = { 0.5, -1.5 } } },
      secondary_draw_orders = { north = -1 },
    },
    {
      production_type = "output",
      pipe_picture = electromagnetic_pipe_pictures,
      pipe_covers = pipecoverspictures(),
      volume = 200,
      pipe_connections = { { flow_direction = "input-output", direction = defines.direction.west, position = { -1.5, 0.5 } } },
      secondary_draw_orders = { north = -1 },
    },
  }
end

local function make_large_fluid_boxes()
  return {
    {
      production_type = "input",
      pipe_picture = electromagnetic_pipe_pictures,
      pipe_covers = pipecoverspictures(),
      volume = 300,
      pipe_connections = { { flow_direction = "input-output", direction = defines.direction.north, position = { -1, -3 } } },
      secondary_draw_orders = { north = -1 },
    },
    {
      production_type = "input",
      pipe_picture = electromagnetic_pipe_pictures,
      pipe_covers = pipecoverspictures(),
      volume = 300,
      pipe_connections = { { flow_direction = "input-output", direction = defines.direction.north, position = { 1, -3 } } },
      secondary_draw_orders = { north = -1 },
    },
    {
      production_type = "output",
      pipe_picture = electromagnetic_pipe_pictures,
      pipe_covers = pipecoverspictures(),
      volume = 300,
      pipe_connections = { { flow_direction = "input-output", direction = defines.direction.south, position = { -1, 3 } } },
      secondary_draw_orders = { north = -1 },
    },
    {
      production_type = "output",
      pipe_picture = electromagnetic_pipe_pictures,
      pipe_covers = pipecoverspictures(),
      volume = 300,
      pipe_connections = { { flow_direction = "input-output", direction = defines.direction.south, position = { 1, 3 } } },
      secondary_draw_orders = { north = -1 },
    },
  }
end

local harvester = table.deepcopy(data.raw["assembling-machine"]["chemical-plant"])
harvester.name = "fw-flux-harvester"
harvester.icon = nil
harvester.icon_size = nil
harvester.icons = flux_harvester_icons()
harvester.minable = { mining_time = 0.8, result = "fw-flux-harvester" }
harvester.max_health = 700
harvester.collision_box = { { -2.2, -2.2 }, { 2.2, 2.2 } }
harvester.selection_box = { { -2.5, -2.5 }, { 2.5, 2.5 } }
harvester.fast_replaceable_group = "fw-flux-processing"
harvester.crafting_categories = { "fw-flux-harvesting" }
harvester.crafting_speed = 2.2
harvester.energy_usage = "2.2MW"
harvester.ingredient_count = 12
harvester.module_slots = 4
harvester.allowed_effects = { "consumption", "speed", "productivity", "pollution" }
harvester.fluid_boxes = make_harvester_fluid_boxes()
harvester.fluid_boxes_off_when_no_fluid_recipe = true
harvester.open_sound = sounds.mech_small_open
harvester.close_sound = sounds.mech_small_close
harvester.graphics_set = {
  animation = {
    layers = {
      {
        filename = quantum_stabilizer_path .. "quantum-stabilizer-hr-shadow.png",
        priority = "high",
        width = 900,
        height = 420,
        repeat_count = 104,
        animation_speed = 0.35,
        scale = 0.4,
        draw_as_shadow = true,
      },
      {
        priority = "high",
        width = 410,
        height = 410,
        frame_count = 104,
        lines_per_file = 8,
        animation_speed = 0.35,
        scale = 0.4,
        stripes = {
          { filename = quantum_stabilizer_path .. "quantum-stabilizer-hr-animation-1.png", width_in_frames = 8, height_in_frames = 8 },
          { filename = quantum_stabilizer_path .. "quantum-stabilizer-hr-animation-2.png", width_in_frames = 8, height_in_frames = 5 },
        },
      },
    },
  },
  working_visualisations = {
    {
      fadeout = true,
      animation = {
        priority = "high",
        width = 410,
        height = 410,
        frame_count = 104,
        lines_per_file = 8,
        animation_speed = 0.35,
        scale = 0.4,
        draw_as_glow = true,
        blend_mode = "additive",
        tint = { r = 0.78, g = 0.26, b = 1.0, a = 0.9 },
        stripes = {
          { filename = quantum_stabilizer_path .. "quantum-stabilizer-hr-animation-emission-1.png", width_in_frames = 8, height_in_frames = 8 },
          { filename = quantum_stabilizer_path .. "quantum-stabilizer-hr-animation-emission-2.png", width_in_frames = 8, height_in_frames = 5 },
        },
      },
    },
    working_light(0.95, 9, { 0, -0.4 }, { r = 0.67, g = 0.18, b = 1.0 }),
  },
}
harvester.working_sound = {
  sound = {
    filename = "__space-age__/sound/entity/electromagnetic-plant/electromagnetic-plant-loop.ogg",
    volume = 0.48,
    audible_distance_modifier = 0.55,
  },
  fade_in_ticks = 6,
  fade_out_ticks = 24,
  max_sounds_per_prototype = 2,
}

local arc_foundry = table.deepcopy(data.raw["assembling-machine"]["chemical-plant"])
arc_foundry.name = "fw-arc-foundry"
arc_foundry.icon = advanced_foundry_path .. "advanced-foundry-icon.png"
arc_foundry.icon_size = 64
arc_foundry.minable = { mining_time = 1, result = "fw-arc-foundry" }
arc_foundry.max_health = 950
arc_foundry.collision_box = { { -3.2, -3.2 }, { 3.2, 3.2 } }
arc_foundry.selection_box = { { -3.5, -3.5 }, { 3.5, 3.5 } }
arc_foundry.fast_replaceable_group = "fw-flux-processing"
arc_foundry.crafting_categories = { "fw-arc-smelting" }
arc_foundry.crafting_speed = 3.2
arc_foundry.energy_usage = "6.2MW"
arc_foundry.ingredient_count = 16
arc_foundry.module_slots = 5
arc_foundry.allowed_effects = { "consumption", "speed", "productivity", "pollution", "quality" }
arc_foundry.fluid_boxes = make_large_fluid_boxes()
arc_foundry.fluid_boxes_off_when_no_fluid_recipe = true
arc_foundry.graphics_set = {
  always_draw_idle_animation = true,
  idle_animation = {
    layers = {
      {
        filename = advanced_foundry_path .. "advanced-foundry-hr-shadow.png",
        size = { 900, 800 },
        shift = { 0, 0 },
        scale = 0.5,
        line_length = 1,
        frame_count = 1,
        repeat_count = 50,
        draw_as_shadow = true,
        animation_speed = 0.25,
      },
      {
        filename = advanced_foundry_path .. "advanced-foundry-hr-animation-1.png",
        size = { 530, 530 },
        shift = { 0, 0 },
        scale = 0.5,
        line_length = 8,
        lines_per_file = 8,
        frame_count = 50,
        animation_speed = 0.25,
      },
    },
  },
  working_visualisations = {
    {
      fadeout = true,
      secondary_draw_order = 1,
      animation = {
        layers = {
          {
            filename = advanced_foundry_path .. "advanced-foundry-hr-emission-1.png",
            size = { 530, 530 },
            shift = { 0, 0 },
            scale = 0.5,
            line_length = 8,
            lines_per_file = 8,
            frame_count = 40,
            draw_as_glow = true,
            blend_mode = "additive",
            animation_speed = 0.25,
          },
        },
      },
    },
    working_light(0.9, 9.5, { 0.0, -0.2 }, { r = 1.0, g = 0.52, b = 0.18 }),
    working_light(0.5, 6.5, { 0.95, 0.35 }, { r = 1.0, g = 0.25, b = 0.1 }),
  },
}
arc_foundry.working_sound = {
  sound = {
    filename = "__space-age__/sound/entity/foundry/foundry.ogg",
    volume = 0.5,
    audible_distance_modifier = 0.6,
  },
  fade_in_ticks = 4,
  fade_out_ticks = 20,
  max_sounds_per_prototype = 2,
  sound_accents = {
    { sound = { filename = "__space-age__/sound/entity/foundry/foundry-slide-close.ogg", volume = 0.55, audible_distance_modifier = 0.3 }, frame = 18 },
    { sound = { filename = "__space-age__/sound/entity/foundry/foundry-clamp.ogg", volume = 0.4, audible_distance_modifier = 0.3 }, frame = 39 },
    { sound = { filename = "__space-age__/sound/entity/foundry/foundry-metal-clunk.ogg", volume = 0.55, audible_distance_modifier = 0.35 }, frame = 64 },
    { sound = { filename = "__space-age__/sound/entity/foundry/foundry-slide-open.ogg", volume = 0.55, audible_distance_modifier = 0.3 }, frame = 74 },
    { sound = { filename = "__space-age__/sound/entity/foundry/foundry-pipe-in.ogg", volume = 0.65, audible_distance_modifier = 0.35 }, frame = 106 },
    { sound = { filename = "__space-age__/sound/entity/foundry/foundry-smoke-puff.ogg", volume = 0.55, audible_distance_modifier = 0.3 }, frame = 106 },
  },
}
arc_foundry.open_sound = sounds.steam_open
arc_foundry.close_sound = sounds.steam_close

local synthesis_plant = table.deepcopy(data.raw["assembling-machine"]["chemical-plant"])
synthesis_plant.name = "fw-synthesis-plant"
synthesis_plant.icon = gravity_assembler_path .. "gravity-assembler-icon.png"
synthesis_plant.icon_size = 64
synthesis_plant.minable = { mining_time = 1, result = "fw-synthesis-plant" }
synthesis_plant.max_health = 900
synthesis_plant.collision_box = { { -1.6, -1.6 }, { 1.6, 1.6 } }
synthesis_plant.selection_box = { { -2, -2 }, { 2, 2 } }
synthesis_plant.fast_replaceable_group = "fw-flux-processing"
synthesis_plant.crafting_categories = { "fw-flux-synthesis", "fw-flux-condensing" }
synthesis_plant.crafting_speed = 2.9
synthesis_plant.energy_usage = "4.6MW"
synthesis_plant.ingredient_count = 20
synthesis_plant.module_slots = 5
synthesis_plant.allowed_effects = { "consumption", "speed", "productivity", "pollution", "quality" }
synthesis_plant.fluid_boxes = make_medium_fluid_boxes()
synthesis_plant.fluid_boxes_off_when_no_fluid_recipe = true
synthesis_plant.graphics_set = {
  animation = {
    layers = {
      {
        filename = gravity_assembler_path .. "gravity-assembler-hr-shadow.png",
        priority = "high",
        width = 520,
        height = 500,
        frame_count = 1,
        line_length = 1,
        repeat_count = 80,
        animation_speed = 0.5,
        draw_as_shadow = true,
        scale = 0.5,
      },
      {
        priority = "high",
        width = 320,
        height = 320,
        frame_count = 80,
        lines_per_file = 8,
        animation_speed = 0.5,
        shift = util.by_pixel(0, -8),
        scale = 0.5,
        stripes = {
          {
            filename = gravity_assembler_path .. "gravity-assembler-hr-animation-1.png",
            width_in_frames = 8,
            height_in_frames = 8,
          },
          {
            filename = gravity_assembler_path .. "gravity-assembler-hr-animation-2.png",
            width_in_frames = 8,
            height_in_frames = 5,
          },
        },
      },
    },
  },
  working_visualisations = {
    {
      fadeout = true,
      animation = {
        layers = {
          {
            priority = "high",
            width = 320,
            height = 320,
            frame_count = 80,
            lines_per_file = 8,
            animation_speed = 0.5,
            shift = util.by_pixel(0, -8),
            scale = 0.5,
            draw_as_glow = true,
            blend_mode = "additive",
            stripes = {
              {
                filename = gravity_assembler_path .. "gravity-assembler-hr-animation-emission-1.png",
                width_in_frames = 8,
                height_in_frames = 8,
              },
              {
                filename = gravity_assembler_path .. "gravity-assembler-hr-animation-emission-2.png",
                width_in_frames = 8,
                height_in_frames = 5,
              },
            },
          },
        },
      },
    },
    working_light(0.8, 8, { 0.0, -0.35 }, { r = 0.28, g = 0.85, b = 1.0 }),
    working_light(0.4, 5.5, { 0.85, 0.15 }, { r = 0.95, g = 0.3, b = 1.0 }),
  },
}
synthesis_plant.working_sound = {
  sound = {
    filename = "__space-age__/sound/entity/electromagnetic-plant/electromagnetic-plant-loop.ogg",
    volume = 0.45,
    audible_distance_modifier = 0.55,
  },
  fade_in_ticks = 4,
  fade_out_ticks = 24,
  max_sounds_per_prototype = 3,
  sound_accents = {
    { sound = { filename = "__space-age__/sound/entity/electromagnetic-plant/emp-bridge-open.ogg", volume = 0.45, audible_distance_modifier = 0.3 }, frame = 6 },
    { sound = { filename = "__space-age__/sound/entity/electromagnetic-plant/emp-coil-1.ogg", volume = 0.5, audible_distance_modifier = 0.3 }, frame = 26 },
    { sound = { filename = "__space-age__/sound/entity/electromagnetic-plant/emp-electric-3.ogg", volume = 0.42, audible_distance_modifier = 0.3 }, frame = 42 },
    { sound = { filename = "__space-age__/sound/entity/electromagnetic-plant/emp-arm-retract.ogg", volume = 0.4, audible_distance_modifier = 0.28 }, frame = 56 },
  },
}
synthesis_plant.open_sound = sounds.electric_large_open
synthesis_plant.close_sound = sounds.electric_large_close

data:extend({
  { type = "recipe-category", name = "fw-flux-harvesting" },
  { type = "recipe-category", name = "fw-arc-smelting" },
  { type = "recipe-category", name = "fw-flux-synthesis" },
  {
    type = "item",
    name = "fw-flux-harvester",
    icons = flux_harvester_icons(),
    subgroup = "production-machine",
    order = "f[fw-flux-harvester]",
    inventory_move_sound = item_sounds.metal_large_inventory_move,
    pick_sound = item_sounds.metal_large_inventory_pickup,
    drop_sound = item_sounds.metal_large_inventory_move,
    stack_size = 20,
    place_result = "fw-flux-harvester",
  },
  {
    type = "item",
    name = "fw-arc-foundry",
    icon = advanced_foundry_path .. "advanced-foundry-icon.png",
    icon_size = 64,
    subgroup = "production-machine",
    order = "g[fw-arc-foundry]",
    inventory_move_sound = item_sounds.metal_large_inventory_move,
    pick_sound = item_sounds.metal_large_inventory_pickup,
    drop_sound = item_sounds.metal_large_inventory_move,
    stack_size = 10,
    place_result = "fw-arc-foundry",
  },
  {
    type = "item",
    name = "fw-synthesis-plant",
    icon = gravity_assembler_path .. "gravity-assembler-icon.png",
    icon_size = 64,
    subgroup = "production-machine",
    order = "h[fw-synthesis-plant]",
    inventory_move_sound = item_sounds.metal_large_inventory_move,
    pick_sound = item_sounds.metal_large_inventory_pickup,
    drop_sound = item_sounds.metal_large_inventory_move,
    stack_size = 10,
    place_result = "fw-synthesis-plant",
  },
  {
    type = "recipe",
    name = "fw-flux-harvester",
    icons = flux_harvester_icons(),
    enabled = false,
    energy_required = 10,
    ingredients = {
      { type = "item", name = "crusher", amount = 1 },
      { type = "item", name = "chemical-plant", amount = 1 },
      { type = "item", name = "fw-pressure-housing", amount = 1 },
      { type = "item", name = "fw-flow-regulator", amount = 1 },
      { type = "item", name = "fw-transformer-core", amount = 1 },
      { type = "item", name = "fw-harvester-head", amount = 1 },
      { type = "item", name = "fw-steel-beam", amount = 8 },
      { type = "item", name = "fw-cermet", amount = 6 },
    },
    results = { { type = "item", name = "fw-flux-harvester", amount = 1 } },
  },
  {
    type = "recipe",
    name = "fw-arc-foundry",
    icon = advanced_foundry_path .. "advanced-foundry-icon.png",
    icon_size = 64,
    enabled = false,
    energy_required = 14,
    ingredients = {
      { type = "item", name = "electric-furnace", amount = 2 },
      { type = "item", name = "fw-foundry-lining", amount = 6 },
      { type = "item", name = "fw-field-winding", amount = 2 },
      { type = "item", name = "fw-annealed-cermet", amount = 8 },
      { type = "item", name = "fw-power-regulator", amount = 2 },
      { type = "item", name = "titanium-plate", amount = 16 },
    },
    results = { { type = "item", name = "fw-arc-foundry", amount = 1 } },
  },
  {
    type = "recipe",
    name = "fw-synthesis-plant",
    icon = gravity_assembler_path .. "gravity-assembler-icon.png",
    icon_size = 64,
    enabled = false,
    energy_required = 12,
    ingredients = {
      { type = "item", name = "chemical-plant", amount = 2 },
      { type = "item", name = "fw-pressure-housing", amount = 3 },
      { type = "item", name = "fw-flow-regulator", amount = 2 },
      { type = "item", name = "fw-circuit-substrate", amount = 3 },
      { type = "item", name = "fw-coil-block", amount = 2 },
      { type = "item", name = "fw-lens-array", amount = 1 },
      { type = "item", name = "fw-cermet", amount = 4 },
      { type = "item", name = "advanced-circuit", amount = 6 },
    },
    results = { { type = "item", name = "fw-synthesis-plant", amount = 1 } },
  },
  harvester,
  arc_foundry,
  synthesis_plant,
})
