local Tech = require("__haul_lib__/utils/tech")

data:extend({
  {
    type = "technology",
    name = "fw-flux-catalysis",
    icon = "__FluxWorksAssets__/graphics/technology/fw-synthesizer.png",
    icon_size = 1024,
    prerequisites = { "fw-liquid-mining", "fw-material-refinement", "fw-flux-extraction" },
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
      { type = "unlock-recipe", recipe = "fw-flux-catalyst" },
    },
    order = "d-a[fw-flux-catalysis]",
  },
  {
    type = "technology",
    name = "fw-flux-yellow-catalysis",
    icon = "__FluxWorksAssets__/graphics/technology/fw-power-regulation.png",
    icon_size = 1024,
    prerequisites = { "fw-flux-catalysis", "fw-liquid-mining", "fw-material-refinement" },
    unit = {
      count = 300,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
      },
      time = 35,
    },
    effects = {},
    order = "d-b[fw-flux-yellow-catalysis]",
  },
  {
    type = "technology",
    name = "fw-flux-stabilization",
    icon = "__FluxWorksAssets__/graphics/technology/fw-synthesizer.png",
    icon_size = 1024,
    prerequisites = { "fw-flux-yellow-catalysis", "fw-sealed-systems", "fw-conductive-networks" },
    unit = {
      count = 340,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
      },
      time = 35,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-synthesis-plant" },
    },
    order = "d-c[fw-flux-stabilization]",
  },
  {
    type = "technology",
    name = "fw-harvester-systems",
    icon = "__FluxWorksAssets__/graphics/technology/fw-synthesizer.png",
    icon_size = 1024,
    prerequisites = { "fw-flux-stabilization", "fw-power-regulation" },
    unit = {
      count = 380,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
      },
      time = 35,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-harvester-head" },
      { type = "unlock-recipe", recipe = "fw-flux-harvester" },
      { type = "unlock-recipe", recipe = "fw-silica-beneficiation" },
      { type = "unlock-recipe", recipe = "fw-carbonic-washing" },
    },
    order = "d-d[fw-harvester-systems]",
  },
  {
    type = "technology",
    name = "fw-flux-structuring",
    icon = "__FluxWorksAssets__/graphics/technology/fw-conductive-networks.png",
    icon_size = 1024,
    prerequisites = { "fw-flux-stabilization", "fw-optical-instrumentation" },
    unit = {
      count = 420,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
      },
      time = 40,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-stabilized-flux-crystal" },
      { type = "unlock-recipe", recipe = "fw-flux-lattice" },
    },
    order = "d-e[fw-flux-structuring]",
  },
  {
    type = "technology",
    name = "fw-flux-red-energetics",
    icon = "__FluxWorksAssets__/graphics/technology/fw-arc-furnace.png",
    icon_size = 1024,
    prerequisites = { "fw-flux-stabilization", "fw-power-regulation" },
    unit = {
      count = 360,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
      },
      time = 35,
    },
    effects = {},
    order = "d-f[fw-flux-red-energetics]",
  },
  {
    type = "technology",
    name = "fw-flux-green-reclamation",
    icon = "__FluxWorksAssets__/graphics/technology/fw-biosystems-engineering.png",
    icon_size = 1024,
    prerequisites = { "fw-flux-stabilization", "fw-biosystems-engineering" },
    unit = {
      count = 360,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "agricultural-science-pack", 1 },
      },
      time = 35,
    },
    effects = {},
    order = "d-g[fw-flux-green-reclamation]",
  },
  {
    type = "technology",
    name = "fw-flux-metallurgy",
    icon = "__FluxWorksAssets__/graphics/technology/fw-arc-furnace.png",
    icon_size = 1024,
    prerequisites = { "fw-flux-red-energetics", "fw-metallurgic-assemblies" },
    unit = {
      count = 520,
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
      { type = "unlock-recipe", recipe = "fw-arc-foundry" },
      { type = "unlock-recipe", recipe = "fw-annealed-cermet" },
      { type = "unlock-recipe", recipe = "fw-arc-insulator-vitrification" },
    },
    order = "d-h[fw-flux-metallurgy]",
  },
  {
    type = "technology",
    name = "fw-flux-resonance",
    icon = "__FluxWorksAssets__/graphics/technology/fw-electromagnetic-architecture.png",
    icon_size = 1024,
    prerequisites = { "fw-flux-yellow-catalysis", "fw-flux-red-energetics", "fw-systems-integration" },
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
      { type = "unlock-recipe", recipe = "fw-condensed-flux-matrix" },
      { type = "unlock-recipe", recipe = "fw-resonance-substrate" },
    },
    order = "d-i[fw-flux-resonance]",
  },
  {
    type = "technology",
    name = "fw-resonance-assemblies",
    icon = "__FluxWorksAssets__/graphics/technology/fw-electromagnetic-architecture.png",
    icon_size = 1024,
    prerequisites = { "fw-flux-resonance", "fw-flux-structuring", "fw-flux-green-cultivation" },
    unit = {
      count = 760,
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
      { type = "unlock-recipe", recipe = "fw-flux-resonance-cell" },
    },
    order = "d-j[fw-resonance-assemblies]",
  },
  {
    type = "technology",
    name = "fw-flux-asteroid-harvesting",
    icon = "__FluxWorksAssets__/graphics/technology/fw-rocket-chunk-processing.png",
    icon_size = 190,
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
      { type = "unlock-recipe", recipe = "fw-flux-asteroid-refining" },
      { type = "unlock-recipe", recipe = "fw-flux-asteroid-deep-refining" },
    },
    order = "d-k[fw-flux-asteroid-harvesting]",
  },
  {
    type = "technology",
    name = "fw-flux-field-theory",
    icon = "__FluxWorksAssets__/graphics/technology/fw-electromagnetic-architecture.png",
    icon_size = 1024,
    prerequisites = { "fw-flux-asteroid-harvesting", "fw-electromagnetic-architecture", "quantum-processor" },
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
      { type = "unlock-recipe", recipe = "fw-silicon-ore-to-titanium-ore" },
      { type = "unlock-recipe", recipe = "fw-titanium-ore-to-uranium-ore" },
    },
    order = "d-l[fw-flux-field-theory]",
  },
  {
    type = "technology",
    name = "fw-aquilo-cryochemistry",
    icon = "__FluxWorksAssets__/graphics/technology/fw-cryogenic-control.png",
    icon_size = 1024,
    prerequisites = { "fw-flux-chemical-synthesis", "fw-cryogenic-control", "lithium-processing", "cryogenic-science-pack" },
    unit = {
      count = 980,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
        { "utility-science-pack", 1 },
        { "space-science-pack", 1 },
        { "cryogenic-science-pack", 1 },
      },
      time = 55,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-electrolyte-conditioning" },
      { type = "unlock-recipe", recipe = "fw-lithium-adsorption" },
      { type = "unlock-recipe", recipe = "fw-fluoroketone-synthesis" },
      { type = "unlock-recipe", recipe = "fw-spectral-coolant-blend" },
      { type = "unlock-recipe", recipe = "fw-aquilo-cryogel" },
    },
    order = "d-m[fw-aquilo-cryochemistry]",
  },
  {
    type = "technology",
    name = "fw-gleba-biochemistry",
    icon = "__FluxWorksAssets__/graphics/technology/fw-biosystems-engineering.png",
    icon_size = 1024,
    prerequisites = { "fw-flux-green-cultivation", "fw-biosystems-engineering", "agricultural-science-pack" },
    unit = {
      count = 1040,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
        { "utility-science-pack", 1 },
        { "space-science-pack", 1 },
        { "agricultural-science-pack", 1 },
      },
      time = 55,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-gleba-spore-resin" },
    },
    order = "d-ma[fw-gleba-biochemistry]",
  },
  {
    type = "technology",
    name = "fw-flux-chemical-synthesis",
    icon = "__FluxWorksAssets__/graphics/technology/fw-power-regulation.png",
    icon_size = 1024,
    prerequisites = { "fw-flux-field-theory", "fw-flux-yellow-catalysis", "fw-industrial-expansion" },
    unit = {
      count = 780,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
        { "utility-science-pack", 1 },
        { "space-science-pack", 1 },
      },
      time = 50,
    },
    effects = {},
    order = "d-n[fw-flux-chemical-synthesis]",
  },
  {
    type = "technology",
    name = "fw-vulcanus-pyrochemistry",
    icon = "__FluxWorksAssets__/graphics/technology/fw-arc-furnace.png",
    icon_size = 1024,
    prerequisites = { "fw-flux-metallurgy", "fw-flux-reactive-slurries", "metallurgic-science-pack" },
    unit = {
      count = 1080,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
        { "utility-science-pack", 1 },
        { "space-science-pack", 1 },
        { "metallurgic-science-pack", 1 },
      },
      time = 55,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-vulcanus-slag-cermet" },
    },
    order = "d-na[fw-vulcanus-pyrochemistry]",
  },
  {
    type = "technology",
    name = "fw-flux-reactive-slurries",
    icon = "__FluxWorksAssets__/graphics/technology/fw-power-regulation.png",
    icon_size = 1024,
    prerequisites = { "fw-flux-chemical-synthesis", "fw-flux-red-energetics", "fw-energetic-compounds" },
    unit = {
      count = 900,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
        { "utility-science-pack", 1 },
        { "space-science-pack", 1 },
      },
      time = 55,
    },
    effects = {},
    order = "d-o[fw-flux-reactive-slurries]",
  },
  {
    type = "technology",
    name = "fw-fulgora-electrochemistry",
    icon = "__FluxWorksAssets__/graphics/technology/fw-electromagnetic-architecture.png",
    icon_size = 1024,
    prerequisites = { "fw-electromagnetic-architecture", "fw-flux-field-theory", "electromagnetic-science-pack" },
    unit = {
      count = 1120,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
        { "utility-science-pack", 1 },
        { "space-science-pack", 1 },
        { "electromagnetic-science-pack", 1 },
      },
      time = 55,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-fulgora-static-mesh" },
    },
    order = "d-oa[fw-fulgora-electrochemistry]",
  },
  {
    type = "technology",
    name = "fw-flux-green-cultivation",
    icon = "__FluxWorksAssets__/graphics/technology/fw-biosystems-engineering.png",
    icon_size = 1024,
    prerequisites = { "fw-flux-field-theory", "fw-flux-green-reclamation", "fw-biosystems-engineering" },
    unit = {
      count = 820,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "utility-science-pack", 1 },
        { "space-science-pack", 1 },
        { "agricultural-science-pack", 1 },
      },
      time = 50,
    },
    effects = {},
    order = "d-p[fw-flux-green-cultivation]",
  },
  {
    type = "technology",
    name = "fw-flux-green-propagation",
    icon = "__FluxWorksAssets__/graphics/technology/fw-biosystems-engineering.png",
    icon_size = 1024,
    prerequisites = { "fw-flux-green-cultivation", "fw-flux-reactive-slurries" },
    unit = {
      count = 980,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "utility-science-pack", 1 },
        { "space-science-pack", 1 },
        { "agricultural-science-pack", 1 },
      },
      time = 55,
    },
    effects = {},
    order = "d-q[fw-flux-green-propagation]",
  },
  {
    type = "technology",
    name = "fw-flux-thermal-networks",
    icon = "__FluxWorksAssets__/graphics/technology/fw-arc-furnace.png",
    icon_size = 1024,
    prerequisites = { "fw-flux-field-theory", "fw-flux-red-energetics", "fw-cryogenic-control" },
    unit = {
      count = 860,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
        { "utility-science-pack", 1 },
        { "space-science-pack", 1 },
      },
      time = 55,
    },
    effects = {},
    order = "d-r[fw-flux-thermal-networks]",
  },
  {
    type = "technology",
    name = "fw-superconductive-systems",
    icon = "__FluxWorksAssets__/graphics/technology/fw-electromagnetic-architecture.png",
    icon_size = 1024,
    prerequisites = { "fw-aquilo-cryochemistry", "fw-electromagnetic-architecture", "fw-flux-thermal-networks", "electromagnetic-science-pack" },
    unit = {
      count = 1180,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
        { "utility-science-pack", 1 },
        { "space-science-pack", 1 },
        { "electromagnetic-science-pack", 1 },
        { "cryogenic-science-pack", 1 },
      },
      time = 60,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-superconductor-bath" },
      { type = "unlock-recipe", recipe = "fw-supercapacitor-conditioning" },
    },
    order = "d-s[fw-superconductive-systems]",
  },
  {
    type = "technology",
    name = "fw-flux-phase-engineering",
    icon = "__FluxWorksAssets__/graphics/technology/fw-electromagnetic-architecture.png",
    icon_size = 1024,
    prerequisites = { "fw-flux-field-theory", "fw-flux-resonance", "fw-cryogenic-control" },
    unit = {
      count = 980,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
        { "utility-science-pack", 1 },
        { "space-science-pack", 1 },
        { "electromagnetic-science-pack", 1 },
        { "cryogenic-science-pack", 1 },
      },
      time = 60,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-flux-phase-manifold" },
    },
    order = "d-t[fw-flux-phase-engineering]",
  },
  {
    type = "technology",
    name = "fw-flux-overdrive",
    icon = "__FluxWorksAssets__/graphics/technology/fw-promethium-stabilization.png",
    icon_size = 1024,
    prerequisites = { "fw-flux-thermal-networks", "fw-flux-phase-engineering", "fw-promethium-stabilization" },
    unit = {
      count = 1250,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
        { "utility-science-pack", 1 },
        { "space-science-pack", 1 },
        { "electromagnetic-science-pack", 1 },
        { "cryogenic-science-pack", 1 },
      },
      time = 60,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-promethium-matrix" },
    },
    order = "d-u[fw-flux-overdrive]",
  },
  {
    type = "technology",
    name = "fw-fusion-lattices",
    icon = "__FluxWorksAssets__/graphics/technology/fw-promethium-stabilization.png",
    icon_size = 1024,
    prerequisites = { "fw-superconductive-systems", "fw-flux-overdrive", "fusion-reactor-equipment" },
    unit = {
      count = 1450,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
        { "utility-science-pack", 1 },
        { "space-science-pack", 1 },
        { "electromagnetic-science-pack", 1 },
        { "cryogenic-science-pack", 1 },
        { "promethium-science-pack", 1 },
      },
      time = 65,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-fusion-power-cell-conditioning" },
    },
    order = "d-v[fw-fusion-lattices]",
  },
  {
    type = "technology",
    name = "fw-flux-synthesis",
    icon = "__FluxWorksAssets__/graphics/technology/fw-synthesizer.png",
    icon_size = 1024,
    prerequisites = { "fw-flux-phase-engineering", "fw-flux-chemical-synthesis", "fw-resonance-assemblies", "fw-computational-arrays" },
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
      { type = "unlock-recipe", recipe = "fw-flux-condenser" },
    },
    order = "d-w[fw-flux-synthesis]",
  },
  {
    type = "technology",
    name = "fw-flux-convergence",
    icon = "__FluxWorksAssets__/graphics/technology/fw-promethium-stabilization.png",
    icon_size = 1024,
    prerequisites = { "fw-flux-synthesis", "fw-flux-overdrive", "fw-flux-green-propagation" },
    unit = {
      count = 1500,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
        { "utility-science-pack", 1 },
        { "space-science-pack", 1 },
        { "metallurgic-science-pack", 1 },
        { "agricultural-science-pack", 1 },
        { "electromagnetic-science-pack", 1 },
        { "cryogenic-science-pack", 1 },
      },
      time = 65,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-rift-stabilizer" },
      { type = "unlock-recipe", recipe = "fw-flux-metallic-synthesis" },
    },
    order = "d-x[fw-flux-convergence]",
  },
  {
    type = "technology",
    name = "fw-rift-harmonics",
    icon = "__FluxWorksAssets__/graphics/technology/fw-synthesizer.png",
    icon_size = 1024,
    prerequisites = { "fw-flux-convergence", "fw-fusion-lattices", "fw-promethium-stabilization", "promethium-science-pack" },
    unit = {
      count = 1750,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
        { "utility-science-pack", 1 },
        { "space-science-pack", 1 },
        { "metallurgic-science-pack", 1 },
        { "agricultural-science-pack", 1 },
        { "electromagnetic-science-pack", 1 },
        { "cryogenic-science-pack", 1 },
        { "promethium-science-pack", 1 },
      },
      time = 70,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-rift-seed-crystallization" },
    },
    order = "d-y[fw-rift-harmonics]",
  },
})

Tech:get("fw-flux-catalysis")
  :setCost(200)
  :setColors("RGB")
  :setTime(30)
  :setPrerequisites({ "fw-liquid-mining", "fw-material-refinement", "fw-flux-extraction" })

Tech:get("fw-flux-yellow-catalysis")
  :setCost(260)
  :setColors("RGBP")
  :setTime(35)
  :setPrerequisites({ "fw-flux-catalysis", "fw-liquid-mining", "fw-material-refinement" })

Tech:get("fw-flux-stabilization")
  :setCost(300)
  :setColors("RGBP")
  :setTime(35)
  :setPrerequisites({ "fw-flux-yellow-catalysis", "fw-sealed-systems", "fw-conductive-networks" })

Tech:get("fw-harvester-systems")
  :setCost(340)
  :setColors("RGBP")
  :setTime(35)
  :setPrerequisites({ "fw-flux-stabilization", "fw-power-regulation" })

Tech:get("fw-flux-structuring")
  :setCost(360)
  :setColors("RGBP")
  :setTime(40)
  :setPrerequisites({ "fw-flux-stabilization", "fw-optical-instrumentation" })

Tech:get("fw-flux-red-energetics")
  :setCost(340)
  :setColors("RGBP")
  :setTime(35)
  :setPrerequisites({ "fw-flux-stabilization", "fw-power-regulation" })

Tech:get("fw-flux-green-reclamation")
  :setCost(320)
  :setColors("RGBA")
  :setTime(35)
  :setPrerequisites({ "fw-flux-stabilization", "fw-biosystems-engineering" })

Tech:get("fw-flux-metallurgy")
  :setCost(500)
  :setColors("RGBPYW")
  :setTime(40)
  :setPrerequisites({ "fw-flux-red-energetics", "fw-metallurgic-assemblies" })

Tech:get("fw-flux-resonance")
  :setCost(480)
  :setColors("RGBPY")
  :setTime(40)
  :setPrerequisites({ "fw-flux-yellow-catalysis", "fw-flux-red-energetics", "fw-systems-integration" })

Tech:get("fw-resonance-assemblies")
  :setCost(680)
  :setColors("RGBPYW")
  :setTime(45)
  :setPrerequisites({ "fw-flux-resonance", "fw-flux-structuring", "fw-flux-green-cultivation" })

Tech:get("fw-flux-asteroid-harvesting")
  :setCost(450)
  :setColors("RGBPYW")
  :setTime(40)
  :setPrerequisites({ "fw-flux-resonance", "rocket-chunk-processing", "fw-flux-extraction" })

Tech:get("fw-flux-field-theory")
  :setCost(760)
  :setColors("RGBPYW")
  :setTime(45)
  :setPrerequisites({ "fw-flux-asteroid-harvesting", "fw-electromagnetic-architecture", "quantum-processor" })

Tech:get("fw-flux-chemical-synthesis")
  :setCost(720)
  :setColors("RGBPYW")
  :setTime(50)
  :setPrerequisites({ "fw-flux-field-theory", "fw-flux-yellow-catalysis", "fw-industrial-expansion" })

Tech:get("fw-aquilo-cryochemistry")
  :setCost(980)
  :setColors("RGBPYWC")
  :setTime(55)
  :setPrerequisites({ "fw-flux-chemical-synthesis", "fw-cryogenic-control", "lithium-processing", "cryogenic-science-pack" })

Tech:get("fw-gleba-biochemistry")
  :setCost(1040)
  :setColors("RGBYWA")
  :setTime(55)
  :setPrerequisites({ "fw-flux-green-cultivation", "fw-biosystems-engineering", "agricultural-science-pack" })

Tech:get("fw-flux-reactive-slurries")
  :setCost(900)
  :setColors("RGBPYW")
  :setTime(55)
  :setPrerequisites({ "fw-flux-chemical-synthesis", "fw-flux-red-energetics", "fw-energetic-compounds" })

Tech:get("fw-vulcanus-pyrochemistry")
  :setCost(1080)
  :setColors("RGBPYWV")
  :setTime(55)
  :setPrerequisites({ "fw-flux-metallurgy", "fw-flux-reactive-slurries", "metallurgic-science-pack" })

Tech:get("fw-fulgora-electrochemistry")
  :setCost(1120)
  :setColors("RGBPYWE")
  :setTime(55)
  :setPrerequisites({ "fw-electromagnetic-architecture", "fw-flux-field-theory", "electromagnetic-science-pack" })

Tech:get("fw-flux-green-cultivation")
  :setCost(760)
  :setColors("RGBYWA")
  :setTime(50)
  :setPrerequisites({ "fw-flux-field-theory", "fw-flux-green-reclamation", "fw-biosystems-engineering" })

Tech:get("fw-flux-green-propagation")
  :setCost(980)
  :setColors("RGBYWA")
  :setTime(55)
  :setPrerequisites({ "fw-flux-green-cultivation", "fw-flux-reactive-slurries" })

Tech:get("fw-flux-thermal-networks")
  :setCost(860)
  :setColors("RGBPYW")
  :setTime(55)
  :setPrerequisites({ "fw-flux-field-theory", "fw-flux-red-energetics", "fw-cryogenic-control" })

Tech:get("fw-superconductive-systems")
  :setCost(1240)
  :setColors("RGBPYWEC")
  :setTime(65)
  :setPrerequisites({ "fw-aquilo-cryochemistry", "fw-fulgora-electrochemistry", "fw-electromagnetic-architecture", "fw-flux-thermal-networks", "electromagnetic-science-pack" })

Tech:get("fw-flux-phase-engineering")
  :setCost(900)
  :setColors("RGBPYWFC")
  :setTime(65)
  :setPrerequisites({ "fw-flux-field-theory", "fw-flux-resonance", "fw-cryogenic-control", "fw-flux-synthesis" })

Tech:get("fw-flux-overdrive")
  :setCost(1320)
  :setColors("RGBPYWFC")
  :setTime(65)
  :setPrerequisites({ "fw-flux-thermal-networks", "fw-flux-phase-engineering", "fw-superconductive-systems", "fw-promethium-stabilization" })

Tech:get("fw-fusion-lattices")
  :setCost(1540)
  :setColors("RGBPYWVFCP")
  :setTime(70)
  :setPrerequisites({ "fw-superconductive-systems", "fw-flux-overdrive", "fw-vulcanus-pyrochemistry", "fusion-reactor-equipment" })

Tech:get("fw-flux-synthesis")
  :setCost(980)
  :setColors("RGBPYW")
  :setTime(65)
  :setPrerequisites({ "fw-flux-resonance", "fw-flux-chemical-synthesis", "fw-resonance-assemblies", "fw-computational-arrays" })

Tech:get("fw-flux-convergence")
  :setCost(1620)
  :setColors("RGBPYWVFCA")
  :setTime(70)
  :setPrerequisites({ "fw-flux-synthesis", "fw-flux-overdrive", "fw-flux-green-propagation", "fw-aquilo-cryochemistry", "fw-gleba-biochemistry", "fw-fulgora-electrochemistry", "fw-vulcanus-pyrochemistry" })

Tech:get("fw-rift-harmonics")
  :setCost(1880)
  :setColors("RGBPYWVFCAP")
  :setTime(75)
  :setPrerequisites({ "fw-flux-convergence", "fw-fusion-lattices", "fw-promethium-stabilization", "promethium-science-pack" })
