local Startup = require("prototypes.lib.startup-settings")

if not Startup.enabled("fw-enable-crafting-tab-reorganization", true) then
  return
end

local organize_science = Startup.enabled("fw-tab-science-organization", true)
local organize_bioprocessing = Startup.enabled("fw-tab-bioprocessing-organization", true)
local organize_chemistry = Startup.enabled("fw-tab-chemistry-organization", true)
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

local function set_many_subgroups(prototype_types, name, subgroup)
  for _, prototype_type in pairs(prototype_types) do
    set_subgroup(prototype_type, name, subgroup)
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

ensure_item_group("fw-science", "__base__/graphics/icons/lab.png", 64, "c-a[science]")
ensure_item_group("fw-bioprocessing", "__space-age__/graphics/icons/biochamber.png", 64, "c-b[bioprocessing]")
ensure_item_group("fw-flux", "__FluxWorksAssets__/graphics/icons/items/flux.png", 64, "c-c[flux]")
ensure_item_group("fw-chemistry", "__FluxWorksAssets__/graphics/resources/fluids/chlorine.png", 128, "c-d[chemistry]")
ensure_item_group("fw-fabrication", "__FluxWorksAssets__/graphics/icons/items/fw-foundry-lining.png", 1024, "ca[fabrication]")

ensure_item_subgroup("fw-science-packs", "fw-science", "a[science-packs]")
ensure_item_subgroup("fw-science-labs", "fw-science", "b[labs]")
ensure_item_subgroup("fw-bioprocessing-machines", "fw-bioprocessing", "a[machines]")
ensure_item_subgroup("fw-bioprocessing-products", "fw-bioprocessing", "b[products]")
ensure_item_subgroup("fw-bioprocessing-processes", "fw-bioprocessing", "c[processes]")
ensure_item_subgroup("fw-flux-machines", "fw-flux", "a[machines]")
ensure_item_subgroup("fw-flux-resources", "fw-flux", "b[resources]")
ensure_item_subgroup("fw-flux-systems", "fw-flux", "c[systems]")
ensure_item_subgroup("fw-flux-purple", "fw-flux", "d[purple]")
ensure_item_subgroup("fw-flux-yellow", "fw-flux", "e[yellow]")
ensure_item_subgroup("fw-flux-red", "fw-flux", "f[red]")
ensure_item_subgroup("fw-flux-green", "fw-flux", "g[green]")
ensure_item_subgroup("fw-transmutation-upcycle", "fw-flux", "h[transmutation]-a[upcycle]")
ensure_item_subgroup("fw-transmutation-downcycle", "fw-flux", "i[transmutation]-b[downcycle]")
ensure_item_subgroup("fw-flux-condensing-core", "fw-flux", "j[condensing]-a[core]")
ensure_item_subgroup("fw-flux-condensing-promethium", "fw-flux", "k[condensing]-b[promethium]")
ensure_item_subgroup("fw-flux-exchange", "fw-flux", "l[exchange]")
ensure_item_subgroup("fw-chemistry-machines", "fw-chemistry", "a[machines]")
ensure_item_subgroup("fw-chemistry-fluids", "fw-chemistry", "b[fluids]")
ensure_item_subgroup("fw-chemistry-materials", "fw-chemistry", "c[materials]")
ensure_item_subgroup("fw-chemistry-processes", "fw-chemistry", "d[processes]")
ensure_item_subgroup("fw-fabrication-machines", "fw-fabrication", "a[machines]")
ensure_item_subgroup("fw-intermediate-structural", "fw-fabrication", "b[structural]")
ensure_item_subgroup("fw-intermediate-electrical", "fw-fabrication", "c[electrical]")
ensure_item_subgroup("fw-intermediate-precision", "fw-fabrication", "d[precision]")
ensure_item_subgroup("fw-intermediate-ballistic", "fw-fabrication", "e[ballistic]")
ensure_item_subgroup("fw-intermediate-aerospace", "fw-fabrication", "f[aerospace]")
ensure_item_subgroup("fw-fabrication-components", "fw-fabrication", "y[components]")

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
  }) do
    move_recipe(name, "fw-bioprocessing-processes")
  end
end

if organize_chemistry then
  for _, name in pairs({
  "fw-salt",
  "fw-carbon",
  "fw-resin",
  "fw-rubber-sheet",
  "sulfur",
  "plastic-bar",
  "explosives",
  "battery",
  "solid-fuel",
  "rocket-fuel",
  "coal",
  "carbon",
  }) do
    set_subgroup("item", name, "fw-chemistry-materials")
  end

  for _, name in pairs({
  "fw-chlorine",
  "fw-latex",
  "fw-blasting-gel",
  "fw-napalm",
  "sulfuric-acid",
  "lubricant",
  }) do
    set_subgroup("fluid", name, "fw-chemistry-fluids")
  end

  for _, name in pairs({
  "chemical-plant",
  "oil-refinery",
  }) do
    move_item_and_recipe(name, "fw-chemistry-machines")
  end

  for _, name in pairs({
  "fw-salt-from-water",
  "fw-chlorine",
  "fw-carbon-refining",
  "fw-carbon-washing",
  "fw-salt-brine-clarification",
  "fw-silica-beneficiation",
  "fw-carbonic-washing",
  "fw-chlorine-pressurization",
  "fw-latex-polymerization",
  "fw-resin-polymerization",
  "fw-sulfur-bonding",
  "fw-acid-synthesis",
  "fw-rubber-vulcanization",
  "fw-rubber-sheet",
  "fw-gunpowder",
  "fw-gunpowder-early",
  "plastic-bar",
  "sulfur",
  "sulfuric-acid",
  "explosives",
  "battery",
  "fw-blasting-gel",
  "fw-reactive-slurry",
  "fw-battery-electrolyte",
  "fw-napalm",
  "flamethrower-ammo",
  "solid-fuel-from-light-oil",
  "solid-fuel-from-petroleum-gas",
  "solid-fuel-from-heavy-oil",
  "lubricant",
  "heavy-oil-cracking",
  "light-oil-cracking",
  "basic-oil-processing",
  "advanced-oil-processing",
  "coal-liquefaction",
  "simple-coal-liquefaction",
  "ice-melting",
  "acid-neutralisation",
  "steam-condensation",
  "carbon",
  "coal-synthesis",
  "thruster-fuel",
  "thruster-oxidizer",
  "advanced-thruster-fuel",
  "advanced-thruster-oxidizer",
  "lithium",
  "ammoniacal-solution-separation",
  "solid-fuel-from-ammonia",
  "ammonia-rocket-fuel",
  "holmium-solution",
  "fw-spectral-coolant-blend",
  }) do
    move_recipe(name, "fw-chemistry-processes")
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
    move_item_and_recipe(name, "fw-chemistry-fluids")
  end
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

  for _, name in pairs({
  "fw-flux-quarry",
  "fw-flux-harvester",
  "fw-flux-condenser",
  }) do
    move_item_and_recipe(name, "fw-flux-machines")
  end
end

if organize_fabrication then
  for _, name in pairs({
  "fw-arc-foundry",
  "fw-synthesis-plant",
  }) do
    move_item_and_recipe(name, "fw-fabrication-machines")
  end
end

-- Orbital salvage parts read better beside the Space Age platform chain
-- than inside FluxWorks fabrication components.
move_item_and_recipe("fw-rocket-avionics", "space-material")
move_item_and_recipe("fw-rocket-heatshield", "space-material")
move_item_and_recipe("fw-rocket-engine", "space-material")
move_item_and_recipe("incomplete-rocket-part", "space-material")
move_item_and_recipe("remnant-beacon", "space-platform")

if organize_flux then
  for _, name in pairs({
  "fw-rift-coupler",
  "fw-phase-vault",
  "fw-spectral-reservoir",
  "fw-rift-exchange-gate",
  }) do
    move_item_and_recipe(name, "fw-flux-exchange")
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
  move_recipe("fw-flux-asteroid-refining", "fw-flux-systems")
  move_recipe("fw-flux-metallic-synthesis", "fw-flux-systems")
  move_recipe("fw-rift-seed-crystallization", "fw-flux-systems")
  move_recipe("fw-condensed-flux-matrix", "fw-flux-condensing-core")
  move_recipe("fw-flux-phase-manifold", "fw-flux-condensing-core")
  move_recipe("fw-promethium-primer", "fw-flux-condensing-promethium")
  move_recipe("fw-promethium-matrix", "fw-flux-condensing-promethium")
  move_recipe("fw-rift-stabilizer", "fw-flux-condensing-promethium")

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
