local function science_ingredients(...)
  local ingredients = {}

  for _, science_pack in ipairs({ ... }) do
    table.insert(ingredients, { science_pack, 1 })
  end

  return ingredients
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

local function process_tech(name, icon, prerequisites, ingredients, count, recipes, order)
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
    "e-c[fw-reactive-chemistry-productivity]"
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
    "e-d[fw-green-reclamation-productivity]"
  ),
  process_tech(
    "fw-green-cultivation-productivity",
    "__FluxWorksAssets__/graphics/technology/fw-polymer-reclamation-productivity.png",
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
    "e-e[fw-green-cultivation-productivity]"
  ),
  process_tech(
    "fw-green-propagation-productivity",
    "__FluxWorksAssets__/graphics/technology/fw-harvester-reprocessing-productivity.png",
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
    "e-f[fw-green-propagation-productivity]"
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
    "e-g[fw-cryogenic-loop-productivity]"
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
    "e-i[fw-phase-assembly-productivity]"
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
    "e-j[fw-asteroid-refinement-productivity]"
  ),
})
