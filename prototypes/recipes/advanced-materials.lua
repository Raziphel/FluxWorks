local icon_path = "__FluxWorksAssets__/graphics/icons/items/"

data:extend({
  { type = "recipe-category", name = "basic-crushing" },
})

data:extend({
  {
    type = "recipe",
    name = "silica",
    category = "basic-crushing",
    enabled = false,
    energy_required = 3.2,
    allow_productivity = true,
    ingredients = { { type = "item", name = "stone", amount = 2 } },
    results = { { type = "item", name = "silica", amount = 5 } },
  },
  {
    type = "recipe",
    name = "silicon",
    category = "smelting",
    enabled = false,
    energy_required = 3.2,
    allow_productivity = true,
    ingredients = { { type = "item", name = "silica", amount = 10 } },
    results = { { type = "item", name = "silicon", amount = 1 } },
  },
  {
    type = "recipe",
    name = "silicon-wafer",
    category = "crafting-with-fluid",
    subgroup = "intermediate-product",
    enabled = false,
    energy_required = 2,
    allow_productivity = true,
    ingredients = {
      { type = "item", name = "silicon", amount = 2 },
      { type = "fluid", name = "sulfuric-acid", amount = 5 },
    },
    results = { { type = "item", name = "silicon-wafer", amount = 3 } },
  },
  {
    type = "recipe",
    name = "graphite",
    category = "basic-crushing",
    enabled = false,
    allow_productivity = true,
    energy_required = 0.5,
    ingredients = { { type = "item", name = "flake-graphite", amount = 1 } },
    results = { { type = "item", name = "graphite", amount = 1 } },
  },
  {
    type = "recipe",
    name = "diamond-processing",
    icons = {
      { icon = icon_path .. "diamond.png", icon_size = 128 },
      { icon = icon_path .. "rough-diamond.png", icon_size = 128, scale = 0.25, shift = { -8, -8 } },
    },
    category = "advanced-crafting",
    subgroup = "raw-material",
    enabled = false,
    allow_productivity = true,
    energy_required = 20,
    ingredients = { { type = "item", name = "rough-diamond", amount = 1 } },
    results = {
      { type = "item", name = "diamond", amount = 1, probability = 0.8 },
      { type = "item", name = "stone", amount = 1, probability = 0.2 },
    },
  },
  {
    type = "recipe",
    name = "synthetic-diamond",
    icons = {
      { icon = icon_path .. "diamond.png", icon_size = 128 },
      { icon = icon_path .. "graphite.png", icon_size = 128, scale = 0.25, shift = { -8, -8 } },
    },
    category = "smelting",
    enabled = false,
    allow_productivity = true,
    energy_required = 20,
    ingredients = { { type = "item", name = "graphite", amount = 20 } },
    results = { { type = "item", name = "diamond", amount = 1 } },
  },
})
