local icon_path = "__FluxWorksAssets__/graphics/icons/items/"
local aop_quantum = "__Age-of-Production-Graphics__/graphics/icons/quantum-computer.png"
local aop_petro = "__Age-of-Production-Graphics__/graphics/icons/petrochemical-facility.png"
local aop_hydraulic = "__Age-of-Production-Graphics__/graphics/icons/hydraulic-plant.png"
local aop_atomic = "__Age-of-Production-Graphics__/graphics/icons/atomic-enricher.png"

data:extend({
  {
    type = "item",
    name = "fw-quantum-spindle",
    icon = icon_path .. "fw-quantum-computer.png",
    icon_size = 64,
    subgroup = "fw-fabrication-components",
    order = "z[required-mod]-a[quantum-spindle]",
    stack_size = 50,
  },
  {
    type = "item",
    name = "fw-reactive-column",
    icon = aop_petro,
    icon_size = 64,
    subgroup = "fw-fabrication-components",
    order = "z[required-mod]-b[reactive-column]",
    stack_size = 50,
  },
  {
    type = "item",
    name = "fw-hydraulic-core",
    icon = icon_path .. "fw-hydraulic-manifold.png",
    icon_size = 64,
    subgroup = "fw-fabrication-components",
    order = "z[required-mod]-c[hydraulic-core]",
    stack_size = 50,
  },
  {
    type = "item",
    name = "fw-reactor-instrument-cluster",
    icon = aop_atomic,
    icon_size = 64,
    subgroup = "fw-fabrication-components",
    order = "z[required-mod]-d[reactor-instrument-cluster]",
    stack_size = 50,
  },
})
