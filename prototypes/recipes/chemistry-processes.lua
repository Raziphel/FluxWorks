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
  {
    type = "recipe",
    name = "fw-electrolyte-conditioning",
    icon = "__space-age__/graphics/icons/fluid/electrolyte.png",
    icon_size = 64,
    category = "chemistry",
    subgroup = "fw-chemistry-processes",
    order = "f[late-chemistry]-a[electrolyte-conditioning]",
    enabled = false,
    energy_required = 6.0,
    allow_productivity = true,
    ingredients = {
      { type = "item", name = "stone", amount = 1 },
      { type = "item", name = "fw-resin", amount = 1 },
      { type = "item", name = "fw-inline-filter", amount = 1 },
      { type = "fluid", name = "heavy-oil", amount = 10 },
      { type = "fluid", name = "holmium-solution", amount = 10 },
    },
    results = {
      { type = "fluid", name = "electrolyte", amount = 16 },
    },
    main_product = "electrolyte",
  },
  {
    type = "recipe",
    name = "fw-lithium-adsorption",
    icon = "__space-age__/graphics/icons/lithium.png",
    icon_size = 64,
    category = "chemistry",
    subgroup = "fw-chemistry-processes",
    order = "f[late-chemistry]-b[lithium-adsorption]",
    enabled = false,
    energy_required = 8.0,
    allow_productivity = true,
    ingredients = {
      { type = "item", name = "holmium-plate", amount = 1 },
      { type = "item", name = "fw-inline-filter", amount = 1 },
      { type = "item", name = "fw-sensor-diode", amount = 1 },
      { type = "fluid", name = "lithium-brine", amount = 50 },
      { type = "fluid", name = "ammonia", amount = 50 },
    },
    results = {
      { type = "item", name = "lithium", amount = 7 },
    },
    main_product = "lithium",
  },
  {
    type = "recipe",
    name = "fw-fluoroketone-synthesis",
    icon = "__space-age__/graphics/icons/fluid/fluoroketone-hot.png",
    icon_size = 64,
    category = "chemistry",
    subgroup = "fw-chemistry-processes",
    order = "f[late-chemistry]-c[fluoroketone-synthesis]",
    enabled = false,
    energy_required = 9.0,
    allow_productivity = true,
    ingredients = {
      { type = "item", name = "solid-fuel", amount = 1 },
      { type = "item", name = "lithium", amount = 1 },
      { type = "item", name = "fw-thermal-buffer", amount = 1 },
      { type = "item", name = "fw-flow-regulator", amount = 1 },
      { type = "fluid", name = "fluorine", amount = 50 },
      { type = "fluid", name = "ammonia", amount = 50 },
    },
    results = {
      { type = "fluid", name = "fluoroketone-hot", amount = 70, temperature = 180 },
    },
    main_product = "fluoroketone-hot",
  },
  {
    type = "recipe",
    name = "fw-aquilo-cryogel",
    icons = data.raw.item["fw-aquilo-cryogel"].icons,
    category = "chemistry",
    subgroup = "fw-chemistry-processes",
    order = "f[late-chemistry]-d[aquilo-cryogel]",
    enabled = false,
    energy_required = 10.0,
    allow_productivity = true,
    ingredients = {
      { type = "item", name = "fw-salt", amount = 2 },
      { type = "item", name = "lithium", amount = 2 },
      { type = "item", name = "ice", amount = 8 },
      { type = "item", name = "fw-thermal-buffer", amount = 1 },
      { type = "fluid", name = "fluoroketone-cold", amount = 40, temperature = -150 },
      { type = "fluid", name = "fw-yellow-flux", amount = 18 },
      { type = "fluid", name = "fw-green-flux", amount = 12 },
    },
    results = {
      { type = "item", name = "fw-aquilo-cryogel", amount = 2 },
    },
  },
  {
    type = "recipe",
    name = "fw-gleba-spore-resin",
    icons = data.raw.item["fw-gleba-spore-resin"].icons,
    category = "chemistry",
    subgroup = "fw-chemistry-processes",
    order = "f[late-chemistry]-e[gleba-spore-resin]",
    enabled = false,
    energy_required = 9.0,
    allow_productivity = true,
    ingredients = {
      { type = "item", name = "fw-resin", amount = 1 },
      { type = "item", name = "bioflux", amount = 2 },
      { type = "item", name = "nutrients", amount = 8 },
      { type = "item", name = "spoilage", amount = 4 },
      { type = "fluid", name = "fw-latex", amount = 20 },
      { type = "fluid", name = "fw-green-flux", amount = 22 },
    },
    results = {
      { type = "item", name = "fw-gleba-spore-resin", amount = 2 },
    },
  },
  {
    type = "recipe",
    name = "fw-fulgora-static-mesh",
    icons = data.raw.item["fw-fulgora-static-mesh"].icons,
    category = "chemistry",
    subgroup = "fw-chemistry-processes",
    order = "f[late-chemistry]-g[fulgora-static-mesh]",
    enabled = false,
    energy_required = 11.0,
    allow_productivity = true,
    ingredients = {
      { type = "item", name = "holmium-plate", amount = 2 },
      { type = "item", name = "supercapacitor", amount = 1 },
      { type = "item", name = "fw-metal-mesh", amount = 2 },
      { type = "item", name = "aluminum-plate", amount = 1 },
      { type = "item", name = "silicon", amount = 1 },
      { type = "item", name = "fw-em-core", amount = 1 },
      { type = "fluid", name = "electrolyte", amount = 16 },
      { type = "fluid", name = "fw-yellow-flux", amount = 10 },
      { type = "fluid", name = "fw-red-flux", amount = 18 },
    },
    results = {
      { type = "item", name = "fw-fulgora-static-mesh", amount = 2 },
    },
  },
  {
    type = "recipe",
    name = "fw-vulcanus-slag-cermet",
    icons = data.raw.item["fw-vulcanus-slag-cermet"].icons,
    category = "chemistry",
    subgroup = "fw-chemistry-processes",
    order = "f[late-chemistry]-g[vulcanus-slag-cermet]",
    enabled = false,
    energy_required = 10.0,
    allow_productivity = true,
    ingredients = {
      { type = "item", name = "fw-cermet", amount = 2 },
      { type = "item", name = "tungsten-carbide", amount = 2 },
      { type = "item", name = "calcite", amount = 3 },
      { type = "item", name = "fw-foundry-lining", amount = 1 },
      { type = "fluid", name = "sulfuric-acid", amount = 30 },
      { type = "fluid", name = "fw-red-flux", amount = 26 },
    },
    results = {
      { type = "item", name = "fw-vulcanus-slag-cermet", amount = 2 },
    },
  },
  {
    type = "recipe",
    name = "fw-superconductor-bath",
    icon = "__space-age__/graphics/icons/superconductor.png",
    icon_size = 64,
    category = "chemistry",
    subgroup = "fw-chemistry-processes",
    order = "f[late-chemistry]-i[superconductor-bath]",
    enabled = false,
    energy_required = 10.0,
    allow_productivity = true,
    ingredients = {
      { type = "item", name = "holmium-plate", amount = 1 },
      { type = "item", name = "aluminum-plate", amount = 1 },
      { type = "item", name = "tin-plate", amount = 1 },
      { type = "item", name = "plastic-bar", amount = 1 },
      { type = "item", name = "fw-rubber-sheet", amount = 1 },
      { type = "item", name = "fw-cryo-coil", amount = 1 },
      { type = "item", name = "fw-aquilo-cryogel", amount = 1 },
      { type = "item", name = "fw-fulgora-static-mesh", amount = 1 },
      { type = "fluid", name = "light-oil", amount = 5 },
      { type = "fluid", name = "fw-purple-flux", amount = 10 },
      { type = "fluid", name = "fw-yellow-flux", amount = 16 },
      { type = "fluid", name = "fw-red-flux", amount = 12 },
      { type = "fluid", name = "fw-green-flux", amount = 10 },
    },
    results = {
      { type = "item", name = "superconductor", amount = 2 },
    },
    main_product = "superconductor",
  },
  {
    type = "recipe",
    name = "fw-supercapacitor-conditioning",
    icon = "__space-age__/graphics/icons/supercapacitor.png",
    icon_size = 64,
    category = "chemistry",
    subgroup = "fw-chemistry-processes",
    order = "f[late-chemistry]-j[supercapacitor-conditioning]",
    enabled = false,
    energy_required = 12.0,
    allow_productivity = true,
    ingredients = {
      { type = "item", name = "holmium-plate", amount = 2 },
      { type = "item", name = "superconductor", amount = 2 },
      { type = "item", name = "electronic-circuit", amount = 4 },
      { type = "item", name = "silicon", amount = 1 },
      { type = "item", name = "aluminum-plate", amount = 1 },
      { type = "item", name = "battery", amount = 1 },
      { type = "item", name = "fw-power-regulator", amount = 1 },
      { type = "item", name = "fw-coil-block", amount = 1 },
      { type = "item", name = "fw-fulgora-static-mesh", amount = 1 },
      { type = "fluid", name = "electrolyte", amount = 10 },
      { type = "fluid", name = "fw-purple-flux", amount = 14 },
      { type = "fluid", name = "fw-yellow-flux", amount = 18 },
      { type = "fluid", name = "fw-red-flux", amount = 18 },
      { type = "fluid", name = "fw-green-flux", amount = 8 },
    },
    results = {
      { type = "item", name = "supercapacitor", amount = 2 },
    },
    main_product = "supercapacitor",
  },
  {
    type = "recipe",
    name = "fw-fusion-power-cell-conditioning",
    icon = "__space-age__/graphics/icons/fusion-power-cell.png",
    icon_size = 64,
    category = "chemistry",
    subgroup = "fw-chemistry-processes",
    order = "f[late-chemistry]-k[fusion-power-cell-conditioning]",
    enabled = false,
    energy_required = 14.0,
    allow_productivity = true,
    ingredients = {
      { type = "item", name = "lithium-plate", amount = 5 },
      { type = "item", name = "holmium-plate", amount = 1 },
      { type = "item", name = "titanium-plate", amount = 1 },
      { type = "item", name = "silicon", amount = 1 },
      { type = "item", name = "fw-thermal-buffer", amount = 1 },
      { type = "item", name = "fw-rift-stabilizer", amount = 1 },
      { type = "item", name = "fw-aquilo-cryogel", amount = 1 },
      { type = "item", name = "fw-gleba-spore-resin", amount = 1 },
      { type = "item", name = "fw-fulgora-static-mesh", amount = 1 },
      { type = "item", name = "fw-vulcanus-slag-cermet", amount = 1 },
      { type = "fluid", name = "ammonia", amount = 100 },
      { type = "fluid", name = "fw-purple-flux", amount = 24 },
      { type = "fluid", name = "fw-yellow-flux", amount = 20 },
      { type = "fluid", name = "fw-red-flux", amount = 24 },
      { type = "fluid", name = "fw-green-flux", amount = 20 },
    },
    results = {
      { type = "item", name = "fusion-power-cell", amount = 2 },
    },
    main_product = "fusion-power-cell",
  },
})

add_unlock("fw-liquid-mining", "fw-chlorine-pressurization")
add_unlock("fw-liquid-mining", "fw-latex-polymerization")
add_unlock("fw-polymer-chemistry", "fw-resin-polymerization")
add_unlock("fw-polymer-chemistry", "fw-sulfur-bonding")
add_unlock("fw-polymer-chemistry", "fw-acid-synthesis")
add_unlock("fw-polymer-chemistry", "fw-rubber-vulcanization")
add_unlock("fw-energetic-compounds", "fw-blasting-gel")
add_unlock("fw-energetic-compounds", "fw-reactive-slurry")
add_unlock("fw-energetic-compounds", "fw-battery-electrolyte")
add_unlock("fw-energetic-compounds", "fw-napalm")
add_unlock("fw-aquilo-cryochemistry", "fw-electrolyte-conditioning")
add_unlock("fw-aquilo-cryochemistry", "fw-lithium-adsorption")
add_unlock("fw-aquilo-cryochemistry", "fw-fluoroketone-synthesis")
add_unlock("fw-aquilo-cryochemistry", "fw-aquilo-cryogel")
add_unlock("fw-gleba-biochemistry", "fw-gleba-spore-resin")
add_unlock("fw-fulgora-electrochemistry", "fw-fulgora-static-mesh")
add_unlock("fw-vulcanus-pyrochemistry", "fw-vulcanus-slag-cermet")
add_unlock("fw-superconductive-systems", "fw-superconductor-bath")
add_unlock("fw-superconductive-systems", "fw-supercapacitor-conditioning")
add_unlock("fw-fusion-lattices", "fw-fusion-power-cell-conditioning")
