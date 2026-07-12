local Tech = require("__haul_lib__/utils/tech")

data:extend({
  {
    type = "technology",
    name = "fw-industrial-expansion",
    icons = {
      { icon = "__Age-of-Production-Graphics__/graphics/icons/petrochemical-facility.png", icon_size = 64 },
      { icon = "__Age-of-Production-Graphics__/graphics/icons/hydraulic-plant.png", icon_size = 64, scale = 0.38, shift = { 12, 12 } },
    },
    prerequisites = { "fw-material-refinement", "fw-advanced-fabrication", "advanced-material-processing-2" },
    unit = {
      count = 190,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
      },
      time = 35,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-arc-cermet-densification" },
      { type = "unlock-recipe", recipe = "fw-arc-glass-recast" },
      { type = "unlock-recipe", recipe = "fw-synthesized-gunpowder" },
      { type = "unlock-recipe", recipe = "fw-synthesized-filter-core" },
      { type = "unlock-recipe", recipe = "fw-salt-brine-clarification" },
      { type = "unlock-recipe", recipe = "fw-titanium-slurry-grading" },
      { type = "unlock-recipe", recipe = "fw-carbon-grade-screening" },
    },
    order = "c-f[fw-industrial-expansion]",
  },
})

-- Keep balancing centralized with the same Haul Lib pattern used by other tech files.
Tech:get("fw-industrial-expansion")
  :setCost(190)
  :setColors("RGBP")
  :setTime(30)
  :setPrerequisites({ "fw-material-refinement", "fw-advanced-fabrication", "advanced-material-processing-2" })
