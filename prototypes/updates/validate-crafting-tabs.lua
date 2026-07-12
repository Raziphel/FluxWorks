local Startup = require("prototypes.lib.startup-settings")

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

for _, entry in pairs({
  { "fw-logistics-transport", "logistics" },
  { "fw-logistics-inserters", "logistics" },
  { "fw-logistics-fluid-handling", "logistics" },
  { "fw-logistics-rail", "logistics" },
  { "fw-logistics-storage", "logistics" },
  { "fw-logistics-power", "logistics" },
  { "fw-logistics-circuitry", "logistics" },
  { "fw-logistics-robotics", "logistics" },
  { "fw-logistics-network", "logistics" },
  { "fw-production-extraction", "production" },
  { "fw-production-smelting", "production" },
  { "fw-production-assembly", "production" },
  { "fw-production-chemistry", "production" },
  { "fw-production-specialized", "production" },
  { "fw-production-processing", "production" },
  { "fw-science-packs", "fw-science" },
  { "fw-science-labs", "fw-science" },
  { "fw-science-facilities", "fw-science" },
  { "fw-bioprocessing-machines", "fw-bioprocessing" },
  { "fw-bioprocessing-products", "fw-bioprocessing" },
  { "fw-bioprocessing-processes", "fw-bioprocessing" },
  { "fw-energy-generation", "fw-energy" },
  { "fw-energy-storage", "fw-energy" },
  { "fw-energy-reactors", "fw-energy" },
  { "fw-energy-fuels", "fw-energy" },
  { "fw-chemistry-machines", "fw-chemistry" },
  { "fw-chemistry-feedstocks", "fw-chemistry" },
  { "fw-chemistry-polymers", "fw-chemistry" },
  { "fw-chemistry-reactives", "fw-chemistry" },
  { "fw-chemistry-fluids", "fw-chemistry" },
  { "fw-chemistry-petrochem", "fw-chemistry" },
  { "fw-chemistry-advanced", "fw-chemistry" },
  { "fw-chemistry-barrels", "fw-chemistry" },
  { "fw-chemistry-materials", "fw-chemistry" },
  { "fw-chemistry-processes", "fw-chemistry" },
  { "fw-systems-machines", "fw-systems" },
  { "fw-systems-control", "fw-systems" },
  { "fw-systems-instrumentation", "fw-systems" },
  { "fw-systems-infrastructure", "fw-systems" },
  { "fw-fabrication-machines", "fw-fabrication" },
  { "fw-intermediate-structural", "fw-fabrication" },
  { "fw-intermediate-electrical", "fw-fabrication" },
  { "fw-intermediate-precision", "fw-fabrication" },
  { "fw-intermediate-ballistic", "fw-fabrication" },
  { "fw-intermediate-aerospace", "fw-fabrication" },
  { "fw-fabrication-components", "fw-fabrication" },
  { "fw-flux-machines", "fw-flux" },
  { "fw-flux-resources", "fw-flux" },
  { "fw-flux-systems", "fw-flux" },
  { "fw-flux-purple", "fw-flux" },
  { "fw-flux-yellow", "fw-flux" },
  { "fw-flux-red", "fw-flux" },
  { "fw-flux-green", "fw-flux" },
  { "fw-transmutation-upcycle", "fw-flux" },
  { "fw-transmutation-downcycle", "fw-flux" },
  { "fw-flux-condensing-core", "fw-flux" },
  { "fw-flux-condensing-promethium", "fw-flux" },
  { "fw-flux-exchange", "fw-flux" },
  { "fw-flux-origin-projects", "fw-flux" },
}) do
  assert_subgroup_group(entry[1], entry[2])
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
}, "fw-production-extraction")

assert_many({ "item", "recipe" }, {
  "stone-furnace",
  "steel-furnace",
  "electric-furnace",
  "foundry",
  "fw-arc-foundry",
}, "fw-production-smelting")

assert_many({ "item", "recipe" }, {
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
}, "fw-production-chemistry")

assert_many({ "item", "recipe" }, {
  "crusher",
  "recycler",
}, "fw-production-specialized")

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
}, "fw-production-smelting")

assert_many({ "item", "tool", "recipe" }, {
  "automation-science-pack",
  "logistic-science-pack",
  "chemical-science-pack",
  "production-science-pack",
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
  "fw-spore-filter",
  "fw-gleba-spore-resin",
}, "fw-bioprocessing-products")

assert_many({ "recipe" }, {
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
  "fw-reactor-instrument-cluster",
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
  "fw-nuclear-fuel-overdrive",
  "fw-supercapacitor-conditioning",
  "fw-fusion-power-cell-conditioning",
}, "fw-energy-fuels")

assert_many({ "item", "recipe" }, {
  "fw-signal-conduit",
  "fw-power-regulator",
  "fw-field-winding",
  "fw-flow-regulator",
  "fw-logic-matrix",
  "fw-servo-valve",
  "fw-hydraulic-manifold",
  "fw-hydraulic-core",
  "fw-quantum-spindle",
}, "fw-systems-control")

assert_many({ "item", "recipe" }, {
  "fw-lens-array",
  "fw-sensor-diode",
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
  "fw-promethium-primer",
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
  "fw-polymer-binder",
  "fw-chlorinated-binder-stock",
  "fw-elastomer-matrix",
}, "fw-chemistry-polymers")

assert_many({ "item", "recipe" }, {
  "fw-fired-ceramic",
  "fw-ceramic-casing",
  "fw-pressure-housing",
  "fw-foundry-lining",
  "fw-smelter-array",
  "fw-reinforced-seal",
  "fw-hydraulic-actuator",
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
