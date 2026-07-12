local icon_path = "__FluxWorksAssets__/graphics/icons/items/"
local k2_loader = "__Krastorio2Assets__/icons/entities/loader.png"
local k248_tank = "__248k-Redux-graphics__/ressources/electronic/el_tank/el_tank_item.png"
local k248_ki_core = "__248k-Redux-graphics__/ressources/electronic/el_ki/el_ki_core/el_ki_core_item.png"
local k2_advanced_loader = "__Krastorio2Assets__/icons/entities/advanced-loader.png"

data:extend({
  {
    type = "item",
    name = "fw-loader-frame",
    icon = k2_loader,
    icon_size = 64,
    subgroup = "fw-fabrication-components",
    order = "z[kr-logistics]-a[loader-frame]",
    stack_size = 100,
  },
  {
    type = "item",
    name = "fw-pressure-vessel",
    icon = k248_tank,
    icon_size = 64,
    subgroup = "fw-fabrication-components",
    order = "z[kr-logistics]-b[pressure-vessel]",
    stack_size = 50,
  },
  {
    type = "item",
    name = "fw-logistic-relay",
    icon = k248_ki_core,
    icon_size = 64,
    subgroup = "fw-fabrication-components",
    order = "z[kr-logistics]-c[logistic-relay]",
    stack_size = 50,
  },
  {
    type = "item",
    name = "fw-bulk-router",
    icon = k2_advanced_loader,
    icon_size = 64,
    subgroup = "fw-fabrication-components",
    order = "z[kr-logistics]-d[bulk-router]",
    stack_size = 50,
  },
})
