local effects = require("__core__/lualib/surface-render-parameter-effects")
local tile_collision_masks = require("__base__/prototypes/tile/tile-collision-masks")
local tile_graphics = require("__base__/prototypes/tile/tile-graphics")
local tile_pollution = require("__base__/prototypes/tile/tile-pollution-values")
local tile_sounds = require("__base__/prototypes/tile/tile-sounds")
local tile_trigger_effects = require("__space-age__/prototypes/tile/tile-trigger-effects")

local tile_spritesheet_layout = tile_graphics.tile_spritesheet_layout
local tile_layer_offset = 60
local shattered_surface_width = 3200
local shattered_surface_height = 3200
local alien_biomes_loaded = mods["alien-biomes-graphics"] ~= nil

local function shattered_tile_texture(alien_biomes_texture, fallback_texture)
  if alien_biomes_loaded then
    return alien_biomes_texture
  end

  return fallback_texture
end

local empty_space_transitions =
{
  {
    to_tiles = { "out-of-map", "empty-space" },
    transition_group = out_of_map_transition_group_id,
    background_layer_offset = 1,
    background_layer_group = "zero",
    offset_background_layer_by_tile_layer = true,
    spritesheet = "__space-age__/graphics/terrain/out-of-map-transition/volcanic-out-of-map-transition.png",
    layout = tile_spritesheet_layout.transition_4_4_8_1_1,
    overlay_enabled = false,
  },
}

local empty_space_transitions_between_transitions =
{
  {
    transition_group1 = default_transition_group_id,
    transition_group2 = out_of_map_transition_group_id,
    background_layer_offset = 1,
    background_layer_group = "zero",
    offset_background_layer_by_tile_layer = true,
    spritesheet = "__space-age__/graphics/terrain/out-of-map-transition/volcanic-out-of-map-transition-transition.png",
    layout = tile_spritesheet_layout.transition_3_3_3_1_0,
    overlay_enabled = false,
  },
}

data:extend({
  {
    type = "noise-expression",
    name = "fw_shattered_sample_x",
    expression = "x + 36 * basis_noise{x = x, y = y, seed0 = map_seed, seed1 = 4101, input_scale = 1/140, output_scale = 1}",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_sample_y",
    expression = "y + 36 * basis_noise{x = x, y = y, seed0 = map_seed, seed1 = 4102, input_scale = 1/140, output_scale = 1}",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_distance",
    expression = "sqrt(fw_shattered_sample_x * fw_shattered_sample_x + fw_shattered_sample_y * fw_shattered_sample_y)",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_edge_mask",
    expression = "clamp((" .. (shattered_surface_width / 2 - 300) .. " - fw_shattered_distance) / 104, 0, 1)",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_fracture_noise_a",
    expression = "abs(multioctave_noise{x = x, y = y, persistence = 0.72, seed0 = map_seed, seed1 = 4201, octaves = 4, input_scale = 1/42, output_scale = 1})",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_fracture_noise_b",
    expression = "abs(multioctave_noise{x = x, y = y, persistence = 0.70, seed0 = map_seed, seed1 = 4202, octaves = 3, input_scale = 1/70, output_scale = 1})",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_peak_noise",
    expression = "abs(multioctave_noise{x = x, y = y, persistence = 0.74, seed0 = map_seed, seed1 = 4203, octaves = 4, input_scale = 1/36, output_scale = 1})",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_fracture_mask",
    expression = "clamp(max((fw_shattered_fracture_noise_a - 0.57) * 3.2, (fw_shattered_fracture_noise_b - 0.61) * 3.6), 0, 1)",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_ribbon_cut",
    expression = "clamp((abs(basis_noise{x = x, y = y, seed0 = map_seed, seed1 = 4215, input_scale = 1/50, output_scale = 1}) - 0.225) * 3.1, 0, 1)",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_shelf_fill",
    expression = "0.065 * fw_shattered_edge_mask * (0.55 + 0.45 * abs(multioctave_noise{x = x, y = y, persistence = 0.69, seed0 = map_seed, seed1 = 4216, octaves = 3, input_scale = 1/90, output_scale = 1}))",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_decorative_knockout",
    expression = "0.5 + 0.5 * multioctave_noise{x = x, y = y, persistence = 0.72, seed0 = map_seed, seed1 = 4510, octaves = 3, input_scale = 1/18, output_scale = 1}",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_red_raw",
    expression = "max(0, fw_shattered_edge_mask * max(1.22 - sqrt((fw_shattered_sample_x + 238) * (fw_shattered_sample_x + 238) + (fw_shattered_sample_y - 206) * (fw_shattered_sample_y - 206)) / 126, 1.04 - sqrt((fw_shattered_sample_x + 336) * (fw_shattered_sample_x + 336) + (fw_shattered_sample_y - 296) * (fw_shattered_sample_y - 296)) / 74, 0.97 - sqrt((fw_shattered_sample_x + 350) * (fw_shattered_sample_x + 350) + (fw_shattered_sample_y - 108) * (fw_shattered_sample_y - 108)) / 58, 0.90 - sqrt((fw_shattered_sample_x + 156) * (fw_shattered_sample_x + 156) + (fw_shattered_sample_y - 342) * (fw_shattered_sample_y - 342)) / 50, 0.84 - sqrt((fw_shattered_sample_x + 286) * (fw_shattered_sample_x + 286) + (fw_shattered_sample_y - 84) * (fw_shattered_sample_y - 84)) / 40, 0.82 - sqrt((fw_shattered_sample_x + 122) * (fw_shattered_sample_x + 122) + (fw_shattered_sample_y - 236) * (fw_shattered_sample_y - 236)) / 36, 0.79 - sqrt((fw_shattered_sample_x + 392) * (fw_shattered_sample_x + 392) + (fw_shattered_sample_y - 192) * (fw_shattered_sample_y - 192)) / 32, 0.68 - sqrt((fw_shattered_sample_x + 442) * (fw_shattered_sample_x + 442) + (fw_shattered_sample_y - 248) * (fw_shattered_sample_y - 248)) / 20, 0.66 - sqrt((fw_shattered_sample_x + 418) * (fw_shattered_sample_x + 418) + (fw_shattered_sample_y - 118) * (fw_shattered_sample_y - 118)) / 18, 0.64 - sqrt((fw_shattered_sample_x + 306) * (fw_shattered_sample_x + 306) + (fw_shattered_sample_y - 366) * (fw_shattered_sample_y - 366)) / 18, 0.62 - sqrt((fw_shattered_sample_x + 206) * (fw_shattered_sample_x + 206) + (fw_shattered_sample_y - 404) * (fw_shattered_sample_y - 404)) / 16, 0.60 - sqrt((fw_shattered_sample_x + 96) * (fw_shattered_sample_x + 96) + (fw_shattered_sample_y - 302) * (fw_shattered_sample_y - 302)) / 15, 0.62 - sqrt((fw_shattered_sample_x + 520) * (fw_shattered_sample_x + 520) + (fw_shattered_sample_y - 320) * (fw_shattered_sample_y - 320)) / 18, 0.60 - sqrt((fw_shattered_sample_x + 504) * (fw_shattered_sample_x + 504) + (fw_shattered_sample_y - 170) * (fw_shattered_sample_y - 170)) / 17, 0.58 - sqrt((fw_shattered_sample_x + 430) * (fw_shattered_sample_x + 430) + (fw_shattered_sample_y - 420) * (fw_shattered_sample_y - 420)) / 16, 0.56 - sqrt((fw_shattered_sample_x + 300) * (fw_shattered_sample_x + 300) + (fw_shattered_sample_y - 470) * (fw_shattered_sample_y - 470)) / 15, 0.54 - sqrt((fw_shattered_sample_x + 170) * (fw_shattered_sample_x + 170) + (fw_shattered_sample_y - 430) * (fw_shattered_sample_y - 430)) / 14, 0.52 - sqrt((fw_shattered_sample_x + 70) * (fw_shattered_sample_x + 70) + (fw_shattered_sample_y - 340) * (fw_shattered_sample_y - 340)) / 13) - 0.34 * fw_shattered_fracture_mask - 0.16 * fw_shattered_ribbon_cut + fw_shattered_shelf_fill + 0.05 * basis_noise{x = x, y = y, seed0 = map_seed, seed1 = 4401, input_scale = 1/110, output_scale = 1})",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_purple_raw",
    expression = "max(0, fw_shattered_edge_mask * max(1.22 - sqrt((fw_shattered_sample_x - 236) * (fw_shattered_sample_x - 236) + (fw_shattered_sample_y - 208) * (fw_shattered_sample_y - 208)) / 126, 1.04 - sqrt((fw_shattered_sample_x - 334) * (fw_shattered_sample_x - 334) + (fw_shattered_sample_y - 298) * (fw_shattered_sample_y - 298)) / 74, 0.97 - sqrt((fw_shattered_sample_x - 348) * (fw_shattered_sample_x - 348) + (fw_shattered_sample_y - 110) * (fw_shattered_sample_y - 110)) / 58, 0.90 - sqrt((fw_shattered_sample_x - 154) * (fw_shattered_sample_x - 154) + (fw_shattered_sample_y - 344) * (fw_shattered_sample_y - 344)) / 50, 0.84 - sqrt((fw_shattered_sample_x - 284) * (fw_shattered_sample_x - 284) + (fw_shattered_sample_y - 86) * (fw_shattered_sample_y - 86)) / 40, 0.82 - sqrt((fw_shattered_sample_x - 120) * (fw_shattered_sample_x - 120) + (fw_shattered_sample_y - 238) * (fw_shattered_sample_y - 238)) / 36, 0.79 - sqrt((fw_shattered_sample_x - 390) * (fw_shattered_sample_x - 390) + (fw_shattered_sample_y - 194) * (fw_shattered_sample_y - 194)) / 32, 0.68 - sqrt((fw_shattered_sample_x - 440) * (fw_shattered_sample_x - 440) + (fw_shattered_sample_y - 250) * (fw_shattered_sample_y - 250)) / 20, 0.66 - sqrt((fw_shattered_sample_x - 416) * (fw_shattered_sample_x - 416) + (fw_shattered_sample_y - 120) * (fw_shattered_sample_y - 120)) / 18, 0.64 - sqrt((fw_shattered_sample_x - 304) * (fw_shattered_sample_x - 304) + (fw_shattered_sample_y - 368) * (fw_shattered_sample_y - 368)) / 18, 0.62 - sqrt((fw_shattered_sample_x - 204) * (fw_shattered_sample_x - 204) + (fw_shattered_sample_y - 406) * (fw_shattered_sample_y - 406)) / 16, 0.60 - sqrt((fw_shattered_sample_x - 94) * (fw_shattered_sample_x - 94) + (fw_shattered_sample_y - 304) * (fw_shattered_sample_y - 304)) / 15, 0.62 - sqrt((fw_shattered_sample_x - 518) * (fw_shattered_sample_x - 518) + (fw_shattered_sample_y - 322) * (fw_shattered_sample_y - 322)) / 18, 0.60 - sqrt((fw_shattered_sample_x - 502) * (fw_shattered_sample_x - 502) + (fw_shattered_sample_y - 172) * (fw_shattered_sample_y - 172)) / 17, 0.58 - sqrt((fw_shattered_sample_x - 428) * (fw_shattered_sample_x - 428) + (fw_shattered_sample_y - 422) * (fw_shattered_sample_y - 422)) / 16, 0.56 - sqrt((fw_shattered_sample_x - 298) * (fw_shattered_sample_x - 298) + (fw_shattered_sample_y - 472) * (fw_shattered_sample_y - 472)) / 15, 0.54 - sqrt((fw_shattered_sample_x - 168) * (fw_shattered_sample_x - 168) + (fw_shattered_sample_y - 432) * (fw_shattered_sample_y - 432)) / 14, 0.52 - sqrt((fw_shattered_sample_x - 68) * (fw_shattered_sample_x - 68) + (fw_shattered_sample_y - 342) * (fw_shattered_sample_y - 342)) / 13) - 0.34 * fw_shattered_fracture_mask - 0.16 * fw_shattered_ribbon_cut + fw_shattered_shelf_fill + 0.05 * basis_noise{x = x, y = y, seed0 = map_seed, seed1 = 4402, input_scale = 1/110, output_scale = 1})",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_yellow_raw",
    expression = "max(0, fw_shattered_edge_mask * max(1.20 - sqrt((fw_shattered_sample_x - 242) * (fw_shattered_sample_x - 242) + (fw_shattered_sample_y + 202) * (fw_shattered_sample_y + 202)) / 126, 1.04 - sqrt((fw_shattered_sample_x - 340) * (fw_shattered_sample_x - 340) + (fw_shattered_sample_y + 290) * (fw_shattered_sample_y + 290)) / 74, 0.97 - sqrt((fw_shattered_sample_x - 354) * (fw_shattered_sample_x - 354) + (fw_shattered_sample_y + 104) * (fw_shattered_sample_y + 104)) / 58, 0.90 - sqrt((fw_shattered_sample_x - 160) * (fw_shattered_sample_x - 160) + (fw_shattered_sample_y + 336) * (fw_shattered_sample_y + 336)) / 50, 0.84 - sqrt((fw_shattered_sample_x - 290) * (fw_shattered_sample_x - 290) + (fw_shattered_sample_y + 80) * (fw_shattered_sample_y + 80)) / 40, 0.82 - sqrt((fw_shattered_sample_x - 126) * (fw_shattered_sample_x - 126) + (fw_shattered_sample_y + 230) * (fw_shattered_sample_y + 230)) / 36, 0.79 - sqrt((fw_shattered_sample_x - 396) * (fw_shattered_sample_x - 396) + (fw_shattered_sample_y + 186) * (fw_shattered_sample_y + 186)) / 32, 0.68 - sqrt((fw_shattered_sample_x - 446) * (fw_shattered_sample_x - 446) + (fw_shattered_sample_y + 240) * (fw_shattered_sample_y + 240)) / 20, 0.66 - sqrt((fw_shattered_sample_x - 422) * (fw_shattered_sample_x - 422) + (fw_shattered_sample_y + 112) * (fw_shattered_sample_y + 112)) / 18, 0.64 - sqrt((fw_shattered_sample_x - 310) * (fw_shattered_sample_x - 310) + (fw_shattered_sample_y + 360) * (fw_shattered_sample_y + 360)) / 18, 0.62 - sqrt((fw_shattered_sample_x - 210) * (fw_shattered_sample_x - 210) + (fw_shattered_sample_y + 398) * (fw_shattered_sample_y + 398)) / 16, 0.60 - sqrt((fw_shattered_sample_x - 100) * (fw_shattered_sample_x - 100) + (fw_shattered_sample_y + 296) * (fw_shattered_sample_y + 296)) / 15, 0.62 - sqrt((fw_shattered_sample_x - 524) * (fw_shattered_sample_x - 524) + (fw_shattered_sample_y + 312) * (fw_shattered_sample_y + 312)) / 18, 0.60 - sqrt((fw_shattered_sample_x - 500) * (fw_shattered_sample_x - 500) + (fw_shattered_sample_y + 164) * (fw_shattered_sample_y + 164)) / 17, 0.58 - sqrt((fw_shattered_sample_x - 426) * (fw_shattered_sample_x - 426) + (fw_shattered_sample_y + 414) * (fw_shattered_sample_y + 414)) / 16, 0.56 - sqrt((fw_shattered_sample_x - 296) * (fw_shattered_sample_x - 296) + (fw_shattered_sample_y + 464) * (fw_shattered_sample_y + 464)) / 15, 0.54 - sqrt((fw_shattered_sample_x - 166) * (fw_shattered_sample_x - 166) + (fw_shattered_sample_y + 424) * (fw_shattered_sample_y + 424)) / 14, 0.52 - sqrt((fw_shattered_sample_x - 66) * (fw_shattered_sample_x - 66) + (fw_shattered_sample_y + 334) * (fw_shattered_sample_y + 334)) / 13) - 0.34 * fw_shattered_fracture_mask - 0.16 * fw_shattered_ribbon_cut + fw_shattered_shelf_fill + 0.05 * basis_noise{x = x, y = y, seed0 = map_seed, seed1 = 4403, input_scale = 1/110, output_scale = 1})",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_green_raw",
    expression = "max(0, fw_shattered_edge_mask * max(1.20 - sqrt((fw_shattered_sample_x + 240) * (fw_shattered_sample_x + 240) + (fw_shattered_sample_y + 204) * (fw_shattered_sample_y + 204)) / 126, 1.04 - sqrt((fw_shattered_sample_x + 338) * (fw_shattered_sample_x + 338) + (fw_shattered_sample_y + 292) * (fw_shattered_sample_y + 292)) / 74, 0.97 - sqrt((fw_shattered_sample_x + 352) * (fw_shattered_sample_x + 352) + (fw_shattered_sample_y + 106) * (fw_shattered_sample_y + 106)) / 58, 0.90 - sqrt((fw_shattered_sample_x + 158) * (fw_shattered_sample_x + 158) + (fw_shattered_sample_y + 338) * (fw_shattered_sample_y + 338)) / 50, 0.84 - sqrt((fw_shattered_sample_x + 288) * (fw_shattered_sample_x + 288) + (fw_shattered_sample_y + 82) * (fw_shattered_sample_y + 82)) / 40, 0.82 - sqrt((fw_shattered_sample_x + 124) * (fw_shattered_sample_x + 124) + (fw_shattered_sample_y + 232) * (fw_shattered_sample_y + 232)) / 36, 0.79 - sqrt((fw_shattered_sample_x + 394) * (fw_shattered_sample_x + 394) + (fw_shattered_sample_y + 188) * (fw_shattered_sample_y + 188)) / 32, 0.68 - sqrt((fw_shattered_sample_x + 444) * (fw_shattered_sample_x + 444) + (fw_shattered_sample_y + 242) * (fw_shattered_sample_y + 242)) / 20, 0.66 - sqrt((fw_shattered_sample_x + 420) * (fw_shattered_sample_x + 420) + (fw_shattered_sample_y + 114) * (fw_shattered_sample_y + 114)) / 18, 0.64 - sqrt((fw_shattered_sample_x + 308) * (fw_shattered_sample_x + 308) + (fw_shattered_sample_y + 362) * (fw_shattered_sample_y + 362)) / 18, 0.62 - sqrt((fw_shattered_sample_x + 208) * (fw_shattered_sample_x + 208) + (fw_shattered_sample_y + 400) * (fw_shattered_sample_y + 400)) / 16, 0.60 - sqrt((fw_shattered_sample_x + 98) * (fw_shattered_sample_x + 98) + (fw_shattered_sample_y + 298) * (fw_shattered_sample_y + 298)) / 15, 0.62 - sqrt((fw_shattered_sample_x + 522) * (fw_shattered_sample_x + 522) + (fw_shattered_sample_y + 314) * (fw_shattered_sample_y + 314)) / 18, 0.60 - sqrt((fw_shattered_sample_x + 498) * (fw_shattered_sample_x + 498) + (fw_shattered_sample_y + 166) * (fw_shattered_sample_y + 166)) / 17, 0.58 - sqrt((fw_shattered_sample_x + 424) * (fw_shattered_sample_x + 424) + (fw_shattered_sample_y + 416) * (fw_shattered_sample_y + 416)) / 16, 0.56 - sqrt((fw_shattered_sample_x + 294) * (fw_shattered_sample_x + 294) + (fw_shattered_sample_y + 466) * (fw_shattered_sample_y + 466)) / 15, 0.54 - sqrt((fw_shattered_sample_x + 164) * (fw_shattered_sample_x + 164) + (fw_shattered_sample_y + 426) * (fw_shattered_sample_y + 426)) / 14, 0.52 - sqrt((fw_shattered_sample_x + 64) * (fw_shattered_sample_x + 64) + (fw_shattered_sample_y + 336) * (fw_shattered_sample_y + 336)) / 13) - 0.34 * fw_shattered_fracture_mask - 0.16 * fw_shattered_ribbon_cut + fw_shattered_shelf_fill + 0.05 * basis_noise{x = x, y = y, seed0 = map_seed, seed1 = 4404, input_scale = 1/110, output_scale = 1})",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_land_mask",
    expression = "clamp(max(fw_shattered_red_raw, fw_shattered_purple_raw, fw_shattered_yellow_raw, fw_shattered_green_raw) + 0.02 * fw_shattered_edge_mask, 0, 1)",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_elevation",
    expression = "180 * fw_shattered_land_mask + 46 * clamp((fw_shattered_land_mask - 0.30) * 1.8, 0, 1) * fw_shattered_peak_noise - 120 * (1 - fw_shattered_land_mask)",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_cliffiness",
    expression = "0.62 * clamp((fw_shattered_land_mask - 0.28) * 1.8, 0, 1) * (0.55 + 0.55 * fw_shattered_peak_noise)",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_aux",
    expression = "0.5 + 0.20 * basis_noise{x = x, y = y, seed0 = map_seed, seed1 = 4301, input_scale = 1/180, output_scale = 1}",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_temperature",
    expression = "0.5 + 0.20 * basis_noise{x = x, y = y, seed0 = map_seed, seed1 = 4302, input_scale = 1/180, output_scale = 1}",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_red_biome",
    expression = "clamp((fw_shattered_red_raw - 0.115) * 5.4, 0, 1)",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_purple_biome",
    expression = "clamp((fw_shattered_purple_raw - 0.115) * 5.4, 0, 1)",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_yellow_biome",
    expression = "clamp((fw_shattered_yellow_raw - 0.115) * 5.4, 0, 1)",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_green_biome",
    expression = "clamp((fw_shattered_green_raw - 0.115) * 5.4, 0, 1)",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_space_probability",
    expression = "clamp(1 - clamp((fw_shattered_land_mask - 0.085) * 5.0, 0, 1), 0, 1)",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_red_tile_probability",
    expression = "fw_shattered_red_biome",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_purple_tile_probability",
    expression = "fw_shattered_purple_biome",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_yellow_tile_probability",
    expression = "fw_shattered_yellow_biome",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_green_tile_probability",
    expression = "fw_shattered_green_biome",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_red_vent_probability",
    expression = "(control:fw_shattered_flux_vents:size > 0) * 0.00085 * clamp((fw_shattered_red_biome - 0.48) * 2.1, 0, 1) * (0.50 + 0.35 * abs(multioctave_noise{x = x, y = y, persistence = 0.7, seed0 = map_seed, seed1 = 4501, octaves = 2, input_scale = 1/15}))",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_red_vent_richness",
    expression = "(fw_shattered_red_biome > 0) * 125000 * control:fw_shattered_flux_vents:richness",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_purple_vent_probability",
    expression = "(control:fw_shattered_flux_vents:size > 0) * 0.00085 * clamp((fw_shattered_purple_biome - 0.48) * 2.1, 0, 1) * (0.50 + 0.35 * abs(multioctave_noise{x = x, y = y, persistence = 0.7, seed0 = map_seed, seed1 = 4502, octaves = 2, input_scale = 1/15}))",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_purple_vent_richness",
    expression = "(fw_shattered_purple_biome > 0) * 125000 * control:fw_shattered_flux_vents:richness",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_yellow_vent_probability",
    expression = "(control:fw_shattered_flux_vents:size > 0) * 0.00085 * clamp((fw_shattered_yellow_biome - 0.48) * 2.1, 0, 1) * (0.50 + 0.35 * abs(multioctave_noise{x = x, y = y, persistence = 0.7, seed0 = map_seed, seed1 = 4503, octaves = 2, input_scale = 1/15}))",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_yellow_vent_richness",
    expression = "(fw_shattered_yellow_biome > 0) * 125000 * control:fw_shattered_flux_vents:richness",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_green_vent_probability",
    expression = "(control:fw_shattered_flux_vents:size > 0) * 0.00085 * clamp((fw_shattered_green_biome - 0.48) * 2.1, 0, 1) * (0.50 + 0.35 * abs(multioctave_noise{x = x, y = y, persistence = 0.7, seed0 = map_seed, seed1 = 4504, octaves = 2, input_scale = 1/15}))",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_green_vent_richness",
    expression = "(fw_shattered_green_biome > 0) * 125000 * control:fw_shattered_flux_vents:richness",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_tiny_rock_probability",
    expression = "0.18 * clamp((fw_shattered_land_mask - 0.12) * 1.7, 0, 1) * clamp(0.90 - fw_shattered_decorative_knockout, 0, 1)",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_small_rock_probability",
    expression = "0.12 * clamp((fw_shattered_land_mask - 0.18) * 1.9, 0, 1) * clamp(0.76 - fw_shattered_decorative_knockout, 0, 1)",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_medium_rock_probability",
    expression = "0.07 * clamp((fw_shattered_land_mask - 0.22) * 2.0, 0, 1) * clamp(0.62 - fw_shattered_decorative_knockout, 0, 1)",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_light_mud_decal_probability",
    expression = "0.055 * clamp(fw_shattered_fracture_mask + 0.25 * fw_shattered_ribbon_cut - 0.42 * fw_shattered_decorative_knockout, 0, 1)",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_yellow_sand_decal_probability",
    expression = "0.16 * clamp((fw_shattered_yellow_biome - 0.24) * 1.6, 0, 1) * clamp(0.86 - fw_shattered_decorative_knockout, 0, 1)",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_yellow_sand_dune_probability",
    expression = "0.08 * clamp((fw_shattered_yellow_biome - 0.32) * 1.7, 0, 1) * clamp(0.68 - fw_shattered_decorative_knockout, 0, 1)",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_yellow_brown_asterisk_probability",
    expression = "0.12 * clamp((fw_shattered_yellow_biome - 0.28) * 1.7, 0, 1) * clamp(0.66 - fw_shattered_decorative_knockout, 0, 1)",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_yellow_brown_fluff_probability",
    expression = "0.10 * clamp((fw_shattered_yellow_biome - 0.26) * 1.6, 0, 1) * clamp(0.68 - fw_shattered_decorative_knockout, 0, 1)",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_red_bush_probability",
    expression = "0.10 * clamp((fw_shattered_red_biome - 0.28) * 1.7, 0, 1) * clamp(0.64 - fw_shattered_decorative_knockout, 0, 1)",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_red_croton_probability",
    expression = "0.12 * clamp((fw_shattered_red_biome - 0.26) * 1.7, 0, 1) * clamp(0.70 - fw_shattered_decorative_knockout, 0, 1)",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_red_asterisk_probability",
    expression = "0.10 * clamp((fw_shattered_red_biome - 0.28) * 1.7, 0, 1) * clamp(0.68 - fw_shattered_decorative_knockout, 0, 1)",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_green_pita_probability",
    expression = "0.13 * clamp((fw_shattered_green_biome - 0.24) * 1.7, 0, 1) * clamp(0.70 - fw_shattered_decorative_knockout, 0, 1)",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_green_pita_mini_probability",
    expression = "0.10 * clamp((fw_shattered_green_biome - 0.22) * 1.7, 0, 1) * clamp(0.74 - fw_shattered_decorative_knockout, 0, 1)",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_green_croton_probability",
    expression = "0.12 * clamp((fw_shattered_green_biome - 0.26) * 1.7, 0, 1) * clamp(0.70 - fw_shattered_decorative_knockout, 0, 1)",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_purple_ice_decal_probability",
    expression = "0.09 * clamp((fw_shattered_purple_biome - 0.26) * 1.7, 0, 1) * clamp(0.72 - fw_shattered_decorative_knockout + 0.12 * fw_shattered_peak_noise, 0, 1)",
  },
  {
    type = "noise-expression",
    name = "fw_shattered_purple_snowy_decal_probability",
    expression = "0.05 * clamp((fw_shattered_purple_biome - 0.30) * 1.7, 0, 1) * clamp(0.60 - fw_shattered_decorative_knockout + 0.16 * fw_shattered_peak_noise, 0, 1)",
  },
})

local function make_tile(name, order, layer, map_color, texture, probability_expression)
  return {
    type = "tile",
    name = name,
    order = order,
    collision_mask = tile_collision_masks.ground(),
    layer = layer,
    sprite_usage_surface = "nauvis",
    autoplace = { probability_expression = probability_expression },
    variants = tile_variations_template_with_transitions(texture, {
      max_size = 4,
      [1] = { weights = { 0.085, 0.085, 0.085, 0.085, 0.087, 0.085, 0.065, 0.085, 0.045, 0.045, 0.045, 0.045, 0.005, 0.025, 0.045, 0.045 } },
      [2] = { probability = 1, weights = { 0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025, 0.020, 0.025, 0.025, 0.010 } },
      [4] = { probability = 0.1, weights = { 0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025, 0.020, 0.025, 0.025, 0.010 } },
    }),
    transitions = empty_space_transitions,
    transitions_between_transitions = empty_space_transitions_between_transitions,
    walking_sound = tile_sounds.walking.grass,
    driving_sound = tile_sounds.driving.dirt,
    map_color = map_color,
    scorch_mark_color = { 0.35, 0.28, 0.24 },
    absorptions_per_second = tile_pollution.grass,
    vehicle_friction_modifier = 1.3,
    trigger_effect = tile_trigger_effects.grass_1_trigger_effect(),
  }
end

local function make_space_tile()
  local tile = table.deepcopy(data.raw.tile["empty-space"])
  tile.name = "fw-shattered-space"
  tile.order = "z[other]-a[fw-shattered-space]"
  tile.autoplace = { probability_expression = "fw_shattered_space_probability" }
  tile.map_color = { 0, 0, 0 }
  return tile
end

data:extend({
  make_space_tile(),
  make_tile(
    "fw-shattered-red-land",
    "b[natural]-z[shattered]-a[red]",
    tile_layer_offset + 1,
    { 176, 74, 58 },
    shattered_tile_texture(
      "__alien-biomes-graphics__/graphics/terrain/mineral-red-dirt-1.png",
      "__base__/graphics/terrain/red-desert-0.png"
    ),
    "fw_shattered_red_tile_probability"
  ),
  make_tile(
    "fw-shattered-purple-land",
    "b[natural]-z[shattered]-b[purple]",
    tile_layer_offset + 2,
    { 166, 126, 201 },
    shattered_tile_texture(
      "__alien-biomes-graphics__/graphics/terrain/vegetation-purple-grass-1.png",
      "__base__/graphics/terrain/dirt-1.png"
    ),
    "fw_shattered_purple_tile_probability"
  ),
  make_tile(
    "fw-shattered-yellow-land",
    "b[natural]-z[shattered]-c[yellow]",
    tile_layer_offset + 3,
    { 222, 196, 94 },
    shattered_tile_texture(
      "__alien-biomes-graphics__/graphics/terrain/vegetation-yellow-grass-1.png",
      "__base__/graphics/terrain/grass-1.png"
    ),
    "fw_shattered_yellow_tile_probability"
  ),
  make_tile(
    "fw-shattered-green-land",
    "b[natural]-z[shattered]-d[green]",
    tile_layer_offset + 4,
    { 79, 187, 77 },
    shattered_tile_texture(
      "__alien-biomes-graphics__/graphics/terrain/vegetation-green-grass-1.png",
      "__base__/graphics/terrain/grass-1.png"
    ),
    "fw_shattered_green_tile_probability"
  ),
})

local shattered_location = data.raw["space-location"] and data.raw["space-location"]["shattered-planet"]

if shattered_location then
  data.raw["space-location"]["shattered-planet"] = nil
end

local shattered_planet = table.deepcopy(data.raw.planet["nauvis"])

shattered_planet.name = "shattered-planet"
shattered_planet.icon = "__space-age__/graphics/icons/shattered-planet.png"
shattered_planet.starmap_icon = "__space-age__/graphics/icons/starmap-shattered-planet.png"
shattered_planet.starmap_icon_size = 512
shattered_planet.gravity_pull = 10
shattered_planet.distance = shattered_location and shattered_location.distance or 35
shattered_planet.orientation = shattered_location and shattered_location.orientation or 0.245
shattered_planet.magnitude = shattered_location and shattered_location.magnitude or 0.7
shattered_planet.label_orientation = 0.18
shattered_planet.order = "e[shattered-planet]"
shattered_planet.subgroup = "planets"
shattered_planet.map_seed_offset = 42000
shattered_planet.pollutant_type = nil
shattered_planet.auto_save_on_first_trip = true
shattered_planet.solar_power_in_space = shattered_location and shattered_location.solar_power_in_space or 60
shattered_planet.asteroid_spawn_influence = shattered_location and shattered_location.asteroid_spawn_influence or 1
shattered_planet.asteroid_spawn_definitions = shattered_location and shattered_location.asteroid_spawn_definitions or nil
shattered_planet.surface_properties = {
  ["day-night-cycle"] = 6 * minute,
  ["solar-power"] = 80,
  pressure = 100,
  gravity = 8,
}
shattered_planet.surface_render_parameters = {
  fog = effects.default_fog_effect_properties(),
}
shattered_planet.map_gen_settings = {
  width = shattered_surface_width,
  height = shattered_surface_height,
  property_expression_names = {
    elevation = "fw_shattered_elevation",
    temperature = "fw_shattered_temperature",
    moisture = 0.5,
    aux = "fw_shattered_aux",
    cliffiness = "fw_shattered_cliffiness",
    cliff_elevation = "cliff_elevation_from_elevation",
    ["entity:fw-shattered-yellow-flux-vent:probability"] = "fw_shattered_yellow_vent_probability",
    ["entity:fw-shattered-yellow-flux-vent:richness"] = "fw_shattered_yellow_vent_richness",
    ["entity:fw-shattered-red-flux-vent:probability"] = "fw_shattered_red_vent_probability",
    ["entity:fw-shattered-red-flux-vent:richness"] = "fw_shattered_red_vent_richness",
    ["entity:fw-shattered-green-flux-vent:probability"] = "fw_shattered_green_vent_probability",
    ["entity:fw-shattered-green-flux-vent:richness"] = "fw_shattered_green_vent_richness",
    ["entity:fw-shattered-purple-flux-vent:probability"] = "fw_shattered_purple_vent_probability",
    ["entity:fw-shattered-purple-flux-vent:richness"] = "fw_shattered_purple_vent_richness",
    ["decorative:tiny-rock:probability"] = "fw_shattered_tiny_rock_probability",
    ["decorative:small-rock:probability"] = "fw_shattered_small_rock_probability",
    ["decorative:medium-rock:probability"] = "fw_shattered_medium_rock_probability",
    ["decorative:light-mud-decal:probability"] = "fw_shattered_light_mud_decal_probability",
    ["decorative:sand-decal:probability"] = "fw_shattered_yellow_sand_decal_probability",
    ["decorative:sand-dune-decal:probability"] = "fw_shattered_yellow_sand_dune_probability",
    ["decorative:brown-asterisk:probability"] = "fw_shattered_yellow_brown_asterisk_probability",
    ["decorative:brown-fluff-dry:probability"] = "fw_shattered_yellow_brown_fluff_probability",
    ["decorative:red-desert-bush:probability"] = "fw_shattered_red_bush_probability",
    ["decorative:red-croton:probability"] = "fw_shattered_red_croton_probability",
    ["decorative:red-asterisk:probability"] = "fw_shattered_red_asterisk_probability",
    ["decorative:green-pita:probability"] = "fw_shattered_green_pita_probability",
    ["decorative:green-pita-mini:probability"] = "fw_shattered_green_pita_mini_probability",
    ["decorative:green-croton:probability"] = "fw_shattered_green_croton_probability",
    ["decorative:aqulio-ice-decal-blue:probability"] = "fw_shattered_purple_ice_decal_probability",
    ["decorative:aqulio-snowy-decal:probability"] = "fw_shattered_purple_snowy_decal_probability",
  },
  autoplace_controls = {
    ["fw_shattered_flux_vents"] = {},
  },
  cliff_settings = {
    name = "cliff",
    cliff_elevation_interval = 42,
    cliff_elevation_0 = 34,
    cliff_smoothing = 0,
    richness = 0.8,
  },
  autoplace_settings = {
    tile = {
      settings = {
        ["fw-shattered-space"] = {},
        ["fw-shattered-red-land"] = {},
        ["fw-shattered-purple-land"] = {},
        ["fw-shattered-yellow-land"] = {},
        ["fw-shattered-green-land"] = {},
      },
    },
    decorative = {
      settings = {
        ["tiny-rock"] = {},
        ["small-rock"] = {},
        ["medium-rock"] = {},
        ["light-mud-decal"] = {},
        ["sand-decal"] = {},
        ["sand-dune-decal"] = {},
        ["brown-asterisk"] = {},
        ["brown-fluff-dry"] = {},
        ["red-desert-bush"] = {},
        ["red-croton"] = {},
        ["red-asterisk"] = {},
        ["green-pita"] = {},
        ["green-pita-mini"] = {},
        ["green-croton"] = {},
        ["aqulio-ice-decal-blue"] = {},
        ["aqulio-snowy-decal"] = {},
      },
    },
    entity = {
      settings = {
        ["fw-shattered-yellow-flux-vent"] = {},
        ["fw-shattered-red-flux-vent"] = {},
        ["fw-shattered-green-flux-vent"] = {},
        ["fw-shattered-purple-flux-vent"] = {},
      },
    },
  },
}

data:extend({ shattered_planet })
