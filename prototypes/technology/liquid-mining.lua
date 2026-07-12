local Tech = require("__haul_lib__/utils/tech")

data:extend({
  {
    type = "technology",
    name = "fw-liquid-mining",
    icon = "__Age-of-Production-Graphics__/graphics/technology/core-mining.png",
    icon_size = 64,
    prerequisites = { "fw-sealed-components", "fluid-handling", "sulfur-processing" },
    unit = {
      count = 70,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
      },
      time = 24,
    },
    effects = {
      { type = "mining-with-fluid", modifier = true },
      { type = "unlock-recipe", recipe = "fw-chlorine" },
      { type = "unlock-recipe", recipe = "fw-carbon-washing" },
    },
    order = "c-a",
  },
})

Tech:get("fw-liquid-mining")
  :setCost(70)
  :setColors("RG")
  :setTime(24)
  :setPrerequisites({ "fw-sealed-components", "fluid-handling", "sulfur-processing" })
