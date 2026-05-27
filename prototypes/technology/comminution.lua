data:extend({
  {
    type = "technology",
    name = "fw-comminution",
    icon = "__FluxWorksAssets__/graphics/technology/comminution.png",
    icon_size = 968,
    prerequisites = { "automation" },
    unit = {
      count = 40,
      ingredients = {
        { "automation-science-pack", 1 },
      },
      time = 20,
    },
    effects = {
      { type = "unlock-recipe", recipe = "crusher" },
      { type = "unlock-recipe", recipe = "fw-crushed-iron-ore" },
      { type = "unlock-recipe", recipe = "fw-crushed-copper-ore" },
      { type = "unlock-recipe", recipe = "fw-crushed-lead-ore" },
      { type = "unlock-recipe", recipe = "fw-crushed-titanium-ore" },
      { type = "unlock-recipe", recipe = "fw-gunpowder-early" },
    },
    order = "a-b-c[fw-comminution]",
  },
})
