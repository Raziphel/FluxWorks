local item_sounds = require("__base__.prototypes.item_sounds")
local util = require("util")

local condenser = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-3"])
condenser.name = "fw-flux-condenser"
condenser.icon = "__FluxWorksAssets__/graphics/icons/items/fw-flux-condenser.png"
condenser.icon_size = 64
condenser.minable = { mining_time = 0.8, result = "fw-flux-condenser" }
condenser.max_health = 1500
condenser.collision_box = { { -2.6, -2.6 }, { 2.6, 2.6 } }
condenser.selection_box = { { -3, -3 }, { 3, 3 } }
condenser.fast_replaceable_group = "fw-flux-condenser"
condenser.icon_draw_specification = { shift = {0, -0.3} }
condenser.circuit_wire_max_distance = assembling_machine_circuit_wire_max_distance
condenser.circuit_connector = circuit_connector_definitions["assembling-machine"]
condenser.crafting_categories = { "fw-flux-condensing" }
condenser.crafting_speed = 1
condenser.fluid_boxes = table.deepcopy(data.raw["assembling-machine"]["chemical-plant"].fluid_boxes)
local fluid_box_positions = {
  { position = { -1.5, -2.59 }, direction = defines.direction.north },
  { position = { 1.5, -2.59 }, direction = defines.direction.north },
  { position = { -1.5, 2.59 }, direction = defines.direction.south },
  { position = { 1.5, 2.59 }, direction = defines.direction.south },
}
for index, fluid_box in pairs(condenser.fluid_boxes) do
  if type(fluid_box) == "table" then
    fluid_box.volume = 10000
    if fluid_box.pipe_connections and fluid_box.pipe_connections[1] and fluid_box_positions[index] then
      fluid_box.pipe_connections[1].position = fluid_box_positions[index].position
      fluid_box.pipe_connections[1].direction = fluid_box_positions[index].direction
    end
  end
end
condenser.fluid_boxes_off_when_no_fluid_recipe = true
condenser.energy_source = {
  type = "electric",
  usage_priority = "secondary-input",
  emissions_per_minute = { pollution = 0 },
}
condenser.energy_usage = "750kW"
condenser.ingredient_count = 40
condenser.max_item_product_count = 40
condenser.module_slots = 0
condenser.allowed_effects = {}
condenser.graphics_set = {
  animation_progress = 0.5,
  animation = {
    layers = {
      {
        filename = "__FluxWorksAssets__/graphics/entity/flux-condenser/quantum-computer-hr-animation-1.png",
        width = 400,
        height = 400,
        frame_count = 1,
        line_length = 1,
        shift = util.by_pixel(0, -8.5),
        scale = 0.5,
      },
      {
        filename = "__FluxWorksAssets__/graphics/entity/flux-condenser/quantum-computer-hr-emission-1.png",
        width = 400,
        height = 400,
        frame_count = 1,
        line_length = 1,
        shift = util.by_pixel(0, -10),
        scale = 0.5,
        draw_as_glow = true,
        blend_mode = "additive",
      },
      {
        filename = "__FluxWorksAssets__/graphics/entity/flux-condenser/quantum-computer-hr-shadow.png",
        width = 700,
        height = 600,
        frame_count = 1,
        line_length = 1,
        shift = util.by_pixel(13, 1),
        scale = 0.5,
        draw_as_shadow = true,
      },
    },
  },
}

condenser.open_sound = { filename = "__base__/sound/open-close/lab-open.ogg", volume = 0.6 }
condenser.close_sound = { filename = "__base__/sound/open-close/lab-close.ogg", volume = 0.6 }


data:extend({
  {
    type = "recipe-category",
    name = "fw-flux-condensing",
  },
  {
    type = "item",
    name = "fw-flux-condenser",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-flux-condenser.png",
    icon_size = 64,
    subgroup = "production-machine",
    order = "f[fw-flux-condenser]",
    inventory_move_sound = item_sounds.metal_large_inventory_move,
    pick_sound = item_sounds.metal_large_inventory_pickup,
    drop_sound = item_sounds.metal_large_inventory_move,
    stack_size = 20,
    place_result = "fw-flux-condenser",
  },
  {
    type = "recipe",
    name = "fw-flux-condenser",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-flux-condenser.png",
    icon_size = 64,
    enabled = false,
    energy_required = 12,
    ingredients = {
      { type = "item", name = "chemical-plant", amount = 2 },
      { type = "item", name = "fw-condensed-flux-matrix", amount = 4 },
      { type = "item", name = "fw-flux-resonance-cell", amount = 2 },
      { type = "item", name = "fw-flux-phase-manifold", amount = 1 },
      { type = "item", name = "processing-unit", amount = 20 },
      { type = "item", name = "electric-engine-unit", amount = 10 },
    },
    results = {
      { type = "item", name = "fw-flux-condenser", amount = 1 },
    },
  },
  condenser,
})
