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

-- Targeted base-game integration, kept intentionally light.
patch_recipe_ingredients("electronic-circuit", "fw-solder-alloy", 1)
patch_recipe_ingredients("advanced-circuit", "fw-solder-alloy", 1)
patch_recipe_ingredients("advanced-circuit", "fw-ceramic-insulator", 1)
patch_recipe_ingredients("processing-unit", "fw-solder-alloy", 1)
patch_recipe_ingredients("processing-unit", "fw-capacitor", 1)
patch_recipe_ingredients("engine-unit", "fw-bearing", 1)
patch_recipe_ingredients("electric-engine-unit", "fw-bearing", 1)
patch_recipe_ingredients("flying-robot-frame", "fw-light-frame", 1)
patch_recipe_ingredients("low-density-structure", "fw-light-frame", 1)
patch_recipe_ingredients("battery", "fw-ceramic-insulator", 1)
patch_recipe_ingredients("accumulator", "fw-capacitor", 2)
patch_recipe_ingredients("uranium-rounds-magazine", "fw-gunpowder", 1)
patch_recipe_ingredients("lab", "fw-glass", 4)
patch_recipe_ingredients("lab", "fw-ceramic-insulator", 2)
patch_recipe_ingredients("biolab", "fw-glass", 20)
patch_recipe_ingredients("biolab", "fw-capacitor", 8)
patch_recipe_ingredients("fast-inserter", "fw-steel-beam", 1)
patch_recipe_ingredients("filter-inserter", "fw-steel-beam", 1)
patch_recipe_ingredients("stack-inserter", "fw-aluminum-beam", 1)
patch_recipe_ingredients("stack-filter-inserter", "fw-aluminum-beam", 1)
patch_recipe_ingredients("bulk-inserter", "fw-aluminum-beam", 1)
patch_recipe_ingredients("underground-belt", "fw-steel-beam", 1)
patch_recipe_ingredients("splitter", "fw-steel-beam", 1)
patch_recipe_ingredients("assembling-machine-2", "fw-steel-beam", 1)
patch_recipe_ingredients("assembling-machine-2", "fw-circuit-substrate", 1)
patch_recipe_ingredients("assembling-machine-3", "fw-aluminum-beam", 2)
patch_recipe_ingredients("assembling-machine-3", "fw-inductor-coil", 2)
patch_recipe_ingredients("electric-mining-drill", "fw-steel-beam", 1)
patch_recipe_ingredients("electric-furnace", "fw-composite-panel", 2)
patch_recipe_ingredients("electric-furnace", "fw-inductor-coil", 1)
patch_recipe_ingredients("medium-electric-pole", "fw-steel-beam", 1)
patch_recipe_ingredients("substation", "fw-aluminum-beam", 2)
patch_recipe_ingredients("substation", "fw-inductor-coil", 1)
patch_recipe_ingredients("radar", "fw-circuit-substrate", 2)
patch_recipe_ingredients("solar-panel", "fw-glass", 2)
patch_recipe_ingredients("solar-panel", "fw-copper-tube", 2)
patch_recipe_ingredients("laser-turret", "fw-capacitor", 1)
patch_recipe_ingredients("laser-turret", "fw-inductor-coil", 2)
patch_recipe_ingredients("piercing-rounds-magazine", "fw-bullet-casing", 1)
patch_recipe_ingredients("uranium-rounds-magazine", "fw-bullet-casing", 1)
patch_recipe_ingredients("processing-unit", "fw-sensor-package", 1)
patch_recipe_ingredients("speed-module", "fw-ribbon-cable", 1)
patch_recipe_ingredients("effectivity-module", "fw-ribbon-cable", 1)
patch_recipe_ingredients("productivity-module", "fw-sensor-package", 1)
patch_recipe_ingredients("chemical-plant", "fw-inline-filter", 1)
patch_recipe_ingredients("oil-refinery", "fw-inline-filter", 2)
patch_recipe_ingredients("pumpjack", "fw-inline-filter", 1)
patch_recipe_ingredients("beacon", "fw-transformer-core", 2)
patch_recipe_ingredients("beacon", "fw-sensor-package", 2)
patch_recipe_ingredients("roboport", "fw-ribbon-cable", 2)
patch_recipe_ingredients("substation", "fw-transformer-core", 1)
patch_recipe_ingredients("lab", "fw-glass-lens", 2)

-- Broader base-game + Space Age integration.
-- Gameplay intent:
-- early game: light throughput tax and new part identity
-- mid game: force dedicated component lines without stalling core expansion
-- late game / SA: specialization pressure on optics, filtering, and power components
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

-- Space Age production chain touchpoints (guarded by recipe existence).
patch_recipe_ingredients("electromagnetic-plant", "fw-transformer-core", 4)
patch_recipe_ingredients("electromagnetic-plant", "fw-ribbon-cable", 6)
patch_recipe_ingredients("electromagnetic-plant", "fw-sensor-package", 4)
patch_recipe_ingredients("foundry", "fw-cermet", 8)
patch_recipe_ingredients("foundry", "fw-composite-panel", 4)
patch_recipe_ingredients("recycler", "fw-inline-filter", 3)
patch_recipe_ingredients("recycler", "fw-cermet", 2)
patch_recipe_ingredients("biochamber", "fw-inline-filter", 2)
patch_recipe_ingredients("cryogenic-plant", "fw-transformer-core", 4)
patch_recipe_ingredients("cryogenic-plant", "fw-cermet", 4)

patch_recipe_ingredients("supercapacitor", "fw-capacitor", 2)
patch_recipe_ingredients("supercapacitor", "fw-ribbon-cable", 2)
patch_recipe_ingredients("superconductor", "fw-ribbon-cable", 2)
patch_recipe_ingredients("superconductor", "fw-cermet", 1)
patch_recipe_ingredients("quantum-processor", "fw-sensor-package", 2)
patch_recipe_ingredients("quantum-processor", "fw-glass-lens", 2)
patch_recipe_ingredients("quantum-processor", "fw-ribbon-cable", 2)
patch_recipe_ingredients("holmium-plate", "fw-inline-filter", 1)
patch_recipe_ingredients("tungsten-carbide", "fw-cermet", 1)
patch_recipe_ingredients("carbon-fiber", "fw-inline-filter", 1)
patch_recipe_ingredients("carbon-fiber", "fw-composite-panel", 1)

patch_recipe_ingredients("space-platform-foundation", "fw-composite-panel", 4)
patch_recipe_ingredients("space-platform-starter-pack", "fw-transformer-core", 3)
patch_recipe_ingredients("space-platform-starter-pack", "fw-sensor-package", 3)
patch_recipe_ingredients("asteroid-collector", "fw-inline-filter", 2)
patch_recipe_ingredients("asteroid-collector", "fw-cermet", 2)
patch_recipe_ingredients("crusher", "fw-cermet", 2)
patch_recipe_ingredients("cargo-landing-pad", "fw-composite-panel", 4)
patch_recipe_ingredients("cargo-bay", "fw-inline-filter", 2)
patch_recipe_ingredients("space-platform-thruster", "fw-cermet", 2)
patch_recipe_ingredients("space-platform-hub", "fw-transformer-core", 2)

patch_recipe_ingredients("electromagnetic-science-pack", "fw-sensor-package", 1)
patch_recipe_ingredients("metallurgic-science-pack", "fw-cermet", 1)
patch_recipe_ingredients("agricultural-science-pack", "fw-inline-filter", 1)
patch_recipe_ingredients("cryogenic-science-pack", "fw-glass-lens", 1)
patch_recipe_ingredients("promethium-science-pack", "fw-transformer-core", 1)
