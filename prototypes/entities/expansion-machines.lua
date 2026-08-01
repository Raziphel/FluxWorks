local util = require("util")
local thermal_plant_path = "__finely-crafted-graphics__/graphics/thermal-plant/"
local oxidizer_path = "__finely-crafted-graphics__/graphics/oxidizer/"

local assembler_pictures = require("__base__.prototypes.entity.assembler-pictures")
local assembler2_pipe_pictures = assembler_pictures.assembler2pipepictures
local assembler3_pipe_pictures = assembler_pictures.assembler3pipepictures

local petro = table.deepcopy(data.raw["assembling-machine"]["chemical-plant"])
petro.name = "fw-petrochemical-facility"
petro.icon = thermal_plant_path .. "thermal-plant-icon.png"
petro.icon_size = 64
petro.minable = { mining_time = 0.5, result = "fw-petrochemical-facility" }
petro.max_health = 650
petro.collision_box = { { -2.5, -2.5 }, { 2.5, 2.5 } }
petro.selection_box = { { -3, -3 }, { 3, 3 } }
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
        filename = thermal_plant_path .. "thermal-plant-hr-shadow.png",
        priority = "high",
        width = 900,
        height = 500,
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
          { filename = thermal_plant_path .. "thermal-plant-hr-animation-1.png", width_in_frames = 8, height_in_frames = 8 },
          { filename = thermal_plant_path .. "thermal-plant-hr-animation-2.png", width_in_frames = 8, height_in_frames = 2 },
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
              { filename = thermal_plant_path .. "thermal-plant-hr-animation-1.png", width_in_frames = 8, height_in_frames = 8 },
              { filename = thermal_plant_path .. "thermal-plant-hr-animation-2.png", width_in_frames = 8, height_in_frames = 2 },
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
              { filename = thermal_plant_path .. "thermal-plant-hr-emission-1.png", width_in_frames = 8, height_in_frames = 8 },
              { filename = thermal_plant_path .. "thermal-plant-hr-emission-2.png", width_in_frames = 8, height_in_frames = 2 },
            },
          },
        },
      },
    },
  },
}
petro.working_sound = {
  sound = { filename = "__base__/sound/chemical-plant-1.ogg", volume = 0.9 },
  apparent_volume = 0.5,
}
petro.open_sound = { filename = "__base__/sound/open-close/fluid-open.ogg", volume = 0.55 }
petro.close_sound = { filename = "__base__/sound/open-close/fluid-close.ogg", volume = 0.54 }

local hydraulic = table.deepcopy(data.raw["assembling-machine"]["chemical-plant"])
hydraulic.name = "fw-hydraulic-plant"
hydraulic.icon = oxidizer_path .. "oxidizer-icon.png"
hydraulic.icon_size = 64
hydraulic.minable = { mining_time = 0.5, result = "fw-hydraulic-plant" }
hydraulic.max_health = 550
hydraulic.collision_box = { { -2.0, -2.0 }, { 2.0, 2.0 } }
hydraulic.selection_box = { { -2.4, -2.4 }, { 2.4, 2.4 } }
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
        filename = oxidizer_path .. "oxidizer-hr-shadow.png",
        priority = "high",
        width = 600,
        height = 400,
        frame_count = 1,
        line_length = 1,
        repeat_count = 64,
        animation_speed = 0.3,
        shift = util.by_pixel(8, 2),
        draw_as_shadow = true,
        scale = 0.44,
      },
      {
        priority = "high",
        width = 320,
        height = 370,
        frame_count = 64,
        line_length = 8,
        animation_speed = 0.3,
        scale = 0.44,
        shift = util.by_pixel(0, -10),
        filename = oxidizer_path .. "oxidizer-hr-animation.png",
      },
    },
  },
  working_visualisations = {
    {
      fadeout = true,
      animation = {
        filename = oxidizer_path .. "oxidizer-hr-animation.png",
        priority = "high",
        width = 320,
        height = 370,
        frame_count = 64,
        line_length = 8,
        animation_speed = 0.3,
        scale = 0.44,
        shift = util.by_pixel(0, -10),
        draw_as_glow = true,
        blend_mode = "additive",
        tint = { r = 0.25, g = 0.85, b = 0.95, a = 0.35 },
      },
    },
    {
      light = {
        intensity = 0.45,
        size = 6,
        shift = { 0.0, -0.2 },
        color = { r = 0.2, g = 0.85, b = 0.95 },
      },
    },
  },
}
hydraulic.working_sound = {
  sound = { filename = "__base__/sound/chemical-plant-2.ogg", volume = 0.78 },
  apparent_volume = 0.3,
}
hydraulic.open_sound = { filename = "__base__/sound/open-close/fluid-open.ogg", volume = 0.55 }
hydraulic.close_sound = { filename = "__base__/sound/open-close/fluid-close.ogg", volume = 0.54 }

data:extend({ petro, hydraulic })
