local Recipe = require("__haul_lib__/utils/recipe")
local Startup = require("prototypes.lib.startup-settings")

if not Startup.enabled("fw-enable-recipe-integration", true) then
  return
end

local enable_science_pack_overhaul = Startup.enabled("fw-enable-science-pack-overhaul", true)
local enable_core_material_replacements = Startup.enabled("fw-enable-core-material-replacements", true)
local enable_combat_recipe_integration = Startup.enabled("fw-enable-combat-recipe-integration", true)
local enable_orbital_and_planetary_integration = Startup.enabled("fw-enable-orbital-and-planetary-integration", true)
local enable_machine_part_rehoming = Startup.enabled("fw-enable-machine-part-rehoming", true)

local function ingredient_name(ingredient)
  return ingredient.name or ingredient[1]
end

local patch_recipe_ingredient_spec

local function clone_ingredient(spec)
  if spec.type or spec.name then
    return table.deepcopy(spec)
  end

  return {
    type = "item",
    name = spec[1],
    amount = spec[2],
  }
end

local function add_unique_ingredient(ingredients, spec)
  local new_ingredient = clone_ingredient(spec)
  for _, ingredient in pairs(ingredients or {}) do
    if ingredient_name(ingredient) == new_ingredient.name then
      return ingredients
    end
  end
  table.insert(ingredients, new_ingredient)
  return ingredients
end

local function patch_recipe_ingredients(recipe_name, name, amount)
  patch_recipe_ingredient_spec(recipe_name, { type = "item", name = name, amount = amount })
end

patch_recipe_ingredient_spec = function(recipe_name, ingredient_spec)
  if not (data.raw.recipe and data.raw.recipe[recipe_name]) then
    return
  end

  local recipe = Recipe:get(recipe_name)
  local ingredients = recipe.ingredients or {}
  recipe:setIngredients(add_unique_ingredient(ingredients, ingredient_spec))
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

local function replace_recipe_ingredient(recipe_name, old_name, new_spec)
  if not (data.raw.recipe and data.raw.recipe[recipe_name]) then
    return
  end

  local recipe = Recipe:get(recipe_name)
  local ingredients = remove_ingredient(recipe.ingredients or {}, old_name)
  recipe:setIngredients(add_unique_ingredient(ingredients, new_spec))
end

local function replace_many_recipe_ingredients(recipe_names, old_name, new_spec)
  for _, recipe_name in ipairs(recipe_names) do
    replace_recipe_ingredient(recipe_name, old_name, new_spec)
  end
end

local function set_recipe_category(recipe_name, category)
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if not recipe then
    return
  end

  recipe.category = category
  if recipe.normal then
    recipe.normal.category = category
  end
  if recipe.expensive then
    recipe.expensive.category = category
  end
end

local function set_recipe_subgroup(recipe_name, subgroup)
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if not recipe then
    return
  end

  recipe.subgroup = subgroup
  if recipe.normal then
    recipe.normal.subgroup = subgroup
  end
  if recipe.expensive then
    recipe.expensive.subgroup = subgroup
  end
end

-- Start with the obvious stuff.
-- Green circuits stay mostly normal. Red/blue chips get dragged into our goofy little electronics ladder.
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
  { "lab", "fw-glass-lens", 2 },
})

-- Now do the wider "yeah this should probably use our parts" pass.
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
replace_recipe_ingredient("flamethrower-ammo", "crude-oil", { type = "fluid", name = "fw-napalm", amount = 40 })

-- Space Age gets the same treatment. No free pass just because it is in space.
if enable_orbital_and_planetary_integration then
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
end

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
  { "flying-robot-frame", "aluminum-plate", 2 },
  { "low-density-structure", "aluminum-plate", 2 },
  { "roboport", "aluminum-plate", 4 },
  { "personal-roboport-equipment", "aluminum-plate", 4 },
  { "exoskeleton-equipment", "aluminum-plate", 8 },
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
  { "personal-roboport-mk2-equipment", "titanium-plate", 8 },
  { "spidertron", "titanium-plate", 20 },
  { "railgun", "titanium-plate", 12 },
  { "railgun-turret", "titanium-plate", 20 },
  { "rocket-silo", "silicon", 16 },
  { "thruster", "silicon", 6 },
  { "space-platform-hub", "silicon", 6 },
  { "space-platform-foundation", "lead-plate", 4 },
  { "cargo-landing-pad", "lead-plate", 6 },
  { "electromagnetic-plant", "silicon", 8 },
  { "quantum-processor", "silicon", 4 },
  { "superconductor", "silicon", 2 },
  { "railgun", "silicon", 6 },
  { "carbon-fiber", "carbon", 2 },
  { "plastic-bar", "carbon", 1 },
})

-- Small coherence pass for chemistry and fire-control surfaces.
if enable_combat_recipe_integration then
  remove_recipe_ingredient("poison-capsule", "fw-sensor-package")
  remove_recipe_ingredient("slowdown-capsule", "fw-sensor-package")
  remove_recipe_ingredient("cliff-explosives", "fw-sensor-package")
end

patch_recipe_set({
  { "flamethrower-turret", "fw-flow-regulator", 1 },
  { "electrolyte", "fw-resin", 1 },
  { "electrolyte", "fw-inline-filter", 1 },
  { "lithium", "fw-inline-filter", 1 },
  { "lithium", "fw-sensor-diode", 1 },
  { "fluoroketone", "fw-thermal-buffer", 1 },
  { "fluoroketone", "fw-flow-regulator", 1 },
  { "fluoroketone-cooling", "fw-cryo-coil", 1 },
  { "superconductor", "fw-rubber-sheet", 1 },
  { "superconductor", "fw-cryo-coil", 1 },
  { "supercapacitor", "fw-power-regulator", 1 },
  { "supercapacitor", "fw-coil-block", 1 },
  { "fusion-power-cell", "fw-thermal-buffer", 1 },
  { "fusion-power-cell", "fw-power-regulator", 1 },
  { "fission-reactor-equipment", "fw-pressure-housing", 2 },
  { "fission-reactor-equipment", "fw-flow-regulator", 1 },
  { "battery-mk2-equipment", "fw-power-regulator", 1 },
  { "battery-mk2-equipment", "fw-capacitor", 2 },
})

if enable_combat_recipe_integration then
  patch_recipe_set({
    { "poison-capsule", "fw-spore-filter", 1 },
    { "slowdown-capsule", "fw-resin", 1 },
  })
end

for _, patch in ipairs({
  { "electrolyte", "fw-yellow-flux", 8 },
  { "lithium", "fw-yellow-flux", 12 },
  { "fluoroketone", "fw-red-flux", 18 },
  { "fluoroketone-cooling", "fw-green-flux", 10 },
}) do
  patch_recipe_ingredient_spec(patch[1], { type = "fluid", name = patch[2], amount = patch[3] })
end

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

if enable_combat_recipe_integration then
  patch_many_recipes({
    "laser-turret",
    "flamethrower-turret",
    "artillery-turret",
    "tank",
    "car",
  }, "fw-cermet", 2)
end

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
if enable_orbital_and_planetary_integration then
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
end

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

if enable_combat_recipe_integration then
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

  -- Do not make the first ammo tier annoying for no reason.
  -- It just wants the gunpowder bit, not a whole side quest in metal parts.
  remove_recipe_ingredient("firearm-magazine", "tin-plate")

  patch_many_recipes({
    "defender-capsule",
    "distractor-capsule",
    "destroyer-capsule",
    "poison-capsule",
    "slowdown-capsule",
    "cliff-explosives",
  }, "fw-sensor-package", 1)
end

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

-- Science was getting a little "throw every shiny part in the blender."
-- This pulls it back into more deliberate lanes.
if enable_science_pack_overhaul then
  local all_science_packs = {
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
  }

  local late_space_science_packs = {
    "metallurgic-science-pack",
    "electromagnetic-science-pack",
    "agricultural-science-pack",
    "cryogenic-science-pack",
    "promethium-science-pack",
  }

  for _, recipe_name in ipairs(all_science_packs) do
    remove_recipe_ingredient(recipe_name, "fw-glass-lens")
  end

  for _, recipe_name in ipairs(late_space_science_packs) do
    remove_recipe_ingredient(recipe_name, "fw-capacitor")
  end

  remove_recipe_ingredient("automation-science-pack", "copper-plate")
  remove_recipe_ingredient("logistic-science-pack", "lead-plate")
  remove_recipe_ingredient("military-science-pack", "fw-gunpowder")
  remove_recipe_ingredient("chemical-science-pack", "fw-bearing")
  remove_recipe_ingredient("chemical-science-pack", "fw-solder-wire")
  remove_recipe_ingredient("production-science-pack", "fw-cermet")
  remove_recipe_ingredient("production-science-pack", "fw-coil-block")
  remove_recipe_ingredient("utility-science-pack", "fw-sensor-package")
  remove_recipe_ingredient("utility-science-pack", "fw-memory-die")
  remove_recipe_ingredient("space-science-pack", "fw-light-frame")
  remove_recipe_ingredient("space-science-pack", "fw-logic-matrix")
  remove_recipe_ingredient("metallurgic-science-pack", "fw-cermet")
  remove_recipe_ingredient("metallurgic-science-pack", "fw-smelter-array")
  remove_recipe_ingredient("metallurgic-science-pack", "fw-annealed-cermet")
  remove_recipe_ingredient("metallurgic-science-pack", "fw-vulcanus-slag-cermet")
  remove_recipe_ingredient("metallurgic-science-pack", "fw-pressure-housing")
  remove_recipe_ingredient("electromagnetic-science-pack", "fw-sensor-package")
  remove_recipe_ingredient("electromagnetic-science-pack", "fw-em-core")
  remove_recipe_ingredient("electromagnetic-science-pack", "fw-fulgora-static-mesh")
  remove_recipe_ingredient("electromagnetic-science-pack", "fw-coil-block")
  remove_recipe_ingredient("agricultural-science-pack", "fw-inline-filter")
  remove_recipe_ingredient("agricultural-science-pack", "fw-spore-filter")
  remove_recipe_ingredient("agricultural-science-pack", "fw-nutrient-bed")
  remove_recipe_ingredient("agricultural-science-pack", "fw-gleba-spore-resin")
  remove_recipe_ingredient("cryogenic-science-pack", "fw-glass-lens")
  remove_recipe_ingredient("cryogenic-science-pack", "fw-thermal-buffer")
  remove_recipe_ingredient("cryogenic-science-pack", "fw-cryo-coil")
  remove_recipe_ingredient("cryogenic-science-pack", "fw-aquilo-cryogel")
  remove_recipe_ingredient("cryogenic-science-pack", "fw-power-regulator")
  remove_recipe_ingredient("promethium-science-pack", "fw-transformer-core")
  remove_recipe_ingredient("promethium-science-pack", "promethium-asteroid-chunk")
  remove_recipe_ingredient("promethium-science-pack", "fw-promethium-primer")
  remove_recipe_ingredient("promethium-science-pack", "fw-promethium-matrix")
  remove_recipe_ingredient("promethium-science-pack", "fw-rift-stabilizer")
  remove_recipe_ingredient("promethium-science-pack", "fw-logic-matrix")

  replace_recipe_ingredient("automation-science-pack", "copper-plate", { type = "item", name = "tin-plate", amount = 1 })
  replace_recipe_ingredient("military-science-pack", "stone-wall", { type = "item", name = "stone-wall", amount = 1 })
  replace_recipe_ingredient("space-science-pack", "carbon", { type = "item", name = "fw-carbon", amount = 1 })
  replace_recipe_ingredient("promethium-science-pack", "quantum-processor", { type = "item", name = "fw-logic-matrix", amount = 1 })

  patch_recipe_set({
    { "automation-science-pack", "lead-plate", 1 },
    { "logistic-science-pack", "lead-plate", 1 },
    { "military-science-pack", "fw-gunpowder", 1 },
    { "chemical-science-pack", "fw-bearing", 1 },
    { "chemical-science-pack", "fw-solder-wire", 2 },
    { "production-science-pack", "fw-pressure-housing", 1 },
    { "production-science-pack", "fw-coil-block", 1 },
    { "utility-science-pack", "fw-capacitor", 1 },
    { "utility-science-pack", "fw-memory-die", 1 },
    { "space-science-pack", "fw-light-frame", 1 },
    { "metallurgic-science-pack", "fw-cermet", 1 },
    { "metallurgic-science-pack", "fw-steel-beam", 1 },
    { "metallurgic-science-pack", "fw-pressure-housing", 1 },
    { "electromagnetic-science-pack", "fw-sensor-diode", 1 },
    { "electromagnetic-science-pack", "fw-power-regulator", 1 },
    { "electromagnetic-science-pack", "fw-coil-block", 1 },
    { "agricultural-science-pack", "fw-inline-filter", 1 },
    { "agricultural-science-pack", "fw-resin", 1 },
    { "cryogenic-science-pack", "fw-flow-regulator", 1 },
    { "cryogenic-science-pack", "fw-power-regulator", 1 },
    { "promethium-science-pack", "promethium-asteroid-chunk", 8 },
    { "promethium-science-pack", "fw-aquilo-cryogel", 1 },
    { "promethium-science-pack", "fw-gleba-spore-resin", 1 },
    { "promethium-science-pack", "fw-fulgora-static-mesh", 1 },
    { "promethium-science-pack", "fw-vulcanus-slag-cermet", 1 },
    { "promethium-science-pack", "fw-flux-resonance-cell", 1 },
    { "promethium-science-pack", "fw-flux-phase-manifold", 1 },
  })
end

-- Sneak the staged parts into machines where they actually make sense.
patch_recipe_set({
  { "lab", "fw-lens-array", 1 },
  { "radar", "fw-sensor-diode", 1 },
  { "crusher", "fw-harvester-head", 1 },
  { "big-mining-drill", "fw-harvester-head", 2 },
  { "asteroid-collector", "fw-harvester-head", 1 },
  { "substation", "fw-power-regulator", 1 },
  { "electric-furnace", "fw-annealed-cermet", 1 },
  { "foundry", "fw-foundry-lining", 1 },
  { "foundry", "fw-annealed-cermet", 1 },
  { "biochamber", "fw-nutrient-bed", 1 },
  { "cryogenic-plant", "fw-cryo-coil", 1 },
  { "electromagnetic-plant", "fw-em-core", 1 },
  { "fw-flux-condenser", "fw-power-regulator", 2 },
  { "fw-flux-condenser", "fw-resonance-substrate", 2 },
  { "fw-flux-resonance-cell", "fw-field-winding", 1 },
  { "fw-flux-phase-manifold", "fw-em-core", 1 },
  { "fw-flux-metallic-synthesis", "fw-thermal-buffer", 1 },
})

-- A bunch of late parts were still pretending hand crafting was fine.
-- No thanks. These belong to the real machine lanes now.
if enable_machine_part_rehoming then
  for _, recipe_name in ipairs({
    "fw-field-winding",
    "fw-spore-filter",
    "fw-cryo-coil",
    "fw-thermal-buffer",
    "fw-em-core",
    "fw-logic-matrix",
    "fw-rift-stabilizer",
  }) do
    set_recipe_category(recipe_name, "fw-flux-synthesis")
  end

  patch_recipe_set({
    { "fw-field-winding", "fw-power-regulator", 1 },
    { "fw-field-winding", "fw-signal-conduit", 1 },
    { "fw-spore-filter", "fw-sensor-diode", 1 },
    { "fw-cryo-coil", "fw-power-regulator", 1 },
    { "fw-thermal-buffer", "fw-pressure-housing", 1 },
    { "fw-em-core", "fw-resonance-substrate", 1 },
    { "fw-logic-matrix", "fw-resonance-substrate", 1 },
    { "fw-logic-matrix", "fw-sensor-diode", 1 },
    { "fw-rift-stabilizer", "fw-power-regulator", 1 },
    { "fw-harvester-head", "fw-coil-block", 1 },
    { "fw-harvester-head", "fw-signal-conduit", 1 },
    { "fw-resonance-substrate", "fw-lens-array", 1 },
    { "fw-condensed-flux-matrix", "fw-coil-block", 1 },
    { "fw-flux-phase-manifold", "fw-field-winding", 1 },
    { "fw-flux-phase-manifold", "fw-logic-matrix", 1 },
    { "fw-promethium-primer", "fw-lens-array", 1 },
    { "fw-promethium-primer", "fw-signal-conduit", 1 },
    { "fw-promethium-matrix", "fw-logic-matrix", 1 },
  })

  for _, recipe_name in ipairs({
    "fw-condensed-flux-matrix",
    "fw-flux-phase-manifold",
  }) do
    set_recipe_category(recipe_name, "fw-flux-condensing")
    set_recipe_subgroup(recipe_name, "fw-flux-condensing-core")
  end

  for _, recipe_name in ipairs({
    "fw-promethium-primer",
    "fw-promethium-matrix",
    "fw-rift-stabilizer",
  }) do
    set_recipe_category(recipe_name, "fw-flux-condensing")
    set_recipe_subgroup(recipe_name, "fw-flux-condensing-promethium")
  end

  for _, patch in ipairs({
    { "fw-condensed-flux-matrix", "fw-purple-flux", 48 },
    { "fw-condensed-flux-matrix", "fw-yellow-flux", 36 },
    { "fw-condensed-flux-matrix", "fw-red-flux", 72 },
    { "fw-condensed-flux-matrix", "fw-green-flux", 24 },
    { "fw-flux-phase-manifold", "fw-purple-flux", 120 },
    { "fw-flux-phase-manifold", "fw-yellow-flux", 80 },
    { "fw-flux-phase-manifold", "fw-red-flux", 160 },
    { "fw-flux-phase-manifold", "fw-green-flux", 32 },
    { "fw-promethium-primer", "fw-purple-flux", 24 },
    { "fw-promethium-primer", "fw-yellow-flux", 18 },
    { "fw-promethium-primer", "fw-red-flux", 36 },
    { "fw-promethium-primer", "fw-green-flux", 12 },
    { "fw-promethium-matrix", "fw-purple-flux", 48 },
    { "fw-promethium-matrix", "fw-yellow-flux", 40 },
    { "fw-promethium-matrix", "fw-red-flux", 60 },
    { "fw-promethium-matrix", "fw-green-flux", 24 },
    { "fw-rift-stabilizer", "fw-purple-flux", 90 },
    { "fw-rift-stabilizer", "fw-yellow-flux", 60 },
    { "fw-rift-stabilizer", "fw-red-flux", 90 },
    { "fw-rift-stabilizer", "fw-green-flux", 50 },
  }) do
    patch_recipe_ingredient_spec(patch[1], { type = "fluid", name = patch[2], amount = patch[3] })
  end
end

-- Time to back off a little.
-- We still want the FluxWorks flavor, just not smeared on absolutely everything.
for _, recipe_name in ipairs({
  "steam-engine",
  "steam-turbine",
  "pumpjack",
  "centrifuge",
  "electrolyser",
  "electromagnetic-plant",
  "cryogenic-plant",
  "foundry",
  "biochamber",
  "recycler",
  "crusher",
  "fusion-generator",
  "fusion-reactor",
  "fusion-reactor-equipment",
  "power-armor-mk2",
  "rocket-silo",
  "space-platform-starter-pack",
  "space-platform-hub",
}) do
  remove_recipe_ingredient(recipe_name, "fw-transformer-core")
end

for _, recipe_name in ipairs({
  "electric-engine-unit",
  "flying-robot-frame",
  "construction-robot",
  "logistic-robot",
  "roboport",
  "beacon",
  "radar",
  "biolab",
  "electromagnetic-plant",
  "cryogenic-plant",
  "foundry",
  "recycler",
  "crusher",
  "satellite",
}) do
  remove_recipe_ingredient(recipe_name, "fw-sensor-package")
end

for _, recipe_name in ipairs({
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
  "space-platform-starter-pack",
  "space-platform-hub",
}) do
  remove_recipe_ingredient(recipe_name, "fw-memory-die")
end

for _, recipe_name in ipairs({
  "rocket-silo",
  "satellite",
  "space-platform-foundation",
  "space-platform-starter-pack",
  "thruster",
  "space-platform-hub",
  "cargo-landing-pad",
  "asteroid-collector",
}) do
  remove_recipe_ingredient(recipe_name, "fw-rocket-engine")
  remove_recipe_ingredient(recipe_name, "fw-rocket-avionics")
  remove_recipe_ingredient(recipe_name, "fw-rocket-heatshield")
end

for _, recipe_name in ipairs({
  "space-platform-foundation",
  "space-platform-starter-pack",
  "thruster",
  "space-platform-hub",
  "asteroid-collector",
  "cargo-bay",
  "cargo-landing-pad",
}) do
  remove_recipe_ingredient(recipe_name, "fw-light-frame")
end

for _, recipe_name in ipairs({
  "rocket-silo",
  "satellite",
  "beacon",
  "fusion-reactor-equipment",
  "power-armor-mk2",
  "space-platform-foundation",
  "thruster",
  "space-platform-hub",
  "cargo-landing-pad",
  "asteroid-collector",
  "electromagnetic-plant",
  "cryogenic-plant",
}) do
  remove_recipe_ingredient(recipe_name, "titanium-plate")
end

for _, recipe_name in ipairs({
  "assembling-machine-2",
  "assembling-machine-3",
  "electric-furnace",
  "recycler",
  "crusher",
  "foundry",
  "power-armor",
  "power-armor-mk2",
  "modular-armor",
  "mech-armor",
  "night-vision-equipment",
  "belt-immunity-equipment",
  "battery-equipment",
  "battery-mk2-equipment",
}) do
  remove_recipe_ingredient(recipe_name, "fw-composite-panel")
end

for _, recipe_name in ipairs({
  "oil-refinery",
  "chemical-plant",
  "centrifuge",
  "pumpjack",
  "offshore-pump",
  "electrolyser",
  "cryogenic-plant",
  "biochamber",
  "storage-tank",
  "pump",
  "pipe-to-ground",
  "heat-exchanger",
  "heat-pipe",
  "steam-engine",
  "steam-turbine",
}) do
  remove_recipe_ingredient(recipe_name, "fw-inline-filter")
end

-- Higher-tier pass.
-- This is the part where the expensive toys start admitting they should use the nice parts.
if enable_orbital_and_planetary_integration then
  patch_recipe_set({
    { "engine-unit", "fw-pressure-housing", 1 },
    { "electric-engine-unit", "fw-flow-regulator", 1 },
    { "pump", "fw-flow-regulator", 1 },
    { "offshore-pump", "fw-flow-regulator", 1 },
    { "pumpjack", "fw-flow-regulator", 1 },
    { "chemical-plant", "fw-pressure-housing", 1 },
    { "oil-refinery", "fw-pressure-housing", 2 },
    { "centrifuge", "fw-pressure-housing", 1 },
    { "electrolyser", "fw-pressure-housing", 1 },
    { "crusher", "fw-pressure-housing", 1 },
    { "recycler", "fw-pressure-housing", 1 },
    { "big-mining-drill", "fw-pressure-housing", 2 },
    { "big-mining-drill", "fw-flow-regulator", 1 },
    { "foundry", "fw-power-regulator", 1 },
    { "biochamber", "fw-flow-regulator", 1 },
    { "cryogenic-plant", "fw-power-regulator", 1 },
    { "electromagnetic-plant", "fw-power-regulator", 1 },
    { "supercapacitor", "fw-power-regulator", 1 },
    { "superconductor", "fw-cryo-coil", 1 },
    { "quantum-processor", "fw-em-core", 1 },
    { "quantum-processor", "fw-logic-matrix", 1 },
    { "quantum-processor", "fw-resonance-substrate", 1 },
    { "thruster", "fw-annealed-cermet", 2 },
    { "space-platform-hub", "fw-annealed-cermet", 2 },
    { "cargo-landing-pad", "fw-annealed-cermet", 2 },
    { "space-platform-starter-pack", "fw-annealed-cermet", 1 },
    { "space-platform-foundation", "fw-annealed-cermet", 1 },
    { "asteroid-collector", "fw-annealed-cermet", 1 },
    { "rocket-silo", "fw-power-regulator", 2 },
    { "rocket-silo", "fw-logic-matrix", 1 },
    { "satellite", "fw-sensor-diode", 2 },
    { "satellite", "fw-lens-array", 1 },
    { "fusion-generator", "fw-rift-stabilizer", 1 },
    { "fusion-reactor", "fw-rift-stabilizer", 1 },
    { "fusion-reactor-equipment", "fw-rift-stabilizer", 1 },
    { "power-armor-mk2", "fw-rift-stabilizer", 1 },
    { "mech-armor", "fw-rift-stabilizer", 1 },
    { "fusion-generator", "fw-aquilo-cryogel", 1 },
    { "fusion-generator", "fw-fulgora-static-mesh", 1 },
    { "fusion-reactor", "fw-vulcanus-slag-cermet", 1 },
    { "fusion-reactor", "fw-fulgora-static-mesh", 1 },
    { "fusion-reactor-equipment", "fw-aquilo-cryogel", 1 },
    { "fusion-reactor-equipment", "fw-vulcanus-slag-cermet", 1 },
    { "mech-armor", "fw-aquilo-cryogel", 1 },
    { "mech-armor", "fw-vulcanus-slag-cermet", 1 },
    { "teslagun", "fw-fulgora-static-mesh", 1 },
    { "tesla-turret", "fw-fulgora-static-mesh", 2 },
    { "tesla-ammo", "fw-fulgora-static-mesh", 1 },
    { "railgun", "fw-vulcanus-slag-cermet", 1 },
    { "railgun-turret", "fw-vulcanus-slag-cermet", 2 },
    { "railgun-ammo", "fw-vulcanus-slag-cermet", 1 },
    { "biolab", "fw-gleba-spore-resin", 1 },
    { "foundry", "fw-vulcanus-slag-cermet", 1 },
    { "cryogenic-plant", "fw-aquilo-cryogel", 1 },
    { "electromagnetic-plant", "fw-fulgora-static-mesh", 1 },
    { "fusion-generator", "fw-flux-resonance-cell", 1 },
    { "fusion-reactor", "fw-flux-resonance-cell", 1 },
    { "fusion-reactor-equipment", "fw-flux-resonance-cell", 1 },
    { "fusion-generator", "fw-flux-phase-manifold", 1 },
    { "fusion-reactor", "fw-flux-phase-manifold", 2 },
    { "fusion-reactor-equipment", "fw-flux-phase-manifold", 1 },
    { "power-armor-mk2", "fw-logic-matrix", 1 },
    { "mech-armor", "fw-logic-matrix", 1 },
    { "mech-armor", "fw-resonance-substrate", 2 },
    { "mech-armor", "fw-flux-resonance-cell", 1 },
    { "promethium-science-pack", "fw-flux-resonance-cell", 1 },
    { "promethium-science-pack", "fw-flux-phase-manifold", 1 },
  })
end

-- Whole-game cleanup pass.
-- Thread the newer parts in where they belong, but keep the counts sane so the factory does not turn into soup.
patch_many_recipes({
  "fast-splitter",
  "express-splitter",
  "turbo-splitter",
  "bulk-inserter",
  "stack-inserter",
  "stack-filter-inserter",
  "train-stop",
  "rail-signal",
  "rail-chain-signal",
  "roboport",
}, "fw-signal-conduit", 1)

patch_many_recipes({
  "substation",
  "beacon",
  "power-switch",
  "electromagnetic-plant",
  "teslagun",
  "tesla-turret",
}, "fw-field-winding", 1)

patch_many_recipes({
  "storage-tank",
  "heat-exchanger",
  "heat-pipe",
  "nuclear-reactor",
  "fission-reactor-equipment",
  "fusion-reactor",
  "fusion-reactor-equipment",
}, "fw-thermal-buffer", 1)

patch_many_recipes({
  "fluid-wagon",
  "car",
  "tank",
  "spidertron",
  "locomotive",
  "cargo-wagon",
  "artillery-wagon",
}, "fw-bearing", 1)

patch_many_recipes({
  "pump",
  "pumpjack",
  "offshore-pump",
  "fluid-wagon",
  "locomotive",
  "car",
  "tank",
  "spidertron",
}, "fw-flow-regulator", 1)

patch_many_recipes({
  "radar",
  "rocket-turret",
  "tesla-turret",
  "railgun-turret",
  "artillery-turret",
  "spidertron",
}, "fw-sensor-diode", 1)

patch_many_recipes({
  "satellite",
  "rocket-turret",
  "tesla-turret",
  "railgun-turret",
  "quantum-processor",
  "space-platform-hub",
}, "fw-lens-array", 1)

patch_recipe_set({
  { "spidertron", "fw-logic-matrix", 1 },
  { "spidertron", "fw-em-core", 1 },
  { "mech-armor", "fw-em-core", 1 },
  { "personal-laser-defense-equipment", "fw-coil-block", 1 },
  { "discharge-defense-equipment", "fw-coil-block", 1 },
  { "battery-equipment", "fw-power-regulator", 1 },
  { "night-vision-equipment", "fw-lens-array", 1 },
  { "energy-shield-equipment", "fw-ceramic-casing", 1 },
  { "energy-shield-mk2-equipment", "fw-ceramic-casing", 1 },
  { "fusion-generator", "fw-em-core", 1 },
  { "fusion-reactor", "fw-field-winding", 1 },
  { "fusion-reactor-equipment", "fw-field-winding", 1 },
  { "space-platform-foundation", "fw-foundry-lining", 1 },
  { "thruster", "fw-thermal-buffer", 1 },
  { "cargo-landing-pad", "fw-pressure-housing", 1 },
})

if enable_combat_recipe_integration then
  patch_recipe_set({
    { "rocket-turret", "fw-pressure-housing", 1 },
    { "rocket-turret", "fw-power-regulator", 1 },
    { "teslagun", "fw-em-core", 1 },
    { "tesla-turret", "fw-em-core", 1 },
    { "railgun", "fw-power-regulator", 1 },
    { "railgun-turret", "fw-power-regulator", 1 },
    { "railgun-turret", "fw-em-core", 1 },
  })
end

-- Bigger rebuild pass.
-- Some recipes should stop pretending FluxWorks is just garnish and actually lean on the fabricated parts.
if enable_core_material_replacements then

-- Pipe-adjacent stuff should actually look pipe-adjacent, just with our tubing instead of raw plates-only nonsense.
replace_many_recipe_ingredients({
  "engine-unit",
  "electric-engine-unit",
}, "pipe", { type = "item", name = "fw-copper-tube", amount = 2 })

replace_many_recipe_ingredients({
  "pump",
  "offshore-pump",
  "steam-engine",
}, "pipe", { type = "item", name = "fw-copper-tube", amount = 1 })

replace_many_recipe_ingredients({
  "storage-tank",
  "pipe-to-ground",
  "heat-exchanger",
  "steam-turbine",
  "fluid-wagon",
}, "pipe", { type = "item", name = "fw-copper-tube", amount = 2 })

replace_many_recipe_ingredients({
  "chemical-plant",
  "pumpjack",
  "flamethrower-turret",
}, "pipe", { type = "item", name = "fw-copper-tube", amount = 2 })

replace_many_recipe_ingredients({
  "oil-refinery",
}, "pipe", { type = "item", name = "fw-copper-tube", amount = 4 })

-- Mechanical bits graduate from "gear everywhere" to "yeah bearings exist."
replace_many_recipe_ingredients({
  "fast-transport-belt",
  "express-transport-belt",
  "turbo-transport-belt",
  "fast-underground-belt",
  "express-underground-belt",
  "turbo-underground-belt",
  "fast-inserter",
  "filter-inserter",
  "stack-inserter",
  "stack-filter-inserter",
  "bulk-inserter",
  "engine-unit",
}, "iron-gear-wheel", { type = "item", name = "fw-bearing", amount = 1 })

replace_many_recipe_ingredients({
  "fast-splitter",
  "express-splitter",
  "turbo-splitter",
  "car",
  "locomotive",
  "cargo-wagon",
  "fluid-wagon",
  "artillery-wagon",
}, "iron-gear-wheel", { type = "item", name = "fw-bearing", amount = 2 })

replace_many_recipe_ingredients({
  "tank",
  "spidertron",
}, "iron-gear-wheel", { type = "item", name = "fw-bearing", amount = 4 })

-- Big frame-y stuff should use beams. Nice and simple.
replace_many_recipe_ingredients({
  "electric-mining-drill",
  "assembling-machine-2",
  "medium-electric-pole",
  "rail-signal",
  "rail-chain-signal",
  "train-stop",
  "rail-ramp",
  "rail-support",
}, "steel-plate", { type = "item", name = "fw-steel-beam", amount = 1 })

replace_many_recipe_ingredients({
  "assembling-machine-3",
  "pumpjack",
  "chemical-plant",
  "electric-furnace",
  "car",
  "cargo-wagon",
  "fluid-wagon",
}, "steel-plate", { type = "item", name = "fw-steel-beam", amount = 2 })

replace_many_recipe_ingredients({
  "oil-refinery",
  "locomotive",
  "tank",
  "artillery-wagon",
}, "steel-plate", { type = "item", name = "fw-steel-beam", amount = 4 })

-- Power storage and robot bits get pushed toward real capacitor hardware.
replace_many_recipe_ingredients({
  "flying-robot-frame",
  "construction-robot",
  "logistic-robot",
  "laser-turret",
  "personal-roboport-equipment",
}, "battery", { type = "item", name = "fw-capacitor", amount = 2 })

replace_many_recipe_ingredients({
  "personal-roboport-mk2-equipment",
  "battery-mk2-equipment",
  "fission-reactor-equipment",
  "fusion-reactor-equipment",
}, "battery", { type = "item", name = "fw-capacitor", amount = 4 })

-- Once the factory grows up, the control network should look like it did too.
patch_many_recipes({
  "arithmetic-combinator",
  "decider-combinator",
  "constant-combinator",
  "selector-combinator",
  "programmable-speaker",
  "power-switch",
  "rail-signal",
  "rail-chain-signal",
  "train-stop",
  "roboport",
}, "fw-signal-conduit", 1)

patch_many_recipes({
  "arithmetic-combinator",
  "decider-combinator",
  "constant-combinator",
  "selector-combinator",
  "programmable-speaker",
  "rail-signal",
  "rail-chain-signal",
  "radar",
  "rocket-turret",
  "tesla-turret",
}, "fw-circuit-contact", 1)

patch_many_recipes({
  "small-electric-pole",
  "medium-electric-pole",
  "big-electric-pole",
  "substation",
  "power-switch",
  "accumulator",
  "laser-turret",
  "teslagun",
}, "fw-ceramic-insulator", 1)

patch_recipe_set({
  { "accumulator", "fw-power-regulator", 1 },
  { "substation", "fw-transformer-core", 1 },
  { "roboport", "fw-power-regulator", 1 },
  { "radar", "fw-power-regulator", 1 },
  { "power-switch", "fw-circuit-substrate", 1 },
  { "programmable-speaker", "fw-circuit-substrate", 1 },
  { "arithmetic-combinator", "fw-circuit-substrate", 1 },
  { "decider-combinator", "fw-circuit-substrate", 1 },
  { "constant-combinator", "fw-circuit-substrate", 1 },
  { "selector-combinator", "fw-circuit-substrate", 1 },
  { "rail-signal", "fw-sensor-diode", 1 },
  { "rail-chain-signal", "fw-sensor-diode", 1 },
  { "train-stop", "fw-sensor-package", 1 },
})

-- Coherence pass.
-- Keep neighboring recipes speaking the same material language so nothing feels like a weird one-off prank.

-- Also: fluid handling should still come from pipes.
-- We are layering on top, not pretending the whole family got reinvented overnight.
replace_recipe_ingredient("engine-unit", "fw-copper-tube", { type = "item", name = "pipe", amount = 2 })
replace_recipe_ingredient("electric-engine-unit", "fw-copper-tube", { type = "item", name = "pipe", amount = 2 })
replace_recipe_ingredient("pump", "fw-copper-tube", { type = "item", name = "pipe", amount = 1 })
replace_recipe_ingredient("offshore-pump", "fw-copper-tube", { type = "item", name = "pipe", amount = 3 })
replace_recipe_ingredient("steam-engine", "fw-copper-tube", { type = "item", name = "pipe", amount = 5 })
replace_recipe_ingredient("pipe-to-ground", "fw-copper-tube", { type = "item", name = "pipe", amount = 10 })
replace_recipe_ingredient("heat-exchanger", "fw-copper-tube", { type = "item", name = "pipe", amount = 10 })
replace_recipe_ingredient("steam-turbine", "fw-copper-tube", { type = "item", name = "pipe", amount = 20 })
replace_recipe_ingredient("fluid-wagon", "fw-copper-tube", { type = "item", name = "pipe", amount = 8 })
replace_recipe_ingredient("chemical-plant", "fw-copper-tube", { type = "item", name = "pipe", amount = 5 })
replace_recipe_ingredient("pumpjack", "fw-copper-tube", { type = "item", name = "pipe", amount = 10 })
replace_recipe_ingredient("flamethrower-turret", "fw-copper-tube", { type = "item", name = "pipe", amount = 10 })
replace_recipe_ingredient("oil-refinery", "fw-copper-tube", { type = "item", name = "pipe", amount = 10 })

for _, recipe_name in ipairs({
  "pipe-to-ground",
  "storage-tank",
  "pump",
  "offshore-pump",
  "chemical-plant",
  "oil-refinery",
  "pumpjack",
  "engine-unit",
  "electric-engine-unit",
}) do
  remove_recipe_ingredient(recipe_name, "lead-plate")
end

for _, recipe_name in ipairs({
  "pump",
  "offshore-pump",
}) do
  remove_recipe_ingredient(recipe_name, "electronic-circuit")
end

remove_recipe_ingredient("engine-unit", "fw-pressure-housing")

patch_recipe_set({
  { "engine-unit", "fw-copper-tube", 1 },
  { "electric-engine-unit", "fw-copper-tube", 1 },
  { "pipe-to-ground", "fw-copper-tube", 1 },
  { "storage-tank", "fw-copper-tube", 2 },
  { "pump", "fw-copper-tube", 1 },
  { "offshore-pump", "fw-copper-tube", 1 },
  { "steam-engine", "fw-copper-tube", 1 },
  { "steam-turbine", "fw-copper-tube", 2 },
  { "heat-exchanger", "fw-copper-tube", 2 },
  { "fluid-wagon", "fw-copper-tube", 2 },
  { "chemical-plant", "fw-copper-tube", 2 },
  { "oil-refinery", "fw-copper-tube", 4 },
  { "pumpjack", "fw-copper-tube", 2 },
  { "flamethrower-turret", "fw-copper-tube", 2 },
  { "centrifuge", "fw-copper-tube", 2 },
  { "electrolyser", "fw-copper-tube", 2 },
  { "cryogenic-plant", "fw-copper-tube", 4 },
  { "foundry", "fw-copper-tube", 2 },
  { "biochamber", "fw-copper-tube", 2 },
  { "recycler", "fw-copper-tube", 1 },
  { "crusher", "fw-copper-tube", 1 },
  { "thruster", "fw-copper-tube", 4 },
  { "infinity-pipe", "fw-copper-tube", 1 },
  { "casting-pipe-to-ground", "fw-copper-tube", 1 },
})

patch_recipe_set({
  { "storage-tank", "fw-flow-regulator", 1 },
  { "pump", "fw-flow-regulator", 1 },
  { "offshore-pump", "fw-flow-regulator", 1 },
  { "fluid-wagon", "fw-flow-regulator", 1 },
  { "steam-turbine", "fw-thermal-buffer", 1 },
  { "heat-exchanger", "fw-thermal-buffer", 1 },
  { "heating-tower", "fw-thermal-buffer", 1 },
  { "infinity-pipe", "fw-flow-regulator", 1 },
  { "electrolyser", "fw-flow-regulator", 1 },
  { "centrifuge", "fw-flow-regulator", 1 },
})
end

-- Keep the control family broad, sure, but stop shoving every single control part into every single recipe.
remove_recipe_ingredient("train-stop", "fw-sensor-package")
patch_recipe_set({
  { "train-stop", "fw-circuit-substrate", 1 },
  { "train-stop", "fw-signal-conduit", 1 },
  { "radar", "fw-signal-conduit", 1 },
  { "radar", "fw-sensor-diode", 1 },
  { "beacon", "fw-field-winding", 1 },
  { "lightning-collector", "fw-power-regulator", 1 },
  { "electromagnetic-science-pack", "fw-power-regulator", 1 },
})

-- Final high-tier cleanup.
-- Orbital, sensing, thermal, and field hardware should feel like actual families, not lonely patch notes.
if enable_orbital_and_planetary_integration then
  patch_many_recipes({
    "rocket-silo",
    "satellite",
    "space-platform-foundation",
    "space-platform-starter-pack",
    "space-platform-hub",
    "cargo-landing-pad",
    "cargo-bay",
    "asteroid-collector",
    "thruster",
  }, "fw-signal-conduit", 1)

  patch_many_recipes({
    "rocket-silo",
    "satellite",
    "space-platform-hub",
    "cargo-bay",
    "asteroid-collector",
    "biolab",
    "radar",
    "rocket-turret",
    "railgun-turret",
    "tesla-turret",
  }, "fw-lens-array", 1)

  patch_many_recipes({
    "nuclear-reactor",
    "fission-reactor",
    "fusion-reactor",
    "fusion-generator",
    "cryogenic-plant",
    "electromagnetic-plant",
    "foundry",
    "thruster",
  }, "fw-field-winding", 1)

  patch_many_recipes({
    "heat-exchanger",
    "heat-pipe",
    "steam-turbine",
    "nuclear-reactor",
    "fission-reactor",
    "fusion-reactor",
    "fusion-generator",
    "thruster",
  }, "fw-foundry-lining", 1)

  patch_recipe_set({
    { "biolab", "fw-logic-matrix", 1 },
    { "rocket-silo", "fw-pressure-housing", 2 },
    { "satellite", "fw-logic-matrix", 1 },
    { "space-platform-foundation", "fw-foundry-lining", 1 },
    { "space-platform-starter-pack", "fw-power-regulator", 1 },
    { "space-platform-hub", "fw-em-core", 1 },
    { "cargo-bay", "fw-pressure-housing", 1 },
    { "asteroid-collector", "fw-flow-regulator", 1 },
    { "thruster", "fw-pressure-housing", 1 },
    { "fission-reactor", "fw-thermal-buffer", 1 },
    { "nuclear-reactor", "fw-thermal-buffer", 1 },
    { "fusion-reactor", "fw-em-core", 1 },
    { "fusion-generator", "fw-logic-matrix", 1 },
    { "cryogenic-plant", "fw-thermal-buffer", 1 },
    { "electromagnetic-plant", "fw-em-core", 1 },
    { "foundry", "fw-foundry-lining", 1 },
    { "rocket-turret", "fw-signal-conduit", 1 },
    { "railgun-turret", "fw-logic-matrix", 1 },
    { "tesla-turret", "fw-field-winding", 1 },
    { "mech-armor", "fw-em-core", 1 },
    { "spidertron", "fw-signal-conduit", 1 },
  })
end
