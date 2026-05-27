-- Cross-surface crusher integration for FluxWorks + BZ-style crushing recipes.

local function remove_surface_conditions(prototype)
  if prototype then
    prototype.surface_conditions = nil
  end
end

-- Ensure our recipe category exists for BZ-style crushing chains.
if not (data.raw["recipe-category"] and data.raw["recipe-category"]["basic-crushing"]) then
  data:extend({
    { type = "recipe-category", name = "basic-crushing" },
  })
end

-- Patch base crusher to be usable on any surface and in basic-crushing chains.
local crusher_entity = data.raw["assembling-machine"] and data.raw["assembling-machine"]["crusher"]
if crusher_entity then
  remove_surface_conditions(crusher_entity)
  crusher_entity.crafting_categories = crusher_entity.crafting_categories or {}

  local has_basic_crushing = false
  for _, category in pairs(crusher_entity.crafting_categories) do
    if category == "basic-crushing" then
      has_basic_crushing = true
      break
    end
  end

  if not has_basic_crushing then
    table.insert(crusher_entity.crafting_categories, "basic-crushing")
  end
end

local crusher_item = data.raw["item"] and data.raw["item"]["crusher"]
if crusher_item then
  remove_surface_conditions(crusher_item)
end

local crusher_recipe = data.raw["recipe"] and data.raw["recipe"]["crusher"]
if crusher_recipe then
  remove_surface_conditions(crusher_recipe)
  crusher_recipe.enabled = false
  if crusher_recipe.normal then
    crusher_recipe.normal.enabled = false
  end
  if crusher_recipe.expensive then
    crusher_recipe.expensive.enabled = false
  end
end

-- If base game still gates crusher behind Vulcanus discovery, remove that hard lock.
local vulcanus_discovery = data.raw["technology"] and data.raw["technology"]["planet-discovery-vulcanus"]
if vulcanus_discovery and vulcanus_discovery.effects then
  local filtered = {}
  for _, effect in pairs(vulcanus_discovery.effects) do
    if not (effect.type == "unlock-recipe" and effect.recipe == "crusher") then
      table.insert(filtered, effect)
    end
  end
  vulcanus_discovery.effects = filtered
end
