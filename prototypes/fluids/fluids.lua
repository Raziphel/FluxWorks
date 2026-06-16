-- Flux fluids used by the transmutation loop.
data:extend({
{
  -- Main loop fluid.
  type = "fluid",
  name = "fw-purple-flux",
  default_temperature = 15,
  max_temperature = 100,
  base_color = { r = 0.43, g = 0.18, b = 0.64 },
  flow_color = { r = 0.79, g = 0.58, b = 0.97 },
  icon = "__FluxWorksAssets__/graphics/icons/fluids/ArtisanalReskins_alien-acid.png",
  icon_size = 64,
  order = "a[fluid]-a[fw-purple-flux]"
},
{
  -- Chemical-processing spectrum.
  type = "fluid",
  name = "fw-yellow-flux",
  default_temperature = 15,
  max_temperature = 100,
  base_color = { r = 0.78, g = 0.59, b = 0.08 },
  flow_color = { r = 0.98, g = 0.88, b = 0.29 },
  icon = "__FluxWorksAssets__/graphics/icons/fluids/ArtisanalReskins_alien-explosive.png",
  icon_size = 64,
  order = "a[fluid]-b[fw-yellow-flux]"
},
{
  type = "fluid",
  name = "fw-red-flux",
  default_temperature = 15,
  max_temperature = 100,
  base_color = { r = 0.68, g = 0.14, b = 0.12 },
  flow_color = { r = 0.96, g = 0.43, b = 0.31 },
  icon = "__FluxWorksAssets__/graphics/icons/fluids/ArtisanalReskins_alien-fire.png",
  icon_size = 64,
  order = "a[fluid]-c[fw-red-flux]"
},
{
  type = "fluid",
  name = "fw-green-flux",
  default_temperature = 15,
  max_temperature = 100,
  base_color = { r = 0.16, g = 0.52, b = 0.18 },
  flow_color = { r = 0.54, g = 0.9, b = 0.4 },
  icon = "__FluxWorksAssets__/graphics/icons/fluids/ArtisanalReskins_alien-poison.png",
  icon_size = 64,
  order = "a[fluid]-d[fw-green-flux]"
},
})
