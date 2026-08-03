local Tech = require("__razi_lib__/lib/technology")

data:extend({
  {
    type = "technology",
    name = "fw-flux-extraction",
    icon = "__FluxWorksAssets__/graphics/technology/native/fw-flux-extraction.png",
    icon_size = 256,
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
  :setColors("RGB")
  :setTime(32)
  :setPrerequisites({ "fw-liquid-mining", "fw-material-refinement", "fw-sealed-systems" })
