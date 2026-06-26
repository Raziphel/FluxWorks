local function tech_unit_formula(formula, ingredients, time)
  return {
    count_formula = formula,
    ingredients = ingredients,
    time = time,
  }
end

local function science_ingredients(...)
  local ingredients = {}

  for _, science_pack in ipairs({ ... }) do
    table.insert(ingredients, { science_pack, 1 })
  end

  return ingredients
end

local function productivity_change(recipe, change)
  if not (data.raw.recipe and data.raw.recipe[recipe]) then
    return nil
  end

  return {
    type = "change-recipe-productivity",
    recipe = recipe,
    change = change,
  }
end

local function unlock_recipe_effect(recipe)
  if not (data.raw.recipe and data.raw.recipe[recipe]) then
    return nil
  end

  return {
    type = "unlock-recipe",
    recipe = recipe,
  }
end

local function collect_effects(builder, values)
  local effects = {}

  for _, value in ipairs(values) do
    local effect = builder(value)
    if effect then
      table.insert(effects, effect)
    end
  end

  return effects
end

local function bonus_tech(name, icon, prerequisites, ingredients, change, recipes, order)
  return {
    type = "technology",
    name = name,
    icon = icon,
    icon_size = 1024,
    prerequisites = prerequisites,
    unit = tech_unit_formula("1.45^L*900", ingredients, 60),
    effects = collect_effects(function(recipe)
      return productivity_change(recipe, change)
    end, recipes),
    max_level = "infinite",
    upgrade = true,
    order = order,
  }
end

local function named_bonus_tech(name, icon, prerequisites, ingredients, change, recipes, order, localised_name, localised_description)
  local tech = bonus_tech(name, icon, prerequisites, ingredients, change, recipes, order)
  tech.localised_name = { "technology-name." .. name }
  tech.localised_description = { "technology-description." .. name }
  return tech
end

local function process_tech(name, icon, prerequisites, ingredients, count, recipes, order, localised_name, localised_description)
  return {
    type = "technology",
    name = name,
    icon = icon,
    icon_size = 1024,
    prerequisites = prerequisites,
    unit = {
      count = count,
      ingredients = ingredients,
      time = 55,
    },
    effects = collect_effects(unlock_recipe_effect, recipes),
    localised_name = { "technology-name." .. name },
    localised_description = { "technology-description." .. name },
    order = order,
  }
end

data:extend({
  bonus_tech(
    "fw-harvester-reprocessing-productivity",
    "__FluxWorksAssets__/graphics/technology/fw-harvester-reprocessing-productivity.png",
    { "fw-harvester-systems", "production-science-pack" },
    science_ingredients(
      "automation-science-pack",
      "logistic-science-pack",
      "chemical-science-pack",
      "production-science-pack",
      "space-science-pack"
    ),
    0.04,
    {
      "fw-salt-brine-clarification",
      "fw-silica-beneficiation",
      "fw-carbonic-washing",
    },
    "e-a[fw-harvester-reprocessing-productivity]"
  ),
  bonus_tech(
    "fw-polymer-reclamation-productivity",
    "__FluxWorksAssets__/graphics/technology/fw-polymer-reclamation-productivity.png",
    { "fw-flux-chemical-synthesis", "production-science-pack" },
    science_ingredients(
      "automation-science-pack",
      "logistic-science-pack",
      "chemical-science-pack",
      "production-science-pack",
      "utility-science-pack",
      "space-science-pack"
    ),
    0.04,
    {
      "fw-chlorine-pressurization",
      "fw-latex-polymerization",
      "fw-resin-polymerization",
      "fw-sulfur-bonding",
      "fw-acid-synthesis",
      "fw-rubber-vulcanization",
    },
    "e-b[fw-polymer-reclamation-productivity]"
  ),
  process_tech(
    "fw-reactive-chemistry-productivity",
    "__FluxWorksAssets__/graphics/technology/fw-reactive-chemistry-productivity.png",
    { "fw-flux-reactive-slurries", "production-science-pack" },
    science_ingredients(
      "automation-science-pack",
      "logistic-science-pack",
      "chemical-science-pack",
      "production-science-pack",
      "utility-science-pack",
      "space-science-pack"
    ),
    1200,
    {
      "fw-reactive-slurry-focusing",
      "fw-gelled-napalm-mixing",
    },
    "e-c[fw-reactive-chemistry-productivity]",
    { "", "Reactive Chemistry Stabilization" },
    { "", "Unlocks controlled demolition and napalm variants with explicit loop behavior instead of another invisible productivity scaler." }
  ),
  process_tech(
    "fw-green-reclamation-productivity",
    "__FluxWorksAssets__/graphics/technology/fw-green-cycle-productivity.png",
    { "fw-flux-green-cultivation", "production-science-pack" },
    science_ingredients(
      "automation-science-pack",
      "logistic-science-pack",
      "chemical-science-pack",
      "production-science-pack",
      "agricultural-science-pack"
    ),
    750,
    {
      "fw-green-flux-compost-bloom",
    },
    "e-d[fw-green-reclamation-productivity]",
    { "", "Green Composting" },
    { "", "Adds a spoilage-heavy compost bloom that climbs back to bioflux instead of treating the whole lane like a single productivity number." }
  ),
  process_tech(
    "fw-green-cultivation-productivity",
    "__FluxWorksAssets__/graphics/technology/fw-green-cycle-productivity.png",
    { "fw-flux-green-cultivation", "production-science-pack" },
    science_ingredients(
      "automation-science-pack",
      "logistic-science-pack",
      "chemical-science-pack",
      "production-science-pack",
      "utility-science-pack",
      "space-science-pack",
      "agricultural-science-pack"
    ),
    1200,
    {
      "fw-green-flux-biolubricant-bloom",
      "fw-green-flux-aquaculture-bloom",
    },
    "e-e[fw-green-cultivation-productivity]",
    { "", "Green Culture Steering" },
    { "", "Unlocks dedicated bloom recipes for biolubricant and aquaculture so the biological lane gets real texture instead of flat per-recipe productivity." }
  ),
  process_tech(
    "fw-green-propagation-productivity",
    "__FluxWorksAssets__/graphics/technology/fw-green-cycle-productivity.png",
    { "fw-flux-green-propagation", "production-science-pack" },
    science_ingredients(
      "automation-science-pack",
      "logistic-science-pack",
      "chemical-science-pack",
      "production-science-pack",
      "utility-science-pack",
      "space-science-pack",
      "agricultural-science-pack"
    ),
    1400,
    {
      "fw-green-flux-yumako-seed-seedbanking",
      "fw-green-flux-jellynut-seed-seedbanking",
      "fw-green-flux-tree-seed-seedbanking",
    },
    "e-f[fw-green-propagation-productivity]",
    { "", "Seedbank Propagation" },
    { "", "Unlocks managed seedbank recipes that stockpile regenerative crops through bioflux support rather than an infinite propagation bonus." }
  ),
  process_tech(
    "fw-cryogenic-loop-productivity",
    "__FluxWorksAssets__/graphics/technology/fw-cryogenic-loop-productivity.png",
    { "fw-aquilo-cryochemistry", "production-science-pack" },
    science_ingredients(
      "automation-science-pack",
      "logistic-science-pack",
      "chemical-science-pack",
      "production-science-pack",
      "utility-science-pack",
      "space-science-pack",
      "cryogenic-science-pack"
    ),
    1500,
    {
      "fw-spectral-coolant-recycling",
      "fw-aquilo-cryogel-annealing",
    },
    "e-g[fw-cryogenic-loop-productivity]",
    { "", "Spectral Cryorecovery" },
    { "", "Adds closed-loop coolant and cryogel handling so Aquilo processing feels engineered, not just productivity-buffed." }
  ),
  bonus_tech(
    "fw-resonance-material-productivity",
    "__FluxWorksAssets__/graphics/technology/fw-resonance-assembly-productivity.png",
    { "fw-resonance-assemblies", "production-science-pack" },
    science_ingredients(
      "automation-science-pack",
      "logistic-science-pack",
      "chemical-science-pack",
      "production-science-pack",
      "utility-science-pack",
      "space-science-pack",
      "electromagnetic-science-pack",
      "cryogenic-science-pack"
    ),
    0.08,
    {
      "fw-stabilized-flux-crystal",
      "fw-flux-lattice",
      "fw-resonance-substrate",
      "fw-condensed-flux-matrix",
    },
    "e-h[fw-resonance-material-productivity]"
  ),
  process_tech(
    "fw-phase-assembly-productivity",
    "__FluxWorksAssets__/graphics/technology/fw-resonance-assembly-productivity.png",
    { "fw-flux-phase-engineering", "production-science-pack" },
    science_ingredients(
      "automation-science-pack",
      "logistic-science-pack",
      "chemical-science-pack",
      "production-science-pack",
      "utility-science-pack",
      "space-science-pack",
      "electromagnetic-science-pack",
      "cryogenic-science-pack"
    ),
    1700,
    {
      "fw-flux-resonance-cell-calibration",
      "fw-flux-phase-manifold-calibration",
    },
    "e-i[fw-phase-assembly-productivity]",
    { "", "Phase Assembly Calibration" },
    { "", "Unlocks tuned resonance-cell and manifold assembly passes that emphasize catalyst retention and reliability over another endgame productivity stack." }
  ),
  process_tech(
    "fw-asteroid-refinement-productivity",
    "__FluxWorksAssets__/graphics/technology/fw-asteroid-refinement-productivity.png",
    { "fw-flux-asteroid-harvesting", "production-science-pack" },
    science_ingredients(
      "automation-science-pack",
      "logistic-science-pack",
      "chemical-science-pack",
      "production-science-pack",
      "utility-science-pack",
      "space-science-pack"
    ),
    1400,
    {
      "fw-flux-asteroid-core-sorting",
    },
    "e-j[fw-asteroid-refinement-productivity]",
    { "", "Deep Asteroid Sorting" },
    { "", "Adds a sorting-focused asteroid pass with better catalyst retention and crystal recovery instead of another broad chunk productivity bonus." }
  ),
  bonus_tech(
    "fw-superconductive-productivity",
    "__FluxWorksAssets__/graphics/technology/fw-superconductive-productivity.png",
    { "fw-superconductive-systems", "production-science-pack" },
    science_ingredients(
      "automation-science-pack",
      "logistic-science-pack",
      "chemical-science-pack",
      "production-science-pack",
      "utility-science-pack",
      "space-science-pack",
      "electromagnetic-science-pack",
      "cryogenic-science-pack"
    ),
    0.08,
    {
      "fw-superconductor-bath",
      "fw-supercapacitor-conditioning",
    },
    "e-n[fw-superconductive-productivity]"
  ),
  bonus_tech(
    "fw-promethium-containment-productivity",
    "__FluxWorksAssets__/graphics/technology/fw-promethium-containment-productivity.png",
    { "fw-fusion-lattices", "production-science-pack" },
    science_ingredients(
      "automation-science-pack",
      "logistic-science-pack",
      "chemical-science-pack",
      "production-science-pack",
      "utility-science-pack",
      "space-science-pack",
      "metallurgic-science-pack",
      "agricultural-science-pack",
      "electromagnetic-science-pack",
      "cryogenic-science-pack",
      "promethium-science-pack"
    ),
    0.10,
    {
      "fw-promethium-primer",
      "fw-promethium-matrix",
      "fw-rift-stabilizer",
      "fw-fusion-power-cell-conditioning",
    },
    "e-o[fw-promethium-containment-productivity]"
  ),
  bonus_tech(
    "fw-rift-synthesis-productivity",
    "__FluxWorksAssets__/graphics/technology/fw-rift-synthesis-productivity.png",
    { "fw-rift-harmonics", "production-science-pack" },
    science_ingredients(
      "automation-science-pack",
      "logistic-science-pack",
      "chemical-science-pack",
      "production-science-pack",
      "utility-science-pack",
      "space-science-pack",
      "metallurgic-science-pack",
      "agricultural-science-pack",
      "electromagnetic-science-pack",
      "cryogenic-science-pack",
      "promethium-science-pack"
    ),
    0.10,
    {
      "fw-rift-seed-crystallization",
      "fw-flux-metallic-synthesis",
    },
    "e-p[fw-rift-synthesis-productivity]"
  ),
  named_bonus_tech(
    "fw-ceramic-infrastructure-productivity",
    "__FluxWorksAssets__/graphics/technology/fw-metallurgic-assemblies.png",
    { "fw-metallurgic-assemblies", "production-science-pack" },
    science_ingredients(
      "automation-science-pack",
      "logistic-science-pack",
      "chemical-science-pack",
      "production-science-pack",
      "utility-science-pack",
      "space-science-pack",
      "metallurgic-science-pack"
    ),
    0.04,
    {
      "fw-fired-ceramic",
      "fw-ceramic-casing",
      "fw-ceramic-insulator",
      "fw-foundry-lining",
      "fw-smelter-array",
    },
    "e-q[fw-ceramic-infrastructure-productivity]",
    { "", "Ceramic Infrastructure" },
    { "", "Improves the heavy ceramic shell, insulation, and foundry liner lane so FluxWorks gets more real manufacturing specialization in the mid-to-late tree." }
  ),
  named_bonus_tech(
    "fw-structural-fabrication-productivity",
    "__FluxWorksAssets__/graphics/icons/items/fw-cermet.png",
    { "fw-industrial-expansion", "production-science-pack" },
    science_ingredients(
      "automation-science-pack",
      "logistic-science-pack",
      "chemical-science-pack",
      "production-science-pack",
      "utility-science-pack"
    ),
    0.04,
    {
      "fw-iron-beam",
      "fw-steel-beam",
      "fw-aluminum-beam",
      "fw-copper-tube",
      "fw-metal-mesh",
      "fw-light-frame",
      "fw-composite-panel",
    },
    "e-r[fw-structural-fabrication-productivity]",
    { "", "Structural Fabrication" },
    { "", "Turns the beam, frame, and composite lane into its own repeatable research track instead of leaving broad industrial growth concentrated in a few big unlocks." }
  ),
  named_bonus_tech(
    "fw-circuit-foundry-productivity",
    "__FluxWorksAssets__/graphics/technology/fw-electromagnetic-architecture.png",
    { "fw-computational-arrays", "production-science-pack" },
    science_ingredients(
      "automation-science-pack",
      "logistic-science-pack",
      "chemical-science-pack",
      "production-science-pack",
      "utility-science-pack"
    ),
    0.04,
    {
      "fw-circuit-contact-leaded",
      "fw-solder-wire",
      "fw-chip-carrier",
      "fw-microchip",
      "fw-memory-die",
      "fw-ceramic-wafer",
    },
    "e-s[fw-circuit-foundry-productivity]",
    { "", "Circuit Foundry Scaling" },
    { "", "Expands the electronics ladder with a dedicated repeatable research for carrier, wafer, and control-chip throughput." }
  ),
  named_bonus_tech(
    "fw-signal-routing-productivity",
    "__FluxWorksAssets__/graphics/technology/fw-conductive-networks.png",
    { "fw-power-regulation", "production-science-pack" },
    science_ingredients(
      "automation-science-pack",
      "logistic-science-pack",
      "chemical-science-pack",
      "production-science-pack",
      "utility-science-pack"
    ),
    0.04,
    {
      "fw-tinned-cable",
      "fw-cable-harness",
      "fw-conductor-bundle",
      "fw-signal-conduit",
      "fw-coil-block",
      "fw-field-winding",
    },
    "e-t[fw-signal-routing-productivity]",
    { "", "Signal Routing" },
    { "", "Adds a repeatable research path for the wiring, conduit, and field-control backbone that much of FluxWorks manufacturing sits on." }
  ),
  named_bonus_tech(
    "fw-optical-control-productivity",
    "__FluxWorksAssets__/graphics/technology/fw-electromagnetic-architecture.png",
    { "fw-electromagnetic-architecture", "production-science-pack" },
    science_ingredients(
      "automation-science-pack",
      "logistic-science-pack",
      "chemical-science-pack",
      "production-science-pack",
      "utility-science-pack",
      "space-science-pack",
      "electromagnetic-science-pack"
    ),
    0.06,
    {
      "fw-glass-lens",
      "fw-lens-array",
      "fw-sensor-diode",
      "fw-sensor-package",
      "fw-em-core",
      "fw-logic-matrix",
    },
    "e-u[fw-optical-control-productivity]",
    { "", "Optical Control Arrays" },
    { "", "Pushes sensing, imaging, and field-control hardware into a distinct specialist research lane for denser late-game tree texture." }
  ),
  named_bonus_tech(
    "fw-sealed-process-productivity",
    "__FluxWorksAssets__/graphics/technology/fw-sealed-systems.png",
    { "fw-spectral-fluid-retention", "production-science-pack" },
    science_ingredients(
      "automation-science-pack",
      "logistic-science-pack",
      "chemical-science-pack",
      "production-science-pack",
      "utility-science-pack",
      "space-science-pack",
      "cryogenic-science-pack"
    ),
    0.06,
    {
      "fw-inline-filter",
      "fw-pressure-housing",
      "fw-flow-regulator",
      "fw-reservoir-lining",
      "fw-thermal-phase-gasket",
    },
    "e-v[fw-sealed-process-productivity]",
    { "", "Sealed Process Engineering" },
    { "", "Extends the sealed-system branch with its own repeatable infrastructure research for filters, housings, regulators, and fluid-memory hardware." }
  ),
  named_bonus_tech(
    "fw-bioculture-apparatus-productivity",
    "__FluxWorksAssets__/graphics/technology/fw-biosystems-engineering.png",
    { "fw-flux-green-propagation", "production-science-pack" },
    science_ingredients(
      "automation-science-pack",
      "logistic-science-pack",
      "chemical-science-pack",
      "production-science-pack",
      "utility-science-pack",
      "space-science-pack",
      "agricultural-science-pack"
    ),
    0.06,
    {
      "fw-nutrient-bed",
      "fw-spore-filter",
      "fw-gleba-spore-resin",
    },
    "e-w[fw-bioculture-apparatus-productivity]",
    { "", "Bioculture Apparatus" },
    { "", "Adds a dedicated repeatable research for FluxWorks bio hardware so the Green branch grows through real manufacturing depth instead of only recipe unlocks." }
  ),
  named_bonus_tech(
    "fw-cryogenic-loop-efficiency",
    "__FluxWorksAssets__/graphics/technology/fw-cryogenic-control.png",
    { "fw-aquilo-cryochemistry", "production-science-pack" },
    science_ingredients(
      "automation-science-pack",
      "logistic-science-pack",
      "chemical-science-pack",
      "production-science-pack",
      "utility-science-pack",
      "space-science-pack",
      "cryogenic-science-pack"
    ),
    0.06,
    {
      "fw-cryo-coil",
      "fw-thermal-buffer",
      "fw-spectral-coolant-blend",
      "fw-aquilo-cryogel",
    },
    "e-x[fw-cryogenic-loop-efficiency]",
    { "", "Cryogenic Loop Efficiency" },
    { "", "Creates a repeatable Aquilo-side research branch for cold-loop machinery and cryogel infrastructure." }
  ),
  named_bonus_tech(
    "fw-electrochemical-platform-productivity",
    "__FluxWorksAssets__/graphics/technology/fw-electromagnetic-architecture.png",
    { "fw-fulgora-electrochemistry", "production-science-pack" },
    science_ingredients(
      "automation-science-pack",
      "logistic-science-pack",
      "chemical-science-pack",
      "production-science-pack",
      "utility-science-pack",
      "space-science-pack",
      "electromagnetic-science-pack"
    ),
    0.06,
    {
      "fw-electrolyte-conditioning",
      "fw-lithium-adsorption",
      "fw-fulgora-static-mesh",
      "fw-superconductor-bath",
      "fw-supercapacitor-conditioning",
    },
    "e-y[fw-electrochemical-platform-productivity]",
    { "", "Electrochemical Platforms" },
    { "", "Builds out a repeatable Fulgora-side hardware research loop for electrolyte handling, static mesh, and capacitor-grade field assemblies." }
  ),
  named_bonus_tech(
    "fw-resonance-core-productivity",
    "__FluxWorksAssets__/graphics/technology/fw-resonance-assembly-productivity.png",
    { "fw-resonance-assemblies", "production-science-pack" },
    science_ingredients(
      "automation-science-pack",
      "logistic-science-pack",
      "chemical-science-pack",
      "production-science-pack",
      "utility-science-pack",
      "space-science-pack",
      "electromagnetic-science-pack",
      "cryogenic-science-pack"
    ),
    0.08,
    {
      "fw-flux-resonance-cell",
      "fw-flux-phase-manifold",
    },
    "e-z[fw-resonance-core-productivity]",
    { "", "Resonance Core Scaling" },
    { "", "Adds a dedicated repeatable endgame research for the core resonance assemblies that sit between Flux structuring and phase engineering." }
  ),
  named_bonus_tech(
    "fw-phase-containment-productivity",
    "__FluxWorksAssets__/graphics/technology/fw-rift-synthesis-productivity.png",
    { "fw-deep-phase-storage", "production-science-pack" },
    science_ingredients(
      "automation-science-pack",
      "logistic-science-pack",
      "chemical-science-pack",
      "production-science-pack",
      "utility-science-pack",
      "space-science-pack",
      "electromagnetic-science-pack",
      "cryogenic-science-pack"
    ),
    0.08,
    {
      "fw-phase-anchor",
      "fw-entanglement-core",
      "fw-compression-baffle",
      "fw-phase-vault",
      "fw-spectral-reservoir",
    },
    "f-a[fw-phase-containment-productivity]",
    { "", "Phase Containment" },
    { "", "Turns deep storage and spectral retention into their own repeatable infrastructure branch instead of a single endgame unlock plateau." }
  ),
  named_bonus_tech(
    "fw-rift-logistics-productivity",
    "__FluxWorksAssets__/graphics/technology/fw-rift-synthesis-productivity.png",
    { "fw-rift-harmonics", "production-science-pack" },
    science_ingredients(
      "automation-science-pack",
      "logistic-science-pack",
      "chemical-science-pack",
      "production-science-pack",
      "utility-science-pack",
      "space-science-pack",
      "metallurgic-science-pack",
      "agricultural-science-pack",
      "electromagnetic-science-pack",
      "cryogenic-science-pack",
      "promethium-science-pack"
    ),
    0.10,
    {
      "fw-rift-stabilizer",
      "fw-promethium-matrix",
      "fw-rift-coupler",
      "fw-rift-exchange-gate",
    },
    "f-b[fw-rift-logistics-productivity]",
    { "", "Rift Logistics" },
    { "", "Adds a final repeatable research rung for the heaviest FluxWorks teleportation and promethium infrastructure." }
  ),
})
