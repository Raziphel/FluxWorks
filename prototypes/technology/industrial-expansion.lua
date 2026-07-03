local Tech = require("__haul_lib__/utils/tech")

data:extend({
  {
    type = "technology",
    name = "fw-industrial-expansion",
    icon = "__base__/graphics/technology/advanced-material-processing-2.png",
    icon_size = 256,
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
