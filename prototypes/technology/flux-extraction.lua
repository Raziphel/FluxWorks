local Tech = require("__haul_lib__/utils/tech")

data:extend({
  {
    type = "technology",
    name = "fw-flux-extraction",
    icon = "__finely-crafted-graphics__/graphics/core-extractor/core-extractor-icon.png",
    icon_size = 64,
    prerequisites = { "fw-liquid-mining", "fw-material-refinement", "fw-sealed-systems" },
    unit = {
      count = 160,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
      },
      time = 32,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-flux-quarry" },
    },
    order = "e-f-b[fw-flux-extraction]",
  },
})

Tech:get("fw-flux-extraction")
  :setCost(160)
  :setColors("RGC")
  :setTime(32)
  :setPrerequisites({ "fw-liquid-mining", "fw-material-refinement", "fw-sealed-systems" })
