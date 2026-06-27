local Tech = require("__haul_lib__/utils/tech")

data:extend({
  {
    type = "technology",
    name = "fw-industrial-expansion",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-composite-panel.png",
    icon_size = 1024,
    prerequisites = { "fw-material-refinement", "fw-advanced-fabrication", "advanced-material-processing-2" },
    unit = {
      count = 280,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
      },
      time = 40,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-arc-cermet-densification" },
      { type = "unlock-recipe", recipe = "fw-arc-glass-recast" },
      { type = "unlock-recipe", recipe = "fw-synthesized-gunpowder" },
      { type = "unlock-recipe", recipe = "fw-synthesized-filter-core" },
      { type = "unlock-recipe", recipe = "fw-salt-brine-clarification" },
    },
    order = "c-f[fw-industrial-expansion]",
  },
})

-- Keep balancing centralized with the same Haul Lib pattern used by other tech files.
Tech:get("fw-industrial-expansion")
  :setCost(280)
  :setColors("RGBP")
  :setTime(40)
  :setPrerequisites({ "fw-material-refinement", "fw-advanced-fabrication", "advanced-material-processing-2" })
