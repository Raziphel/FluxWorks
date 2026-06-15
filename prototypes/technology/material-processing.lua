local Tech = require("__haul_lib__/utils/tech")

local function tech_unit(count, science_packs, time)
  return {
    count = count,
    ingredients = science_packs,
    time = time,
  }
end

local function unlock(recipe_name)
  return { type = "unlock-recipe", recipe = recipe_name }
end

data:extend({
  {
    type = "technology",
    name = "fw-material-foundations",
    icon = "__FluxWorksAssets__/graphics/technology/fw-glassworking.png",
    icon_size = 1024,
    prerequisites = { "fw-comminution", "automation-2", "electronics" },
    unit = tech_unit(75, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
    }, 20),
    effects = {
      unlock("fw-glass"),
      unlock("fw-rubber-sheet"),
    },
    order = "c-a[fw-material-foundations]",
  },
  {
    type = "technology",
    name = "fw-structural-fabrication",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-iron-beam.png",
    icon_size = 1024,
    prerequisites = { "fw-material-foundations", "logistics-2", "steel-processing" },
    unit = tech_unit(90, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
    }, 25),
    effects = {
      unlock("fw-copper-tube"),
      unlock("fw-metal-mesh"),
      unlock("fw-iron-beam"),
    },
    order = "c-b[fw-structural-fabrication]",
  },
  {
    type = "technology",
    name = "fw-contact-casting",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-circuit-contact.png",
    icon_size = 1024,
    prerequisites = { "fw-structural-fabrication", "electronics", "logistics-2" },
    unit = tech_unit(65, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
    }, 20),
    effects = {
      unlock("fw-circuit-contact-leaded"),
    },
    order = "c-c[fw-contact-casting]",
  },
  {
    type = "technology",
    name = "fw-metals-fabrication",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-solder-alloy.png",
    icon_size = 128,
    prerequisites = { "fw-structural-fabrication", "engine", "military-2", "toolbelt" },
    unit = tech_unit(115, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
    }, 30),
    effects = {
      unlock("fw-solder-alloy"),
      unlock("fw-bearing"),
      unlock("fw-ceramic-insulator"),
    },
    order = "c-d[fw-metals-fabrication]",
  },
  {
    type = "technology",
    name = "fw-circuit-foundry",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-solder-wire.png",
    icon_size = 1024,
    prerequisites = { "fw-contact-casting", "fw-metals-fabrication", "automation-2", "logistics-2" },
    unit = tech_unit(85, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
    }, 20),
    effects = {
      unlock("fw-solder-wire"),
      unlock("fw-ceramic-wafer"),
    },
    order = "c-e[fw-circuit-foundry]",
  },
  {
    type = "technology",
    name = "fw-beam-engineering",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-steel-beam.png",
    icon_size = 1024,
    prerequisites = { "fw-metals-fabrication", "fw-material-foundations" },
    unit = tech_unit(120, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
    }, 30),
    effects = {
      unlock("fw-steel-beam"),
      unlock("fw-aluminum-beam"),
    },
    order = "c-f[fw-beam-engineering]",
  },
  {
    type = "technology",
    name = "fw-conductive-assembly",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-cable-harness.png",
    icon_size = 1024,
    prerequisites = { "fw-metals-fabrication", "fw-material-foundations" },
    unit = tech_unit(125, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
    }, 25),
    effects = {
      unlock("fw-tinned-cable"),
      unlock("fw-cable-harness"),
    },
    order = "c-g[fw-conductive-assembly]",
  },
  {
    type = "technology",
    name = "fw-wafer-etching",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-chip-carrier.png",
    icon_size = 1024,
    prerequisites = { "fw-circuit-foundry", "fw-material-foundations", "advanced-circuit" },
    unit = tech_unit(135, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
    }, 25),
    effects = {
      unlock("fw-silicon-wafer"),
      unlock("fw-chip-carrier"),
    },
    order = "c-h[fw-wafer-etching]",
  },
  {
    type = "technology",
    name = "fw-electromechanical-systems",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-inductor-coil.png",
    icon_size = 1024,
    prerequisites = { "fw-beam-engineering", "fw-wafer-etching", "electric-energy-distribution-1", "battery" },
    unit = tech_unit(180, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
    }, 30),
    effects = {
      unlock("fw-circuit-substrate"),
      unlock("fw-inductor-coil"),
      unlock("fw-capacitor"),
      unlock("silicon"),
    },
    order = "c-i[fw-electromechanical-systems]",
  },
  {
    type = "technology",
    name = "fw-signal-architecture",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-ribbon-cable.png",
    icon_size = 1024,
    prerequisites = { "fw-wafer-etching", "fw-conductive-assembly", "battery", "radar" },
    unit = tech_unit(140, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
    }, 25),
    effects = {
      unlock("fw-conductor-bundle"),
      unlock("fw-microchip"),
    },
    order = "c-j[fw-signal-architecture]",
  },
  {
    type = "technology",
    name = "fw-computational-arrays",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-sensor-package.png",
    icon_size = 1024,
    prerequisites = { "fw-signal-architecture", "processing-unit", "modules", "electric-engine" },
    unit = tech_unit(180, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
    }, 30),
    effects = {
      unlock("fw-memory-die"),
      unlock("fw-rocket-engine"),
    },
    order = "c-k[fw-computational-arrays]",
  },
  {
    type = "technology",
    name = "fw-material-refinement",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-cermet.png",
    icon_size = 1024,
    prerequisites = { "fw-metals-fabrication", "fw-beam-engineering", "concrete", "sulfur-processing", "fluid-handling" },
    unit = tech_unit(170, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
    }, 30),
    effects = {
      unlock("fw-cermet"),
      unlock("fw-inline-filter"),
    },
    order = "c-l[fw-material-refinement]",
  },
  {
    type = "technology",
    name = "fw-instrumentation",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-sensor-package.png",
    icon_size = 1024,
    prerequisites = { "fw-electromechanical-systems", "solar-energy", "radar" },
    unit = tech_unit(210, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
    }, 30),
    effects = {
      unlock("fw-glass-lens"),
      unlock("fw-ribbon-cable"),
    },
    order = "c-m[fw-instrumentation]",
  },
  {
    type = "technology",
    name = "fw-systems-integration",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-transformer-core.png",
    icon_size = 1024,
    prerequisites = { "fw-instrumentation", "robotics", "electric-energy-accumulators", "electric-engine" },
    unit = tech_unit(260, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
    }, 35),
    effects = {
      unlock("fw-sensor-package"),
      unlock("fw-transformer-core"),
    },
    order = "c-n[fw-systems-integration]",
  },
  {
    type = "technology",
    name = "fw-advanced-fabrication",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-light-frame.png",
    icon_size = 128,
    prerequisites = { "fw-electromechanical-systems", "fw-material-refinement", "fw-systems-integration", "military-3", "production-science-pack" },
    unit = tech_unit(220, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
    }, 35),
    effects = {
      unlock("fw-composite-panel"),
      unlock("fw-light-frame"),
      unlock("fw-gunpowder"),
    },
    order = "c-o[fw-advanced-fabrication]",
  },
})

Tech:get("fw-material-foundations")
  :setCost(75)
  :setColors("RG")
  :setTime(20)
  :setPrerequisites({ "fw-comminution", "automation-2", "electronics" })

Tech:get("fw-structural-fabrication")
  :setCost(90)
  :setColors("RG")
  :setTime(25)
  :setPrerequisites({ "fw-material-foundations", "logistics-2", "steel-processing" })

Tech:get("fw-contact-casting")
  :setCost(65)
  :setColors("RG")
  :setTime(20)
  :setPrerequisites({ "fw-structural-fabrication", "electronics", "logistics-2" })

Tech:get("fw-metals-fabrication")
  :setCost(115)
  :setColors("RGM")
  :setTime(30)
  :setPrerequisites({ "fw-structural-fabrication", "engine", "military-2", "toolbelt" })

Tech:get("fw-circuit-foundry")
  :setCost(85)
  :setColors("RG")
  :setTime(20)
  :setPrerequisites({ "fw-contact-casting", "fw-metals-fabrication", "automation-2", "logistics-2" })

Tech:get("fw-beam-engineering")
  :setCost(120)
  :setColors("RGM")
  :setTime(30)
  :setPrerequisites({ "fw-metals-fabrication", "fw-material-foundations" })

Tech:get("fw-conductive-assembly")
  :setCost(125)
  :setColors("RG")
  :setTime(25)
  :setPrerequisites({ "fw-metals-fabrication", "fw-material-foundations" })

Tech:get("fw-wafer-etching")
  :setCost(135)
  :setColors("RG")
  :setTime(25)
  :setPrerequisites({ "fw-circuit-foundry", "fw-material-foundations", "advanced-circuit" })

Tech:get("fw-electromechanical-systems")
  :setCost(180)
  :setColors("RGB")
  :setTime(30)
  :setPrerequisites({ "fw-beam-engineering", "fw-wafer-etching", "electric-energy-distribution-1", "battery" })

Tech:get("fw-signal-architecture")
  :setCost(140)
  :setColors("RGB")
  :setTime(25)
  :setPrerequisites({ "fw-wafer-etching", "fw-conductive-assembly", "battery", "radar" })

Tech:get("fw-computational-arrays")
  :setCost(180)
  :setColors("RGB")
  :setTime(30)
  :setPrerequisites({ "fw-signal-architecture", "processing-unit", "modules", "electric-engine" })

Tech:get("fw-material-refinement")
  :setCost(170)
  :setColors("RGB")
  :setTime(30)
  :setPrerequisites({ "fw-metals-fabrication", "fw-beam-engineering", "concrete", "sulfur-processing", "fluid-handling" })

Tech:get("fw-instrumentation")
  :setCost(210)
  :setColors("RGB")
  :setTime(30)
  :setPrerequisites({ "fw-electromechanical-systems", "solar-energy", "radar" })

Tech:get("fw-systems-integration")
  :setCost(260)
  :setColors("RGBP")
  :setTime(35)
  :setPrerequisites({ "fw-instrumentation", "robotics", "electric-energy-accumulators", "electric-engine" })

Tech:get("fw-advanced-fabrication")
  :setCost(220)
  :setColors("RGBMP")
  :setTime(35)
  :setPrerequisites({ "fw-electromechanical-systems", "fw-material-refinement", "fw-systems-integration", "military-3", "production-science-pack" })
