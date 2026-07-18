local Tech = require("__haul_lib__/utils/tech")

local function tech_unit(count, science_packs, time)
  return {
    count = count,
    ingredients = science_packs,
    time = time,
  }
end

local function unlock(recipe_name)
  return { type = "unlock-recipe", recipe = recipe_name }
end

data:extend({
  {
    type = "technology",
    name = "fw-pressure-containment",
    icon = "__Krastorio2Assets__/icons/entities/steel-pipe.png",
    icon_size = 64,
    prerequisites = { "fw-tube-forming", "fw-beam-engineering", "fluid-handling" },
    unit = tech_unit(85, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
    }, 24),
    effects = {
      unlock("fw-kr-steel-pipe"),
      unlock("fw-kr-steel-pipe-to-ground"),
      unlock("fw-kr-steel-pump"),
      unlock("fw-kr-big-storage-tank"),
    },
    order = "c-l[fw-pressure-containment]",
  },
  {
    type = "technology",
    name = "fw-bulk-logistics",
    icon = "__Krastorio2Assets__/icons/entities/loader.png",
    icon_size = 64,
    prerequisites = { "fw-beam-engineering", "fw-metals-fabrication", "logistics-2", "steel-processing" },
    unit = tech_unit(95, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
    }, 24),
    effects = {
      unlock("fw-kr-loader"),
      unlock("fw-kr-fast-loader"),
      unlock("fw-kr-strongbox"),
      unlock("fw-kr-warehouse"),
    },
    order = "c-m[fw-bulk-logistics]",
  },
  {
    type = "technology",
    name = "fw-network-logistics",
    icon = "__Krastorio2Assets__/icons/entities/passive-provider-warehouse.png",
    icon_size = 64,
    prerequisites = { "fw-bulk-logistics", "fw-signal-architecture", "logistic-robotics", "logistics-3" },
    unit = tech_unit(165, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
    }, 30),
    effects = {
      unlock("fw-kr-express-loader"),
      unlock("fw-kr-passive-provider-strongbox"),
      unlock("fw-kr-storage-strongbox"),
      unlock("fw-kr-passive-provider-warehouse"),
      unlock("fw-kr-storage-warehouse"),
    },
    order = "c-n[fw-network-logistics]",
  },
  {
    type = "technology",
    name = "fw-logistics-orchestration",
    icon = "__Krastorio2Assets__/icons/entities/advanced-loader.png",
    icon_size = 64,
    prerequisites = { "fw-network-logistics", "fw-computational-arrays", "logistic-system", "turbo-transport-belt", "fw-industrial-expansion" },
    unit = tech_unit(260, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
    }, 35),
    effects = {
      unlock("fw-kr-advanced-loader"),
      unlock("fw-kr-active-provider-strongbox"),
      unlock("fw-kr-buffer-strongbox"),
      unlock("fw-kr-requester-strongbox"),
      unlock("fw-kr-active-provider-warehouse"),
      unlock("fw-kr-buffer-warehouse"),
      unlock("fw-kr-requester-warehouse"),
      unlock("fw-kr-huge-storage-tank"),
    },
    order = "c-o[fw-logistics-orchestration]",
  },
})

Tech:get("fw-pressure-containment")
  :setCost(85)
  :setColors("RG")
  :setTime(24)
  :setPrerequisites({ "fw-tube-forming", "fw-beam-engineering", "fluid-handling" })

Tech:get("fw-bulk-logistics")
  :setCost(95)
  :setColors("RG")
  :setTime(24)
  :setPrerequisites({ "fw-beam-engineering", "fw-metals-fabrication", "logistics-2", "steel-processing" })

Tech:get("fw-network-logistics")
  :setCost(165)
  :setColors("RGB")
  :setTime(30)
  :setPrerequisites({ "fw-bulk-logistics", "fw-signal-architecture", "logistic-robotics", "logistics-3" })

Tech:get("fw-logistics-orchestration")
  :setCost(260)
  :setColors("RGBP")
  :setTime(35)
  :setPrerequisites({ "fw-network-logistics", "fw-computational-arrays", "logistic-system", "turbo-transport-belt", "fw-industrial-expansion" })
