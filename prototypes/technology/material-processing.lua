local Tech = require("__haul_lib__/utils/tech")

data:extend({
  {
    type = "technology",
    name = "fw-material-foundations",
    icon = "__FluxWorksAssets__/graphics/technology/fw-glassworking.png",
    icon_size = 1024,
    prerequisites = { "fw-comminution", "steel-processing", "logistics-2", "automation-2", "electronics" },
    unit = {
      count = 90,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
      },
      time = 25,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-glass" },
      { type = "unlock-recipe", recipe = "fw-rubber-sheet" },
      { type = "unlock-recipe", recipe = "fw-copper-tube" },
      { type = "unlock-recipe", recipe = "fw-metal-mesh" },
      { type = "unlock-recipe", recipe = "fw-iron-beam" },
      { type = "unlock-recipe", recipe = "fw-circuit-contact-leaded" },
    },
    order = "c-a[fw-material-foundations]",
  },
  {
    type = "technology",
    name = "fw-metals-fabrication",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-steel-beam.png",
    icon_size = 1024,
    prerequisites = { "fw-material-foundations", "engine", "military-2", "toolbelt" },
    unit = {
      count = 130,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
      },
      time = 30,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-solder-alloy" },
      { type = "unlock-recipe", recipe = "fw-bearing" },
      { type = "unlock-recipe", recipe = "fw-ceramic-insulator" },
      { type = "unlock-recipe", recipe = "fw-steel-beam" },
      { type = "unlock-recipe", recipe = "fw-aluminum-beam" },
      { type = "unlock-recipe", recipe = "fw-cable-harness" },
      { type = "unlock-recipe", recipe = "fw-tinned-cable" },
    },
    order = "c-b[fw-metals-fabrication]",
  },
  {
    type = "technology",
    name = "fw-electromechanical-systems",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-inductor-coil.png",
    icon_size = 1024,
    prerequisites = { "fw-metals-fabrication", "advanced-circuit", "electric-energy-distribution-1", "battery" },
    unit = {
      count = 180,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
      },
      time = 30,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-circuit-substrate" },
      { type = "unlock-recipe", recipe = "fw-inductor-coil" },
      { type = "unlock-recipe", recipe = "fw-capacitor" },
      { type = "unlock-recipe", recipe = "silicon" },
    },
    order = "c-c[fw-electromechanical-systems]",
  },
  {
    type = "technology",
    name = "fw-circuit-foundry",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-circuit-substrate.png",
    icon_size = 1024,
    prerequisites = { "electronics", "automation-2", "logistics-2" },
    unit = {
      count = 70,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
      },
      time = 20,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-solder-wire" },
      { type = "unlock-recipe", recipe = "fw-chip-carrier" },
      { type = "unlock-recipe", recipe = "fw-ceramic-wafer" },
      { type = "unlock-recipe", recipe = "fw-silicon-wafer" },
    },
    order = "c-c[fw-circuit-foundry]",
  },
  {
    type = "technology",
    name = "fw-signal-architecture",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-ribbon-cable.png",
    icon_size = 1024,
    prerequisites = { "fw-circuit-foundry", "advanced-circuit", "battery", "radar" },
    unit = {
      count = 140,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
      },
      time = 25,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-conductor-bundle" },
      { type = "unlock-recipe", recipe = "fw-microchip" },
    },
    order = "c-d[fw-signal-architecture]",
  },
  {
    type = "technology",
    name = "fw-computational-arrays",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-sensor-package.png",
    icon_size = 1024,
    prerequisites = { "fw-signal-architecture", "processing-unit", "modules", "electric-engine" },
    unit = {
      count = 180,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
      },
      time = 30,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-memory-die" },
      { type = "unlock-recipe", recipe = "fw-rocket-engine" },
    },
    order = "c-e[fw-computational-arrays]",
  },
  {
    type = "technology",
    name = "fw-material-refinement",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-cermet.png",
    icon_size = 1024,
    prerequisites = { "fw-metals-fabrication", "concrete", "sulfur-processing", "fluid-handling" },
    unit = {
      count = 170,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
      },
      time = 30,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-cermet" },
      { type = "unlock-recipe", recipe = "fw-inline-filter" },
    },
    order = "c-c[fw-material-refinement]",
  },
  {
    type = "technology",
    name = "fw-instrumentation",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-sensor-package.png",
    icon_size = 1024,
    prerequisites = { "fw-electromechanical-systems", "solar-energy", "radar" },
    unit = {
      count = 210,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
      },
      time = 30,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-glass-lens" },
      { type = "unlock-recipe", recipe = "fw-ribbon-cable" },
    },
    order = "c-d[fw-instrumentation]",
  },
  {
    type = "technology",
    name = "fw-systems-integration",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-transformer-core.png",
    icon_size = 1024,
    prerequisites = { "fw-instrumentation", "robotics", "electric-energy-accumulators", "electric-engine" },
    unit = {
      count = 260,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
      },
      time = 35,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-sensor-package" },
      { type = "unlock-recipe", recipe = "fw-transformer-core" },
    },
    order = "c-e[fw-systems-integration]",
  },
  {
    type = "technology",
    name = "fw-advanced-fabrication",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-light-frame.png",
    icon_size = 128,
    prerequisites = { "fw-electromechanical-systems", "fw-material-refinement", "fw-systems-integration", "military-3", "production-science-pack" },
    unit = {
      count = 220,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
      },
      time = 35,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-composite-panel" },
      { type = "unlock-recipe", recipe = "fw-light-frame" },
      { type = "unlock-recipe", recipe = "fw-gunpowder" },
    },
    order = "c-d[fw-advanced-fabrication]",
  },
})

-- Normalize progression with Haul Lib tech helpers so balancing stays centralized.
Tech:get("fw-material-foundations")
  :setCost(90)
  :setColors("RG")
  :setTime(25)
  :setPrerequisites({ "fw-comminution", "steel-processing", "logistics-2", "automation-2", "electronics" })

Tech:get("fw-metals-fabrication")
  :setCost(130)
  :setColors("RGM")
  :setTime(30)
  :setPrerequisites({ "fw-material-foundations", "engine", "military-2", "toolbelt" })

Tech:get("fw-electromechanical-systems")
  :setCost(180)
  :setColors("RGB")
  :setTime(30)
  :setPrerequisites({ "fw-metals-fabrication", "advanced-circuit", "electric-energy-distribution-1", "battery" })

Tech:get("fw-circuit-foundry")
  :setCost(70)
  :setColors("RG")
  :setTime(20)
  :setPrerequisites({ "electronics", "automation-2", "logistics-2" })

Tech:get("fw-material-refinement")
  :setCost(170)
  :setColors("RGB")
  :setTime(30)
  :setPrerequisites({ "fw-metals-fabrication", "concrete", "sulfur-processing", "fluid-handling" })

Tech:get("fw-instrumentation")
  :setCost(210)
  :setColors("RGB")
  :setTime(30)
  :setPrerequisites({ "fw-electromechanical-systems", "solar-energy", "radar" })

Tech:get("fw-signal-architecture")
  :setCost(140)
  :setColors("RGB")
  :setTime(25)
  :setPrerequisites({ "fw-circuit-foundry", "advanced-circuit", "battery", "radar" })

Tech:get("fw-systems-integration")
  :setCost(260)
  :setColors("RGBP")
  :setTime(35)
  :setPrerequisites({ "fw-instrumentation", "robotics", "electric-energy-accumulators", "electric-engine" })

Tech:get("fw-computational-arrays")
  :setCost(180)
  :setColors("RGB")
  :setTime(30)
  :setPrerequisites({ "fw-signal-architecture", "processing-unit", "modules", "electric-engine" })

Tech:get("fw-advanced-fabrication")
  :setCost(220)
  :setColors("RGBMP")
  :setTime(35)
  :setPrerequisites({ "fw-electromechanical-systems", "fw-material-refinement", "fw-systems-integration", "military-3", "production-science-pack" })
