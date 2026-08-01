local base_tile_sounds = require("__base__/prototypes/tile/tile-sounds")

local icon_path = "__FluxWorksAssets__/graphics/icons/fluids/"
local SHARED_CONTROL = "fw_shattered_flux_vents"

local vents = {
  {
    name = "fw-shattered-yellow-flux-vent",
    tile = "fw-shattered-yellow-land",
    probability = "fw_shattered_yellow_vent_probability",
    richness = "fw_shattered_yellow_vent_richness",
    fluid = "fw-yellow-flux",
    icon = icon_path .. "flux-yellow.png",
    map_color = { 0.96, 0.85, 0.29 },
    gas_outer_tint = { r = 0.96, g = 0.85, b = 0.29, a = 0.35 },
    gas_inner_tint = { r = 1.00, g = 0.96, b = 0.58, a = 0.55 },
    order = "a",
  },
  {
    name = "fw-shattered-red-flux-vent",
    tile = "fw-shattered-red-land",
    probability = "fw_shattered_red_vent_probability",
    richness = "fw_shattered_red_vent_richness",
    fluid = "fw-red-flux",
    icon = icon_path .. "flux-red.png",
    map_color = { 0.88, 0.29, 0.22 },
    gas_outer_tint = { r = 0.90, g = 0.30, b = 0.22, a = 0.35 },
    gas_inner_tint = { r = 1.00, g = 0.56, b = 0.42, a = 0.55 },
    order = "b",
  },
  {
    name = "fw-shattered-green-flux-vent",
    tile = "fw-shattered-green-land",
    probability = "fw_shattered_green_vent_probability",
    richness = "fw_shattered_green_vent_richness",
    fluid = "fw-green-flux",
    icon = icon_path .. "flux-green.png",
    map_color = { 0.36, 0.86, 0.31 },
    gas_outer_tint = { r = 0.36, g = 0.86, b = 0.31, a = 0.35 },
    gas_inner_tint = { r = 0.68, g = 1.00, b = 0.58, a = 0.55 },
    order = "c",
  },
  {
    name = "fw-shattered-purple-flux-vent",
    tile = "fw-shattered-purple-land",
    probability = "fw_shattered_purple_vent_probability",
    richness = "fw_shattered_purple_vent_richness",
    fluid = "fw-purple-flux",
    icon = icon_path .. "flux-purple.png",
    map_color = { 0.68, 0.49, 0.95 },
    gas_outer_tint = { r = 0.68, g = 0.49, b = 0.95, a = 0.35 },
    gas_inner_tint = { r = 0.90, g = 0.74, b = 1.00, a = 0.55 },
    order = "d",
  },
}

local function make_vent(def)
  return {
    type = "resource",
    name = def.name,
    icon = def.icon,
    icon_size = 256,
    flags = { "placeable-neutral" },
    category = "basic-fluid",
    subgroup = "mineable-fluids",
    order = "z[flux-vent]-" .. def.order,
    infinite = true,
    highlight = true,
    minimum = 20000,
    normal = 100000,
    infinite_depletion_amount = 10,
    resource_patch_search_radius = 16,
    tree_removal_probability = 0.0,
    tree_removal_max_distance = 0,
    draw_stateless_visualisation_under_building = false,
    minable = {
      mining_time = 1,
      results = {
        {
          type = "fluid",
          name = def.fluid,
          amount_min = 1,
          amount_max = 1,
          probability = 1,
        },
      },
    },
    walking_sound = base_tile_sounds.walking.oil({}),
    collision_box = { { -1.4, -1.4 }, { 1.4, 1.4 } },
    selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
    autoplace = {
      control = SHARED_CONTROL,
      order = "z[flux-vent]-" .. def.order,
      probability_expression = def.probability,
      richness_expression = def.richness,
      tile_restriction = { def.tile },
    },
    stage_counts = { 0 },
    stages = {
      layers = {
        util.sprite_load("__space-age__/graphics/entity/sulfuric-acid-geyser/sulfuric-acid-geyser", {
          priority = "high",
          frame_count = 4,
          scale = 0.5,
        }),
      },
    },
    stateless_visualisation = {
      {
        count = 1,
        render_layer = "smoke",
        animation = {
          filename = "__space-age__/graphics/entity/sulfuric-acid-geyser/sulfuric-acid-geyser-gas-outer.png",
          frame_count = 47,
          line_length = 16,
          width = 90,
          height = 188,
          animation_speed = 0.3,
          shift = util.by_pixel(-6, -89),
          scale = 1,
          tint = def.gas_outer_tint,
        },
      },
      {
        count = 1,
        render_layer = "smoke",
        animation = {
          filename = "__space-age__/graphics/entity/sulfuric-acid-geyser/sulfuric-acid-geyser-gas-inner.png",
          frame_count = 47,
          line_length = 16,
          width = 40,
          height = 84,
          animation_speed = 0.4,
          shift = util.by_pixel(-4, -30),
          scale = 1,
          tint = def.gas_inner_tint,
        },
      },
    },
    map_color = def.map_color,
    map_grid = false,
  }
end

local prototypes = {
  {
    type = "autoplace-control",
    category = "resource",
    name = SHARED_CONTROL,
    richness = true,
    order = "z-a[shattered-flux-vents]",
    localised_name = {
      "",
      "[entity=fw-shattered-yellow-flux-vent] ",
      "[entity=fw-shattered-red-flux-vent] ",
      "[entity=fw-shattered-green-flux-vent] ",
      "[entity=fw-shattered-purple-flux-vent] ",
      { "autoplace-control-names." .. SHARED_CONTROL },
    },
  },
}

for _, def in ipairs(vents) do
  prototypes[#prototypes + 1] = make_vent(def)
end

data:extend(prototypes)
