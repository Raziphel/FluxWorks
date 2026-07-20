local Tech = require("__haul_lib__/utils/tech")

data:extend({
  {
    type = "technology",
    name = "fw-flux-catalysis",
    icon = "__FluxWorksAssets__/graphics/icons/items/flux-1-light.png",
    icon_size = 64,
    prerequisites = { "fw-liquid-mining", "fw-material-refinement", "fw-flux-extraction" },
    unit = {
      count = 140,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
      },
      time = 30,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-flux-catalyst" },
      { type = "unlock-recipe", recipe = "fw-flux-fired-ceramic-annealing" },
      { type = "unlock-recipe", recipe = "fw-flux-cermet-tempering" },
    },
    order = "d-a[fw-flux-catalysis]",
  },
  {
    type = "technology",
    name = "fw-flux-yellow-catalysis",
    icon = "__FluxWorksAssets__/graphics/icons/items/flux-light.png",
    icon_size = 64,
    prerequisites = { "fw-flux-catalysis", "fw-liquid-mining", "fw-sealed-systems" },
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
    effects = {},
    order = "d-b[fw-flux-yellow-catalysis]",
  },
  {
    type = "technology",
    name = "fw-flux-stabilization",
    icon = "__FluxWorksAssets__/graphics/technology/fw-flux-stabilization.png",
    icon_size = 256,
    prerequisites = { "fw-flux-yellow-catalysis", "fw-sealed-systems", "fw-conductive-networks", "fw-ceramic-engineering" },
    unit = {
      count = 260,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
      },
      time = 40,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-synthesis-plant" },
    },
    order = "d-c[fw-flux-stabilization]",
  },
  {
    type = "technology",
    name = "fw-harvester-systems",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-harvester-head.png",
    icon_size = 64,
    prerequisites = { "fw-flux-stabilization", "fw-power-regulation", "fw-liquid-mining" },
    unit = {
      count = 320,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
      },
      time = 40,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-harvester-head" },
      { type = "unlock-recipe", recipe = "fw-flux-harvester" },
      { type = "unlock-recipe", recipe = "fw-silica-beneficiation" },
      { type = "unlock-recipe", recipe = "fw-carbonic-washing" },
      { type = "unlock-recipe", recipe = "fw-bauxite-slurry-clarification" },
      { type = "unlock-recipe", recipe = "fw-tin-ore-beneficiation" },
      { type = "unlock-recipe", recipe = "fw-lead-ore-beneficiation" },
    },
    order = "d-d[fw-harvester-systems]",
  },
  {
    type = "technology",
    name = "fw-flux-structuring",
    icon = "__FluxWorksAssets__/graphics/icons/items/flux-2-light.png",
    icon_size = 64,
    prerequisites = { "fw-flux-stabilization", "fw-flux-yellow-catalysis", "fw-optical-instrumentation" },
    unit = {
      count = 340,
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
    name = "fw-flux-purple-transmutation",
    icon = "__FluxWorksAssets__/graphics/icons/items/flux-1.png",
    icon_size = 64,
    prerequisites = { "fw-harvester-systems", "fw-material-foundations" },
    unit = {
      count = 380,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
      },
      time = 40,
    },
    effects = {},
    order = "d-ea[fw-flux-purple-transmutation]",
  },
  {
    type = "technology",
    name = "fw-flux-red-energetics",
    icon = "__base__/graphics/icons/nuclear-fuel.png",
    icon_size = 64,
    prerequisites = { "fw-flux-stabilization", "fw-power-regulation" },
    unit = {
      count = 320,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
      },
      time = 40,
    },
    effects = {},
    order = "d-f[fw-flux-red-energetics]",
  },
  {
    type = "technology",
    name = "fw-flux-green-reclamation",
    icon = "__space-age__/graphics/icons/spoilage.png",
    icon_size = 64,
    prerequisites = { "fw-flux-stabilization", "biochamber", "agricultural-science-pack" },
    unit = {
      count = 360,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "agricultural-science-pack", 1 },
      },
      time = 40,
    },
    effects = {},
    order = "d-g[fw-flux-green-reclamation]",
  },
  {
    type = "technology",
    name = "fw-flux-metallurgy",
    icon = "__finely-crafted-graphics__/graphics/advanced-foundry/advanced-foundry-icon.png",
    icon_size = 64,
    prerequisites = { "fw-flux-red-energetics", "fw-metallurgic-assemblies", "fw-ceramic-engineering" },
    unit = {
      count = 580,
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
      { type = "unlock-recipe", recipe = "fw-arc-foundry" },
      { type = "unlock-recipe", recipe = "fw-annealed-cermet" },
      { type = "unlock-recipe", recipe = "fw-arc-insulator-vitrification" },
    },
    order = "d-h[fw-flux-metallurgy]",
  },
  {
    type = "technology",
    name = "fw-flux-resonance",
    icon = "__FluxWorksAssets__/graphics/technology/fw-flux-resonance.png",
    icon_size = 1024,
    prerequisites = { "fw-flux-structuring", "fw-flux-red-energetics", "fw-flux-green-reclamation", "fw-harvester-systems" },
    unit = {
      count = 520,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
        { "utility-science-pack", 1 },
      },
      time = 45,
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
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-flux-resonance-cell.png",
    icon_size = 1254,
    prerequisites = { "fw-flux-resonance", "fw-electromagnetic-architecture" },
    unit = {
      count = 720,
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
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-rocket-chunk.png",
    icon_size = 64,
    prerequisites = { "fw-resonance-assemblies", "rocket-chunk-processing", "fw-orbital-hardening" },
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
      { type = "unlock-recipe", recipe = "fw-flux-asteroid-refining" },
    },
    order = "d-k[fw-flux-asteroid-harvesting]",
  },
  {
    type = "technology",
    name = "fw-flux-field-theory",
    icon = "__FluxWorksAssets__/graphics/technology/fw-flux-field-theory.png",
    icon_size = 256,
    prerequisites = { "fw-flux-resonance", "fw-resonance-assemblies", "fw-flux-asteroid-harvesting" },
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
    icon = "__space-age__/graphics/icons/cryogenic-plant.png",
    icon_size = 64,
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
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-resin.png",
    icon_size = 64,
    prerequisites = { "fw-flux-green-cultivation", "biochamber", "agricultural-science-pack" },
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
    icon = "__FluxWorksAssets__/graphics/technology/fw-flux-chemical-synthesis.png",
    icon_size = 256,
    prerequisites = { "fw-flux-field-theory", "fw-flux-yellow-catalysis", "fw-polymer-chemistry", "fw-industrial-expansion" },
    unit = {
      count = 820,
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
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-vulcanus-slag-cermet.png",
    icon_size = 128,
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
    icon = "__base__/graphics/icons/explosives.png",
    icon_size = 64,
    prerequisites = { "fw-flux-chemical-synthesis", "fw-flux-red-energetics", "fw-energetic-compounds", "fw-metallurgic-assemblies" },
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
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-em-core.png",
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
    icon = "__FluxWorksAssets__/graphics/technology/fw-flux-green-cultivation.png",
    icon_size = 256,
    prerequisites = { "fw-flux-field-theory", "fw-flux-green-reclamation", "biochamber" },
    unit = {
      count = 860,
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
    icon = "__FluxWorksAssets__/graphics/technology/fw-green-cycle-productivity.png",
    icon_size = 1024,
    prerequisites = { "fw-flux-green-cultivation", "fw-flux-chemical-synthesis" },
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
    icon = "__Krastorio2Assets__/technologies/fusion-energy.png",
    icon_size = 256,
    prerequisites = { "fw-flux-field-theory", "fw-flux-metallurgy", "fw-cryogenic-control" },
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
    icon = "__FluxWorksAssets__/graphics/technology/fw-superconductive-productivity.png",
    icon_size = 1024,
    prerequisites = { "fw-aquilo-cryochemistry", "fw-fulgora-electrochemistry", "fw-flux-thermal-networks" },
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
    icon = "__Krastorio2Assets__/technologies/matter-processing.png",
    icon_size = 256,
    prerequisites = { "fw-flux-field-theory", "fw-resonance-assemblies", "fw-superconductive-systems" },
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
      { type = "unlock-recipe", recipe = "fw-rift-seed-crystallization" },
    },
    order = "d-t[fw-flux-phase-engineering]",
  },
  {
    type = "technology",
    name = "fw-deep-phase-storage",
    icon = "__FluxWorksAssets__/graphics/technology/fw-deep-phase-storage.png",
    icon_size = 256,
    prerequisites = { "fw-flux-phase-engineering", "fw-flux-convergence" },
    unit = {
      count = 3200,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
        { "utility-science-pack", 1 },
        { "space-science-pack", 1 },
        { "agricultural-science-pack", 1 },
        { "metallurgic-science-pack", 1 },
        { "electromagnetic-science-pack", 1 },
        { "cryogenic-science-pack", 1 },
      },
      time = 90,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-phase-anchor" },
      { type = "unlock-recipe", recipe = "fw-entanglement-core" },
      { type = "unlock-recipe", recipe = "fw-compression-baffle" },
      { type = "unlock-recipe", recipe = "fw-phase-vault" },
    },
    order = "d-ta[fw-deep-phase-storage]",
  },
  {
    type = "technology",
    name = "fw-spectral-fluid-retention",
    icon = "__FluxWorksAssets__/graphics/icons/items/fluid-memory-storage/fluid-memory-unit.png",
    icon_size = 64,
    prerequisites = { "fw-deep-phase-storage", "fw-aquilo-cryochemistry", "fw-flux-thermal-networks" },
    unit = {
      count = 4200,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
        { "utility-science-pack", 1 },
        { "space-science-pack", 1 },
        { "agricultural-science-pack", 1 },
        { "metallurgic-science-pack", 1 },
        { "electromagnetic-science-pack", 1 },
        { "cryogenic-science-pack", 1 },
      },
      time = 105,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-reservoir-lining" },
      { type = "unlock-recipe", recipe = "fw-thermal-phase-gasket" },
      { type = "unlock-recipe", recipe = "fw-spectral-reservoir" },
    },
    order = "d-tb[fw-spectral-fluid-retention]",
  },
  {
    type = "technology",
    name = "fw-rift-logistics",
    icon = "__FluxWorksAssets__/graphics/icons/items/late-utility/fw-rift-coupler.png",
    icon_size = 1024,
    prerequisites = {
      "fw-rift-harmonics",
      "fw-deep-phase-storage",
      "fw-spectral-fluid-retention",
      "fw-flux-overdrive",
      "fw-fulgora-electrochemistry",
    },
    unit = {
      count = 6000,
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
      time = 120,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-rift-coupler" },
      { type = "unlock-recipe", recipe = "fw-rift-exchange-gate" },
      { type = "unlock-recipe", recipe = "fw-rift-exchange-fluid-gate" },
    },
    order = "d-tc[fw-rift-logistics]",
  },
  {
    type = "technology",
    name = "fw-flux-overdrive",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-condensed-flux-matrix.png",
    icon_size = 64,
    prerequisites = { "fw-flux-thermal-networks", "fw-superconductive-systems", "fw-vulcanus-pyrochemistry", "fw-promethium-stabilization" },
    unit = {
      count = 1320,
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
    effects = {},
    order = "d-u[fw-flux-overdrive]",
  },
  {
    type = "technology",
    name = "fw-fusion-lattices",
    icon = "__space-age__/graphics/icons/fusion-power-cell.png",
    icon_size = 64,
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
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-quantum-computer.png",
    icon_size = 64,
    prerequisites = { "fw-flux-phase-engineering", "fw-flux-chemical-synthesis", "fw-resonance-assemblies" },
    unit = {
      count = 1020,
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
      { type = "unlock-recipe", recipe = "fw-quantum-computer" },
      { type = "unlock-recipe", recipe = "fw-flux-condenser" },
      { type = "unlock-recipe", recipe = "fw-flux-metallic-synthesis" },
    },
    order = "d-w[fw-flux-synthesis]",
  },
  {
    type = "technology",
    name = "fw-flux-convergence",
    icon = "__Krastorio2Assets__/icons/items/matter-stabilizer.png",
    icon_size = 64,
    prerequisites = {
      "fw-flux-synthesis",
      "fw-flux-overdrive",
      "fw-flux-green-propagation",
      "fw-aquilo-cryochemistry",
      "fw-gleba-biochemistry",
      "fw-fulgora-electrochemistry",
      "fw-vulcanus-pyrochemistry",
      "fw-promethium-stabilization",
    },
    unit = {
      count = 1620,
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
    },
    order = "d-x[fw-flux-convergence]",
  },
  {
    type = "technology",
    name = "fw-rift-harmonics",
    icon = "__FluxWorksAssets__/graphics/icons/items/late-utility/fw-entanglement-core.png",
    icon_size = 1024,
    prerequisites = { "fw-flux-convergence", "fw-fusion-lattices", "fw-spectral-fluid-retention" },
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
      },
      time = 70,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-model-lattice" },
    },
    order = "d-y[fw-rift-harmonics]",
  },
  {
    type = "technology",
    name = "fw-origin-infrastructure",
    icon = "__space-age__/graphics/icons/quantum-processor.png",
    icon_size = 64,
    prerequisites = { "fw-rift-harmonics", "fw-rift-logistics" },
    unit = {
      count = 2200,
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
      time = 75,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-origin-forge" },
      { type = "unlock-recipe", recipe = "fw-storm-spine-segment" },
      { type = "unlock-recipe", recipe = "fw-origin-crucible-lining" },
      { type = "unlock-recipe", recipe = "fw-harmonic-lattice-core" },
    },
    order = "d-z[fw-origin-infrastructure]",
  },
  {
    type = "technology",
    name = "fw-storm-megastructures",
    icon = "__space-age__/graphics/icons/promethium-science-pack.png",
    icon_size = 64,
    prerequisites = { "fw-origin-infrastructure", "fw-flux-convergence" },
    unit = {
      count = 2800,
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
      time = 90,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-living-reactor-weave" },
      { type = "unlock-recipe", recipe = "fw-origin-catalyst-manifold" },
      { type = "unlock-recipe", recipe = "fw-storm-spine" },
      { type = "unlock-recipe", recipe = "fw-origin-crucible" },
    },
    order = "e-a[fw-storm-megastructures]",
  },
  {
    type = "technology",
    name = "fw-origin-transcendence",
    icon = "__FluxWorksAssets__/graphics/icons/items/origin-projects/fw-origin-singularity.png",
    icon_size = 256,
    prerequisites = { "fw-storm-megastructures" },
    unit = {
      count = 3600,
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
      time = 120,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-universal-collapse-core" },
      { type = "unlock-recipe", recipe = "fw-genesis-ark" },
      { type = "unlock-recipe", recipe = "fw-origin-singularity" },
    },
    order = "e-b[fw-origin-transcendence]",
  },
})

Tech:get("fw-flux-catalysis")
  :setCost(140)
  :setColors("RGC")
  :setTime(30)
  :setPrerequisites({ "fw-liquid-mining", "fw-material-refinement", "fw-flux-extraction" })

Tech:get("fw-flux-yellow-catalysis")
  :setCost(220)
  :setColors("RGBP")
  :setTime(35)
  :setPrerequisites({ "fw-flux-catalysis", "fw-liquid-mining", "fw-sealed-systems" })

Tech:get("fw-flux-stabilization")
  :setCost(260)
  :setColors("RGBP")
  :setTime(40)
  :setPrerequisites({ "fw-flux-yellow-catalysis", "fw-sealed-systems", "fw-conductive-networks", "fw-ceramic-engineering" })

Tech:get("fw-harvester-systems")
  :setCost(320)
  :setColors("RGBP")
  :setTime(40)
  :setPrerequisites({ "fw-flux-stabilization", "fw-power-regulation", "fw-liquid-mining" })

Tech:get("fw-flux-purple-transmutation")
  :setCost(380)
  :setColors("RGBP")
  :setTime(40)
  :setPrerequisites({ "fw-harvester-systems", "fw-material-foundations" })

Tech:get("fw-flux-structuring")
  :setCost(340)
  :setColors("RGBP")
  :setTime(40)
  :setPrerequisites({ "fw-flux-stabilization", "fw-flux-yellow-catalysis", "fw-optical-instrumentation" })

Tech:get("fw-flux-red-energetics")
  :setCost(320)
  :setColors("RGBP")
  :setTime(40)
  :setPrerequisites({ "fw-flux-stabilization", "fw-power-regulation" })

Tech:get("fw-flux-green-reclamation")
  :setCost(360)
  :setColors("RGBA")
  :setTime(40)
  :setPrerequisites({ "fw-flux-stabilization", "biochamber", "agricultural-science-pack" })

Tech:get("fw-flux-metallurgy")
  :setCost(580)
  :setColors("RGBPYW")
  :setTime(45)
  :setPrerequisites({ "fw-flux-red-energetics", "fw-metallurgic-assemblies", "fw-ceramic-engineering" })

Tech:get("fw-flux-resonance")
  :setCost(520)
  :setColors("RGBPY")
  :setTime(45)
  :setPrerequisites({ "fw-flux-structuring", "fw-flux-red-energetics", "fw-flux-green-reclamation", "fw-flux-purple-transmutation" })

Tech:get("fw-resonance-assemblies")
  :setCost(720)
  :setColors("RGBPYW")
  :setTime(45)
  :setPrerequisites({ "fw-flux-resonance", "fw-electromagnetic-architecture" })

Tech:get("fw-flux-asteroid-harvesting")
  :setCost(520)
  :setColors("RGBPYW")
  :setTime(40)
  :setPrerequisites({ "fw-resonance-assemblies", "rocket-chunk-processing", "fw-orbital-hardening" })

Tech:get("fw-flux-field-theory")
  :setCost(760)
  :setColors("RGBPYW")
  :setTime(45)
  :setPrerequisites({ "fw-flux-resonance", "fw-resonance-assemblies", "fw-flux-asteroid-harvesting" })

Tech:get("fw-flux-chemical-synthesis")
  :setCost(820)
  :setColors("RGBPYW")
  :setTime(50)
  :setPrerequisites({ "fw-flux-field-theory", "fw-flux-yellow-catalysis", "fw-polymer-chemistry", "fw-industrial-expansion" })

Tech:get("fw-aquilo-cryochemistry")
  :setCost(980)
  :setColors("RGBPYWC")
  :setTime(55)
  :setPrerequisites({ "fw-flux-chemical-synthesis", "fw-cryogenic-control", "lithium-processing", "cryogenic-science-pack" })

Tech:get("fw-gleba-biochemistry")
  :setCost(1040)
  :setColors("RGBYWA")
  :setTime(55)
  :setPrerequisites({ "fw-flux-green-cultivation", "biochamber", "agricultural-science-pack" })

Tech:get("fw-flux-reactive-slurries")
  :setCost(900)
  :setColors("RGBPYW")
  :setTime(55)
  :setPrerequisites({ "fw-flux-chemical-synthesis", "fw-flux-red-energetics", "fw-energetic-compounds", "fw-metallurgic-assemblies" })

Tech:get("fw-origin-infrastructure")
  :setCost(2200)
  :setColors("RGBPYWAC")
  :setTime(75)
  :setPrerequisites({ "fw-rift-harmonics", "fw-rift-logistics", "fw-superconductive-systems" })

Tech:get("fw-storm-megastructures")
  :setCost(2800)
  :setColors("RGBPYWAC")
  :setTime(90)
  :setPrerequisites({ "fw-origin-infrastructure", "fw-fusion-lattices", "fw-flux-convergence" })

Tech:get("fw-origin-transcendence")
  :setCost(3600)
  :setColors("RGBPYWAC")
  :setTime(120)
  :setPrerequisites({ "fw-storm-megastructures" })

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
  :setCost(860)
  :setColors("RGBYWA")
  :setTime(50)
  :setPrerequisites({ "fw-flux-field-theory", "fw-flux-green-reclamation", "biochamber" })

Tech:get("fw-flux-green-propagation")
  :setCost(980)
  :setColors("RGBYWA")
  :setTime(55)
  :setPrerequisites({ "fw-flux-green-cultivation", "fw-flux-chemical-synthesis" })

Tech:get("fw-flux-thermal-networks")
  :setCost(860)
  :setColors("RGBPYW")
  :setTime(55)
  :setPrerequisites({ "fw-flux-field-theory", "fw-flux-metallurgy", "fw-cryogenic-control" })

Tech:get("fw-superconductive-systems")
  :setCost(1240)
  :setColors("RGBPYWEC")
  :setTime(65)
  :setPrerequisites({ "fw-aquilo-cryochemistry", "fw-fulgora-electrochemistry", "fw-flux-thermal-networks" })

Tech:get("fw-flux-phase-engineering")
  :setCost(900)
  :setColors("RGBPYWFC")
  :setTime(65)
  :setPrerequisites({ "fw-flux-field-theory", "fw-resonance-assemblies", "fw-superconductive-systems" })

Tech:get("fw-deep-phase-storage")
  :setCost(1280)
  :setColors("RGBPYWEC")
  :setTime(60)
  :setPrerequisites({ "fw-flux-phase-engineering", "fw-flux-convergence" })

Tech:get("fw-spectral-fluid-retention")
  :setCost(1420)
  :setColors("RGBPYWEC")
  :setTime(65)
  :setPrerequisites({ "fw-deep-phase-storage", "fw-aquilo-cryochemistry", "fw-flux-thermal-networks" })

Tech:get("fw-rift-logistics")
  :setCost(1760)
  :setColors("RGBPYWVEACP")
  :setTime(70)
  :setPrerequisites({
    "fw-rift-harmonics",
    "fw-deep-phase-storage",
    "fw-spectral-fluid-retention",
    "fw-flux-overdrive",
    "fw-fulgora-electrochemistry"
  })

Tech:get("fw-flux-overdrive")
  :setCost(1320)
  :setColors("RGBPYWFC")
  :setTime(65)
  :setPrerequisites({ "fw-flux-thermal-networks", "fw-superconductive-systems", "fw-vulcanus-pyrochemistry", "fw-promethium-stabilization" })

Tech:get("fw-fusion-lattices")
  :setCost(1540)
  :setColors("RGBPYWVFCP")
  :setTime(70)
  :setPrerequisites({ "fw-superconductive-systems", "fw-flux-overdrive", "fw-vulcanus-pyrochemistry", "fusion-reactor-equipment" })

Tech:get("fw-flux-synthesis")
  :setCost(1020)
  :setColors("RGBPYW")
  :setTime(65)
  :setPrerequisites({ "fw-flux-phase-engineering", "fw-flux-chemical-synthesis", "fw-resonance-assemblies" })

Tech:get("fw-flux-convergence")
  :setCost(1620)
  :setColors("RGBPYWVFCA")
  :setTime(70)
  :setPrerequisites({ "fw-flux-synthesis", "fw-flux-overdrive", "fw-flux-green-propagation", "fw-aquilo-cryochemistry", "fw-gleba-biochemistry", "fw-fulgora-electrochemistry", "fw-vulcanus-pyrochemistry", "fw-promethium-stabilization" })

Tech:get("fw-rift-harmonics")
  :setCost(1880)
  :setColors("RGBPYWVFCAP")
  :setTime(75)
  :setPrerequisites({ "fw-flux-convergence", "fw-fusion-lattices", "fw-spectral-fluid-retention" })
