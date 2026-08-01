local function unit(count, sciences, time)
  local ingredients = {}
  for _, science in ipairs(sciences) do
    ingredients[#ingredients + 1] = { science, 1 }
  end
  return { count = count, ingredients = ingredients, time = time or 60 }
end

local common = {
  "automation-science-pack", "logistic-science-pack", "chemical-science-pack",
  "production-science-pack", "utility-science-pack", "space-science-pack",
}

local function sciences(extra)
  local result = {}
  for _, science in ipairs(common) do result[#result + 1] = science end
  for _, science in ipairs(extra or {}) do result[#result + 1] = science end
  return result
end

data:extend({
  {
    type = "technology", name = "fw-orbital-flux-industrialization",
    icon = "__FluxWorksAssets__/graphics/technology/fw-asteroid-refinement-productivity.png", icon_size = 190,
    prerequisites = { "space-platform", "fw-orbital-hardening", "fw-flux-catalysis" },
    unit = unit(650, sciences(), 45),
    effects = { { type = "unlock-recipe", recipe = "fw-orbital-flux-chunk-sorting" } },
    order = "d-k-a[fw-orbital-flux-industrialization]",
  },
  {
    type = "technology", name = "fw-vulcanus-industrial-symbiosis",
    icon = "__FluxWorksAssets__/graphics/technology/fw-metallurgic-assemblies.png", icon_size = 256,
    prerequisites = { "fw-flux-metallurgy", "tungsten-steel", "metallurgic-science-pack" },
    unit = unit(1250, sciences({ "metallurgic-science-pack" }), 60),
    effects = {
      { type = "unlock-recipe", recipe = "fw-vulcanus-red-carbide-sintering" },
      { type = "unlock-recipe", recipe = "fw-vulcanus-flux-casting" },
    },
    order = "d-n-b[fw-vulcanus-industrial-symbiosis]",
  },
  {
    type = "technology", name = "fw-gleba-regenerative-symbiosis",
    icons = {
      { icon = "__FluxWorksAssets__/graphics/technology/fw-biosystems-engineering.png", icon_size = 256 },
      { icon = "__FluxWorksAssets__/graphics/icons/items/flux-1.png", icon_size = 64, scale = 0.55, shift = { 30, 30 } },
    },
    prerequisites = { "fw-flux-green-cultivation", "carbon-fiber", "agricultural-science-pack" },
    unit = unit(1250, sciences({ "agricultural-science-pack" }), 60),
    effects = { { type = "unlock-recipe", recipe = "fw-gleba-green-carbon-fiber-cultivation" } },
    order = "d-n-c[fw-gleba-regenerative-symbiosis]",
  },
  {
    type = "technology", name = "fw-fulgora-electromagnetic-symbiosis",
    icon = "__FluxWorksAssets__/graphics/technology/fw-conductive-networks.png", icon_size = 256,
    prerequisites = { "fw-fulgora-electrochemistry", "electromagnetic-science-pack", "recycling" },
    unit = unit(1250, sciences({ "electromagnetic-science-pack" }), 60),
    effects = { { type = "unlock-recipe", recipe = "fw-fulgora-yellow-holmium-reclamation" } },
    order = "d-n-d[fw-fulgora-electromagnetic-symbiosis]",
  },
  {
    type = "technology", name = "fw-aquilo-thermal-symbiosis",
    icon = "__FluxWorksAssets__/graphics/technology/fw-cryogenic-control.png", icon_size = 256,
    prerequisites = { "fw-aquilo-cryochemistry", "heating-tower", "cryogenic-science-pack" },
    unit = unit(1350, sciences({ "cryogenic-science-pack" }), 60),
    effects = { { type = "unlock-recipe", recipe = "fw-aquilo-red-ammonia-cracking" } },
    order = "d-n-e[fw-aquilo-thermal-symbiosis]",
  },
  {
    type = "technology", name = "fw-cross-planetary-industrial-convergence",
    icon = "__FluxWorksAssets__/graphics/technology/fw-promethium-stabilization.png", icon_size = 256,
    prerequisites = {
      "fw-flux-convergence", "fw-vulcanus-industrial-symbiosis",
      "fw-gleba-regenerative-symbiosis", "fw-fulgora-electromagnetic-symbiosis",
      "fw-aquilo-thermal-symbiosis",
    },
    unit = unit(2200, sciences({
      "metallurgic-science-pack", "agricultural-science-pack",
      "electromagnetic-science-pack", "cryogenic-science-pack",
    }), 75),
    effects = { { type = "unlock-recipe", recipe = "fw-converged-quantum-processor" } },
    order = "d-z[fw-cross-planetary-industrial-convergence]",
  },
})

local function add_prerequisite(technology_name, prerequisite_name)
  local technology = data.raw.technology and data.raw.technology[technology_name]
  if not technology then return end
  technology.prerequisites = technology.prerequisites or {}
  for _, prerequisite in ipairs(technology.prerequisites) do
    if prerequisite == prerequisite_name then return end
  end
  technology.prerequisites[#technology.prerequisites + 1] = prerequisite_name
end

-- These are the visible interlocks: major Space Age rewards now pass through the matching
-- FluxWorks planetary discipline instead of living on a parallel, disconnected tree.
add_prerequisite("advanced-material-processing-2", "fw-ceramic-engineering")
add_prerequisite("automation-3", "fw-systems-integration")
add_prerequisite("electric-energy-distribution-2", "fw-power-regulation")
add_prerequisite("robotics", "fw-signal-architecture")
add_prerequisite("advanced-asteroid-processing", "fw-orbital-flux-industrialization")
add_prerequisite("turbo-transport-belt", "fw-vulcanus-industrial-symbiosis")
add_prerequisite("stack-inserter", "fw-gleba-regenerative-symbiosis")
add_prerequisite("tesla-weapons", "fw-fulgora-electromagnetic-symbiosis")
add_prerequisite("fusion-reactor", "fw-cross-planetary-industrial-convergence")
