return function(Router)
  local set_orders = Router.set_orders
  local purge_prototype = Router.purge
  local move_item_and_recipe = Router.move_item_and_recipe
  local move_recipe = Router.move_recipe

  for _, name in pairs({
  "fw-rift-coupler",
  }) do
    move_item_and_recipe(name, "fw-flux-exchange")
  end

  for _, name in pairs({
  "fw-model-lattice",
  "fw-phase-anchor",
  "fw-entanglement-core",
  "fw-reservoir-lining",
  "fw-compression-baffle",
  "fw-thermal-phase-gasket",
  }) do
    move_item_and_recipe(name, "fw-flux-exchange")
  end

  for _, name in pairs({
    "fw-storm-spine-segment",
    "fw-origin-crucible-lining",
    "fw-harmonic-lattice-core",
    "fw-living-reactor-weave",
    "fw-origin-catalyst-manifold",
    "fw-storm-spine",
    "fw-origin-crucible",
    "fw-universal-collapse-core",
    "fw-genesis-ark",
  }) do
    move_item_and_recipe(name, "fw-flux-origin-projects")
  end

  for _, name in pairs({
  "fw-flux-catalyst",
  "fw-stabilized-flux-crystal",
  "fw-flux-lattice",
  "fw-harvester-head",
  "fw-annealed-cermet",
  "fw-resonance-substrate",
  "fw-quantum-computer",
  "fw-condensed-flux-matrix",
  "fw-flux-resonance-cell",
  "fw-flux-phase-manifold",
  }) do
    move_item_and_recipe(name, "fw-flux-systems")
  end
  for _, name in pairs({
  "fw-condensed-flux-matrix",
  "fw-flux-phase-manifold",
  }) do
    move_item_and_recipe(name, "fw-flux-condensing-core")
  end
  for _, name in pairs({
  "fw-promethium-matrix",
  "fw-rift-stabilizer",
  }) do
    move_item_and_recipe(name, "fw-flux-condensing-promethium")
  end
  move_recipe("fw-flux-asteroid-refining", "fw-flux-systems")
  move_recipe("fw-flux-metallic-synthesis", "fw-flux-systems")
  move_recipe("fw-rift-seed-crystallization", "fw-flux-systems")
  move_recipe("fw-condensed-flux-matrix", "fw-flux-condensing-core")
  move_recipe("fw-flux-phase-manifold", "fw-flux-condensing-core")
  move_recipe("fw-promethium-matrix", "fw-flux-condensing-promethium")
  move_recipe("fw-rift-stabilizer", "fw-flux-condensing-promethium")

  set_orders({ "item", "recipe" }, {
    { "fw-flux-catalyst", "a[catalysts]-a[flux-catalyst]" },
    { "fw-stabilized-flux-crystal", "a[catalysts]-b[stabilized-flux-crystal]" },
    { "fw-flux-lattice", "b[lattice]-a[flux-lattice]" },
    { "fw-resonance-substrate", "b[lattice]-b[resonance-substrate]" },
    { "fw-flux-resonance-cell", "b[lattice]-c[flux-resonance-cell]" },
    { "fw-harvester-head", "c[infrastructure]-a[harvester-head]" },
    { "fw-annealed-cermet", "c[infrastructure]-b[annealed-cermet]" },
    { "fw-condensed-flux-matrix", "d[condensing]-a[condensed-flux-matrix]" },
    { "fw-flux-phase-manifold", "d[condensing]-b[flux-phase-manifold]" },
    { "fw-quantum-computer", "d[condensing]-c[quantum-computer]" },
    { "fw-flux-asteroid-refining", "e[processing]-b[flux-asteroid-refining]" },
    { "fw-flux-metallic-synthesis", "e[processing]-c[flux-metallic-synthesis]" },
    { "fw-rift-seed-crystallization", "e[processing]-d[rift-seed-crystallization]" },
  })

  set_orders({ "item", "recipe" }, {
    { "fw-phase-anchor", "a[exchange-components]-a[phase-anchor]" },
    { "fw-entanglement-core", "a[exchange-components]-b[entanglement-core]" },
    { "fw-reservoir-lining", "a[exchange-components]-c[reservoir-lining]" },
    { "fw-compression-baffle", "a[exchange-components]-d[compression-baffle]" },
    { "fw-thermal-phase-gasket", "a[exchange-components]-e[thermal-phase-gasket]" },
    { "fw-model-lattice", "a[exchange-components]-f[model-lattice]" },
    { "fw-rift-coupler", "b[exchange-systems]-a[rift-coupler]" },
  })

  set_orders({ "item", "recipe" }, {
    { "fw-storm-spine-segment", "a[precursors]-a[storm-spine-segment]" },
    { "fw-origin-crucible-lining", "a[precursors]-b[origin-crucible-lining]" },
    { "fw-harmonic-lattice-core", "a[precursors]-c[harmonic-lattice-core]" },
    { "fw-living-reactor-weave", "a[precursors]-d[living-reactor-weave]" },
    { "fw-origin-catalyst-manifold", "a[precursors]-e[origin-catalyst-manifold]" },
    { "fw-storm-spine", "b[projects]-a[storm-spine]" },
    { "fw-origin-crucible", "b[projects]-b[origin-crucible]" },
    { "fw-universal-collapse-core", "b[projects]-c[universal-collapse-core]" },
    { "fw-genesis-ark", "b[projects]-d[genesis-ark]" },
  })

  for recipe_name, recipe in pairs(data.raw.recipe or {}) do
    if string.sub(recipe_name, 1, 22) == "fw-exchange-from-flux-" then
      recipe.subgroup = "fw-flux-exchange"
    elseif string.sub(recipe_name, 1, 30) == "fw-purple-flux-from-material-" then
      recipe.subgroup = "fw-flux-purple"
    elseif string.sub(recipe_name, 1, 15) == "fw-yellow-flux-" then
      recipe.subgroup = "fw-flux-yellow"
    elseif string.sub(recipe_name, 1, 24) == "fw-red-flux-from-fuel-" then
      recipe.subgroup = "fw-flux-red"
    elseif string.sub(recipe_name, 1, 12) == "fw-red-flux-" then
      recipe.subgroup = "fw-flux-red"
    elseif string.sub(recipe_name, 1, 14) == "fw-green-flux-" then
      recipe.subgroup = "fw-flux-green"
    elseif string.sub(recipe_name, 1, 3) == "fw-" and string.find(recipe_name, "flux", 1, true) then
      recipe.subgroup = recipe.subgroup or "fw-flux-systems"
    end
  end
end
