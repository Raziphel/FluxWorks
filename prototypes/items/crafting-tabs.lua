local Layout = require("prototypes.lib.crafting-tab-layout")

local prototypes = {}

for _, item_group in ipairs(Layout.item_groups) do
  prototypes[#prototypes + 1] = {
    type = "item-group",
    name = item_group.name,
    icon = item_group.icon,
    icon_size = item_group.icon_size,
    icon_mipmaps = item_group.icon_mipmaps,
    icons = item_group.icons,
    order = item_group.order,
  }
end

for _, subgroup in ipairs(Layout.subgroups) do
  prototypes[#prototypes + 1] = {
    type = "item-subgroup",
    name = subgroup.name,
    group = subgroup.group,
    order = subgroup.order,
  }
end

data:extend(prototypes)
