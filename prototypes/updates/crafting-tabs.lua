local Startup = require("prototypes.lib.startup-settings")

if not Startup.enabled("fw-enable-crafting-tab-reorganization", true) then
  return
end

local organize_science = Startup.enabled("fw-tab-science-organization", true)
local organize_bioprocessing = Startup.enabled("fw-tab-bioprocessing-organization", true)
local organize_energy = Startup.enabled("fw-tab-energy-organization", true)
local organize_chemistry = Startup.enabled("fw-tab-chemistry-organization", true)
local organize_systems = Startup.enabled("fw-tab-systems-organization", true)
local organize_flux = Startup.enabled("fw-tab-flux-organization", true)
local organize_fabrication = Startup.enabled("fw-tab-fabrication-organization", true)

local function ensure_item_group(name, icon, icon_size, order)
  local group = data.raw["item-group"] and data.raw["item-group"][name]
  if group then
    group.icon = icon or group.icon
    group.icon_size = icon_size or group.icon_size
    group.order = order or group.order
    return
  end

  data:extend({
    {
      type = "item-group",
      name = name,
      icon = icon,
      icon_size = icon_size,
      order = order,
    },
  })
end

local function ensure_item_subgroup(name, group, order)
  local subgroup = data.raw["item-subgroup"] and data.raw["item-subgroup"][name]
  if subgroup then
    subgroup.group = group or subgroup.group
    subgroup.order = order or subgroup.order
    return
  end

  data:extend({
    {
      type = "item-subgroup",
      name = name,
      group = group,
      order = order,
    },
  })
end

local function set_subgroup(prototype_type, name, subgroup)
  local prototype = data.raw[prototype_type] and data.raw[prototype_type][name]
  if prototype then
    prototype.subgroup = subgroup
  end
end

local function set_order(prototype_type, name, order)
  local prototype = data.raw[prototype_type] and data.raw[prototype_type][name]
  if prototype then
    prototype.order = order
  end
end

local function set_many_subgroups(prototype_types, name, subgroup)
  for _, prototype_type in pairs(prototype_types) do
    set_subgroup(prototype_type, name, subgroup)
  end
end

local function set_orders(prototype_types, entries)
  for _, entry in pairs(entries) do
    for _, prototype_type in pairs(prototype_types) do
      set_order(prototype_type, entry[1], entry[2])
    end
  end
end

local function move_science_pack(name)
  set_many_subgroups({ "tool", "item", "recipe" }, name, "fw-science-packs")
end

local function move_item_and_recipe(name, subgroup)
  set_many_subgroups({ "item", "tool", "capsule", "module", "ammo", "recipe" }, name, subgroup)
end

local function move_recipe(name, subgroup)
  set_subgroup("recipe", name, subgroup)
end

local function recipe_entries(recipe, field)
  if recipe[field] then
    return recipe[field]
  end
  if recipe.normal and recipe.normal[field] then
    return recipe.normal[field]
  end
  return nil
end

local function entry_type(entry)
  return entry.type or "item"
end

local function entry_name(entry)
  return entry.name or entry[1]
end

local function recipe_main_item_name(recipe)
  if not recipe then
    return nil
  end
  if recipe.main_product and recipe.main_product ~= "" then
    return recipe.main_product
  end
  local results = recipe_entries(recipe, "results")
  if results then
    for _, result in pairs(results) do
      if entry_type(result) == "item" then
        return entry_name(result)
      end
    end
  end
  return recipe.result or (recipe.normal and recipe.normal.result)
end

local function item_subgroup(name)
  local item = data.raw.item and data.raw.item[name]
  if item then
    return item.subgroup
  end
  local tool = data.raw.tool and data.raw.tool[name]
  if tool then
    return tool.subgroup
  end
  return nil
end

ensure_item_group("fw-science", "__base__/graphics/icons/lab.png", 64, "z[fluxworks]-a[science]")
ensure_item_group("fw-bioprocessing", "__space-age__/graphics/icons/biochamber.png", 64, "z[fluxworks]-b[bioprocessing]")
ensure_item_group("fw-energy", "__space-age__/graphics/icons/fusion-power-cell.png", 64, "z[fluxworks]-c[energy]")
ensure_item_group("fw-chemistry", "__Krastorio2Assets__/icons/fluids/chlorine.png", 64, "z[fluxworks]-d[chemistry]")
ensure_item_group("fw-systems", "__FluxWorksAssets__/graphics/icons/items/fw-logic-matrix.png", 64, "z[fluxworks]-e[systems]")
ensure_item_group("fw-fabrication", "__FluxWorksAssets__/graphics/icons/items/fw-foundry-lining.png", 1024, "z[fluxworks]-f[fabrication]")
ensure_item_group("fw-flux", "__FluxWorksAssets__/graphics/icons/items/flux.png", 64, "z[fluxworks]-g[flux]")

ensure_item_subgroup("fw-logistics-transport", "logistics", "a[fluxworks]-a[transport]")
ensure_item_subgroup("fw-logistics-inserters", "logistics", "a[fluxworks]-b[inserters]")
ensure_item_subgroup("fw-logistics-storage", "logistics", "a[fluxworks]-c[storage]")
ensure_item_subgroup("fw-logistics-fluid-handling", "logistics", "a[fluxworks]-d[fluid-handling]")
ensure_item_subgroup("fw-logistics-rail", "logistics", "a[fluxworks]-e[rail]")
ensure_item_subgroup("fw-logistics-power", "logistics", "a[fluxworks]-f[power]")
ensure_item_subgroup("fw-logistics-circuitry", "logistics", "a[fluxworks]-g[circuitry]")
ensure_item_subgroup("fw-logistics-robotics", "logistics", "a[fluxworks]-h[robotics]")
ensure_item_subgroup("fw-logistics-network", "logistics", "a[fluxworks]-i[network]")
ensure_item_subgroup("fw-production-extraction", "production", "z[fluxworks]-9[extraction]")
ensure_item_subgroup("fw-production-smelting", "production", "z[fluxworks]-a[smelting]")
ensure_item_subgroup("fw-production-assembly", "production", "z[fluxworks]-b[assembly]")
ensure_item_subgroup("fw-production-chemistry", "production", "z[fluxworks]-c[chemistry]")
ensure_item_subgroup("fw-production-specialized", "production", "z[fluxworks]-d[specialized]")
ensure_item_subgroup("fw-production-processing", "production", "z[fluxworks]-e[processing]")

ensure_item_subgroup("fw-science-packs", "fw-science", "z[fluxworks]-f[science]-a[packs]")
ensure_item_subgroup("fw-science-labs", "fw-science", "z[fluxworks]-f[science]-b[labs]")
ensure_item_subgroup("fw-science-facilities", "fw-science", "z[fluxworks]-f[science]-c[facilities]")
ensure_item_subgroup("fw-bioprocessing-machines", "fw-bioprocessing", "z[fluxworks]-g[bioprocessing]-a[machines]")
ensure_item_subgroup("fw-bioprocessing-products", "fw-bioprocessing", "z[fluxworks]-g[bioprocessing]-b[products]")
ensure_item_subgroup("fw-bioprocessing-processes", "fw-bioprocessing", "z[fluxworks]-g[bioprocessing]-c[processes]")
ensure_item_subgroup("fw-energy-generation", "fw-energy", "z[fluxworks]-h[energy]-a[generation]")
ensure_item_subgroup("fw-energy-storage", "fw-energy", "z[fluxworks]-h[energy]-b[storage]")
ensure_item_subgroup("fw-energy-reactors", "fw-energy", "z[fluxworks]-h[energy]-c[reactors]")
ensure_item_subgroup("fw-energy-fuels", "fw-energy", "z[fluxworks]-h[energy]-d[fuels]")
ensure_item_subgroup("fw-chemistry-machines", "fw-chemistry", "z[fluxworks]-i[chemistry]-a[machines]")
ensure_item_subgroup("fw-chemistry-feedstocks", "fw-chemistry", "z[fluxworks]-i[chemistry]-b[feedstocks]")
ensure_item_subgroup("fw-chemistry-polymers", "fw-chemistry", "z[fluxworks]-i[chemistry]-c[polymers]")
ensure_item_subgroup("fw-chemistry-reactives", "fw-chemistry", "z[fluxworks]-i[chemistry]-d[reactives]")
ensure_item_subgroup("fw-chemistry-fluids", "fw-chemistry", "z[fluxworks]-i[chemistry]-e[fluids]")
ensure_item_subgroup("fw-chemistry-petrochem", "fw-chemistry", "z[fluxworks]-i[chemistry]-f[petrochem]")
ensure_item_subgroup("fw-chemistry-advanced", "fw-chemistry", "z[fluxworks]-i[chemistry]-g[advanced]")
ensure_item_subgroup("fw-chemistry-barrels", "fw-chemistry", "z[fluxworks]-i[chemistry]-h[barrels]")
ensure_item_subgroup("fw-chemistry-materials", "fw-chemistry", "z[fluxworks]-i[chemistry]-i[materials]")
ensure_item_subgroup("fw-chemistry-processes", "fw-chemistry", "z[fluxworks]-i[chemistry]-j[processes]")
ensure_item_subgroup("fw-systems-machines", "fw-systems", "z[fluxworks]-j[systems]-a[machines]")
ensure_item_subgroup("fw-systems-control", "fw-systems", "z[fluxworks]-j[systems]-b[control]")
ensure_item_subgroup("fw-systems-instrumentation", "fw-systems", "z[fluxworks]-j[systems]-c[instrumentation]")
ensure_item_subgroup("fw-systems-infrastructure", "fw-systems", "z[fluxworks]-j[systems]-d[infrastructure]")
ensure_item_subgroup("fw-fabrication-machines", "fw-fabrication", "z[fluxworks]-k[fabrication]-a[machines]")
ensure_item_subgroup("fw-intermediate-structural", "fw-fabrication", "z[fluxworks]-k[fabrication]-b[structural]")
ensure_item_subgroup("fw-intermediate-electrical", "fw-fabrication", "z[fluxworks]-k[fabrication]-c[electrical]")
ensure_item_subgroup("fw-intermediate-precision", "fw-fabrication", "z[fluxworks]-k[fabrication]-d[precision]")
ensure_item_subgroup("fw-intermediate-ballistic", "fw-fabrication", "z[fluxworks]-k[fabrication]-e[ballistic]")
ensure_item_subgroup("fw-intermediate-aerospace", "fw-fabrication", "z[fluxworks]-k[fabrication]-f[aerospace]")
ensure_item_subgroup("fw-fabrication-components", "fw-fabrication", "z[fluxworks]-k[fabrication]-g[general]")
ensure_item_subgroup("fw-flux-machines", "fw-flux", "z[fluxworks]-l[flux]-a[machines]")
ensure_item_subgroup("fw-flux-resources", "fw-flux", "z[fluxworks]-l[flux]-b[resources]")
ensure_item_subgroup("fw-flux-systems", "fw-flux", "z[fluxworks]-l[flux]-c[systems]")
ensure_item_subgroup("fw-flux-purple", "fw-flux", "z[fluxworks]-l[flux]-d[purple]")
ensure_item_subgroup("fw-flux-yellow", "fw-flux", "z[fluxworks]-l[flux]-e[yellow]")
ensure_item_subgroup("fw-flux-red", "fw-flux", "z[fluxworks]-l[flux]-f[red]")
ensure_item_subgroup("fw-flux-green", "fw-flux", "z[fluxworks]-l[flux]-g[green]")
ensure_item_subgroup("fw-transmutation-upcycle", "fw-flux", "z[fluxworks]-l[flux]-h[transmutation]-a[upcycle]")
ensure_item_subgroup("fw-transmutation-downcycle", "fw-flux", "z[fluxworks]-l[flux]-i[transmutation]-b[downcycle]")
ensure_item_subgroup("fw-flux-condensing-core", "fw-flux", "z[fluxworks]-l[flux]-j[condensing]-a[core]")
ensure_item_subgroup("fw-flux-condensing-promethium", "fw-flux", "z[fluxworks]-l[flux]-k[condensing]-b[promethium]")
ensure_item_subgroup("fw-flux-exchange", "fw-flux", "z[fluxworks]-l[flux]-l[exchange]")
ensure_item_subgroup("fw-flux-origin-projects", "fw-flux", "z[fluxworks]-l[flux]-m[origin-projects]")

if organize_science then
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
    { "automation-science-pack", "a[packs]-a[automation]" },
    { "logistic-science-pack", "a[packs]-b[logistic]" },
    { "military-science-pack", "a[packs]-c[military]" },
    { "chemical-science-pack", "a[packs]-d[chemical]" },
    { "production-science-pack", "b[advanced]-a[production]" },
    { "utility-science-pack", "b[advanced]-b[utility]" },
    { "space-science-pack", "b[advanced]-c[space]" },
    { "metallurgic-science-pack", "c[planetary]-a[metallurgic]" },
    { "electromagnetic-science-pack", "c[planetary]-b[electromagnetic]" },
    { "agricultural-science-pack", "c[planetary]-c[agricultural]" },
    { "cryogenic-science-pack", "c[planetary]-d[cryogenic]" },
    { "promethium-science-pack", "c[planetary]-e[promethium]" },
    { "lab", "d[labs]-a[lab]" },
    { "biolab", "d[labs]-b[biolab]" },
  })
end

for _, name in pairs({
  "transport-belt",
  "fast-transport-belt",
  "express-transport-belt",
  "turbo-transport-belt",
  "underground-belt",
  "fast-underground-belt",
  "express-underground-belt",
  "turbo-underground-belt",
  "splitter",
  "fast-splitter",
  "express-splitter",
  "turbo-splitter",
  "fw-kr-loader",
  "fw-kr-fast-loader",
  "fw-kr-express-loader",
  "fw-kr-advanced-loader",
}) do
  move_item_and_recipe(name, "fw-logistics-transport")
end

for _, entry in pairs({
  { "transport-belt", "a[belts]-a[transport-belt]" },
  { "fast-transport-belt", "a[belts]-b[fast-transport-belt]" },
  { "express-transport-belt", "a[belts]-c[express-transport-belt]" },
  { "turbo-transport-belt", "a[belts]-d[turbo-transport-belt]" },
  { "underground-belt", "a[belts]-e[underground-belt]" },
  { "fast-underground-belt", "a[belts]-f[fast-underground-belt]" },
  { "express-underground-belt", "a[belts]-g[express-underground-belt]" },
  { "turbo-underground-belt", "a[belts]-h[turbo-underground-belt]" },
  { "splitter", "b[splitters]-a[splitter]" },
  { "fast-splitter", "b[splitters]-b[fast-splitter]" },
  { "express-splitter", "b[splitters]-c[express-splitter]" },
  { "turbo-splitter", "b[splitters]-d[turbo-splitter]" },
  { "fw-kr-loader", "b[splitters]-e[fw-kr-loader]" },
  { "fw-kr-fast-loader", "b[splitters]-f[fw-kr-fast-loader]" },
  { "fw-kr-express-loader", "b[splitters]-g[fw-kr-express-loader]" },
  { "fw-kr-advanced-loader", "b[splitters]-h[fw-kr-advanced-loader]" },
}) do
  set_order("item", entry[1], entry[2])
  set_order("recipe", entry[1], entry[2])
end

for _, name in pairs({
  "burner-inserter",
  "inserter",
  "long-handed-inserter",
  "fast-inserter",
  "filter-inserter",
  "bulk-inserter",
  "stack-inserter",
  "stack-filter-inserter",
}) do
  move_item_and_recipe(name, "fw-logistics-inserters")
end

for _, entry in pairs({
  { "burner-inserter", "a[inserters]-a[burner-inserter]" },
  { "inserter", "a[inserters]-b[inserter]" },
  { "long-handed-inserter", "a[inserters]-c[long-handed-inserter]" },
  { "fast-inserter", "a[inserters]-d[fast-inserter]" },
  { "filter-inserter", "a[inserters]-e[filter-inserter]" },
  { "bulk-inserter", "b[bulk]-a[bulk-inserter]" },
  { "stack-inserter", "b[bulk]-b[stack-inserter]" },
  { "stack-filter-inserter", "b[bulk]-c[stack-filter-inserter]" },
}) do
  set_order("item", entry[1], entry[2])
  set_order("recipe", entry[1], entry[2])
end

for _, name in pairs({
  "pipe",
  "pipe-to-ground",
  "pump",
  "offshore-pump",
}) do
  move_item_and_recipe(name, "fw-logistics-fluid-handling")
end

for _, entry in pairs({
  { "pipe", "a[pipes]-a[pipe]" },
  { "pipe-to-ground", "a[pipes]-b[pipe-to-ground]" },
  { "pump", "b[pumps]-a[pump]" },
  { "offshore-pump", "b[pumps]-b[offshore-pump]" },
}) do
  set_order("item", entry[1], entry[2])
  set_order("recipe", entry[1], entry[2])
end

for _, name in pairs({
  "rail",
  "locomotive",
  "cargo-wagon",
  "fluid-wagon",
  "artillery-wagon",
  "train-stop",
  "rail-signal",
  "rail-chain-signal",
  "rail-ramp",
  "rail-support",
}) do
  move_item_and_recipe(name, "fw-logistics-rail")
end

for _, entry in pairs({
  { "rail", "a[track]-a[rail]" },
  { "rail-ramp", "a[track]-b[rail-ramp]" },
  { "rail-support", "a[track]-c[rail-support]" },
  { "train-stop", "b[signals]-a[train-stop]" },
  { "rail-signal", "b[signals]-b[rail-signal]" },
  { "rail-chain-signal", "b[signals]-c[rail-chain-signal]" },
  { "locomotive", "c[trains]-a[locomotive]" },
  { "cargo-wagon", "c[trains]-b[cargo-wagon]" },
  { "fluid-wagon", "c[trains]-c[fluid-wagon]" },
  { "artillery-wagon", "c[trains]-d[artillery-wagon]" },
}) do
  set_order("item", entry[1], entry[2])
  set_order("recipe", entry[1], entry[2])
end

for _, name in pairs({
  "wooden-chest",
  "iron-chest",
  "steel-chest",
  "logistic-chest-passive-provider",
  "logistic-chest-active-provider",
  "logistic-chest-storage",
  "logistic-chest-buffer",
  "logistic-chest-requester",
  "storage-tank",
  "fw-phase-vault",
  "fw-spectral-reservoir",
  "fw-kr-strongbox",
  "fw-kr-passive-provider-strongbox",
  "fw-kr-active-provider-strongbox",
  "fw-kr-storage-strongbox",
  "fw-kr-buffer-strongbox",
  "fw-kr-requester-strongbox",
  "fw-kr-warehouse",
  "fw-kr-passive-provider-warehouse",
  "fw-kr-active-provider-warehouse",
  "fw-kr-storage-warehouse",
  "fw-kr-buffer-warehouse",
  "fw-kr-requester-warehouse",
  "fw-kr-big-storage-tank",
  "fw-kr-huge-storage-tank",
}) do
  move_item_and_recipe(name, "fw-logistics-storage")
end

for _, entry in pairs({
  { "wooden-chest", "a[solid-storage]-a[wooden-chest]" },
  { "iron-chest", "a[solid-storage]-b[iron-chest]" },
  { "steel-chest", "a[solid-storage]-c[steel-chest]" },
  { "logistic-chest-passive-provider", "a[solid-storage]-d[passive-provider]" },
  { "logistic-chest-active-provider", "a[solid-storage]-e[active-provider]" },
  { "logistic-chest-storage", "a[solid-storage]-f[storage]" },
  { "logistic-chest-buffer", "a[solid-storage]-g[buffer]" },
  { "logistic-chest-requester", "a[solid-storage]-h[requester]" },
  { "fw-kr-strongbox", "b[large-storage]-a[fw-kr-strongbox]" },
  { "fw-kr-warehouse", "b[large-storage]-b[fw-kr-warehouse]" },
  { "storage-tank", "b[large-storage]-c[storage-tank]" },
  { "fw-kr-big-storage-tank", "b[large-storage]-d[fw-kr-big-storage-tank]" },
  { "fw-kr-huge-storage-tank", "b[large-storage]-e[fw-kr-huge-storage-tank]" },
  { "fw-phase-vault", "b[large-storage]-f[phase-vault]" },
  { "fw-spectral-reservoir", "b[large-storage]-g[spectral-reservoir]" },
  { "fw-kr-passive-provider-strongbox", "c[logistic-strongboxes]-a[passive-provider]" },
  { "fw-kr-active-provider-strongbox", "c[logistic-strongboxes]-b[active-provider]" },
  { "fw-kr-storage-strongbox", "c[logistic-strongboxes]-c[storage]" },
  { "fw-kr-buffer-strongbox", "c[logistic-strongboxes]-d[buffer]" },
  { "fw-kr-requester-strongbox", "c[logistic-strongboxes]-e[requester]" },
  { "fw-kr-passive-provider-warehouse", "d[logistic-warehouses]-a[passive-provider]" },
  { "fw-kr-active-provider-warehouse", "d[logistic-warehouses]-b[active-provider]" },
  { "fw-kr-storage-warehouse", "d[logistic-warehouses]-c[storage]" },
  { "fw-kr-buffer-warehouse", "d[logistic-warehouses]-d[buffer]" },
  { "fw-kr-requester-warehouse", "d[logistic-warehouses]-e[requester]" },
}) do
  set_order("item", entry[1], entry[2])
  set_order("recipe", entry[1], entry[2])
end

for _, name in pairs({
  "small-electric-pole",
  "medium-electric-pole",
  "big-electric-pole",
  "substation",
}) do
  move_item_and_recipe(name, "fw-logistics-power")
end

for _, entry in pairs({
  { "small-electric-pole", "a[power-distribution]-a[small-electric-pole]" },
  { "medium-electric-pole", "a[power-distribution]-b[medium-electric-pole]" },
  { "big-electric-pole", "a[power-distribution]-c[big-electric-pole]" },
  { "substation", "a[power-distribution]-d[substation]" },
}) do
  set_order("item", entry[1], entry[2])
  set_order("recipe", entry[1], entry[2])
end

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

for _, entry in pairs({
  { "small-lamp", "a[signals]-a[small-lamp]" },
  { "red-wire", "a[signals]-b[red-wire]" },
  { "green-wire", "a[signals]-c[green-wire]" },
  { "constant-combinator", "b[combinators]-a[constant-combinator]" },
  { "arithmetic-combinator", "b[combinators]-b[arithmetic-combinator]" },
  { "decider-combinator", "b[combinators]-c[decider-combinator]" },
  { "selector-combinator", "b[combinators]-d[selector-combinator]" },
  { "power-switch", "c[logic]-a[power-switch]" },
  { "programmable-speaker", "c[logic]-b[programmable-speaker]" },
  { "display-panel", "c[logic]-c[display-panel]" },
}) do
  set_order("item", entry[1], entry[2])
  set_order("recipe", entry[1], entry[2])
end

for _, name in pairs({
  "fw-rift-exchange-gate",
  "fw-rift-exchange-fluid-gate",
}) do
  move_item_and_recipe(name, "fw-flux-exchange")
end

for _, entry in pairs({
  { "fw-rift-exchange-gate", "e[rift-logistics]-a[exchange-gate]" },
  { "fw-rift-exchange-fluid-gate", "e[rift-logistics]-b[exchange-fluid-gate]" },
}) do
  set_order("item", entry[1], entry[2])
  set_order("recipe", entry[1], entry[2])
end

move_item_and_recipe("fw-origin-singularity", "fw-flux-origin-projects")
set_order("item", "fw-origin-singularity", "z[origin]-z[origin-singularity]")
set_order("recipe", "fw-origin-singularity", "z[origin]-z[origin-singularity]")

for _, name in pairs({
  "burner-mining-drill",
  "electric-mining-drill",
  "big-mining-drill",
  "pumpjack",
  "agricultural-tower",
  "fw-flux-quarry",
  "fw-flux-harvester",
}) do
  move_item_and_recipe(name, "fw-production-extraction")
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
  move_item_and_recipe(name, "fw-production-smelting")
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
  "assembling-machine-1",
  "assembling-machine-2",
  "assembling-machine-3",
  "electromagnetic-plant",
  "cryogenic-plant",
  "fw-synthesis-plant",
  "fw-flux-condenser",
  "fw-origin-forge",
}) do
  move_item_and_recipe(name, "fw-production-assembly")
end

for _, entry in pairs({
  { "assembling-machine-1", "a[assembly]-a[assembling-machine-1]" },
  { "assembling-machine-2", "a[assembly]-b[assembling-machine-2]" },
  { "assembling-machine-3", "a[assembly]-c[assembling-machine-3]" },
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
  move_item_and_recipe(name, "fw-production-chemistry")
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
  move_item_and_recipe(name, "fw-production-specialized")
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

if organize_bioprocessing then
  for _, name in pairs({
    "agricultural-tower",
    "biochamber",
  }) do
    move_item_and_recipe(name, "fw-bioprocessing-machines")
  end

  for _, name in pairs({
  "yumako",
  "jellynut",
  "yumako-mash",
  "jelly",
  "yumako-seed",
  "jellynut-seed",
  "tree-seed",
  "nutrients",
  "bioflux",
  "copper-bacteria",
  "iron-bacteria",
  "spoilage",
  "biter-egg",
  "pentapod-egg",
  "raw-fish",
  "fw-nutrient-bed",
  "fw-spore-filter",
  "fw-gleba-spore-resin",
  "artificial-yumako-soil",
  "overgrowth-yumako-soil",
  "artificial-jellynut-soil",
  "overgrowth-jellynut-soil",
  }) do
    set_subgroup("item", name, "fw-bioprocessing-products")
  end

  for _, name in pairs({
  "yumako-processing",
  "jellynut-processing",
  "copper-bacteria",
  "copper-bacteria-cultivation",
  "iron-bacteria",
  "iron-bacteria-cultivation",
  "nutrients-from-spoilage",
  "nutrients-from-yumako-mash",
  "nutrients-from-bioflux",
  "nutrients-from-fish",
  "nutrients-from-biter-egg",
  "pentapod-egg",
  "bioflux",
  "bioplastic",
  "biosulfur",
  "biolubricant",
  "burnt-spoilage",
  "biter-egg",
  "fish-breeding",
  "wood-processing",
  "artificial-yumako-soil",
  "overgrowth-yumako-soil",
  "artificial-jellynut-soil",
  "overgrowth-jellynut-soil",
  "fw-gleba-spore-resin",
  "fw-green-flux-bioflux-cultivation",
  "fw-green-flux-biolubricant-bloom",
  }) do
    move_recipe(name, "fw-bioprocessing-processes")
  end

  set_orders({ "item", "recipe" }, {
    { "agricultural-tower", "a[machines]-a[agricultural-tower]" },
    { "biochamber", "a[machines]-b[biochamber]" },
  })

  set_orders({ "item" }, {
    { "yumako", "a[produce]-a[yumako]" },
    { "jellynut", "a[produce]-b[jellynut]" },
    { "yumako-mash", "b[processed]-a[yumako-mash]" },
    { "jelly", "b[processed]-b[jelly]" },
    { "yumako-seed", "c[seeds]-a[yumako-seed]" },
    { "jellynut-seed", "c[seeds]-b[jellynut-seed]" },
    { "tree-seed", "c[seeds]-c[tree-seed]" },
    { "artificial-yumako-soil", "d[soil]-a[artificial-yumako-soil]" },
    { "overgrowth-yumako-soil", "d[soil]-b[overgrowth-yumako-soil]" },
    { "artificial-jellynut-soil", "d[soil]-c[artificial-jellynut-soil]" },
    { "overgrowth-jellynut-soil", "d[soil]-d[overgrowth-jellynut-soil]" },
    { "nutrients", "e[biomass]-a[nutrients]" },
    { "bioflux", "e[biomass]-b[bioflux]" },
    { "spoilage", "e[biomass]-c[spoilage]" },
    { "raw-fish", "e[biomass]-d[raw-fish]" },
    { "fw-nutrient-bed", "f[substrates]-a[nutrient-bed]" },
    { "fw-spore-filter", "f[substrates]-b[spore-filter]" },
    { "fw-gleba-spore-resin", "f[substrates]-c[gleba-spore-resin]" },
    { "copper-bacteria", "g[cultures]-a[copper-bacteria]" },
    { "iron-bacteria", "g[cultures]-b[iron-bacteria]" },
    { "biter-egg", "g[cultures]-c[biter-egg]" },
    { "pentapod-egg", "g[cultures]-d[pentapod-egg]" },
  })

  set_orders({ "recipe" }, {
    { "yumako-processing", "a[produce]-a[yumako-processing]" },
    { "jellynut-processing", "a[produce]-b[jellynut-processing]" },
    { "nutrients-from-yumako-mash", "b[nutrients]-a[from-yumako]" },
    { "nutrients-from-bioflux", "b[nutrients]-b[from-bioflux]" },
    { "nutrients-from-spoilage", "b[nutrients]-c[from-spoilage]" },
    { "nutrients-from-fish", "b[nutrients]-d[from-fish]" },
    { "nutrients-from-biter-egg", "b[nutrients]-e[from-biter-egg]" },
    { "bioflux", "c[refining]-a[bioflux]" },
    { "copper-bacteria", "d[cultures]-a[copper-bacteria]" },
    { "copper-bacteria-cultivation", "d[cultures]-b[copper-bacteria-cultivation]" },
    { "iron-bacteria", "d[cultures]-c[iron-bacteria]" },
    { "iron-bacteria-cultivation", "d[cultures]-d[iron-bacteria-cultivation]" },
    { "biter-egg", "e[fauna]-a[biter-egg]" },
    { "pentapod-egg", "e[fauna]-b[pentapod-egg]" },
    { "fish-breeding", "e[fauna]-c[fish-breeding]" },
    { "wood-processing", "f[growth]-a[wood-processing]" },
    { "artificial-yumako-soil", "f[growth]-b[artificial-yumako-soil]" },
    { "overgrowth-yumako-soil", "f[growth]-c[overgrowth-yumako-soil]" },
    { "artificial-jellynut-soil", "f[growth]-d[artificial-jellynut-soil]" },
    { "overgrowth-jellynut-soil", "f[growth]-e[overgrowth-jellynut-soil]" },
    { "bioplastic", "g[materials]-a[bioplastic]" },
    { "biosulfur", "g[materials]-b[biosulfur]" },
    { "biolubricant", "g[materials]-c[biolubricant]" },
    { "fw-gleba-spore-resin", "g[materials]-d[gleba-spore-resin]" },
    { "burnt-spoilage", "h[waste]-a[burnt-spoilage]" },
    { "fw-green-flux-bioflux-cultivation", "i[flux-culture]-a[bioflux-cultivation]" },
    { "fw-green-flux-biolubricant-bloom", "i[flux-culture]-b[biolubricant-bloom]" },
  })
end

if organize_energy then
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
    "fw-reactor-instrument-cluster",
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
    { "boiler", "a[steam]-a[boiler]" },
    { "steam-engine", "a[steam]-b[steam-engine]" },
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
    { "centrifuge", "a[reactors]-a[centrifuge]" },
    { "fw-atomic-enricher", "a[reactors]-b[atomic-enricher]" },
    { "fw-isotope-matrix", "b[core-parts]-a[isotope-matrix]" },
    { "fw-moderator-lattice", "b[core-parts]-b[moderator-lattice]" },
    { "fw-control-rod-assembly", "b[core-parts]-c[control-rod-assembly]" },
    { "fw-reactor-coolant-cartridge", "c[control]-a[reactor-coolant-cartridge]" },
    { "fw-reactor-dopant", "c[control]-b[reactor-dopant]" },
    { "fw-reactor-instrument-cluster", "c[control]-c[reactor-instrument-cluster]" },
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

if organize_chemistry then
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
    "fw-rubber-sheet",
    "plastic-bar",
    "fw-polymer-binder",
    "fw-chlorinated-binder-stock",
    "fw-elastomer-matrix",
  }) do
    set_subgroup("item", name, "fw-chemistry-polymers")
  end

  for _, name in pairs({
    "explosives",
    "battery",
    "fw-reactive-column",
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
    { "plastic-bar", "b[polymers]-b[plastic]" },
    { "fw-rubber-sheet", "b[polymers]-c[rubber-sheet]" },
    { "fw-polymer-binder", "b[polymers]-d[polymer-binder]" },
    { "fw-chlorinated-binder-stock", "b[polymers]-e[chlorinated-binder-stock]" },
    { "fw-elastomer-matrix", "b[polymers]-f[elastomer-matrix]" },
    { "explosives", "c[energetics]-a[explosives]" },
    { "battery", "c[energetics]-b[battery]" },
    { "fw-reactive-column", "c[energetics]-c[reactive-column]" },
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
    { "fw-sulfur-bonding", "b[polymers]-c[sulfur-bonding]" },
    { "fw-rubber-vulcanization", "b[polymers]-d[rubber-vulcanization]" },
    { "fw-rubber-sheet", "b[polymers]-e[rubber-sheet]" },
    { "plastic-bar", "b[polymers]-f[plastic-bar]" },
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

if organize_systems then
  for _, name in pairs({
    "fw-signal-conduit",
    "fw-power-regulator",
    "fw-field-winding",
    "fw-flow-regulator",
    "fw-logic-matrix",
    "fw-servo-valve",
    "fw-hydraulic-manifold",
    "fw-hydraulic-core",
    "fw-quantum-spindle",
  }) do
    move_item_and_recipe(name, "fw-systems-control")
  end

  for _, name in pairs({
    "fw-lens-array",
    "fw-sensor-diode",
    "fw-sensor-package",
    "fw-memory-die",
    "fw-transformer-core",
    "fw-em-core",
  }) do
    move_item_and_recipe(name, "fw-systems-instrumentation")
  end

  for _, name in pairs({
    "small-electric-pole",
    "medium-electric-pole",
    "big-electric-pole",
    "substation",
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
    "construction-robot",
    "logistic-robot",
    "roboport",
    "radar",
    "beacon",
    "remnant-beacon",
  }) do
    move_item_and_recipe(name, "fw-systems-infrastructure")
  end

  set_orders({ "item", "recipe" }, {
    { "fw-signal-conduit", "a[control]-a[signal-conduit]" },
    { "fw-power-regulator", "a[control]-b[power-regulator]" },
    { "fw-field-winding", "a[control]-c[field-winding]" },
    { "fw-flow-regulator", "b[fluid-control]-a[flow-regulator]" },
    { "fw-servo-valve", "b[fluid-control]-b[servo-valve]" },
    { "fw-hydraulic-manifold", "b[fluid-control]-c[hydraulic-manifold]" },
    { "fw-hydraulic-core", "b[fluid-control]-d[hydraulic-core]" },
    { "fw-logic-matrix", "c[logic]-a[logic-matrix]" },
    { "fw-quantum-spindle", "c[logic]-b[quantum-spindle]" },
  })

  set_orders({ "item", "recipe" }, {
    { "fw-lens-array", "a[sensors]-a[lens-array]" },
    { "fw-sensor-diode", "a[sensors]-b[sensor-diode]" },
    { "fw-sensor-package", "a[sensors]-c[sensor-package]" },
    { "fw-transformer-core", "b[field-hardware]-a[transformer-core]" },
    { "fw-em-core", "b[field-hardware]-b[em-core]" },
    { "fw-memory-die", "c[logic-media]-a[memory-die]" },
  })

  set_orders({ "item", "recipe" }, {
    { "small-electric-pole", "a[power-grid]-a[small-electric-pole]" },
    { "medium-electric-pole", "a[power-grid]-b[medium-electric-pole]" },
    { "big-electric-pole", "a[power-grid]-c[big-electric-pole]" },
    { "substation", "a[power-grid]-d[substation]" },
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
    { "construction-robot", "e[robotics]-a[construction-robot]" },
    { "logistic-robot", "e[robotics]-b[logistic-robot]" },
    { "roboport", "e[robotics]-c[roboport]" },
    { "radar", "f[sensors]-a[radar]" },
    { "beacon", "f[sensors]-b[beacon]" },
    { "remnant-beacon", "f[sensors]-c[remnant-beacon]" },
  })
end

if organize_flux then
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

if organize_fabrication then
  for _, name in pairs({
    "fw-fired-ceramic",
    "fw-ceramic-casing",
    "fw-pressure-housing",
    "fw-foundry-lining",
    "fw-smelter-array",
    "fw-reinforced-seal",
    "fw-hydraulic-actuator",
    "fw-radioactive-scrap",
  }) do
    move_item_and_recipe(name, "fw-intermediate-structural")
  end

  for _, entry in pairs({
    { "fw-fired-ceramic", "a[ceramics]-a[fired-ceramic]" },
    { "fw-ceramic-casing", "a[ceramics]-b[ceramic-casing]" },
    { "fw-pressure-housing", "b[housings]-a[pressure-housing]" },
    { "fw-foundry-lining", "b[housings]-b[foundry-lining]" },
    { "fw-smelter-array", "b[housings]-c[smelter-array]" },
    { "fw-reinforced-seal", "c[hydraulics]-a[reinforced-seal]" },
    { "fw-hydraulic-actuator", "c[hydraulics]-b[hydraulic-actuator]" },
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
  }) do
    move_recipe(entry[1], "fw-fabrication-components")
    set_order("recipe", entry[1], entry[2])
  end
end

-- Orbital salvage parts read better beside the Space Age platform chain
-- than inside FluxWorks fabrication components.
move_item_and_recipe("fw-rocket-avionics", "space-material")
move_item_and_recipe("fw-rocket-heatshield", "space-material")
move_item_and_recipe("fw-rocket-engine", "space-material")
move_item_and_recipe("incomplete-rocket-part", "space-material")
move_item_and_recipe("remnant-beacon", "fw-systems-infrastructure")

for _, entry in pairs({
  { "casting-pipe", "c[foundry-casting]-a[casting-pipe]" },
  { "casting-pipe-to-ground", "c[foundry-casting]-b[casting-pipe-to-ground]" },
}) do
  move_recipe(entry[1], "fw-production-smelting")
  set_order("recipe", entry[1], entry[2])
end

for _, name in pairs({
  "fw-loader-frame",
  "fw-pressure-vessel",
  "fw-logistic-relay",
  "fw-bulk-router",
}) do
  move_item_and_recipe(name, "fw-fabrication-components")
end

for _, entry in pairs({
  { "fw-loader-frame", "e[branch]-a[loader-frame]" },
  { "fw-pressure-vessel", "e[branch]-b[pressure-vessel]" },
  { "fw-logistic-relay", "e[branch]-c[logistic-relay]" },
  { "fw-bulk-router", "e[branch]-d[bulk-router]" },
}) do
  set_order("item", entry[1], entry[2])
  set_order("recipe", entry[1], entry[2])
end

for _, name in pairs({
  "fw-polymer-binder",
  "fw-chlorinated-binder-stock",
  "fw-elastomer-matrix",
}) do
  move_item_and_recipe(name, "fw-chemistry-polymers")
end

for _, entry in pairs({
  { "fw-polymer-binder", "d[synthetics]-a[polymer-binder]" },
  { "fw-chlorinated-binder-stock", "d[synthetics]-b[chlorinated-binder-stock]" },
  { "fw-elastomer-matrix", "d[synthetics]-c[elastomer-matrix]" },
}) do
  set_order("item", entry[1], entry[2])
  set_order("recipe", entry[1], entry[2])
end

if organize_flux then
  for _, name in pairs({
  "fw-rift-coupler",
  }) do
    move_item_and_recipe(name, "fw-flux-exchange")
  end

  for _, name in pairs({
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
  "fw-condensed-flux-matrix",
  "fw-flux-resonance-cell",
  "fw-flux-phase-manifold",
  "fw-arc-insulator-vitrification",
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
  "fw-promethium-primer",
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
  move_recipe("fw-promethium-primer", "fw-flux-condensing-promethium")
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
    { "fw-arc-insulator-vitrification", "e[processing]-a[arc-insulator-vitrification]" },
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

for recipe_name, recipe in pairs(data.raw.recipe or {}) do
  if string.sub(recipe_name, 1, 3) == "fw-" and not recipe.subgroup then
    recipe.subgroup = item_subgroup(recipe_main_item_name(recipe))
  end
end
