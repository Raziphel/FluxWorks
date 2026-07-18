local Startup = require("prototypes.lib.startup-settings")
local Layout = require("prototypes.lib.crafting-tab-layout")

if not Startup.enabled("fw-enable-crafting-tab-reorganization", true) then
  return
end

local function assert_subgroup(prototype_type, name, expected_subgroup)
  local prototype = data.raw[prototype_type] and data.raw[prototype_type][name]
  if prototype and prototype.subgroup ~= expected_subgroup then
    error(
      "FluxWorks crafting tab routing mismatch for "
        .. prototype_type
        .. " "
        .. name
        .. ": expected "
        .. expected_subgroup
        .. ", got "
        .. tostring(prototype.subgroup)
    )
  end
end

local function assert_many(prototype_types, names, expected_subgroup)
  for _, name in pairs(names) do
    for _, prototype_type in pairs(prototype_types) do
      assert_subgroup(prototype_type, name, expected_subgroup)
    end
  end
end

local function assert_subgroup_group(name, expected_group)
  local subgroup = data.raw["item-subgroup"] and data.raw["item-subgroup"][name]
  if subgroup and subgroup.group ~= expected_group then
    error(
      "FluxWorks crafting subgroup mismatch for "
        .. name
        .. ": expected group "
        .. expected_group
        .. ", got "
        .. tostring(subgroup.group)
    )
  end
end

local function assert_absent(prototype_type, name)
  local prototypes = data.raw[prototype_type]
  if prototypes and prototypes[name] then
    error("FluxWorks obsolete " .. prototype_type .. " still present: " .. name)
  end
end

for _, subgroup in ipairs(Layout.subgroups) do
  assert_subgroup_group(subgroup.name, subgroup.group)
end

for _, name in ipairs({
  "fw-science-facilities",
}) do
  assert_absent("item-subgroup", name)
end

for _, name in ipairs({
  "fw-sensor-diode",
  "fw-smelter-array",
  "fw-spore-filter",
  "fw-promethium-primer",
}) do
  assert_absent("item", name)
  assert_absent("recipe", name)
end

assert_absent("recipe", "fw-promethium-sensor-diode-doping")
assert_absent("technology", "fw-sensor-focusing")
assert_absent("technology", "fw-smelter-architectures")
assert_absent("technology", "fw-biosystems-engineering")

for _, name in ipairs({
  "fw-fabrication-science-pack",
  "fw-transport-science-pack",
  "fw-combustion-science-pack",
  "fw-solution-science-pack",
  "fw-instrumentation-science-pack",
}) do
  assert_absent("item", name)
  assert_absent("tool", name)
  assert_absent("recipe", name)
end

assert_many({ "item", "recipe" }, {
  "transport-belt",
  "fast-transport-belt",
  "express-transport-belt",
  "turbo-transport-belt",
  "underground-belt",
  "fast-underground-belt",
  "express-underground-belt",
  "turbo-underground-belt",
  "splitter",
  "fast-splitter",
  "express-splitter",
  "turbo-splitter",
  "fw-kr-loader",
  "fw-kr-fast-loader",
  "fw-kr-express-loader",
  "fw-kr-advanced-loader",
}, "fw-logistics-transport")

assert_many({ "item", "recipe" }, {
  "burner-inserter",
  "inserter",
  "long-handed-inserter",
  "fast-inserter",
  "filter-inserter",
  "bulk-inserter",
  "stack-inserter",
  "stack-filter-inserter",
}, "fw-logistics-inserters")

assert_many({ "item", "recipe" }, {
  "pipe",
  "pipe-to-ground",
  "pump",
  "offshore-pump",
}, "fw-logistics-fluid-handling")

assert_many({ "item", "recipe" }, {
  "rail",
  "locomotive",
  "cargo-wagon",
  "fluid-wagon",
  "artillery-wagon",
  "train-stop",
  "rail-signal",
  "rail-chain-signal",
  "rail-ramp",
  "rail-support",
}, "fw-logistics-rail")

assert_many({ "item", "recipe" }, {
  "wooden-chest",
  "iron-chest",
  "steel-chest",
  "logistic-chest-passive-provider",
  "logistic-chest-active-provider",
  "logistic-chest-storage",
  "logistic-chest-buffer",
  "logistic-chest-requester",
  "storage-tank",
  "fw-phase-vault",
  "fw-spectral-reservoir",
  "fw-kr-strongbox",
  "fw-kr-passive-provider-strongbox",
  "fw-kr-active-provider-strongbox",
  "fw-kr-storage-strongbox",
  "fw-kr-buffer-strongbox",
  "fw-kr-requester-strongbox",
  "fw-kr-warehouse",
  "fw-kr-passive-provider-warehouse",
  "fw-kr-active-provider-warehouse",
  "fw-kr-storage-warehouse",
  "fw-kr-buffer-warehouse",
  "fw-kr-requester-warehouse",
  "fw-kr-big-storage-tank",
  "fw-kr-huge-storage-tank",
}, "fw-logistics-storage")

assert_many({ "item", "recipe" }, {
  "burner-mining-drill",
  "electric-mining-drill",
  "big-mining-drill",
  "pumpjack",
  "fw-flux-quarry",
  "fw-flux-harvester",
  "stone-furnace",
  "steel-furnace",
  "electric-furnace",
  "foundry",
  "fw-arc-foundry",
  "assembling-machine-1",
  "assembling-machine-2",
  "assembling-machine-3",
  "electromagnetic-plant",
  "cryogenic-plant",
  "fw-synthesis-plant",
  "fw-flux-condenser",
  "fw-origin-forge",
}, "fw-production-assembly")

assert_many({ "item", "recipe" }, {
  "chemical-plant",
  "oil-refinery",
  "fw-petrochemical-facility",
  "fw-hydraulic-plant",
  "crusher",
  "recycler",
}, "fw-production-assembly")

assert_many({ "item", "recipe" }, {
  "fw-resin",
  "fw-chlorinated-binder-stock",
  "fw-elastomer-matrix",
  "fw-rubber-sheet",
  "plastic-bar",
}, "fw-chemistry-polymers")

assert_many({ "item", "recipe" }, {
  "fw-rift-exchange-gate",
  "fw-rift-exchange-fluid-gate",
}, "fw-flux-exchange")

assert_many({ "item", "recipe" }, {
  "fw-origin-singularity",
}, "fw-flux-origin-projects")

assert_many({ "recipe" }, {
  "casting-pipe",
  "casting-pipe-to-ground",
}, "fw-production-assembly")

assert_many({ "item", "tool", "recipe" }, {
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
}, "fw-science-packs")

assert_many({ "item", "recipe" }, {
  "lab",
  "biolab",
}, "fw-science-labs")

assert_many({ "item", "recipe" }, {
  "agricultural-tower",
  "biochamber",
}, "fw-bioprocessing-machines")

assert_many({ "item" }, {
  "fw-nutrient-bed",
  "fw-gleba-spore-resin",
}, "fw-bioprocessing-products")

assert_many({ "recipe" }, {
  "fw-nutrient-bed",
  "fw-gleba-spore-resin",
  "fw-green-flux-bioflux-cultivation",
  "fw-green-flux-biolubricant-bloom",
}, "fw-bioprocessing-processes")

assert_many({ "item", "recipe" }, {
  "boiler",
  "steam-engine",
  "solar-panel",
  "lightning-rod",
  "lightning-collector",
}, "fw-energy-generation")

assert_many({ "item", "recipe" }, {
  "accumulator",
  "supercapacitor",
  "fw-thermal-buffer",
  "fw-cryo-coil",
}, "fw-energy-storage")

assert_many({ "item", "recipe" }, {
  "centrifuge",
  "fw-atomic-enricher",
  "fw-isotope-matrix",
  "fw-moderator-lattice",
  "fw-control-rod-assembly",
  "fw-reactor-coolant-cartridge",
  "fw-reactor-dopant",
  "fw-recovered-actinides",
}, "fw-energy-reactors")

assert_many({ "item", "recipe" }, {
  "solid-fuel",
  "rocket-fuel",
  "nuclear-fuel",
  "fusion-power-cell",
  "fw-shielded-fuel-casing",
  "fw-fuel-pellet-bundle",
}, "fw-energy-fuels")

assert_many({ "recipe" }, {
  "fw-reactor-grade-fuel-cell",
  "fw-spent-fuel-reconditioning",
  "fw-pellet-bundle-reprocessing",
  "fw-nuclear-fuel-overdrive",
  "fw-supercapacitor-conditioning",
  "fw-fusion-power-cell-conditioning",
}, "fw-energy-fuels")

assert_many({ "recipe" }, {
  "fw-radioactive-scrap-sorting",
  "fw-isotope-recovery",
  "fw-actinide-matrix-seeding",
  "fw-scrap-lattice-recasting",
  "fw-actinide-dopant-refining",
}, "fw-fabrication-components")

assert_many({ "item", "recipe" }, {
  "fw-signal-conduit",
  "fw-power-regulator",
  "fw-field-winding",
  "fw-flow-regulator",
  "fw-logic-matrix",
  "fw-hydraulic-manifold",
}, "fw-systems-control")

assert_many({ "item", "recipe" }, {
  "fw-lens-array",
  "fw-sensor-package",
  "fw-memory-die",
  "fw-transformer-core",
  "fw-em-core",
}, "fw-systems-instrumentation")

assert_many({ "item", "recipe" }, {
  "small-electric-pole",
  "medium-electric-pole",
  "big-electric-pole",
  "substation",
  "small-lamp",
  "red-wire",
  "green-wire",
  "constant-combinator",
  "arithmetic-combinator",
  "decider-combinator",
  "selector-combinator",
  "power-switch",
  "programmable-speaker",
  "display-panel",
  "construction-robot",
  "logistic-robot",
  "roboport",
  "radar",
  "beacon",
  "remnant-beacon",
}, "fw-systems-infrastructure")

assert_many({ "fluid" }, { "fw-purple-flux" }, "fw-flux-purple")
assert_many({ "fluid" }, { "fw-yellow-flux" }, "fw-flux-yellow")
assert_many({ "fluid" }, { "fw-red-flux" }, "fw-flux-red")
assert_many({ "fluid" }, { "fw-green-flux" }, "fw-flux-green")

assert_many({ "item", "recipe" }, {
  "fw-flux-catalyst",
  "fw-stabilized-flux-crystal",
  "fw-flux-lattice",
  "fw-harvester-head",
  "fw-annealed-cermet",
  "fw-resonance-substrate",
  "fw-quantum-computer",
}, "fw-flux-systems")

assert_many({ "item", "recipe" }, {
  "fw-model-lattice",
  "fw-phase-anchor",
  "fw-entanglement-core",
  "fw-reservoir-lining",
  "fw-compression-baffle",
  "fw-thermal-phase-gasket",
  "fw-rift-coupler",
}, "fw-flux-exchange")

assert_many({ "item", "recipe" }, {
  "fw-condensed-flux-matrix",
  "fw-flux-phase-manifold",
}, "fw-flux-condensing-core")

assert_many({ "item", "recipe" }, {
  "fw-promethium-matrix",
  "fw-rift-stabilizer",
}, "fw-flux-condensing-promethium")

assert_many({ "item", "recipe" }, {
  "fw-storm-spine-segment",
  "fw-origin-crucible-lining",
  "fw-harmonic-lattice-core",
  "fw-living-reactor-weave",
  "fw-origin-catalyst-manifold",
  "fw-storm-spine",
  "fw-origin-crucible",
  "fw-universal-collapse-core",
  "fw-genesis-ark",
}, "fw-flux-origin-projects")

assert_many({ "item", "recipe" }, {
  "fw-fired-ceramic",
  "fw-ceramic-casing",
  "fw-pressure-housing",
  "fw-foundry-lining",
  "fw-reinforced-seal",
  "fw-radioactive-scrap",
}, "fw-intermediate-structural")

assert_many({ "item", "recipe" }, {
  "fw-coil-block",
}, "fw-intermediate-electrical")

assert_many({ "item", "recipe" }, {
  "fw-gunpowder",
  "fw-solder-alloy",
}, "fw-intermediate-ballistic")

assert_many({ "recipe" }, {
  "fw-radioactive-scrap-sorting",
  "fw-isotope-recovery",
}, "fw-fabrication-components")
