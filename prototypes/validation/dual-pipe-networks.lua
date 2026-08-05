local function has_ingredient(recipe_name, ingredient_name, amount)
  for _, ingredient in pairs((data.raw.recipe[recipe_name] or {}).ingredients or {}) do
    if ingredient.name == ingredient_name and ingredient.amount == amount then return true end
  end
  return false
end

local function has_unlock(technology_name, recipe_name)
  for _, effect in pairs((data.raw.technology[technology_name] or {}).effects or {}) do
    if effect.type == "unlock-recipe" and effect.recipe == recipe_name then return true end
  end
  return false
end

local function first_category(entity_type, entity_name)
  local entity = data.raw[entity_type] and data.raw[entity_type][entity_name]
  local connection = entity and entity.fluid_box and entity.fluid_box.pipe_connections
    and entity.fluid_box.pipe_connections[1]
  return connection and connection.connection_category and connection.connection_category[1]
end

for _, recipe_name in ipairs({
  "pipe", "pipe-to-ground", "pump",
  "fw-copper-pipe", "fw-copper-pipe-to-ground", "fw-copper-pump",
}) do
  if not has_unlock("basic-fluid-handling", recipe_name) then
    error("Basic Fluid Handling must unlock both pipe families together: " .. recipe_name)
  end
end

if not has_ingredient("pipe", "lead-plate", 1)
  or not has_ingredient("pipe-to-ground", "pipe", 10)
  or not has_ingredient("pipe-to-ground", "lead-plate", 5)
  or not has_ingredient("pump", "pipe", 1)
then
  error("Lead fluid logistics lost its lead material identity")
end

if not has_ingredient("fw-copper-pipe", "copper-plate", 1)
  or not has_ingredient("fw-copper-pipe-to-ground", "fw-copper-pipe", 10)
  or not has_ingredient("fw-copper-pipe-to-ground", "copper-plate", 5)
  or not has_ingredient("fw-copper-pump", "fw-copper-pipe", 1)
then
  error("Copper fluid logistics lost its copper material identity")
end

for _, spec in ipairs({
  { "pipe", "pipe", "fw-lead-pipe" },
  { "pipe-to-ground", "pipe-to-ground", "fw-lead-pipe" },
  { "pump", "pump", "fw-lead-pipe" },
  { "pipe", "fw-copper-pipe", "fw-copper-pipe" },
  { "pipe-to-ground", "fw-copper-pipe-to-ground", "fw-copper-pipe" },
  { "pump", "fw-copper-pump", "fw-copper-pipe" },
}) do
  if first_category(spec[1], spec[2]) ~= spec[3] then
    error("Pipe family connection category drifted: " .. spec[2])
  end
end

local chemical_plant = data.raw["assembling-machine"] and data.raw["assembling-machine"]["chemical-plant"]
local machine_categories = chemical_plant and chemical_plant.fluid_boxes
  and chemical_plant.fluid_boxes[1] and chemical_plant.fluid_boxes[1].pipe_connections
  and chemical_plant.fluid_boxes[1].pipe_connections[1].connection_category or {}
if machine_categories[1] ~= "fw-lead-pipe" or machine_categories[2] ~= "fw-copper-pipe" then
  error("Ordinary fluid machines must accept both FluxWorks pipe families")
end
