local util = require("util")
local atom_forge_path = "__finely-crafted-graphics__/graphics/atom-forge/"

local function make_shadow_layer(path, width, height, repeat_count, animation_speed, shift, scale)
  return {
    filename = path,
    priority = "high",
    width = width,
    height = height,
    frame_count = 1,
    line_length = 1,
    repeat_count = repeat_count,
    animation_speed = animation_speed,
    shift = shift,
    draw_as_shadow = true,
    scale = scale,
  }
end

local function make_striped_layer(prefix, file_defs, opts)
  local stripes = {}
  for _, file_def in ipairs(file_defs) do
    stripes[#stripes + 1] = {
      filename = prefix .. file_def.name,
      width_in_frames = file_def.width_in_frames,
      height_in_frames = file_def.height_in_frames,
    }
  end

  return {
    priority = "high",
    width = opts.width,
    height = opts.height,
    frame_count = opts.frame_count,
    lines_per_file = opts.lines_per_file,
    animation_speed = opts.animation_speed,
    shift = opts.shift,
    scale = opts.scale,
    stripes = stripes,
  }
end

local function make_glow_layer(base_layer, prefix, file_defs)
  local glow = table.deepcopy(base_layer)
  glow.draw_as_glow = true
  glow.blend_mode = "additive"
  glow.stripes = {}

  for _, file_def in ipairs(file_defs) do
    glow.stripes[#glow.stripes + 1] = {
      filename = prefix .. file_def.name,
      width_in_frames = file_def.width_in_frames,
      height_in_frames = file_def.height_in_frames,
    }
  end

  return glow
end

local atomic_enricher = table.deepcopy(data.raw["assembling-machine"]["centrifuge"])
atomic_enricher.name = "fw-atomic-enricher"
atomic_enricher.icon = atom_forge_path .. "atom-forge-icon.png"
atomic_enricher.icon_size = 64
atomic_enricher.minable = { mining_time = 0.8, result = "fw-atomic-enricher" }
atomic_enricher.max_health = 600
atomic_enricher.collision_box = { { -2.35, -2.35 }, { 2.35, 2.35 } }
atomic_enricher.selection_box = { { -2.5, -2.5 }, { 2.5, 2.5 } }
atomic_enricher.crafting_categories = { "fw-atomic-enrichment" }
atomic_enricher.crafting_speed = 3.4
atomic_enricher.energy_usage = "6.5MW"
atomic_enricher.energy_source = {
  type = "electric",
  usage_priority = "secondary-input",
  emissions_per_minute = { pollution = 4 },
  drain = "280kW",
}
atomic_enricher.module_slots = 6
atomic_enricher.allowed_effects = { "consumption", "speed", "productivity", "pollution", "quality" }

do
  local prefix = atom_forge_path
  local shift = util.by_pixel(0, -16)
  local base = make_striped_layer(prefix, {
    { name = "atom-forge-hr-animation-1.png", width_in_frames = 8, height_in_frames = 8 },
    { name = "atom-forge-hr-animation-2.png", width_in_frames = 8, height_in_frames = 2 },
  }, {
    width = 400,
    height = 480,
    frame_count = 80,
    lines_per_file = 8,
    animation_speed = 0.15,
    shift = shift,
    scale = 0.5,
  })
  local glow = make_glow_layer(base, prefix, {
    { name = "atom-forge-hr-emission-1.png", width_in_frames = 8, height_in_frames = 8 },
    { name = "atom-forge-hr-emission-2.png", width_in_frames = 8, height_in_frames = 2 },
  })

  atomic_enricher.graphics_set = {
    animation = {
      layers = {
        make_shadow_layer(prefix .. "atom-forge-hr-shadow.png", 900, 500, 80, 0.15, shift, 0.5),
        base,
      },
    },
    working_visualisations = {
      {
        fadeout = true,
        animation = {
          layers = {
            base,
            glow,
          },
        },
      },
    },
  }
end

atomic_enricher.working_sound = {
  sound = { filename = "__base__/sound/nuclear-reactor-1.ogg", volume = 0.65 },
  apparent_volume = 0.3,
}

data:extend({
  atomic_enricher,
})
