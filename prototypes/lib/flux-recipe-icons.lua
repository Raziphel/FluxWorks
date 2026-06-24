local M = {}

local ITEM_TYPES = {
  "item",
  "tool",
  "ammo",
  "capsule",
  "module",
  "armor",
  "gun",
  "repair-tool",
  "item-with-entity-data",
}

local function prototype_icon_data(prototype)
  if not prototype then
    return nil
  end

  if prototype.icons then
    return { icons = table.deepcopy(prototype.icons) }
  end

  if prototype.icon then
    return {
      icon = prototype.icon,
      icon_size = prototype.icon_size or 64,
      icon_mipmaps = prototype.icon_mipmaps,
      tint = prototype.tint,
    }
  end

  return nil
end

function M.item_icon(item_name)
  for _, item_type in ipairs(ITEM_TYPES) do
    local prototype = data.raw[item_type] and data.raw[item_type][item_name]
    if prototype then
      return prototype_icon_data(prototype)
    end
  end
  return nil
end

function M.fluid_icon(fluid_name)
  return prototype_icon_data(data.raw.fluid and data.raw.fluid[fluid_name])
end

function M.source_to_flux_icons(source_name, flux_fluid_name)
  local source_icon = M.item_icon(source_name)
  local flux_icon = M.fluid_icon(flux_fluid_name)
  if not (source_icon and flux_icon) then
    return source_icon or flux_icon
  end

  local icons = {}
  for _, icon in ipairs(source_icon.icons or { source_icon }) do
    local entry = table.deepcopy(icon)
    entry.scale = (entry.scale or 1) * 0.92
    icons[#icons + 1] = entry
  end
  for _, icon in ipairs(flux_icon.icons or { flux_icon }) do
    local entry = table.deepcopy(icon)
    entry.scale = (entry.scale or 1) * 0.48
    entry.shift = entry.shift or { 9, -9 }
    icons[#icons + 1] = entry
  end

  return { icons = icons }
end

return M
