data:extend({
  {
    type = "technology",
    name = "fw-flux-mining-productivity",
    icon = "__FluxWorksAssets__/graphics/technology/fw-flux-mining-productivity.png",
    icon_size = 256,
    effects = {
      {
        type = "mining-drill-productivity-bonus",
        modifier = 0.1,
      },
    },
    prerequisites = { "fw-comminution", "fw-flux-extraction" },
    unit = {
      count_formula = "1.5^L*1500",
      ingredients = {
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
      },
      time = 30,
    },
    max_level = "infinite",
    upgrade = true,
    order = "e-p-b-c[fw-flux-mining-productivity]",
  },
})
