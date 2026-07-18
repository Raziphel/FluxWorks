local item_sounds = require("__base__.prototypes.item_sounds")
local sounds = require("__base__.prototypes.entity.sounds")
local util = require("util")
local core_extractor_path = "__finely-crafted-graphics__/graphics/core-extractor/"

local flux_quarry = table.deepcopy(data.raw["mining-drill"]["electric-mining-drill"])
flux_quarry.name = "fw-flux-quarry"
flux_quarry.icon = core_extractor_path .. "core-extractor-icon.png"
flux_quarry.icon_size = 64
flux_quarry.minable = { mining_time = 1, result = "fw-flux-quarry" }
flux_quarry.max_health = 1500
flux_quarry.collision_box = { { -5.1, -5.1 }, { 5.1, 5.1 } }
flux_quarry.selection_box = { { -5.5, -5.5 }, { 5.5, 5.5 } }
flux_quarry.resource_categories = { "fw-flux-rift" }
flux_quarry.mining_speed = 4
flux_quarry.energy_usage = "12MW"
flux_quarry.module_slots = 6
flux_quarry.allowed_effects = { "consumption", "speed", "productivity", "pollution" }
flux_quarry.vector_to_place_result = { 0, 5.75 }
flux_quarry.graphics_set = {
  animation = {
    layers = {
      {
        filename = core_extractor_path .. "core-extractor-hr-shadow.png",
        priority = "high",
        width = 1400,
        height = 1400,
        frame_count = 1,
        line_length = 1,
        repeat_count = 120,
        animation_speed = 1,
        shift = util.by_pixel(0, -8),
        draw_as_shadow = true,
        scale = 0.5
      },
      {
        priority = "high",
        width = 704,
        height = 704,
        frame_count = 120,
        lines_per_file = 8,
        animation_speed = 1,
        shift = util.by_pixel(0, -8),
        scale = 0.5,
        stripes = {
          {
            filename = core_extractor_path .. "core-extractor-hr-animation-1.png",
            width_in_frames = 8,
            height_in_frames = 8
          },
          {
            filename = core_extractor_path .. "core-extractor-hr-animation-2.png",
            width_in_frames = 8,
            height_in_frames = 7
          }
        }
      }
    }
  },
  working_visualisations = {
    {
      fadeout = true,
      animation = {
        layers = {
          {
            priority = "high",
            width = 704,
            height = 704,
            frame_count = 120,
            lines_per_file = 8,
            animation_speed = 1,
            shift = util.by_pixel(0, -8),
            scale = 0.5,
            stripes = {
              {
                filename = core_extractor_path .. "core-extractor-hr-animation-emission-1.png",
                width_in_frames = 8,
                height_in_frames = 8
              },
              {
                filename = core_extractor_path .. "core-extractor-hr-animation-emission-2.png",
                width_in_frames = 8,
                height_in_frames = 7
              }
            },
            draw_as_glow = true,
            blend_mode = "additive",
          },
          {
            priority = "high",
            width = 704,
            height = 704,
            frame_count = 120,
            lines_per_file = 8,
            animation_speed = 1,
            shift = util.by_pixel(0, -8),
            scale = 0.5,
            stripes = {
              {
                filename = core_extractor_path .. "core-extractor-hr-emission-1.png",
                width_in_frames = 8,
                height_in_frames = 8
              },
              {
                filename = core_extractor_path .. "core-extractor-hr-emission-2.png",
                width_in_frames = 8,
                height_in_frames = 7
              }
            },
            draw_as_glow = true,
            blend_mode = "additive",
            tint = { r = 0.7, g = 0.35, b = 1.0, a = 0.85 },
          },
        },
      },
    },
    {
      light = {
        intensity = 1.0,
        size = 18,
        shift = { 0.0, -0.45 },
        color = { r = 0.68, g = 0.32, b = 1.0 },
      },
    },
    {
      light = {
        intensity = 0.5,
        size = 12,
        shift = { 0.8, 0.35 },
        color = { r = 0.3, g = 0.82, b = 1.0 },
      },
    },
  },
}
flux_quarry.working_sound = {
  sound = { filename = "__space-age__/sound/entity/big-mining-drill/big-mining-drill-loop.ogg", volume = 0.8 },
  apparent_volume = 0.6
}
flux_quarry.open_sound = sounds.machine_open
flux_quarry.close_sound = sounds.machine_close

data:extend({
  {
    type = "resource-category",
    name = "fw-flux-rift",
  },
  {
    type = "item",
    name = "fw-flux-quarry",
    icon = core_extractor_path .. "core-extractor-icon.png",
    icon_size = 64,
    subgroup = "extraction-machine",
    order = "c[miner]-f[fw-flux-quarry]",
    inventory_move_sound = item_sounds.metal_large_inventory_move,
    pick_sound = item_sounds.metal_large_inventory_pickup,
    drop_sound = item_sounds.metal_large_inventory_move,
    stack_size = 10,
    place_result = "fw-flux-quarry",
  },
  {
    type = "recipe",
    name = "fw-flux-quarry",
    icon = core_extractor_path .. "core-extractor-icon.png",
    icon_size = 64,
    enabled = false,
    energy_required = 20,
    ingredients = {
      { type = "item", name = "pumpjack", amount = 2 },
      { type = "item", name = "electric-mining-drill", amount = 4 },
      { type = "item", name = "fw-steel-beam", amount = 20 },
      { type = "item", name = "fw-cermet", amount = 12 },
      { type = "item", name = "fw-pressure-housing", amount = 6 },
      { type = "item", name = "fw-flow-regulator", amount = 4 },
      { type = "item", name = "fw-drive-module", amount = 8 },
      { type = "item", name = "fw-control-assembly", amount = 6 },
      { type = "item", name = "advanced-circuit", amount = 12 },
      { type = "item", name = "electric-motor", amount = 10 },
    },
    results = { { type = "item", name = "fw-flux-quarry", amount = 1 } },
  },
  flux_quarry,
})
