local Tech = require("__haul_lib__/utils/tech")

data:extend({
  {
    type = "technology",
    name = "fw-liquid-mining",
    icon = "__FluxWorksAssets__/graphics/resources/fluids/chlorine.png",
    icon_size = 128,
    prerequisites = { "fw-electromechanical-systems", "fluid-handling" },
    unit = {
      count = 150,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
      },
      time = 30,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-chlorine" },
      { type = "unlock-recipe", recipe = "fw-carbon-washing" },
    },
    order = "c-a",
  },
})

Tech:get("fw-liquid-mining")
  :setCost(150)
  :setColors("RGB")
  :setTime(30)
  :setPrerequisites({ "fw-electromechanical-systems", "fluid-handling" })
