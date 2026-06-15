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
    icon_size = 1024,
    prerequisites = { "fw-structural-fabrication", "stone-wall" },
    unit = tech_unit(110, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
    }, 25),
    effects = {
      unlock("fw-fired-ceramic"),
      unlock("fw-ceramic-casing"),
    },
    order = "c-g[fw-ceramic-engineering]",
  },
  {
    type = "technology",
    name = "fw-conductive-networks",
    icon = "__FluxWorksAssets__/graphics/technology/fw-conductive-networks.png",
    icon_size = 1024,
    prerequisites = { "fw-conductive-assembly", "fw-wafer-etching" },
    unit = tech_unit(130, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
    }, 25),
    effects = {
      unlock("fw-coil-block"),
      unlock("fw-signal-conduit"),
    },
    order = "c-h[fw-conductive-networks]",
  },
  {
    type = "technology",
    name = "fw-optical-instrumentation",
    icon = "__FluxWorksAssets__/graphics/technology/fw-optical-instrumentation.png",
    icon_size = 1024,
    prerequisites = { "fw-instrumentation", "fw-wafer-etching" },
    unit = tech_unit(180, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
    }, 30),
    effects = {
      unlock("fw-lens-array"),
      unlock("fw-sensor-diode"),
    },
    order = "c-i[fw-optical-instrumentation]",
  },
  {
    type = "technology",
    name = "fw-sealed-systems",
    icon = "__FluxWorksAssets__/graphics/technology/fw-sealed-systems.png",
    icon_size = 1024,
    prerequisites = { "fw-material-refinement", "fw-electromechanical-systems" },
    unit = tech_unit(210, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
    }, 30),
    effects = {
      unlock("fw-pressure-housing"),
      unlock("fw-flow-regulator"),
    },
    order = "c-j[fw-sealed-systems]",
  },
  {
    type = "technology",
    name = "fw-power-regulation",
    icon = "__FluxWorksAssets__/graphics/technology/fw-power-regulation.png",
    icon_size = 1024,
    prerequisites = { "fw-systems-integration", "fw-conductive-networks" },
    unit = tech_unit(260, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
    }, 35),
    effects = {
      unlock("fw-power-regulator"),
      unlock("fw-field-winding"),
    },
    order = "c-k[fw-power-regulation]",
  },
  {
    type = "technology",
    name = "fw-metallurgic-assemblies",
    icon = "__FluxWorksAssets__/graphics/technology/fw-metallurgic-assemblies.png",
    icon_size = 1024,
    prerequisites = { "fw-industrial-expansion", "fw-ceramic-engineering" },
    unit = tech_unit(420, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "utility-science-pack", 1 },
      { "space-science-pack", 1 },
    }, 40),
    effects = {
      unlock("fw-foundry-lining"),
      unlock("fw-smelter-array"),
    },
    order = "d-f[fw-metallurgic-assemblies]",
  },
  {
    type = "technology",
    name = "fw-biosystems-engineering",
    icon = "__FluxWorksAssets__/graphics/technology/fw-biosystems-engineering.png",
    icon_size = 1024,
    prerequisites = { "fw-industrial-expansion", "fw-optical-instrumentation", "space-science-pack" },
    unit = tech_unit(420, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "utility-science-pack", 1 },
      { "space-science-pack", 1 },
    }, 40),
    effects = {
      unlock("fw-nutrient-bed"),
      unlock("fw-spore-filter"),
    },
    order = "d-g[fw-biosystems-engineering]",
  },
  {
    type = "technology",
    name = "fw-cryogenic-control",
    icon = "__FluxWorksAssets__/graphics/technology/fw-cryogenic-control.png",
    icon_size = 1024,
    prerequisites = { "fw-flux-catalysis", "fw-power-regulation", "space-science-pack" },
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
      unlock("fw-thermal-buffer"),
    },
    order = "d-h[fw-cryogenic-control]",
  },
  {
    type = "technology",
    name = "fw-electromagnetic-architecture",
    icon = "__FluxWorksAssets__/graphics/technology/fw-electromagnetic-architecture.png",
    icon_size = 1024,
    prerequisites = { "fw-flux-resonance", "fw-computational-arrays", "space-science-pack" },
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
      unlock("fw-logic-matrix"),
    },
    order = "d-i[fw-electromagnetic-architecture]",
  },
  {
    type = "technology",
    name = "fw-promethium-stabilization",
    icon = "__FluxWorksAssets__/graphics/technology/fw-promethium-stabilization.png",
    icon_size = 1024,
    prerequisites = { "fw-flux-field-theory", "fw-electromagnetic-architecture", "fw-cryogenic-control" },
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
    }, 50),
    effects = {
      unlock("fw-promethium-matrix"),
      unlock("fw-rift-stabilizer"),
    },
    order = "d-j[fw-promethium-stabilization]",
  },
})
