local resource_autoplace = require("__core__.lualib.resource-autoplace")
local Common = require("__haul_lib__/utils/common")

-- If KR quarry exists, use it so this patch works with quarry drills.
local mining_category = "basic-solid"
if data.raw["resource-category"] and data.raw["resource-category"]["kr-quarry"] then
  mining_category = "kr-quarry"
end

data:extend({
  {
    -- Mined item from the flux rift.
    type = "item",
    name = "fw-crystalised-flux",
    icon = "__FluxWorksAssets__/graphics/icons/items/flux.png",
    subgroup = "raw-resource",
    order = "ga[fw-crystalised-flux]",
    stack_size = 50,
    pictures = {
      {
        layers = {
          {
            size = 64,
            filename = "__FluxWorksAssets__/graphics/icons/items/flux.png",
            scale = 0.5,
          },
          {
            draw_as_light = true,
            blend_mode = "additive",
            tint = { r = 0.3, g = 0.3, b = 0.3, a = 0.3 },
            size = 64,
            filename = "__FluxWorksAssets__/graphics/icons/items/flux-light.png",
            scale = 0.5,
          },
        },
      },
      {
        layers = {
          {
            size = 64,
            filename = "__FluxWorksAssets__/graphics/icons/items/flux-1.png",
            scale = 0.5,
          },
          {
            draw_as_light = true,
            blend_mode = "additive",
            tint = { r = 0.3, g = 0.3, b = 0.3, a = 0.3 },
            size = 64,
            filename = "__FluxWorksAssets__/graphics/icons/items/flux-1-light.png",
            scale = 0.5,
          },
        },
      },
      {
        layers = {
          {
            size = 64,
            filename = "__FluxWorksAssets__/graphics/icons/items/flux-2.png",
            scale = 0.5,
          },
          {
            draw_as_light = true,
            blend_mode = "additive",
            tint = { r = 0.3, g = 0.3, b = 0.3, a = 0.3 },
            size = 64,
            filename = "__FluxWorksAssets__/graphics/icons/items/flux-2-light.png",
            scale = 0.5,
          },
        },
      },
      {
        layers = {
          {
            size = 64,
            filename = "__FluxWorksAssets__/graphics/icons/items/flux-3.png",
            scale = 0.5,
          },
          {
            draw_as_light = true,
            blend_mode = "additive",
            tint = { r = 0.3, g = 0.3, b = 0.3, a = 0.3 },
            size = 64,
            filename = "__FluxWorksAssets__/graphics/icons/items/flux-3-light.png",
            scale = 0.5,
          },
        },
      },
    },
  },
  {
    -- The actual world node.
    type = "resource",
    name = "fw-crystalised-flux",
    category = mining_category,
    icon = "__FluxWorksAssets__/graphics/icons/items/flux.png",
    flags = { "placeable-neutral" },
    order = "a-b-a",
    subgroup = "mineable-fluids",
    collision_box = { { -3.4, -3.4 }, { 3.4, 3.4 } },
    selection_box = { { -3.5, -3.5 }, { 3.5, 3.5 } },
    infinite = false,
    highlight = true,
    minimum = 220,
    normal = 900,
    infinite_depletion_amount = 10,
    resource_patch_search_radius = 12,
    tree_removal_probability = 1,
    tree_removal_max_distance = 32 * 32,
    minable = { mining_time = 2, result = "fw-crystalised-flux" },
    autoplace = resource_autoplace.resource_autoplace_settings({
      name = "fw-crystalised-flux",
      order = "f",
      base_density = 0.14,
      richness_multiplier = 1.6,
      richness_multiplier_distance_bonus = 1.4,
      base_spots_per_km2 = 0.022,
      has_starting_area_placement = false,
      random_spot_size_minimum = 0.01,
      random_spot_size_maximum = 0.07,
      regular_blob_amplitude_multiplier = 1,
      richness_post_multiplier = 1.2,
      additional_richness = 250000,
      regular_rq_factor_multiplier = 0.08,
      candidate_spot_count = 2,
    }),
    stage_counts = { 0 },
    stages = {
      sheet = {
        filename = "__FluxWorksAssets__/graphics/resources/flux/flux-rift.png",
        priority = "extra-high",
        width = 500,
        height = 500,
        frame_count = 6,
        variation_count = 1,
        scale = 0.4,
      },
    },
    stages_effect = {
      sheets = {
        {
          filename = "__FluxWorksAssets__/graphics/resources/flux/flux-rift-glow.png",
          priority = "extra-high",
          width = 500,
          height = 500,
          frame_count = 6,
          variation_count = 1,
          scale = 0.4,
          draw_as_glow = true,
        },
      },
    },
    effect_animation_period = 5,
    effect_animation_period_deviation = 1,
    effect_darkness_multiplier = 3.5,
    min_effect_alpha = 0.2,
    max_effect_alpha = 0.3,
    map_color = { r = 1, g = 0.5, b = 1 },
    mining_visualisation_tint = { r = 0.792, g = 0.050, b = 0.858 },
    map_grid = false,
  },
})

if data.raw["autoplace-control"] and data.raw["autoplace-control"]["iron-ore"] then
  -- Copy iron-ore's map-gen control so this looks/behaves like a normal ore slider.
  local flux_autoplace = Common.cloneInto("autoplace-control", "iron-ore", "fw-crystalised-flux")
  flux_autoplace.localised_name = { "", "[entity=fw-crystalised-flux] ", { "autoplace-control-names.fw-crystalised-flux" } }
  flux_autoplace.richness = true
  flux_autoplace.order = "b-k"
  flux_autoplace.category = "resource"
else
  -- Safety fallback in case iron-ore control isn't available for some reason.
  data:extend({
    {
      type = "autoplace-control",
      name = "fw-crystalised-flux",
      localised_name = { "", "[entity=fw-crystalised-flux] ", { "autoplace-control-names.fw-crystalised-flux" } },
      richness = true,
      order = "b-k",
      category = "resource",
    },
  })
end
