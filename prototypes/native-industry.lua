-- FluxWorks-owned sand and glass processing for the core material progression.
if not (data.raw.item and data.raw.item.sand) then
  data:extend({
    {
      type = "item",
      name = "sand",
      icon = "__base__/graphics/icons/stone.png",
      icon_size = 64,
      subgroup = "raw-material",
      order = "a[stone]-b[sand]",
      stack_size = 200,
    },
    {
      type = "recipe",
      name = "sand",
      category = "basic-crushing",
      enabled = false,
      energy_required = 1,
      ingredients = { { type = "item", name = "stone", amount = 2 } },
      results = { { type = "item", name = "sand", amount = 4 } },
    },
  })
end

if not (data.raw.item and data.raw.item.glass) then
  data:extend({
    {
      type = "item",
      name = "glass",
      icon = "__space-age__/graphics/icons/superconductor.png",
      icon_size = 64,
      subgroup = "raw-material",
      order = "a[stone]-c[glass]",
      stack_size = 100,
    },
    {
      type = "recipe",
      name = "glass",
      category = "smelting",
      enabled = false,
      energy_required = 3.2,
      ingredients = { { type = "item", name = "sand", amount = 4 } },
      results = { { type = "item", name = "glass", amount = 2 } },
    },
  })
end

if not (data.raw.technology and data.raw.technology["sand-processing"]) then
  data:extend({
    {
      type = "technology",
      name = "sand-processing",
      icon = "__base__/graphics/icons/stone.png",
      icon_size = 64,
      prerequisites = { "fw-comminution" },
      unit = {
        count = 20,
        ingredients = { { "automation-science-pack", 1 } },
        time = 15,
      },
      effects = {
        { type = "unlock-recipe", recipe = "sand" },
      },
      order = "a-b-d[sand-processing]",
    },
  })
end


if not (data.raw.technology and data.raw.technology["glass-processing"]) then
  data:extend({
    {
      type = "technology",
      name = "glass-processing",
      icon = "__space-age__/graphics/icons/superconductor.png",
      icon_size = 64,
      prerequisites = { "sand-processing" },
      unit = {
        count = 30,
        ingredients = { { "automation-science-pack", 1 } },
        time = 15,
      },
      effects = { { type = "unlock-recipe", recipe = "glass" } },
      order = "a-b-e[glass-processing]",
    },
  })
end
