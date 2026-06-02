local resource_autoplace = require("__core__.lualib.resource-autoplace")
local item_sounds = require("__base__.prototypes.item_sounds")

local ORE_RARITY = {
  ["fw-lead-ore"] =     { base_density = 5.8, base_spots_per_km2 = 1.4,  starting = true,  regular_rq = 1.25, starting_rq = 1.65 },
  ["fw-bauxite-ore"] =  { base_density = 2.1, base_spots_per_km2 = 0.65, starting = false, regular_rq = 0.90, starting_rq = 1.0 },
  ["fw-titanium-ore"] = { base_density = 1.25, base_spots_per_km2 = 0.42, starting = false, regular_rq = 0.85, starting_rq = 1.0 },
  ["fw-salt"] =         { base_density = 2.2, base_spots_per_km2 = 0.75, starting = false, regular_rq = 2.9, starting_rq = 3.1 },
}

-- Centralized asset paths so art moves are easy later.
local ore_path = "__FluxWorksAssets__/graphics/resources/ores/"
local mixed_deposit_path = "__FluxWorksAssets__/graphics/resources/deposits/"
local resource_icon_path = "__FluxWorksAssets__/graphics/icons/resources/"
local fluid_path = "__FluxWorksAssets__/graphics/resources/fluids/"
local bz_icon_path = "__FluxWorksAssets__/graphics/icons/items/"
local TITANIUM_TINT = { r = 0.80, g = 0.80, b = 0.78, a = 1 }
local BAUXITE_TINT = { r = 0.86, g = 0.42, b = 0.18, a = 1 }
local METALLIC_DEPOSIT_TINT = { r = 0.86, g = 0.90, b = 0.96, a = 1 }
local MINERAL_DEPOSIT_TINT = { r = 1.00, g = 0.82, b = 0.46, a = 1 }
local CARBONIC_DEPOSIT_TINT = { r = 0.20, g = 0.20, b = 0.22, a = 1 }
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
      { icon = ore_path .. "titanium-ore.png", icon_size = 64, tint = TITANIUM_TINT },
    },
    flags = { "placeable-neutral" },
    order = "a-b-a",
    map_color = { r = 0.66, g = 0.66, b = 0.64 },
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
    icons = {
      { icon = ore_path .. "titanium-ore.png", icon_size = 64, tint = TITANIUM_TINT },
    },
    pictures = {
      { filename = ore_path .. "titanium-ore.png", size = 64, scale = 0.5, tint = TITANIUM_TINT },
      { filename = ore_path .. "titanium-ore-2.png", size = 64, scale = 0.5, tint = TITANIUM_TINT },
      { filename = ore_path .. "titanium-ore-3.png", size = 64, scale = 0.5, tint = TITANIUM_TINT },
      { filename = ore_path .. "titanium-ore-4.png", size = 64, scale = 0.5, tint = TITANIUM_TINT },
    },
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
    icons = {
      { icon = ore_path .. "lead-ore.png", icon_size = 64, tint = { r = 0.78, g = 0.66, b = 0.88, a = 1 } },
    },
    pictures = {
      { filename = ore_path .. "lead-ore.png", size = 64, scale = 0.5, tint = { r = 0.78, g = 0.66, b = 0.88, a = 1 } },
      { filename = ore_path .. "lead-ore-1.png", size = 64, scale = 0.5, tint = { r = 0.78, g = 0.66, b = 0.88, a = 1 } },
      { filename = ore_path .. "lead-ore-2.png", size = 64, scale = 0.5, tint = { r = 0.78, g = 0.66, b = 0.88, a = 1 } },
      { filename = ore_path .. "lead-ore-3.png", size = 64, scale = 0.5, tint = { r = 0.78, g = 0.66, b = 0.88, a = 1 } },
    },
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
      { icon = ore_path .. "bauxite-ore.png", icon_size = 64, tint = BAUXITE_TINT },
    },
    flags = { "placeable-neutral" },
    order = "a-b-a",
    map_color = { r = 0.82, g = 0.40, b = 0.18 },
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
    icons = {
      { icon = ore_path .. "bauxite-ore.png", icon_size = 64, tint = BAUXITE_TINT },
    },
    pictures = {
      { filename = ore_path .. "bauxite-ore.png", size = 64, scale = 0.5, tint = BAUXITE_TINT },
      { filename = ore_path .. "bauxite-ore-2.png", size = 64, scale = 0.5, tint = BAUXITE_TINT },
      { filename = ore_path .. "bauxite-ore-3.png", size = 64, scale = 0.5, tint = BAUXITE_TINT },
      { filename = ore_path .. "bauxite-ore-4.png", size = 64, scale = 0.5, tint = BAUXITE_TINT },
    },
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

      -- Strongly bias salt toward moist/wet regions so it naturally
      -- forms coastal and humidity-driven deposits.
      autoplace.probability_expression =
        "(" .. autoplace.probability_expression .. ") * (0.05 + 0.95 * clamp((moisture - 0.48) * 3.2, 0, 1))"
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
    pictures = {
      { filename = ore_path .. "salt.png", size = 128, scale = 0.125 },
      { filename = ore_path .. "salt-1.png", size = 128, scale = 0.125 },
      { filename = ore_path .. "salt-2.png", size = 128, scale = 0.125 },
      { filename = ore_path .. "salt-3.png", size = 128, scale = 0.125 },
      { filename = ore_path .. "salt-4.png", size = 128, scale = 0.125 },
    },
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
    icon = fluid_path .. "chlorine.png",
    icon_size = 128,
    order = "a[fluid]-f[fw-chlorine]",
  },
  {
    type = "recipe",
    name = "fw-chlorine",
    icon = fluid_path .. "chlorine.png",
    icon_size = 128,
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
    name = "fw-metallic-deposit",
    localised_name = { "", "[entity=fw-metallic-deposit] ", { "autoplace-control-names.fw-metallic-deposit" } },
    richness = true,
    order = "a-m",
  },
  {
    type = "resource",
    name = "fw-metallic-deposit",
    icons = {
      { icon = resource_icon_path .. "fw-metallic-deposit.png", icon_size = 64, tint = METALLIC_DEPOSIT_TINT },
      { icon = "__base__/graphics/icons/iron-ore.png", icon_size = 64, scale = 0.34, shift = { -9, 8 }, tint = { r = 0.82, g = 0.86, b = 0.90, a = 1.00 } },
      { icon = "__base__/graphics/icons/copper-ore.png", icon_size = 64, scale = 0.34, shift = { 8, 8 }, tint = { r = 0.84, g = 0.56, b = 0.38, a = 1.00 } },
    },
    flags = { "placeable-neutral" },
    order = "a-b-b",
    map_color = { r = 0.45, g = 0.53, b = 0.62 },
    minable = {
      mining_time = 1.1,
      results = {
        { type = "item", name = "iron-ore", amount_min = 1, amount_max = 2 },
        { type = "item", name = "copper-ore", amount_min = 1, amount_max = 2, probability = 0.85 },
        { type = "item", name = "lead-ore", amount = 1, probability = 0.40 },
        { type = "item", name = "tin-ore", amount = 1, probability = 0.30 },
      },
    },
    collision_box = { { -0.1, -0.1 }, { 0.1, 0.1 } },
    selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
    autoplace = resource_autoplace.resource_autoplace_settings({
      name = "fw-metallic-deposit",
      order = "a-m",
      base_density = 11.0,
      base_spots_per_km2 = 0.62,
      has_starting_area_placement = true,
      regular_rq_factor_multiplier = 1.35,
      starting_rq_factor_multiplier = 2.35,
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
        tint = METALLIC_DEPOSIT_TINT,
      },
    },
  },
  {
    type = "autoplace-control",
    category = "resource",
    name = "fw-mineral-deposit",
    localised_name = { "", "[entity=fw-mineral-deposit] ", { "autoplace-control-names.fw-mineral-deposit" } },
    richness = true,
    order = "a-n",
  },
  {
    type = "resource",
    name = "fw-mineral-deposit",
    icons = {
      { icon = resource_icon_path .. "fw-mineral-deposit.png", icon_size = 64, tint = MINERAL_DEPOSIT_TINT },
      { icon = "__base__/graphics/icons/stone.png", icon_size = 64, scale = 0.34, shift = { -9, 8 }, tint = { r = 1.00, g = 0.86, b = 0.62, a = 1.00 } },
      { icon = "__base__/graphics/icons/uranium-ore.png", icon_size = 64, scale = 0.34, shift = { 8, 8 }, tint = { r = 0.80, g = 1.00, b = 0.72, a = 1.00 } },
    },
    flags = { "placeable-neutral" },
    order = "a-b-c",
    map_color = { r = 0.86, g = 0.64, b = 0.30 },
    minable = {
      mining_time = 1.8,
      required_fluid = "water",
      fluid_amount = 10,
      results = {
        { type = "item", name = "bauxite-ore", amount = 1 },
        { type = "item", name = "titanium-ore", amount = 1, probability = 0.35 },
        { type = "item", name = "silicon-ore", amount = 1, probability = 0.60 },
        { type = "item", name = "stone", amount = 1, probability = 0.55 },
      },
    },
    collision_box = { { -0.1, -0.1 }, { 0.1, 0.1 } },
    selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
    autoplace = resource_autoplace.resource_autoplace_settings({
      name = "fw-mineral-deposit",
      order = "a-n",
      base_density = 7.0,
      base_spots_per_km2 = 0.42,
      has_starting_area_placement = true,
      regular_rq_factor_multiplier = 1.20,
      starting_rq_factor_multiplier = 2.05,
    }),
    stage_counts = { 26000, 15500, 9200, 5200, 2300, 820, 260, 110 },
    stages = {
      sheet = {
        filename = mixed_deposit_path .. "mineral-deposit-sheet-vivid.png",
        priority = "extra-high",
        size = 128,
        frame_count = 8,
        variation_count = 8,
        scale = 0.5,
        tint = MINERAL_DEPOSIT_TINT,
      },
    },
  },
  {
    type = "autoplace-control",
    category = "resource",
    name = "fw-carbonic-deposit",
    localised_name = { "", "[entity=fw-carbonic-deposit] ", { "autoplace-control-names.fw-carbonic-deposit" } },
    richness = true,
    order = "a-o",
  },
  {
    type = "resource",
    name = "fw-carbonic-deposit",
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
        { type = "item", name = "silicon-ore", amount = 1, probability = 0.70 },
        { type = "item", name = "fw-salt", amount = 1, probability = 0.35 },
      },
    },
    collision_box = { { -0.1, -0.1 }, { 0.1, 0.1 } },
    selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
    autoplace = resource_autoplace.resource_autoplace_settings({
      name = "fw-carbonic-deposit",
      order = "a-o",
      base_density = 7.8,
      base_spots_per_km2 = 0.36,
      has_starting_area_placement = true,
      regular_rq_factor_multiplier = 1.55,
      starting_rq_factor_multiplier = 1.75,
    }),
    stage_counts = { 24000, 14500, 8600, 4800, 2100, 760, 240, 100 },
    stages = {
      sheet = {
        filename = mixed_deposit_path .. "carbonic-deposit-sheet-vivid.png",
        priority = "extra-high",
        size = 128,
        frame_count = 8,
        variation_count = 8,
        scale = 0.5,
        tint = CARBONIC_DEPOSIT_TINT,
      },
    },
  },
})

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

-- Disable legacy standalone ore worldgen so Nauvis stays focused on mixed deposits.
for _, legacy_resource in pairs({ "fw-lead-ore", "fw-bauxite-ore", "fw-titanium-ore" }) do
  if data.raw.resource[legacy_resource] then
    data.raw.resource[legacy_resource].autoplace = nil
  end
end
