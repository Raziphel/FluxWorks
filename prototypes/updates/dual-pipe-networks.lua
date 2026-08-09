local lead_tint = { r = 0.76, g = 0.68, b = 0.84, a = 1 }
local copper_tint = { r = 1.00, g = 0.55, b = 0.28, a = 1 }
local lead_category = "fw-lead-pipe"
local copper_category = "fw-copper-pipe"
local shared_categories = { lead_category, copper_category }

local function tint_sprites(value, tint)
  if type(value) ~= "table" then return end
  if value.filename
    and not value.draw_as_shadow
    and not value.draw_as_light
    and value.blend_mode ~= "additive"
  then
    value.tint = tint
  end
  for key, child in pairs(value) do
    if key ~= "tint" then tint_sprites(child, tint) end
  end
end

local function set_icon(prototype, icon)
  prototype.icon = nil
  prototype.icon_size = nil
  prototype.icons = {
    { icon = icon, icon_size = 64 },
  }
end

local function visit_pipe_connections(value, callback)
  if type(value) ~= "table" then return end
  if value.pipe_connections then
    for _, connection in pairs(value.pipe_connections) do callback(connection) end
  end
  for _, child in pairs(value) do visit_pipe_connections(child, callback) end
end

-- Ordinary machines can accept either pipe material. The pipe families remain
-- exclusive, so adjacent lead and copper lines never merge with one another.
for prototype_type, prototypes in pairs(data.raw) do
  for _, prototype in pairs(prototypes) do
    -- Pipe families own their connection category. In particular, underground
    -- connections accept at most one category in Factorio 2.1; widening a
    -- third-party pipe-to-ground to both FluxWorks families makes it invalid.
    if prototype_type ~= "pipe" and prototype_type ~= "pipe-to-ground" and prototype_type ~= "pump" then
      visit_pipe_connections(prototype, function(connection)
        if connection.connection_category == nil then
          connection.connection_category = table.deepcopy(shared_categories)
        elseif connection.connection_category == "default" then
          connection.connection_category = table.deepcopy(shared_categories)
        elseif type(connection.connection_category) == "table" then
          local expanded = {}
          for _, category in pairs(connection.connection_category) do
            if category == "default" then
              table.insert(expanded, lead_category)
              table.insert(expanded, copper_category)
            else
              table.insert(expanded, category)
            end
          end
          connection.connection_category = expanded
        end
      end)
    end
  end
end

local function set_family_connections(entity, category)
  visit_pipe_connections(entity.fluid_box, function(connection)
    connection.connection_category = { category }
  end)
end

local function tint_entity(entity, tint)
  tint_sprites(entity.pictures, tint)
  tint_sprites(entity.animations, tint)
  tint_sprites(entity.fluid_box and entity.fluid_box.pipe_covers, tint)
end

local lead_specs = {
  {
    type = "pipe",
    name = "pipe",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-lead-pipe.png",
    localised_name = { "entity-name.fw-lead-pipe" },
    localised_description = { "entity-description.fw-lead-pipe" },
  },
  {
    type = "pipe-to-ground",
    name = "pipe-to-ground",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-lead-pipe-to-ground.png",
    localised_name = { "entity-name.fw-lead-pipe-to-ground" },
    localised_description = { "entity-description.fw-lead-pipe-to-ground" },
  },
  {
    type = "pump",
    name = "pump",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-lead-pump.png",
    localised_name = { "entity-name.fw-lead-pump" },
    localised_description = { "entity-description.fw-lead-pump" },
  },
}

for _, spec in ipairs(lead_specs) do
  local entity = data.raw[spec.type] and data.raw[spec.type][spec.name]
  local item = data.raw.item and data.raw.item[spec.name]
  local recipe = data.raw.recipe and data.raw.recipe[spec.name]
  if not (entity and item and recipe) then
    error("FluxWorks dual pipe networks require the base " .. spec.name .. " family")
  end

  entity.localised_name = spec.localised_name
  item.localised_name = spec.localised_name
  recipe.localised_name = spec.localised_name
  entity.localised_description = spec.localised_description
  item.localised_description = spec.localised_description
  recipe.localised_description = spec.localised_description
  set_icon(entity, spec.icon)
  set_icon(item, spec.icon)
  set_icon(recipe, spec.icon)
  tint_entity(entity, lead_tint)
  set_family_connections(entity, lead_category)
  entity.fast_replaceable_group = "fw-lead-pipe"
end

data.raw.recipe.pipe.ingredients = {
  { type = "item", name = "lead-plate", amount = 1 },
}
data.raw.recipe["pipe-to-ground"].ingredients = {
  { type = "item", name = "lead-plate", amount = 5 },
  { type = "item", name = "pipe", amount = 10 },
}
data.raw.recipe.pump.ingredients = {
  { type = "item", name = "iron-gear-wheel", amount = 2 },
  { type = "item", name = "iron-plate", amount = 1 },
  { type = "item", name = "pipe", amount = 1 },
}

local copper_specs = {
  {
    type = "pipe",
    source = "pipe",
    name = "fw-copper-pipe",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-copper-pipe.png",
    localised_description = { "entity-description.fw-copper-pipe" },
  },
  {
    type = "pipe-to-ground",
    source = "pipe-to-ground",
    name = "fw-copper-pipe-to-ground",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-copper-pipe-to-ground.png",
    localised_description = { "entity-description.fw-copper-pipe-to-ground" },
  },
  {
    type = "pump",
    source = "pump",
    name = "fw-copper-pump",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-copper-pump.png",
    localised_description = { "entity-description.fw-copper-pump" },
  },
}

for index, spec in ipairs(copper_specs) do
  local entity = table.deepcopy(data.raw[spec.type][spec.source])
  local item = table.deepcopy(data.raw.item[spec.source])
  entity.name = spec.name
  entity.localised_name = { "entity-name." .. spec.name }
  entity.localised_description = spec.localised_description
  entity.minable.result = spec.name
  entity.fast_replaceable_group = "fw-copper-pipe"
  item.name = spec.name
  item.localised_name = { "entity-name." .. spec.name }
  item.localised_description = spec.localised_description
  item.place_result = spec.name
  item.order = "a[pipes]-" .. string.char(97 + index * 2) .. "[" .. spec.name .. "]"
  set_icon(entity, spec.icon)
  set_icon(item, spec.icon)
  tint_entity(entity, copper_tint)
  set_family_connections(entity, copper_category)
  data:extend({ entity, item })
end

data:extend({
  {
    type = "recipe",
    name = "fw-copper-pipe",
    enabled = false,
    allow_decomposition = false,
    subgroup = "fw-logistics-fluid-handling",
    order = "a[pipes]-b[copper-pipe]",
    ingredients = { { type = "item", name = "copper-plate", amount = 1 } },
    results = { { type = "item", name = "fw-copper-pipe", amount = 1 } },
  },
  {
    type = "recipe",
    name = "fw-copper-pipe-to-ground",
    enabled = false,
    allow_decomposition = false,
    subgroup = "fw-logistics-fluid-handling",
    order = "a[pipes]-d[copper-pipe-to-ground]",
    ingredients = {
      { type = "item", name = "copper-plate", amount = 5 },
      { type = "item", name = "fw-copper-pipe", amount = 10 },
    },
    results = { { type = "item", name = "fw-copper-pipe-to-ground", amount = 2 } },
  },
  {
    type = "recipe",
    name = "fw-copper-pump",
    enabled = false,
    allow_decomposition = false,
    subgroup = "fw-logistics-fluid-handling",
    order = "a[pipes]-f[copper-pump]",
    ingredients = {
      { type = "item", name = "iron-gear-wheel", amount = 2 },
      { type = "item", name = "iron-plate", amount = 1 },
      { type = "item", name = "fw-copper-pipe", amount = 1 },
    },
    results = { { type = "item", name = "fw-copper-pump", amount = 1 } },
  },
})

for _, spec in ipairs(copper_specs) do
  local recipe = data.raw.recipe[spec.name]
  recipe.localised_name = { "entity-name." .. spec.name }
  recipe.localised_description = spec.localised_description
  set_icon(recipe, spec.icon)
end

local basic_fluids = data.raw.technology and data.raw.technology["basic-fluid-handling"]
if not basic_fluids then error("FluxWorks dual pipe networks require Basic Fluid Handling") end
basic_fluids.effects = basic_fluids.effects or {}
local unlocks = {}
for _, effect in pairs(basic_fluids.effects) do
  if effect.type == "unlock-recipe" then unlocks[effect.recipe] = true end
end
for _, recipe_name in ipairs({ "pump", "fw-copper-pipe", "fw-copper-pipe-to-ground", "fw-copper-pump" }) do
  if not unlocks[recipe_name] then
    table.insert(basic_fluids.effects, { type = "unlock-recipe", recipe = recipe_name })
  end
end
