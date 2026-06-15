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
      { type = "unlock-recipe", recipe = "fw-flux-catalyst" },
    },
    order = "d-a[fw-flux-catalysis]",
  },
  {
    type = "technology",
    name = "fw-flux-stabilization",
    icon = "__FluxWorksAssets__/graphics/technology/fw-synthesizer.png",
    icon_size = 1024,
    prerequisites = { "fw-flux-catalysis", "fw-sealed-systems", "fw-conductive-networks" },
    unit = {
      count = 280,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
      },
      time = 30,
    },
    effects = {
      { type = "unlock-recipe", recipe = "fw-stabilized-flux-crystal" },
      { type = "unlock-recipe", recipe = "fw-flux-lattice" },
    },
    order = "d-b[fw-flux-stabilization]",
  },
  {
    type = "technology",
    name = "fw-flux-yellow-catalysis",
    icon = "__FluxWorksAssets__/graphics/technology/fw-power-regulation.png",
    icon_size = 1024,
    prerequisites = { "fw-flux-stabilization", "fw-liquid-mining", "fw-material-refinement" },
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
    effects = {
      { type = "unlock-recipe", recipe = "fw-yellow-flux-chlorine-pressurization" },
      { type = "unlock-recipe", recipe = "fw-yellow-flux-latex-suspension" },
      { type = "unlock-recipe", recipe = "fw-yellow-flux-sulfur-bonding" },
      { type = "unlock-recipe", recipe = "fw-yellow-flux-acid-synthesis" },
    },
    order = "d-c[fw-flux-yellow-catalysis]",
  },
  {
    type = "technology",
    name = "fw-flux-red-energetics",
    icon = "__FluxWorksAssets__/graphics/technology/fw-arc-furnace.png",
    icon_size = 256,
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
    effects = {
      { type = "unlock-recipe", recipe = "fw-red-flux-fuel-compaction" },
    },
    order = "d-d[fw-flux-red-energetics]",
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
    effects = {
      { type = "unlock-recipe", recipe = "fw-green-flux-spoilage-reclamation" },
    },
    order = "d-e[fw-flux-green-reclamation]",
  },
  {
    type = "technology",
    name = "fw-flux-resonance",
    icon = "__FluxWorksAssets__/graphics/technology/fw-arc-furnace.png",
    icon_size = 256,
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
      { type = "unlock-recipe", recipe = "fw-flux-resonance-cell" },
    },
    order = "d-f[fw-flux-resonance]",
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
      { type = "unlock-recipe", recipe = "fw-flux-asteroid-refining" },
      { type = "unlock-recipe", recipe = "fw-flux-asteroid-deep-refining" },
    },
    order = "d-g[fw-flux-asteroid-harvesting]",
  },
  {
    type = "technology",
    name = "fw-flux-field-theory",
    icon = "__FluxWorksAssets__/graphics/technology/fw-arc-furnace.png",
    icon_size = 256,
    prerequisites = { "fw-flux-asteroid-harvesting", "fw-electromagnetic-architecture", "utility-science-pack" },
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
    order = "d-h[fw-flux-field-theory]",
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
    effects = {
      { type = "unlock-recipe", recipe = "fw-yellow-flux-resin-polymerization" },
      { type = "unlock-recipe", recipe = "fw-yellow-flux-rubber-vulcanization" },
      { type = "unlock-recipe", recipe = "fw-yellow-flux-battery-electrolyte" },
    },
    order = "d-i[fw-flux-chemical-synthesis]",
  },
  {
    type = "technology",
    name = "fw-flux-reactive-slurries",
    icon = "__FluxWorksAssets__/graphics/technology/fw-power-regulation.png",
    icon_size = 1024,
    prerequisites = { "fw-flux-chemical-synthesis", "fw-red-flux-energetics" },
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
    effects = {
      { type = "unlock-recipe", recipe = "fw-yellow-flux-blasting-gel" },
      { type = "unlock-recipe", recipe = "fw-yellow-flux-reactive-slurry" },
    },
    order = "d-j[fw-flux-reactive-slurries]",
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
    effects = {
      { type = "unlock-recipe", recipe = "fw-green-flux-bioflux-cultivation" },
      { type = "unlock-recipe", recipe = "fw-green-flux-biolubricant-culture" },
      { type = "unlock-recipe", recipe = "fw-green-flux-aquaculture-feed" },
    },
    order = "d-k[fw-flux-green-cultivation]",
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
    effects = {
      { type = "unlock-recipe", recipe = "fw-green-flux-yumako-seed-propagation" },
      { type = "unlock-recipe", recipe = "fw-green-flux-jellynut-seed-propagation" },
      { type = "unlock-recipe", recipe = "fw-green-flux-tree-seed-propagation" },
    },
    order = "d-l[fw-flux-green-propagation]",
  },
  {
    type = "technology",
    name = "fw-flux-thermal-networks",
    icon = "__FluxWorksAssets__/graphics/technology/fw-arc-furnace.png",
    icon_size = 256,
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
    effects = {
      { type = "unlock-recipe", recipe = "fw-red-flux-rocket-fuel-infusion" },
    },
    order = "d-m[fw-flux-thermal-networks]",
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
    order = "d-n[fw-flux-phase-engineering]",
  },
  {
    type = "technology",
    name = "fw-flux-overdrive",
    icon = "__FluxWorksAssets__/graphics/technology/fw-arc-furnace.png",
    icon_size = 256,
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
      { type = "unlock-recipe", recipe = "fw-red-flux-nuclear-fuel-staging" },
    },
    order = "d-o[fw-flux-overdrive]",
  },
  {
    type = "technology",
    name = "fw-flux-synthesis",
    icon = "__FluxWorksAssets__/graphics/technology/fw-arc-furnace.png",
    icon_size = 256,
    prerequisites = { "fw-flux-phase-engineering", "fw-flux-chemical-synthesis", "fw-flux-green-cultivation", "fw-computational-arrays" },
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
      { type = "unlock-recipe", recipe = "fw-rift-seed-crystallization" },
    },
    order = "d-p[fw-flux-synthesis]",
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
      { type = "unlock-recipe", recipe = "fw-flux-metallic-synthesis" },
    },
    order = "d-q[fw-flux-convergence]",
  },
})

Tech:get("fw-flux-catalysis")
  :setCost(220)
  :setColors("RGB")
  :setTime(30)
  :setPrerequisites({ "fw-liquid-mining", "fw-material-refinement" })

Tech:get("fw-flux-stabilization")
  :setCost(280)
  :setColors("RGB")
  :setTime(30)
  :setPrerequisites({ "fw-flux-catalysis", "fw-sealed-systems", "fw-conductive-networks" })

Tech:get("fw-flux-yellow-catalysis")
  :setCost(360)
  :setColors("RGBP")
  :setTime(35)
  :setPrerequisites({ "fw-flux-stabilization", "fw-liquid-mining", "fw-material-refinement" })

Tech:get("fw-flux-red-energetics")
  :setCost(360)
  :setColors("RGBP")
  :setTime(35)
  :setPrerequisites({ "fw-flux-stabilization", "fw-power-regulation" })

Tech:get("fw-flux-green-reclamation")
  :setCost(360)
  :setColors("RGBA")
  :setTime(35)
  :setPrerequisites({ "fw-flux-stabilization", "fw-biosystems-engineering" })

Tech:get("fw-flux-resonance")
  :setCost(520)
  :setColors("RGBPY")
  :setTime(40)
  :setPrerequisites({ "fw-flux-yellow-catalysis", "fw-flux-red-energetics", "fw-systems-integration" })

Tech:get("fw-flux-asteroid-harvesting")
  :setCost(450)
  :setColors("RGBPYW")
  :setTime(40)
  :setPrerequisites({ "fw-flux-resonance", "rocket-chunk-processing", "fw-flux-extraction" })

Tech:get("fw-flux-field-theory")
  :setCost(700)
  :setColors("RGBPYW")
  :setTime(45)
  :setPrerequisites({ "fw-flux-asteroid-harvesting", "fw-electromagnetic-architecture", "utility-science-pack" })

Tech:get("fw-flux-chemical-synthesis")
  :setCost(780)
  :setColors("RGBPYW")
  :setTime(50)
  :setPrerequisites({ "fw-flux-field-theory", "fw-flux-yellow-catalysis", "fw-industrial-expansion" })

Tech:get("fw-flux-reactive-slurries")
  :setCost(900)
  :setColors("RGBPYW")
  :setTime(55)
  :setPrerequisites({ "fw-flux-chemical-synthesis", "fw-flux-red-energetics" })

Tech:get("fw-flux-green-cultivation")
  :setCost(820)
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

Tech:get("fw-flux-phase-engineering")
  :setCost(980)
  :setColors("RGBPYWFC")
  :setTime(60)
  :setPrerequisites({ "fw-flux-field-theory", "fw-flux-resonance", "fw-cryogenic-control" })

Tech:get("fw-flux-overdrive")
  :setCost(1250)
  :setColors("RGBPYWFC")
  :setTime(60)
  :setPrerequisites({ "fw-flux-thermal-networks", "fw-flux-phase-engineering", "fw-promethium-stabilization" })

Tech:get("fw-flux-synthesis")
  :setCost(1100)
  :setColors("RGBPYW")
  :setTime(60)
  :setPrerequisites({ "fw-flux-phase-engineering", "fw-flux-chemical-synthesis", "fw-flux-green-cultivation", "fw-computational-arrays" })

Tech:get("fw-flux-convergence")
  :setCost(1500)
  :setColors("RGBPYWVFCA")
  :setTime(65)
  :setPrerequisites({ "fw-flux-synthesis", "fw-flux-overdrive", "fw-flux-green-propagation" })
