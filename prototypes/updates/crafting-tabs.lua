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

ensure_item_group("fw-science", "__base__/graphics/icons/lab.png", 64, "c-a[science]")
ensure_item_group("fw-bioprocessing", "__space-age__/graphics/icons/biochamber.png", 64, "c-b[bioprocessing]")
ensure_item_group("fw-flux", "__FluxWorksAssets__/graphics/icons/items/flux.png", 64, "c-c[flux]")

ensure_item_subgroup("fw-science-packs", "fw-science", "a[science-packs]")
ensure_item_subgroup("fw-science-labs", "fw-science", "b[labs]")
ensure_item_subgroup("fw-bioprocessing-machines", "fw-bioprocessing", "a[machines]")
ensure_item_subgroup("fw-bioprocessing-products", "fw-bioprocessing", "b[products]")
ensure_item_subgroup("fw-bioprocessing-processes", "fw-bioprocessing", "c[processes]")
ensure_item_subgroup("fw-flux-resources", "fw-flux", "a[resources]")
ensure_item_subgroup("fw-flux-fluids", "fw-flux", "b[fluids]")
ensure_item_subgroup("fw-flux-machines", "fw-flux", "c[machines]")
ensure_item_subgroup("fw-flux-systems", "fw-flux", "d[systems]")
ensure_item_subgroup("fw-transmutation-upcycle", "fw-flux", "e[transmutation]-a[upcycle]")
ensure_item_subgroup("fw-transmutation-downcycle", "fw-flux", "e[transmutation]-b[downcycle]")
ensure_item_subgroup("fw-flux-exchange", "fw-flux", "f[exchange]")

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

for _, name in pairs({
  "fw-crystalised-flux",
  "fw-flux-asteroid-chunk",
}) do
  set_subgroup("item", name, "fw-flux-resources")
end

for _, name in pairs({
  "fw-purple-flux",
  "fw-yellow-flux",
  "fw-red-flux",
  "fw-green-flux",
}) do
  set_subgroup("fluid", name, "fw-flux-fluids")
  move_recipe(name, "fw-flux-fluids")
end
move_recipe("fw-purple-flux-reclamation", "fw-flux-fluids")
move_item_and_recipe("fw-purple-flux-barrel", "fw-flux-fluids")
move_recipe("empty-fw-purple-flux-barrel", "fw-flux-fluids")

for _, name in pairs({
  "fw-flux-quarry",
  "fw-flux-condenser",
}) do
  move_item_and_recipe(name, "fw-flux-machines")
end

for _, name in pairs({
  "fw-flux-catalyst",
  "fw-stabilized-flux-crystal",
  "fw-flux-lattice",
  "fw-condensed-flux-matrix",
  "fw-flux-resonance-cell",
  "fw-flux-phase-manifold",
}) do
  move_item_and_recipe(name, "fw-flux-systems")
end
move_recipe("fw-flux-asteroid-refining", "fw-flux-systems")
move_recipe("fw-rift-seed-crystallization", "fw-flux-systems")

for recipe_name, recipe in pairs(data.raw.recipe or {}) do
  if string.sub(recipe_name, 1, 22) == "fw-exchange-from-flux-" then
    recipe.subgroup = "fw-flux-exchange"
  elseif string.sub(recipe_name, 1, 3) == "fw-" and string.find(recipe_name, "flux", 1, true) then
    recipe.subgroup = recipe.subgroup or "fw-flux-systems"
  end
end
