local Common = require("__haul_lib__/utils/common")

data:extend({
{
  type = "fluid",
  name = "purple-flux",
  default_temperature = 15,
  max_temperature = 100,
  base_color = { r = 0, g = 0.34, b = 0.6 },
  flow_color = { r = 0.7, g = 0.7, b = 0.7 },
  icon = "__FluxWorksAssets__/graphics/icons/fluids/ArtisanalReskins_alien-acid.png",
  icon_size = 64,
  order = "a[fluid]-a[water]"
},
{
  type = "fluid",
  name = "yellow-flux",
  default_temperature = 15,
  max_temperature = 100,
  base_color = { r = 0, g = 0.34, b = 0.6 },
  flow_color = { r = 0.7, g = 0.7, b = 0.7 },
  icon = "__FluxWorksAssets__/graphics/icons/fluids/ArtisanalReskins_alien-explosive.png",
  icon_size = 64,
  order = "a[fluid]-a[water]"
},
{
  type = "fluid",
  name = "red-flux",
  default_temperature = 15,
  max_temperature = 100,
  base_color = { r = 0, g = 0.34, b = 0.6 },
  flow_color = { r = 0.7, g = 0.7, b = 0.7 },
  icon = "__FluxWorksAssets__/graphics/icons/fluids/ArtisanalReskins_alien-fire.png",
  icon_size = 64,
  order = "a[fluid]-a[water]"
},
{
  type = "fluid",
  name = "green-flux",
  default_temperature = 15,
  max_temperature = 100,
  base_color = { r = 0, g = 0.34, b = 0.6 },
  flow_color = { r = 0.7, g = 0.7, b = 0.7 },
  icon = "__FluxWorksAssets__/graphics/icons/fluids/ArtisanalReskins_alien-poison.png",
  icon_size = 64,
  order = "a[fluid]-a[water]"
},
})
