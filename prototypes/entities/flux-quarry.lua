local item_sounds = require("__base__.prototypes.item_sounds")
local sounds = require("__base__.prototypes.entity.sounds")
local util = require("util")

local flux_quarry = table.deepcopy(data.raw["mining-drill"]["electric-mining-drill"])
flux_quarry.name = "fw-flux-quarry"
flux_quarry.icon = "__FluxWorksAssets__/graphics/icons/items/fw-flux-quarry.png"
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
        filename = "__FluxWorksAssets__/graphics/entity/flux-quarry/core-miner-hr-shadow.png",
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
            filename = "__FluxWorksAssets__/graphics/entity/flux-quarry/core-miner-hr-animation-1.png",
            width_in_frames = 8,
            height_in_frames = 8
          },
          {
            filename = "__FluxWorksAssets__/graphics/entity/flux-quarry/core-miner-hr-animation-2.png",
            width_in_frames = 8,
            height_in_frames = 7
          }
        }
      }
    }
  }
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
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-flux-quarry.png",
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
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-flux-quarry.png",
    icon_size = 64,
    enabled = false,
    energy_required = 30,
    ingredients = {
      { type = "item", name = "big-mining-drill", amount = 2 },
      { type = "item", name = "electric-mining-drill", amount = 8 },
      { type = "item", name = "fw-steel-beam", amount = 40 },
      { type = "item", name = "fw-cermet", amount = 24 },
      { type = "item", name = "fw-transformer-core", amount = 16 },
      { type = "item", name = "processing-unit", amount = 30 },
      { type = "item", name = "titanium-plate", amount = 60 },
      { type = "item", name = "electric-engine-unit", amount = 30 },
      { type = "item", name = "low-density-structure", amount = 20 },
    },
    results = { { type = "item", name = "fw-flux-quarry", amount = 1 } },
  },
  flux_quarry,
})
