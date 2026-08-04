local function science(...)
  local ingredients = {}
  for _, name in ipairs({ ... }) do
    ingredients[#ingredients + 1] = { name, 1 }
  end
  return ingredients
end

local science_tiers = {
  science("automation-science-pack", "logistic-science-pack", "chemical-science-pack"),
  science(
    "automation-science-pack",
    "logistic-science-pack",
    "chemical-science-pack",
    "production-science-pack",
    "utility-science-pack"
  ),
  science(
    "automation-science-pack",
    "logistic-science-pack",
    "chemical-science-pack",
    "production-science-pack",
    "utility-science-pack",
    "space-science-pack"
  ),
}

local function productivity_effect(recipe, change)
  return { type = "change-recipe-productivity", recipe = recipe, change = change }
end

local program_icon_path = "__FluxWorksAssets__/graphics/technology/programs/"

local function tier_icons(stem, icon_size)
  icon_size = icon_size or 64
  return {
    { program_icon_path .. stem .. "-1.png", icon_size },
    { program_icon_path .. stem .. "-2.png", icon_size },
    { program_icon_path .. stem .. "-3.png", icon_size },
  }
end

local material_handling_prerequisite = data.raw.technology["aai-loader"]
  and "aai-loader"
  or "logistics-2"
local autonomous_logistics_prerequisite = data.raw.technology["aai-express-loader"]
  and "aai-express-loader"
  or "logistics-3"

local programs = {
  {
    stem = "fw-industrial-yield",
    tier_icons = tier_icons("fw-industrial-yield"),
    prerequisites = { "fw-mineral-beneficiation", "mining-productivity-1" },
    effects = {
      { { type = "mining-drill-productivity-bonus", modifier = 0.05 } },
      { { type = "mining-drill-productivity-bonus", modifier = 0.08 } },
      { { type = "mining-drill-productivity-bonus", modifier = 0.12 } },
    },
  },
  {
    stem = "fw-material-handling",
    tier_icons = tier_icons("fw-material-handling"),
    prerequisites = { material_handling_prerequisite, "inserter-capacity-bonus-2" },
    effects = {
      {
        { type = "inserter-stack-size-bonus", modifier = 1 },
        { type = "bulk-inserter-capacity-bonus", modifier = 1 },
      },
      {
        { type = "inserter-stack-size-bonus", modifier = 1 },
        { type = "bulk-inserter-capacity-bonus", modifier = 1 },
      },
      {
        { type = "inserter-stack-size-bonus", modifier = 1 },
        { type = "bulk-inserter-capacity-bonus", modifier = 2 },
      },
    },
  },
  {
    stem = "fw-autonomous-logistics",
    tier_icons = tier_icons("fw-autonomous-logistics"),
    prerequisites = { autonomous_logistics_prerequisite, "worker-robots-speed-3" },
    effects = {
      {
        { type = "worker-robot-speed", modifier = 0.25 },
        { type = "worker-robot-storage", modifier = 1 },
      },
      {
        { type = "worker-robot-speed", modifier = 0.35 },
        { type = "worker-robot-storage", modifier = 1 },
      },
      {
        { type = "worker-robot-speed", modifier = 0.50 },
        { type = "worker-robot-storage", modifier = 1 },
      },
    },
  },
  {
    stem = "fw-rail-network-control",
    tier_icons = tier_icons("fw-rail-network-control", 256),
    prerequisites = { "fw-signal-architecture", "braking-force-2" },
    effects = {
      { { type = "train-braking-force-bonus", modifier = 0.10 } },
      { { type = "train-braking-force-bonus", modifier = 0.15 } },
      { { type = "train-braking-force-bonus", modifier = 0.20 } },
    },
  },
  {
    stem = "fw-research-methodology",
    tier_icons = tier_icons("fw-research-methodology"),
    prerequisites = { "fw-instrumentation", "research-speed-2" },
    effects = {
      {
        { type = "laboratory-speed", modifier = 0.15 },
        { type = "laboratory-productivity", modifier = 0.03 },
      },
      {
        { type = "laboratory-speed", modifier = 0.25 },
        { type = "laboratory-productivity", modifier = 0.05 },
      },
      {
        { type = "laboratory-speed", modifier = 0.40 },
        { type = "laboratory-productivity", modifier = 0.08 },
      },
    },
  },
  {
    stem = "fw-flux-process-mastery",
    tier_icons = tier_icons("fw-flux-process-mastery"),
    prerequisites = { "fw-flux-stabilization" },
    effects = {
      {
        productivity_effect("fw-flux-catalyst", 0.05),
        productivity_effect("fw-stabilized-flux-crystal", 0.05),
      },
      {
        productivity_effect("fw-flux-metallic-synthesis", 0.08),
        productivity_effect("fw-flux-asteroid-refining", 0.08),
      },
      {
        productivity_effect("fw-condensed-flux-matrix", 0.10),
        productivity_effect("fw-flux-resonance-cell-calibration", 0.10),
        productivity_effect("fw-flux-phase-manifold-calibration", 0.10),
      },
    },
  },
}

local prototypes = {}
local counts = { 240, 700, 1800 }
local times = { 35, 45, 60 }
local tier_numerals = { "I", "II", "III" }

for program_index, program in ipairs(programs) do
  for tier = 1, 3 do
    local name = program.stem .. "-" .. tier
    local prerequisites = tier == 1 and program.prerequisites or { program.stem .. "-" .. (tier - 1) }
    local effects = {}
    for _, effect in ipairs(program.effects[tier]) do
      if effect then
        effects[#effects + 1] = effect
      end
    end

    prototypes[#prototypes + 1] = {
      type = "technology",
      name = name,
      -- Keep these names independent of locale fallback behavior used by
      -- generated, numbered prototypes.
      localised_name = { "", { "technology-name." .. program.stem }, " ", tier_numerals[tier] },
      icon = program.tier_icons[tier][1],
      icon_size = program.tier_icons[tier][2],
      prerequisites = prerequisites,
      unit = {
        count = counts[tier],
        -- Each program is assigned its own domain pack during final fixes.
        -- Do not share this table between prototypes: mutating one program's
        -- science requirements would otherwise leak into every program at the
        -- same tier and erase the distinction between research disciplines.
        ingredients = table.deepcopy(science_tiers[tier]),
        time = times[tier],
      },
      effects = effects,
      upgrade = true,
      order = "fw-programs-" .. string.char(96 + program_index) .. "-" .. tier,
    }
  end
end

data:extend(prototypes)
