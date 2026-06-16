local function has_unlock_effect(effects, recipe_name)
  for _, effect in pairs(effects or {}) do
    if effect.type == "unlock-recipe" and effect.recipe == recipe_name then
      return true
    end
  end
  return false
end

local function add_unlock(tech_name, recipe_name)
  local tech = data.raw.technology and data.raw.technology[tech_name]
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if not (tech and recipe) then
    return
  end

  recipe.enabled = false
  tech.effects = tech.effects or {}
  if not has_unlock_effect(tech.effects, recipe_name) then
    table.insert(tech.effects, { type = "unlock-recipe", recipe = recipe_name })
  end
end

data:extend({
  {
    type = "recipe",
    name = "fw-chlorine-pressurization",
    icon = "__FluxWorksAssets__/graphics/resources/fluids/chlorine.png",
    icon_size = 128,
    category = "chemistry",
    subgroup = "fw-chemistry-processes",
    order = "e[base-chemistry]-a[chlorine-pressurization]",
    enabled = false,
    energy_required = 3.5,
    allow_productivity = true,
    ingredients = {
      { type = "item", name = "fw-salt", amount = 3 },
      { type = "fluid", name = "water", amount = 40 },
    },
    results = {
      { type = "fluid", name = "fw-chlorine", amount = 24 },
    },
    main_product = "fw-chlorine",
  },
  {
    type = "recipe",
    name = "fw-latex-polymerization",
    icon = "__FluxWorksAssets__/graphics/icons/fluids/fw-latex.png",
    icon_size = 64,
    category = "chemistry",
    subgroup = "fw-chemistry-processes",
    order = "e[base-chemistry]-b[latex-polymerization]",
    enabled = false,
    energy_required = 4.0,
    allow_productivity = true,
    ingredients = {
      { type = "item", name = "plastic-bar", amount = 2 },
      { type = "item", name = "fw-salt", amount = 1 },
      { type = "fluid", name = "water", amount = 30 },
    },
    results = {
      { type = "fluid", name = "fw-latex", amount = 24 },
    },
    main_product = "fw-latex",
  },
  {
    type = "recipe",
    name = "fw-resin-polymerization",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-resin.png",
    icon_size = 64,
    category = "chemistry",
    subgroup = "fw-chemistry-processes",
    order = "e[base-chemistry]-c[resin-polymerization]",
    enabled = false,
    energy_required = 4.5,
    allow_productivity = true,
    ingredients = {
      { type = "item", name = "fw-carbon", amount = 1 },
      { type = "fluid", name = "fw-latex", amount = 24 },
    },
    results = {
      { type = "item", name = "fw-resin", amount = 1 },
    },
    main_product = "fw-resin",
  },
  {
    type = "recipe",
    name = "fw-sulfur-bonding",
    icon = "__base__/graphics/icons/sulfur.png",
    icon_size = 64,
    category = "chemistry",
    subgroup = "fw-chemistry-processes",
    order = "e[base-chemistry]-d[sulfur-bonding]",
    enabled = false,
    energy_required = 4.0,
    allow_productivity = true,
    ingredients = {
      { type = "item", name = "fw-salt", amount = 1 },
      { type = "item", name = "fw-carbon", amount = 1 },
      { type = "fluid", name = "fw-chlorine", amount = 20 },
    },
    results = {
      { type = "item", name = "sulfur", amount = 2 },
    },
    main_product = "sulfur",
  },
  {
    type = "recipe",
    name = "fw-acid-synthesis",
    icon = "__base__/graphics/icons/fluid/sulfuric-acid.png",
    icon_size = 64,
    category = "chemistry",
    subgroup = "fw-chemistry-processes",
    order = "e[base-chemistry]-e[acid-synthesis]",
    enabled = false,
    energy_required = 4.5,
    allow_productivity = true,
    ingredients = {
      { type = "item", name = "fw-salt", amount = 1 },
      { type = "item", name = "sulfur", amount = 2 },
      { type = "fluid", name = "fw-chlorine", amount = 20 },
      { type = "fluid", name = "water", amount = 50 },
    },
    results = {
      { type = "fluid", name = "sulfuric-acid", amount = 80 },
    },
    main_product = "sulfuric-acid",
  },
  {
    type = "recipe",
    name = "fw-rubber-vulcanization",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-rubber-sheet.png",
    icon_size = 1024,
    category = "chemistry",
    subgroup = "fw-chemistry-processes",
    order = "e[base-chemistry]-f[rubber-vulcanization]",
    enabled = false,
    energy_required = 4.5,
    allow_productivity = true,
    ingredients = {
      { type = "item", name = "fw-resin", amount = 1 },
      { type = "item", name = "sulfur", amount = 1 },
      { type = "fluid", name = "fw-latex", amount = 20 },
    },
    results = {
      { type = "item", name = "fw-rubber-sheet", amount = 4 },
    },
    main_product = "fw-rubber-sheet",
  },
  {
    type = "recipe",
    name = "fw-blasting-gel",
    icon = "__FluxWorksAssets__/graphics/icons/fluids/fw-blasting-gel.png",
    icon_size = 64,
    category = "chemistry",
    subgroup = "fw-chemistry-processes",
    order = "e[base-chemistry]-g[blasting-gel]",
    enabled = false,
    energy_required = 5.5,
    allow_productivity = true,
    ingredients = {
      { type = "item", name = "explosives", amount = 1 },
      { type = "item", name = "fw-resin", amount = 1 },
      { type = "fluid", name = "water", amount = 20 },
    },
    results = {
      { type = "fluid", name = "fw-blasting-gel", amount = 20 },
    },
    main_product = "fw-blasting-gel",
  },
  {
    type = "recipe",
    name = "fw-reactive-slurry",
    icon = "__base__/graphics/icons/cliff-explosives.png",
    icon_size = 64,
    category = "chemistry",
    subgroup = "fw-chemistry-processes",
    order = "e[base-chemistry]-h[reactive-slurry]",
    enabled = false,
    energy_required = 5.5,
    allow_productivity = true,
    ingredients = {
      { type = "item", name = "explosives", amount = 1 },
      { type = "fluid", name = "fw-blasting-gel", amount = 30 },
    },
    results = {
      { type = "item", name = "cliff-explosives", amount = 1 },
    },
    main_product = "cliff-explosives",
  },
  {
    type = "recipe",
    name = "fw-battery-electrolyte",
    icon = "__base__/graphics/icons/battery.png",
    icon_size = 64,
    category = "chemistry",
    subgroup = "fw-chemistry-processes",
    order = "e[base-chemistry]-i[battery-electrolyte]",
    enabled = false,
    energy_required = 5.0,
    allow_productivity = true,
    ingredients = {
      { type = "item", name = "lead-plate", amount = 1 },
      { type = "item", name = "tin-plate", amount = 1 },
      { type = "item", name = "fw-resin", amount = 1 },
      { type = "fluid", name = "sulfuric-acid", amount = 20 },
    },
    results = {
      { type = "item", name = "battery", amount = 1 },
    },
    main_product = "battery",
  },
  {
    type = "recipe",
    name = "fw-napalm",
    icons = {
      {
        icon = "__FluxWorksAssets__/graphics/icons/fluids/fw-blasting-gel.png",
        icon_size = 64,
      },
      {
        icon = "__base__/graphics/icons/sulfur.png",
        icon_size = 64,
        scale = 0.45,
        shift = { 9, 9 },
      },
    },
    category = "chemistry",
    subgroup = "fw-chemistry-processes",
    order = "e[base-chemistry]-j[napalm]",
    enabled = false,
    energy_required = 6.0,
    allow_productivity = true,
    ingredients = {
      { type = "fluid", name = "fw-blasting-gel", amount = 30 },
      { type = "fluid", name = "light-oil", amount = 20 },
      { type = "item", name = "sulfur", amount = 1 },
      { type = "item", name = "fw-carbon", amount = 1 },
    },
    results = {
      { type = "fluid", name = "fw-napalm", amount = 40 },
    },
    main_product = "fw-napalm",
  },
})

add_unlock("fw-liquid-mining", "fw-chlorine-pressurization")
add_unlock("fw-liquid-mining", "fw-latex-polymerization")
add_unlock("fw-material-refinement", "fw-resin-polymerization")
add_unlock("fw-material-refinement", "fw-sulfur-bonding")
add_unlock("fw-material-refinement", "fw-acid-synthesis")
add_unlock("fw-material-refinement", "fw-rubber-vulcanization")
add_unlock("fw-advanced-fabrication", "fw-blasting-gel")
add_unlock("fw-advanced-fabrication", "fw-reactive-slurry")
add_unlock("fw-advanced-fabrication", "fw-battery-electrolyte")
add_unlock("fw-industrial-expansion", "fw-napalm")
