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
    name = "fw-isotope-conditioning",
    icon = "__base__/graphics/icons/centrifuge.png",
    icon_size = 64,
    prerequisites = { "fw-flux-metallurgy", "nuclear-power" },
    unit = tech_unit(520, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "utility-science-pack", 1 },
      { "space-science-pack", 1 },
    }, 40),
    effects = {
      unlock("fw-atomic-enricher"),
      unlock("fw-shielded-fuel-casing"),
      unlock("fw-fuel-pellet-bundle"),
      unlock("fw-moderator-lattice"),
      unlock("fw-isotope-matrix"),
      unlock("fw-reactor-instrument-cluster"),
      unlock("fw-reactor-grade-fuel-cell"),
    },
    order = "d-hc[fw-isotope-conditioning]",
  },
  {
    type = "technology",
    name = "fw-reactor-doping",
    icon = "__base__/graphics/icons/uranium-fuel-cell.png",
    icon_size = 64,
    prerequisites = { "fw-isotope-conditioning", "kovarex-enrichment-process", "fw-cryogenic-control" },
    unit = tech_unit(640, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "utility-science-pack", 1 },
      { "space-science-pack", 1 },
      { "cryogenic-science-pack", 1 },
    }, 44),
    effects = {
      unlock("fw-control-rod-assembly"),
      unlock("fw-reactor-coolant-cartridge"),
      unlock("fw-reactor-dopant"),
    },
    order = "d-hd[fw-reactor-doping]",
  },
  {
    type = "technology",
    name = "fw-actinide-recovery",
    icon = "__base__/graphics/icons/depleted-uranium-fuel-cell.png",
    icon_size = 64,
    prerequisites = { "fw-reactor-doping", "fw-electromagnetic-architecture" },
    unit = tech_unit(760, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "utility-science-pack", 1 },
      { "space-science-pack", 1 },
      { "cryogenic-science-pack", 1 },
      { "electromagnetic-science-pack", 1 },
    }, 48),
    effects = {
      unlock("fw-spent-fuel-reconditioning"),
      unlock("fw-radioactive-scrap-sorting"),
      unlock("fw-isotope-recovery"),
    },
    order = "d-he[fw-actinide-recovery]",
  },
  {
    type = "technology",
    name = "fw-reactor-instrumentation",
    icon = "__base__/graphics/technology/nuclear-power.png",
    icon_size = 256,
    prerequisites = { "fw-actinide-recovery", "fw-flux-resonance" },
    unit = tech_unit(900, {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "utility-science-pack", 1 },
      { "space-science-pack", 1 },
      { "cryogenic-science-pack", 1 },
      { "electromagnetic-science-pack", 1 },
    }, 52),
    effects = {
      unlock("fw-nuclear-fuel-overdrive"),
    },
    order = "d-hf[fw-reactor-instrumentation]",
  },
})
