local item_sounds = require("__base__.prototypes.item_sounds")
local sounds = require("__base__.prototypes.entity.sounds")
local util = require("util")
local convector_path = "__finely-crafted-graphics__/graphics/convector/"
local quantum_stabilizer_path = "__finely-crafted-graphics__/graphics/quantum-stabilizer/"
local condenser_icon = "__FluxWorksAssets__/graphics/icons/items/fw-flux-condenser.png"
local origin_forge_icon = "__FluxWorksAssets__/graphics/icons/items/origin-projects/fw-origin-forge.png"

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

local function make_origin_forge_graphics()
  return {
    animation = {
      layers = {
        {
          filename = convector_path .. "convector-hr-shadow.png",
          priority = "high",
          width = 600,
          height = 500,
        frame_count = 1,
        line_length = 1,
        repeat_count = 80,
        animation_speed = 0.2,
        draw_as_shadow = true,
        scale = 0.64,
        shift = util.by_pixel(10, 14),
      },
        {
          priority = "high",
          width = 360,
          height = 350,
          frame_count = 80,
          lines_per_file = 8,
          animation_speed = 0.2,
          scale = 0.64,
          shift = util.by_pixel(0, -12),
          stripes = {
            { filename = convector_path .. "convector-hr-animation-1.png", width_in_frames = 8, height_in_frames = 8 },
            { filename = convector_path .. "convector-hr-animation-2.png", width_in_frames = 8, height_in_frames = 2 },
          },
        },
      },
    },
    working_visualisations = {
      {
        fadeout = true,
        animation = {
          priority = "high",
          width = 360,
          height = 350,
          frame_count = 80,
          lines_per_file = 8,
          animation_speed = 0.2,
          scale = 0.64,
          shift = util.by_pixel(0, -12),
          draw_as_glow = true,
          blend_mode = "additive",
          tint = { r = 0.72, g = 0.34, b = 1.0, a = 0.9 },
          stripes = {
            { filename = convector_path .. "convector-hr-animation-emission-1.png", width_in_frames = 8, height_in_frames = 8 },
            { filename = convector_path .. "convector-hr-animation-emission-2.png", width_in_frames = 8, height_in_frames = 2 },
          },
        },
      },
      working_light(0.92, 12, { 0.0, -0.3 }, { r = 0.65, g = 0.35, b = 1.0 }),
      working_light(0.55, 8, { 1.0, 0.75 }, { r = 0.22, g = 0.8, b = 1.0 }),
      working_light(0.45, 7, { -1.15, 0.9 }, { r = 1.0, g = 0.48, b = 0.24 }),
    },
  }
end

local condenser = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-3"])
condenser.name = "fw-flux-condenser"
condenser.icon = condenser_icon
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
condenser.crafting_speed = 1.05
condenser.fluid_boxes = table.deepcopy(data.raw["assembling-machine"]["chemical-plant"].fluid_boxes)
local fluid_box_positions = {
  { position = { -1.5, -2.59 }, direction = defines.direction.north },
  { position = { 1.5, -2.59 }, direction = defines.direction.north },
  { position = { -1.5, 2.59 }, direction = defines.direction.south },
  { position = { 1.5, 2.59 }, direction = defines.direction.south },
}
for index, fluid_box in pairs(condenser.fluid_boxes) do
  if type(fluid_box) == "table" then
    fluid_box.production_type = "input"
    fluid_box.volume = 10000
    if fluid_box.pipe_connections and fluid_box.pipe_connections[1] and fluid_box_positions[index] then
      fluid_box.pipe_connections[1].flow_direction = "input"
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
condenser.energy_usage = "7.5MW"
condenser.ingredient_count = 40
condenser.max_item_product_count = 40
condenser.module_slots = 3
condenser.allowed_effects = { "consumption", "speed", "productivity", "pollution", "quality" }
condenser.graphics_set = {
  animation_progress = 0.5,
  animation = {
    layers = {
      {
        priority = "high",
        width = 410,
        height = 410,
        frame_count = 104,
        lines_per_file = 8,
        animation_speed = 0.16,
        shift = util.by_pixel(0, -8.5),
        scale = 0.5,
        stripes = {
          { filename = quantum_stabilizer_path .. "quantum-stabilizer-hr-animation-1.png", width_in_frames = 8, height_in_frames = 8 },
          { filename = quantum_stabilizer_path .. "quantum-stabilizer-hr-animation-2.png", width_in_frames = 8, height_in_frames = 5 },
        },
      },
      {
        filename = quantum_stabilizer_path .. "quantum-stabilizer-hr-shadow.png",
        priority = "high",
        width = 900,
        height = 420,
        frame_count = 1,
        line_length = 1,
        repeat_count = 104,
        animation_speed = 0.16,
        shift = util.by_pixel(13, 1),
        scale = 0.5,
        draw_as_shadow = true,
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
        animation_speed = 0.16,
        shift = util.by_pixel(0, -10),
        scale = 0.5,
        draw_as_glow = true,
        blend_mode = "additive",
        stripes = {
          { filename = quantum_stabilizer_path .. "quantum-stabilizer-hr-animation-emission-1.png", width_in_frames = 8, height_in_frames = 8 },
          { filename = quantum_stabilizer_path .. "quantum-stabilizer-hr-animation-emission-2.png", width_in_frames = 8, height_in_frames = 5 },
        },
      },
    },
    {
      light = {
        intensity = 0.95,
        size = 10,
        shift = { 0.0, -0.3 },
        color = { r = 0.5, g = 0.85, b = 1.0 },
      },
    },
    {
      light = {
        intensity = 0.45,
        size = 6,
        shift = { 1.1, 0.4 },
        color = { r = 0.95, g = 0.35, b = 1.0 },
      },
    },
  },
}

condenser.open_sound = { filename = "__base__/sound/open-close/electric-large-open.ogg", volume = 0.6 }
condenser.close_sound = { filename = "__base__/sound/open-close/electric-large-close.ogg", volume = 0.6 }
condenser.working_sound = {
  sound = {
    filename = "__space-age__/sound/entity/fusion/fusion-generator.ogg",
    volume = 0.38,
    audible_distance_modifier = 0.55,
  },
  fade_in_ticks = 6,
  fade_out_ticks = 30,
  max_sounds_per_prototype = 2,
  sound_accents = {
    { sound = { filename = "__space-age__/sound/entity/electromagnetic-plant/electromagnetic-plant-warmup.ogg", volume = 0.35, audible_distance_modifier = 0.25 }, frame = 1 },
    { sound = { filename = "__space-age__/sound/entity/electromagnetic-plant/emp-electric-4.ogg", volume = 0.36, audible_distance_modifier = 0.28 }, frame = 1 },
  },
}

local origin_forge = table.deepcopy(condenser)
origin_forge.name = "fw-origin-forge"
origin_forge.minable = { mining_time = 1, result = "fw-origin-forge" }
origin_forge.max_health = 2200
origin_forge.collision_box = { { -2.9, -2.9 }, { 2.9, 2.9 } }
origin_forge.selection_box = { { -3.5, -3.5 }, { 3.5, 3.5 } }
origin_forge.fast_replaceable_group = "fw-flux-condenser"
origin_forge.crafting_categories = { "fw-origin-forging" }
origin_forge.crafting_speed = 0.85
origin_forge.energy_usage = "18MW"
origin_forge.ingredient_count = 48
origin_forge.max_item_product_count = 48
origin_forge.module_slots = 4
origin_forge.allowed_effects = { "consumption", "speed", "productivity", "pollution", "quality" }
origin_forge.icon = origin_forge_icon
origin_forge.icon_size = 64
origin_forge.icons = nil
origin_forge.graphics_set = make_origin_forge_graphics()
origin_forge.open_sound = sounds.steam_open
origin_forge.close_sound = sounds.steam_close
origin_forge.working_sound = {
  sound = {
    filename = "__space-age__/sound/entity/foundry/foundry.ogg",
    volume = 0.55,
    audible_distance_modifier = 0.6,
  },
  fade_in_ticks = 4,
  fade_out_ticks = 24,
  max_sounds_per_prototype = 2,
  sound_accents = {
    { sound = { filename = "__space-age__/sound/entity/foundry/foundry-pipe-out.ogg", volume = 0.85, audible_distance_modifier = 0.35 }, frame = 2 },
    { sound = { filename = "__space-age__/sound/entity/foundry/foundry-slide-close.ogg", volume = 0.6, audible_distance_modifier = 0.28 }, frame = 18 },
    { sound = { filename = "__space-age__/sound/entity/foundry/foundry-clamp.ogg", volume = 0.45, audible_distance_modifier = 0.28 }, frame = 39 },
    { sound = { filename = "__space-age__/sound/entity/foundry/foundry-slide-stop.ogg", volume = 0.65, audible_distance_modifier = 0.35 }, frame = 43 },
    { sound = { variations = sound_variations("__space-age__/sound/entity/foundry/foundry-fire-whoosh", 3, 0.7), audible_distance_modifier = 0.28 }, frame = 64 },
    { sound = { filename = "__space-age__/sound/entity/foundry/foundry-metal-clunk.ogg", volume = 0.6, audible_distance_modifier = 0.35 }, frame = 64 },
    { sound = { filename = "__space-age__/sound/entity/foundry/foundry-slide-open.ogg", volume = 0.6, audible_distance_modifier = 0.28 }, frame = 74 },
    { sound = { filename = "__space-age__/sound/entity/foundry/foundry-smoke-puff.ogg", volume = 0.75, audible_distance_modifier = 0.28 }, frame = 106 },
    { sound = { variations = sound_variations("__space-age__/sound/entity/foundry/foundry-pour", 2, 0.65) }, frame = 110 },
    { sound = { filename = "__space-age__/sound/entity/foundry/foundry-rocks.ogg", volume = 0.6, audible_distance_modifier = 0.28 }, frame = 120 },
  },
}


data:extend({
  {
    type = "recipe-category",
    name = "fw-flux-condensing",
  },
  {
    type = "recipe-category",
    name = "fw-origin-forging",
  },
  {
    type = "item",
    name = "fw-flux-condenser",
    icon = condenser_icon,
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
    type = "item",
    name = "fw-origin-forge",
    icon = origin_forge_icon,
    icon_size = 64,
    subgroup = "production-machine",
    order = "g[fw-origin-forge]",
    inventory_move_sound = item_sounds.metal_large_inventory_move,
    pick_sound = item_sounds.metal_large_inventory_pickup,
    drop_sound = item_sounds.metal_large_inventory_move,
    stack_size = 10,
    place_result = "fw-origin-forge",
  },
  {
    type = "recipe",
    name = "fw-flux-condenser",
    icon = condenser_icon,
    icon_size = 64,
    enabled = false,
    energy_required = 12,
    ingredients = {
      { type = "item", name = "fw-annealed-cermet", amount = 8 },
      { type = "item", name = "fw-resonance-substrate", amount = 4 },
      { type = "item", name = "fw-harvester-head", amount = 2 },
      { type = "item", name = "fw-condensed-flux-matrix", amount = 6 },
      { type = "item", name = "fw-flux-resonance-cell", amount = 4 },
      { type = "item", name = "fw-flux-phase-manifold", amount = 2 },
      { type = "item", name = "fw-power-regulator", amount = 2 },
      { type = "item", name = "fw-em-core", amount = 2 },
    },
    results = {
      { type = "item", name = "fw-flux-condenser", amount = 1 },
    },
  },
  {
    type = "recipe",
    name = "fw-origin-forge",
    icon = origin_forge_icon,
    icon_size = 64,
    enabled = false,
    energy_required = 24,
    ingredients = {
      { type = "item", name = "fw-flux-condenser", amount = 2 },
      { type = "item", name = "fw-rift-coupler", amount = 4 },
      { type = "item", name = "fw-phase-anchor", amount = 4 },
      { type = "item", name = "fw-entanglement-core", amount = 4 },
      { type = "item", name = "fw-promethium-matrix", amount = 4 },
      { type = "item", name = "fusion-power-cell", amount = 12 },
      { type = "item", name = "superconductor", amount = 16 },
      { type = "item", name = "supercapacitor", amount = 16 },
    },
    results = {
      { type = "item", name = "fw-origin-forge", amount = 1 },
    },
  },
  condenser,
  origin_forge,
})
