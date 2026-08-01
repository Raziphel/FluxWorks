local icon_path = "__FluxWorksAssets__/graphics/icons/items/"

local ore_icons = {
  ["lead-ore"] = { icon = "__FluxWorksAssets__/graphics/resources/ores/lead-ore.png", icon_size = 64, icon_mipmaps = 0 },
  ["tin-ore"] = { icon = icon_path .. "fw-bz-tin-ore.png", icon_size = 64, icon_mipmaps = 3 },
  ["bauxite-ore"] = { icon = icon_path .. "fw-bauxite-ore.png", icon_size = 64, icon_mipmaps = 3 },
  ["silicon-ore"] = { icon = icon_path .. "fw-bz-silicon-ore.png", icon_size = 64, icon_mipmaps = 3 },
  ["titanium-ore"] = { icon = icon_path .. "fw-bz-titanium-ore.png", icon_size = 64, icon_mipmaps = 3 },
}

for item_name, def in pairs(ore_icons) do
  local item = data.raw.item and data.raw.item[item_name]
  if item then
    item.icons = nil
    item.pictures = nil
    item.icon = def.icon
    item.icon_size = def.icon_size
    item.icon_mipmaps = def.icon_mipmaps
  end
end
