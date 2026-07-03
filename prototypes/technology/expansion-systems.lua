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
    icon = "__base__/graphics/technology/oil-processing.png",
    icon_size = 256,
    prerequisites = { "fw-power-regulation", "fw-polymer-chemistry", "oil-processing" },
    unit = tech_unit(240, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
    }, 28),
    effects = {
      unlock("fw-petrochemical-facility"),
      unlock("fw-polymer-binder"),
      unlock("fw-chlorinated-binder-stock"),
    },
    order = "d-kb[fw-petrochemical-engineering]",
  },
  {
    type = "technology",
    name = "fw-polymer-stabilization",
    icon = "__base__/graphics/icons/plastic-bar.png",
    icon_size = 64,
    prerequisites = { "fw-petrochemical-engineering", "fw-material-refinement" },
    unit = tech_unit(300, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
    }, 32),
    effects = {
      unlock("fw-elastomer-matrix"),
      unlock("fw-reinforced-seal"),
    },
    order = "d-kc[fw-polymer-stabilization]",
  },
  {
    type = "technology",
    name = "fw-hydraulic-systems",
    icon = "__base__/graphics/icons/electric-engine-unit.png",
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
      unlock("fw-hydraulic-actuator"),
      unlock("fw-servo-valve"),
    },
    order = "d-kd[fw-hydraulic-systems]",
  },
  {
    type = "technology",
    name = "fw-fluid-control-architecture",
    icon = "__base__/graphics/icons/pump.png",
    icon_size = 64,
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
    },
    order = "d-ke[fw-fluid-control-architecture]",
  },
})
