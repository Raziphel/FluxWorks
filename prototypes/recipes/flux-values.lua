local M = {}

-- Hand-tuned starting points for the flux economy.
-- The resolver can build from recipes, but these keep important items from
-- landing at silly stack-size fallback values.
M.item_values = {
  -- Rocks, scraps, and other things pulled straight from the world.
  ["stone"] = 2,
  ["coal"] = 3,
  ["copper-ore"] = 4,
  ["iron-ore"] = 4,
  ["uranium-ore"] = 12,
  ["calcite"] = 8,
  ["tungsten-ore"] = 24,
  ["scrap"] = 6,
  ["spoilage"] = 50,
  ["biter-egg"] = 3500,

  -- Plain old factory staples.
  ["iron-plate"] = 8,
  ["copper-plate"] = 8,
  ["steel-plate"] = 28,
  ["stone-brick"] = 7,
  ["plastic-bar"] = 40,
  ["sulfur"] = 45,
  ["battery"] = 90,

  -- Modules need hard floors because tier 3 recipes can depend on odd late-game ingredients.
  ["speed-module"] = 6000,
  ["speed-module-2"] = 60000,
  ["speed-module-3"] = 350000,
  ["efficiency-module"] = 6000,
  ["efficiency-module-2"] = 60000,
  ["efficiency-module-3"] = 350000,
  ["productivity-module"] = 6000,
  ["productivity-module-2"] = 60000,
  ["productivity-module-3"] = 350000,
  ["quality-module"] = 6000,
  ["quality-module-2"] = 60000,
  ["quality-module-3"] = 350000,

  -- Moving parts and power-chain intermediates.
  ["iron-gear-wheel"] = 14,
  ["pipe"] = 12,
  ["engine-unit"] = 500,
  ["electric-engine-unit"] = 1000,
  ["flying-robot-frame"] = 1800,

  -- Vehicles are valued for tooltips only; the condenser does not clone entity-data items.
  ["car"] = 12000,
  ["tank"] = 35000,
  ["locomotive"] = 20000,
  ["cargo-wagon"] = 12000,
  ["fluid-wagon"] = 14000,
  ["artillery-wagon"] = 90000,
  ["spidertron"] = 250000,

  -- Circuits are deliberately punchy so blue chips do not feel free.
  ["electronic-circuit"] = 180,
  ["advanced-circuit"] = 700,
  ["processing-unit"] = 3000,

  -- Rocket and late-base-game staples.
  ["low-density-structure"] = 160,
  ["rocket-fuel"] = 700,
  ["rocket-part"] = 2400,
  ["satellite"] = 2200,

  -- Space Age anchors, with promethium treated like the endgame trophy it is.
  ["holmium-ore"] = 36,
  ["holmium-plate"] = 64,
  ["superconductor"] = 260,
  ["supercapacitor"] = 180,
  ["electromagnetic-science-pack"] = 520,
  ["agricultural-science-pack"] = 420,
  ["metallurgic-science-pack"] = 620,
  ["cryogenic-science-pack"] = 720,
  ["promethium-asteroid-chunk"] = 6000,
  ["promethium-science-pack"] = 25000,

  -- FluxWorks raws and intermediates.
  ["lead-ore"] = 5,
  ["bauxite-ore"] = 6,
  ["tin-ore"] = 7,
  ["silicon-ore"] = 8,
  ["titanium-ore"] = 14,
  ["fw-crystalised-flux"] = 18,
  ["fw-salt"] = 4,
  ["fw-sand"] = 3,
  ["fw-carbon"] = 10,
  ["lead-plate"] = 11,
  ["tin-plate"] = 12,
  ["titanium-plate"] = 30,
  ["aluminum-plate"] = 18,
  ["silicon"] = 12,

  -- The home-grown FluxWorks component chain.
  ["fw-glass"] = 8,
  ["fw-circuit-contact"] = 16,
  ["fw-solder-wire"] = 14,
  ["fw-flux-catalyst"] = 40,
  ["fw-stabilized-flux-crystal"] = 54,
  ["fw-flux-lattice"] = 96,
  ["fw-condensed-flux-matrix"] = 220,
  ["fw-flux-resonance-cell"] = 480,
  ["fw-flux-phase-manifold"] = 1400,
  ["fw-flux-condenser"] = 3800,
}

M.fluid_values = {
  ["water"] = 0.02,
  ["steam"] = 0.02,
  ["petroleum-gas"] = 0.12,
  ["light-oil"] = 0.22,
  ["heavy-oil"] = 0.24,
  ["sulfuric-acid"] = 0.36,
  ["fluoroketone-hot"] = 1.2,
  ["fluoroketone-cold"] = 1.0,

  ["fw-purple-flux"] = 1.0,
  ["fw-yellow-flux"] = 1.8,
  ["fw-red-flux"] = 2.2,
  ["fw-green-flux"] = 2.0,
  ["fw-chlorine"] = 0.8,
}

M.default_time_value = 6

M.recipe_category_multipliers = {
  ["crafting"] = 1.0,
  ["advanced-crafting"] = 1.05,
  ["crafting-with-fluid"] = 1.10,
  ["electronics"] = 1.35,
  ["electronics-with-fluid"] = 1.50,
  ["smelting"] = 1.18,
  ["chemistry"] = 1.15,
  ["centrifuging"] = 1.20,
  ["electromagnetics"] = 1.22,
  ["metallurgy"] = 1.20,
  ["cryogenics"] = 1.25,
  ["rocket-building"] = 1.30,
  ["fw-flux-condensing"] = 1.35,
}

M.recipe_category_time_multipliers = {
  ["crafting"] = 1.0,
  ["advanced-crafting"] = 1.15,
  ["crafting-with-fluid"] = 1.25,
  ["electronics"] = 1.8,
  ["electronics-with-fluid"] = 2.2,
  ["smelting"] = 1.5,
  ["chemistry"] = 1.8,
  ["centrifuging"] = 2.0,
  ["electromagnetics"] = 2.3,
  ["metallurgy"] = 2.2,
  ["cryogenics"] = 2.5,
  ["rocket-building"] = 3.0,
  ["fw-flux-condensing"] = 1.0,
}

return M
