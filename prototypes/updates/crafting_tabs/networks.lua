return function(Router)
  local set_orders = Router.set_orders
  local purge_prototype = Router.purge
  local move_item_and_recipe = Router.move_item_and_recipe

  for _, name in pairs({
    "small-lamp",
    "red-wire",
    "green-wire",
    "constant-combinator",
    "arithmetic-combinator",
    "decider-combinator",
    "selector-combinator",
    "power-switch",
    "programmable-speaker",
    "display-panel",
  }) do
    move_item_and_recipe(name, "fw-logistics-circuitry")
  end

  set_orders({ "item", "recipe" }, {
    { "small-lamp", "b[signals]-a[small-lamp]" },
    { "red-wire", "b[signals]-b[red-wire]" },
    { "green-wire", "b[signals]-c[green-wire]" },
    { "constant-combinator", "c[automation]-a[constant-combinator]" },
    { "arithmetic-combinator", "c[automation]-b[arithmetic-combinator]" },
    { "decider-combinator", "c[automation]-c[decider-combinator]" },
    { "selector-combinator", "c[automation]-d[selector-combinator]" },
    { "power-switch", "d[network]-a[power-switch]" },
    { "programmable-speaker", "d[network]-b[programmable-speaker]" },
    { "display-panel", "d[network]-c[display-panel]" },
  })

  for _, name in pairs({ "construction-robot", "logistic-robot", "roboport" }) do
    move_item_and_recipe(name, "fw-logistics-robotics")
  end

  for _, name in pairs({ "radar", "beacon", "remnant-beacon" }) do
    move_item_and_recipe(name, "fw-logistics-network")
  end

  set_orders({ "item", "recipe" }, {
    { "construction-robot", "a[robots]-a[construction-robot]" },
    { "logistic-robot", "a[robots]-b[logistic-robot]" },
    { "roboport", "b[network]-a[roboport]" },
    { "radar", "a[coverage]-a[radar]" },
    { "beacon", "a[coverage]-b[beacon]" },
    { "remnant-beacon", "a[coverage]-c[remnant-beacon]" },
  })
end
