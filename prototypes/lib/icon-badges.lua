local IconBadges = {}

local flux_icon_path = "__FluxWorksAssets__/graphics/icons/fluids/"

function IconBadges.planetary(base_icon, base_size, flux_icon)
  return {
    { icon = base_icon, icon_size = base_size },
    {
      icon = flux_icon_path .. flux_icon,
      icon_size = 256,
      scale = 0.32,
      shift = { -9, -9 },
    },
  }
end

return IconBadges
