local Recipe = require("__haul_lib__/utils/recipe")

local function ingredient_name(ingredient)
  return ingredient.name or ingredient[1]
end

local function add_unique_ingredient(ingredients, name, amount)
  for _, ingredient in pairs(ingredients or {}) do
    if ingredient_name(ingredient) == name then
      return ingredients
    end
  end
  table.insert(ingredients, { type = "item", name = name, amount = amount })
  return ingredients
end

local function patch_recipe_ingredients(recipe_name, name, amount)
  if not (data.raw.recipe and data.raw.recipe[recipe_name]) then
    return
  end

  local recipe = Recipe:get(recipe_name)
  local ingredients = recipe.ingredients or {}
  recipe:setIngredients(add_unique_ingredient(ingredients, name, amount))
end

local function patch_many_recipes(recipe_names, ingredient_name_value, amount)
  for _, recipe_name in ipairs(recipe_names) do
    patch_recipe_ingredients(recipe_name, ingredient_name_value, amount)
  end
end

local function patch_recipe_set(patches)
  for _, patch in ipairs(patches) do
    patch_recipe_ingredients(patch[1], patch[2], patch[3])
  end
end

local function remove_ingredient(ingredients, name)
  local filtered = {}
  for _, ingredient in pairs(ingredients or {}) do
    if ingredient_name(ingredient) ~= name then
      filtered[#filtered + 1] = ingredient
    end
  end
  return filtered
end

local function remove_recipe_ingredient(recipe_name, name)
  if not (data.raw.recipe and data.raw.recipe[recipe_name]) then
    return
  end

  local recipe = Recipe:get(recipe_name)
  recipe:setIngredients(remove_ingredient(recipe.ingredients or {}, name))
end

-- Targeted base-game integration
-- Keep green circuits early, but make red/blue circuits use the new electronics chain.
patch_recipe_set({
  { "electronic-circuit", "fw-circuit-contact", 1 },
  { "advanced-circuit", "fw-solder-wire", 1 },
  { "advanced-circuit", "fw-chip-carrier", 1 },
  { "advanced-circuit", "fw-microchip", 1 },
  { "processing-unit", "fw-microchip", 1 },
  { "processing-unit", "fw-memory-die", 1 },
  { "engine-unit", "fw-bearing", 1 },
  { "electric-engine-unit", "fw-bearing", 1 },
  { "flying-robot-frame", "fw-light-frame", 1 },
  { "low-density-structure", "fw-light-frame", 1 },
  { "battery", "fw-ceramic-insulator", 1 },
  { "accumulator", "fw-capacitor", 2 },
  { "firearm-magazine", "fw-gunpowder", 1 },
  { "piercing-rounds-magazine", "firearm-magazine", 1 },
  { "piercing-rounds-magazine", "fw-gunpowder", 1 },
  { "uranium-rounds-magazine", "piercing-rounds-magazine", 1 },
  { "uranium-rounds-magazine", "fw-gunpowder", 1 },
  { "lab", "fw-glass", 4 },
  { "lab", "fw-ceramic-insulator", 2 },
  { "biolab", "fw-glass", 20 },
  { "biolab", "fw-capacitor", 8 },
  { "fast-inserter", "fw-steel-beam", 1 },
  { "filter-inserter", "fw-steel-beam", 1 },
  { "stack-inserter", "fw-aluminum-beam", 1 },
  { "stack-filter-inserter", "fw-aluminum-beam", 1 },
  { "bulk-inserter", "fw-aluminum-beam", 1 },
  { "assembling-machine-2", "fw-steel-beam", 1 },
  { "assembling-machine-2", "fw-circuit-substrate", 1 },
  { "assembling-machine-3", "fw-aluminum-beam", 2 },
  { "assembling-machine-3", "fw-inductor-coil", 2 },
  { "electric-mining-drill", "fw-steel-beam", 1 },
  { "electric-furnace", "fw-composite-panel", 2 },
  { "electric-furnace", "fw-inductor-coil", 1 },
  { "medium-electric-pole", "fw-steel-beam", 1 },
  { "substation", "fw-aluminum-beam", 2 },
  { "substation", "fw-inductor-coil", 1 },
  { "radar", "fw-circuit-substrate", 2 },
  { "solar-panel", "fw-glass", 2 },
  { "solar-panel", "fw-copper-tube", 2 },
  { "laser-turret", "fw-capacitor", 1 },
  { "laser-turret", "fw-inductor-coil", 2 },
  { "speed-module", "fw-ribbon-cable", 1 },
  { "module", "fw-solder-wire", 1 },
  { "module", "fw-chip-carrier", 1 },
  { "speed-module", "fw-microchip", 1 },
  { "effectivity-module", "fw-ribbon-cable", 1 },
  { "productivity-module", "fw-sensor-package", 1 },
  { "productivity-module", "fw-memory-die", 1 },
  { "effectivity-module-2", "fw-microchip", 1 },
  { "productivity-module-2", "fw-memory-die", 1 },
  { "speed-module-3", "fw-memory-die", 1 },
  { "productivity-module-3", "fw-memory-die", 2 },
  { "quality-module", "fw-chip-carrier", 1 },
  { "quality-module-3", "fw-memory-die", 1 },
  { "chemical-plant", "fw-inline-filter", 1 },
  { "oil-refinery", "fw-inline-filter", 2 },
  { "pumpjack", "fw-inline-filter", 1 },
  { "beacon", "fw-transformer-core", 2 },
  { "beacon", "fw-sensor-package", 2 },
  { "roboport", "fw-ribbon-cable", 2 },
  { "substation", "fw-transformer-core", 1 },
  { "lab", "fw-glass-lens", 2 },
})

-- Broader base-game + Space Age integration.
patch_recipe_ingredients("rocket-silo", "fw-composite-panel", 6)
patch_recipe_ingredients("rocket-silo", "fw-transformer-core", 4)
patch_recipe_ingredients("satellite", "fw-glass-lens", 4)
patch_recipe_ingredients("satellite", "fw-sensor-package", 4)
patch_recipe_ingredients("fission-reactor", "fw-cermet", 8)
patch_recipe_ingredients("heat-pipe", "fw-cermet", 1)
patch_recipe_ingredients("centrifuge", "fw-inline-filter", 2)
patch_recipe_ingredients("nuclear-reactor", "fw-cermet", 8)
patch_recipe_ingredients("rocket-fuel", "fw-inline-filter", 1)
patch_recipe_ingredients("utility-science-pack", "fw-sensor-package", 1)
patch_recipe_ingredients("production-science-pack", "fw-cermet", 1)

-- Space Age production chains
patch_recipe_ingredients("electromagnetic-plant", "fw-transformer-core", 4)
patch_recipe_ingredients("electromagnetic-plant", "fw-ribbon-cable", 6)
patch_recipe_ingredients("electromagnetic-plant", "fw-sensor-package", 4)
patch_recipe_ingredients("electromagnetic-plant", "fw-memory-die", 2)
patch_recipe_ingredients("foundry", "fw-cermet", 8)
patch_recipe_ingredients("foundry", "fw-composite-panel", 4)
patch_recipe_ingredients("recycler", "fw-inline-filter", 3)
patch_recipe_ingredients("recycler", "fw-cermet", 2)
patch_recipe_ingredients("biochamber", "fw-inline-filter", 2)
patch_recipe_ingredients("cryogenic-plant", "fw-transformer-core", 4)
patch_recipe_ingredients("cryogenic-plant", "fw-cermet", 4)
patch_recipe_ingredients("cryogenic-plant", "fw-memory-die", 1)

patch_recipe_ingredients("supercapacitor", "fw-capacitor", 2)
patch_recipe_ingredients("supercapacitor", "fw-ribbon-cable", 2)
patch_recipe_ingredients("superconductor", "fw-ribbon-cable", 2)
patch_recipe_ingredients("superconductor", "fw-cermet", 1)
patch_recipe_ingredients("quantum-processor", "fw-sensor-package", 2)
patch_recipe_ingredients("quantum-processor", "fw-glass-lens", 2)
patch_recipe_ingredients("quantum-processor", "fw-ribbon-cable", 2)
patch_recipe_ingredients("quantum-processor", "fw-memory-die", 2)
patch_recipe_ingredients("holmium-plate", "fw-inline-filter", 1)
patch_recipe_ingredients("tungsten-carbide", "fw-cermet", 1)
patch_recipe_ingredients("carbon-fiber", "fw-inline-filter", 1)
patch_recipe_ingredients("carbon-fiber", "fw-composite-panel", 1)

patch_recipe_ingredients("space-platform-foundation", "fw-composite-panel", 4)
patch_recipe_ingredients("space-platform-foundation", "fw-cermet", 2)
patch_recipe_ingredients("space-platform-starter-pack", "fw-transformer-core", 3)
patch_recipe_ingredients("space-platform-starter-pack", "fw-sensor-package", 3)
patch_recipe_ingredients("space-platform-starter-pack", "fw-memory-die", 2)
patch_recipe_ingredients("space-platform-starter-pack", "fw-rocket-engine", 2)
patch_recipe_ingredients("asteroid-collector", "fw-inline-filter", 2)
patch_recipe_ingredients("asteroid-collector", "fw-cermet", 2)
patch_recipe_ingredients("crusher", "fw-cermet", 2)
patch_recipe_ingredients("cargo-landing-pad", "fw-composite-panel", 4)
patch_recipe_ingredients("cargo-bay", "fw-inline-filter", 2)
patch_recipe_ingredients("thruster", "fw-cermet", 2)
patch_recipe_ingredients("thruster", "fw-rocket-engine", 2)
patch_recipe_ingredients("space-platform-hub", "fw-transformer-core", 2)
patch_recipe_ingredients("space-platform-hub", "fw-memory-die", 2)
patch_recipe_ingredients("space-platform-hub", "fw-rocket-engine", 1)

patch_recipe_ingredients("electromagnetic-science-pack", "fw-sensor-package", 1)
patch_recipe_ingredients("metallurgic-science-pack", "fw-cermet", 1)
patch_recipe_ingredients("agricultural-science-pack", "fw-inline-filter", 1)
patch_recipe_ingredients("cryogenic-science-pack", "fw-glass-lens", 1)
patch_recipe_ingredients("promethium-science-pack", "fw-transformer-core", 1)

-- Resource-driven integration pass: lead for fluid systems, titanium for high-tier structures.
patch_recipe_ingredients("pipe-to-ground", "lead-plate", 2)
patch_recipe_ingredients("storage-tank", "lead-plate", 4)
patch_recipe_ingredients("pump", "lead-plate", 2)
patch_recipe_ingredients("chemical-plant", "lead-plate", 2)
patch_recipe_ingredients("oil-refinery", "lead-plate", 4)

patch_recipe_ingredients("heat-exchanger", "titanium-plate", 4)
patch_recipe_ingredients("heat-pipe", "titanium-plate", 1)
patch_recipe_ingredients("centrifuge", "titanium-plate", 4)
patch_recipe_ingredients("nuclear-reactor", "titanium-plate", 12)
patch_recipe_ingredients("rocket-silo", "titanium-plate", 20)
patch_recipe_ingredients("satellite", "titanium-plate", 8)
patch_recipe_ingredients("beacon", "titanium-plate", 6)
patch_recipe_ingredients("fusion-reactor-equipment", "titanium-plate", 20)
patch_recipe_ingredients("power-armor-mk2", "titanium-plate", 30)
patch_recipe_ingredients("fusion-reactor-equipment", "fw-rocket-engine", 2)
patch_recipe_ingredients("power-armor-mk2", "fw-rocket-engine", 2)

patch_recipe_ingredients("space-platform-foundation", "titanium-plate", 4)
patch_recipe_ingredients("thruster", "titanium-plate", 6)
patch_recipe_ingredients("space-platform-hub", "titanium-plate", 8)
patch_recipe_ingredients("cargo-landing-pad", "titanium-plate", 8)
patch_recipe_ingredients("asteroid-collector", "titanium-plate", 4)
patch_recipe_ingredients("electromagnetic-plant", "titanium-plate", 6)
patch_recipe_ingredients("cryogenic-plant", "titanium-plate", 6)

-- Additional material-chain rebalance: use refined products in component recipes.
patch_recipe_set({
  { "electronic-circuit", "silicon", 1 },
  { "advanced-circuit", "silicon", 1 },
  { "processing-unit", "silicon", 1 },
  { "solar-panel", "silicon", 2 },
  { "accumulator", "silicon", 1 },
  { "battery", "lead-plate", 1 },
  { "explosives", "fw-salt", 1 },
  { "grenade", "tin-plate", 1 },
  { "cluster-grenade", "tin-plate", 2 },
  { "rocket", "tin-plate", 1 },
  { "explosive-rocket", "tin-plate", 1 },
  { "firearm-magazine", "tin-plate", 1 },
  { "piercing-rounds-magazine", "tin-plate", 1 },
  { "uranium-rounds-magazine", "tin-plate", 1 },
  { "engine-unit", "lead-plate", 1 },
  { "electric-engine-unit", "lead-plate", 1 },
  { "pumpjack", "lead-plate", 2 },
  { "offshore-pump", "lead-plate", 2 },
  { "pump", "electronic-circuit", 1 },
  { "offshore-pump", "electronic-circuit", 2 },
  { "laser-turret", "silicon", 2 },
  { "flamethrower-turret", "lead-plate", 6 },
  { "artillery-turret", "titanium-plate", 12 },
  { "rocket-silo", "silicon", 16 },
  { "thruster", "silicon", 6 },
  { "space-platform-hub", "silicon", 6 },
  { "space-platform-foundation", "lead-plate", 4 },
  { "cargo-landing-pad", "lead-plate", 6 },
  { "electromagnetic-plant", "silicon", 8 },
  { "quantum-processor", "silicon", 4 },
  { "superconductor", "silicon", 2 },
  { "carbon-fiber", "carbon", 2 },
  { "plastic-bar", "carbon", 1 },
})

-- Wide integration pass across base game + Space Age surfaces.
patch_many_recipes({
  "fast-transport-belt",
  "express-transport-belt",
  "turbo-transport-belt",
  "fast-underground-belt",
  "express-underground-belt",
  "turbo-underground-belt",
  "fast-splitter",
  "express-splitter",
  "turbo-splitter",
}, "fw-steel-beam", 1)

patch_many_recipes({
  "bulk-inserter",
  "stack-inserter",
  "stack-filter-inserter",
  "filter-inserter",
}, "fw-circuit-substrate", 1)

patch_many_recipes({
  "assembling-machine-2",
  "assembling-machine-3",
  "electric-furnace",
  "recycler",
  "crusher",
  "foundry",
}, "fw-composite-panel", 1)

patch_many_recipes({
  "laser-turret",
  "flamethrower-turret",
  "artillery-turret",
  "tank",
  "car",
}, "fw-cermet", 2)

patch_many_recipes({
  "locomotive",
  "cargo-wagon",
  "fluid-wagon",
  "artillery-wagon",
  "train-stop",
  "rail-signal",
  "rail-chain-signal",
  "rail",
  "rail-ramp",
  "rail-support",
}, "fw-steel-beam", 1)

patch_many_recipes({
  "steam-engine",
  "steam-turbine",
  "medium-electric-pole",
  "big-electric-pole",
  "substation",
}, "fw-transformer-core", 1)

patch_many_recipes({
  "chemical-plant",
  "oil-refinery",
  "centrifuge",
  "pumpjack",
  "offshore-pump",
  "electrolyser",
  "cryogenic-plant",
  "biochamber",
}, "fw-inline-filter", 1)

patch_many_recipes({
  "electric-engine-unit",
  "flying-robot-frame",
  "construction-robot",
  "logistic-robot",
  "roboport",
  "beacon",
  "radar",
}, "fw-sensor-package", 1)

patch_many_recipes({
  "module",
  "speed-module",
  "effectivity-module",
  "productivity-module",
  "quality-module",
  "speed-module-2",
  "effectivity-module-2",
  "productivity-module-2",
  "quality-module-2",
  "speed-module-3",
  "effectivity-module-3",
  "productivity-module-3",
  "quality-module-3",
  "processing-unit",
  "quantum-processor",
}, "fw-memory-die", 1)

patch_many_recipes({
  "automation-science-pack",
  "logistic-science-pack",
  "military-science-pack",
  "chemical-science-pack",
  "production-science-pack",
  "utility-science-pack",
  "space-science-pack",
  "metallurgic-science-pack",
  "electromagnetic-science-pack",
  "agricultural-science-pack",
  "cryogenic-science-pack",
  "promethium-science-pack",
}, "fw-glass-lens", 1)

patch_many_recipes({
  "rocket-silo",
  "satellite",
  "space-platform-foundation",
  "space-platform-starter-pack",
  "thruster",
  "space-platform-hub",
  "cargo-landing-pad",
  "asteroid-collector",
}, "fw-rocket-engine", 1)

-- Space Age deep integration pass: orbital hardware and late-game planetary systems.
patch_many_recipes({
  "thruster",
  "space-platform-hub",
  "space-platform-starter-pack",
  "cargo-landing-pad",
  "asteroid-collector",
  "cargo-bay",
}, "fw-rocket-avionics", 1)

patch_many_recipes({
  "thruster",
  "space-platform-hub",
  "space-platform-starter-pack",
  "space-platform-foundation",
  "cargo-landing-pad",
}, "fw-rocket-heatshield", 1)

patch_many_recipes({
  "electromagnetic-science-pack",
  "metallurgic-science-pack",
  "agricultural-science-pack",
  "cryogenic-science-pack",
  "promethium-science-pack",
}, "fw-capacitor", 1)

patch_many_recipes({
  "fusion-generator",
  "fusion-reactor",
  "fusion-reactor-equipment",
  "power-armor-mk2",
}, "fw-transformer-core", 2)

patch_many_recipes({
  "fusion-generator",
  "fusion-reactor",
  "fusion-reactor-equipment",
  "power-armor-mk2",
}, "fw-cermet", 2)

patch_many_recipes({
  "biolab",
  "electromagnetic-plant",
  "cryogenic-plant",
  "foundry",
  "recycler",
  "crusher",
}, "fw-sensor-package", 1)

-- Extra-wide integration pass: intermediates, combat, logistics, and utility.
patch_many_recipes({
  "electronic-circuit",
  "advanced-circuit",
  "processing-unit",
  "module",
  "speed-module",
  "effectivity-module",
  "productivity-module",
  "quality-module",
}, "fw-circuit-contact", 1)

patch_many_recipes({
  "small-electric-pole",
  "medium-electric-pole",
  "big-electric-pole",
  "substation",
  "power-switch",
  "programmable-speaker",
  "arithmetic-combinator",
  "decider-combinator",
  "constant-combinator",
  "selector-combinator",
}, "fw-copper-tube", 1)

patch_many_recipes({
  "steel-furnace",
  "electric-furnace",
  "assembling-machine-2",
  "assembling-machine-3",
  "chemical-plant",
  "oil-refinery",
  "centrifuge",
  "lab",
}, "fw-steel-beam", 1)

patch_many_recipes({
  "storage-tank",
  "pump",
  "offshore-pump",
  "pipe-to-ground",
  "heat-exchanger",
  "heat-pipe",
  "steam-engine",
  "steam-turbine",
}, "fw-inline-filter", 1)

patch_many_recipes({
  "repair-pack",
  "radar",
  "beacon",
  "roboport",
  "construction-robot",
  "logistic-robot",
  "personal-roboport-equipment",
  "personal-roboport-mk2-equipment",
}, "fw-solder-wire", 1)

patch_many_recipes({
  "logistic-chest-active-provider",
  "logistic-chest-passive-provider",
  "logistic-chest-storage",
  "logistic-chest-buffer",
  "logistic-chest-requester",
  "requester-chest",
  "buffer-chest",
}, "fw-chip-carrier", 1)

patch_many_recipes({
  "gate",
  "wall",
  "stone-wall",
  "laser-turret",
  "flamethrower-turret",
  "artillery-turret",
  "land-mine",
}, "fw-cermet", 1)

patch_many_recipes({
  "grenade",
  "cluster-grenade",
  "rocket",
  "explosive-rocket",
  "cannon-shell",
  "explosive-cannon-shell",
  "shotgun-shell",
  "piercing-shotgun-shell",
  "firearm-magazine",
  "piercing-rounds-magazine",
  "uranium-rounds-magazine",
}, "fw-gunpowder", 1)

-- Keep early bullet ammo practical: basic magazines should only pick up the
-- gunpowder layer instead of extra FluxWorks metalwork.
remove_recipe_ingredient("firearm-magazine", "tin-plate")

patch_many_recipes({
  "defender-capsule",
  "distractor-capsule",
  "destroyer-capsule",
  "poison-capsule",
  "slowdown-capsule",
  "cliff-explosives",
}, "fw-sensor-package", 1)

patch_many_recipes({
  "locomotive",
  "cargo-wagon",
  "fluid-wagon",
  "artillery-wagon",
  "rail",
  "rail-ramp",
  "rail-support",
  "rail-signal",
  "rail-chain-signal",
  "train-stop",
}, "fw-aluminum-beam", 1)

patch_many_recipes({
  "pumpjack",
  "centrifuge",
  "electrolyser",
  "electromagnetic-plant",
  "cryogenic-plant",
  "foundry",
  "biochamber",
  "recycler",
  "crusher",
}, "fw-transformer-core", 1)

patch_many_recipes({
  "accumulator",
  "fusion-generator",
  "fusion-reactor",
  "fusion-reactor-equipment",
  "battery-mk2-equipment",
  "exoskeleton-equipment",
  "energy-shield-mk2-equipment",
}, "fw-capacitor", 1)

patch_many_recipes({
  "power-armor",
  "power-armor-mk2",
  "modular-armor",
  "mech-armor",
  "night-vision-equipment",
  "belt-immunity-equipment",
  "battery-equipment",
  "battery-mk2-equipment",
}, "fw-composite-panel", 1)

patch_many_recipes({
  "space-platform-starter-pack",
  "space-platform-foundation",
  "thruster",
  "space-platform-hub",
  "asteroid-collector",
  "cargo-bay",
  "cargo-landing-pad",
}, "fw-light-frame", 1)
