-- Space Age surfaces recover FluxWorks ores through their native production
-- language instead of receiving copies of Nauvis-style ore patches.

local bacteria_specs = {
  {
    key = "lead",
    product = "lead-ore",
    tint = { r = 0.34, g = 0.28, b = 0.32, a = 1 },
    rock = "iron-stromatolite",
    bacteria_probability = 0.35,
    ore_probability = 0.22,
  },
  {
    key = "bauxite",
    product = "bauxite-ore",
    tint = { r = 0.88, g = 0.50, b = 0.10, a = 1 },
    rock = "copper-stromatolite",
    bacteria_probability = 0.32,
    ore_probability = 0.20,
  },
  {
    key = "tin",
    product = "tin-ore",
    tint = { r = 0.88, g = 0.72, b = 0.48, a = 1 },
    rock = "copper-stromatolite",
    bacteria_probability = 0.22,
    ore_probability = 0.14,
  },
  {
    key = "silicon",
    product = "silicon-ore",
    tint = { r = 0.62, g = 0.88, b = 0.92, a = 1 },
    rock = "iron-stromatolite",
    bacteria_probability = 0.30,
    ore_probability = 0.20,
  },
  {
    key = "titanium",
    product = "titanium-ore",
    tint = { r = 0.30, g = 0.50, b = 0.66, a = 1 },
    rock = "iron-stromatolite",
    bacteria_probability = 0.08,
    ore_probability = 0.05,
  },
  {
    key = "salt",
    product = "fw-salt",
    tint = { r = 1.00, g = 1.00, b = 1.00, a = 1 },
    rock = "copper-stromatolite",
    bacteria_probability = 0.30,
    ore_probability = 0.25,
  },
}

local bacteria_base_icons = {
  ["iron-stromatolite"] = {
    "__space-age__/graphics/icons/iron-bacteria.png",
    "__space-age__/graphics/icons/iron-bacteria-1.png",
    "__space-age__/graphics/icons/iron-bacteria-2.png",
    "__space-age__/graphics/icons/iron-bacteria-3.png",
  },
  ["copper-stromatolite"] = {
    "__space-age__/graphics/icons/copper-bacteria.png",
    "__space-age__/graphics/icons/copper-bacteria-1.png",
    "__space-age__/graphics/icons/copper-bacteria-2.png",
    "__space-age__/graphics/icons/copper-bacteria-3.png",
  },
}

local salt_bacteria_icons = {
  "__FluxWorksAssets__/graphics/icons/items/fw-salt-bacteria.png",
  "__FluxWorksAssets__/graphics/icons/items/fw-salt-bacteria-1.png",
  "__FluxWorksAssets__/graphics/icons/items/fw-salt-bacteria-2.png",
  "__FluxWorksAssets__/graphics/icons/items/fw-salt-bacteria-3.png",
}

local bacteria_prototypes = {}
local cultivation_recipes = {}

for index, spec in ipairs(bacteria_specs) do
  local bacteria_name = "fw-" .. spec.key .. "-bacteria"
  local base_icons = spec.key == "salt" and salt_bacteria_icons or bacteria_base_icons[spec.rock]
  local icons = {
    {
      icon = base_icons[1],
      icon_size = 64,
      tint = spec.tint,
    },
  }

  local pictures = {}
  for _, filename in ipairs(base_icons) do
    pictures[#pictures + 1] = {
      size = 64,
      filename = filename,
      scale = 0.5,
      mipmap_count = 4,
      tint = spec.tint,
    }
  end

  bacteria_prototypes[#bacteria_prototypes + 1] = {
    type = "item",
    name = bacteria_name,
    icons = icons,
    pictures = pictures,
    subgroup = "fw-bioprocessing-products",
    order = "g[cultures]-" .. string.format("%02d", index) .. "[" .. bacteria_name .. "]",
    inventory_move_sound = table.deepcopy(data.raw.item["iron-bacteria"].inventory_move_sound),
    pick_sound = table.deepcopy(data.raw.item["iron-bacteria"].pick_sound),
    drop_sound = table.deepcopy(data.raw.item["iron-bacteria"].drop_sound),
    stack_size = 50,
    default_import_location = "gleba",
    weight = 1000,
    spoil_ticks = 60 * 60,
    spoil_result = spec.product,
  }

  cultivation_recipes[#cultivation_recipes + 1] = {
    type = "recipe",
    name = bacteria_name .. "-cultivation",
    icon = "__FluxWorksAssets__/graphics/icons/items/" .. bacteria_name .. "-cultivation.png",
    icon_size = 64,
    category = "organic",
    surface_conditions = {
      { property = "pressure", min = 2000, max = 2000 },
    },
    subgroup = "fw-bioprocessing-processes",
    order = "d[cultures]-z" .. string.format("%02d", index) .. "[" .. bacteria_name .. "]",
    enabled = false,
    allow_productivity = true,
    reset_freshness_on_craft = true,
    energy_required = spec.key == "titanium" and 8 or 4,
    ingredients = {
      { type = "item", name = bacteria_name, amount = 1 },
      { type = "item", name = "bioflux", amount = spec.key == "titanium" and 2 or 1 },
    },
    results = {
      { type = "item", name = bacteria_name, amount = spec.key == "titanium" and 3 or 4 },
    },
    main_product = bacteria_name,
    crafting_machine_tint = {
      primary = spec.tint,
      secondary = {
        r = math.min(1, spec.tint.r * 0.72),
        g = math.min(1, spec.tint.g * 0.72),
        b = math.min(1, spec.tint.b * 0.72),
        a = 1,
      },
    },
    show_amount_in_title = false,
  }

  local rock = data.raw["simple-entity"] and data.raw["simple-entity"][spec.rock]
  if rock and rock.minable and rock.minable.results then
    rock.minable.results[#rock.minable.results + 1] = {
      type = "item",
      name = bacteria_name,
      amount_min = spec.key == "titanium" and 1 or 2,
      amount_max = spec.key == "titanium" and 2 or 4,
      probability = spec.bacteria_probability,
    }
    rock.minable.results[#rock.minable.results + 1] = {
      type = "item",
      name = spec.product,
      amount_min = 1,
      amount_max = spec.key == "titanium" and 1 or 3,
      probability = spec.ore_probability,
    }
  end
end

local native_stromatolite_drops = {
  ["iron-stromatolite"] = {
    stone = 0.80,
    ["iron-ore"] = 0.85,
    ["iron-bacteria"] = 0.65,
  },
  ["copper-stromatolite"] = {
    stone = 0.80,
    ["copper-ore"] = 0.85,
    ["copper-bacteria"] = 0.65,
  },
}

for rock_name, probabilities in pairs(native_stromatolite_drops) do
  local rock = data.raw["simple-entity"] and data.raw["simple-entity"][rock_name]
  for _, result in ipairs((rock and rock.minable and rock.minable.results) or {}) do
    local probability = probabilities[result.name or result[1]]
    if probability then
      result.probability = probability
    end
  end
end

data:extend(bacteria_prototypes)
data:extend(cultivation_recipes)

local function recipe(definition)
  definition.type = "recipe"
  definition.enabled = false
  definition.allow_productivity = definition.allow_productivity ~= false
  definition.always_show_products = true
  return definition
end

local recipes = {
  -- Vulcanus: fractionate minerals from lava in a foundry.
  recipe({
    name = "fw-vulcanus-lead-fractionation",
    category = "metallurgy",
    subgroup = "vulcanus-processes",
    order = "z[fluxworks]-a[lead]",
    energy_required = 6,
    ingredients = {
      { type = "fluid", name = "lava", amount = 250 },
      { type = "item", name = "calcite", amount = 1 },
    },
    results = {
      { type = "item", name = "lead-ore", amount = 12 },
      { type = "item", name = "stone", amount = 3 },
    },
    main_product = "lead-ore",
  }),
  recipe({
    name = "fw-vulcanus-bauxite-fractionation",
    category = "metallurgy",
    subgroup = "vulcanus-processes",
    order = "z[fluxworks]-b[bauxite]",
    energy_required = 7,
    ingredients = {
      { type = "fluid", name = "lava", amount = 300 },
      { type = "item", name = "calcite", amount = 2 },
    },
    results = {
      { type = "item", name = "bauxite-ore", amount = 10 },
      { type = "item", name = "stone", amount = 4 },
    },
    main_product = "bauxite-ore",
  }),
  recipe({
    name = "fw-vulcanus-tin-fractionation",
    category = "metallurgy",
    subgroup = "vulcanus-processes",
    order = "z[fluxworks]-ba[tin]",
    energy_required = 7,
    ingredients = {
      { type = "fluid", name = "lava", amount = 280 },
      { type = "item", name = "calcite", amount = 1 },
    },
    results = {
      { type = "item", name = "tin-ore", amount = 10 },
      { type = "item", name = "stone", amount = 3 },
    },
    main_product = "tin-ore",
  }),
  recipe({
    name = "fw-vulcanus-silicon-fractionation",
    category = "metallurgy",
    subgroup = "vulcanus-processes",
    order = "z[fluxworks]-c[silicon]",
    energy_required = 6,
    ingredients = {
      { type = "fluid", name = "lava", amount = 220 },
      { type = "item", name = "calcite", amount = 1 },
    },
    results = {
      { type = "item", name = "silicon-ore", amount = 12 },
      { type = "item", name = "stone", amount = 2 },
    },
    main_product = "silicon-ore",
  }),
  recipe({
    name = "fw-vulcanus-titanium-fractionation",
    category = "metallurgy",
    subgroup = "vulcanus-processes",
    order = "z[fluxworks]-d[titanium]",
    energy_required = 10,
    ingredients = {
      { type = "fluid", name = "lava", amount = 500 },
      { type = "item", name = "tungsten-ore", amount = 1 },
      { type = "item", name = "calcite", amount = 2 },
    },
    results = {
      { type = "item", name = "titanium-ore", amount = 4 },
      { type = "item", name = "stone", amount = 5 },
    },
    main_product = "titanium-ore",
  }),
  recipe({
    name = "fw-vulcanus-salt-fractionation",
    category = "metallurgy",
    subgroup = "vulcanus-processes",
    order = "z[fluxworks]-e[salt]",
    energy_required = 6,
    ingredients = {
      { type = "fluid", name = "lava", amount = 180 },
      { type = "item", name = "calcite", amount = 2 },
    },
    results = {
      { type = "item", name = "fw-salt", amount = 12 },
      { type = "item", name = "stone", amount = 2 },
    },
    main_product = "fw-salt",
  }),

  -- Gleba: living cultures bioleach trace metals from renewable biomass.
  recipe({
    name = "fw-gleba-lead-bioleaching",
    category = "organic",
    subgroup = "agriculture-processes",
    order = "z[fluxworks]-a[lead]",
    energy_required = 8,
    ingredients = {
      { type = "item", name = "fw-lead-bacteria", amount = 5 },
      { type = "item", name = "bioflux", amount = 1 },
      { type = "item", name = "spoilage", amount = 10 },
    },
    results = { { type = "item", name = "lead-ore", amount = 10 } },
    main_product = "lead-ore",
  }),
  recipe({
    name = "fw-gleba-bauxite-bioleaching",
    category = "organic",
    subgroup = "agriculture-processes",
    order = "z[fluxworks]-b[bauxite]",
    energy_required = 8,
    ingredients = {
      { type = "item", name = "fw-bauxite-bacteria", amount = 4 },
      { type = "item", name = "jelly", amount = 8 },
      { type = "item", name = "spoilage", amount = 8 },
    },
    results = { { type = "item", name = "bauxite-ore", amount = 10 } },
    main_product = "bauxite-ore",
  }),
  recipe({
    name = "fw-gleba-tin-bioleaching",
    category = "organic",
    subgroup = "agriculture-processes",
    order = "z[fluxworks]-ba[tin]",
    energy_required = 8,
    ingredients = {
      { type = "item", name = "fw-tin-bacteria", amount = 5 },
      { type = "item", name = "yumako-mash", amount = 8 },
      { type = "item", name = "spoilage", amount = 8 },
    },
    results = { { type = "item", name = "tin-ore", amount = 10 } },
    main_product = "tin-ore",
  }),
  recipe({
    name = "fw-gleba-silicon-bioleaching",
    category = "organic",
    subgroup = "agriculture-processes",
    order = "z[fluxworks]-c[silicon]",
    energy_required = 7,
    ingredients = {
      { type = "item", name = "stone", amount = 6 },
      { type = "item", name = "yumako-mash", amount = 8 },
      { type = "item", name = "fw-silicon-bacteria", amount = 2 },
    },
    results = { { type = "item", name = "silicon-ore", amount = 12 } },
    main_product = "silicon-ore",
  }),
  recipe({
    name = "fw-gleba-titanium-bioleaching",
    category = "organic",
    subgroup = "agriculture-processes",
    order = "z[fluxworks]-d[titanium]",
    energy_required = 12,
    ingredients = {
      { type = "item", name = "fw-titanium-bacteria", amount = 10 },
      { type = "item", name = "bioflux", amount = 2 },
      { type = "item", name = "jelly", amount = 10 },
    },
    results = { { type = "item", name = "titanium-ore", amount = 4 } },
    main_product = "titanium-ore",
  }),
  recipe({
    name = "fw-gleba-salt-biomineralization",
    category = "organic",
    subgroup = "agriculture-processes",
    order = "z[fluxworks]-e[salt]",
    energy_required = 6,
    ingredients = {
      { type = "item", name = "fw-salt-bacteria", amount = 5 },
      { type = "item", name = "spoilage", amount = 12 },
      { type = "item", name = "jelly", amount = 6 },
      { type = "fluid", name = "water", amount = 20 },
    },
    results = { { type = "item", name = "fw-salt", amount = 10 } },
    main_product = "fw-salt",
  }),
}

data:extend(recipes)

local function unlock_with(technology_name, recipe_names)
  local technology = data.raw.technology and data.raw.technology[technology_name]
  if not technology then return end
  technology.effects = technology.effects or {}
  for _, recipe_name in ipairs(recipe_names) do
    technology.effects[#technology.effects + 1] = { type = "unlock-recipe", recipe = recipe_name }
  end
end

unlock_with("foundry", {
  "fw-vulcanus-lead-fractionation",
  "fw-vulcanus-bauxite-fractionation",
  "fw-vulcanus-tin-fractionation",
  "fw-vulcanus-silicon-fractionation",
  "fw-vulcanus-titanium-fractionation",
  "fw-vulcanus-salt-fractionation",
})
unlock_with("biochamber", {
  "fw-gleba-lead-bioleaching",
  "fw-gleba-bauxite-bioleaching",
  "fw-gleba-tin-bioleaching",
  "fw-gleba-silicon-bioleaching",
  "fw-gleba-titanium-bioleaching",
  "fw-gleba-salt-biomineralization",
})
unlock_with("bacteria-cultivation", {
  "fw-lead-bacteria-cultivation",
  "fw-bauxite-bacteria-cultivation",
  "fw-tin-bacteria-cultivation",
  "fw-silicon-bacteria-cultivation",
  "fw-titanium-bacteria-cultivation",
  "fw-salt-bacteria-cultivation",
})
