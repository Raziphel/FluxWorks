return function(Router)
  local set_orders = Router.set_orders
  local purge_prototype = Router.purge
  local move_item_and_recipe = Router.move_item_and_recipe
  local move_recipe = Router.move_recipe

  for _, name in pairs({
    "burner-turbine",
    "heating-tower",
  }) do
    move_item_and_recipe(name, "fw-energy-generation")
  end

  for _, name in pairs({
    "nuclear-reactor",
    "heat-pipe",
    "heat-exchanger",
    "steam-turbine",
    "fusion-reactor",
    "fusion-generator",
  }) do
    move_item_and_recipe(name, "fw-energy-reactors")
  end

  for _, name in pairs({
    "boiler",
    "steam-engine",
    "solar-panel",
    "lightning-rod",
    "lightning-collector",
  }) do
    move_item_and_recipe(name, "fw-energy-generation")
  end

  for _, name in pairs({
    "accumulator",
    "supercapacitor",
    "fw-thermal-buffer",
    "fw-cryo-coil",
  }) do
    move_item_and_recipe(name, "fw-energy-storage")
  end

  for _, name in pairs({
    "centrifuge",
    "fw-atomic-enricher",
    "fw-isotope-matrix",
    "fw-moderator-lattice",
    "fw-control-rod-assembly",
    "fw-reactor-coolant-cartridge",
    "fw-reactor-dopant",
    "fw-recovered-actinides",
  }) do
    move_item_and_recipe(name, "fw-energy-reactors")
  end

  for _, name in pairs({
    "solid-fuel",
    "rocket-fuel",
    "nuclear-fuel",
    "fusion-power-cell",
    "fw-shielded-fuel-casing",
    "fw-fuel-pellet-bundle",
  }) do
    move_item_and_recipe(name, "fw-energy-fuels")
  end

  for _, name in pairs({
    "fw-reactor-grade-fuel-cell",
    "fw-spent-fuel-reconditioning",
    "fw-nuclear-fuel-overdrive",
    "fw-supercapacitor-conditioning",
    "fw-fusion-power-cell-conditioning",
  }) do
    move_recipe(name, "fw-energy-fuels")
  end

  set_orders({ "item", "recipe" }, {
    { "burner-turbine", "a[steam]-a[burner-turbine]" },
    { "boiler", "a[steam]-b[boiler]" },
    { "steam-engine", "a[steam]-c[steam-engine]" },
    { "heating-tower", "a[steam]-d[heating-tower]" },
    { "solar-panel", "b[renewable]-a[solar-panel]" },
    { "lightning-rod", "b[renewable]-b[lightning-rod]" },
    { "lightning-collector", "b[renewable]-c[lightning-collector]" },
  })

  set_orders({ "item", "recipe" }, {
    { "accumulator", "a[storage]-a[accumulator]" },
    { "supercapacitor", "a[storage]-b[supercapacitor]" },
    { "fw-thermal-buffer", "b[thermal]-a[thermal-buffer]" },
    { "fw-cryo-coil", "b[thermal]-b[cryo-coil]" },
  })

  set_orders({ "item", "recipe" }, {
    { "nuclear-reactor", "a[nuclear]-a[nuclear-reactor]" },
    { "heat-pipe", "a[nuclear]-b[heat-pipe]" },
    { "heat-exchanger", "a[nuclear]-c[heat-exchanger]" },
    { "steam-turbine", "a[nuclear]-d[steam-turbine]" },
    { "fusion-reactor", "b[fusion]-a[fusion-reactor]" },
    { "fusion-generator", "b[fusion]-b[fusion-generator]" },
    { "centrifuge", "c[reactor-support]-a[centrifuge]" },
    { "fw-atomic-enricher", "c[reactor-support]-b[atomic-enricher]" },
    { "fw-isotope-matrix", "b[core-parts]-a[isotope-matrix]" },
    { "fw-moderator-lattice", "b[core-parts]-b[moderator-lattice]" },
    { "fw-control-rod-assembly", "b[core-parts]-c[control-rod-assembly]" },
    { "fw-reactor-coolant-cartridge", "c[control]-a[reactor-coolant-cartridge]" },
    { "fw-reactor-dopant", "c[control]-b[reactor-dopant]" },
    { "fw-recovered-actinides", "d[recovery]-a[recovered-actinides]" },
  })

  set_orders({ "item", "recipe" }, {
    { "solid-fuel", "a[chemical]-a[solid-fuel]" },
    { "rocket-fuel", "a[chemical]-b[rocket-fuel]" },
    { "nuclear-fuel", "a[chemical]-c[nuclear-fuel]" },
    { "fusion-power-cell", "b[cells]-a[fusion-power-cell]" },
    { "fw-shielded-fuel-casing", "b[cells]-b[shielded-fuel-casing]" },
    { "fw-fuel-pellet-bundle", "b[cells]-c[fuel-pellet-bundle]" },
    { "fw-supercapacitor-conditioning", "c[conditioning]-a[supercapacitor-conditioning]" },
    { "fw-fusion-power-cell-conditioning", "c[conditioning]-b[fusion-power-cell-conditioning]" },
    { "fw-reactor-grade-fuel-cell", "d[reactor-fuels]-a[reactor-grade-fuel-cell]" },
    { "fw-spent-fuel-reconditioning", "d[reactor-fuels]-b[spent-fuel-reconditioning]" },
    { "fw-nuclear-fuel-overdrive", "d[reactor-fuels]-c[nuclear-fuel-overdrive]" },
  })
end
