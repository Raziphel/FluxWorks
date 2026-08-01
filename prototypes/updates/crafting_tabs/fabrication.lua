return function(Router)
  local set_order = Router.set_order
  local purge_prototype = Router.purge
  local move_item_and_recipe = Router.move_item_and_recipe
  local move_recipe = Router.move_recipe

  for _, name in pairs({
    "fw-signal-conduit",
    "fw-power-regulator",
    "fw-field-winding",
    "fw-transformer-core",
    "fw-em-core",
  }) do
    move_item_and_recipe(name, "fw-intermediate-electrical")
  end

  for _, name in pairs({
    "fw-logic-matrix",
    "fw-lens-array",
    "fw-sensor-package",
    "fw-memory-die",
    "fw-flow-regulator",
    "fw-hydraulic-manifold",
  }) do
    move_item_and_recipe(name, "fw-intermediate-precision")
  end

  for _, name in pairs({
    "fw-fired-ceramic",
    "fw-ceramic-casing",
    "fw-pressure-housing",
    "fw-foundry-lining",
    "fw-reinforced-seal",
    "fw-radioactive-scrap",
  }) do
    move_item_and_recipe(name, "fw-intermediate-structural")
  end

  for _, entry in pairs({
    { "fw-fired-ceramic", "a[ceramics]-a[fired-ceramic]" },
    { "fw-ceramic-casing", "a[ceramics]-b[ceramic-casing]" },
    { "fw-pressure-housing", "b[housings]-a[pressure-housing]" },
    { "fw-foundry-lining", "b[housings]-b[foundry-lining]" },
    { "fw-reinforced-seal", "c[hydraulics]-a[reinforced-seal]" },
    { "fw-radioactive-scrap", "d[recovery]-a[radioactive-scrap]" },
  }) do
    set_order("item", entry[1], entry[2])
    set_order("recipe", entry[1], entry[2])
  end

  for _, name in pairs({
    "fw-coil-block",
  }) do
    move_item_and_recipe(name, "fw-intermediate-electrical")
  end

  for _, entry in pairs({
    { "fw-coil-block", "a[wiring]-a[coil-block]" },
  }) do
    set_order("item", entry[1], entry[2])
    set_order("recipe", entry[1], entry[2])
  end

  for _, name in pairs({
    "fw-gunpowder",
    "fw-solder-alloy",
  }) do
    move_item_and_recipe(name, "fw-intermediate-ballistic")
  end

  for _, entry in pairs({
    { "fw-gunpowder", "a[propellant]-a[gunpowder]" },
    { "fw-solder-alloy", "b[alloys]-a[solder-alloy]" },
  }) do
    set_order("item", entry[1], entry[2])
    set_order("recipe", entry[1], entry[2])
  end

  for _, entry in pairs({
    { "fw-radioactive-scrap-sorting", "a[recovery]-a[radioactive-scrap-sorting]" },
    { "fw-isotope-recovery", "a[recovery]-b[isotope-recovery]" },
    { "fw-actinide-matrix-seeding", "a[recovery]-c[actinide-matrix-seeding]" },
    { "fw-scrap-lattice-recasting", "a[recovery]-d[scrap-lattice-recasting]" },
    { "fw-actinide-dopant-refining", "a[recovery]-e[actinide-dopant-refining]" },
  }) do
    move_recipe(entry[1], "fw-fabrication-components")
    set_order("recipe", entry[1], entry[2])
  end

  -- These are material-production routes whose products already live in the
  -- fabrication tab. Consuming Flux does not make the finished material a
  -- Flux system, so keep the alternate recipes beside their primary recipes.
  for _, entry in pairs({
    { "fw-flux-fired-ceramic-annealing", "a[ceramics]-a2[flux-annealing]" },
    { "fw-arc-glass-recast", "a[ceramics]-b[arc-glass-recast]" },
    { "fw-arc-insulator-vitrification", "a[ceramics]-c[arc-insulator-vitrification]" },
    { "fw-flux-cermet-tempering", "b[advanced-materials]-a[flux-cermet-tempering]" },
    { "fw-arc-cermet-densification", "b[advanced-materials]-b[arc-cermet-densification]" },
    { "fw-vulcanus-slag-cermet", "b[advanced-materials]-c[vulcanus-slag-cermet]" },
  }) do
    move_recipe(entry[1], "fw-fabrication-components")
    set_order("recipe", entry[1], entry[2])
  end

  move_recipe("fw-pellet-bundle-reprocessing", "fw-energy-fuels")
  set_order("recipe", "fw-pellet-bundle-reprocessing", "d[reactor-fuels]-d[pellet-bundle-reprocessing]")
end
