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
    name = "fw-comminution",
    icon = "__space-age__/graphics/icons/crusher.png",
    icon_size = 64,
    prerequisites = { "automation", "steel-processing" },
    unit = tech_unit(16, {
      { "automation-science-pack", 1 },
    }, 12),
    effects = {
      unlock("crusher"),
    },
    order = "a-b-c[fw-comminution]",
  },
  {
    type = "technology",
    name = "fw-aggregate-recovery",
    icon = "__Krastorio2Assets__/icons/items/sand-2.png",
    icon_size = 64,
    prerequisites = { "fw-comminution" },
    unit = tech_unit(18, {
      { "automation-science-pack", 1 },
    }, 12),
    effects = {
      unlock("fw-sand"),
    },
    order = "a-b-d[fw-aggregate-recovery]",
  },
  {
    type = "technology",
    name = "fw-basic-separation",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-inline-filter.png",
    icon_size = 1024,
    prerequisites = { "fw-aggregate-recovery", "logistics" },
    unit = tech_unit(18, {
      { "automation-science-pack", 1 },
    }, 15),
    effects = {
      unlock("fw-carbon-refining"),
    },
    order = "a-b-e[fw-basic-separation]",
  },
  {
    type = "technology",
    name = "fw-brine-processing",
    icon = "__FluxWorksAssets__/graphics/resources/ores/salt.png",
    icon_size = 128,
    prerequisites = { "fw-basic-separation" },
    unit = tech_unit(20, {
      { "automation-science-pack", 1 },
    }, 15),
    effects = {
      unlock("fw-salt-from-water"),
    },
    order = "a-b-f[fw-brine-processing]",
  },
  {
    type = "technology",
    name = "fw-ore-crushing",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-crushed-lead-ore.png",
    icon_size = 128,
    prerequisites = { "fw-basic-separation" },
    unit = tech_unit(28, {
      { "automation-science-pack", 1 },
    }, 18),
    effects = {
      unlock("fw-crushed-iron-ore"),
      unlock("fw-crushed-copper-ore"),
      unlock("fw-crushed-tin-ore"),
      unlock("fw-crushed-bauxite-ore"),
      unlock("fw-crushed-lead-ore"),
      unlock("fw-crushed-titanium-ore"),
    },
    order = "a-b-g[fw-ore-crushing]",
  },
  {
    type = "technology",
    name = "fw-dense-ore-smelting",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-bz-tin-ore.png",
    icon_size = 128,
    prerequisites = { "fw-ore-crushing", "steel-processing" },
    unit = tech_unit(32, {
      { "automation-science-pack", 1 },
    }, 18),
    effects = {
      unlock("iron-plate-from-crushed"),
      unlock("copper-plate-from-crushed"),
      unlock("tin-plate-from-crushed"),
      unlock("aluminum-plate-from-crushed-bauxite"),
      unlock("lead-plate-from-crushed"),
      unlock("titanium-plate-from-crushed"),
    },
    order = "a-b-h[fw-dense-ore-smelting]",
  },
  {
    type = "technology",
    name = "fw-mineral-beneficiation",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-bz-carbon-ore.png",
    icon_size = 128,
    prerequisites = { "fw-dense-ore-smelting", "fw-brine-processing", "logistics" },
    unit = tech_unit(40, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
    }, 18),
    effects = {
      unlock("fw-silicon-beneficiation"),
    },
    order = "a-b-i[fw-mineral-beneficiation]",
  },
})

Tech:get("fw-comminution")
  :setCost(16)
  :setColors("R")
  :setTime(12)
  :setPrerequisites({ "automation", "steel-processing" })

Tech:get("fw-aggregate-recovery")
  :setCost(18)
  :setColors("R")
  :setTime(12)
  :setPrerequisites({ "fw-comminution" })

Tech:get("fw-basic-separation")
  :setCost(18)
  :setColors("R")
  :setTime(15)
  :setPrerequisites({ "fw-aggregate-recovery", "logistics" })

Tech:get("fw-brine-processing")
  :setCost(20)
  :setColors("R")
  :setTime(15)
  :setPrerequisites({ "fw-basic-separation" })

Tech:get("fw-ore-crushing")
  :setCost(28)
  :setColors("R")
  :setTime(18)
  :setPrerequisites({ "fw-basic-separation" })

Tech:get("fw-dense-ore-smelting")
  :setCost(32)
  :setColors("R")
  :setTime(18)
  :setPrerequisites({ "fw-ore-crushing", "steel-processing" })

Tech:get("fw-mineral-beneficiation")
  :setCost(40)
  :setColors("RG")
  :setTime(18)
  :setPrerequisites({ "fw-dense-ore-smelting", "fw-brine-processing", "logistics" })
