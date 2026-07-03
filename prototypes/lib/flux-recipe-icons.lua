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

local function clone_icon_layers(icon_data, scale_multiplier, shift_override, tint_override)
  if not icon_data then
    return {}
  end

  local icons = {}
  for _, icon in ipairs(icon_data.icons or { icon_data }) do
    local entry = table.deepcopy(icon)
    if scale_multiplier then
      entry.scale = (entry.scale or 1) * scale_multiplier
    end
    if shift_override then
      entry.shift = shift_override
    end
    if tint_override then
      entry.tint = tint_override
    end
    icons[#icons + 1] = entry
  end

  return icons
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

function M.item_overlay(item_name, scale, shift, tint)
  return { item = item_name, scale = scale, shift = shift, tint = tint }
end

function M.fluid_overlay(fluid_name, scale, shift, tint)
  return { fluid = fluid_name, scale = scale, shift = shift, tint = tint }
end

function M.path_overlay(icon, icon_size, scale, shift, tint)
  return {
    icon_data = {
      icon = icon,
      icon_size = icon_size,
    },
    scale = scale,
    shift = shift,
    tint = tint,
  }
end

function M.compose(base_icon_data, overlays, base_scale)
  if not base_icon_data then
    return nil
  end

  return { icons = clone_icon_layers(base_icon_data) }
end

function M.product_item_icons(item_name, overlays, base_scale)
  return M.compose(M.item_icon(item_name), overlays, base_scale)
end

function M.product_fluid_icons(fluid_name, overlays, base_scale)
  return M.compose(M.fluid_icon(fluid_name), overlays, base_scale)
end

function M.source_to_flux_icons(source_name, flux_fluid_name)
  local flux_icon = M.fluid_icon(flux_fluid_name)
  if not flux_icon then
    return M.item_icon(source_name)
  end
  return { icons = clone_icon_layers(flux_icon) }
end

return M
