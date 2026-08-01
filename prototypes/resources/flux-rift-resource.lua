local resource_autoplace = require("__core__.lualib.resource-autoplace")
local Prototype = require("__razi_lib__/lib/prototype")

local crystallized_flux_icon = "__FluxWorksAssets__/graphics/icons/items/crystallized-flux.png"
local crystallized_flux_on_belt_variants = {
  {
    icon = "__FluxWorksAssets__/graphics/icons/items/crystallized-flux-on-belt-1.png",
    light = "__FluxWorksAssets__/graphics/icons/items/crystallized-flux-on-belt-1-light.png",
  },
  {
    icon = "__FluxWorksAssets__/graphics/icons/items/crystallized-flux-on-belt-2.png",
    light = "__FluxWorksAssets__/graphics/icons/items/crystallized-flux-on-belt-2-light.png",
  },
  {
    icon = "__FluxWorksAssets__/graphics/icons/items/crystallized-flux-on-belt-3.png",
    light = "__FluxWorksAssets__/graphics/icons/items/crystallized-flux-on-belt-3-light.png",
  },
  {
    icon = "__FluxWorksAssets__/graphics/icons/items/crystallized-flux-on-belt-4.png",
    light = "__FluxWorksAssets__/graphics/icons/items/crystallized-flux-on-belt-4-light.png",
  },
}

local crystallized_flux_item_pictures = {}
for _, variant in ipairs(crystallized_flux_on_belt_variants) do
  crystallized_flux_item_pictures[#crystallized_flux_item_pictures + 1] = {
    layers = {
      {
        size = 64,
        filename = variant.icon,
        scale = 0.5,
      },
      {
        draw_as_light = true,
        blend_mode = "additive",
        tint = { r = 0.3, g = 0.3, b = 0.3, a = 0.3 },
        size = 64,
        filename = variant.light,
        scale = 0.5,
      },
    },
  }
end

data:extend({
  {
    -- Mined item from the flux rift.
    type = "item",
    name = "fw-crystalised-flux",
    icon = crystallized_flux_icon,
    icon_size = 64,
    subgroup = "raw-resource",
    order = "ga[fw-crystalised-flux]",
    stack_size = 50,
    weight = 10000,
    pictures = crystallized_flux_item_pictures,
  },
  {
    -- The actual world node.
    type = "resource",
    name = "fw-crystalised-flux",
    category = "fw-flux-rift",
    icon = crystallized_flux_icon,
    icon_size = 64,
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
    stages = table.deepcopy(data.raw.resource["uranium-ore"].stages),
    stages_effect = table.deepcopy(data.raw.resource["uranium-ore"].stages_effect),
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
  local flux_autoplace = Prototype.clone("autoplace-control", "iron-ore", "fw-crystalised-flux")
  flux_autoplace.localised_name = { "", "[item=fw-crystalised-flux] ", { "autoplace-control-names.fw-crystalised-flux" } }
  flux_autoplace.richness = true
  flux_autoplace.order = "b-k"
  flux_autoplace.category = "resource"
else
  -- Safety fallback in case iron-ore control isn't available for some reason.
  data:extend({
    {
      type = "autoplace-control",
      name = "fw-crystalised-flux",
      localised_name = { "", "[item=fw-crystalised-flux] ", { "autoplace-control-names.fw-crystalised-flux" } },
      richness = true,
      order = "b-k",
      category = "resource",
    },
  })
end
