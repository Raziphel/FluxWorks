local hit_effects = require("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")

local function loader_structure(tint)
  return {
    direction_in = {
      sheets = {
        {
          filename = "__Krastorio2Assets__/buildings/loader/kr-loader.png",
          priority = "extra-high",
          shift = { 0.15625, 0.0703125 },
          width = 106,
          height = 85,
          y = 85,
          scale = 0.5,
        },
        {
          filename = "__Krastorio2Assets__/buildings/loader/kr-loader-mask.png",
          priority = "extra-high",
          shift = { 0.15625, 0.0703125 },
          width = 106,
          height = 85,
          y = 85,
          scale = 0.5,
          tint = tint,
        },
        {
          filename = "__Krastorio2Assets__/buildings/loader/kr-loader-rust.png",
          priority = "extra-high",
          shift = { 0.15625, 0.0703125 },
          width = 106,
          height = 85,
          y = 85,
          scale = 0.5,
        },
      },
    },
    direction_out = {
      sheets = {
        {
          filename = "__Krastorio2Assets__/buildings/loader/kr-loader.png",
          priority = "extra-high",
          shift = { 0.15625, 0.0703125 },
          width = 106,
          height = 85,
          scale = 0.5,
        },
        {
          filename = "__Krastorio2Assets__/buildings/loader/kr-loader-mask.png",
          priority = "extra-high",
          shift = { 0.15625, 0.0703125 },
          width = 106,
          height = 85,
          scale = 0.5,
          tint = tint,
        },
        {
          filename = "__Krastorio2Assets__/buildings/loader/kr-loader-rust.png",
          priority = "extra-high",
          shift = { 0.15625, 0.0703125 },
          width = 106,
          height = 85,
          scale = 0.5,
        },
      },
    },
  }
end

local function add_unlock(technology_name, recipe_name)
  local technology = data.raw.technology and data.raw.technology[technology_name]
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if not technology or not recipe then
    return
  end

  technology.effects = technology.effects or {}
  for _, effect in pairs(technology.effects) do
    if effect.type == "unlock-recipe" and effect.recipe == recipe_name then
      return
    end
  end

  technology.effects[#technology.effects + 1] = { type = "unlock-recipe", recipe = recipe_name }
end

local function warehouse_reflection()
  return {
    pictures = {
      filename = "__Krastorio2Assets__/buildings/warehouse/warehouse-reflection.png",
      priority = "extra-high",
      width = 60,
      height = 50,
      shift = util.by_pixel(0, 40),
      variation_count = 1,
      scale = 5,
    },
    rotate = false,
    orientation_to_variation = false,
  }
end

local function make_loader(name, belt_name, icon_path, tint, ingredients, order, next_upgrade, drain)
  return {
    {
      type = "recipe",
      name = name,
      energy_required = 2,
      enabled = false,
      ingredients = ingredients,
      results = { { type = "item", name = name, amount = 1 } },
    },
    {
      type = "item",
      name = name,
      icon = icon_path,
      icon_size = 64,
      subgroup = "belt",
      order = order,
      place_result = name,
      stack_size = 50,
    },
    {
      type = "loader-1x1",
      name = name,
      icon = icon_path,
      icon_size = 64,
      flags = { "placeable-neutral", "player-creation" },
      minable = { mining_time = 0.25, result = name },
      placeable_by = { item = name, count = 1 },
      fast_replaceable_group = "transport-belt",
      next_upgrade = next_upgrade,
      collision_box = { { -0.4, -0.45 }, { 0.4, 0.45 } },
      selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
      speed = data.raw["transport-belt"][belt_name].speed,
      container_distance = 0.75,
      filter_count = 5,
      energy_source = {
        type = "electric",
        usage_priority = "secondary-input",
        drain = drain,
      },
      energy_per_item = "9kJ",
      max_health = 300,
      corpse = "small-remnants",
      resistances = { { type = "fire", percent = 90 } },
      open_sound = sounds.machine_open,
      close_sound = sounds.machine_close,
      belt_animation_set = data.raw["transport-belt"][belt_name].belt_animation_set,
      animation_speed_coefficient = 32,
      icon_draw_specification = { scale = 0.7 },
      structure = loader_structure(tint),
      structure_render_layer = "object",
      circuit_wire_max_distance = default_circuit_wire_max_distance,
    },
  }
end

local function make_strongbox(name, icon, picture, order, logistic_mode, logistic_slots, trash_slots, ingredients)
  local entity = {
    type = logistic_mode and "logistic-container" or "container",
    name = name,
    icon = icon,
    icon_size = 64,
    flags = { "placeable-player", "player-creation" },
    fast_replaceable_group = "container",
    minable = { mining_time = 0.5, result = name },
    collision_box = { { -0.8, -0.8 }, { 0.8, 0.8 } },
    selection_box = { { -1, -1 }, { 1, 1 } },
    inventory_size = 120,
    max_health = 500,
    corpse = "big-remnants",
    damaged_trigger_effect = hit_effects.entity(),
    resistances = {
      { type = "physical", percent = 30 },
      { type = "fire", percent = 50 },
      { type = "impact", percent = 50 },
    },
    open_sound = sounds.machine_open,
    close_sound = sounds.machine_close,
    picture = {
      filename = picture,
      priority = "extra-high",
      width = 340,
      height = 340,
      scale = 0.25,
    },
    opened_duration = logistic_chest_opened_duration,
    circuit_connector = circuit_connector_definitions["chest"],
    circuit_wire_max_distance = default_circuit_wire_max_distance,
  }

  if logistic_mode then
    entity.logistic_mode = logistic_mode
  end
  if logistic_slots then
    entity.max_logistic_slots = logistic_slots
  end
  if trash_slots then
    entity.trash_inventory_size = trash_slots
  end

  return {
    {
      type = "recipe",
      name = name,
      energy_required = 1,
      enabled = false,
      ingredients = ingredients,
      results = { { type = "item", name = name, amount = 1 } },
    },
    {
      type = "item",
      name = name,
      icon = icon,
      icon_size = 64,
      subgroup = "storage",
      order = order,
      place_result = name,
      stack_size = 50,
    },
    entity,
  }
end

local function make_warehouse(name, icon, picture, order, logistic_mode, logistic_slots, trash_slots, ingredients)
  local entity = {
    type = logistic_mode and "logistic-container" or "container",
    name = name,
    icon = icon,
    icon_size = 64,
    flags = { "placeable-player", "player-creation" },
    fast_replaceable_group = "container",
    minable = { mining_time = 1, result = name },
    collision_box = { { -2.75, -2.75 }, { 2.75, 2.75 } },
    selection_box = { { -3, -3 }, { 3, 3 } },
    inventory_size = 500,
    max_health = 1500,
    corpse = "big-remnants",
    damaged_trigger_effect = hit_effects.entity(),
    resistances = {
      { type = "physical", percent = 50 },
      { type = "fire", percent = 75 },
      { type = "impact", percent = 75 },
    },
    open_sound = sounds.machine_open,
    close_sound = sounds.machine_close,
    water_reflection = warehouse_reflection(),
    opened_duration = logistic_chest_opened_duration,
    circuit_connector = circuit_connector_definitions["chest"],
    circuit_wire_max_distance = 20,
  }

  if logistic_mode then
    entity.logistic_mode = logistic_mode
    entity.animation = {
      filename = picture,
      priority = "extra-high",
      width = 512,
      height = 512,
      frame_count = 6,
      line_length = 3,
      scale = 0.5,
    }
  else
    entity.picture = {
      filename = picture,
      priority = "extra-high",
      width = 512,
      height = 512,
      scale = 0.5,
    }
  end

  if logistic_slots then
    entity.max_logistic_slots = logistic_slots
  end
  if trash_slots then
    entity.trash_inventory_size = trash_slots
  end

  return {
    {
      type = "recipe",
      name = name,
      energy_required = 1,
      enabled = false,
      ingredients = ingredients,
      results = { { type = "item", name = name, amount = 1 } },
    },
    {
      type = "item",
      name = name,
      icon = icon,
      icon_size = 64,
      subgroup = "storage",
      order = order,
      place_result = name,
      stack_size = 50,
    },
    entity,
  }
end

if data.raw.item.pipe then
  data.raw.item.pipe.localised_name = { "item-name.fw-lead-lined-pipe" }
end
if data.raw.pipe.pipe then
  data.raw.pipe.pipe.localised_name = { "entity-name.fw-lead-lined-pipe" }
  if data.raw.pipe.pipe.fluid_box then
    data.raw.pipe.pipe.fluid_box.volume = 120
  end
end
if data.raw.recipe.pipe then
  data.raw.recipe.pipe.localised_name = { "recipe-name.fw-lead-lined-pipe" }
  data.raw.recipe.pipe.ingredients = {
    { type = "item", name = "lead-plate", amount = 1 },
    { type = "item", name = "fw-copper-tube", amount = 1 },
  }
  data.raw.recipe.pipe.results = { { type = "item", name = "pipe", amount = 2 } }
end

if data.raw.item["pipe-to-ground"] then
  data.raw.item["pipe-to-ground"].localised_name = { "item-name.fw-lead-lined-pipe-to-ground" }
end
if data.raw["pipe-to-ground"] and data.raw["pipe-to-ground"]["pipe-to-ground"] then
  data.raw["pipe-to-ground"]["pipe-to-ground"].localised_name = { "entity-name.fw-lead-lined-pipe-to-ground" }
  if data.raw["pipe-to-ground"]["pipe-to-ground"].fluid_box then
    data.raw["pipe-to-ground"]["pipe-to-ground"].fluid_box.volume = 240
  end
end
if data.raw.recipe["pipe-to-ground"] then
  data.raw.recipe["pipe-to-ground"].localised_name = { "recipe-name.fw-lead-lined-pipe-to-ground" }
  data.raw.recipe["pipe-to-ground"].ingredients = {
    { type = "item", name = "pipe", amount = 10 },
    { type = "item", name = "lead-plate", amount = 4 },
    { type = "item", name = "fw-flow-regulator", amount = 1 },
  }
end

local steel_pipe = table.deepcopy(data.raw.pipe.pipe)
steel_pipe.name = "fw-kr-steel-pipe"
steel_pipe.icon = "__Krastorio2Assets__/icons/entities/steel-pipe.png"
steel_pipe.icon_size = 64
steel_pipe.minable = { mining_time = 0.1, result = "fw-kr-steel-pipe" }
steel_pipe.max_health = 200
steel_pipe.icon_draw_specification = { scale = 0.5 }
steel_pipe.localised_name = { "entity-name.fw-kr-steel-pipe" }
steel_pipe.resistances = {
  { type = "fire", percent = 90 },
  { type = "impact", percent = 50 },
}
steel_pipe.working_sound = sounds.pipe
if steel_pipe.fluid_box then
  steel_pipe.fluid_box.volume = 240
end
steel_pipe.pictures = {
  straight_vertical_single = {
    filename = "__Krastorio2Assets__/buildings/steel-pipe/steel-pipe-straight-vertical-single.png",
    priority = "extra-high",
    width = 160,
    height = 160,
    scale = 0.5,
  },
  straight_vertical = {
    filename = "__Krastorio2Assets__/buildings/steel-pipe/steel-pipe-straight-vertical.png",
    priority = "extra-high",
    width = 128,
    height = 128,
    scale = 0.5,
  },
  straight_vertical_window = {
    filename = "__Krastorio2Assets__/buildings/steel-pipe/steel-pipe-straight-vertical-window.png",
    priority = "extra-high",
    width = 128,
    height = 128,
    scale = 0.5,
  },
  straight_horizontal_window = {
    filename = "__Krastorio2Assets__/buildings/steel-pipe/steel-pipe-straight-horizontal-window.png",
    priority = "extra-high",
    width = 128,
    height = 128,
    scale = 0.5,
  },
  straight_horizontal = {
    filename = "__Krastorio2Assets__/buildings/steel-pipe/steel-pipe-straight-horizontal.png",
    priority = "extra-high",
    width = 128,
    height = 128,
    scale = 0.5,
  },
  corner_up_right = {
    filename = "__Krastorio2Assets__/buildings/steel-pipe/steel-pipe-corner-up-right.png",
    priority = "extra-high",
    width = 128,
    height = 128,
    scale = 0.5,
  },
  corner_up_left = {
    filename = "__Krastorio2Assets__/buildings/steel-pipe/steel-pipe-corner-up-left.png",
    priority = "extra-high",
    width = 128,
    height = 128,
    scale = 0.5,
  },
  corner_down_right = {
    filename = "__Krastorio2Assets__/buildings/steel-pipe/steel-pipe-corner-down-right.png",
    priority = "extra-high",
    width = 128,
    height = 128,
    scale = 0.5,
  },
  corner_down_left = {
    filename = "__Krastorio2Assets__/buildings/steel-pipe/steel-pipe-corner-down-left.png",
    priority = "extra-high",
    width = 128,
    height = 128,
    scale = 0.5,
  },
  t_up = {
    filename = "__Krastorio2Assets__/buildings/steel-pipe/steel-pipe-t-up.png",
    priority = "extra-high",
    width = 128,
    height = 128,
    scale = 0.5,
  },
  t_down = {
    filename = "__Krastorio2Assets__/buildings/steel-pipe/steel-pipe-t-down.png",
    priority = "extra-high",
    width = 128,
    height = 128,
    scale = 0.5,
  },
  t_right = {
    filename = "__Krastorio2Assets__/buildings/steel-pipe/steel-pipe-t-right.png",
    priority = "extra-high",
    width = 128,
    height = 128,
    scale = 0.5,
  },
  t_left = {
    filename = "__Krastorio2Assets__/buildings/steel-pipe/steel-pipe-t-left.png",
    priority = "extra-high",
    width = 128,
    height = 128,
    scale = 0.5,
  },
  cross = {
    filename = "__Krastorio2Assets__/buildings/steel-pipe/steel-pipe-cross.png",
    priority = "extra-high",
    width = 128,
    height = 128,
    scale = 0.5,
  },
  ending_up = {
    filename = "__Krastorio2Assets__/buildings/steel-pipe/steel-pipe-ending-up.png",
    priority = "extra-high",
    width = 128,
    height = 128,
    scale = 0.5,
  },
  ending_down = {
    filename = "__Krastorio2Assets__/buildings/steel-pipe/steel-pipe-ending-down.png",
    priority = "extra-high",
    width = 128,
    height = 128,
    scale = 0.5,
  },
  ending_right = {
    filename = "__Krastorio2Assets__/buildings/steel-pipe/steel-pipe-ending-right.png",
    priority = "extra-high",
    width = 128,
    height = 128,
    scale = 0.5,
  },
  ending_left = {
    filename = "__Krastorio2Assets__/buildings/steel-pipe/steel-pipe-ending-left.png",
    priority = "extra-high",
    width = 128,
    height = 128,
    scale = 0.5,
  },
  straight_vertical_single_visualization = data.raw.pipe.pipe.pictures.straight_vertical_single_visualization,
  straight_vertical_visualization = data.raw.pipe.pipe.pictures.straight_vertical_visualization,
  straight_vertical_window_visualization = data.raw.pipe.pipe.pictures.straight_vertical_window_visualization,
  straight_horizontal_window_visualization = data.raw.pipe.pipe.pictures.straight_horizontal_window_visualization,
  straight_horizontal_visualization = data.raw.pipe.pipe.pictures.straight_horizontal_visualization,
  corner_up_right_visualization = data.raw.pipe.pipe.pictures.corner_up_right_visualization,
  corner_up_left_visualization = data.raw.pipe.pipe.pictures.corner_up_left_visualization,
  corner_down_right_visualization = data.raw.pipe.pipe.pictures.corner_down_right_visualization,
  corner_down_left_visualization = data.raw.pipe.pipe.pictures.corner_down_left_visualization,
  t_up_visualization = data.raw.pipe.pipe.pictures.t_up_visualization,
  t_down_visualization = data.raw.pipe.pipe.pictures.t_down_visualization,
  t_right_visualization = data.raw.pipe.pipe.pictures.t_right_visualization,
  t_left_visualization = data.raw.pipe.pipe.pictures.t_left_visualization,
  cross_visualization = data.raw.pipe.pipe.pictures.cross_visualization,
  ending_up_visualization = data.raw.pipe.pipe.pictures.ending_up_visualization,
  ending_down_visualization = data.raw.pipe.pipe.pictures.ending_down_visualization,
  ending_right_visualization = data.raw.pipe.pipe.pictures.ending_right_visualization,
  ending_left_visualization = data.raw.pipe.pipe.pictures.ending_left_visualization,
  straight_vertical_single_disabled_visualization = data.raw.pipe.pipe.pictures.straight_vertical_single_disabled_visualization,
  straight_vertical_disabled_visualization = data.raw.pipe.pipe.pictures.straight_vertical_disabled_visualization,
  straight_vertical_window_disabled_visualization = data.raw.pipe.pipe.pictures.straight_vertical_window_disabled_visualization,
  straight_horizontal_window_disabled_visualization = data.raw.pipe.pipe.pictures.straight_horizontal_window_disabled_visualization,
  straight_horizontal_disabled_visualization = data.raw.pipe.pipe.pictures.straight_horizontal_disabled_visualization,
  corner_up_right_disabled_visualization = data.raw.pipe.pipe.pictures.corner_up_right_disabled_visualization,
  corner_up_left_disabled_visualization = data.raw.pipe.pipe.pictures.corner_up_left_disabled_visualization,
  corner_down_right_disabled_visualization = data.raw.pipe.pipe.pictures.corner_down_right_disabled_visualization,
  corner_down_left_disabled_visualization = data.raw.pipe.pipe.pictures.corner_down_left_disabled_visualization,
  t_up_disabled_visualization = data.raw.pipe.pipe.pictures.t_up_disabled_visualization,
  t_down_disabled_visualization = data.raw.pipe.pipe.pictures.t_down_disabled_visualization,
  t_right_disabled_visualization = data.raw.pipe.pipe.pictures.t_right_disabled_visualization,
  t_left_disabled_visualization = data.raw.pipe.pipe.pictures.t_left_disabled_visualization,
  cross_disabled_visualization = data.raw.pipe.pipe.pictures.cross_disabled_visualization,
  ending_up_disabled_visualization = data.raw.pipe.pipe.pictures.ending_up_disabled_visualization,
  ending_down_disabled_visualization = data.raw.pipe.pipe.pictures.ending_down_disabled_visualization,
  ending_right_disabled_visualization = data.raw.pipe.pipe.pictures.ending_right_disabled_visualization,
  ending_left_disabled_visualization = data.raw.pipe.pipe.pictures.ending_left_disabled_visualization,
  horizontal_window_background = {
    filename = "__Krastorio2Assets__/buildings/steel-pipe/steel-pipe-horizontal-window-background.png",
    priority = "extra-high",
    width = 128,
    height = 128,
    scale = 0.5,
  },
  vertical_window_background = {
    filename = "__Krastorio2Assets__/buildings/steel-pipe/steel-pipe-vertical-window-background.png",
    priority = "extra-high",
    width = 128,
    height = 128,
    scale = 0.5,
  },
  fluid_background = {
    filename = "__base__/graphics/entity/pipe/fluid-background.png",
    priority = "extra-high",
    width = 64,
    height = 40,
    scale = 0.5,
  },
  low_temperature_flow = {
    filename = "__base__/graphics/entity/pipe/fluid-flow-low-temperature.png",
    priority = "extra-high",
    width = 160,
    height = 18,
  },
  middle_temperature_flow = {
    filename = "__base__/graphics/entity/pipe/fluid-flow-medium-temperature.png",
    priority = "extra-high",
    width = 160,
    height = 18,
  },
  high_temperature_flow = {
    filename = "__base__/graphics/entity/pipe/fluid-flow-high-temperature.png",
    priority = "extra-high",
    width = 160,
    height = 18,
  },
  gas_flow = {
    filename = "__base__/graphics/entity/pipe/steam.png",
    priority = "extra-high",
    line_length = 10,
    width = 48,
    height = 30,
    frame_count = 60,
  },
}
steel_pipe.horizontal_window_bounding_box = { { -0.25, -0.28125 }, { 0.25, 0.15625 } }
steel_pipe.vertical_window_bounding_box = { { -0.28125, -0.5 }, { 0.03125, 0.125 } }

local steel_pipe_to_ground = table.deepcopy(data.raw["pipe-to-ground"]["pipe-to-ground"])
steel_pipe_to_ground.name = "fw-kr-steel-pipe-to-ground"
steel_pipe_to_ground.icon = "__Krastorio2Assets__/icons/entities/steel-pipe-to-ground.png"
steel_pipe_to_ground.icon_size = 64
steel_pipe_to_ground.minable = { mining_time = 0.1, result = "fw-kr-steel-pipe-to-ground" }
steel_pipe_to_ground.max_health = 150
steel_pipe_to_ground.icon_draw_specification = { scale = 0.5 }
steel_pipe_to_ground.localised_name = { "entity-name.fw-kr-steel-pipe-to-ground" }
steel_pipe_to_ground.resistances = {
  { type = "fire", percent = 90 },
  { type = "impact", percent = 60 },
}
steel_pipe_to_ground.working_sound = sounds.pipe
steel_pipe_to_ground.fluid_box.pipe_connections[2].max_underground_distance = 30
steel_pipe_to_ground.fluid_box.volume = 480
steel_pipe_to_ground.pictures = {
  north = {
    filename = "__Krastorio2Assets__/buildings/steel-pipe-to-ground/steel-pipe-to-ground-up.png",
    priority = "extra-high",
    width = 128,
    height = 128,
    scale = 0.5,
  },
  south = {
    filename = "__Krastorio2Assets__/buildings/steel-pipe-to-ground/steel-pipe-to-ground-down.png",
    priority = "extra-high",
    width = 128,
    height = 128,
    scale = 0.5,
  },
  west = {
    filename = "__Krastorio2Assets__/buildings/steel-pipe-to-ground/steel-pipe-to-ground-left.png",
    priority = "extra-high",
    width = 128,
    height = 128,
    scale = 0.5,
  },
  east = {
    filename = "__Krastorio2Assets__/buildings/steel-pipe-to-ground/steel-pipe-to-ground-right.png",
    priority = "extra-high",
    width = 128,
    height = 128,
    scale = 0.5,
  },
}

local steel_pump = table.deepcopy(data.raw.pump.pump)
steel_pump.name = "fw-kr-steel-pump"
steel_pump.icon = "__Krastorio2Assets__/icons/entities/steel-pump.png"
steel_pump.icon_size = 64
steel_pump.icon_draw_specification = { scale = 0.5 }
steel_pump.minable = { mining_time = 0.2, result = "fw-kr-steel-pump" }
steel_pump.fast_replaceable_group = "pump"
steel_pump.localised_name = { "entity-name.fw-kr-steel-pump" }
steel_pump.max_health = 180
steel_pump.pumping_speed = 50
steel_pump.energy_usage = "50kW"
steel_pump.resistances = {
  { type = "fire", percent = 80 },
  { type = "impact", percent = 30 },
}
steel_pump.fluid_box.pipe_covers = pipecoverspictures()
steel_pump.animations = {
  north = {
    layers = {
      {
        filename = "__Krastorio2Assets__/buildings/steel-pipe-covers/steel-pipe-cover-north.png",
        priority = "extra-high",
        width = 128,
        height = 128,
        scale = 0.5,
        shift = { 0, -1.5 },
        repeat_count = 32,
        animation_speed = 0.5,
      },
      {
        filename = "__base__/graphics/entity/pipe-covers/pipe-cover-north-shadow.png",
        priority = "extra-high",
        width = 128,
        height = 128,
        scale = 0.5,
        draw_as_shadow = true,
        shift = { 0, -1.5 },
        repeat_count = 32,
      },
      {
        filename = "__Krastorio2Assets__/buildings/steel-pump/steel-pump-north.png",
        width = 103,
        height = 164,
        scale = 0.5,
        line_length = 8,
        frame_count = 32,
        shift = util.by_pixel(8, 3.5),
      },
    },
  },
  east = {
    filename = "__Krastorio2Assets__/buildings/steel-pump/steel-pump-east.png",
    width = 130,
    height = 109,
    scale = 0.5,
    line_length = 8,
    frame_count = 32,
    animation_speed = 0.5,
    shift = util.by_pixel(-0.5, 1.75),
  },
  south = {
    layers = {
      {
        filename = "__Krastorio2Assets__/buildings/steel-pipe-covers/steel-pipe-cover-north.png",
        priority = "extra-high",
        width = 128,
        height = 128,
        scale = 0.5,
        shift = { 0, -1.5 },
        repeat_count = 32,
        animation_speed = 0.5,
      },
      {
        filename = "__base__/graphics/entity/pipe-covers/pipe-cover-north-shadow.png",
        priority = "extra-high",
        width = 128,
        height = 128,
        scale = 0.5,
        draw_as_shadow = true,
        shift = { 0, -1.5 },
        repeat_count = 32,
      },
      {
        filename = "__Krastorio2Assets__/buildings/steel-pump/steel-pump-south.png",
        width = 114,
        height = 160,
        scale = 0.5,
        line_length = 8,
        frame_count = 32,
        shift = util.by_pixel(12.5, -8),
      },
    },
  },
  west = {
    filename = "__Krastorio2Assets__/buildings/steel-pump/steel-pump-west.png",
    width = 131,
    height = 111,
    scale = 0.5,
    line_length = 8,
    frame_count = 32,
    animation_speed = 0.5,
    shift = util.by_pixel(-0.25, 1.25),
  },
}

data:extend(make_loader(
  "fw-kr-loader",
  "transport-belt",
  "__Krastorio2Assets__/icons/entities/loader.png",
  { 249, 207, 70 },
  {
    { type = "item", name = "transport-belt", amount = 1 },
    { type = "item", name = "fw-loader-frame", amount = 1 },
    { type = "item", name = "electronic-circuit", amount = 2 },
  },
  "d[loader]-a1[fw-kr-loader]",
  "fw-kr-fast-loader",
  "400W"
))

data:extend(make_loader(
  "fw-kr-fast-loader",
  "fast-transport-belt",
  "__Krastorio2Assets__/icons/entities/fast-loader.png",
  { 228, 24, 38 },
  {
    { type = "item", name = "fast-transport-belt", amount = 1 },
    { type = "item", name = "fw-kr-loader", amount = 1 },
    { type = "item", name = "fw-loader-frame", amount = 1 },
    { type = "item", name = "electronic-circuit", amount = 4 },
    { type = "item", name = "fw-cable-harness", amount = 1 },
  },
  "d[loader]-a2[fw-kr-fast-loader]",
  "fw-kr-express-loader",
  "500W"
))

data:extend(make_loader(
  "fw-kr-express-loader",
  "express-transport-belt",
  "__Krastorio2Assets__/icons/entities/express-loader.png",
  { 90, 190, 220 },
  {
    { type = "item", name = "express-transport-belt", amount = 1 },
    { type = "item", name = "fw-kr-fast-loader", amount = 1 },
    { type = "item", name = "fw-loader-frame", amount = 2 },
    { type = "item", name = "advanced-circuit", amount = 4 },
    { type = "item", name = "fw-logistic-relay", amount = 1 },
    { type = "item", name = "fw-cable-harness", amount = 2 },
  },
  "d[loader]-a3[fw-kr-express-loader]",
  nil,
  "500W"
))

data:extend(make_loader(
  "fw-kr-advanced-loader",
  "turbo-transport-belt",
  "__Krastorio2Assets__/icons/entities/advanced-loader.png",
  { 76, 232, 48 },
  {
    { type = "item", name = "turbo-transport-belt", amount = 1 },
    { type = "item", name = "fw-kr-express-loader", amount = 1 },
    { type = "item", name = "fw-loader-frame", amount = 2 },
    { type = "item", name = "tungsten-plate", amount = 8 },
    { type = "item", name = "processing-unit", amount = 4 },
    { type = "item", name = "fw-bulk-router", amount = 1 },
    { type = "item", name = "fw-sensor-package", amount = 1 },
  },
  "d[loader]-a4[fw-kr-advanced-loader]",
  nil,
  "1kW"
))

data:extend({
  {
    type = "recipe",
    name = "fw-kr-steel-pipe",
    enabled = false,
    ingredients = {
      { type = "item", name = "pipe", amount = 2 },
      { type = "item", name = "steel-plate", amount = 1 },
      { type = "item", name = "fw-steel-beam", amount = 1 },
    },
    results = { { type = "item", name = "fw-kr-steel-pipe", amount = 2 } },
  },
  {
    type = "item",
    name = "fw-kr-steel-pipe",
    icon = "__Krastorio2Assets__/icons/entities/steel-pipe.png",
    icon_size = 64,
    localised_name = { "item-name.fw-kr-steel-pipe" },
    subgroup = "energy-pipe-distribution",
    order = "a[pipe]-aa[fw-kr-steel-pipe]",
    place_result = "fw-kr-steel-pipe",
    stack_size = 50,
  },
  steel_pipe,
  {
    type = "recipe",
    name = "fw-kr-steel-pipe-to-ground",
    enabled = false,
    ingredients = {
      { type = "item", name = "fw-kr-steel-pipe", amount = 10 },
      { type = "item", name = "fw-steel-beam", amount = 2 },
      { type = "item", name = "fw-flow-regulator", amount = 1 },
    },
    results = { { type = "item", name = "fw-kr-steel-pipe-to-ground", amount = 2 } },
  },
  {
    type = "item",
    name = "fw-kr-steel-pipe-to-ground",
    icon = "__Krastorio2Assets__/icons/entities/steel-pipe-to-ground.png",
    icon_size = 64,
    localised_name = { "item-name.fw-kr-steel-pipe-to-ground" },
    subgroup = "energy-pipe-distribution",
    order = "a[pipe]-ba[fw-kr-steel-pipe-to-ground]",
    place_result = "fw-kr-steel-pipe-to-ground",
    stack_size = 50,
  },
  steel_pipe_to_ground,
  {
    type = "recipe",
    name = "fw-kr-steel-pump",
    energy_required = 2,
    enabled = false,
    ingredients = {
      { type = "item", name = "fw-bearing", amount = 2 },
      { type = "item", name = "engine-unit", amount = 1 },
      { type = "item", name = "fw-pressure-vessel", amount = 1 },
      { type = "item", name = "fw-kr-steel-pipe", amount = 2 },
      { type = "item", name = "fw-flow-regulator", amount = 1 },
    },
    results = { { type = "item", name = "fw-kr-steel-pump", amount = 1 } },
  },
  {
    type = "item",
    name = "fw-kr-steel-pump",
    icon = "__Krastorio2Assets__/icons/entities/steel-pump.png",
    icon_size = 64,
    localised_name = { "item-name.fw-kr-steel-pump" },
    subgroup = "energy-pipe-distribution",
    order = "b[pipe]-ca[fw-kr-steel-pump]",
    place_result = "fw-kr-steel-pump",
    stack_size = 50,
  },
  steel_pump,
  {
    type = "recipe",
    name = "fw-kr-big-storage-tank",
    energy_required = 5,
    enabled = false,
    ingredients = {
      { type = "item", name = "fw-steel-beam", amount = 8 },
      { type = "item", name = "steel-plate", amount = 16 },
      { type = "item", name = "fw-pressure-vessel", amount = 2 },
      { type = "item", name = "fw-kr-steel-pipe", amount = 4 },
      { type = "item", name = "fw-flow-regulator", amount = 2 },
    },
    results = { { type = "item", name = "fw-kr-big-storage-tank", amount = 1 } },
  },
  {
    type = "item",
    name = "fw-kr-big-storage-tank",
    icon = "__Krastorio2Assets__/icons/entities/big-storage-tank.png",
    icon_size = 64,
    localised_name = { "item-name.fw-kr-big-storage-tank" },
    subgroup = "storage",
    order = "b[fluid]-bb2[fw-kr-big-storage-tank]",
    place_result = "fw-kr-big-storage-tank",
    stack_size = 50,
  },
  {
    type = "storage-tank",
    name = "fw-kr-big-storage-tank",
    icon = "__Krastorio2Assets__/icons/entities/big-storage-tank.png",
    icon_size = 64,
    localised_name = { "entity-name.fw-kr-big-storage-tank" },
    flags = { "placeable-player", "player-creation" },
    minable = { mining_time = 0.5, result = "fw-kr-big-storage-tank" },
    collision_box = { { -1.25, -1.25 }, { 1.25, 1.25 } },
    selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
    flow_length_in_ticks = 360,
    fluid_box = {
      volume = 50000,
      pipe_covers = pipecoverspictures(),
      pipe_connections = {
        { flow_direction = "input-output", direction = defines.direction.west, position = { -1, 0 } },
        { flow_direction = "input-output", direction = defines.direction.north, position = { 0, -1 } },
        { flow_direction = "input-output", direction = defines.direction.east, position = { 1, 0 } },
        { flow_direction = "input-output", direction = defines.direction.south, position = { 0, 1 } },
      },
    },
    max_health = 750,
    corpse = "big-remnants",
    resistances = {
      { type = "physical", percent = 35 },
      { type = "fire", percent = 75 },
      { type = "impact", percent = 50 },
    },
    working_sound = {
      sound = { filename = "__base__/sound/storage-tank.ogg", volume = 0.5 },
      max_sounds_per_prototype = 3,
    },
    pictures = {
      picture = {
        sheets = {
          {
            filename = "__Krastorio2Assets__/buildings/big-storage-tank/big-storage-tank.png",
            priority = "extra-high",
            frames = 1,
            scale = 0.5,
            width = 256,
            height = 256,
          },
          {
            filename = "__Krastorio2Assets__/buildings/big-storage-tank/big-storage-tank-sh.png",
            priority = "extra-high",
            frames = 1,
            scale = 0.5,
            width = 256,
            height = 256,
            shift = { 0.152, 0 },
            draw_as_shadow = true,
          },
        },
      },
      fluid_background = {
        filename = "__base__/graphics/entity/storage-tank/fluid-background.png",
        priority = "extra-high",
        width = 32,
        height = 15,
      },
      window_background = {
        filename = "__base__/graphics/entity/storage-tank/window-background.png",
        priority = "extra-high",
        width = 17,
        height = 24,
      },
      flow_sprite = {
        filename = "__base__/graphics/entity/pipe/fluid-flow-low-temperature.png",
        priority = "extra-high",
        width = 160,
        height = 20,
      },
      gas_flow = {
        filename = "__base__/graphics/entity/pipe/steam.png",
        priority = "extra-high",
        line_length = 10,
        width = 48,
        height = 30,
        frame_count = 60,
        animation_speed = 0.25,
      },
    },
    window_bounding_box = { { -0.125, 0.6875 }, { 0.1875, 1.1875 } },
    water_reflection = {
      pictures = {
        filename = "__Krastorio2Assets__/buildings/big-storage-tank/big-storage-tank-reflection.png",
        priority = "extra-high",
        width = 40,
        height = 35,
        shift = util.by_pixel(0, 40),
        variation_count = 1,
        scale = 5,
      },
      rotate = false,
      orientation_to_variation = false,
    },
    circuit_connector = circuit_connector_definitions["storage-tank"],
    circuit_wire_max_distance = default_circuit_wire_max_distance,
  },
  {
    type = "recipe",
    name = "fw-kr-huge-storage-tank",
    energy_required = 10,
    enabled = false,
    ingredients = {
      { type = "item", name = "fw-kr-big-storage-tank", amount = 2 },
      { type = "item", name = "fw-steel-beam", amount = 12 },
      { type = "item", name = "steel-plate", amount = 30 },
      { type = "item", name = "fw-pressure-vessel", amount = 4 },
      { type = "item", name = "fw-kr-steel-pipe", amount = 8 },
      { type = "item", name = "concrete", amount = 20 },
      { type = "item", name = "fw-hydraulic-manifold", amount = 2 },
    },
    results = { { type = "item", name = "fw-kr-huge-storage-tank", amount = 1 } },
  },
  {
    type = "item",
    name = "fw-kr-huge-storage-tank",
    icon = "__Krastorio2Assets__/icons/entities/huge-storage-tank.png",
    icon_size = 64,
    localised_name = { "item-name.fw-kr-huge-storage-tank" },
    subgroup = "storage",
    order = "b[fluid]-c[fw-kr-huge-storage-tank]",
    place_result = "fw-kr-huge-storage-tank",
    stack_size = 50,
  },
  {
    type = "storage-tank",
    name = "fw-kr-huge-storage-tank",
    icon = "__Krastorio2Assets__/icons/entities/huge-storage-tank.png",
    icon_size = 64,
    localised_name = { "entity-name.fw-kr-huge-storage-tank" },
    flags = { "placeable-player", "player-creation" },
    minable = { mining_time = 1, result = "fw-kr-huge-storage-tank" },
    collision_box = { { -2.35, -2.35 }, { 2.35, 2.35 } },
    selection_box = { { -2.5, -2.5 }, { 2.5, 2.5 } },
    flow_length_in_ticks = 360,
    fluid_box = {
      volume = 200000,
      pipe_covers = pipecoverspictures(),
      pipe_connections = {
        { flow_direction = "input-output", direction = defines.direction.west, position = { -2, -1 } },
        { flow_direction = "input-output", direction = defines.direction.west, position = { -2, 0 } },
        { flow_direction = "input-output", direction = defines.direction.west, position = { -2, 1 } },
        { flow_direction = "input-output", direction = defines.direction.north, position = { -1, -2 } },
        { flow_direction = "input-output", direction = defines.direction.north, position = { 0, -2 } },
        { flow_direction = "input-output", direction = defines.direction.north, position = { 1, -2 } },
        { flow_direction = "input-output", direction = defines.direction.east, position = { 2, -1 } },
        { flow_direction = "input-output", direction = defines.direction.east, position = { 2, 0 } },
        { flow_direction = "input-output", direction = defines.direction.east, position = { 2, 1 } },
        { flow_direction = "input-output", direction = defines.direction.south, position = { -1, 2 } },
        { flow_direction = "input-output", direction = defines.direction.south, position = { 0, 2 } },
        { flow_direction = "input-output", direction = defines.direction.south, position = { 1, 2 } },
      },
    },
    max_health = 2000,
    corpse = "big-remnants",
    resistances = {
      { type = "physical", percent = 50 },
      { type = "fire", percent = 80 },
      { type = "impact", percent = 80 },
    },
    working_sound = {
      sound = { filename = "__base__/sound/storage-tank.ogg", volume = 0.5 },
      max_sounds_per_prototype = 3,
    },
    pictures = {
      picture = {
        sheets = {
          {
            filename = "__Krastorio2Assets__/buildings/huge-storage-tank/huge-storage-tank.png",
            priority = "extra-high",
            frames = 1,
            scale = 0.5,
            width = 426,
            height = 426,
          },
          {
            filename = "__Krastorio2Assets__/buildings/huge-storage-tank/huge-storage-tank-sh.png",
            priority = "extra-high",
            frames = 1,
            scale = 0.5,
            width = 426,
            height = 426,
            draw_as_shadow = true,
          },
        },
      },
      fluid_background = {
        filename = "__base__/graphics/entity/storage-tank/fluid-background.png",
        priority = "extra-high",
        width = 32,
        height = 15,
      },
      window_background = {
        filename = "__base__/graphics/entity/storage-tank/window-background.png",
        priority = "extra-high",
        width = 17,
        height = 24,
      },
      flow_sprite = {
        filename = "__base__/graphics/entity/pipe/fluid-flow-low-temperature.png",
        priority = "extra-high",
        width = 160,
        height = 20,
      },
      gas_flow = {
        filename = "__base__/graphics/entity/pipe/steam.png",
        priority = "extra-high",
        line_length = 10,
        width = 48,
        height = 30,
        frame_count = 60,
        animation_speed = 0.25,
      },
    },
    window_bounding_box = { { -0.125, 0.6875 }, { 0.1875, 1.1875 } },
    water_reflection = {
      pictures = {
        filename = "__Krastorio2Assets__/buildings/huge-storage-tank/huge-storage-tank-reflection.png",
        priority = "extra-high",
        width = 52,
        height = 48,
        shift = util.by_pixel(0, 40),
        variation_count = 1,
        scale = 5,
      },
      rotate = false,
      orientation_to_variation = false,
    },
    circuit_connector = circuit_connector_definitions["storage-tank"],
    circuit_wire_max_distance = 20,
  },
})

data:extend(make_strongbox(
  "fw-kr-strongbox",
  "__Krastorio2Assets__/icons/entities/strongbox.png",
  "__Krastorio2Assets__/buildings/strongbox/strongbox.png",
  "a[items]-a[fw-kr-strongbox]",
  nil,
  nil,
  nil,
  {
    { type = "item", name = "steel-chest", amount = 2 },
    { type = "item", name = "fw-steel-beam", amount = 2 },
    { type = "item", name = "fw-metal-mesh", amount = 2 },
    { type = "item", name = "fw-loader-frame", amount = 1 },
  }
))

data:extend(make_strongbox(
  "fw-kr-passive-provider-strongbox",
  "__Krastorio2Assets__/icons/entities/passive-provider-strongbox.png",
  "__Krastorio2Assets__/buildings/passive-provider-strongbox/passive-provider-strongbox.png",
  "a[items]-b[fw-kr-passive-provider-strongbox]",
  "passive-provider",
  nil,
  nil,
  {
    { type = "item", name = "fw-kr-strongbox", amount = 1 },
    { type = "item", name = "advanced-circuit", amount = 5 },
    { type = "item", name = "fw-logistic-relay", amount = 1 },
  }
))

data:extend(make_strongbox(
  "fw-kr-active-provider-strongbox",
  "__Krastorio2Assets__/icons/entities/active-provider-strongbox.png",
  "__Krastorio2Assets__/buildings/active-provider-strongbox/active-provider-strongbox.png",
  "a[items]-c[fw-kr-active-provider-strongbox]",
  "active-provider",
  nil,
  nil,
  {
    { type = "item", name = "fw-kr-strongbox", amount = 1 },
    { type = "item", name = "processing-unit", amount = 2 },
    { type = "item", name = "fw-bulk-router", amount = 1 },
  }
))

data:extend(make_strongbox(
  "fw-kr-buffer-strongbox",
  "__Krastorio2Assets__/icons/entities/buffer-strongbox.png",
  "__Krastorio2Assets__/buildings/buffer-strongbox/buffer-strongbox.png",
  "a[items]-d[fw-kr-buffer-strongbox]",
  "buffer",
  nil,
  20,
  {
    { type = "item", name = "fw-kr-strongbox", amount = 1 },
    { type = "item", name = "processing-unit", amount = 2 },
    { type = "item", name = "fw-bulk-router", amount = 1 },
  }
))

data:extend(make_strongbox(
  "fw-kr-storage-strongbox",
  "__Krastorio2Assets__/icons/entities/storage-strongbox.png",
  "__Krastorio2Assets__/buildings/storage-strongbox/storage-strongbox.png",
  "a[items]-e[fw-kr-storage-strongbox]",
  "storage",
  1,
  nil,
  {
    { type = "item", name = "fw-kr-strongbox", amount = 1 },
    { type = "item", name = "advanced-circuit", amount = 4 },
    { type = "item", name = "fw-logistic-relay", amount = 1 },
  }
))

data:extend(make_strongbox(
  "fw-kr-requester-strongbox",
  "__Krastorio2Assets__/icons/entities/requester-strongbox.png",
  "__Krastorio2Assets__/buildings/requester-strongbox/requester-strongbox.png",
  "a[items]-f[fw-kr-requester-strongbox]",
  "requester",
  nil,
  20,
  {
    { type = "item", name = "fw-kr-strongbox", amount = 1 },
    { type = "item", name = "advanced-circuit", amount = 4 },
    { type = "item", name = "fw-bulk-router", amount = 1 },
  }
))

data:extend(make_warehouse(
  "fw-kr-warehouse",
  "__Krastorio2Assets__/icons/entities/warehouse.png",
  "__Krastorio2Assets__/buildings/warehouse/warehouse.png",
  "a[items]-e[fw-kr-warehouse]",
  nil,
  nil,
  nil,
  {
    { type = "item", name = "fw-kr-strongbox", amount = 4 },
    { type = "item", name = "fw-steel-beam", amount = 10 },
    { type = "item", name = "steel-plate", amount = 12 },
    { type = "item", name = "fw-composite-panel", amount = 4 },
    { type = "item", name = "fw-metal-mesh", amount = 6 },
    { type = "item", name = "fw-loader-frame", amount = 4 },
  }
))

data:extend(make_warehouse(
  "fw-kr-passive-provider-warehouse",
  "__Krastorio2Assets__/icons/entities/passive-provider-warehouse.png",
  "__Krastorio2Assets__/buildings/passive-provider-warehouse/passive-provider-warehouse.png",
  "a[items]-f[fw-kr-passive-provider-warehouse]",
  "passive-provider",
  nil,
  nil,
  {
    { type = "item", name = "fw-kr-warehouse", amount = 1 },
    { type = "item", name = "advanced-circuit", amount = 20 },
    { type = "item", name = "fw-logistic-relay", amount = 2 },
  }
))

data:extend(make_warehouse(
  "fw-kr-active-provider-warehouse",
  "__Krastorio2Assets__/icons/entities/active-provider-warehouse.png",
  "__Krastorio2Assets__/buildings/active-provider-warehouse/active-provider-warehouse.png",
  "a[items]-g[fw-kr-active-provider-warehouse]",
  "active-provider",
  nil,
  nil,
  {
    { type = "item", name = "fw-kr-warehouse", amount = 1 },
    { type = "item", name = "processing-unit", amount = 8 },
    { type = "item", name = "fw-bulk-router", amount = 2 },
  }
))

data:extend(make_warehouse(
  "fw-kr-buffer-warehouse",
  "__Krastorio2Assets__/icons/entities/buffer-warehouse.png",
  "__Krastorio2Assets__/buildings/buffer-warehouse/buffer-warehouse.png",
  "a[items]-h[fw-kr-buffer-warehouse]",
  "buffer",
  nil,
  20,
  {
    { type = "item", name = "fw-kr-warehouse", amount = 1 },
    { type = "item", name = "processing-unit", amount = 8 },
    { type = "item", name = "fw-bulk-router", amount = 2 },
  }
))

data:extend(make_warehouse(
  "fw-kr-storage-warehouse",
  "__Krastorio2Assets__/icons/entities/storage-warehouse.png",
  "__Krastorio2Assets__/buildings/storage-warehouse/storage-warehouse.png",
  "a[items]-i[fw-kr-storage-warehouse]",
  "storage",
  1,
  nil,
  {
    { type = "item", name = "fw-kr-warehouse", amount = 1 },
    { type = "item", name = "advanced-circuit", amount = 16 },
    { type = "item", name = "fw-logistic-relay", amount = 2 },
  }
))

data:extend(make_warehouse(
  "fw-kr-requester-warehouse",
  "__Krastorio2Assets__/icons/entities/requester-warehouse.png",
  "__Krastorio2Assets__/buildings/requester-warehouse/requester-warehouse.png",
  "a[items]-j[fw-kr-requester-warehouse]",
  "requester",
  nil,
  20,
  {
    { type = "item", name = "fw-kr-warehouse", amount = 1 },
    { type = "item", name = "advanced-circuit", amount = 16 },
    { type = "item", name = "fw-bulk-router", amount = 2 },
  }
))
