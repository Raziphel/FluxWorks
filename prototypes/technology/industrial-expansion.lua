local Tech = require("__haul_lib__/utils/tech")

data:extend({
  {
    type = "technology",
    name = "fw-industrial-expansion",
    icons = {
      {
        icon = "__FluxWorksAssets__/graphics/icons/items/fw-composite-panel.png",
        icon_size = 1024,
      },
      {
        icon = "__FluxWorksAssets__/graphics/resources/ores/salt.png",
        icon_size = 64,
        scale = 0.45,
        shift = { 9, 9 },
      },
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
      { type = "unlock-recipe", recipe = "fw-salt-brine-clarification" },
    },
    order = "c-f[fw-industrial-expansion]",
  },
  {
    type = "technology",
    name = "fw-arc-recasting",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-cermet.png",
    icon_size = 1024,
    prerequisites = { "fw-industrial-expansion", "fw-flux-metallurgy" },
    unit = {
      count = 175,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
      },
      time = 30,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-arc-cermet-densification" },
      { type = "unlock-recipe", recipe = "fw-arc-glass-recast" },
    },
    order = "c-g[fw-arc-recasting]",
  },
  {
    type = "technology",
    name = "fw-reactive-powders",
    icon = "__FluxWorksAssets__/graphics/icons/fluids/fw-blasting-gel.png",
    icon_size = 64,
    prerequisites = { "fw-industrial-expansion", "fw-propellant-synthesis" },
    unit = {
      count = 170,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
      },
      time = 30,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-synthesized-gunpowder" },
    },
    order = "c-h[fw-reactive-powders]",
  },
  {
    type = "technology",
    name = "fw-slurry-beneficiation",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-crushed-titanium-ore.png",
    icon_size = 128,
    prerequisites = { "fw-industrial-expansion", "fw-harvester-systems" },
    unit = {
      count = 180,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
      },
      time = 30,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-titanium-slurry-grading" },
      { type = "unlock-recipe", recipe = "fw-carbon-grade-screening" },
    },
    order = "c-i[fw-slurry-beneficiation]",
  },
})

-- Keep balancing centralized with the same Haul Lib pattern used by other tech files.
Tech:get("fw-industrial-expansion")
  :setCost(190)
  :setColors("RGBP")
  :setTime(30)
  :setPrerequisites({ "fw-material-refinement", "fw-advanced-fabrication", "advanced-material-processing-2" })

Tech:get("fw-arc-recasting")
  :setCost(175)
  :setColors("RGBP")
  :setTime(28)
  :setPrerequisites({ "fw-industrial-expansion", "fw-flux-metallurgy" })

Tech:get("fw-reactive-powders")
  :setCost(170)
  :setColors("RGBP")
  :setTime(28)
  :setPrerequisites({ "fw-industrial-expansion", "fw-propellant-synthesis" })

Tech:get("fw-slurry-beneficiation")
  :setCost(180)
  :setColors("RGBP")
  :setTime(28)
  :setPrerequisites({ "fw-industrial-expansion", "fw-harvester-systems" })
