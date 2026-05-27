data:extend({
  {
    type = "technology",
    name = "fw-liquid-mining",
    icon = "__FluxWorksAssets__/graphics/resources/fluids/chlorine.png",
    icon_size = 128,
    prerequisites = { "fluid-handling" },
    unit = {
      count = 200,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
      },
      time = 30,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-chlorine" },
    },
    order = "c-a",
  },
})
