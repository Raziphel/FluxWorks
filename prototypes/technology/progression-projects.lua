-- Major progression rewards are conventional research milestones. Domain
-- science belongs in laboratories; it should not be disguised as one-off
-- flask-shaped charter items in the crafting catalog.

local milestones = {
  {
    technology = "fw-industrial-district-project",
    domain = "fw-industrial-methods-science",
    icons = {
      { icon = "__base__/graphics/technology/mining-productivity.png", icon_size = 256 },
      { icon = "__FluxWorksAssets__/graphics/icons/science/fw-industrial-methods-science-pack.png", icon_size = 64, scale = 1.35, shift = { 48, 48 } },
    },
    count = 300,
    time = 30,
    sciences = {
      "automation-science-pack",
      "logistic-science-pack",
      "chemical-science-pack",
      "fw-industrial-methods-science-pack",
    },
    effects = {
      { type = "mining-drill-productivity-bonus", modifier = 0.05 },
      { type = "inserter-stack-size-bonus", modifier = 1 },
    },
    order = "fw-milestone-a[industrial-operations]",
  },
  {
    technology = "fw-autonomous-network-project",
    domain = "fw-systems-analysis-science",
    previous = "fw-industrial-district-project",
    icons = {
      { icon = "__base__/graphics/technology/worker-robots-speed.png", icon_size = 256 },
      { icon = "__FluxWorksAssets__/graphics/icons/science/fw-systems-analysis-science-pack.png", icon_size = 64, scale = 1.35, shift = { 48, 48 } },
    },
    count = 450,
    time = 40,
    sciences = {
      "automation-science-pack",
      "logistic-science-pack",
      "chemical-science-pack",
      "utility-science-pack",
      "fw-systems-analysis-science-pack",
    },
    effects = {
      { type = "worker-robot-speed", modifier = 0.25 },
      { type = "worker-robot-storage", modifier = 1 },
    },
    order = "fw-milestone-b[autonomous-logistics]",
  },
  {
    technology = "fw-spectrum-control-project",
    domain = "fw-flux-theory-science",
    previous = "fw-autonomous-network-project",
    icons = {
      { icon = "__base__/graphics/technology/research-speed.png", icon_size = 256 },
      { icon = "__FluxWorksAssets__/graphics/icons/science/fw-flux-theory-science-pack.png", icon_size = 64, scale = 1.35, shift = { 48, 48 } },
    },
    count = 650,
    time = 50,
    sciences = {
      "automation-science-pack",
      "logistic-science-pack",
      "chemical-science-pack",
      "production-science-pack",
      "utility-science-pack",
      "space-science-pack",
      "fw-flux-theory-science-pack",
    },
    effects = {
      { type = "change-recipe-productivity", recipe = "fw-flux-catalyst", change = 0.05 },
      { type = "change-recipe-productivity", recipe = "fw-stabilized-flux-crystal", change = 0.05 },
      { type = "change-recipe-productivity", recipe = "fw-condensed-flux-matrix", change = 0.05 },
    },
    order = "fw-milestone-c[spectrum-process-control]",
  },
  {
    technology = "fw-convergence-directive-project",
    domain = "fw-planetary-convergence-science",
    previous = "fw-spectrum-control-project",
    icons = {
      { icon = "__space-age__/graphics/technology/research-productivity.png", icon_size = 256 },
      { icon = "__FluxWorksAssets__/graphics/icons/science/fw-planetary-convergence-science-pack.png", icon_size = 64, scale = 1.35, shift = { 48, 48 } },
    },
    count = 1000,
    time = 60,
    sciences = {
      "automation-science-pack",
      "logistic-science-pack",
      "chemical-science-pack",
      "production-science-pack",
      "utility-science-pack",
      "space-science-pack",
      "metallurgic-science-pack",
      "agricultural-science-pack",
      "electromagnetic-science-pack",
      "cryogenic-science-pack",
      "fw-planetary-convergence-science-pack",
    },
    effects = {
      { type = "laboratory-productivity", modifier = 0.10 },
      { type = "mining-drill-productivity-bonus", modifier = 0.10 },
      { type = "worker-robot-speed", modifier = 0.25 },
    },
    order = "fw-milestone-d[planetary-convergence-mastery]",
  },
}

local function science_ingredients(names)
  local ingredients = {}
  for _, name in ipairs(names) do
    ingredients[#ingredients + 1] = { name, 1 }
  end
  return ingredients
end

for _, milestone in ipairs(milestones) do
  data:extend({
    {
      type = "technology",
      name = milestone.technology,
      icons = milestone.icons,
      prerequisites = milestone.previous
        and { milestone.domain, milestone.previous }
        or { milestone.domain },
      unit = {
        count = milestone.count,
        time = milestone.time,
        ingredients = science_ingredients(milestone.sciences),
      },
      effects = milestone.effects,
      order = milestone.order,
    },
  })
end

return milestones
