local science_icons = "__FluxWorksAssets__/graphics/icons/science/"

local packs = {
  {
    name = "fw-industrial-methods-science-pack",
    icon = science_icons .. "fw-industrial-methods-science-pack.png",
    order = "d[domain]-a[industrial]",
  },
  {
    name = "fw-systems-analysis-science-pack",
    icon = science_icons .. "fw-systems-analysis-science-pack.png",
    order = "d[domain]-b[systems]",
  },
  {
    name = "fw-flux-theory-science-pack",
    icon = science_icons .. "fw-flux-theory-science-pack.png",
    order = "d[domain]-c[flux]",
  },
  {
    name = "fw-planetary-convergence-science-pack",
    icon = science_icons .. "fw-planetary-convergence-science-pack.png",
    order = "d[domain]-d[convergence]",
  },
}

for _, pack in ipairs(packs) do
  data:extend({
    {
      type = "item",
      name = pack.name,
      icon = pack.icon,
      icon_size = 64,
      subgroup = "fw-science-packs",
      order = pack.order,
      stack_size = 200,
      weight = 1000,
    },
  })
end

data:extend({
  {
    type = "recipe",
    name = "fw-industrial-methods-science-pack",
    enabled = false,
    energy_required = 8,
    ingredients = {
      { type = "item", name = "fw-metal-mesh", amount = 1 },
      { type = "item", name = "fw-iron-beam", amount = 1 },
      { type = "item", name = "glass", amount = 1 },
      { type = "item", name = "fw-carbon", amount = 2 },
    },
    results = { { type = "item", name = "fw-industrial-methods-science-pack", amount = 2 } },
    subgroup = "fw-science-packs",
    order = "d[domain]-a[industrial]",
  },
  {
    type = "recipe",
    name = "fw-systems-analysis-science-pack",
    enabled = false,
    energy_required = 12,
    ingredients = {
      { type = "item", name = "fw-sensor-package", amount = 1 },
      { type = "item", name = "fw-signal-conduit", amount = 2 },
      { type = "item", name = "fw-microchip", amount = 1 },
      { type = "item", name = "battery", amount = 2 },
    },
    results = { { type = "item", name = "fw-systems-analysis-science-pack", amount = 2 } },
    subgroup = "fw-science-packs",
    order = "d[domain]-b[systems]",
  },
  {
    type = "recipe",
    name = "fw-flux-theory-science-pack",
    enabled = false,
    category = "fw-flux-synthesis",
    energy_required = 18,
    ingredients = {
      { type = "item", name = "fw-stabilized-flux-crystal", amount = 2 },
      { type = "item", name = "fw-flux-catalyst", amount = 1 },
      { type = "item", name = "fw-resonance-substrate", amount = 1 },
      { type = "fluid", name = "fw-purple-flux", amount = 40 },
    },
    results = { { type = "item", name = "fw-flux-theory-science-pack", amount = 2 } },
    subgroup = "fw-science-packs",
    order = "d[domain]-c[flux]",
  },
  {
    type = "recipe",
    name = "fw-planetary-convergence-science-pack",
    enabled = false,
    category = "fw-flux-condensing",
    energy_required = 30,
    ingredients = {
      { type = "item", name = "fw-promethium-matrix", amount = 1 },
      { type = "item", name = "fw-rift-stabilizer", amount = 1 },
      { type = "item", name = "fw-condensed-flux-matrix", amount = 2 },
    },
    results = { { type = "item", name = "fw-planetary-convergence-science-pack", amount = 4 } },
    subgroup = "fw-science-packs",
    order = "d[domain]-d[convergence]",
  },
})

local function science(...)
  local ingredients = {}
  for _, name in ipairs({ ... }) do
    ingredients[#ingredients + 1] = { name, 1 }
  end
  return ingredients
end

local unlocks = {
  {
    name = "fw-industrial-methods-science",
    pack = "fw-industrial-methods-science-pack",
    prerequisites = { "fw-metals-fabrication", "logistics-2" },
    count = 140,
    ingredients = science("automation-science-pack", "logistic-science-pack"),
    order = "fw-domain-a[industrial]",
  },
  {
    name = "fw-systems-analysis-science",
    pack = "fw-systems-analysis-science-pack",
    prerequisites = { "fw-sensor-integration", "production-science-pack" },
    count = 420,
    ingredients = science(
      "automation-science-pack", "logistic-science-pack", "chemical-science-pack", "production-science-pack"
    ),
    order = "fw-domain-b[systems]",
  },
  {
    name = "fw-flux-theory-science",
    pack = "fw-flux-theory-science-pack",
    prerequisites = { "fw-flux-resonance", "space-science-pack" },
    count = 720,
    ingredients = science(
      "automation-science-pack", "logistic-science-pack", "chemical-science-pack",
      "production-science-pack", "utility-science-pack", "space-science-pack"
    ),
    order = "fw-domain-c[flux]",
  },
  {
    name = "fw-planetary-convergence-science",
    pack = "fw-planetary-convergence-science-pack",
    prerequisites = { "fw-cross-planetary-industrial-convergence", "fw-promethium-stabilization" },
    count = 1600,
    ingredients = science(
      "automation-science-pack", "logistic-science-pack", "chemical-science-pack",
      "production-science-pack", "utility-science-pack", "space-science-pack",
      "metallurgic-science-pack", "agricultural-science-pack",
      "electromagnetic-science-pack", "cryogenic-science-pack"
    ),
    order = "fw-domain-d[convergence]",
  },
}

for index, unlock in ipairs(unlocks) do
  data:extend({
    {
      type = "technology",
      name = unlock.name,
      icon = packs[index].icon,
      icon_size = 64,
      prerequisites = unlock.prerequisites,
      unit = { count = unlock.count, ingredients = unlock.ingredients, time = 45 },
      effects = { { type = "unlock-recipe", recipe = unlock.pack } },
      order = unlock.order,
    },
  })
end

for _, lab in pairs(data.raw.lab or {}) do
  lab.inputs = lab.inputs or {}
  for _, pack in ipairs(packs) do
    local present = false
    for _, input in ipairs(lab.inputs) do
      if input == pack.name then
        present = true
        break
      end
    end
    if not present then
      lab.inputs[#lab.inputs + 1] = pack.name
    end
  end
end

return {
  packs = packs,
  unlocks = unlocks,
}
