local function load_modules(modules)
  for _, module_name in ipairs(modules) do
    require(module_name)
  end
end

-- Load the public registration surface early. Dependent mods can require this
-- module from their own data stage; FluxWorks consumes registrations later.
require("prototypes.lib.compatibility-api")

-- Physical world and machines.
load_modules({
  "prototypes.resources.flux-rift-resource",
  "prototypes.resources.ores",
  "prototypes.resources.shattered-flux-vents",
  "prototypes.entities.flux-quarry",
  "prototypes.entities.flux-processing-machines",
  "prototypes.entities.flux-condenser",
  "prototypes.entities.late-utility",
  "prototypes.entities.expansion-machines",
  "prototypes.entities.advanced-expansion-machines",
})

-- Player-facing catalog and the core technology tree.
load_modules({
  "prototypes.items.crafting-tabs",
  "prototypes.items.advanced-materials",
  "prototypes.items.chemistry-materials",
  "prototypes.items.metal-plates",
  "prototypes.items.flux-systems",
  "prototypes.items.progression-components",
  "prototypes.items.expansion-systems",
  "prototypes.items.advanced-expansion-systems",
  "prototypes.technology.comminution",
  "prototypes.technology.flux-extraction",
  "prototypes.technology.flux-mining-productivity",
  "prototypes.technology.material-processing",
  "prototypes.technology.liquid-mining",
  "prototypes.technology.industrial-expansion",
  "prototypes.technology.flux-systems",
  "prototypes.technology.progression-components",
})

-- Fluids and manufacturing chains.
load_modules({
  "prototypes.fluids.fluids",
  "prototypes.fluids.chemistry-fluids",
  "prototypes.recipes.advanced-materials",
  "prototypes.recipes.chemistry-processes",
  "prototypes.recipes.industrial-processes",
  "prototypes.recipes.bonus-processes",
  "prototypes.recipes.metal-plates",
  "prototypes.recipes.transmutation-recipes",
  "prototypes.recipes.flux-systems",
  "prototypes.recipes.progression-components",
  "prototypes.recipes.expansion-processes",
  "prototypes.recipes.advanced-expansion-processes",
  "prototypes.recipes.space-age-symbiosis",
  "prototypes.recipes.shattered-campaign",
})

-- Late progression, compatibility prototypes, and data-stage presentation.
load_modules({
  "prototypes.technology.expansion-systems",
  "prototypes.technology.flux-bonuses",
  "prototypes.technology.advanced-expansion-systems",
  "prototypes.technology.space-age-symbiosis",
  "prototypes.technology.shattered-campaign",
  "prototypes.compat.aai-logistics",
  "prototypes.updates.starting-loadout",
  "prototypes.updates.shattered-planet",
  "prototypes.updates.rocket-reusability",
  "prototypes.updates.flux-asteroids",
  "prototypes.menu-branding",
})

-- Flux has dedicated pipe and tank logistics; auto-generated barrels would add
-- an unrelated vanilla item family to the crafting catalog.
for name, fluid in pairs(data.raw.fluid or {}) do
  if string.sub(name, 1, 3) == "fw-" then fluid.auto_barrel = false end
end
