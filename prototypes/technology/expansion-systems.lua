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
    name = "fw-petrochemical-engineering",
    icon = "__finely-crafted-graphics__/graphics/thermal-plant/thermal-plant-icon.png",
    icon_size = 64,
    prerequisites = { "fw-power-regulation", "fw-polymer-chemistry", "oil-processing" },
    unit = tech_unit(240, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
    }, 28),
    effects = {
      unlock("fw-petrochemical-facility"),
    },
    order = "d-kb[fw-petrochemical-engineering]",
  },
  {
    type = "technology",
    name = "fw-reactive-binders",
    icon = "__base__/graphics/technology/advanced-oil-processing.png",
    icon_size = 256,
    prerequisites = { "fw-petrochemical-engineering", "fw-polymer-chemistry" },
    unit = tech_unit(270, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
    }, 30),
    effects = {
      unlock("fw-chlorinated-binder-stock"),
      unlock("fw-catalytic-polymerization"),
      unlock("fw-sour-gas-desulfurization"),
    },
    order = "d-kc[fw-reactive-binders]",
  },
  {
    type = "technology",
    name = "fw-elastomer-engineering",
    icon = "__space-age__/graphics/technology/bioflux-processing.png",
    icon_size = 256,
    prerequisites = { "fw-reactive-binders", "fw-fluid-regulation" },
    unit = tech_unit(300, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
    }, 32),
    effects = {
      unlock("fw-elastomer-matrix"),
      unlock("fw-heavy-oil-dewaxing"),
    },
    order = "d-kd[fw-elastomer-engineering]",
  },
  {
    type = "technology",
    name = "fw-polymer-stabilization",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-reinforced-seal.png",
    icon_size = 64,
    prerequisites = { "fw-elastomer-engineering", "fw-material-refinement" },
    unit = tech_unit(300, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
    }, 32),
    effects = {
      unlock("fw-reinforced-seal"),
    },
    order = "d-ke[fw-polymer-stabilization]",
  },
  {
    type = "technology",
    name = "fw-hydraulic-systems",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-hydraulic-manifold.png",
    icon_size = 64,
    prerequisites = { "fw-sealed-systems", "fw-polymer-stabilization" },
    unit = tech_unit(280, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
    }, 32),
    effects = {
      unlock("fw-hydraulic-plant"),
      unlock("fw-hydraulic-tube-drawing"),
      unlock("fw-hydraulic-filter-pressing"),
      unlock("fw-hydraulic-housing-forming"),
      unlock("fw-hydraulic-seal-compression"),
      unlock("fw-hydraulic-bearing-forging"),
      unlock("fw-hydraulic-mesh-stamping"),
      unlock("fw-hydraulic-cable-sheathing"),
    },
    order = "d-kf[fw-hydraulic-systems]",
  },
  {
    type = "technology",
    name = "fw-fluid-control-architecture",
    icon = "__FluxWorksAssets__/graphics/technology/fw-fluid-control-architecture.png",
    icon_size = 256,
    prerequisites = { "fw-hydraulic-systems", "fw-systems-integration" },
    unit = tech_unit(360, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "utility-science-pack", 1 },
    }, 36),
    effects = {
      unlock("fw-hydraulic-manifold"),
      unlock("fw-hydraulic-regulator-calibration"),
    },
    order = "d-kg[fw-fluid-control-architecture]",
  },
})
