return function(Router)
  local set_order = Router.set_order
  local set_orders = Router.set_orders
  local purge_prototype = Router.purge
  local move_item_and_recipe = Router.move_item_and_recipe

for _, name in pairs({
  "burner-mining-drill",
  "electric-mining-drill",
  "big-mining-drill",
  "pumpjack",
  "agricultural-tower",
  "fw-flux-quarry",
  "fw-flux-harvester",
}) do
  move_item_and_recipe(name, "extraction-machine")
end

for _, entry in pairs({
  { "burner-mining-drill", "a[mining]-a[burner-mining-drill]" },
  { "electric-mining-drill", "a[mining]-b[electric-mining-drill]" },
  { "big-mining-drill", "a[mining]-c[big-mining-drill]" },
  { "pumpjack", "b[resource-pumps]-a[pumpjack]" },
  { "agricultural-tower", "c[biological-harvest]-a[agricultural-tower]" },
  { "fw-flux-quarry", "d[flux-harvest]-a[flux-quarry]" },
  { "fw-flux-harvester", "d[flux-harvest]-b[flux-harvester]" },
}) do
  set_order("item", entry[1], entry[2])
  set_order("recipe", entry[1], entry[2])
end

for _, name in pairs({
  "stone-furnace",
  "steel-furnace",
  "electric-furnace",
  "foundry",
  "fw-arc-foundry",
}) do
  move_item_and_recipe(name, "smelting-machine")
end

for _, entry in pairs({
  { "stone-furnace", "a[furnaces]-a[stone-furnace]" },
  { "steel-furnace", "a[furnaces]-b[steel-furnace]" },
  { "electric-furnace", "a[furnaces]-c[electric-furnace]" },
  { "foundry", "b[foundries]-a[foundry]" },
  { "fw-arc-foundry", "b[foundries]-b[arc-foundry]" },
}) do
  set_order("item", entry[1], entry[2])
  set_order("recipe", entry[1], entry[2])
end

for _, name in pairs({
  "burner-assembling-machine",
  "assembling-machine-1",
  "assembling-machine-2",
  "assembling-machine-3",
  "electromagnetic-plant",
  "cryogenic-plant",
  "fw-synthesis-plant",
  "fw-flux-condenser",
  "fw-origin-forge",
}) do
  move_item_and_recipe(name, "production-machine")
end

for _, entry in pairs({
  { "burner-assembling-machine", "a[assembly]-a[burner-assembling-machine]" },
  { "assembling-machine-1", "a[assembly]-b[assembling-machine-1]" },
  { "assembling-machine-2", "a[assembly]-c[assembling-machine-2]" },
  { "assembling-machine-3", "a[assembly]-d[assembling-machine-3]" },
  { "electromagnetic-plant", "b[advanced-assembly]-a[electromagnetic-plant]" },
  { "cryogenic-plant", "b[advanced-assembly]-b[cryogenic-plant]" },
  { "fw-synthesis-plant", "b[advanced-assembly]-c[synthesis-plant]" },
  { "fw-flux-condenser", "c[flux]-a[flux-condenser]" },
  { "fw-origin-forge", "c[flux]-b[origin-forge]" },
}) do
  set_order("item", entry[1], entry[2])
  set_order("recipe", entry[1], entry[2])
end

for _, name in pairs({
  "chemical-plant",
  "oil-refinery",
  "fw-petrochemical-facility",
  "fw-hydraulic-plant",
}) do
  move_item_and_recipe(name, "production-machine")
end

for _, entry in pairs({
  { "chemical-plant", "a[processing]-a[chemical-plant]" },
  { "oil-refinery", "a[processing]-b[oil-refinery]" },
  { "fw-petrochemical-facility", "b[expansion]-a[petrochemical-facility]" },
  { "fw-hydraulic-plant", "b[expansion]-b[hydraulic-plant]" },
}) do
  set_order("item", entry[1], entry[2])
  set_order("recipe", entry[1], entry[2])
end

for _, name in pairs({
  "crusher",
  "biochamber",
  "centrifuge",
  "recycler",
}) do
  move_item_and_recipe(name, "production-machine")
end

for _, entry in pairs({
  { "crusher", "a[ore-processing]-a[crusher]" },
  { "biochamber", "b[specialized]-a[biochamber]" },
  { "centrifuge", "b[specialized]-b[centrifuge]" },
  { "recycler", "b[specialized]-c[recycler]" },
}) do
  set_order("item", entry[1], entry[2])
  set_order("recipe", entry[1], entry[2])
end

-- AAI/K2 machines otherwise retain late z-orders in the production group and
-- form an orphaned block below modules. Keep them with their actual families.
move_item_and_recipe("area-mining-drill", "extraction-machine")
move_item_and_recipe("industrial-furnace", "smelting-machine")
move_item_and_recipe("fuel-processor", "production-machine")
move_item_and_recipe("burner-lab", "fw-science-labs")
move_item_and_recipe("captive-biter-spawner", "fw-bioprocessing-machines")

set_orders({ "item", "recipe" }, {
  { "area-mining-drill", "a[mining]-c[area-mining-drill]" },
  { "big-mining-drill", "a[mining]-d[big-mining-drill]" },
  { "industrial-furnace", "a[furnaces]-d[industrial-furnace]" },
  { "fuel-processor", "d[specialized]-a[fuel-processor]" },
  { "burner-lab", "d[labs]-a[burner-lab]" },
  { "captive-biter-spawner", "a[machines]-c[captive-biter-spawner]" },
})
end
