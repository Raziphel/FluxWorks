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

local function productivity_effects(change, recipes)
  local effects = {}

  for _, recipe in ipairs(recipes) do
    local effect = productivity_change(recipe, change)
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
    effects = productivity_effects(change, recipes),
    max_level = "infinite",
    upgrade = true,
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
  bonus_tech(
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
    0.06,
    {
      "fw-blasting-gel",
      "fw-reactive-slurry",
      "fw-battery-electrolyte",
      "fw-napalm",
    },
    "e-c[fw-reactive-chemistry-productivity]"
  ),
  bonus_tech(
    "fw-green-reclamation-productivity",
    "__FluxWorksAssets__/graphics/technology/fw-green-cycle-productivity.png",
    { "fw-flux-green-reclamation", "production-science-pack" },
    science_ingredients(
      "automation-science-pack",
      "logistic-science-pack",
      "chemical-science-pack",
      "production-science-pack",
      "agricultural-science-pack"
    ),
    0.04,
    {
      "fw-green-flux-spoilage-reclamation",
    },
    "e-d[fw-green-reclamation-productivity]"
  ),
  bonus_tech(
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
    0.06,
    {
      "fw-green-flux-bioflux-cultivation",
      "fw-green-flux-biolubricant-culture",
      "fw-green-flux-aquaculture-feed",
    },
    "e-e[fw-green-cultivation-productivity]"
  ),
  bonus_tech(
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
    0.08,
    {
      "fw-green-flux-yumako-seed-propagation",
      "fw-green-flux-jellynut-seed-propagation",
      "fw-green-flux-tree-seed-propagation",
    },
    "e-f[fw-green-propagation-productivity]"
  ),
  bonus_tech(
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
    0.06,
    {
      "fw-electrolyte-conditioning",
      "fw-lithium-adsorption",
      "fw-fluoroketone-synthesis",
      "fw-spectral-coolant-blend",
      "fw-aquilo-cryogel",
    },
    "e-g[fw-cryogenic-loop-productivity]"
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
  bonus_tech(
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
    0.10,
    {
      "fw-flux-resonance-cell",
      "fw-flux-phase-manifold",
    },
    "e-i[fw-phase-assembly-productivity]"
  ),
  bonus_tech(
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
    0.04,
    {
      "fw-flux-asteroid-refining",
      "fw-flux-asteroid-deep-refining",
    },
    "e-j[fw-asteroid-refinement-productivity]"
  ),
  bonus_tech(
    "fw-gleba-biochemistry-productivity",
    "__FluxWorksAssets__/graphics/technology/fw-planetary-material-productivity.png",
    { "fw-gleba-biochemistry", "production-science-pack" },
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
      "fw-gleba-spore-resin",
    },
    "e-k[fw-gleba-biochemistry-productivity]"
  ),
  bonus_tech(
    "fw-fulgora-electrochemistry-productivity",
    "__FluxWorksAssets__/graphics/technology/fw-planetary-material-productivity.png",
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
    0.08,
    {
      "fw-fulgora-static-mesh",
    },
    "e-l[fw-fulgora-electrochemistry-productivity]"
  ),
  bonus_tech(
    "fw-vulcanus-pyrochemistry-productivity",
    "__FluxWorksAssets__/graphics/technology/fw-planetary-material-productivity.png",
    { "fw-vulcanus-pyrochemistry", "production-science-pack" },
    science_ingredients(
      "automation-science-pack",
      "logistic-science-pack",
      "chemical-science-pack",
      "production-science-pack",
      "utility-science-pack",
      "space-science-pack",
      "metallurgic-science-pack"
    ),
    0.08,
    {
      "fw-vulcanus-slag-cermet",
    },
    "e-m[fw-vulcanus-pyrochemistry-productivity]"
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
})
