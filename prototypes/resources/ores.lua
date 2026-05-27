local resource_autoplace = require("__core__.lualib.resource-autoplace")
local item_sounds = require("__base__.prototypes.item_sounds")

local ORE_RARITY = {
  ["fw-lead-ore"] =     { base_density = 5.8, base_spots_per_km2 = 1.4,  starting = true,  regular_rq = 1.25, starting_rq = 1.65 },
  ["fw-bauxite-ore"] =  { base_density = 2.1, base_spots_per_km2 = 0.65, starting = false, regular_rq = 0.90, starting_rq = 1.0 },
  ["fw-titanium-ore"] = { base_density = 1.25, base_spots_per_km2 = 0.42, starting = false, regular_rq = 0.85, starting_rq = 1.0 },
  ["fw-salt"] =         { base_density = 5.5, base_spots_per_km2 = 2.0,  starting = false, regular_rq = 1.85, starting_rq = 1.95 },
}

-- Centralized asset paths so moving graphics later is painless.
local ore_path = "__FluxWorksAssets__/graphics/resources/ores/"
local fluid_path = "__FluxWorksAssets__/graphics/resources/fluids/"

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
  -- Titanium.
  {
    type = "autoplace-control",
    category = "resource",
    name = "fw-titanium-ore",
    localised_name = { "", "[item=titanium-ore] ", { "autoplace-control-names.fw-titanium-ore" } },
    richness = true,
    order = "a-t",
  },
  -- Lead.
  {
    type = "resource",
    name = "fw-titanium-ore",
    icons = {
      { icon = ore_path .. "titanium-ore.png", icon_size = 64, tint = { r = 0.50, g = 0.66, b = 0.80, a = 1 } },
    },
    flags = { "placeable-neutral" },
    order = "a-b-a",
    map_color = { r = 0.42, g = 0.58, b = 0.74 },
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
    stage_counts = { 15000, 9500, 5500, 2900, 1300, 400, 150, 80 },
    stages = {
      sheet = {
        filename = ore_path .. "hr-titanium-ore.png",
        priority = "extra-high",
        size = 128,
        frame_count = 8,
        variation_count = 8,
        scale = 0.5,
        tint = { r = 0.50, g = 0.66, b = 0.80, a = 1 },
      },
    },
  },
  -- Tin.
  {
    type = "item",
    name = "titanium-ore",
    icons = {
      { icon = ore_path .. "titanium-ore.png", icon_size = 64, tint = { r = 0.50, g = 0.66, b = 0.80, a = 1 } },
    },
    pictures = {
      { filename = ore_path .. "titanium-ore.png", size = 64, scale = 0.5, tint = { r = 0.50, g = 0.66, b = 0.80, a = 1 } },
      { filename = ore_path .. "titanium-ore-2.png", size = 64, scale = 0.5, tint = { r = 0.50, g = 0.66, b = 0.80, a = 1 } },
      { filename = ore_path .. "titanium-ore-3.png", size = 64, scale = 0.5, tint = { r = 0.50, g = 0.66, b = 0.80, a = 1 } },
      { filename = ore_path .. "titanium-ore-4.png", size = 64, scale = 0.5, tint = { r = 0.50, g = 0.66, b = 0.80, a = 1 } },
    },
    inventory_move_sound = item_sounds.resource_inventory_move,
    pick_sound = item_sounds.resource_inventory_pickup,
    drop_sound = item_sounds.resource_inventory_move,
    subgroup = "raw-resource",
    order = "z[titanium-ore]",
    stack_size = 50,
  },
  -- Aluminum.
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
  -- Recolored aluminum variant for bauxite.
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
      { icon = ore_path .. "bauxite-ore.png", icon_size = 64, tint = { r = 0.74, g = 0.34, b = 0.24, a = 1 } },
    },
    flags = { "placeable-neutral" },
    order = "a-b-a",
    map_color = { r = 0.70, g = 0.30, b = 0.20 },
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
        tint = { r = 0.74, g = 0.34, b = 0.24, a = 1 },
      },
    },
  },
  {
    type = "item",
    name = "bauxite-ore",
    icons = {
      { icon = ore_path .. "bauxite-ore.png", icon_size = 64, tint = { r = 0.74, g = 0.34, b = 0.24, a = 1 } },
    },
    pictures = {
      { filename = ore_path .. "bauxite-ore.png", size = 64, scale = 0.5, tint = { r = 0.74, g = 0.34, b = 0.24, a = 1 } },
      { filename = ore_path .. "bauxite-ore-2.png", size = 64, scale = 0.5, tint = { r = 0.74, g = 0.34, b = 0.24, a = 1 } },
      { filename = ore_path .. "bauxite-ore-3.png", size = 64, scale = 0.5, tint = { r = 0.74, g = 0.34, b = 0.24, a = 1 } },
      { filename = ore_path .. "bauxite-ore-4.png", size = 64, scale = 0.5, tint = { r = 0.74, g = 0.34, b = 0.24, a = 1 } },
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

      -- Favor wet terrain, but keep a baseline chance so deposits still spawn
      -- on more seeds/maps instead of disappearing entirely.
      autoplace.probability_expression =
        "(" .. autoplace.probability_expression .. ") * (0.25 + 0.75 * clamp((moisture - 0.50) * 2.5, 0, 1))"
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
    -- Early salt source so this chain starts without extra dependencies.
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
