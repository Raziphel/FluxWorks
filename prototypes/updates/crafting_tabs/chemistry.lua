return function(Router)
  local set_subgroup = Router.set_subgroup
  local set_orders = Router.set_orders
  local purge_prototype = Router.purge
  local move_item_and_recipe = Router.move_item_and_recipe
  local move_recipe = Router.move_recipe

  for _, name in pairs({
    "coal",
    "carbon",
    "fw-carbon",
    "fw-salt",
    "sulfur",
    "lithium",
  }) do
    set_subgroup("item", name, "fw-chemistry-feedstocks")
  end

  for _, name in pairs({
    "fw-resin",
    "fw-chlorinated-binder-stock",
    "fw-elastomer-matrix",
    "fw-rubber-sheet",
    "plastic-bar",
  }) do
    set_subgroup("item", name, "fw-chemistry-polymers")
  end

  for _, name in pairs({
    "explosives",
    "battery",
  }) do
    set_subgroup("item", name, "fw-chemistry-reactives")
  end

  for _, name in pairs({
    "fw-chlorine",
    "fw-latex",
    "fw-blasting-gel",
    "fw-napalm",
    "sulfuric-acid",
    "lubricant",
    "holmium-solution",
    "fw-spectral-coolant-blend",
  }) do
    set_subgroup("fluid", name, "fw-chemistry-fluids")
  end

  for _, name in pairs({
    "fw-salt-from-water",
    "fw-carbon-refining",
    "fw-carbon-washing",
    "fw-salt-brine-clarification",
    "fw-silica-beneficiation",
    "fw-carbonic-washing",
    "coal-synthesis",
  }) do
    move_recipe(name, "fw-chemistry-feedstocks")
  end

  for _, name in pairs({
    "fw-latex-polymerization",
    "fw-resin-polymerization",
    "fw-chlorinated-binder-stock",
    "fw-elastomer-matrix",
    "fw-sulfur-bonding",
    "fw-rubber-vulcanization",
    "fw-rubber-sheet",
    "plastic-bar",
  }) do
    move_recipe(name, "fw-chemistry-polymers")
  end

  for _, name in pairs({
    "fw-gunpowder",
    "fw-gunpowder-early",
    "explosives",
    "battery",
    "fw-blasting-gel",
    "fw-reactive-slurry",
    "fw-battery-electrolyte",
    "fw-napalm",
    "flamethrower-ammo",
  }) do
    move_recipe(name, "fw-chemistry-reactives")
  end

  for _, name in pairs({
    "basic-oil-processing",
    "advanced-oil-processing",
    "coal-liquefaction",
    "simple-coal-liquefaction",
    "heavy-oil-cracking",
    "light-oil-cracking",
    "lubricant",
    "solid-fuel-from-light-oil",
    "solid-fuel-from-petroleum-gas",
    "solid-fuel-from-heavy-oil",
    "solid-fuel-from-ammonia",
    "ammonia-rocket-fuel",
    "thruster-fuel",
    "thruster-oxidizer",
    "advanced-thruster-fuel",
    "advanced-thruster-oxidizer",
  }) do
    move_recipe(name, "fw-chemistry-petrochem")
  end

  for _, name in pairs({
    "fw-chlorine",
    "fw-chlorine-pressurization",
    "fw-acid-synthesis",
    "acid-neutralisation",
    "sulfur",
    "sulfuric-acid",
    "ice-melting",
    "steam-condensation",
    "carbon",
    "lithium",
    "ammoniacal-solution-separation",
    "holmium-solution",
    "fw-spectral-coolant-blend",
  }) do
    move_recipe(name, "fw-chemistry-advanced")
  end

  for _, name in pairs({
    "fw-chlorine-barrel",
    "empty-fw-chlorine-barrel",
    "sulfuric-acid-barrel",
    "empty-sulfuric-acid-barrel",
    "lubricant-barrel",
    "empty-lubricant-barrel",
    "crude-oil-barrel",
    "empty-crude-oil-barrel",
    "heavy-oil-barrel",
    "empty-heavy-oil-barrel",
    "light-oil-barrel",
    "empty-light-oil-barrel",
    "petroleum-gas-barrel",
    "empty-petroleum-gas-barrel",
  }) do
    move_item_and_recipe(name, "fw-chemistry-barrels")
  end

  set_orders({ "item", "recipe" }, {
    { "chemical-plant", "a[machines]-a[chemical-plant]" },
    { "oil-refinery", "a[machines]-b[oil-refinery]" },
    { "fw-petrochemical-facility", "a[machines]-c[petrochemical-facility]" },
  })

  set_orders({ "item" }, {
    { "coal", "a[feedstocks]-a[coal]" },
    { "carbon", "a[feedstocks]-b[carbon]" },
    { "fw-carbon", "a[feedstocks]-c[refined-carbon]" },
    { "fw-salt", "a[feedstocks]-d[salt]" },
    { "sulfur", "a[feedstocks]-e[sulfur]" },
    { "lithium", "a[feedstocks]-f[lithium]" },
    { "fw-resin", "b[polymers]-a[resin]" },
    { "fw-chlorinated-binder-stock", "b[polymers]-b[chlorinated-binder-stock]" },
    { "fw-elastomer-matrix", "b[polymers]-c[elastomer-matrix]" },
    { "plastic-bar", "b[polymers]-d[plastic]" },
    { "fw-rubber-sheet", "b[polymers]-e[rubber-sheet]" },
    { "explosives", "c[energetics]-a[explosives]" },
    { "battery", "c[energetics]-b[battery]" },
  })

  set_orders({ "fluid" }, {
    { "fw-chlorine", "a[fluids]-a[chlorine]" },
    { "fw-latex", "a[fluids]-b[latex]" },
    { "sulfuric-acid", "a[fluids]-c[sulfuric-acid]" },
    { "lubricant", "a[fluids]-d[lubricant]" },
    { "fw-blasting-gel", "b[reactive]-a[blasting-gel]" },
    { "fw-napalm", "b[reactive]-b[napalm]" },
    { "holmium-solution", "c[advanced]-a[holmium-solution]" },
    { "fw-spectral-coolant-blend", "c[advanced]-b[spectral-coolant-blend]" },
  })

  set_orders({ "item", "recipe" }, {
    { "fw-chlorine-barrel", "f[barrels]-a[chlorine-barrel]" },
    { "empty-fw-chlorine-barrel", "f[barrels]-b[empty-chlorine-barrel]" },
    { "sulfuric-acid-barrel", "f[barrels]-c[sulfuric-acid-barrel]" },
    { "empty-sulfuric-acid-barrel", "f[barrels]-d[empty-sulfuric-acid-barrel]" },
    { "lubricant-barrel", "f[barrels]-e[lubricant-barrel]" },
    { "empty-lubricant-barrel", "f[barrels]-f[empty-lubricant-barrel]" },
    { "crude-oil-barrel", "f[barrels]-g[crude-oil-barrel]" },
    { "empty-crude-oil-barrel", "f[barrels]-h[empty-crude-oil-barrel]" },
    { "heavy-oil-barrel", "f[barrels]-i[heavy-oil-barrel]" },
    { "empty-heavy-oil-barrel", "f[barrels]-j[empty-heavy-oil-barrel]" },
    { "light-oil-barrel", "f[barrels]-k[light-oil-barrel]" },
    { "empty-light-oil-barrel", "f[barrels]-l[empty-light-oil-barrel]" },
    { "petroleum-gas-barrel", "f[barrels]-m[petroleum-gas-barrel]" },
    { "empty-petroleum-gas-barrel", "f[barrels]-n[empty-petroleum-gas-barrel]" },
  })

  set_orders({ "recipe" }, {
    { "fw-salt-from-water", "a[feedstocks]-a[salt-from-water]" },
    { "fw-carbon-refining", "a[feedstocks]-b[carbon-refining]" },
    { "fw-carbon-washing", "a[feedstocks]-c[carbon-washing]" },
    { "fw-salt-brine-clarification", "a[feedstocks]-d[salt-brine-clarification]" },
    { "fw-silica-beneficiation", "a[feedstocks]-e[silica-beneficiation]" },
    { "fw-carbonic-washing", "a[feedstocks]-f[carbonic-washing]" },
    { "coal-synthesis", "a[feedstocks]-g[coal-synthesis]" },
    { "fw-latex-polymerization", "b[polymers]-a[latex-polymerization]" },
    { "fw-resin-polymerization", "b[polymers]-b[resin-polymerization]" },
    { "fw-chlorinated-binder-stock", "b[polymers]-c[chlorinated-binder-stock]" },
    { "fw-elastomer-matrix", "b[polymers]-d[elastomer-matrix]" },
    { "fw-sulfur-bonding", "b[polymers]-e[sulfur-bonding]" },
    { "fw-rubber-vulcanization", "b[polymers]-f[rubber-vulcanization]" },
    { "fw-rubber-sheet", "b[polymers]-g[rubber-sheet]" },
    { "plastic-bar", "b[polymers]-h[plastic-bar]" },
    { "fw-gunpowder-early", "c[reactives]-a[gunpowder-early]" },
    { "fw-gunpowder", "c[reactives]-b[gunpowder]" },
    { "explosives", "c[reactives]-c[explosives]" },
    { "battery", "c[reactives]-d[battery]" },
    { "fw-blasting-gel", "c[reactives]-e[blasting-gel]" },
    { "fw-reactive-slurry", "c[reactives]-f[reactive-slurry]" },
    { "fw-battery-electrolyte", "c[reactives]-g[battery-electrolyte]" },
    { "fw-napalm", "c[reactives]-h[napalm]" },
    { "flamethrower-ammo", "c[reactives]-i[flamethrower-ammo]" },
    { "basic-oil-processing", "d[petrochem]-a[basic-oil-processing]" },
    { "advanced-oil-processing", "d[petrochem]-b[advanced-oil-processing]" },
    { "simple-coal-liquefaction", "d[petrochem]-c[simple-coal-liquefaction]" },
    { "coal-liquefaction", "d[petrochem]-d[coal-liquefaction]" },
    { "heavy-oil-cracking", "d[petrochem]-e[heavy-oil-cracking]" },
    { "light-oil-cracking", "d[petrochem]-f[light-oil-cracking]" },
    { "lubricant", "d[petrochem]-g[lubricant]" },
    { "solid-fuel-from-heavy-oil", "d[petrochem]-h[solid-fuel-from-heavy-oil]" },
    { "solid-fuel-from-light-oil", "d[petrochem]-i[solid-fuel-from-light-oil]" },
    { "solid-fuel-from-petroleum-gas", "d[petrochem]-j[solid-fuel-from-petroleum-gas]" },
    { "solid-fuel-from-ammonia", "d[petrochem]-k[solid-fuel-from-ammonia]" },
    { "ammonia-rocket-fuel", "d[petrochem]-l[ammonia-rocket-fuel]" },
    { "thruster-fuel", "d[petrochem]-m[thruster-fuel]" },
    { "thruster-oxidizer", "d[petrochem]-n[thruster-oxidizer]" },
    { "advanced-thruster-fuel", "d[petrochem]-o[advanced-thruster-fuel]" },
    { "advanced-thruster-oxidizer", "d[petrochem]-p[advanced-thruster-oxidizer]" },
    { "fw-chlorine", "e[advanced]-a[chlorine]" },
    { "fw-chlorine-pressurization", "e[advanced]-b[chlorine-pressurization]" },
    { "fw-acid-synthesis", "e[advanced]-c[acid-synthesis]" },
    { "acid-neutralisation", "e[advanced]-d[acid-neutralisation]" },
    { "sulfur", "e[advanced]-e[sulfur]" },
    { "sulfuric-acid", "e[advanced]-f[sulfuric-acid]" },
    { "ice-melting", "e[advanced]-g[ice-melting]" },
    { "steam-condensation", "e[advanced]-h[steam-condensation]" },
    { "carbon", "e[advanced]-i[carbon]" },
    { "lithium", "e[advanced]-j[lithium]" },
    { "ammoniacal-solution-separation", "e[advanced]-k[ammoniacal-solution-separation]" },
    { "holmium-solution", "e[advanced]-l[holmium-solution]" },
    { "fw-spectral-coolant-blend", "e[advanced]-m[spectral-coolant-blend]" },
  })
end
