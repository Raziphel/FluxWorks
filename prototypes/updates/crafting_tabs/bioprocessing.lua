return function(Router)
  local set_subgroup = Router.set_subgroup
  local set_order = Router.set_order
  local set_orders = Router.set_orders
  local purge_prototype = Router.purge
  local move_item_and_recipe = Router.move_item_and_recipe
  local move_item = Router.move_item
  local move_recipe = Router.move_recipe

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
    { "fw-gleba-spore-resin", "f[substrates]-b[gleba-spore-resin]" },
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

  move_item("fw-nutrient-bed", "fw-bioprocessing-products")
  move_item("fw-gleba-spore-resin", "fw-bioprocessing-products")
  move_recipe("fw-nutrient-bed", "fw-bioprocessing-processes")
  move_recipe("fw-gleba-spore-resin", "fw-bioprocessing-processes")

  set_order("item", "fw-nutrient-bed", "g[materials]-d[nutrient-bed]")
  set_order("item", "fw-gleba-spore-resin", "g[materials]-e[gleba-spore-resin]")
  set_order("recipe", "fw-nutrient-bed", "g[materials]-d[nutrient-bed]")
  set_order("recipe", "fw-gleba-spore-resin", "g[materials]-e[gleba-spore-resin]")
end
