return function()
-- These boundaries keep final recipes focused on representative assemblies
-- instead of repeating every lower-level component in their production chain.

local keep_ingredients = {
  ["advanced-circuit"] = { "electronic-circuit", "plastic-bar", "copper-cable", "fw-microchip", "silicon", "fw-circuit-contact" },
  ["artillery-turret"] = { "tungsten-plate", "refined-concrete", "processing-unit", "fw-cermet", "fw-pressure-housing", "fw-hydraulic-manifold" },
  ["assembling-machine-2"] = { "assembling-machine-1", "electronic-circuit", "motor", "fw-bearing", "fw-circuit-contact" },
  ["assembling-machine-3"] = { "assembling-machine-2", "advanced-circuit", "electric-engine-unit", "fw-control-assembly", "fw-chip-carrier", "fw-signal-conduit", "fw-transformer-core" },
  ["big-mining-drill"] = { "electric-mining-drill", "tungsten-carbide", "electric-engine-unit", "fw-flow-regulator", "fw-control-assembly", "fw-transformer-core", "fw-sensor-package" },
  ["cryogenic-plant"] = { "refined-concrete", "superconductor", "processing-unit", "lithium-plate", "fw-cryo-coil", "fw-thermal-buffer", "pipe" },
  ["electromagnetic-science-pack"] = { "supercapacitor", "electrolyte", "holmium-solution", "fw-lens-array", "fw-signal-conduit", "fw-power-regulator" },
  ["fusion-generator"] = { "tungsten-plate", "quantum-processor", "fw-spectral-reservoir", "fw-flux-phase-manifold", "fw-control-rod-assembly", "fw-field-winding", "fw-hydraulic-manifold" },
  ["fusion-reactor"] = { "tungsten-plate", "quantum-processor", "fw-spectral-reservoir", "fw-flux-phase-manifold", "fw-reactor-dopant", "fw-control-rod-assembly", "fw-reactor-coolant-cartridge" },
  ["fusion-reactor-equipment"] = { "fission-reactor-equipment", "fusion-power-cell", "quantum-processor", "fw-flux-phase-manifold", "fw-reactor-dopant", "fw-control-rod-assembly", "fw-reactor-coolant-cartridge" },
  ["fw-actinide-dopant-refining"] = { "fw-recovered-actinides", "fw-isotope-matrix", "fw-reactor-coolant-cartridge", "fw-logic-matrix", "fw-shielded-fuel-casing", "fw-red-flux" },
  ["fw-actinide-matrix-seeding"] = { "fw-recovered-actinides", "uranium-238", "fw-logic-matrix", "fw-shielded-fuel-casing", "fw-ceramic-casing", "sulfuric-acid" },
  ["fw-atomic-enricher"] = { "centrifuge", "fw-pressure-housing", "fw-annealed-cermet", "fw-logic-matrix", "fw-shielded-fuel-casing", "fw-inline-filter" },
  ["fw-entanglement-core"] = { "fw-em-core", "fw-logic-matrix", "fw-flux-resonance-cell", "fw-memory-die", "fw-power-regulator", "fw-quantum-computer" },
  ["fw-ceramic-casing"] = { "fw-fired-ceramic", "fw-steel-beam", "fw-alumina-refractory", "fw-rubber-sheet" },
  ["fw-control-assembly"] = { "electric-motor", "fw-circuit-substrate", "fw-chip-carrier", "fw-solder-wire" },
  ["fw-field-winding"] = { "fw-transformer-core", "fw-coil-block", "electric-engine-unit", "fw-power-regulator" },
  ["fw-flow-regulator"] = { "fw-pressure-housing", "electric-motor", "fw-inline-filter", "engine-unit" },
  ["fw-flux-phase-manifold"] = { "fw-flux-resonance-cell", "fw-resonance-substrate", "fw-condensed-flux-matrix", "fw-field-winding", "fw-sensor-package", "fw-logic-matrix" },
  ["fw-flux-quarry"] = { "electric-mining-drill", "electric-motor", "electric-engine-unit", "fw-pressure-housing", "fw-flow-regulator" },
  ["fw-flux-resonance-cell"] = { "fw-resonance-substrate", "fw-condensed-flux-matrix", "fw-field-winding", "fw-flux-catalyst", "fw-yellow-flux", "fw-red-flux", "fw-green-flux" },
  ["fw-flux-resonance-cell-calibration"] = { "fw-stabilized-flux-crystal", "fw-resonance-substrate", "fw-condensed-flux-matrix", "fw-flux-catalyst", "fw-yellow-flux", "fw-red-flux", "fw-green-flux" },
  ["fw-fulgora-static-mesh"] = { "holmium-plate", "supercapacitor", "fw-metal-mesh", "fw-em-core", "electrolyte", "fw-yellow-flux" },
  ["fw-gleba-spore-resin"] = { "fw-resin", "fw-nutrient-bed", "bioflux", "nutrients", "fw-latex", "fw-green-flux" },
  ["fw-harvester-head"] = { "fw-pressure-housing", "fw-flow-regulator", "fw-transformer-core", "fw-flux-catalyst", "fw-yellow-flux", "electric-motor" },
  ["fw-hydraulic-manifold"] = { "fw-flow-regulator", "fw-pressure-housing", "fw-copper-tube", "fw-reinforced-seal", "fw-elastomer-matrix", "motor" },
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
  ["fw-promethium-matrix"] = { "promethium-asteroid-chunk", "fw-promethium-shard", "fw-stabilized-flux-crystal", "fw-flux-resonance-cell", "fw-logic-matrix", "fw-fulgora-static-mesh", "fw-vulcanus-slag-cermet" },
  ["fw-quantum-computer"] = { "quantum-processor", "fw-logic-matrix", "fw-memory-die", "fw-em-core", "fw-resonance-substrate", "supercapacitor" },
  ["fw-reservoir-lining"] = { "fw-thermal-buffer", "fw-flow-regulator", "fw-ceramic-casing", "fw-cryo-coil", "fw-reinforced-seal", "fw-power-regulator" },
  ["fw-rift-coupler"] = { "fw-phase-anchor", "fw-entanglement-core", "fw-flux-phase-manifold", "fw-model-lattice", "fw-promethium-matrix", "fw-thermal-phase-gasket" },
  ["fw-rift-exchange-fluid-gate"] = { "fw-rift-exchange-gate", "fw-spectral-reservoir", "fw-rift-coupler", "fw-reservoir-lining", "fw-thermal-phase-gasket", "processing-unit" },
  ["fw-rift-stabilizer"] = { "fw-flux-phase-manifold", "fw-promethium-matrix", "fw-logic-matrix", "fw-aquilo-cryogel", "fw-gleba-spore-resin", "fw-fulgora-static-mesh", "fw-vulcanus-slag-cermet" },
  ["fw-sensor-package"] = { "electronic-circuit", "fw-control-assembly", "fw-glass-lens", "tin-plate" },
  ["fw-signal-conduit"] = { "fw-control-assembly", "fw-tinned-cable", "fw-rubber-sheet", "electric-motor" },
  ["fw-spectral-reservoir"] = { "storage-tank", "fw-reservoir-lining", "fw-entanglement-core", "fw-thermal-phase-gasket", "fw-thermal-buffer", "supercapacitor" },
  ["fw-superconductor-bath"] = { "holmium-plate", "fw-cryo-coil", "fw-aquilo-cryogel", "fw-fulgora-static-mesh", "light-oil" },
  ["fw-thermal-phase-gasket"] = { "fw-rubber-sheet", "fw-thermal-buffer", "fw-pressure-housing", "fw-reinforced-seal", "fw-power-regulator" },
  ["fw-transformer-core"] = { "electric-motor", "fw-tinned-cable", "fw-inductor-coil", "bronze-plate" },
  ["industrial-furnace"] = { "electric-furnace", "engine-unit", "fw-foundry-lining", "fw-power-regulator", "fw-hydraulic-manifold" },
  ["laser-turret"] = { "steel-plate", "electronic-circuit", "electric-motor", "fw-capacitor", "fw-cermet", "fw-ceramic-insulator" },
  ["mech-armor"] = { "power-armor-mk2", "superconductor", "supercapacitor", "fw-rift-stabilizer", "fw-flux-resonance-cell", "fw-em-core" },
  ["nuclear-reactor"] = { "concrete", "steel-plate", "titanium-plate", "fw-isotope-matrix", "fw-control-rod-assembly", "fw-reactor-coolant-cartridge" },
  ["oil-refinery"] = { "stone-brick", "electronic-circuit", "fw-steel-beam", "engine-unit", "electric-engine-unit", "electric-motor" },
  ["power-armor-mk2"] = { "power-armor", "processing-unit", "electric-engine-unit", "low-density-structure", "fw-rocket-engine", "fw-logic-matrix" },
  ["promethium-science-pack"] = { "biter-egg", "promethium-asteroid-chunk", "fw-promethium-matrix", "fw-aquilo-cryogel", "fw-gleba-spore-resin", "fw-fulgora-static-mesh", "fw-vulcanus-slag-cermet" },
  ["pumpjack"] = { "electric-motor", "engine-unit", "fw-flow-regulator", "fw-bearing", "pipe" },
  ["quantum-processor"] = { "processing-unit", "superconductor", "lithium-plate", "fluoroketone-cold", "fw-em-core", "fw-logic-matrix", "fw-resonance-substrate" },
  ["spidertron"] = { "exoskeleton-equipment", "fission-reactor-equipment", "rocket-turret", "titanium-plate", "fw-logic-matrix", "fw-em-core" },
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
