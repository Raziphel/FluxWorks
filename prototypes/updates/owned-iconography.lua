-- Keep every player-facing FluxWorks icon on FluxWorks-owned artwork. Recipes
-- that manufacture vanilla products still represent the FluxWorks process,
-- rather than borrowing the vanilla product sprite.

local assets = "__FluxWorksAssets__/graphics/"
local items = assets .. "icons/items/"
local fluids = assets .. "icons/fluids/"
local technology = assets .. "technology/"

local function set_icon(prototype, icon, icon_size)
  if not prototype then return end
  prototype.icon = icon
  prototype.icon_size = icon_size
  prototype.icons = nil
end

local technology_icons = {
  ["fw-comminution"] = { technology .. "fw-comminution.png", 256 },
  ["fw-basic-separation"] = { items .. "fw-inline-filter.png", 256 },
  ["fw-structural-fabrication"] = { items .. "fw-iron-beam.png", 256 },
  ["fw-systems-integration"] = { items .. "fw-solder-wire.png", 256 },
  ["fw-promethium-stabilization"] = { technology .. "fw-promethium-stabilization.png", 256 },
  ["fw-green-propagation-productivity"] = { items .. "fw-living-reactor-weave.png", 128 },
  ["fw-shattered-expedition-planning"] = { technology .. "clean/fw-shattered-expedition-planning.png", 256 },
  ["fw-shattered-platform-hardening"] = { technology .. "fw-shattered-platform-hardening-v3.png", 256 },
  ["fw-shattered-origin-survey"] = { technology .. "fw-origin-survey-lattice-v3.png", 256 },
  ["fw-rift-harmonics"] = { technology .. "fw-rift-harmonics-v3.png", 256 },
  ["fw-rift-network-synchronization"] = { technology .. "mastery/rift-network-synchronization-v3.png", 256 },
  ["fw-origin-transcendence"] = { technology .. "clean/fw-origin-transcendence.png", 256 },
  ["fw-shattered-vent-harmonics"] = { technology .. "clean/fw-shattered-vent-harmonics.png", 256 },
  ["fw-ion-storm-capture"] = { technology .. "clean/fw-ion-storm-capture.png", 256 },
  ["fw-actinide-recovery"] = { technology .. "clean/fw-actinide-recovery.png", 256 },
  ["fw-actinide-reforging"] = { technology .. "clean/fw-actinide-reforging.png", 256 },
  ["fw-orbital-flux-industrialization"] = { technology .. "fw-orbital-flux-industrialization-v2.png", 256 },
  ["fw-deep-phase-storage"] = { technology .. "fw-deep-phase-storage-v2.png", 256 },
  ["fw-flux-field-theory"] = { technology .. "fw-flux-field-theory-v2.png", 256 },
  ["fw-reactive-chemistry-productivity"] = { technology .. "fw-reactive-chemistry-productivity-v2.png", 256 },
  ["fw-industrial-yield-1"] = { technology .. "programs/fw-industrial-yield-1-v2.png", 256 },
  ["fw-industrial-yield-2"] = { technology .. "programs/fw-industrial-yield-2-v2.png", 256 },
  ["fw-industrial-yield-3"] = { technology .. "programs/fw-industrial-yield-3-v2.png", 256 },
  ["fw-industrial-district-project"] = { items .. "fw-origin-crucible-lining.png", 128 },
  ["fw-autonomous-network-project"] = { items .. "fw-tinned-cable.png", 128 },
  ["fw-spectrum-control-project"] = { items .. "fw-condensed-flux-matrix-v2.png", 256 },
  ["fw-convergence-directive-project"] = { items .. "fw-origin-catalyst-manifold.png", 128 },
}

-- Research programs and capstone technologies use one readable subject. The
-- numbered tiers deliberately retain one silhouette, matching Factorio's own
-- upgrade-series convention, while each prototype keeps a unique asset path.
local clean_programs = {
  "fw-actinide-closure-methods",
  "fw-autonomous-logistics",
  "fw-control-miniaturization",
  "fw-cryogenic-reclamation",
  "fw-flux-process-mastery",
  "fw-orbital-recovery",
  "fw-polymer-throughput",
  "fw-precision-ceramics",
  "fw-pressure-systems",
  "fw-rail-network-control",
  "fw-research-methodology",
  "fw-spectral-hardware",
}

for tier = 1, 3 do
  technology_icons["fw-material-handling-" .. tier] = {
    technology .. "clean/fw-material-handling-" .. tier .. "-v2.png", 256,
  }
end

for _, stem in ipairs(clean_programs) do
  for tier = 1, 3 do
    local name = stem .. "-" .. tier
    technology_icons[name] = { technology .. "clean/" .. name .. ".png", 256 }
  end
end

local clean_capstones = {
  "fw-actinide-closure",
  "fw-convergence-research",
  "fw-flux-synthesis-mastery",
  "fw-green-spectrum-calibration",
  "fw-red-spectrum-calibration",
  "fw-rift-harmonics",
  "fw-rift-network-synchronization",
  "fw-rift-transfer-harmonics",
  "fw-shattered-origin-survey",
  "fw-shattered-planet-yield",
  "fw-shattered-platform-hardening",
  "fw-spectral-recovery-theory",
  "fw-spectral-reservoir-density",
  "fw-unified-spectrum-control",
  "fw-yellow-spectrum-calibration",
}

for _, name in ipairs(clean_capstones) do
  technology_icons[name] = { technology .. "clean/" .. name .. ".png", 256 }
end

local clean_mismatches = {
  "fw-cable-looming",
  "fw-contact-casting",
  "fw-cryogenic-loop-productivity",
  "fw-dense-ore-smelting",
  "fw-flux-green-cultivation",
  "fw-flux-green-propagation",
  "fw-flux-green-reclamation",
  "fw-flux-metallurgy",
  "fw-flux-mining-productivity",
  "fw-flux-phase-engineering",
  "fw-fuel-fabrication",
  "fw-green-cultivation-productivity",
  "fw-petrochemical-engineering",
  "fw-signal-architecture",
  "fw-shattered-landing-protocols",
  "fw-vulcanus-industrial-symbiosis",
}

for _, name in ipairs(clean_mismatches) do
  technology_icons[name] = { technology .. "clean/" .. name .. ".png", 256 }
end

for name, icon_data in pairs(technology_icons) do
  set_icon(data.raw.technology and data.raw.technology[name], icon_data[1], icon_data[2])
end

local recipe_icons = {
  ["fw-chlorine"] = { fluids .. "ArtisanalReskins_alien-poison.png", 64 },
  ["fw-chlorine-pressurization"] = { fluids .. "ArtisanalReskins_alien-poison.png", 64 },
  ["fw-sulfur-bonding"] = { items .. "fw-chlorinated-binder-stock.png", 256 },
  ["fw-acid-synthesis"] = { fluids .. "ArtisanalReskins_alien-poison.png", 64 },
  ["fw-reactive-slurry"] = { fluids .. "fw-blasting-gel.png", 64 },
  ["fw-battery-electrolyte"] = { items .. "fw-capacitor.png", 128 },
  ["fw-napalm"] = { fluids .. "ArtisanalReskins_alien-fire.png", 64 },
  ["fw-electrolyte-conditioning"] = { items .. "fw-power-regulator-v2.png", 256 },
  ["fw-lithium-adsorption"] = { items .. "fw-aquilo-cryogel.png", 128 },
  ["fw-fluoroketone-synthesis"] = { items .. "fw-reactor-coolant-cartridge.png", 64 },
  ["fw-superconductor-bath"] = { items .. "fw-cryo-coil.png", 256 },
  ["fw-supercapacitor-conditioning"] = { items .. "fw-capacitor.png", 128 },
  ["fw-fusion-power-cell-conditioning"] = { items .. "fw-isotope-matrix.png", 64 },
  ["fw-reactive-slurry-focusing"] = { fluids .. "fw-blasting-gel.png", 64 },
  ["fw-gelled-napalm-mixing"] = { fluids .. "ArtisanalReskins_alien-fire.png", 64 },
  ["fw-spectral-coolant-recycling"] = { items .. "fw-reactor-coolant-cartridge.png", 64 },
  ["fw-flux-metallic-synthesis"] = { items .. "fw-isotope-matrix.png", 64 },
  ["fw-catalytic-polymerization"] = { items .. "fw-resin.png", 64 },
  ["fw-sour-gas-desulfurization"] = { items .. "fw-inline-filter.png", 256 },
  ["fw-heavy-oil-dewaxing"] = { items .. "fw-reinforced-seal.png", 64 },
  ["fw-reactor-grade-fuel-cell"] = { items .. "fw-fuel-pellet-bundle.png", 256 },
  ["fw-spent-fuel-reconditioning"] = { items .. "fw-radioactive-scrap.png", 256 },
  ["fw-nuclear-fuel-overdrive"] = { items .. "fw-reactor-dopant.png", 256 },
  ["fw-precision-uranium-assay"] = { items .. "fw-recovered-actinides.png", 64 },
  ["fw-flux-isotope-separation"] = { items .. "fw-isotope-matrix.png", 64 },
  ["fw-depleted-cell-dissolution"] = { items .. "fw-radioactive-scrap.png", 256 },
  ["fw-fusion-cell-doping"] = { items .. "fw-reactor-dopant.png", 256 },
  ["fw-orbital-flux-chunk-sorting"] = { items .. "fw-flux-asteroid-chunk.png", 128 },
  ["fw-green-seedbank-propagation"] = { items .. "fw-gleba-spore-resin.png", 128 },
}

for name, icon_data in pairs(recipe_icons) do
  set_icon(data.raw.recipe and data.raw.recipe[name], icon_data[1], icon_data[2])
end

-- Generated Flux recovery recipes used vanilla ingredient stickers. Their
-- spectrum and names already communicate the source; keep the icon purely Flux.
for name, recipe in pairs(data.raw.recipe or {}) do
  if string.match(name, "^fw%-purple%-flux%-from%-") then
    set_icon(recipe, fluids .. "flux-purple.png", 256)
  elseif string.match(name, "^fw%-yellow%-flux%-from%-") then
    set_icon(recipe, fluids .. "flux-yellow.png", 256)
  elseif string.match(name, "^fw%-red%-flux%-from%-") then
    set_icon(recipe, fluids .. "flux-red.png", 256)
  elseif string.match(name, "^fw%-green%-flux%-from%-") then
    set_icon(recipe, fluids .. "flux-green.png", 256)
  end
end

set_icon(data.raw.fluid and data.raw.fluid["fw-chlorine"], fluids .. "ArtisanalReskins_alien-poison.png", 64)
set_icon(data.raw.fluid and data.raw.fluid["fw-napalm"], fluids .. "ArtisanalReskins_alien-fire.png", 64)

local bacteria_icons = {
  ["fw-lead-bacteria"] = "fw-lead-bacteria-v2.png",
  ["fw-bauxite-bacteria"] = "fw-bauxite-bacteria-v2.png",
  ["fw-tin-bacteria"] = "fw-tin-bacteria-v2.png",
  ["fw-silicon-bacteria"] = "fw-silicon-bacteria-v2.png",
  ["fw-titanium-bacteria"] = "fw-titanium-bacteria-v2.png",
}

for name, filename in pairs(bacteria_icons) do
  local prototype = (data.raw.item and data.raw.item[name])
    or (data.raw["item-with-tags"] and data.raw["item-with-tags"][name])
  set_icon(prototype, items .. filename, 256)
end

local resource_icons = {
  ["fw-silica-vein"] = { assets .. "icons/resources/fw-mineral-deposit.png", 64 },
  ["fw-metallic-deposit"] = { assets .. "icons/resources/fw-metallic-deposit.png", 64 },
  ["fw-carbonic-deposit"] = { assets .. "icons/resources/fw-carbonic-deposit.png", 64 },
  ["fw-promethium-impact"] = { items .. "fw-promethium-shard-v2.png", 256 },
}

for name, icon_data in pairs(resource_icons) do
  set_icon(data.raw.resource and data.raw.resource[name], icon_data[1], icon_data[2])
end

set_icon(data.raw.lightning and data.raw.lightning["fw-ion-lightning"], fluids .. "flux-purple.png", 256)
