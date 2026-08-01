return function(Router)
  for _, name in pairs({
    "fw-rift-exchange-gate",
    "fw-rift-exchange-fluid-gate",
  }) do
    Router.move_item_and_recipe(name, "fw-flux-exchange")
  end

  for _, entry in pairs({
    { "fw-rift-exchange-gate", "e[rift-logistics]-a[exchange-gate]" },
    { "fw-rift-exchange-fluid-gate", "e[rift-logistics]-b[exchange-fluid-gate]" },
  }) do
    Router.set_order("item", entry[1], entry[2])
    Router.set_order("recipe", entry[1], entry[2])
  end

  Router.move_item_and_recipe("fw-origin-singularity", "fw-flux-origin-projects")
  Router.set_order("item", "fw-origin-singularity", "z[origin]-z[origin-singularity]")
  Router.set_order("recipe", "fw-origin-singularity", "z[origin]-z[origin-singularity]")
end
