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
    icon = "__FluxWorksAssets__/graphics/technology/comminution.png",
    icon_size = 968,
    prerequisites = { "automation" },
    unit = tech_unit(20, {
      { "automation-science-pack", 1 },
    }, 15),
    effects = {
      unlock("crusher"),
      unlock("fw-crushed-iron-ore"),
      unlock("fw-crushed-copper-ore"),
      unlock("fw-sand"),
    },
    order = "a-b-c[fw-comminution]",
  },
  {
    type = "technology",
    name = "fw-ore-crushing",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-crushed-lead-ore.png",
    icon_size = 128,
    prerequisites = { "fw-comminution", "steel-processing" },
    unit = tech_unit(35, {
      { "automation-science-pack", 1 },
    }, 20),
    effects = {
      unlock("fw-crushed-lead-ore"),
      unlock("fw-crushed-titanium-ore"),
      unlock("lead-plate-from-crushed"),
      unlock("titanium-plate-from-crushed"),
    },
    order = "a-b-d[fw-ore-crushing]",
  },
  {
    type = "technology",
    name = "fw-mineral-beneficiation",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-bz-carbon-ore.png",
    icon_size = 128,
    prerequisites = { "fw-ore-crushing", "logistics" },
    unit = tech_unit(55, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
    }, 20),
    effects = {
      unlock("fw-carbon-refining"),
      unlock("fw-salt-from-water"),
      unlock("fw-metallic-beneficiation"),
      unlock("fw-silicon-beneficiation"),
    },
    order = "a-b-e[fw-mineral-beneficiation]",
  },
})

Tech:get("fw-comminution")
  :setCost(20)
  :setColors("R")
  :setTime(15)
  :setPrerequisites({ "automation" })

Tech:get("fw-ore-crushing")
  :setCost(35)
  :setColors("R")
  :setTime(20)
  :setPrerequisites({ "fw-comminution", "steel-processing" })

Tech:get("fw-mineral-beneficiation")
  :setCost(55)
  :setColors("RG")
  :setTime(20)
  :setPrerequisites({ "fw-ore-crushing", "logistics" })
