-- Centralized ore rarity values used by all FluxWorks resource modules.
-- Keep this as the single balancing source of truth.

return {
  ["fw-lead-ore"] =     { base_density = 5.8, base_spots_per_km2 = 1.4,  starting = true,  regular_rq = 1.25, starting_rq = 1.65 },
  ["fw-tin-ore"] =      { base_density = 3.2, base_spots_per_km2 = 0.95, starting = true,  regular_rq = 1.05, starting_rq = 1.25 },
  ["fw-aluminum-ore"] = { base_density = 4.3, base_spots_per_km2 = 1.1,  starting = true,  regular_rq = 1.15, starting_rq = 1.45 },
  ["fw-bauxite-ore"] =  { base_density = 2.1, base_spots_per_km2 = 0.65, starting = false, regular_rq = 0.90, starting_rq = 1.0 },
  ["fw-titanium-ore"] = { base_density = 1.4, base_spots_per_km2 = 0.45, starting = false, regular_rq = 0.70, starting_rq = 1.0 },
  ["fw-salt"] =         { base_density = 5.5, base_spots_per_km2 = 2.0,  starting = true,  regular_rq = 1.85, starting_rq = 1.95 },
  ["fw-silica-ore"] =   { base_density = 2.4, base_spots_per_km2 = 0.75, starting = false, regular_rq = 0.95, starting_rq = 1.0 },
  ["fw-graphite-ore"] = { base_density = 2.8, base_spots_per_km2 = 0.8,  starting = false, regular_rq = 1.0,  starting_rq = 1.0 },
  ["fw-diamond-ore"] =  { base_density = 0.7, base_spots_per_km2 = 0.25, starting = false, regular_rq = 0.6,  starting_rq = 1.0 },
}
