local Tech = require("__haul_lib__/utils/tech")

local tech_path = "__FluxWorksAssets__/graphics/technology/"

data:extend({
  {
    type = "technology",
    name = "silica-processing",
    icon = tech_path .. "silica-processing.png",
    icon_size = 256,
    prerequisites = { "logistic-science-pack" },
    effects = {
      { type = "unlock-recipe", recipe = "silica" },
    },
    unit = {
      count = 20,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
      },
      time = 30,
    },
    order = "b-b",
  },
  {
    type = "technology",
    name = "silicon-processing",
    icon = tech_path .. "silicon-processing.png",
    icon_size = 256,
    prerequisites = { "silica-processing", "logistic-science-pack" },
    effects = {
      { type = "unlock-recipe", recipe = "silicon" },
      { type = "unlock-recipe", recipe = "silicon-wafer" },
    },
    unit = {
      count = 100,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
      },
      time = 30,
    },
    order = "b-c",
  },
  {
    type = "technology",
    name = "graphite-processing",
    icon = tech_path .. "graphite-processing.png",
    icon_size = 128,
    prerequisites = { "steam-power" },
    effects = {
      { type = "unlock-recipe", recipe = "graphite" },
    },
    unit = {
      count = 30,
      ingredients = {
        { "automation-science-pack", 1 },
      },
      time = 10,
    },
    order = "b-b",
  },
  {
    type = "technology",
    name = "diamond-processing",
    icon = tech_path .. "diamond-processing.png",
    icon_size = 128,
    prerequisites = { "advanced-material-processing-2", "graphite-processing", "chemical-science-pack" },
    effects = {
      { type = "unlock-recipe", recipe = "synthetic-diamond" },
      { type = "unlock-recipe", recipe = "diamond-processing" },
    },
    unit = {
      count = 100,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
      },
      time = 15,
    },
    order = "b-c",
  },
})

if data.raw.technology["automation"] then
  local automation = Tech:get("automation")
  local effects = automation.effects or {}
  local has_salt_unlock = false
  local has_silica_unlock = false

  for _, effect in pairs(effects) do
    if effect.type == "unlock-recipe" and effect.recipe == "fw-salt-from-water" then
      has_salt_unlock = true
    elseif effect.type == "unlock-recipe" and effect.recipe == "fw-silica" then
      has_silica_unlock = true
    end
  end

  if not has_salt_unlock then
    table.insert(effects, { type = "unlock-recipe", recipe = "fw-salt-from-water" })
  end
  if not has_silica_unlock then
    table.insert(effects, { type = "unlock-recipe", recipe = "fw-silica" })
  end

  automation:setEffects(effects)
end
