local resource_autoplace = require("__core__.lualib.resource-autoplace")
local ORE_RARITY = require("prototypes.resources.rarity")

local ore_path = "__FluxWorksAssets__/graphics/resources/ores/"
local icon_path = "__FluxWorksAssets__/graphics/icons/items/"

data:extend({
  {
    type = "autoplace-control",
    category = "resource",
    name = "fw-silica-ore",
    localised_name = { "", "[item=silica] ", { "autoplace-control-names.fw-silica-ore" } },
    richness = true,
    order = "a-q",
  },
  {
    type = "resource",
    name = "fw-silica-ore",
    icons = {
      { icon = ore_path .. "silica.png", icon_size = 64, tint = { r = 0.78, g = 0.67, b = 0.58, a = 1 } },
    },
    flags = { "placeable-neutral" },
    order = "a-b-a",
    map_color = { r = 0.68, g = 0.57, b = 0.49 },
    minable = { mining_time = 0.9, result = "silica" },
    collision_box = { { -0.1, -0.1 }, { 0.1, 0.1 } },
    selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
    autoplace = resource_autoplace.resource_autoplace_settings({
      name = "fw-silica-ore",
      order = "a-q",
      base_density = ORE_RARITY["fw-silica-ore"].base_density,
      base_spots_per_km2 = ORE_RARITY["fw-silica-ore"].base_spots_per_km2,
      has_starting_area_placement = ORE_RARITY["fw-silica-ore"].starting,
      regular_rq_factor_multiplier = ORE_RARITY["fw-silica-ore"].regular_rq,
      starting_rq_factor_multiplier = ORE_RARITY["fw-silica-ore"].starting_rq,
    }),
    stage_counts = { 15000, 9500, 5500, 2900, 1300, 400, 150, 80 },
    stages = {
      sheet = {
        filename = ore_path .. "hr-tin-ore.png",
        priority = "extra-high",
        size = 128,
        frame_count = 8,
        variation_count = 8,
        scale = 0.5,
        tint = { r = 0.78, g = 0.67, b = 0.58, a = 1 },
      },
    },
  },
  {
    type = "autoplace-control",
    category = "resource",
    name = "fw-graphite-ore",
    localised_name = { "", "[item=flake-graphite] ", { "autoplace-control-names.fw-graphite-ore" } },
    richness = true,
    order = "a-g",
  },
  {
    type = "resource",
    name = "fw-graphite-ore",
    icons = {
      { icon = icon_path .. "flake-graphite.png", icon_size = 128, tint = { r = 0.42, g = 0.40, b = 0.48, a = 1 } },
    },
    flags = { "placeable-neutral" },
    order = "a-b-a",
    map_color = { r = 0.36, g = 0.35, b = 0.42 },
    minable = {
      mining_time = 1,
      required_fluid = "steam",
      fluid_amount = 1,
      result = "flake-graphite",
    },
    collision_box = { { -0.1, -0.1 }, { 0.1, 0.1 } },
    selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
    autoplace = resource_autoplace.resource_autoplace_settings({
      name = "fw-graphite-ore",
      order = "a-g",
      base_density = ORE_RARITY["fw-graphite-ore"].base_density,
      base_spots_per_km2 = ORE_RARITY["fw-graphite-ore"].base_spots_per_km2,
      has_starting_area_placement = ORE_RARITY["fw-graphite-ore"].starting,
      regular_rq_factor_multiplier = ORE_RARITY["fw-graphite-ore"].regular_rq,
      starting_rq_factor_multiplier = ORE_RARITY["fw-graphite-ore"].starting_rq,
    }),
    stage_counts = { 15000, 9500, 5500, 2900, 1300, 400, 150, 80 },
    stages = {
      sheet = {
        filename = ore_path .. "hr-graphite-ore.png",
        priority = "extra-high",
        size = 128,
        frame_count = 8,
        variation_count = 8,
        scale = 0.5,
        tint = { r = 0.42, g = 0.40, b = 0.48, a = 1 },
      },
    },
  },
  {
    type = "autoplace-control",
    category = "resource",
    name = "fw-diamond-ore",
    localised_name = { "", "[item=rough-diamond] ", { "autoplace-control-names.fw-diamond-ore" } },
    richness = true,
    order = "a-d",
  },
  {
    type = "resource",
    name = "fw-diamond-ore",
    icons = {
      { icon = icon_path .. "rough-diamond.png", icon_size = 128, tint = { r = 0.58, g = 0.72, b = 0.84, a = 1 } },
    },
    flags = { "placeable-neutral" },
    order = "a-b-a",
    map_color = { r = 0.50, g = 0.64, b = 0.76 },
    minable = {
      mining_time = 2,
      required_fluid = "sulfuric-acid",
      fluid_amount = 10,
      result = "rough-diamond",
    },
    collision_box = { { -0.1, -0.1 }, { 0.1, 0.1 } },
    selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
    autoplace = resource_autoplace.resource_autoplace_settings({
      name = "fw-diamond-ore",
      order = "a-d",
      base_density = ORE_RARITY["fw-diamond-ore"].base_density,
      base_spots_per_km2 = ORE_RARITY["fw-diamond-ore"].base_spots_per_km2,
      has_starting_area_placement = ORE_RARITY["fw-diamond-ore"].starting,
      regular_rq_factor_multiplier = ORE_RARITY["fw-diamond-ore"].regular_rq,
      starting_rq_factor_multiplier = ORE_RARITY["fw-diamond-ore"].starting_rq,
    }),
    stage_counts = { 12000, 7800, 4500, 2200, 1000, 300, 120, 60 },
    stages = {
      sheet = {
        filename = ore_path .. "hr-diamond-ore.png",
        priority = "extra-high",
        size = 128,
        frame_count = 8,
        variation_count = 8,
        scale = 0.5,
        tint = { r = 0.58, g = 0.72, b = 0.84, a = 1 },
      },
    },
  },
})
