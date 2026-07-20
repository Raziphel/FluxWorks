local icon_path = "__FluxWorksAssets__/graphics/icons/items/"

local projects = {
  {
    item = "fw-industrial-district-charter",
    technology = "fw-industrial-district-project",
    domain = "fw-industrial-methods-science",
    icon = icon_path .. "fw-composite-panel.png",
    icon_size = 1024,
    item_icon = "__Krastorio2Assets__/icons/cards/biters-research-data.png",
    item_icon_size = 64,
    technology_icon = "__Krastorio2Assets__/icons/items/steel-beam.png",
    technology_icon_size = 64,
    energy = 45,
    ingredients = {
      { type = "item", name = "fw-industrial-methods-science-pack", amount = 120 },
      { type = "item", name = "fw-steel-beam", amount = 40 },
      { type = "item", name = "fw-composite-panel", amount = 20 },
      { type = "item", name = "electric-engine-unit", amount = 10 },
    },
    effects = {
      { type = "mining-drill-productivity-bonus", modifier = 0.05 },
      { type = "inserter-stack-size-bonus", modifier = 1 },
    },
    order = "a[industrial]",
  },
  {
    item = "fw-autonomous-network-charter",
    technology = "fw-autonomous-network-project",
    domain = "fw-systems-analysis-science",
    previous_project = "fw-industrial-district-project",
    icon = icon_path .. "fw-model-lattice.png",
    icon_size = 64,
    item_icon = "__Krastorio2Assets__/icons/cards/space-research-data.png",
    item_icon_size = 64,
    technology_icon = icon_path .. "fw-lens-array.png",
    technology_icon_size = 1024,
    energy = 60,
    ingredients = {
      { type = "item", name = "fw-systems-analysis-science-pack", amount = 160 },
      { type = "item", name = "fw-sensor-package", amount = 30 },
      { type = "item", name = "fw-logic-matrix", amount = 12 },
      { type = "item", name = "processing-unit", amount = 40 },
      { type = "item", name = "fw-industrial-district-charter", amount = 1 },
    },
    effects = {
      { type = "worker-robot-speed", modifier = 0.25 },
      { type = "worker-robot-storage", modifier = 1 },
    },
    order = "b[network]",
  },
  {
    item = "fw-spectrum-control-charter",
    technology = "fw-spectrum-control-project",
    domain = "fw-flux-theory-science",
    previous_project = "fw-autonomous-network-project",
    icon = icon_path .. "fw-condensed-flux-matrix.png",
    icon_size = 64,
    item_icon = "__Krastorio2Assets__/icons/cards/matter-research-data.png",
    item_icon_size = 64,
    technology_icon = icon_path .. "flux-2.png",
    technology_icon_size = 64,
    category = "fw-flux-synthesis",
    energy = 90,
    ingredients = {
      { type = "item", name = "fw-flux-theory-science-pack", amount = 200 },
      { type = "item", name = "fw-condensed-flux-matrix", amount = 20 },
      { type = "item", name = "fw-flux-resonance-cell", amount = 12 },
      { type = "fluid", name = "fw-purple-flux", amount = 400 },
      { type = "fluid", name = "fw-yellow-flux", amount = 300 },
      { type = "fluid", name = "fw-red-flux", amount = 500 },
      { type = "fluid", name = "fw-green-flux", amount = 250 },
      { type = "item", name = "fw-autonomous-network-charter", amount = 1 },
    },
    effects = {
      { type = "change-recipe-productivity", recipe = "fw-flux-catalyst", change = 0.05 },
      { type = "change-recipe-productivity", recipe = "fw-stabilized-flux-crystal", change = 0.05 },
      { type = "change-recipe-productivity", recipe = "fw-condensed-flux-matrix", change = 0.05 },
    },
    order = "c[spectrum]",
  },
  {
    item = "fw-convergence-directive",
    technology = "fw-convergence-directive-project",
    domain = "fw-planetary-convergence-science",
    previous_project = "fw-spectrum-control-project",
    icon = icon_path .. "fw-promethium-matrix.png",
    icon_size = 1024,
    item_icon = "__Krastorio2Assets__/icons/cards/singularity-research-data.png",
    item_icon_size = 64,
    technology_icon = "__FluxWorksAssets__/graphics/icons/items/late-utility/fw-rift-exchange-gate.png",
    technology_icon_size = 64,
    category = "fw-flux-condensing",
    energy = 150,
    ingredients = {
      { type = "item", name = "fw-planetary-convergence-science-pack", amount = 250 },
      { type = "item", name = "fw-rift-stabilizer", amount = 10 },
      { type = "item", name = "fw-promethium-matrix", amount = 20 },
      { type = "item", name = "fusion-power-cell", amount = 20 },
      { type = "item", name = "quantum-processor", amount = 20 },
      { type = "fluid", name = "fw-purple-flux", amount = 1000 },
      { type = "fluid", name = "fw-yellow-flux", amount = 1000 },
      { type = "fluid", name = "fw-red-flux", amount = 1000 },
      { type = "fluid", name = "fw-green-flux", amount = 1000 },
      { type = "item", name = "fw-spectrum-control-charter", amount = 1 },
    },
    effects = {
      { type = "laboratory-productivity", modifier = 0.10 },
      { type = "mining-drill-productivity-bonus", modifier = 0.10 },
      { type = "worker-robot-speed", modifier = 0.25 },
    },
    order = "d[convergence]",
  },
}

local function add_unlock(technology_name, recipe_name)
  local technology = data.raw.technology and data.raw.technology[technology_name]
  if not technology then
    error("FluxWorks project references missing domain technology " .. technology_name)
  end
  technology.effects = technology.effects or {}
  technology.effects[#technology.effects + 1] = { type = "unlock-recipe", recipe = recipe_name }
end

for _, project in ipairs(projects) do
  data:extend({
    {
      type = "item",
      name = project.item,
      icon = project.item_icon,
      icon_size = project.item_icon_size,
      subgroup = "fw-progression-projects",
      order = project.order,
      stack_size = 1,
      weight = 1000000,
    },
    {
      type = "recipe",
      name = project.item,
      icon = project.item_icon,
      icon_size = project.item_icon_size,
      category = project.category or "crafting",
      enabled = false,
      energy_required = project.energy,
      ingredients = project.ingredients,
      results = { { type = "item", name = project.item, amount = 1 } },
      subgroup = "fw-progression-projects",
      order = project.order,
      allow_productivity = false,
    },
    {
      type = "technology",
      name = project.technology,
      icon = project.technology_icon,
      icon_size = project.technology_icon_size,
      prerequisites = project.previous_project and { project.domain, project.previous_project } or { project.domain },
      research_trigger = { type = "craft-item", item = project.item },
      effects = project.effects,
      order = "fw-project-" .. project.order,
    },
  })
  add_unlock(project.domain, project.item)
end

return projects
