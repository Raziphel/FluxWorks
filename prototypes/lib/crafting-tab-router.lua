local Router = {}

local item_prototype_types = { "item", "tool", "capsule", "module", "ammo" }
local craftable_prototype_types = { "item", "tool", "capsule", "module", "ammo", "recipe" }

function Router.ensure_group(definition)
  local group = data.raw["item-group"] and data.raw["item-group"][definition.name]
  if group then
    group.icon = definition.icon or group.icon
    group.icon_size = definition.icon_size or group.icon_size
    group.icon_mipmaps = definition.icon_mipmaps or group.icon_mipmaps
    group.icons = definition.icons or group.icons
    group.order = definition.order or group.order
    return
  end

  data:extend({
    {
      type = "item-group",
      name = definition.name,
      icon = definition.icon,
      icon_size = definition.icon_size,
      icon_mipmaps = definition.icon_mipmaps,
      icons = definition.icons,
      order = definition.order,
    },
  })
end

function Router.ensure_subgroup(definition)
  local subgroup = data.raw["item-subgroup"] and data.raw["item-subgroup"][definition.name]
  if subgroup then
    subgroup.group = definition.group or subgroup.group
    subgroup.order = definition.order or subgroup.order
    return
  end

  data:extend({
    {
      type = "item-subgroup",
      name = definition.name,
      group = definition.group,
      order = definition.order,
    },
  })
end

function Router.set_subgroup(prototype_type, name, subgroup)
  local prototype = data.raw[prototype_type] and data.raw[prototype_type][name]
  if prototype then
    prototype.subgroup = subgroup
  end
end

function Router.set_order(prototype_type, name, order)
  local prototype = data.raw[prototype_type] and data.raw[prototype_type][name]
  if prototype then
    prototype.order = order
  end
end

function Router.set_many_subgroups(prototype_types, name, subgroup)
  for _, prototype_type in pairs(prototype_types) do
    Router.set_subgroup(prototype_type, name, subgroup)
  end
end

function Router.set_orders(prototype_types, entries)
  for _, entry in pairs(entries) do
    for _, prototype_type in pairs(prototype_types) do
      Router.set_order(prototype_type, entry[1], entry[2])
    end
  end
end

function Router.purge(prototype_type, name)
  local prototypes = data.raw[prototype_type]
  if prototypes then
    prototypes[name] = nil
  end
end

function Router.purge_many(prototype_types, names)
  for _, name in pairs(names) do
    for _, prototype_type in pairs(prototype_types) do
      Router.purge(prototype_type, name)
    end
  end
end

function Router.move_science_pack(name)
  Router.set_many_subgroups({ "tool", "item", "recipe" }, name, "fw-science-packs")
end

function Router.move_item_and_recipe(name, subgroup)
  Router.set_many_subgroups(craftable_prototype_types, name, subgroup)
end

function Router.move_item(name, subgroup)
  Router.set_many_subgroups(item_prototype_types, name, subgroup)
end

function Router.move_recipe(name, subgroup)
  Router.set_subgroup("recipe", name, subgroup)
end

local function recipe_entries(recipe, field)
  if recipe[field] then return recipe[field] end
  if recipe.normal and recipe.normal[field] then return recipe.normal[field] end
  return nil
end

function Router.recipe_main_item_name(recipe)
  if not recipe then return nil end
  if recipe.main_product and recipe.main_product ~= "" then return recipe.main_product end

  local results = recipe_entries(recipe, "results")
  if results then
    for _, result in pairs(results) do
      if (result.type or "item") == "item" then
        return result.name or result[1]
      end
    end
  end
  return recipe.result or (recipe.normal and recipe.normal.result)
end

function Router.item_subgroup(name)
  local item = data.raw.item and data.raw.item[name]
  if item then return item.subgroup end

  local tool = data.raw.tool and data.raw.tool[name]
  return tool and tool.subgroup or nil
end

return Router
