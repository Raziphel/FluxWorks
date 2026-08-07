return function()
-- These boundaries keep final recipes focused on representative assemblies
-- instead of repeating every lower-level component in their production chain.

local keep_ingredients = {
  ["advanced-circuit"] = { "electronic-circuit", "plastic-bar", "copper-cable", "fw-microchip", "silicon", "fw-circuit-contact" },
  ["artillery-turret"] = { "tungsten-plate", "refined-concrete", "processing-unit", "electric-engine-unit", "fw-hydraulic-manifold" },
  ["assembling-machine-2"] = { "assembling-machine-1", "electronic-circuit", "motor", "fw-bearing", "fw-circuit-contact" },
  ["assembling-machine-3"] = { "assembling-machine-2", "advanced-circuit", "electric-engine-unit", "fw-control-assembly", "fw-transformer-core" },
  ["big-mining-drill"] = { "electric-mining-drill", "tungsten-carbide", "electric-engine-unit", "advanced-circuit", "fw-harvester-head" },
  ["artillery-wagon"] = { "cargo-wagon", "engine-unit", "tungsten-plate", "processing-unit", "fw-hydraulic-manifold" },
  ["beacon"] = { "advanced-circuit", "concrete", "steel-plate", "electric-motor", "fw-field-winding" },
  ["big-electric-pole"] = { "iron-stick", "steel-plate", "copper-cable", "concrete", "pipe", "fw-power-regulator" },
  ["bulk-inserter"] = { "electronic-circuit", "advanced-circuit", "fast-inserter", "fw-signal-conduit", "fw-bearing" },
  ["centrifuge"] = { "concrete", "steel-plate", "advanced-circuit", "iron-gear-wheel", "titanium-plate", "fw-isotope-matrix" },
  ["cryogenic-plant"] = { "refined-concrete", "superconductor", "processing-unit", "lithium-plate", "fw-cryo-coil" },
  ["electric-furnace"] = { "advanced-circuit", "concrete", "steel-furnace", "fw-inductor-coil", "fw-foundry-lining" },
  ["electromagnetic-science-pack"] = { "supercapacitor", "accumulator", "electrolyte", "holmium-solution", "fw-lens-array" },
  ["fission-reactor-equipment"] = { "processing-unit", "low-density-structure", "uranium-fuel-cell", "fw-pressure-housing", "fw-thermal-buffer" },
  ["fluoroketone"] = { "fluorine", "ammonia", "solid-fuel", "lithium", "fw-thermal-buffer", "fw-red-flux" },
  ["fusion-power-cell"] = { "lithium-plate", "holmium-plate", "ammonia", "fw-reactor-dopant", "fw-reactor-coolant-cartridge" },
  ["fusion-generator"] = { "tungsten-plate", "superconductor", "quantum-processor", "fw-spectral-reservoir", "fw-field-winding" },
  ["fusion-reactor"] = { "tungsten-plate", "superconductor", "quantum-processor", "fw-spectral-reservoir", "fw-reactor-dopant", "fw-reactor-coolant-cartridge" },
  ["fusion-reactor-equipment"] = { "fission-reactor-equipment", "fusion-power-cell", "quantum-processor", "fw-flux-phase-manifold" },
  ["fw-actinide-dopant-refining"] = { "fw-recovered-actinides", "fw-isotope-matrix", "fw-reactor-coolant-cartridge", "fw-logic-matrix", "fw-shielded-fuel-casing", "fw-red-flux" },
  ["fw-actinide-matrix-seeding"] = { "fw-recovered-actinides", "uranium-238", "fw-logic-matrix", "fw-shielded-fuel-casing", "fw-ceramic-casing", "sulfuric-acid" },
  ["fw-aquilo-cryogel"] = { "fw-salt", "lithium", "ice", "fw-thermal-buffer", "fluoroketone-cold", "fw-yellow-flux" },
  ["fw-aquilo-cryogel-annealing"] = { "fw-salt", "lithium", "ice", "fw-thermal-buffer", "fluoroketone-cold", "fw-yellow-flux" },
  ["fw-atomic-enricher"] = { "centrifuge", "fw-pressure-housing", "fw-annealed-cermet", "fw-logic-matrix", "fw-shielded-fuel-casing", "fw-inline-filter" },
  ["fw-entanglement-core"] = { "fw-em-core", "fw-logic-matrix", "fw-flux-resonance-cell", "fw-memory-die", "fw-power-regulator", "fw-quantum-computer" },
  ["fw-ceramic-casing"] = { "fw-fired-ceramic", "fw-steel-beam", "fw-alumina-refractory", "fw-rubber-sheet" },
  ["fw-control-assembly"] = { "electric-motor", "fw-circuit-substrate", "fw-chip-carrier", "fw-solder-wire" },
  ["fw-field-winding"] = { "fw-transformer-core", "fw-coil-block", "electric-engine-unit", "fw-power-regulator" },
  ["fw-flow-regulator"] = { "fw-pressure-housing", "electric-motor", "fw-inline-filter", "engine-unit" },
  ["fw-flux-phase-manifold"] = { "fw-flux-resonance-cell", "fw-resonance-substrate", "fw-condensed-flux-matrix", "fw-field-winding", "fw-sensor-package", "fw-logic-matrix" },
  ["fw-flux-quarry"] = { "electric-mining-drill", "electric-motor", "electric-engine-unit", "fw-pressure-housing", "fw-flow-regulator" },
  ["fw-flux-metallic-synthesis"] = { "fw-flux-phase-manifold", "fw-purple-flux", "fw-yellow-flux", "fw-red-flux", "fw-thermal-buffer" },
  ["fw-flux-cermet-tempering"] = { "stone-brick", "steel-plate", "aluminum-plate", "fw-alumina-refractory", "fw-crystalised-flux" },
  ["fw-fusion-power-cell-conditioning"] = { "fw-isotope-matrix", "fw-reactor-dopant", "fw-aquilo-cryogel", "ammonia", "fw-red-flux" },
  ["fw-flux-resonance-cell"] = { "fw-resonance-substrate", "fw-condensed-flux-matrix", "fw-flux-catalyst", "fw-yellow-flux", "fw-red-flux", "fw-green-flux" },
  ["fw-flux-resonance-cell-calibration"] = { "fw-stabilized-flux-crystal", "fw-condensed-flux-matrix", "fw-flux-catalyst", "fw-yellow-flux", "fw-red-flux", "fw-green-flux" },
  ["fw-fulgora-static-mesh"] = { "holmium-plate", "supercapacitor", "fw-metal-mesh", "fw-em-core", "electrolyte", "fw-yellow-flux" },
  ["fw-gleba-spore-resin"] = { "fw-resin", "fw-nutrient-bed", "bioflux", "nutrients", "fw-latex", "fw-green-flux" },
  ["fw-harvester-head"] = { "fw-pressure-housing", "fw-flow-regulator", "fw-transformer-core", "fw-flux-catalyst", "fw-yellow-flux", "electric-motor" },
  ["fw-hydraulic-manifold"] = { "fw-flow-regulator", "fw-pressure-housing", "fw-copper-tube", "fw-reinforced-seal", "fw-elastomer-matrix", "motor" },
  ["fw-hydraulic-seal-compression"] = { "fw-chlorinated-binder-stock", "fw-elastomer-matrix", "lead-plate", "water" },
  ["fw-hydraulic-plant"] = { "fw-pressure-housing", "fw-copper-tube", "fw-flow-regulator", "fw-reinforced-seal", "fw-steel-beam", "electric-motor" },
  ["fw-hydraulic-regulator-calibration"] = { "fw-pressure-housing", "electric-motor", "fw-bearing", "fw-inline-filter", "fw-copper-tube", "lubricant" },
  ["fw-isotope-matrix"] = { "uranium-235", "uranium-238", "fw-ceramic-casing", "fw-logic-matrix", "fw-shielded-fuel-casing", "sulfuric-acid" },
  ["fw-model-lattice"] = { "fw-quantum-computer", "fw-flux-lattice", "fw-flux-phase-manifold", "fw-lens-array", "fw-promethium-matrix", "superconductor" },
  ["fw-nuclear-fuel-overdrive"] = { "nuclear-fuel", "fw-reactor-dopant", "fw-isotope-matrix", "fw-logic-matrix", "fw-reactor-coolant-cartridge", "fw-red-flux" },
  ["fw-origin-forge"] = { "fw-flux-condenser", "fw-rift-coupler", "fw-phase-anchor", "fw-entanglement-core", "fw-promethium-matrix", "fusion-power-cell" },
  ["fw-origin-singularity"] = { "fw-genesis-ark", "fw-universal-collapse-core", "fw-origin-catalyst-manifold", "fw-storm-spine", "fw-origin-crucible", "promethium-science-pack" },
  ["fw-petrochemical-facility"] = { "fw-pressure-housing", "fw-steel-beam", "fw-flow-regulator", "fw-inline-filter", "fw-resin", "motor" },
  ["fw-phase-vault"] = { "storage-chest", "fw-phase-anchor", "fw-entanglement-core", "fw-compression-baffle", "fw-pressure-housing", "superconductor" },
  ["fw-foundry-lining"] = { "fw-cermet", "fw-ceramic-casing", "titanium-plate", "fw-alumina-refractory" },
  ["fw-power-regulator"] = { "fw-transformer-core", "fw-control-assembly", "fw-capacitor", "electric-motor" },
  ["fw-pressure-housing"] = { "fw-cermet", "fw-steel-beam", "fw-inline-filter", "engine-unit" },
  ["fw-phase-anchor"] = { "fw-rift-stabilizer", "fw-resonance-substrate", "fw-field-winding", "fw-pressure-housing", "supercapacitor" },
  ["fw-promethium-matrix"] = { "promethium-asteroid-chunk", "fw-promethium-shard", "fw-flux-resonance-cell", "fw-logic-matrix", "fw-fulgora-static-mesh", "fw-vulcanus-slag-cermet" },
  ["fw-quantum-computer"] = { "quantum-processor", "fw-logic-matrix", "fw-memory-die", "fw-em-core", "fw-resonance-substrate", "supercapacitor" },
  ["fw-reservoir-lining"] = { "fw-thermal-buffer", "fw-flow-regulator", "fw-ceramic-casing", "fw-cryo-coil", "fw-reinforced-seal", "fw-power-regulator" },
  ["fw-rift-coupler"] = { "fw-phase-anchor", "fw-entanglement-core", "fw-flux-phase-manifold", "fw-model-lattice", "fw-promethium-matrix", "fw-thermal-phase-gasket" },
  ["fw-rift-exchange-fluid-gate"] = { "fw-rift-exchange-gate", "fw-spectral-reservoir", "fw-rift-coupler", "fw-reservoir-lining", "fw-thermal-phase-gasket", "processing-unit" },
  ["fw-rift-exchange-gate"] = { "fw-rift-coupler", "fw-phase-vault", "fw-spectral-reservoir", "fw-model-lattice", "fw-promethium-matrix", "fusion-reactor-equipment" },
  ["fw-rift-stabilizer"] = { "fw-flux-phase-manifold", "fw-promethium-matrix", "fw-aquilo-cryogel", "fw-gleba-spore-resin", "fw-fulgora-static-mesh", "fw-vulcanus-slag-cermet" },
  ["fw-sensor-package"] = { "electronic-circuit", "fw-control-assembly", "fw-glass-lens", "tin-plate" },
  ["fw-signal-conduit"] = { "fw-control-assembly", "fw-tinned-cable", "fw-rubber-sheet", "electric-motor" },
  ["fw-spectral-reservoir"] = { "storage-tank", "fw-reservoir-lining", "fw-entanglement-core", "fw-thermal-phase-gasket", "fw-thermal-buffer", "supercapacitor" },
  ["fw-superconductor-bath"] = { "holmium-plate", "fw-cryo-coil", "fw-aquilo-cryogel", "fw-fulgora-static-mesh", "light-oil" },
  ["fw-thermal-phase-gasket"] = { "fw-rubber-sheet", "fw-thermal-buffer", "fw-pressure-housing", "fw-reinforced-seal", "fw-power-regulator" },
  ["fw-transformer-core"] = { "electric-motor", "fw-tinned-cable", "fw-inductor-coil", "bronze-plate" },
  ["industrial-furnace"] = { "electric-furnace", "engine-unit", "fw-foundry-lining", "fw-power-regulator", "fw-hydraulic-manifold" },
  ["heat-pipe"] = { "steel-plate", "copper-plate", "fw-cermet", "titanium-plate", "fw-thermal-buffer" },
  ["laser-turret"] = { "steel-plate", "electronic-circuit", "electric-motor", "fw-capacitor" },
  ["mech-armor"] = { "power-armor-mk2", "superconductor", "supercapacitor", "fw-rift-stabilizer", "fw-em-core" },
  ["nuclear-reactor"] = { "concrete", "steel-plate", "advanced-circuit", "copper-plate", "fw-isotope-matrix", "fw-control-rod-assembly" },
  ["oil-refinery"] = { "iron-gear-wheel", "stone-brick", "electronic-circuit", "pipe", "electric-motor" },
  ["power-armor-mk2"] = { "power-armor", "processing-unit", "electric-engine-unit", "low-density-structure", "fw-rocket-engine", "fw-logic-matrix" },
  ["personal-roboport-equipment"] = { "advanced-circuit", "iron-gear-wheel", "steel-plate", "aluminum-plate", "fw-microchip" },
  ["personal-roboport-mk2-equipment"] = { "personal-roboport-equipment", "processing-unit", "superconductor", "titanium-plate", "fw-microchip" },
  ["promethium-science-pack"] = { "biter-egg", "promethium-asteroid-chunk", "fw-promethium-matrix", "fw-aquilo-cryogel", "fw-gleba-spore-resin", "fw-fulgora-static-mesh", "fw-vulcanus-slag-cermet" },
  ["pumpjack"] = { "electric-motor", "engine-unit", "fw-bearing", "pipe" },
  ["quantum-processor"] = { "processing-unit", "superconductor", "lithium-plate", "fluoroketone-cold", "fw-logic-matrix" },
  ["rail-chain-signal"] = { "electronic-circuit", "iron-plate", "fw-signal-conduit", "fw-lens-array" },
  ["rail-signal"] = { "electronic-circuit", "iron-plate", "fw-signal-conduit", "fw-lens-array" },
  ["railgun"] = { "tungsten-plate", "superconductor", "quantum-processor", "fluoroketone-cold", "titanium-plate", "fw-vulcanus-slag-cermet" },
  ["railgun-turret"] = { "quantum-processor", "tungsten-plate", "superconductor", "fluoroketone-cold", "fw-vulcanus-slag-cermet", "fw-logic-matrix" },
  ["roboport"] = { "steel-plate", "iron-gear-wheel", "advanced-circuit", "battery", "fw-power-regulator" },
  ["rocket-turret"] = { "rocket-launcher", "processing-unit", "carbon-fiber", "steel-plate", "fw-lens-array", "fw-pressure-housing" },
  ["spidertron"] = { "exoskeleton-equipment", "fission-reactor-equipment", "rocket-turret", "titanium-plate", "fw-logic-matrix", "fw-em-core" },
  ["space-platform-starter-pack"] = { "space-platform-foundation", "steel-plate", "processing-unit", "fw-sensor-package", "fw-power-regulator" },
  ["tank"] = { "engine-unit", "advanced-circuit", "bronze-plate", "fw-cermet", "fw-flow-regulator" },
  ["teslagun"] = { "holmium-plate", "superconductor", "plastic-bar", "electrolyte", "fw-field-winding" },
  ["tesla-turret"] = { "teslagun", "supercapacitor", "processing-unit", "superconductor", "fw-fulgora-static-mesh", "fw-em-core" },
  ["train-stop"] = { "electronic-circuit", "iron-plate", "iron-stick", "fw-signal-conduit", "fw-circuit-substrate" },
  ["turbo-splitter"] = { "express-splitter", "tungsten-plate", "processing-unit", "lubricant", "fw-signal-conduit", "fw-bearing" },
}

local function entry_name(entry)
  return entry and (entry.name or entry[1])
end

local function is_fluxworks_ingredient(name)
  return name and string.sub(name, 1, 3) == "fw-"
end

local function filter_ingredients(recipe_name, ingredients, keep_names)
  if not ingredients then return end

  local keep = {}
  local required_fluxworks = {}
  local recipe_is_fluxworks_owned = is_fluxworks_ingredient(recipe_name)
  for _, name in ipairs(keep_names) do
    keep[name] = true
    if is_fluxworks_ingredient(name) then
      required_fluxworks[name] = true
    end
  end

  local filtered = {}
  local found_fluxworks = {}
  for _, ingredient in ipairs(ingredients) do
    local name = entry_name(ingredient)
    -- FluxWorks recipes use their exact curated boundary. For shared recipes,
    -- FluxWorks only limits its own component contribution; ingredients from
    -- base or other mods remain intact so alternate production chains do not
    -- need a per-mod compatibility exception.
    if keep[name] or (not recipe_is_fluxworks_owned and not is_fluxworks_ingredient(name)) then
      filtered[#filtered + 1] = ingredient
    end
    if required_fluxworks[name] then found_fluxworks[name] = true end
  end

  local missing = {}
  for name in pairs(required_fluxworks) do
    if not found_fluxworks[name] then
      missing[#missing + 1] = name
    end
  end
  if #missing > 0 then
    table.sort(missing)
    error(("Recipe complexity normalization for %s is missing required FluxWorks ingredients: %s"):format(
      recipe_name, table.concat(missing, ", ")
    ))
  end
  return filtered
end

for recipe_name, keep_names in pairs(keep_ingredients) do
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if not recipe then
    error("Recipe complexity normalization references missing recipe " .. recipe_name)
  end

  recipe.ingredients = filter_ingredients(recipe_name, recipe.ingredients, keep_names)
  if recipe.normal then
    recipe.normal.ingredients = filter_ingredients(recipe_name, recipe.normal.ingredients, keep_names)
  end
  if recipe.expensive then
    recipe.expensive.ingredients = filter_ingredients(recipe_name, recipe.expensive.ingredients, keep_names)
  end
end

end
