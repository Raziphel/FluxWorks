-- Prefer FluxWorks' dedicated artwork over borrowed placeholder icons whenever
-- a matching asset already exists in FluxWorksAssets.

local technology_path = "__FluxWorksAssets__/graphics/technology/"
local item_path = "__FluxWorksAssets__/graphics/icons/items/"

local technology_icons = {
  ["fw-actinide-recovery"] = { "fw-actinide-recovery.png", 256 },
  ["fw-cryogenic-loop-productivity"] = { "fw-cryogenic-loop-productivity.png", 1024 },
  ["fw-electromagnetic-architecture"] = { "fw-electromagnetic-architecture.png", 1024 },
  ["fw-flux-phase-engineering"] = { "fw-flux-phase-engineering.png", 64 },
  ["fw-flux-thermal-networks"] = { "fw-flux-thermal-networks.png", 256 },
  ["fw-liquid-mining"] = { "fw-liquid-mining.png", 256 },
  ["fw-optical-instrumentation"] = { "fw-optical-instrumentation.png", 256 },
  ["fw-reactive-chemistry-productivity"] = { "fw-reactive-chemistry-productivity.png", 1024 },
  ["fw-shattered-expedition-planning"] = { "native/fw-shattered-expedition-planning.png", 256 },
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
  ["fw-comminution"] = { "__FluxWorksAssets__/graphics/technology/native/fw-comminution.png", 64 },
  ["fw-flux-mining-productivity"] = { "__FluxWorksAssets__/graphics/technology/native/fw-flux-mining-productivity.png", 64 },
  ["fw-flux-green-reclamation"] = { "__FluxWorksAssets__/graphics/technology/native/fw-flux-green-reclamation.png", 64 },
  ["fw-aquilo-cryochemistry"] = { "__FluxWorksAssets__/graphics/technology/native/fw-aquilo-cryochemistry.png", 64 },
  ["fw-flux-reactive-slurries"] = { "__FluxWorksAssets__/graphics/technology/native/fw-flux-reactive-slurries.png", 64 },
  ["fw-energetic-compounds"] = { "__FluxWorksAssets__/graphics/technology/native/fw-energetic-compounds.png", 64 },
  ["fw-promethium-stabilization"] = { "__FluxWorksAssets__/graphics/technology/native/fw-promethium-stabilization.png", 64 },
  ["fw-reactive-binders"] = { "__FluxWorksAssets__/graphics/technology/native/fw-reactive-binders.png", 64 },
  ["fw-beam-engineering"] = { "fw-aluminum-beam.png", 1024 },
  ["fw-circuit-foundry"] = { "fw-circuit-substrate.png", 1024 },
  ["fw-conductive-assembly"] = { "fw-circuit-contact.png", 64 },
  ["fw-elastomer-engineering"] = { "fw-elastomer-matrix.png", 64 },
  ["fw-flux-red-energetics"] = { "fw-annealed-cermet.png", 256 },
  ["fw-fusion-lattices"] = { "fw-flux-lattice.png", 1254 },
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
