local icon_path = "__FluxWorksAssets__/graphics/icons/items/"
local late_utility_icon_path = "__FluxWorksAssets__/graphics/icons/items/late-utility/"
local flux_3_icon = "__Krastorio2Assets__/icons/items/imersite-3.png"
local flux_3_light_icon = "__Krastorio2Assets__/icons/items/imersite-3-light.png"
local aop_biocircuit = "__Age-of-Production-Graphics__/graphics/icons/biocircuit.png"
local aop_quantum_computer = "__Age-of-Production-Graphics__/graphics/icons/quantum-computer.png"
local k2_ai_core = "__Krastorio2Assets__/icons/items/ai-core.png"
local k2_big_storage_tank = "__Krastorio2Assets__/icons/entities/big-storage-tank.png"
local k2_energy_control_unit = "__Krastorio2Assets__/icons/items/energy-control-unit.png"
local k2_energy_storage = "__Krastorio2Assets__/icons/entities/energy-storage.png"
local k2_fusion_reactor = "__Krastorio2Assets__/icons/entities/fusion-reactor.png"
local k2_matter_cube = "__Krastorio2Assets__/icons/items/matter-cube.png"
local k2_matter_stabilizer = "__Krastorio2Assets__/icons/items/matter-stabilizer.png"
local k2_quantum_computer = "__Krastorio2Assets__/icons/entities/quantum-computer.png"
local k2_spaceship_research_computer = "__Krastorio2Assets__/icons/entities/spaceship-research-computer.png"
local k248_energy_crystal = "__248k-Redux-graphics__/ressources/electronic/el_energy_crystal/el_energy_crystal_charged_item.png"
local k248_fi_ki_circuit = "__248k-Redux-graphics__/ressources/electronic/el_ki/fi_ki_circuit/fi_ki_circuit_item.png"
local k248_ki_core = "__248k-Redux-graphics__/ressources/electronic/el_ki/el_ki_core/el_ki_core_item.png"
local k248_pressurizer = "__248k-Redux-graphics__/ressources/electronic/el_pressurizer/el_pressurizer_item.png"
local k248_tank = "__248k-Redux-graphics__/ressources/electronic/el_tank/el_tank_item.png"
local k248_ceramic = "__248k-Redux-graphics__/ressources/electronic/el_materials/el_materials_ceramic.png"
local k248_black_hole = "__248k-Redux-graphics__/ressources/gravitation/gr_black_hole/gr_black_hole_item.png"
local origin_icon_path = icon_path .. "origin-projects/"

local function single_icon(icon, icon_size)
  return {
    { icon = icon, icon_size = icon_size },
  }
end

data:extend({
  {
    type = "item-subgroup",
    name = "fw-flux-systems",
    group = "intermediate-products",
    order = "ff",
  },
  {
    type = "item-subgroup",
    name = "fw-flux-exchange",
    group = "intermediate-products",
    order = "fg",
  },
  {
    type = "item-subgroup",
    name = "fw-flux-origin-projects",
    group = "intermediate-products",
    order = "fh",
  },
  {
    type = "item",
    name = "fw-flux-catalyst",
    icon = icon_path .. "flux-2.png",
    icon_size = 64,
    subgroup = "fw-flux-systems",
    order = "a[fw-flux-catalyst]",
    stack_size = 200,
  },
  {
    type = "item",
    name = "fw-stabilized-flux-crystal",
    icons = single_icon(icon_path .. "crystallized-flux-light.png", 64),
    subgroup = "fw-flux-systems",
    order = "b[fw-stabilized-flux-crystal]",
    stack_size = 200,
  },
  {
    type = "item",
    name = "fw-flux-lattice",
    icons = single_icon(icon_path .. "fw-flux-lattice.png", 1024),
    subgroup = "fw-flux-systems",
    order = "c[fw-flux-lattice]",
    stack_size = 100,
  },
  {
    type = "item",
    name = "fw-harvester-head",
    icons = single_icon("__248k-Redux-graphics__/ressources/fission/fi_crusher/fi_crusher_entity_icon.png", 64),
    subgroup = "fw-flux-systems",
    order = "c1[fw-harvester-head]",
    stack_size = 50,
  },
  {
    type = "item",
    name = "fw-annealed-cermet",
    icons = single_icon(icon_path .. "fw-cermet.png", 1024),
    subgroup = "fw-flux-systems",
    order = "c2[fw-annealed-cermet]",
    stack_size = 100,
  },
  {
    type = "item",
    name = "fw-resonance-substrate",
    icons = single_icon(icon_path .. "fw-resonance-substrate.png", 1024),
    subgroup = "fw-flux-systems",
    order = "c3[fw-resonance-substrate]",
    stack_size = 100,
  },
  {
    type = "item",
    name = "fw-condensed-flux-matrix",
    icons = single_icon(icon_path .. "fw-condensed-flux-matrix.png", 1024),
    subgroup = "fw-flux-systems",
    order = "d[fw-condensed-flux-matrix]",
    stack_size = 100,
  },
  {
    type = "item",
    name = "fw-flux-resonance-cell",
    icons = single_icon(icon_path .. "fw-flux-resonance-cell.png", 1024),
    subgroup = "fw-flux-systems",
    order = "e[fw-flux-resonance-cell]",
    stack_size = 100,
  },
  {
    type = "item",
    name = "fw-flux-phase-manifold",
    icons = single_icon(icon_path .. "fw-flux-phase-manifold.png", 1024),
    subgroup = "fw-flux-systems",
    order = "f[fw-flux-phase-manifold]",
    stack_size = 50,
  },
  {
    type = "item",
    name = "fw-phase-anchor",
    icons = single_icon(late_utility_icon_path .. "fw-phase-anchor.png", 1024),
    subgroup = "fw-flux-systems",
    order = "g[fw-phase-anchor]",
    stack_size = 50,
  },
  {
    type = "item",
    name = "fw-entanglement-core",
    icons = single_icon(k2_ai_core, 64),
    subgroup = "fw-flux-systems",
    order = "h[fw-entanglement-core]",
    stack_size = 50,
  },
  {
    type = "item",
    name = "fw-reservoir-lining",
    icons = single_icon(late_utility_icon_path .. "fw-reservoir-lining.png", 1024),
    subgroup = "fw-flux-systems",
    order = "i[fw-reservoir-lining]",
    stack_size = 50,
  },
  {
    type = "item",
    name = "fw-compression-baffle",
    icons = single_icon(icon_path .. "fw-hydraulic-manifold.png", 64),
    subgroup = "fw-flux-systems",
    order = "j[fw-compression-baffle]",
    stack_size = 50,
  },
  {
    type = "item",
    name = "fw-thermal-phase-gasket",
    icons = single_icon(late_utility_icon_path .. "fw-thermal-phase-gasket.png", 1024),
    subgroup = "fw-flux-systems",
    order = "k[fw-thermal-phase-gasket]",
    stack_size = 50,
  },
  {
    type = "item",
    name = "fw-rift-coupler",
    icons = single_icon(aop_quantum_computer, 64),
    subgroup = "fw-flux-exchange",
    order = "a[fw-rift-coupler]",
    stack_size = 20,
  },
  {
    type = "item",
    name = "fw-phase-vault",
    icon = "__FluxWorksAssets__/graphics/icons/items/deep-storage-unit/memory-unit.png",
    icon_size = 64,
    subgroup = "fw-flux-exchange",
    order = "b[fw-phase-vault]",
    stack_size = 10,
    place_result = "fw-phase-vault",
  },
  {
    type = "item",
    name = "fw-spectral-reservoir",
    icon = "__FluxWorksAssets__/graphics/icons/items/fluid-memory-storage/fluid-memory-unit.png",
    icon_size = 64,
    subgroup = "fw-flux-exchange",
    order = "c[fw-spectral-reservoir]",
    stack_size = 10,
    place_result = "fw-spectral-reservoir",
  },
  {
    type = "item",
    name = "fw-rift-exchange-gate",
    icon = late_utility_icon_path .. "fw-rift-exchange-gate.png",
    icon_size = 64,
    subgroup = "fw-flux-exchange",
    order = "d[fw-rift-exchange-gate]",
    stack_size = 10,
    place_result = "fw-rift-exchange-gate",
  },
  {
    type = "item",
    name = "fw-rift-exchange-fluid-gate",
    icon = late_utility_icon_path .. "fw-rift-exchange-fluid-gate.png",
    icon_size = 64,
    subgroup = "fw-flux-exchange",
    order = "e[fw-rift-exchange-fluid-gate]",
    stack_size = 10,
    place_result = "fw-rift-exchange-fluid-gate",
  },
  {
    type = "item",
    name = "fw-storm-spine-segment",
    icons = single_icon("__248k-Redux-graphics__/ressources/fission/fi_crusher/fi_crusher_entity_icon.png", 64),
    subgroup = "fw-flux-origin-projects",
    order = "a[storm-spine-segment]",
    stack_size = 20,
  },
  {
    type = "item",
    name = "fw-origin-crucible-lining",
    icons = single_icon(k2_fusion_reactor, 64),
    subgroup = "fw-flux-origin-projects",
    order = "b[origin-crucible-lining]",
    stack_size = 20,
  },
  {
    type = "item",
    name = "fw-harmonic-lattice-core",
    icons = single_icon(icon_path .. "fw-model-lattice.png", 64),
    subgroup = "fw-flux-origin-projects",
    order = "c[harmonic-lattice-core]",
    stack_size = 20,
  },
  {
    type = "item",
    name = "fw-living-reactor-weave",
    icons = single_icon("__space-age__/graphics/icons/fusion-power-cell.png", 64),
    subgroup = "fw-flux-origin-projects",
    order = "d[living-reactor-weave]",
    stack_size = 20,
  },
  {
    type = "item",
    name = "fw-origin-catalyst-manifold",
    icons = single_icon(icon_path .. "fw-hydraulic-manifold.png", 64),
    subgroup = "fw-flux-origin-projects",
    order = "e[origin-catalyst-manifold]",
    stack_size = 20,
  },
  {
    type = "item",
    name = "fw-storm-spine",
    icons = single_icon(origin_icon_path .. "fw-storm-spine.png", 64),
    subgroup = "fw-flux-origin-projects",
    order = "f[storm-spine]",
    stack_size = 10,
  },
  {
    type = "item",
    name = "fw-origin-crucible",
    icons = single_icon(origin_icon_path .. "fw-origin-crucible.png", 64),
    subgroup = "fw-flux-origin-projects",
    order = "g[origin-crucible]",
    stack_size = 10,
  },
  {
    type = "item",
    name = "fw-universal-collapse-core",
    icons = single_icon(origin_icon_path .. "fw-universal-collapse-core.png", 64),
    subgroup = "fw-flux-origin-projects",
    order = "h[universal-collapse-core]",
    stack_size = 5,
  },
  {
    type = "item",
    name = "fw-genesis-ark",
    icons = single_icon(origin_icon_path .. "fw-genesis-ark.png", 64),
    subgroup = "fw-flux-origin-projects",
    order = "i[genesis-ark]",
    stack_size = 1,
  },
  {
    type = "item",
    name = "fw-origin-singularity",
    icons = single_icon(origin_icon_path .. "fw-origin-singularity.png", 256),
    subgroup = "fw-flux-origin-projects",
    order = "j[origin-singularity]",
    stack_size = 1,
    place_result = "fw-origin-singularity",
  },
})
