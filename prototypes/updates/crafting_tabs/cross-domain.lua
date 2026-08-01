return function(Router)
  local set_order = Router.set_order
  local purge_prototype = Router.purge
  local move_item_and_recipe = Router.move_item_and_recipe
  local move_recipe = Router.move_recipe

-- Orbital salvage parts read better beside the Space Age platform chain
-- than inside FluxWorks fabrication components.
move_item_and_recipe("fw-rocket-avionics", "space-material")
move_item_and_recipe("fw-rocket-heatshield", "space-material")
move_item_and_recipe("fw-rocket-engine", "space-material")
move_item_and_recipe("incomplete-rocket-part", "space-material")
move_item_and_recipe("remnant-beacon", "fw-logistics-network")

for _, entry in pairs({
  { "casting-pipe", "c[foundry-casting]-a[casting-pipe]" },
  { "casting-pipe-to-ground", "c[foundry-casting]-b[casting-pipe-to-ground]" },
}) do
  move_recipe(entry[1], "fw-production-assembly")
  set_order("recipe", entry[1], entry[2])
end
end
