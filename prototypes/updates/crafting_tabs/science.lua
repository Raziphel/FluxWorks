return function(Router)
  local set_orders = Router.set_orders
  local purge_prototype = Router.purge
  local move_science_pack = Router.move_science_pack
  local move_item_and_recipe = Router.move_item_and_recipe

  for _, name in pairs({
    "automation-science-pack",
    "logistic-science-pack",
    "military-science-pack",
    "chemical-science-pack",
    "production-science-pack",
    "utility-science-pack",
    "space-science-pack",
    "metallurgic-science-pack",
    "electromagnetic-science-pack",
    "agricultural-science-pack",
    "cryogenic-science-pack",
    "promethium-science-pack",
    "fw-industrial-methods-science-pack",
    "fw-systems-analysis-science-pack",
    "fw-flux-theory-science-pack",
    "fw-planetary-convergence-science-pack",
  }) do
    move_science_pack(name)
  end

  for _, name in pairs({
    "lab",
    "biolab",
  }) do
    move_item_and_recipe(name, "fw-science-labs")
  end

  set_orders({ "tool", "item", "recipe" }, {
    { "automation-science-pack", "a[progression]-01[automation]" },
    { "logistic-science-pack", "a[progression]-02[logistic]" },
    { "fw-industrial-methods-science-pack", "a[progression]-03[industrial-methods]" },
    { "military-science-pack", "a[progression]-04[military]" },
    { "chemical-science-pack", "a[progression]-05[chemical]" },
    { "production-science-pack", "a[progression]-06[production]" },
    { "fw-systems-analysis-science-pack", "a[progression]-07[systems-analysis]" },
    { "utility-science-pack", "a[progression]-08[utility]" },
    { "space-science-pack", "a[progression]-09[space]" },
    { "fw-flux-theory-science-pack", "a[progression]-10[flux-theory]" },
    { "metallurgic-science-pack", "b[planetary]-01[metallurgic]" },
    { "electromagnetic-science-pack", "b[planetary]-02[electromagnetic]" },
    { "agricultural-science-pack", "b[planetary]-03[agricultural]" },
    { "cryogenic-science-pack", "b[planetary]-04[cryogenic]" },
    { "promethium-science-pack", "b[planetary]-05[promethium]" },
    { "fw-planetary-convergence-science-pack", "b[planetary]-06[convergence]" },
    { "lab", "d[labs]-a[lab]" },
    { "biolab", "d[labs]-b[biolab]" },
  })
end
