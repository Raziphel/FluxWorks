local Tech = require("__haul_lib__/utils/tech")

data:extend({
  {
    type = "technology",
    name = "fw-flux-extraction",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-flux-quarry.png",
    icon_size = 64,
    prerequisites = { "rocket-silo", "fw-systems-integration", "fw-material-refinement" },
    unit = {
      count = 1800,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
        { "utility-science-pack", 1 },
        { "space-science-pack", 1 },
      },
      time = 45,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-flux-quarry" },
    },
    order = "e-f-b[fw-flux-extraction]",
  },
})

Tech:get("fw-flux-extraction")
  :setCost(1800)
  :setColors("RGBPWS")
  :setTime(45)
  :setPrerequisites({ "rocket-silo", "fw-systems-integration", "fw-material-refinement" })
