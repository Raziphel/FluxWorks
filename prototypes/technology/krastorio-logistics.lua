local Tech = require("__haul_lib__/utils/tech")

local function tech_unit(count, science_packs, time)
  return { count = count, ingredients = science_packs, time = time }
end

local function unlock(recipe_name)
  return { type = "unlock-recipe", recipe = recipe_name }
end

local RG = {
  { "automation-science-pack", 1 },
  { "logistic-science-pack", 1 },
}

local RGB = {
  { "automation-science-pack", 1 },
  { "logistic-science-pack", 1 },
  { "chemical-science-pack", 1 },
}

local RGBP = {
  { "automation-science-pack", 1 },
  { "logistic-science-pack", 1 },
  { "chemical-science-pack", 1 },
  { "production-science-pack", 1 },
}

data:extend({
  {
    type = "technology",
    name = "fw-pressure-containment",
    icon = "__Krastorio2Assets__/icons/entities/steel-pipe.png",
    icon_size = 64,
    prerequisites = { "fw-tube-forming", "fw-beam-engineering", "fluid-handling" },
    unit = tech_unit(85, RG, 24),
    effects = {
      unlock("fw-kr-steel-pipe"),
      unlock("fw-kr-steel-pipe-to-ground"),
      unlock("fw-kr-steel-pump"),
    },
    order = "c-l-a[fw-pressure-containment]",
  },
  {
    type = "technology",
    name = "fw-pressure-reservoirs",
    icon = "__Krastorio2Assets__/icons/entities/big-storage-tank.png",
    icon_size = 64,
    prerequisites = { "fw-pressure-containment", "steel-processing" },
    unit = tech_unit(110, RG, 26),
    effects = { unlock("fw-kr-big-storage-tank") },
    order = "c-l-b[fw-pressure-reservoirs]",
  },
  {
    type = "technology",
    name = "fw-bulk-logistics",
    icon = "__Krastorio2Assets__/icons/entities/loader.png",
    icon_size = 64,
    prerequisites = { "fw-beam-engineering", "fw-metals-fabrication", "logistics" },
    unit = tech_unit(70, RG, 22),
    effects = { unlock("fw-kr-loader") },
    order = "c-m-a[fw-bulk-logistics]",
  },
  {
    type = "technology",
    name = "fw-fast-loader-handling",
    icon = "__Krastorio2Assets__/icons/entities/fast-loader.png",
    icon_size = 64,
    prerequisites = { "fw-bulk-logistics", "logistics-2" },
    unit = tech_unit(95, RG, 24),
    effects = { unlock("fw-kr-fast-loader") },
    order = "c-m-b[fw-fast-loader-handling]",
  },
  {
    type = "technology",
    name = "fw-bulk-storage",
    icon = "__Krastorio2Assets__/icons/entities/warehouse.png",
    icon_size = 64,
    prerequisites = { "fw-bulk-logistics", "steel-processing" },
    unit = tech_unit(90, RG, 24),
    effects = {
      unlock("fw-kr-strongbox"),
      unlock("fw-kr-warehouse"),
    },
    order = "c-m-c[fw-bulk-storage]",
  },
  {
    type = "technology",
    name = "fw-network-logistics",
    icon = "__Krastorio2Assets__/icons/entities/express-loader.png",
    icon_size = 64,
    prerequisites = { "fw-fast-loader-handling", "fw-signal-architecture", "logistics-3" },
    unit = tech_unit(165, RGB, 30),
    effects = { unlock("fw-kr-express-loader") },
    order = "c-n-a[fw-network-logistics]",
  },
  {
    type = "technology",
    name = "fw-network-storage",
    icon = "__Krastorio2Assets__/icons/entities/passive-provider-warehouse.png",
    icon_size = 64,
    prerequisites = { "fw-bulk-storage", "fw-signal-architecture", "logistic-robotics" },
    unit = tech_unit(185, RGB, 30),
    effects = {
      unlock("fw-kr-passive-provider-strongbox"),
      unlock("fw-kr-storage-strongbox"),
      unlock("fw-kr-passive-provider-warehouse"),
      unlock("fw-kr-storage-warehouse"),
    },
    order = "c-n-b[fw-network-storage]",
  },
  {
    type = "technology",
    name = "fw-logistics-orchestration",
    icon = "__Krastorio2Assets__/icons/entities/advanced-loader.png",
    icon_size = 64,
    prerequisites = { "fw-network-logistics", "fw-computational-arrays", "turbo-transport-belt", "fw-industrial-expansion" },
    unit = tech_unit(260, RGBP, 35),
    effects = { unlock("fw-kr-advanced-loader") },
    order = "c-o-a[fw-logistics-orchestration]",
  },
  {
    type = "technology",
    name = "fw-controlled-storage",
    icon = "__Krastorio2Assets__/icons/entities/requester-warehouse.png",
    icon_size = 64,
    prerequisites = { "fw-network-storage", "fw-logistics-orchestration", "logistic-system" },
    unit = tech_unit(285, RGBP, 35),
    effects = {
      unlock("fw-kr-active-provider-strongbox"),
      unlock("fw-kr-buffer-strongbox"),
      unlock("fw-kr-requester-strongbox"),
      unlock("fw-kr-active-provider-warehouse"),
      unlock("fw-kr-buffer-warehouse"),
      unlock("fw-kr-requester-warehouse"),
    },
    order = "c-o-b[fw-controlled-storage]",
  },
  {
    type = "technology",
    name = "fw-high-capacity-fluid-storage",
    icon = "__Krastorio2Assets__/icons/entities/huge-storage-tank.png",
    icon_size = 64,
    prerequisites = { "fw-pressure-reservoirs", "fw-controlled-storage", "fw-industrial-expansion" },
    unit = tech_unit(300, RGBP, 36),
    effects = { unlock("fw-kr-huge-storage-tank") },
    order = "c-o-c[fw-high-capacity-fluid-storage]",
  },
})

for _, definition in ipairs({
  { "fw-pressure-containment", 85, "RG", 24, { "fw-tube-forming", "fw-beam-engineering", "fluid-handling" } },
  { "fw-pressure-reservoirs", 110, "RG", 26, { "fw-pressure-containment", "steel-processing" } },
  { "fw-bulk-logistics", 70, "RG", 22, { "fw-beam-engineering", "fw-metals-fabrication", "logistics" } },
  { "fw-fast-loader-handling", 95, "RG", 24, { "fw-bulk-logistics", "logistics-2" } },
  { "fw-bulk-storage", 90, "RG", 24, { "fw-bulk-logistics", "steel-processing" } },
  { "fw-network-logistics", 165, "RGB", 30, { "fw-fast-loader-handling", "fw-signal-architecture", "logistics-3" } },
  { "fw-network-storage", 185, "RGB", 30, { "fw-bulk-storage", "fw-signal-architecture", "logistic-robotics" } },
  { "fw-logistics-orchestration", 260, "RGBP", 35, { "fw-network-logistics", "fw-computational-arrays", "turbo-transport-belt", "fw-industrial-expansion" } },
  { "fw-controlled-storage", 285, "RGBP", 35, { "fw-network-storage", "fw-logistics-orchestration", "logistic-system" } },
  { "fw-high-capacity-fluid-storage", 300, "RGBP", 36, { "fw-pressure-reservoirs", "fw-controlled-storage", "fw-industrial-expansion" } },
}) do
  Tech:get(definition[1])
    :setCost(definition[2])
    :setColors(definition[3])
    :setTime(definition[4])
    :setPrerequisites(definition[5])
end
