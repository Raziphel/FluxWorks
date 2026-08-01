local Tech = require("__razi_lib__/lib/technology")

data:extend({
  {
    type = "technology",
    name = "fw-liquid-mining",
    icon = "__base__/graphics/icons/pumpjack.png",
    icon_size = 64,
    prerequisites = { "fw-tube-forming", "fluid-handling", "sulfur-processing" },
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
  :setPrerequisites({ "fw-tube-forming", "fluid-handling", "sulfur-processing" })
