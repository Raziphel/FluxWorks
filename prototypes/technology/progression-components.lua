local function tech_unit(count, science_packs, time)
  return {
    count = count,
    ingredients = science_packs,
    time = time,
  }
end

local function unlock(recipe_name)
  return { type = "unlock-recipe", recipe = recipe_name }
end

data:extend({
  {
    type = "technology",
    name = "fw-ceramic-engineering",
    icon = "__FluxWorksAssets__/graphics/technology/fw-ceramic-engineering.png",
    icon_size = 256,
    prerequisites = { "fw-structural-fabrication", "stone-wall" },
    unit = tech_unit(95, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
    }, 25),
    effects = {
      unlock("fw-fired-ceramic"),
    },
    order = "c-g[fw-ceramic-engineering]",
  },
  {
    type = "technology",
    name = "fw-machine-casings",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-ceramic-casing.png",
    icon_size = 64,
    prerequisites = { "fw-ceramic-engineering", "fw-material-refinement" },
    unit = tech_unit(105, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
    }, 26),
    effects = {
      unlock("fw-ceramic-casing"),
    },
    order = "c-ga[fw-machine-casings]",
  },
  {
    type = "technology",
    name = "fw-conductive-networks",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-coil-block.png",
    icon_size = 256,
    prerequisites = { "fw-conductive-assembly", "fw-electromechanical-systems" },
    unit = tech_unit(85, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
    }, 25),
    effects = {
      unlock("fw-coil-block"),
    },
    order = "c-h[fw-conductive-networks]",
  },
  {
    type = "technology",
    name = "fw-signal-routing",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-signal-conduit.png",
    icon_size = 256,
    prerequisites = { "fw-conductive-networks", "fw-cable-looming" },
    unit = tech_unit(92, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
    }, 25),
    effects = {
      unlock("fw-signal-conduit"),
    },
    order = "c-ha[fw-signal-routing]",
  },
  {
    type = "technology",
    name = "fw-optical-instrumentation",
    icon = "__base__/graphics/technology/radar.png",
    icon_size = 256,
    prerequisites = { "fw-instrumentation", "fw-wafer-etching" },
    unit = tech_unit(120, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
    }, 30),
    effects = {
      unlock("fw-lens-array"),
    },
    order = "c-i[fw-optical-instrumentation]",
  },
  {
    type = "technology",
    name = "fw-sealed-systems",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-pressure-housing.png",
    icon_size = 256,
    prerequisites = { "fw-material-refinement", "fw-conductive-networks" },
    unit = tech_unit(140, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
    }, 30),
    effects = {
      unlock("fw-pressure-housing"),
    },
    order = "c-j[fw-sealed-systems]",
  },
  {
    type = "technology",
    name = "fw-fluid-regulation",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-flow-regulator.png",
    icon_size = 256,
    prerequisites = { "fw-sealed-systems", "fw-signal-routing" },
    unit = tech_unit(150, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
    }, 30),
    effects = {
      unlock("fw-flow-regulator"),
    },
    order = "c-ja[fw-fluid-regulation]",
  },
  {
    type = "technology",
    name = "fw-polymer-chemistry",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-chlorinated-binder-stock.png",
    icon_size = 64,
    prerequisites = { "fw-liquid-mining", "fw-material-foundations", "sulfur-processing" },
    unit = tech_unit(130, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
    }, 30),
    effects = {
      unlock("fw-resin-polymerization"),
      unlock("fw-sulfur-bonding"),
      unlock("fw-acid-synthesis"),
      unlock("fw-rubber-vulcanization"),
    },
    order = "c-ja[fw-polymer-chemistry]",
  },
  {
    type = "technology",
    name = "fw-power-regulation",
    icon = "__base__/graphics/technology/advanced-electronics-2.png",
    icon_size = 256,
    prerequisites = { "fw-systems-integration", "fw-sealed-systems" },
    unit = tech_unit(180, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
    }, 35),
    effects = {
      unlock("fw-power-regulator"),
    },
    order = "c-k[fw-power-regulation]",
  },
  {
    type = "technology",
    name = "fw-field-balancing",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-field-winding.png",
    icon_size = 256,
    prerequisites = { "fw-power-regulation", "fw-conductive-networks" },
    unit = tech_unit(195, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
    }, 35),
    effects = {
      unlock("fw-field-winding"),
    },
    order = "c-ka[fw-field-balancing]",
  },
  {
    type = "technology",
    name = "fw-energetic-compounds",
    icons = {
      {
        icon = "__FluxWorksAssets__/graphics/icons/fluids/fw-blasting-gel.png",
        icon_size = 64,
      },
      {
        icon = "__base__/graphics/icons/sulfur.png",
        icon_size = 64,
        scale = 0.45,
        shift = { 9, 9 },
      },
    },
    prerequisites = { "fw-polymer-chemistry", "fw-advanced-fabrication", "military-3", "production-science-pack" },
    unit = tech_unit(220, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
    }, 40),
    effects = {
      unlock("fw-blasting-gel"),
      unlock("fw-reactive-slurry"),
      unlock("fw-battery-electrolyte"),
      unlock("fw-napalm"),
    },
    order = "c-ka[fw-energetic-compounds]",
  },
  {
    type = "technology",
    name = "fw-metallurgic-assemblies",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-foundry-lining.png",
    icon_size = 256,
    prerequisites = { "fw-industrial-expansion", "fw-ceramic-engineering", "foundry", "metallurgic-science-pack" },
    unit = tech_unit(390, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "utility-science-pack", 1 },
      { "space-science-pack", 1 },
    }, 40),
    effects = {
      unlock("fw-foundry-lining"),
    },
    order = "d-f[fw-metallurgic-assemblies]",
  },
  {
    type = "technology",
    name = "fw-cryogenic-control",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-cryo-coil.png",
    icon_size = 256,
    prerequisites = { "fw-flux-catalysis", "fw-power-regulation", "cryogenic-plant", "cryogenic-science-pack" },
    unit = tech_unit(520, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "utility-science-pack", 1 },
      { "space-science-pack", 1 },
    }, 45),
    effects = {
      unlock("fw-cryo-coil"),
    },
    order = "d-h[fw-cryogenic-control]",
  },
  {
    type = "technology",
    name = "fw-thermal-retention",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-thermal-buffer.png",
    icon_size = 256,
    prerequisites = { "fw-cryogenic-control", "fw-advanced-fabrication" },
    unit = tech_unit(560, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "utility-science-pack", 1 },
      { "space-science-pack", 1 },
    }, 45),
    effects = {
      unlock("fw-thermal-buffer"),
    },
    order = "d-ha[fw-thermal-retention]",
  },
  {
    type = "technology",
    name = "fw-electromagnetic-architecture",
    icon = "__space-age__/graphics/technology/quantum-processor.png",
    icon_size = 256,
    prerequisites = { "fw-flux-resonance", "fw-computational-arrays", "electromagnetic-plant", "electromagnetic-science-pack" },
    unit = tech_unit(560, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "utility-science-pack", 1 },
      { "space-science-pack", 1 },
    }, 45),
    effects = {
      unlock("fw-em-core"),
    },
    order = "d-i[fw-electromagnetic-architecture]",
  },
  {
    type = "technology",
    name = "fw-logic-weaving",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-logic-matrix.png",
    icon_size = 128,
    prerequisites = { "fw-electromagnetic-architecture", "fw-computational-arrays" },
    unit = tech_unit(620, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "utility-science-pack", 1 },
      { "space-science-pack", 1 },
    }, 48),
    effects = {
      unlock("fw-logic-matrix"),
    },
    order = "d-ia[fw-logic-weaving]",
  },
  {
    type = "technology",
    name = "fw-orbital-hardening",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-rocket-avionics.png",
    icon_size = 64,
    prerequisites = { "fw-computational-arrays", "fw-advanced-fabrication", "utility-science-pack", "space-science-pack" },
    unit = tech_unit(500, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "utility-science-pack", 1 },
      { "space-science-pack", 1 },
    }, 40),
    effects = {
      unlock("fw-rocket-avionics"),
      unlock("fw-rocket-heatshield"),
    },
    order = "d-ia[fw-orbital-hardening]",
  },
  {
    type = "technology",
    name = "fw-promethium-stabilization",
    icon = "__space-age__/graphics/technology/promethium-science-pack.png",
    icon_size = 256,
    prerequisites = {
      "fw-flux-field-theory",
      "fw-aquilo-cryochemistry",
      "fw-gleba-biochemistry",
      "fw-fulgora-electrochemistry",
      "fw-vulcanus-pyrochemistry",
      "fw-electromagnetic-architecture",
      "fw-cryogenic-control"
    },
    unit = tech_unit(900, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "utility-science-pack", 1 },
      { "space-science-pack", 1 },
      { "metallurgic-science-pack", 1 },
      { "agricultural-science-pack", 1 },
      { "electromagnetic-science-pack", 1 },
      { "cryogenic-science-pack", 1 },
    }, 60),
    effects = {
      unlock("fw-promethium-matrix"),
    },
    order = "d-j[fw-promethium-stabilization]",
  },
})
