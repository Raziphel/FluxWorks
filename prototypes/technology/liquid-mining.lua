local Tech = require("__razi_lib__/lib/technology")

data:extend({
  {
    type = "technology",
    name = "fw-liquid-mining",
    icon = "__base__/graphics/icons/pumpjack.png",
    icon_size = 64,
    prerequisites = { "basic-fluid-handling" },
    unit = {
      count = 20,
      ingredients = {
        { "automation-science-pack", 1 },
      },
      time = 15,
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
  :setCost(20)
  :setColors("R")
  :setTime(15)
  :setPrerequisites({ "basic-fluid-handling" })
