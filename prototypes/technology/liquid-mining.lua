data:extend({
  {
    type = "technology",
    name = "fw-liquid-mining",
    icon = "__base__/graphics/technology/fluid-handling.png",
    icon_size = 256,
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
