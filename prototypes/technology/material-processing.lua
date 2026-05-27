local core_effects = {
  { type = "unlock-recipe", recipe = "fw-solder-alloy" },
  { type = "unlock-recipe", recipe = "fw-bearing" },
  { type = "unlock-recipe", recipe = "fw-ceramic-insulator" },
}

local advanced_effects = {
  { type = "unlock-recipe", recipe = "fw-light-frame" },
  { type = "unlock-recipe", recipe = "fw-capacitor" },
  { type = "unlock-recipe", recipe = "fw-gunpowder" },
}

data:extend({
  {
    type = "technology",
    name = "fw-metals-fabrication",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-bearing.png",
    icon_size = 128,
    prerequisites = { "fw-comminution", "steel-processing" },
    unit = {
      count = 120,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
      },
      time = 30,
    },
    effects = core_effects,
    order = "c-a[fw-metals-fabrication]",
  },
  {
    type = "technology",
    name = "fw-advanced-fabrication",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-light-frame.png",
    icon_size = 128,
    prerequisites = { "fw-metals-fabrication", "advanced-circuit", "military" },
    unit = {
      count = 180,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
      },
      time = 30,
    },
    effects = advanced_effects,
    order = "c-b[fw-advanced-fabrication]",
  },
})
