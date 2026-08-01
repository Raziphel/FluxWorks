local util = require("util")

local function has_unlock_effect(effects, recipe_name)
  for _, effect in pairs(effects or {}) do
    if effect.type == "unlock-recipe" and effect.recipe == recipe_name then
      return true
    end
  end
  return false
end

local base_chunk = data.raw["asteroid-chunk"] and data.raw["asteroid-chunk"]["rocket-chunk"]
if not base_chunk then
  return
end

local flux_chunk_item = {
  type = "item",
  name = "fw-flux-asteroid-chunk",
  icon = "__FluxWorksAssets__/graphics/icons/items/fw-flux-asteroid-chunk.png",
  icon_size = 128,
  subgroup = "space-material",
  order = "e[rocket]-f[fw-flux-asteroid-chunk]",
  stack_size = 20,
  weight = 120 * 1000,
}

local flux_chunk = table.deepcopy(base_chunk)
flux_chunk.name = "fw-flux-asteroid-chunk"
flux_chunk.icon = "__FluxWorksAssets__/graphics/icons/items/fw-flux-asteroid-chunk.png"
flux_chunk.icon_size = 128
flux_chunk.localised_description = { "entity-description.fw-flux-asteroid-chunk" }
flux_chunk.order = "a[rocket-chunk]-c[flux]"
flux_chunk.minable = {
  mining_time = 0.35,
  result = "fw-flux-asteroid-chunk",
  mining_particle = "metallic-asteroid-chunk-particle-medium",
}

if flux_chunk.graphics_set and flux_chunk.graphics_set.variations then
  local variations = flux_chunk.graphics_set.variations
  if variations.color_texture then
    variations.color_texture.tint = { r = 0.78, g = 0.35, b = 0.95, a = 1 }
  end
  if variations.normal_map then
    variations.normal_map.tint = { r = 0.86, g = 0.58, b = 1.0, a = 1 }
  end
  if variations.roughness_map then
    variations.roughness_map.tint = { r = 0.70, g = 0.50, b = 0.86, a = 1 }
  end
end

local flux_asteroid = {
  type = "asteroid",
  name = "fw-flux-asteroid",
  localised_description = { "entity-description.fw-flux-asteroid" },
  icon = "__FluxWorksAssets__/graphics/icons/items/fw-flux-asteroid-chunk.png",
  icon_size = 128,
  subgroup = "space-environment",
  order = "e[used-rocket]-c[fw-flux-asteroid]",
  collision_box = { { -7.5, -7.5 }, { 7.5, 7.5 } },
  selection_box = { { -7.5, -7.5 }, { 7.5, 7.5 } },
  collision_mask = { layers = { object = true }, not_colliding_with_itself = true },
  flags = { "placeable-enemy", "placeable-off-grid", "not-repairable", "not-on-map" },
  max_health = 3000,
  damage_per_hp = 1.5,
  resistances = {
    { type = "physical", decrease = 0, percent = 45 },
    { type = "electric", decrease = 0, percent = 100 },
    { type = "laser", decrease = 0, percent = 80 },
    { type = "explosion", decrease = 0, percent = 55 },
    { type = "fire", decrease = 0, percent = 100 },
  },
  graphics_set = {
    rotation_speed = 0.0009,
    normal_strength = 0.35,
    ambient_light = { 1.0, 1.0, 1.0 },
    brightness = 0.35,
    variations = {
      color_texture = {
        filename = "__FluxWorksAssets__/graphics/resources/asteroids/fw-used-rocket.png",
        width = 353,
        height = 829,
        scale = 1,
        tint = { r = 0.76, g = 0.34, b = 0.95, a = 1 },
      },
      normal_map = {
        filename = "__FluxWorksAssets__/graphics/resources/asteroids/fw-used-rocket-normal.png",
        premul_alpha = false,
        width = 353,
        height = 829,
        scale = 1,
      },
      roughness_map = {
        filename = "__FluxWorksAssets__/graphics/resources/asteroids/fw-used-rocket-roughness.png",
        premul_alpha = false,
        width = 353,
        height = 829,
        scale = 1,
      },
    },
  },
  dying_trigger_effect = {
    {
      type = "create-asteroid-chunk",
      asteroid_name = "fw-flux-asteroid-chunk",
      offset_deviation = { { -3, -3 }, { 3, 3 } },
      offsets = {
        { -1.8, -1.4 },
        { 2.2, 0.8 },
        { -2.6, 0.2 },
      },
    },
  },
}

local flux_chunk_refining = {
  type = "recipe",
  name = "fw-flux-asteroid-refining",
  icon = "__FluxWorksAssets__/graphics/icons/items/fw-flux-asteroid-chunk.png",
  icon_size = 128,
  category = "crushing",
  subgroup = "space-crushing",
  order = "b-a-e[fw-flux-asteroid-refining]",
  enabled = false,
  auto_recycle = false,
  energy_required = 3,
  ingredients = {
    { type = "item", name = "fw-flux-asteroid-chunk", amount = 1 },
  },
  results = {
    { type = "item", name = "fw-crystalised-flux", amount_min = 8, amount_max = 14 },
    { type = "item", name = "fw-stabilized-flux-crystal", amount_min = 1, amount_max = 2 },
    { type = "item", name = "fw-flux-catalyst", amount = 1, probability = 0.4 },
  },
  allow_productivity = true,
  allow_decomposition = false,
}

data:extend({ flux_chunk_item, flux_chunk, flux_asteroid, flux_chunk_refining })

local rocket_chunk_processing = data.raw.recipe and data.raw.recipe["rocket-chunk-processing"]
if rocket_chunk_processing then
  rocket_chunk_processing.results = rocket_chunk_processing.results or {}
  table.insert(rocket_chunk_processing.results, { type = "item", name = "fw-flux-asteroid-chunk", amount = 1, probability = 0.2 })
end

local flux_asteroid_tech = data.raw.technology and data.raw.technology["fw-flux-asteroid-harvesting"]
if flux_asteroid_tech then
  flux_asteroid_tech.effects = flux_asteroid_tech.effects or {}
  if not has_unlock_effect(flux_asteroid_tech.effects, "fw-flux-asteroid-refining") then
    table.insert(flux_asteroid_tech.effects, { type = "unlock-recipe", recipe = "fw-flux-asteroid-refining" })
  end
end
