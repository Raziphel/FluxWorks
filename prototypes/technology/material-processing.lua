local Tech = require("__razi_lib__/lib/technology")

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
    name = "fw-elastomer-processing",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-rubber-sheet.png",
    icon_size = 256,
    prerequisites = { "fw-brine-processing", "glass-processing" },
    unit = tech_unit(34, {
      { "automation-science-pack", 1 },
    }, 16),
    effects = {
      unlock("fw-rubber-sheet"),
    },
    order = "c-b[fw-elastomer-processing]",
  },
  {
    type = "technology",
    name = "fw-material-foundations",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-metal-mesh.png",
    icon_size = 256,
    prerequisites = { "glass-processing", "fw-basic-separation" },
    unit = tech_unit(42, {
      { "automation-science-pack", 1 },
    }, 18),
    effects = {
      unlock("fw-metal-mesh"),
      unlock("fw-alumina-refractory"),
    },
    order = "c-c[fw-material-foundations]",
  },
  {
    type = "technology",
    name = "fw-structural-fabrication",
    icon = "__base__/graphics/icons/iron-plate.png",
    icon_size = 64,
    prerequisites = { "fw-material-foundations", "fw-elastomer-processing", "steel-processing" },
    unit = tech_unit(42, {
      { "automation-science-pack", 1 },
    }, 20),
    effects = {
      unlock("fw-iron-beam"),
    },
    order = "c-d[fw-structural-fabrication]",
  },
  {
    type = "technology",
    name = "fw-contact-casting",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-circuit-contact.png",
    icon_size = 64,
    prerequisites = { "fw-structural-fabrication" },
    unit = tech_unit(34, {
      { "automation-science-pack", 1 },
    }, 18),
    effects = {
      unlock("fw-circuit-contact-leaded"),
    },
    order = "c-e[fw-contact-casting]",
  },
  {
    type = "technology",
    name = "fw-tube-forming",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-copper-tube.png",
    icon_size = 256,
    prerequisites = { "fw-structural-fabrication", "fw-contact-casting" },
    unit = tech_unit(44, {
      { "automation-science-pack", 1 },
    }, 18),
    effects = {
      unlock("fw-copper-tube"),
      unlock("fw-inline-filter"),
    },
    order = "c-f[fw-tube-forming]",
  },
  {
    type = "technology",
    name = "fw-metals-fabrication",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-solder-alloy.png",
    icon_size = 64,
    prerequisites = { "fw-structural-fabrication", "engine", "steel-processing" },
    unit = tech_unit(48, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
    }, 24),
    effects = {
      unlock("fw-solder-alloy"),
      unlock("bronze-plate"),
    },
    order = "c-g[fw-metals-fabrication]",
  },
  {
    type = "technology",
    name = "fw-precision-alloys",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-bearing.png",
    icon_size = 128,
    prerequisites = { "fw-metals-fabrication", "glass-processing" },
    unit = tech_unit(54, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
    }, 22),
    effects = {
      unlock("fw-bearing"),
      unlock("fw-ceramic-insulator"),
    },
    order = "c-h[fw-precision-alloys]",
  },
  {
    type = "technology",
    name = "fw-circuit-foundry",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-circuit-contact.png",
    icon_size = 64,
    prerequisites = { "fw-contact-casting", "fw-metals-fabrication", "fw-precision-alloys", "automation-2", "logistics" },
    unit = tech_unit(50, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
    }, 20),
    effects = {
      unlock("fw-solder-wire"),
    },
    order = "c-i[fw-circuit-foundry]",
  },
  {
    type = "technology",
    name = "fw-beam-engineering",
    icon = "__base__/graphics/icons/steel-plate.png",
    icon_size = 64,
    prerequisites = { "fw-metals-fabrication", "fw-material-foundations" },
    unit = tech_unit(65, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
    }, 30),
    effects = {
      unlock("fw-steel-beam"),
      unlock("fw-aluminum-beam"),
    },
    order = "c-j[fw-beam-engineering]",
  },
  {
    type = "technology",
    name = "fw-conductive-assembly",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-circuit-contact.png",
    icon_size = 64,
    prerequisites = { "fw-metals-fabrication", "fw-material-foundations" },
    unit = tech_unit(65, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
    }, 25),
    effects = {
      unlock("fw-tinned-cable"),
    },
    order = "c-k[fw-conductive-assembly]",
  },
  {
    type = "technology",
    name = "fw-cable-looming",
    icon = "__aai-industry__/graphics/technology/electric-engine.png",
    icon_size = 256,
    prerequisites = { "fw-conductive-assembly", "fw-elastomer-processing", "electricity" },
    unit = tech_unit(70, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
    }, 24),
    effects = {},
    order = "c-l[fw-cable-looming]",
  },
  {
    type = "technology",
    name = "fw-wafer-etching",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-circuit-contact.png",
    icon_size = 64,
    prerequisites = { "fw-circuit-foundry", "fw-material-foundations", "advanced-circuit" },
    unit = tech_unit(80, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
    }, 25),
    effects = {
      unlock("fw-silicon-wafer"),
    },
    order = "c-m[fw-wafer-etching]",
  },
  {
    type = "technology",
    name = "fw-chip-packaging",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-chip-carrier.png",
    icon_size = 128,
    prerequisites = { "fw-wafer-etching", "fw-contact-casting" },
    unit = tech_unit(82, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
    }, 25),
    effects = {
      unlock("fw-chip-carrier"),
    },
    order = "c-n[fw-chip-packaging]",
  },
  {
    type = "technology",
    name = "fw-electromechanical-systems",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-inductor-coil.png",
    icon_size = 256,
    prerequisites = { "fw-beam-engineering", "fw-wafer-etching", "fw-precision-alloys", "electric-energy-distribution-1", "battery" },
    unit = tech_unit(145, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
    }, 30),
    effects = {
      unlock("fw-circuit-substrate"),
      unlock("fw-inductor-coil"),
      unlock("silicon"),
    },
    order = "c-o[fw-electromechanical-systems]",
  },
  {
    type = "technology",
    name = "fw-capacitive-systems",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-capacitor.png",
    icon_size = 128,
    prerequisites = { "fw-electromechanical-systems", "battery" },
    unit = tech_unit(110, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
    }, 26),
    effects = {
      unlock("fw-capacitor"),
    },
    order = "c-p[fw-capacitive-systems]",
  },
  {
    type = "technology",
    name = "fw-signal-architecture",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-circuit-contact.png",
    icon_size = 64,
    prerequisites = { "fw-chip-packaging", "fw-cable-looming", "fw-capacitive-systems", "battery", "electricity" },
    unit = tech_unit(95, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
    }, 25),
    effects = {
      unlock("fw-control-assembly"),
    },
    order = "c-q[fw-signal-architecture]",
  },
  {
    type = "technology",
    name = "fw-microelectronics",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-microchip.png",
    icon_size = 256,
    prerequisites = { "fw-signal-architecture", "processing-unit" },
    unit = tech_unit(105, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
    }, 26),
    effects = {
      unlock("fw-microchip"),
    },
    order = "c-r[fw-microelectronics]",
  },
  {
    type = "technology",
    name = "fw-computational-arrays",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-memory-die.png",
    icon_size = 256,
    prerequisites = { "fw-microelectronics", "modules", "electric-engine" },
    unit = tech_unit(140, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
    }, 30),
    effects = {
      unlock("fw-memory-die"),
      unlock("fw-rocket-engine"),
    },
    order = "c-s[fw-computational-arrays]",
  },
  {
    type = "technology",
    name = "fw-material-refinement",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-bauxite-ore.png",
    icon_size = 64,
    prerequisites = { "fw-metals-fabrication", "fw-beam-engineering", "sulfur-processing", "fluid-handling" },
    unit = tech_unit(105, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
    }, 30),
    effects = {
      unlock("fw-cermet"),
    },
    order = "c-l[fw-material-refinement]",
  },
  {
    type = "technology",
    name = "fw-instrumentation",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-glass-lens.png",
    icon_size = 256,
    prerequisites = { "fw-electromechanical-systems", "solar-energy" },
    unit = tech_unit(120, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
    }, 30),
    effects = {
      unlock("fw-glass-lens"),
    },
    order = "c-t[fw-instrumentation]",
  },
  {
    type = "technology",
    name = "fw-ribbon-conductors",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-ribbon-cable.png",
    icon_size = 256,
    prerequisites = { "fw-instrumentation", "fw-cable-looming" },
    unit = tech_unit(124, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
    }, 28),
    effects = {
      unlock("fw-ribbon-cable"),
    },
    order = "c-u[fw-ribbon-conductors]",
  },
  {
    type = "technology",
    name = "fw-systems-integration",
    icon = "__base__/graphics/icons/processing-unit.png",
    icon_size = 64,
    prerequisites = { "fw-instrumentation", "fw-ribbon-conductors", "fw-microelectronics", "electric-engine" },
    unit = tech_unit(170, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
    }, 35),
    effects = {
      unlock("fw-transformer-core"),
    },
    order = "c-v[fw-systems-integration]",
  },
  {
    type = "technology",
    name = "fw-sensor-integration",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-sensor-package.png",
    icon_size = 256,
    prerequisites = { "fw-systems-integration", "fw-optical-instrumentation" },
    unit = tech_unit(185, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
    }, 35),
    effects = {
      unlock("fw-sensor-package"),
    },
    order = "c-va[fw-sensor-integration]",
  },
  {
    type = "technology",
    name = "fw-advanced-fabrication",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-composite-panel.png",
    icon_size = 256,
    prerequisites = { "fw-material-refinement", "fw-systems-integration", "production-science-pack" },
    unit = tech_unit(190, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
    }, 35),
    effects = {
      unlock("fw-composite-panel"),
    },
    order = "c-w[fw-advanced-fabrication]",
  },
  {
    type = "technology",
    name = "fw-lightweight-framing",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-light-frame.png",
    icon_size = 128,
    prerequisites = { "fw-advanced-fabrication", "fw-beam-engineering" },
    unit = tech_unit(205, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
    }, 35),
    effects = {
      unlock("fw-light-frame"),
    },
    order = "c-wa[fw-lightweight-framing]",
  },
  {
    type = "technology",
    name = "fw-propellant-synthesis",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-gunpowder.png",
    icon_size = 128,
    prerequisites = { "fw-advanced-fabrication", "fw-polymer-chemistry", "military-3" },
    unit = tech_unit(215, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
    }, 38),
    effects = {
      unlock("fw-gunpowder"),
    },
    order = "c-wb[fw-propellant-synthesis]",
  },
})

Tech:get("fw-elastomer-processing")
  :setCost(34)
  :setColors("R")
  :setTime(16)
  :setPrerequisites({ "fw-brine-processing", "glass-processing" })

Tech:get("fw-material-foundations")
  :setCost(42)
  :setColors("R")
  :setTime(18)
  :setPrerequisites({ "glass-processing", "fw-basic-separation" })

Tech:get("fw-structural-fabrication")
  :setCost(42)
  :setColors("R")
  :setTime(20)
  :setPrerequisites({ "fw-material-foundations", "fw-elastomer-processing", "steel-processing" })

Tech:get("fw-contact-casting")
  :setCost(34)
  :setColors("R")
  :setTime(18)
  :setPrerequisites({ "fw-structural-fabrication" })

Tech:get("fw-tube-forming")
  :setCost(44)
  :setColors("R")
  :setTime(18)
  :setPrerequisites({ "fw-structural-fabrication", "fw-contact-casting" })

Tech:get("fw-metals-fabrication")
  :setCost(48)
  :setColors("RG")
  :setTime(24)
  :setPrerequisites({ "fw-structural-fabrication", "engine", "steel-processing" })

Tech:get("fw-precision-alloys")
  :setCost(54)
  :setColors("RG")
  :setTime(22)
  :setPrerequisites({ "fw-metals-fabrication", "glass-processing" })

Tech:get("fw-circuit-foundry")
  :setCost(50)
  :setColors("RG")
  :setTime(18)
  :setPrerequisites({ "fw-contact-casting", "fw-metals-fabrication", "fw-precision-alloys", "automation-2", "logistics" })

Tech:get("fw-beam-engineering")
  :setCost(65)
  :setColors("RG")
  :setTime(22)
  :setPrerequisites({ "fw-metals-fabrication", "fw-material-foundations" })

Tech:get("fw-conductive-assembly")
  :setCost(65)
  :setColors("RG")
  :setTime(22)
  :setPrerequisites({ "fw-metals-fabrication", "fw-material-foundations" })

Tech:get("fw-cable-looming")
  :setCost(70)
  :setColors("RG")
  :setTime(24)
  :setPrerequisites({ "fw-conductive-assembly", "fw-elastomer-processing", "electricity" })

Tech:get("fw-wafer-etching")
  :setCost(80)
  :setColors("RG")
  :setTime(22)
  :setPrerequisites({ "fw-circuit-foundry", "fw-material-foundations", "advanced-circuit" })

Tech:get("fw-chip-packaging")
  :setCost(82)
  :setColors("RG")
  :setTime(25)
  :setPrerequisites({ "fw-wafer-etching", "fw-contact-casting" })

Tech:get("fw-electromechanical-systems")
  :setCost(110)
  :setColors("RGB")
  :setTime(26)
  :setPrerequisites({ "fw-beam-engineering", "fw-wafer-etching", "fw-precision-alloys", "electric-energy-distribution-1", "battery" })

Tech:get("fw-capacitive-systems")
  :setCost(110)
  :setColors("RGB")
  :setTime(26)
  :setPrerequisites({ "fw-electromechanical-systems", "battery" })

Tech:get("fw-signal-architecture")
  :setCost(95)
  :setColors("RGB")
  :setTime(24)
  :setPrerequisites({ "fw-chip-packaging", "fw-cable-looming", "fw-capacitive-systems", "battery", "electricity" })

Tech:get("fw-microelectronics")
  :setCost(105)
  :setColors("RGB")
  :setTime(26)
  :setPrerequisites({ "fw-signal-architecture", "processing-unit" })

Tech:get("fw-computational-arrays")
  :setCost(140)
  :setColors("RGB")
  :setTime(24)
  :setPrerequisites({ "fw-microelectronics", "modules", "electric-engine" })

Tech:get("fw-material-refinement")
  :setCost(105)
  :setColors("RGB")
  :setTime(24)
  :setPrerequisites({ "fw-metals-fabrication", "fw-beam-engineering", "sulfur-processing", "fluid-handling" })

Tech:get("fw-instrumentation")
  :setCost(120)
  :setColors("RGB")
  :setTime(24)
  :setPrerequisites({ "fw-electromechanical-systems", "solar-energy" })

Tech:get("fw-ribbon-conductors")
  :setCost(124)
  :setColors("RGB")
  :setTime(28)
  :setPrerequisites({ "fw-instrumentation", "fw-cable-looming" })

Tech:get("fw-systems-integration")
  :setCost(170)
  :setColors("RGB")
  :setTime(30)
  :setPrerequisites({ "fw-instrumentation", "fw-ribbon-conductors", "fw-microelectronics", "electric-engine" })

Tech:get("fw-sensor-integration")
  :setCost(165)
  :setColors("RGBP")
  :setTime(30)
  :setPrerequisites({ "fw-systems-integration", "fw-optical-instrumentation" })

Tech:get("fw-advanced-fabrication")
  :setCost(190)
  :setColors("RGBP")
  :setTime(28)
  :setPrerequisites({ "fw-material-refinement", "fw-systems-integration", "production-science-pack" })

Tech:get("fw-lightweight-framing")
  :setCost(180)
  :setColors("RGBP")
  :setTime(28)
  :setPrerequisites({ "fw-advanced-fabrication", "fw-beam-engineering" })

Tech:get("fw-propellant-synthesis")
  :setCost(190)
  :setColors("RGBC")
  :setTime(34)
  :setPrerequisites({ "fw-advanced-fabrication", "fw-polymer-chemistry", "military-3" })
