local util = require("util")

local assembler2_pipe_pictures = assembler2pipepictures()
local assembler3_pipe_pictures = assembler3pipepictures()

local petro = table.deepcopy(data.raw["assembling-machine"]["chemical-plant"])
petro.name = "fw-petrochemical-facility"
petro.icon = "__FluxWorksAssets__/graphics/icons/items/fw-petrochemical-facility.png"
petro.icon_size = 64
petro.minable = { mining_time = 0.5, result = "fw-petrochemical-facility" }
petro.max_health = 650
petro.collision_box = { { -2.1, -2.1 }, { 2.1, 2.1 } }
petro.selection_box = { { -2.5, -2.5 }, { 2.5, 2.5 } }
petro.crafting_categories = { "fw-petrochemistry" }
petro.crafting_speed = 2.8
petro.energy_usage = "4.8MW"
petro.energy_source = {
  type = "electric",
  usage_priority = "secondary-input",
  drain = "180kW",
  emissions_per_minute = { pollution = 40 },
}
petro.module_slots = 6
petro.allowed_effects = { "consumption", "speed", "productivity", "pollution", "quality" }
petro.fluid_boxes = {
  {
    production_type = "input",
    pipe_picture = assembler3_pipe_pictures,
    pipe_covers = pipecoverspictures(),
    volume = 1000,
    pipe_connections = { { flow_direction = "input", direction = defines.direction.south, position = { -1, 2 } } },
  },
  {
    production_type = "input",
    pipe_picture = assembler3_pipe_pictures,
    pipe_covers = pipecoverspictures(),
    volume = 1000,
    pipe_connections = { { flow_direction = "input", direction = defines.direction.south, position = { 0, 2 } } },
  },
  {
    production_type = "input",
    pipe_picture = assembler3_pipe_pictures,
    pipe_covers = pipecoverspictures(),
    volume = 1000,
    pipe_connections = { { flow_direction = "input", direction = defines.direction.south, position = { 1, 2 } } },
  },
  {
    production_type = "output",
    pipe_picture = assembler3_pipe_pictures,
    pipe_covers = pipecoverspictures(),
    volume = 100,
    pipe_connections = { { flow_direction = "output", direction = defines.direction.north, position = { 0, -2 } } },
  },
}
petro.fluid_boxes_off_when_no_fluid_recipe = true
petro.graphics_set = {
  animation = {
    layers = {
      {
        filename = "__FluxWorksAssets__/graphics/entity/petrochemical-facility/petrochemical-facility-hr-shadow.png",
        priority = "high",
        width = 800,
        height = 600,
        frame_count = 1,
        line_length = 1,
        repeat_count = 60,
        animation_speed = 0.3,
        draw_as_shadow = true,
        scale = 0.45,
        shift = util.by_pixel(0, -10),
      },
      {
        priority = "high",
        width = 400,
        height = 400,
        frame_count = 60,
        lines_per_file = 8,
        animation_speed = 0.3,
        scale = 0.45,
        shift = util.by_pixel(0, -10),
        stripes = {
          { filename = "__FluxWorksAssets__/graphics/entity/petrochemical-facility/petrochemical-facility-hr-animation-1.png", width_in_frames = 8, height_in_frames = 8 },
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
            width = 400,
            height = 400,
            frame_count = 60,
            lines_per_file = 8,
            animation_speed = 0.3,
            scale = 0.45,
            shift = util.by_pixel(0, -10),
            stripes = {
              { filename = "__FluxWorksAssets__/graphics/entity/petrochemical-facility/petrochemical-facility-hr-animation-1.png", width_in_frames = 8, height_in_frames = 8 },
            },
          },
          {
            priority = "high",
            draw_as_glow = true,
            blend_mode = "additive",
            width = 400,
            height = 400,
            frame_count = 60,
            lines_per_file = 8,
            animation_speed = 0.3,
            scale = 0.45,
            shift = util.by_pixel(0, -10),
            stripes = {
              { filename = "__FluxWorksAssets__/graphics/entity/petrochemical-facility/petrochemical-facility-hr-emission-1.png", width_in_frames = 8, height_in_frames = 8 },
            },
          },
        },
      },
    },
  },
}
petro.working_sound = {
  sound = { filename = "__FluxWorksAssets__/sounds/petrochemical-facility.ogg", volume = 0.9 },
  apparent_volume = 0.5,
}
petro.open_sound = { filename = "__base__/sound/open-close/fluid-open.ogg", volume = 0.55 }
petro.close_sound = { filename = "__base__/sound/open-close/fluid-close.ogg", volume = 0.54 }

local hydraulic = table.deepcopy(data.raw["assembling-machine"]["chemical-plant"])
hydraulic.name = "fw-hydraulic-plant"
hydraulic.icon = "__FluxWorksAssets__/graphics/icons/items/fw-hydraulic-plant.png"
hydraulic.icon_size = 64
hydraulic.minable = { mining_time = 0.5, result = "fw-hydraulic-plant" }
hydraulic.max_health = 550
hydraulic.collision_box = { { -1.6, -1.6 }, { 1.6, 1.6 } }
hydraulic.selection_box = { { -2, -2 }, { 2, 2 } }
hydraulic.crafting_categories = { "fw-hydraulics" }
hydraulic.crafting_speed = 2.5
hydraulic.energy_usage = "1.9MW"
hydraulic.energy_source = {
  type = "electric",
  usage_priority = "secondary-input",
  drain = "70kW",
  emissions_per_minute = { pollution = 4 },
}
hydraulic.module_slots = 5
hydraulic.allowed_effects = { "consumption", "speed", "productivity", "pollution", "quality" }
hydraulic.fluid_boxes = {
  {
    production_type = "input",
    pipe_picture = assembler2_pipe_pictures,
    pipe_covers = pipecoverspictures(),
    volume = 100,
    pipe_connections = { { direction = defines.direction.south, flow_direction = "input", position = { -0.5, 1.5 } } },
    secondary_draw_orders = { north = -1 },
  },
  {
    production_type = "input",
    pipe_picture = assembler2_pipe_pictures,
    pipe_covers = pipecoverspictures(),
    volume = 100,
    pipe_connections = { { direction = defines.direction.south, flow_direction = "input", position = { 0.5, 1.5 } } },
    secondary_draw_orders = { north = -1 },
  },
}
hydraulic.fluid_boxes_off_when_no_fluid_recipe = true
hydraulic.graphics_set = {
  animation = {
    layers = {
      {
        filename = "__FluxWorksAssets__/graphics/entity/hydraulic-plant/hydraulic-plant-hr-shadow.png",
        priority = "high",
        width = 1200,
        height = 800,
        frame_count = 1,
        line_length = 1,
        repeat_count = 60,
        animation_speed = 1,
        shift = util.by_pixel(4, -12),
        draw_as_shadow = true,
        scale = 0.25,
      },
      {
        priority = "high",
        width = 280,
        height = 320,
        frame_count = 60,
        lines_per_file = 8,
        animation_speed = 1,
        scale = 0.5,
        shift = util.by_pixel(0, -14),
        stripes = {
          { filename = "__FluxWorksAssets__/graphics/entity/hydraulic-plant/hydraulic-plant-hr-animation-1.png", width_in_frames = 8, height_in_frames = 8 },
        },
      },
    },
  },
  recipe_not_set_tint = { primary = { r = 0.0, g = 0.6, b = 0.6, a = 1 } },
  working_visualisations = {
    {
      fadeout = true,
      animation = {
        layers = {
          {
            priority = "high",
            width = 280,
            height = 320,
            frame_count = 60,
            lines_per_file = 8,
            animation_speed = 1,
            scale = 0.5,
            shift = util.by_pixel(0, -14),
            stripes = {
              { filename = "__FluxWorksAssets__/graphics/entity/hydraulic-plant/hydraulic-plant-hr-animation-1.png", width_in_frames = 8, height_in_frames = 8 },
            },
          },
          {
            priority = "high",
            draw_as_glow = true,
            blend_mode = "additive",
            width = 280,
            height = 320,
            frame_count = 60,
            lines_per_file = 8,
            animation_speed = 1,
            scale = 0.5,
            shift = util.by_pixel(0, -14),
            stripes = {
              { filename = "__FluxWorksAssets__/graphics/entity/hydraulic-plant/hydraulic-plant-hr-emission-1.png", width_in_frames = 8, height_in_frames = 8 },
            },
          },
          {
            priority = "high",
            fadeout = true,
            blend_mode = "additive",
            apply_recipe_tint = "primary",
            width = 280,
            height = 320,
            frame_count = 60,
            lines_per_file = 8,
            animation_speed = 1,
            scale = 0.5,
            shift = util.by_pixel(0, -14),
            stripes = {
              { filename = "__FluxWorksAssets__/graphics/entity/hydraulic-plant/hydraulic-plant-hr-color.png", width_in_frames = 8, height_in_frames = 8 },
            },
          },
        },
      },
    },
  },
}
hydraulic.working_sound = {
  sound = { filename = "__FluxWorksAssets__/sounds/hydraulic-plant.ogg", volume = 0.9 },
  apparent_volume = 0.3,
}
hydraulic.open_sound = { filename = "__base__/sound/open-close/fluid-open.ogg", volume = 0.55 }
hydraulic.close_sound = { filename = "__base__/sound/open-close/fluid-close.ogg", volume = 0.54 }

data:extend({ petro, hydraulic })
