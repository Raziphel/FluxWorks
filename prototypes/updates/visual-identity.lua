-- Use our art where we have it.

local technology_path = "__FluxWorksAssets__/graphics/technology/"
local item_path = "__FluxWorksAssets__/graphics/icons/items/"

local technology_icons = {
  ["fw-actinide-recovery"] = { "fw-actinide-recovery.png", 256 },
  ["fw-cryogenic-loop-productivity"] = { "fw-cryogenic-loop-productivity.png", 256 },
  ["fw-electromagnetic-architecture"] = { "fw-electromagnetic-architecture.png", 256 },
  ["fw-flux-phase-engineering"] = { "fw-flux-phase-engineering.png", 64 },
  ["fw-flux-thermal-networks"] = { "fw-flux-thermal-networks.png", 256 },
  ["fw-liquid-mining"] = { "fw-liquid-mining.png", 256 },
  ["fw-optical-instrumentation"] = { "fw-optical-instrumentation.png", 256 },
  ["fw-reactive-chemistry-productivity"] = { "fw-reactive-chemistry-productivity.png", 256 },
}

for technology_name, icon_data in pairs(technology_icons) do
  local technology = data.raw.technology and data.raw.technology[technology_name]
  if technology then
    technology.icon = technology_path .. icon_data[1]
    technology.icon_size = icon_data[2]
    technology.icons = nil
  end
end

-- Prefer one readable native illustration per technology. Small corner badges
-- become visual noise in the research tree and look pasted on at larger scale.
local native_technology_icons = {
  ["fw-actinide-recovery.png"] = { "base", "nuclear-fuel-reprocessing", "uranium-processing" },
  ["fw-asteroid-refinement-productivity.png"] = { "space-age", "asteroid-productivity", "advanced-asteroid-processing" },
  ["fw-biosystems-engineering.png"] = { "space-age", "biochamber", "bacteria-cultivation" },
  ["fw-ceramic-engineering.png"] = { "space-age", "foundry", "tungsten-carbide" },
  ["fw-conductive-networks.png"] = { "base", "circuit-network", "electric-energy-distribution-2" },
  ["fw-cryogenic-control.png"] = { "space-age", "cryogenic-plant", "aquilo" },
  ["fw-cryogenic-loop-productivity.png"] = { "space-age", "cryogenic-plant", "research-productivity" },
  ["fw-deep-phase-storage.png"] = { "base", "electric-energy-acumulators", "battery-mk2-equipment" },
  ["fw-electromagnetic-architecture.png"] = { "space-age", "electromagnetic-plant", "tesla-weapons" },
  ["fw-fluid-control-architecture.png"] = { "base", "fluid-handling", "advanced-oil-processing" },
  ["fw-flux-chemical-synthesis.png"] = { "base", "sulfur-processing", "advanced-oil-processing" },
  ["fw-flux-field-theory.png"] = { "space-age", "electromagnetic-science-pack", "fusion-reactor" },
  ["fw-flux-green-cultivation.png"] = { "space-age", "agriculture", "bioflux-processing" },
  ["fw-flux-phase-engineering.png"] = { "space-age", "quantum-processor", "fusion-reactor" },
  ["fw-flux-resonance.png"] = { "space-age", "fusion-reactor", "electromagnetic-science-pack" },
  ["fw-flux-stabilization.png"] = { "base", "advanced-circuit", "battery" },
  ["fw-flux-thermal-networks.png"] = { "space-age", "heating-tower", "base", "fluid-handling" },
  ["fw-green-cycle-productivity.png"] = { "space-age", "bioflux-processing", "research-productivity" },
  ["fw-hydraulic-systems.png"] = { "base", "fluid-handling", "engine" },
  ["fw-industrial-expansion.png"] = { "base", "automation-3", "advanced-material-processing-2" },
  ["fw-isotope-conditioning.png"] = { "base", "uranium-processing", "kovarex-enrichment-process" },
  ["fw-liquid-mining.png"] = { "base", "oil-gathering", "electric-mining-drill" },
  ["fw-metallurgic-assemblies.png"] = { "space-age", "foundry", "metallurgic-science-pack" },
  ["fw-optical-instrumentation.png"] = { "base", "laser", "circuit-network" },
  ["fw-petrochemical-engineering.png"] = { "base", "advanced-oil-processing", "plastics" },
  ["fw-polymer-stabilization.png"] = { "base", "plastics", "sulfur-processing" },
  ["fw-promethium-stabilization.png"] = { "space-age", "promethium-science-pack", "quantum-processor" },
  ["fw-reactive-chemistry-productivity.png"] = { "base", "explosives", "space-age", "research-productivity" },
  ["fw-reactor-doping.png"] = { "base", "nuclear-power", "uranium-processing" },
  ["fw-reactor-instrumentation.png"] = { "base", "nuclear-power", "circuit-network" },
  ["fw-remnant-beacon.png"] = { "base", "effect-transmission", "radar" },
  ["fw-resonance-assemblies.png"] = { "space-age", "fusion-reactor", "base", "automation-3" },
  ["fw-rift-logistics.png"] = { "space-age", "quantum-processor", "base", "logistic-system" },
  ["fw-rocket-chunk-processing.png"] = { "base", "rocket-silo", "advanced-material-processing-2" },
  ["fw-sealed-systems.png"] = { "base", "fluid-handling", "battery" },
  ["fw-spectral-fluid-retention.png"] = { "space-age", "holmium-processing", "base", "fluid-handling" },
  ["fw-superconductive-productivity.png"] = { "space-age", "electromagnetic-science-pack", "research-productivity" },
}

local function native_technology_path(mod_name, icon_name)
  return "__" .. mod_name .. "__/graphics/technology/" .. icon_name .. ".png"
end

local function rendered_technology_filename(technology)
  local filename = technology.icon and string.match(
      technology.icon,
      "^__FluxWorksAssets__/graphics/technology/([^/]+%.png)$"
    )
  if filename then return filename end
  for _, layer in ipairs(technology.icons or {}) do
    filename = layer.icon and string.match(
      layer.icon,
      "^__FluxWorksAssets__/graphics/technology/([^/]+%.png)$"
    )
    if filename then return filename end
  end
end

for _, technology in pairs(data.raw.technology or {}) do
  local filename = rendered_technology_filename(technology)
  local icon_data = filename and native_technology_icons[filename]
  if icon_data then
    technology.icon = native_technology_path(icon_data[1], icon_data[2])
    technology.icon_size = 256
    technology.icons = nil
  end
end

local technology_item_icons = {
  ["fw-flux-mining-productivity"] = { "__FluxWorksAssets__/graphics/technology/native/fw-flux-mining-productivity.png", 64 },
  ["fw-flux-green-reclamation"] = { "__FluxWorksAssets__/graphics/technology/native/fw-flux-green-reclamation.png", 64 },
  ["fw-aquilo-cryochemistry"] = { "__FluxWorksAssets__/graphics/technology/native/fw-aquilo-cryochemistry.png", 64 },
  ["fw-flux-reactive-slurries"] = { "__FluxWorksAssets__/graphics/technology/native/fw-flux-reactive-slurries.png", 64 },
  ["fw-energetic-compounds"] = { "__FluxWorksAssets__/graphics/technology/native/fw-energetic-compounds.png", 64 },
  ["fw-reactive-binders"] = { "__FluxWorksAssets__/graphics/technology/native/fw-reactive-binders.png", 64 },
  ["fw-beam-engineering"] = { "fw-aluminum-beam.png", 256 },
  ["fw-circuit-foundry"] = { "fw-circuit-substrate.png", 256 },
  ["fw-conductive-assembly"] = { "fw-circuit-contact.png", 64 },
  ["fw-elastomer-engineering"] = { "fw-elastomer-matrix.png", 64 },
  ["fw-flux-red-energetics"] = { "fw-annealed-cermet.png", 256 },
  ["fw-fusion-lattices"] = { "fw-flux-lattice.png", 256 },
  ["fw-power-regulation"] = { "fw-power-regulator.png", 256 },
  ["fw-wafer-etching"] = { "fw-silicon-wafer.png", 128 },
}

for technology_name, icon_data in pairs(technology_item_icons) do
  local technology = data.raw.technology and data.raw.technology[technology_name]
  if technology then
    technology.icon = string.sub(icon_data[1], 1, 2) == "__" and icon_data[1] or (item_path .. icon_data[1])
    technology.icon_size = icon_data[2]
    technology.icons = nil
  end
end

local origin_technology_icons = {
  ["fw-origin-infrastructure"] = { "fw-origin-forge.png", 64 },
  ["fw-storm-megastructures"] = { "fw-storm-spine.png", 64 },
}

for technology_name, icon_data in pairs(origin_technology_icons) do
  local technology = data.raw.technology and data.raw.technology[technology_name]
  if technology then
    technology.icon = item_path .. "origin-projects/" .. icon_data[1]
    technology.icon_size = icon_data[2]
    technology.icons = nil
  end
end

local item_icons = {
  ["fw-power-regulator"] = { "fw-power-regulator.png", 256 },
}

for item_name, icon_data in pairs(item_icons) do
  local item = data.raw.item and data.raw.item[item_name]
  if item then
    item.icon = item_path .. icon_data[1]
    item.icon_size = icon_data[2]
    item.icons = nil
  end
  local recipe = data.raw.recipe and data.raw.recipe[item_name]
  if recipe then
    recipe.icon = item_path .. icon_data[1]
    recipe.icon_size = icon_data[2]
    recipe.icons = nil
  end
end

-- FluxWorks technologies use a single authored silhouette. Older definitions
-- sometimes combined a technology image with item or science-pack stickers;
-- retain the primary illustration and discard those incidental overlays.
for technology_name, technology in pairs(data.raw.technology or {}) do
  if string.sub(technology_name, 1, 3) == "fw-" and technology.icons and technology.icons[1] then
    local primary = technology.icons[1]
    technology.icon = primary.icon
    technology.icon_size = primary.icon_size or 64
    technology.icons = nil
  end
end
