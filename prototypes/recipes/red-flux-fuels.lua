local ENERGY_UNITS_IN_JOULES = {
  J = 1,
  kJ = 1000,
  MJ = 1000000,
  GJ = 1000000000,
  TJ = 1000000000000,
}

local ITEM_PROTOTYPE_TYPES = {
  "item",
  "ammo",
  "capsule",
  "gun",
  "module",
  "armor",
  "tool",
  "repair-tool",
  "item-with-entity-data",
  "item-with-label",
  "item-with-tags",
  "selection-tool",
  "blueprint-book",
  "copy-paste-tool",
  "deconstruction-item",
  "upgrade-item",
  "rail-planner",
  "spidertron-remote",
}

local function parse_energy_to_joules(energy)
  if type(energy) == "number" then
    return energy
  end
  if type(energy) ~= "string" then
    return nil
  end

  local value, unit = string.match(energy, "^%s*([%d%.]+)%s*([kMGT]?J)%s*$")
  if not value or not unit then
    return nil
  end

  local scalar = ENERGY_UNITS_IN_JOULES[unit]
  if not scalar then
    return nil
  end

  return tonumber(value) * scalar
end

local function item_icon(item)
  if item.icons then
    return { icons = table.deepcopy(item.icons) }
  end
  if item.icon then
    return {
      icon = item.icon,
      icon_size = item.icon_size or 64,
      icon_mipmaps = item.icon_mipmaps,
    }
  end
  return nil
end

local function has_unlock_effect(effects, recipe_name)
  for _, effect in pairs(effects or {}) do
    if effect.type == "unlock-recipe" and effect.recipe == recipe_name then
      return true
    end
  end
  return false
end

local generated = {}
local generated_names = {}
local seen = {}

for _, prototype_type in ipairs(ITEM_PROTOTYPE_TYPES) do
  for item_name, item in pairs(data.raw[prototype_type] or {}) do
    if not seen[item_name] and not item.hidden and item.fuel_value then
      local fuel_joules = parse_energy_to_joules(item.fuel_value)
      local input_amount = nil
      local red_flux_amount = nil

      if fuel_joules and fuel_joules > 0 then
        input_amount = math.max(1, math.ceil(1000000 / fuel_joules))
        red_flux_amount = math.max(1, math.floor(((fuel_joules * input_amount) / 1000000) + 0.5))
      end

      if input_amount and red_flux_amount and red_flux_amount > 0 then
        seen[item_name] = true

        local recipe = {
          type = "recipe",
          name = "fw-red-flux-from-fuel-" .. item_name,
          category = "chemistry",
          subgroup = "fw-transmutation-upcycle",
          order = "a[chemistry]-c[" .. item_name .. "-to-fw-red-flux]",
          enabled = false,
          allow_productivity = false,
          energy_required = math.max(1, math.min(30, (red_flux_amount * input_amount) / 1000)),
          ingredients = {
            { type = "item", name = item_name, amount = input_amount },
          },
          results = {
            { type = "fluid", name = "fw-red-flux", amount = red_flux_amount },
          },
          main_product = "fw-red-flux",
          localised_name = { "", { "item-name." .. item_name }, " -> ", { "fluid-name.fw-red-flux" } },
        }

        local icon = item_icon(item)
        if icon then
          recipe.icons = icon.icons
          recipe.icon = icon.icon
          recipe.icon_size = icon.icon_size
          recipe.icon_mipmaps = icon.icon_mipmaps
        end

        table.insert(generated, recipe)
        table.insert(generated_names, recipe.name)
      end
    end
  end
end

if #generated > 0 then
  data:extend(generated)

  local tech = data.raw.technology and data.raw.technology["fw-flux-field-theory"]
  if tech then
    tech.effects = tech.effects or {}
    for _, recipe_name in ipairs(generated_names) do
      if not has_unlock_effect(tech.effects, recipe_name) then
        table.insert(tech.effects, { type = "unlock-recipe", recipe = recipe_name })
      end
    end
  end
end
