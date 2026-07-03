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

assert_many({ "item", "recipe" }, {
  "fw-flux-quarry",
  "fw-flux-harvester",
  "fw-flux-condenser",
  "fw-origin-forge",
}, "fw-flux-machines")

assert_many({ "item", "recipe" }, {
  "fw-arc-foundry",
  "fw-synthesis-plant",
}, "fw-fabrication-machines")

assert_many({ "item", "recipe" }, {
  "fw-phase-anchor",
  "fw-entanglement-core",
  "fw-reservoir-lining",
  "fw-compression-baffle",
  "fw-thermal-phase-gasket",
  "fw-rift-coupler",
  "fw-phase-vault",
  "fw-spectral-reservoir",
  "fw-rift-exchange-gate",
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
  "fw-origin-singularity",
}, "fw-flux-origin-projects")
