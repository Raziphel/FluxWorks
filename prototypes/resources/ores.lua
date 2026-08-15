local resource_autoplace = require("__core__.lualib.resource-autoplace")
local item_sounds = require("__base__.prototypes.item_sounds")
local Startup = require("prototypes.lib.startup-settings")

local ORE_RARITY = {
  ["fw-lead-ore"] =     { base_density = 7.4, base_spots_per_km2 = 1.8,  starting = true,  regular_rq = 1.45, starting_rq = 1.95 },
  ["fw-bauxite-ore"] =  { base_density = 2.1, base_spots_per_km2 = 0.65, starting = false, regular_rq = 0.90, starting_rq = 1.0 },
  ["fw-titanium-ore"] = { base_density = 0.72, base_spots_per_km2 = 0.24, starting = false, regular_rq = 0.72, starting_rq = 0.85 },
  ["fw-salt"] =         { base_density = 2.2, base_spots_per_km2 = 0.75, starting = false, regular_rq = 2.9, starting_rq = 3.1 },
}

-- Centralized asset paths so art moves are easy later.
local ore_path = "__FluxWorksAssets__/graphics/resources/ores/"
local mixed_deposit_path = "__FluxWorksAssets__/graphics/resources/deposits/"
local resource_icon_path = "__FluxWorksAssets__/graphics/icons/resources/"
local fluid_path = "__FluxWorksAssets__/graphics/resources/fluids/"
local bz_icon_path = "__FluxWorksAssets__/graphics/icons/items/"
local TITANIUM_TINT = { r = 0.44, g = 0.66, b = 0.96, a = 1 }
local BAUXITE_TINT = { r = 1.00, g = 0.63, b = 0.40, a = 1 }
local METALLIC_DEPOSIT_TINT = { r = 0.47, g = 0.56, b = 0.62, a = 1 }
local MINERAL_DEPOSIT_TINT = { r = 0.96, g = 0.70, b = 0.42, a = 1 }
local CARBONIC_DEPOSIT_TINT = { r = 0.18, g = 0.19, b = 0.22, a = 1 }
local PROMETHIUM_IMPACT_TINT = { r = 0.86, g = 0.58, b = 1.00, a = 1 }
local SILICA_VEIN_TINT = { r = 0.48, g = 0.78, b = 1.00, a = 1 }
local NO_TINT = { r = 1, g = 1, b = 1, a = 1 }
-- Reuse stone particles and tint them white so salt mining reads clearly.
local salt_particle = table.deepcopy(data.raw["optimized-particle"]["stone-particle"])
salt_particle.name = "fw-salt-particle"
for _, picture in pairs(salt_particle.pictures) do
  picture.tint = { r = 1, g = 1, b = 1, a = 0 }
  if picture.hr_version then
    picture.hr_version.tint = { r = 1, g = 1, b = 1, a = 0 }
  end
end

data:extend({
  -- Titanium ore controls + prototypes.
  {
    type = "autoplace-control",
    category = "resource",
    name = "fw-titanium-ore",
    localised_name = { "", "[item=titanium-ore] ", { "autoplace-control-names.fw-titanium-ore" } },
    richness = true,
    order = "a-t",
  },
  -- Titanium resource + item.
  {
    type = "resource",
    name = "fw-titanium-ore",
    icons = {
      { icon = bz_icon_path .. "fw-bz-titanium-ore.png", icon_size = 64, tint = TITANIUM_TINT },
    },
    flags = { "placeable-neutral" },
    order = "a-b-a",
    map_color = { r = 0.58, g = 0.70, b = 0.84 },
    minable = {
      mining_time = 2,
      result = "titanium-ore",
      required_fluid = "fw-chlorine",
      fluid_amount = 25,
    },
    collision_box = { { -0.1, -0.1 }, { 0.1, 0.1 } },
    selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
    autoplace = resource_autoplace.resource_autoplace_settings({
      name = "fw-titanium-ore",
      order = "a-t",
      base_density = ORE_RARITY["fw-titanium-ore"].base_density,
      base_spots_per_km2 = ORE_RARITY["fw-titanium-ore"].base_spots_per_km2,
      has_starting_area_placement = ORE_RARITY["fw-titanium-ore"].starting,
      regular_rq_factor_multiplier = ORE_RARITY["fw-titanium-ore"].regular_rq,
      starting_rq_factor_multiplier = ORE_RARITY["fw-titanium-ore"].starting_rq,
    }),
    stage_counts = { 42000, 26000, 16000, 9000, 4200, 1500, 500, 180 },
    stages = {
      sheet = {
        filename = ore_path .. "hr-titanium-ore.png",
        priority = "extra-high",
        size = 128,
        frame_count = 8,
        variation_count = 8,
        scale = 0.5,
        tint = TITANIUM_TINT,
      },
    },
  },
  -- Lead ore controls + prototypes.
  {
    type = "item",
    name = "titanium-ore",
    icon = bz_icon_path .. "fw-bz-titanium-ore.png",
    icon_size = 64,
    inventory_move_sound = item_sounds.resource_inventory_move,
    pick_sound = item_sounds.resource_inventory_pickup,
    drop_sound = item_sounds.resource_inventory_move,
    subgroup = "raw-resource",
    order = "z[titanium-ore]",
    stack_size = 50,
  },
  -- Lead resource + item.
  {
    type = "autoplace-control",
    category = "resource",
    name = "fw-lead-ore",
    localised_name = { "", "[item=lead-ore] ", { "autoplace-control-names.fw-lead-ore" } },
    richness = true,
    order = "a-l",
  },
  {
    type = "resource",
    name = "fw-lead-ore",
    icons = {
      { icon = ore_path .. "lead-ore.png", icon_size = 64, tint = { r = 0.78, g = 0.66, b = 0.88, a = 1 } },
    },
    flags = { "placeable-neutral" },
    order = "a-b-a",
    map_color = { r = 0.66, g = 0.52, b = 0.78 },
    minable = { mining_time = 1, result = "lead-ore" },
    collision_box = { { -0.1, -0.1 }, { 0.1, 0.1 } },
    selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
    autoplace = resource_autoplace.resource_autoplace_settings({
      name = "fw-lead-ore",
      order = "a-l",
      base_density = ORE_RARITY["fw-lead-ore"].base_density,
      base_spots_per_km2 = ORE_RARITY["fw-lead-ore"].base_spots_per_km2,
      has_starting_area_placement = ORE_RARITY["fw-lead-ore"].starting,
      regular_rq_factor_multiplier = ORE_RARITY["fw-lead-ore"].regular_rq,
      starting_rq_factor_multiplier = ORE_RARITY["fw-lead-ore"].starting_rq,
    }),
    stage_counts = { 15000, 9500, 5500, 2900, 1300, 400, 150, 80 },
    stages = {
      sheet = {
        filename = ore_path .. "hr-lead-ore.png",
        priority = "extra-high",
        size = 128,
        frame_count = 8,
        variation_count = 8,
        scale = 0.5,
        tint = { r = 0.78, g = 0.66, b = 0.88, a = 1 },
      },
    },
  },
  {
    type = "item",
    name = "lead-ore",
    icon = ore_path .. "lead-ore.png",
    icon_size = 64,
    inventory_move_sound = item_sounds.resource_inventory_move,
    pick_sound = item_sounds.resource_inventory_pickup,
    drop_sound = item_sounds.resource_inventory_move,
    subgroup = "raw-resource",
    order = "z[lead-ore]",
    stack_size = 50,
  },
  -- Bauxite uses a recolored aluminum-style palette.
  {
    type = "autoplace-control",
    category = "resource",
    name = "fw-bauxite-ore",
    localised_name = { "", "[item=bauxite-ore] ", { "autoplace-control-names.fw-bauxite-ore" } },
    richness = true,
    order = "a-b",
  },
  {
    type = "resource",
    name = "fw-bauxite-ore",
    icons = {
      { icon = bz_icon_path .. "fw-bauxite-ore.png", icon_size = 64, tint = BAUXITE_TINT },
    },
    flags = { "placeable-neutral" },
    order = "a-b-a",
    map_color = { r = 0.90, g = 0.68, b = 0.56 },
    minable = {
      mining_time = 1,
      result = "bauxite-ore",
      required_fluid = "water",
      fluid_amount = 10,
    },
    collision_box = { { -0.1, -0.1 }, { 0.1, 0.1 } },
    selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
    autoplace = resource_autoplace.resource_autoplace_settings({
      name = "fw-bauxite-ore",
      order = "a-b",
      base_density = ORE_RARITY["fw-bauxite-ore"].base_density,
      base_spots_per_km2 = ORE_RARITY["fw-bauxite-ore"].base_spots_per_km2,
      has_starting_area_placement = ORE_RARITY["fw-bauxite-ore"].starting,
      regular_rq_factor_multiplier = ORE_RARITY["fw-bauxite-ore"].regular_rq,
      starting_rq_factor_multiplier = ORE_RARITY["fw-bauxite-ore"].starting_rq,
    }),
    stage_counts = { 15000, 9500, 5500, 2900, 1300, 400, 150, 80 },
    stages = {
      sheet = {
        filename = ore_path .. "hr-bauxite-ore.png",
        priority = "extra-high",
        size = 128,
        frame_count = 8,
        variation_count = 8,
        scale = 0.5,
        tint = BAUXITE_TINT,
      },
    },
  },
  {
    type = "item",
    name = "bauxite-ore",
    icon = bz_icon_path .. "fw-bauxite-ore.png",
    icon_size = 64,
    inventory_move_sound = item_sounds.resource_inventory_move,
    pick_sound = item_sounds.resource_inventory_pickup,
    drop_sound = item_sounds.resource_inventory_move,
    subgroup = "raw-resource",
    order = "z[bauxite-ore]",
    stack_size = 50,
  },
  salt_particle,
  -- Salt patch + item.
  {
    type = "autoplace-control",
    category = "resource",
    name = "fw-salt",
    localised_name = { "", "[item=fw-salt] ", { "autoplace-control-names.fw-salt" } },
    richness = true,
    order = "a-s",
  },
  {
    type = "resource",
    name = "fw-salt",
    icon = ore_path .. "salt.png",
    icon_size = 128,
    flags = { "placeable-neutral" },
    order = "a-b-a",
    map_color = { r = 0.92, g = 1.00, b = 0.93 },
    minable = {
      mining_particle = "fw-salt-particle",
      mining_time = 0.5,
      result = "fw-salt",
    },
    collision_box = { { -0.1, -0.1 }, { 0.1, 0.1 } },
    selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
    autoplace = (function()
      local autoplace = resource_autoplace.resource_autoplace_settings({
        name = "fw-salt",
        order = "a-s",
        base_density = ORE_RARITY["fw-salt"].base_density,
        base_spots_per_km2 = ORE_RARITY["fw-salt"].base_spots_per_km2,
        regular_rq_factor_multiplier = ORE_RARITY["fw-salt"].regular_rq,
        has_starting_area_placement = ORE_RARITY["fw-salt"].starting,
        starting_rq_factor_multiplier = ORE_RARITY["fw-salt"].starting_rq,
      })

      -- On wetter worlds salt forms in coastal/brine deposits, while on
      -- harsher planets the aux fallback still allows isolated evaporite seams.
      autoplace.probability_expression =
        "(" .. autoplace.probability_expression .. ") * (0.18 + 0.82 * max(clamp((moisture - 0.48) * 3.2, 0, 1), clamp(aux * 1.35, 0, 1)))"
      return autoplace
    end)(),
    stage_counts = { 15000, 9500, 5500, 2900, 1300, 400, 150, 80 },
    stages = {
      sheet = {
        filename = ore_path .. "hr-salt.png",
        priority = "extra-high",
        size = 128,
        frame_count = 8,
        variation_count = 8,
        scale = 0.5,
      },
    },
  },
  {
    type = "item",
    name = "fw-salt",
    icon = ore_path .. "salt.png",
    icon_size = 128,
    subgroup = "raw-resource",
    order = "z[fw-salt]",
    stack_size = 50,
  },
  {
    -- Early salt source so the chain can start without extra mod dependencies.
    type = "recipe",
    name = "fw-salt-from-water",
    category = "crafting-with-fluid",
    ingredients = { { type = "fluid", name = "water", amount = 100 } },
    results = { { type = "item", name = "fw-salt", amount = 1 } },
    energy_required = 2,
    enabled = false,
  },
  {
    type = "fluid",
    name = "fw-chlorine",
    default_temperature = 25,
    heat_capacity = "0.1kJ",
    base_color = { r = 0.60, g = 0.90, b = 0.50 },
    flow_color = { r = 0.60, g = 1.00, b = 0.50 },
    icon = "__base__/graphics/icons/fluid/sulfuric-acid.png",
    icon_size = 64,
    order = "a[fluid]-f[fw-chlorine]",
  },
  {
    type = "recipe",
    name = "fw-chlorine",
    icon = "__base__/graphics/icons/fluid/sulfuric-acid.png",
    icon_size = 64,
    category = "chemistry",
    ingredients = { { type = "item", name = "fw-salt", amount = 2 } },
    results = { { type = "fluid", name = "fw-chlorine", amount = 10 } },
    energy_required = 0.5,
    enabled = false,
  },
})

-- Mixed-deposit worldgen: reduce Nauvis patch clutter while still feeding
-- a broad material economy through weighted multi-resource outputs.
data:extend({
  {
    type = "autoplace-control",
    category = "resource",
    name = "fw-silica-vein",
    localised_name = { "", "[item=silicon-ore] ", { "autoplace-control-names.fw-silica-vein" } },
    richness = true,
    order = "a-v",
  },
  {
    type = "resource",
    name = "fw-silica-vein",
    icons = {
      { icon = bz_icon_path .. "fw-bz-silicon-ore.png", icon_size = 64, tint = SILICA_VEIN_TINT },
      { icon = "__base__/graphics/icons/stone.png", icon_size = 64, scale = 0.30, shift = { -8, 8 }, tint = { r = 0.90, g = 0.84, b = 0.72, a = 1.00 } },
    },
    flags = { "placeable-neutral" },
    order = "a-b-bb",
    map_color = { r = 0.82, g = 0.90, b = 0.98 },
    minable = {
      mining_time = 1.4,
      required_fluid = "water",
      fluid_amount = 10,
      results = {
        { type = "item", name = "silicon-ore", amount = 2 },
        { type = "item", name = "stone", amount = 1, probability = 0.55 },
      },
    },
    collision_box = { { -0.1, -0.1 }, { 0.1, 0.1 } },
    selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
    autoplace = resource_autoplace.resource_autoplace_settings({
      name = "fw-silica-vein",
      order = "a-v",
      base_density = 5.2,
      base_spots_per_km2 = 0.32,
      has_starting_area_placement = false,
      regular_rq_factor_multiplier = 1.10,
      starting_rq_factor_multiplier = 0.60,
    }),
    stage_counts = { 18000, 11000, 6500, 3600, 1650, 600, 220, 90 },
    stages = {
      sheet = {
        filename = ore_path .. "hr-silica-vein.png",
        priority = "extra-high",
        size = 128,
        frame_count = 8,
        variation_count = 8,
        scale = 0.5,
        tint = SILICA_VEIN_TINT,
      },
    },
  },
  {
    type = "autoplace-control",
    category = "resource",
    name = "fw-metallic-deposit",
    localised_name = { "", "[item=iron-ore] [item=copper-ore] ", { "autoplace-control-names.fw-metallic-deposit" } },
    richness = true,
    order = "a-m",
  },
  {
    type = "resource",
    name = "fw-metallic-deposit",
    subgroup = "raw-resource",
    icons = {
      { icon = resource_icon_path .. "fw-metallic-deposit.png", icon_size = 64, tint = METALLIC_DEPOSIT_TINT },
      { icon = "__base__/graphics/icons/iron-ore.png", icon_size = 64, scale = 0.34, shift = { -9, 8 }, tint = { r = 0.82, g = 0.86, b = 0.90, a = 1.00 } },
      { icon = "__base__/graphics/icons/copper-ore.png", icon_size = 64, scale = 0.34, shift = { 8, 8 }, tint = { r = 0.68, g = 0.54, b = 0.44, a = 1.00 } },
    },
    flags = { "placeable-neutral" },
    order = "a-b-b",
    map_color = { r = 0.44, g = 0.53, b = 0.58 },
    minable = {
      mining_time = 1.1,
      results = {
        { type = "item", name = "iron-ore", amount_min = 2, amount_max = 3 },
        { type = "item", name = "copper-ore", amount_min = 1, amount_max = 2, probability = 0.95 },
        { type = "item", name = "lead-ore", amount = 1, probability = 0.65 },
        { type = "item", name = "tin-ore", amount = 1, probability = 0.40 },
      },
    },
    collision_box = { { -0.1, -0.1 }, { 0.1, 0.1 } },
    selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
    autoplace = resource_autoplace.resource_autoplace_settings({
      name = "fw-metallic-deposit",
      order = "a-m",
      base_density = 12.0,
      richness_multiplier = 0.40,
      base_spots_per_km2 = 0.56,
      has_starting_area_placement = true,
      richness_post_multiplier = 0.70,
      additional_richness = 240,
      regular_rq_factor_multiplier = 1.55,
      starting_rq_factor_multiplier = 2.80,
    }),
    stage_counts = { 28000, 17000, 10000, 5600, 2500, 900, 280, 120 },
    stages = {
      sheet = {
        filename = "__base__/graphics/entity/iron-ore/iron-ore.png",
        priority = "extra-high",
        size = 128,
        frame_count = 8,
        variation_count = 8,
        scale = 0.5,
        tint = NO_TINT,
      },
    },
  },
  {
    type = "autoplace-control",
    category = "resource",
    name = "fw-mineral-deposit",
    localised_name = { "", "[item=bauxite-ore] [item=silicon-ore] ", { "autoplace-control-names.fw-mineral-deposit" } },
    richness = true,
    order = "a-n",
  },
  {
    type = "resource",
    name = "fw-mineral-deposit",
    subgroup = "raw-resource",
    icons = {
      { icon = resource_icon_path .. "fw-mineral-deposit.png", icon_size = 64, tint = MINERAL_DEPOSIT_TINT },
      { icon = bz_icon_path .. "fw-bauxite-ore.png", icon_size = 64, scale = 0.34, shift = { -9, 8 }, tint = { r = 1.00, g = 0.82, b = 0.74, a = 1.00 } },
      { icon = bz_icon_path .. "fw-bz-silicon-ore.png", icon_size = 64, scale = 0.34, shift = { 8, 8 }, tint = { r = 0.92, g = 0.98, b = 1.00, a = 1.00 } },
    },
    flags = { "placeable-neutral" },
    order = "a-b-c",
    map_color = { r = 0.66, g = 0.62, b = 0.58 },
    minable = {
      mining_time = 1.8,
      results = {
        { type = "item", name = "bauxite-ore", amount = 1 },
        { type = "item", name = "titanium-ore", amount = 1, probability = 0.18 },
        { type = "item", name = "silicon-ore", amount = 1, probability = 0.75 },
        { type = "item", name = "stone", amount = 1, probability = 0.35 },
      },
    },
    collision_box = { { -0.1, -0.1 }, { 0.1, 0.1 } },
    selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
    autoplace = resource_autoplace.resource_autoplace_settings({
      name = "fw-mineral-deposit",
      order = "a-n",
      base_density = 6.6,
      richness_multiplier = 0.38,
      base_spots_per_km2 = 0.30,
      has_starting_area_placement = true,
      richness_post_multiplier = 0.68,
      additional_richness = 190,
      regular_rq_factor_multiplier = 1.10,
      starting_rq_factor_multiplier = 2.35,
    }),
    stage_counts = { 26000, 15500, 9200, 5200, 2300, 820, 260, 110 },
    stages = {
      sheet = {
        filename = "__base__/graphics/entity/stone/stone.png",
        priority = "extra-high",
        size = 128,
        frame_count = 8,
        variation_count = 8,
        scale = 0.5,
        tint = { r = 0.74, g = 0.70, b = 0.64, a = 1 },
      },
    },
  },
  {
    type = "autoplace-control",
    category = "resource",
    name = "fw-carbonic-deposit",
    localised_name = { "", "[item=coal] [item=fw-salt] ", { "autoplace-control-names.fw-carbonic-deposit" } },
    richness = true,
    order = "a-o",
  },
  {
    type = "resource",
    name = "fw-carbonic-deposit",
    subgroup = "raw-resource",
    icons = {
      { icon = resource_icon_path .. "fw-carbonic-deposit.png", icon_size = 64, tint = CARBONIC_DEPOSIT_TINT },
      { icon = "__base__/graphics/icons/coal.png", icon_size = 64, scale = 0.34, shift = { -9, 8 }, tint = { r = 0.58, g = 0.58, b = 0.60, a = 1.00 } },
      { icon = ore_path .. "salt.png", icon_size = 128, scale = 0.17, shift = { 8, 8 }, tint = { r = 0.80, g = 0.80, b = 0.82, a = 1.00 } },
    },
    flags = { "placeable-neutral" },
    order = "a-b-d",
    map_color = { r = 0.14, g = 0.14, b = 0.16 },
    minable = {
      mining_time = 1.0,
      mining_particle = "fw-salt-particle",
      results = {
        { type = "item", name = "coal", amount = 1 },
        { type = "item", name = "fw-salt", amount = 1, probability = 0.50 },
      },
    },
    collision_box = { { -0.1, -0.1 }, { 0.1, 0.1 } },
    selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
    autoplace = resource_autoplace.resource_autoplace_settings({
      name = "fw-carbonic-deposit",
      order = "a-o",
      base_density = 7.8,
      richness_multiplier = 0.36,
      base_spots_per_km2 = 0.32,
      has_starting_area_placement = true,
      richness_post_multiplier = 0.68,
      additional_richness = 200,
      regular_rq_factor_multiplier = 1.32,
      starting_rq_factor_multiplier = 2.30,
    }),
    stage_counts = { 24000, 14500, 8600, 4800, 2100, 760, 240, 100 },
    stages = {
      sheet = {
        filename = "__base__/graphics/entity/coal/coal.png",
        priority = "extra-high",
        size = 128,
        frame_count = 8,
        variation_count = 8,
        scale = 0.5,
        tint = NO_TINT,
      },
    },
  },
})

if data.raw.item["promethium-asteroid-chunk"] and Startup.enabled("fw-worldgen-enable-promethium-impacts", true) then
  data:extend({
    {
      type = "autoplace-control",
      category = "resource",
      name = "fw-promethium-impact",
      localised_name = { "", "[item=fw-promethium-shard] [item=stone] ", { "autoplace-control-names.fw-promethium-impact" } },
      richness = true,
      order = "a-p",
    },
    {
      type = "resource",
      name = "fw-promethium-impact",
      icons = {
        {
          icon = "__base__/graphics/icons/stone.png",
          icon_size = 64,
          tint = { r = 0.66, g = 0.60, b = 0.70, a = 1.00 },
        },
        {
          icon = "__space-age__/graphics/icons/promethium-asteroid-chunk.png",
          icon_size = 64,
          scale = 0.62,
          shift = { -4, -3 },
          tint = PROMETHIUM_IMPACT_TINT,
        },
        {
          icon = "__FluxWorksAssets__/graphics/icons/items/crystallized-flux.png",
          icon_size = 64,
          scale = 0.30,
          shift = { 9, 9 },
          tint = { r = 0.98, g = 0.60, b = 1.00, a = 1.00 },
        },
      },
      flags = { "placeable-neutral" },
      order = "a-b-e",
      map_color = { r = 0.64, g = 0.48, b = 0.72 },
      minable = {
        mining_time = 2.6,
        results = {
          { type = "item", name = "fw-promethium-shard", amount = 1 },
          { type = "item", name = "stone", amount = 1, probability = 0.70 },
        },
      },
      collision_box = { { -0.1, -0.1 }, { 0.1, 0.1 } },
      selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
      autoplace = (function()
        return resource_autoplace.resource_autoplace_settings({
          name = "fw-promethium-impact",
          order = "a-p",
          base_density = 0.20,
          base_spots_per_km2 = 0.024,
          has_starting_area_placement = false,
          regular_rq_factor_multiplier = 0.42,
          starting_rq_factor_multiplier = 0.14,
        })
      end)(),
      stage_counts = { 9000, 6500, 4200, 2600, 1500, 800, 320, 100 },
      stages = {
        sheet = {
          filename = mixed_deposit_path .. "mineral-deposit-sheet-vivid.png",
          priority = "extra-high",
          size = 128,
          frame_count = 8,
          variation_count = 8,
          scale = 0.5,
          tint = PROMETHIUM_IMPACT_TINT,
        },
      },
    },
  })
end

if not data.raw.item["tin-ore"] then
  data:extend({
    {
      type = "item",
      name = "tin-ore",
      icon = "__FluxWorksAssets__/graphics/icons/items/fw-bz-tin-ore.png",
      icon_size = 64,
      subgroup = "raw-resource",
      order = "z[tin-ore]",
      stack_size = 50,
    },
  })
end

if not data.raw.item["silicon-ore"] then
  data:extend({
    {
      type = "item",
      name = "silicon-ore",
      icon = "__FluxWorksAssets__/graphics/icons/items/fw-bz-silicon-ore.png",
      icon_size = 64,
      subgroup = "raw-resource",
      order = "z[silicon-ore]",
      stack_size = 50,
    },
  })
end

-- Always prefer local BZ-style ore icons so visuals stay consistent even when
-- those items come from external mods rather than our fallback definitions.
local function override_ore_item_icon(name, icon_file, icon_size)
  local item = data.raw.item and data.raw.item[name]
  if not item then
    return
  end
  item.icons = nil
  item.pictures = nil
  item.icon = bz_icon_path .. icon_file
  item.icon_size = icon_size or 128
  item.icon_mipmaps = nil
end

override_ore_item_icon("titanium-ore", "fw-bz-titanium-ore.png", 64)
override_ore_item_icon("tin-ore", "fw-bz-tin-ore.png", 64)
override_ore_item_icon("silicon-ore", "fw-bz-silicon-ore.png", 64)
override_ore_item_icon("carbon-ore", "fw-bz-carbon-ore.png", 128)
override_ore_item_icon("bauxite-ore", "fw-bauxite-ore.png", 64)

-- Keep Nauvis focused on mixed deposits unless separate ore patches are requested.
if not Startup.enabled("fw-worldgen-enable-standalone-ores", false) then
  for _, resource_name in pairs({ "fw-lead-ore", "fw-bauxite-ore", "fw-titanium-ore" }) do
    if data.raw.resource[resource_name] then
      data.raw.resource[resource_name].autoplace = nil
    end
  end
end
