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

local technology_item_icons = {
  ["fw-flux-mining-productivity"] = { "__FluxWorksAssets__/graphics/technology/native/fw-flux-mining-productivity.png", 256 },
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
  ["fw-power-regulation"] = { "fw-power-regulator-v2.png", 256 },
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
  ["fw-power-regulator"] = { "fw-power-regulator-v2.png", 256 },
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

-- Final milestone pass: technologies that share an industrial family still need
-- distinct silhouettes in the research tree. Reuse authored FluxWorks items that
-- communicate the actual reward instead of repeating a neighboring technology tile.
local distinct_technology_icons = {
  ["fw-industrial-expansion"] = { item_path .. "fw-drive-module.png", 128 },
  ["fw-signal-architecture"] = { item_path .. "fw-ribbon-cable.png", 256 },
  ["fw-vulcanus-industrial-symbiosis"] = { technology_path .. "fw-metallurgic-assemblies.png", 256 },
  ["fw-gleba-regenerative-symbiosis"] = { item_path .. "fw-gleba-spore-resin.png", 128 },
  ["fw-aquilo-thermal-symbiosis"] = { item_path .. "fw-aquilo-cryogel.png", 128 },
  ["fw-superconductive-systems"] = { item_path .. "fw-transformer-core.png", 256 },
  ["fw-cross-planetary-industrial-convergence"] = { item_path .. "fw-promethium-matrix.png", 256 },
  ["fw-shattered-vulcanus-bridgehead"] = { item_path .. "fw-vulcanus-promethium-refractory-assay.png", 256 },
  ["fw-shattered-gleba-bridgehead"] = { item_path .. "fw-gleba-promethium-radiotrophic-assay.png", 256 },
  ["fw-shattered-fulgora-bridgehead"] = { item_path .. "fw-fulgora-promethium-phase-assay.png", 256 },
  ["fw-shattered-aquilo-bridgehead"] = { item_path .. "fw-aquilo-promethium-cryophase-assay.png", 256 },
  ["fw-ion-storm-survival"] = { item_path .. "fw-storm-spine-segment.png", 128 },
  ["fw-shattered-network-logistics"] = { technology_path .. "fw-rift-logistics.png", 256 },
  ["fw-ion-storm-capture"] = { item_path .. "fw-harmonic-lattice-core.png", 128 },
  ["fw-actinide-reforging"] = { item_path .. "fw-recovered-actinides.png", 64 },
}

for technology_name, icon_data in pairs(distinct_technology_icons) do
  local technology = data.raw.technology and data.raw.technology[technology_name]
  if technology then
    technology.icon = icon_data[1]
    technology.icon_size = icon_data[2]
    technology.icons = nil
  end
end
