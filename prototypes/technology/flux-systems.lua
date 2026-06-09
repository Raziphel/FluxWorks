local Tech = require("__haul_lib__/utils/tech")

data:extend({
  {
    type = "technology",
    name = "fw-flux-catalysis",
    icon = "__FluxWorksAssets__/graphics/technology/fw-synthesizer.png",
    icon_size = 1024,
    prerequisites = { "fw-liquid-mining", "fw-material-refinement" },
    unit = {
      count = 220,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
      },
      time = 30,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-purple-flux" },
      { type = "unlock-recipe", recipe = "fw-flux-catalyst" },
      { type = "unlock-recipe", recipe = "fw-stabilized-flux-crystal" },
      { type = "unlock-recipe", recipe = "fw-flux-lattice" },
    },
    order = "d-a[fw-flux-catalysis]",
  },
  {
    type = "technology",
    name = "fw-flux-resonance",
    icon = "__FluxWorksAssets__/graphics/technology/fw-arc-furnace.png",
    icon_size = 256,
    prerequisites = { "fw-flux-catalysis", "fw-systems-integration" },
    unit = {
      count = 520,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
        { "utility-science-pack", 1 },
      },
      time = 40,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-flux-resonance-cell" },
    },
    order = "d-b[fw-flux-resonance]",
  },
  {
    type = "technology",
    name = "fw-flux-asteroid-harvesting",
    icon = "__FluxWorksAssets__/graphics/technology/fw-rocket-chunk-processing.png",
    icon_size = 256,
    prerequisites = { "fw-flux-resonance", "rocket-chunk-processing", "fw-flux-extraction" },
    unit = {
      count = 450,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
        { "utility-science-pack", 1 },
        { "space-science-pack", 1 },
      },
      time = 40,
    },
    effects = {
    },
    order = "d-c[fw-flux-asteroid-harvesting]",
  },
  {
    type = "technology",
    name = "fw-flux-field-theory",
    icon = "__FluxWorksAssets__/graphics/technology/fw-arc-furnace.png",
    icon_size = 256,
    prerequisites = { "fw-flux-asteroid-harvesting", "fw-systems-integration", "utility-science-pack" },
    unit = {
      count = 700,
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
      { type = "unlock-recipe", recipe = "fw-yellow-flux-conditioning" },
      { type = "unlock-recipe", recipe = "fw-red-flux-conditioning" },
      { type = "unlock-recipe", recipe = "fw-green-flux-conditioning" },
      { type = "unlock-recipe", recipe = "fw-condensed-flux-matrix" },
      { type = "unlock-recipe", recipe = "fw-flux-asteroid-deep-refining" },
    },
    order = "d-d[fw-flux-field-theory]",
  },
  {
    type = "technology",
    name = "fw-flux-synthesis",
    icon = "__FluxWorksAssets__/graphics/technology/fw-arc-furnace.png",
    icon_size = 256,
    prerequisites = { "fw-flux-field-theory", "space-science-pack", "fw-computational-arrays" },
    unit = {
      count = 1100,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
        { "utility-science-pack", 1 },
        { "space-science-pack", 1 },
      },
      time = 60,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-flux-phase-manifold" },
      { type = "unlock-recipe", recipe = "fw-rift-seed-crystallization" },
      { type = "unlock-recipe", recipe = "fw-flux-metallic-synthesis" },
    },
    order = "d-e[fw-flux-synthesis]",
  },
})

Tech:get("fw-flux-catalysis")
  :setCost(220)
  :setColors("RGB")
  :setTime(30)
  :setPrerequisites({ "fw-liquid-mining", "fw-material-refinement" })

Tech:get("fw-flux-resonance")
  :setCost(520)
  :setColors("RGBPW")
  :setTime(40)
  :setPrerequisites({ "fw-flux-catalysis", "fw-systems-integration" })

Tech:get("fw-flux-asteroid-harvesting")
  :setCost(450)
  :setColors("RGBPWS")
  :setTime(40)
  :setPrerequisites({ "fw-flux-resonance", "rocket-chunk-processing", "fw-flux-extraction" })

Tech:get("fw-flux-field-theory")
  :setCost(700)
  :setColors("RGBPWS")
  :setTime(45)
  :setPrerequisites({ "fw-flux-asteroid-harvesting", "fw-systems-integration", "utility-science-pack" })

Tech:get("fw-flux-synthesis")
  :setCost(1100)
  :setColors("RGBPWS")
  :setTime(60)
  :setPrerequisites({ "fw-flux-field-theory", "space-science-pack", "fw-computational-arrays" })
