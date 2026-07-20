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

local function assert_order(prototype_type, name, expected_order)
  local prototype = data.raw[prototype_type] and data.raw[prototype_type][name]
  if prototype and prototype.order ~= expected_order then
    error(
      "FluxWorks crafting order mismatch for "
        .. prototype_type
        .. " "
        .. name
        .. ": expected "
        .. expected_order
        .. ", got "
        .. tostring(prototype.order)
    )
  end
end

local function assert_absent(prototype_type, name)
  local prototypes = data.raw[prototype_type]
  if prototypes and prototypes[name] then
    error("FluxWorks obsolete " .. prototype_type .. " still present: " .. name)
  end
end

local flux_group = data.raw["item-group"] and data.raw["item-group"]["fw-flux"]
if flux_group then
  local expected_icon = "__FluxWorksAssets__/graphics/icons/items/flux.png"
  if flux_group.icon ~= expected_icon or flux_group.icon_size ~= 64 then
    error("FluxWorks Flux crafting tab must use the actual Flux icon")
  end
end

for _, subgroup in ipairs(Layout.subgroups) do
  assert_subgroup_group(subgroup.name, subgroup.group)
end

for _, name in ipairs({
  "fw-science-facilities",
  "fw-systems-machines",
  "fw-systems-control",
  "fw-systems-instrumentation",
  "fw-systems-infrastructure",
}) do
  assert_absent("item-subgroup", name)
end

assert_absent("item-group", "fw-systems")

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
  "area-mining-drill",
}, "extraction-machine")

assert_many({ "item", "recipe" }, {
  "stone-furnace",
  "steel-furnace",
  "electric-furnace",
  "foundry",
  "fw-arc-foundry",
  "industrial-furnace",
}, "smelting-machine")

assert_many({ "item", "recipe" }, {
  "burner-assembling-machine",
  "assembling-machine-1",
  "assembling-machine-2",
  "assembling-machine-3",
  "electromagnetic-plant",
  "cryogenic-plant",
  "fw-synthesis-plant",
  "fw-flux-condenser",
  "fw-origin-forge",
  "chemical-plant",
  "oil-refinery",
  "fw-petrochemical-facility",
  "fw-hydraulic-plant",
  "crusher",
  "recycler",
  "fuel-processor",
}, "production-machine")

assert_many({ "item", "recipe" }, { "burner-lab" }, "fw-science-labs")
assert_many({ "item", "recipe" }, { "captive-biter-spawner" }, "fw-bioprocessing-machines")

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
  "fw-industrial-methods-science-pack",
  "fw-systems-analysis-science-pack",
  "fw-flux-theory-science-pack",
  "fw-planetary-convergence-science-pack",
}, "fw-science-packs")

for _, entry in ipairs({
  { "automation-science-pack", "a[progression]-01[automation]" },
  { "logistic-science-pack", "a[progression]-02[logistic]" },
  { "fw-industrial-methods-science-pack", "a[progression]-03[industrial-methods]" },
  { "military-science-pack", "a[progression]-04[military]" },
  { "chemical-science-pack", "a[progression]-05[chemical]" },
  { "production-science-pack", "a[progression]-06[production]" },
  { "fw-systems-analysis-science-pack", "a[progression]-07[systems-analysis]" },
  { "utility-science-pack", "a[progression]-08[utility]" },
  { "space-science-pack", "a[progression]-09[space]" },
  { "fw-flux-theory-science-pack", "a[progression]-10[flux-theory]" },
  { "metallurgic-science-pack", "b[planetary]-01[metallurgic]" },
  { "electromagnetic-science-pack", "b[planetary]-02[electromagnetic]" },
  { "agricultural-science-pack", "b[planetary]-03[agricultural]" },
  { "cryogenic-science-pack", "b[planetary]-04[cryogenic]" },
  { "promethium-science-pack", "b[planetary]-05[promethium]" },
  { "fw-planetary-convergence-science-pack", "b[planetary]-06[convergence]" },
}) do
  for _, prototype_type in ipairs({ "tool", "item", "recipe" }) do
    assert_order(prototype_type, entry[1], entry[2])
  end
end

assert_many({ "item", "recipe" }, {
  "fw-industrial-district-charter",
  "fw-autonomous-network-charter",
  "fw-spectrum-control-charter",
  "fw-convergence-directive",
}, "fw-progression-projects")

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
  "burner-turbine",
  "boiler",
  "steam-engine",
  "heating-tower",
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
  "nuclear-reactor",
  "heat-pipe",
  "heat-exchanger",
  "steam-turbine",
  "fusion-reactor",
  "fusion-generator",
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
}, "fw-logistics-circuitry")

assert_many({ "item", "recipe" }, {
  "fw-signal-conduit",
  "fw-power-regulator",
  "fw-field-winding",
  "fw-transformer-core",
  "fw-em-core",
}, "fw-intermediate-electrical")

assert_many({ "item", "recipe" }, {
  "fw-logic-matrix",
  "fw-lens-array",
  "fw-sensor-package",
  "fw-memory-die",
  "fw-flow-regulator",
  "fw-hydraulic-manifold",
}, "fw-intermediate-precision")

assert_many({ "item", "recipe" }, {
  "construction-robot",
  "logistic-robot",
  "roboport",
}, "fw-logistics-robotics")

-- Logistics is for usable infrastructure. FluxWorks-owned crafting stock must
-- remain in Fabrication, Chemistry, Science, or Flux instead of being mixed
-- into the rows of belts, pipes, power poles, and network entities.
for item_name, item in pairs(data.raw.item or {}) do
  local subgroup = item.subgroup and data.raw["item-subgroup"] and data.raw["item-subgroup"][item.subgroup]
  if string.sub(item_name, 1, 3) == "fw-"
    and subgroup
    and subgroup.group == "logistics"
    and not item.place_result
    and not item.place_as_tile
  then
    error("FluxWorks intermediate routed into Logistics: " .. item_name .. " in " .. item.subgroup)
  end
end

assert_many({ "item", "recipe" }, {
  "radar",
  "beacon",
  "remnant-beacon",
}, "fw-logistics-network")

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
  "fw-flux-fired-ceramic-annealing",
  "fw-arc-glass-recast",
  "fw-arc-insulator-vitrification",
  "fw-flux-cermet-tempering",
  "fw-arc-cermet-densification",
  "fw-vulcanus-slag-cermet",
}, "fw-fabrication-components")

for recipe_name, recipe in pairs(data.raw.recipe or {}) do
  local recycled_name = string.match(recipe_name, "^(.*)%-recycling$")
  local recycled_item = recycled_name and data.raw.item and data.raw.item[recycled_name]
  if recycled_item and recipe.subgroup ~= recycled_item.subgroup then
    error(
      "FluxWorks recycling tab routing mismatch for "
        .. recipe_name
        .. ": expected "
        .. tostring(recycled_item.subgroup)
        .. ", got "
        .. tostring(recipe.subgroup)
    )
  end
end
