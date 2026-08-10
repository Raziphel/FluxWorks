local Tech = require("__razi_lib__/lib/technology")

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
    icon = "__space-age__/graphics/technology/advanced-asteroid-processing.png",
    icon_size = 256,
    prerequisites = { "automation", "steel-processing" },
    unit = tech_unit(16, {
      { "automation-science-pack", 1 },
    }, 12),
    effects = {
      unlock("crusher"),
      unlock("fw-silicon-beneficiation"),
    },
    order = "a-b-c[fw-comminution]",
  },
  {
    type = "technology",
    name = "fw-basic-separation",
    -- The three output streams make the purpose readable at research-tree scale:
    -- one mixed feed becomes several useful fractions.
    icon = "__base__/graphics/technology/advanced-oil-processing.png",
    icon_size = 256,
    prerequisites = { "sand-processing", "logistics" },
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
    icon_size = 256,
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
    icons = {
      {
        icon = "__base__/graphics/technology/advanced-material-processing-2.png",
        icon_size = 256,
      },
      {
        icon = "__base__/graphics/icons/iron-plate.png",
        icon_size = 64,
        scale = 1.1,
        shift = { -70, 70 },
      },
      {
        icon = "__base__/graphics/icons/copper-plate.png",
        icon_size = 64,
        scale = 1.1,
        shift = { 70, 70 },
      },
    },
    prerequisites = { "fw-ore-crushing", "steel-processing", "logistic-science-pack" },
    unit = tech_unit(32, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
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
    },
    order = "a-b-i[fw-mineral-beneficiation]",
  },
})

Tech:get("fw-comminution")
  :setCost(16)
  :setColors("R")
  :setTime(12)
  :setPrerequisites({ "automation", "steel-processing" })

Tech:get("fw-basic-separation")
  :setCost(18)
  :setColors("R")
  :setTime(15)
  :setPrerequisites({ "sand-processing", "logistics" })

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
  :setColors("RG")
  :setTime(18)
  :setPrerequisites({ "fw-ore-crushing", "steel-processing", "logistic-science-pack" })

Tech:get("fw-mineral-beneficiation")
  :setCost(40)
  :setColors("RG")
  :setTime(18)
  :setPrerequisites({ "fw-dense-ore-smelting", "fw-brine-processing", "logistics" })
