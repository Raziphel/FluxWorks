return function(Router)
  local set_subgroup = Router.set_subgroup
  local set_orders = Router.set_orders
  local purge_prototype = Router.purge
  local move_item_and_recipe = Router.move_item_and_recipe
  local move_recipe = Router.move_recipe

  for _, name in pairs({
  "fw-crystalised-flux",
  "fw-flux-asteroid-chunk",
  }) do
    set_subgroup("item", name, "fw-flux-resources")
  end

  set_subgroup("fluid", "fw-purple-flux", "fw-flux-purple")
  move_recipe("fw-purple-flux", "fw-flux-purple")
  move_recipe("fw-purple-flux-reclamation", "fw-flux-purple")
  move_item_and_recipe("fw-purple-flux-barrel", "fw-flux-purple")
  move_recipe("empty-fw-purple-flux-barrel", "fw-flux-purple")

  set_subgroup("fluid", "fw-yellow-flux", "fw-flux-yellow")
  move_recipe("fw-yellow-flux-conditioning", "fw-flux-yellow")

  set_subgroup("fluid", "fw-red-flux", "fw-flux-red")
  move_recipe("fw-red-flux-conditioning", "fw-flux-red")

  set_subgroup("fluid", "fw-green-flux", "fw-flux-green")
  move_recipe("fw-green-flux-conditioning", "fw-flux-green")

  set_orders({ "item" }, {
    { "fw-crystalised-flux", "a[resources]-a[crystalised-flux]" },
    { "fw-flux-asteroid-chunk", "a[resources]-b[flux-asteroid-chunk]" },
    { "fw-promethium-shard", "a[resources]-c[promethium-shard]" },
  })

  set_orders({ "fluid", "recipe", "item" }, {
    { "fw-purple-flux", "b[raw-flux]-a[purple-flux]" },
    { "fw-purple-flux-barrel", "b[raw-flux]-b[purple-flux-barrel]" },
    { "empty-fw-purple-flux-barrel", "b[raw-flux]-c[empty-purple-flux-barrel]" },
    { "fw-yellow-flux-conditioning", "c[refined-flux]-a[yellow-flux-conditioning]" },
    { "fw-red-flux-conditioning", "c[refined-flux]-b[red-flux-conditioning]" },
    { "fw-green-flux-conditioning", "c[refined-flux]-c[green-flux-conditioning]" },
  })

end
