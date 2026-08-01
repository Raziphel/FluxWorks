local branches = {
  vulcanus = {
    technology = "foundry",
    category = "metallurgy",
    recipes = {
      "fw-vulcanus-lead-fractionation",
      "fw-vulcanus-bauxite-fractionation",
      "fw-vulcanus-tin-fractionation",
      "fw-vulcanus-silicon-fractionation",
      "fw-vulcanus-titanium-fractionation",
      "fw-vulcanus-salt-fractionation",
    },
  },
  gleba = {
    technology = "biochamber",
    category = "organic",
    recipes = {
      "fw-gleba-lead-bioleaching",
      "fw-gleba-bauxite-bioleaching",
      "fw-gleba-tin-bioleaching",
      "fw-gleba-silicon-bioleaching",
      "fw-gleba-titanium-bioleaching",
      "fw-gleba-salt-biomineralization",
    },
  },
}

local expected_products = {
  "lead-ore",
  "bauxite-ore",
  "tin-ore",
  "silicon-ore",
  "titanium-ore",
  "fw-salt",
}
local displaced_deposits = {
  "fw-metallic-deposit",
  "fw-mineral-deposit",
  "fw-carbonic-deposit",
}

local removed_fulgora_reclamation_recipes = {
  "fw-fulgora-lead-reclamation",
  "fw-fulgora-bauxite-reclamation",
  "fw-fulgora-tin-reclamation",
  "fw-fulgora-silicon-reclamation",
  "fw-fulgora-titanium-reclamation",
  "fw-fulgora-salt-reclamation",
}

local fulgora_scrap_components = {
  "fw-circuit-substrate",
  "fw-glass-lens",
  "fw-inductor-coil",
  "fw-capacitor",
  "fw-ceramic-insulator",
  "fw-composite-panel",
  "fw-light-frame",
  "fw-pressure-housing",
  "fw-foundry-lining",
}

local processed_materials = {
  "lead-plate",
  "aluminum-plate",
  "tin-plate",
  "silicon",
  "titanium-plate",
  "fw-salt",
}

local bacteria_specs = {
  { key = "lead", product = "lead-ore", rock = "iron-stromatolite" },
  { key = "bauxite", product = "bauxite-ore", rock = "copper-stromatolite" },
  { key = "tin", product = "tin-ore", rock = "copper-stromatolite" },
  { key = "silicon", product = "silicon-ore", rock = "iron-stromatolite" },
  { key = "titanium", product = "titanium-ore", rock = "iron-stromatolite" },
  { key = "salt", product = "fw-salt", rock = "copper-stromatolite" },
}

local function technology_unlocks(technology_name, recipe_name)
  local technology = data.raw.technology and data.raw.technology[technology_name]
  for _, effect in ipairs((technology and technology.effects) or {}) do
    if effect.type == "unlock-recipe" and effect.recipe == recipe_name then
      return true
    end
  end
  return false
end

local function recipe_produces(recipe, item_name)
  for _, result in ipairs(recipe.results or {}) do
    if (result.type or "item") == "item" and (result.name or result[1]) == item_name then
      return true
    end
  end
  return false
end

local function recipe_consumes(recipe, item_name)
  for _, ingredient in ipairs(recipe.ingredients or {}) do
    if (ingredient.type or "item") == "item" and (ingredient.name or ingredient[1]) == item_name then
      return true
    end
  end
  return false
end

local function rock_result(rock_name, item_name)
  local rock = data.raw["simple-entity"] and data.raw["simple-entity"][rock_name]
  for _, result in ipairs((rock and rock.minable and rock.minable.results) or {}) do
    if (result.type or "item") == "item" and (result.name or result[1]) == item_name then
      return result
    end
  end
end

for _, spec in ipairs(bacteria_specs) do
  local bacteria_name = "fw-" .. spec.key .. "-bacteria"
  local bacteria = data.raw.item and data.raw.item[bacteria_name]
  if not bacteria then
    error("Missing Gleba resource culture: " .. bacteria_name)
  end
  if bacteria.spoil_result ~= spec.product then
    error(bacteria_name .. " must spoil into " .. spec.product)
  end
  if not bacteria.icons or #bacteria.icons ~= 1 then
    error(bacteria_name .. " should use one full bacterial icon without a resource badge")
  end
  local icon_path = bacteria.icons[1].icon or ""
  if spec.rock == "copper-stromatolite"
      and spec.key ~= "salt"
      and not string.find(icon_path, "copper%-bacteria") then
    error(bacteria_name .. " must inherit the copper-bacteria graphic family")
  end
  if spec.key == "salt" and not string.find(icon_path, "fw%-salt%-bacteria") then
    error("Salt bacteria must use the dedicated mineral-white copper-bacteria recolor")
  end

  local bacteria_drop = rock_result(spec.rock, bacteria_name)
  if not bacteria_drop then
    error(spec.rock .. " must naturally seed " .. bacteria_name)
  end
  local bacteria_probability = bacteria_drop.independent_probability or bacteria_drop.probability
  if not bacteria_probability or bacteria_probability >= 1 then
    error(spec.rock .. " must use a chance-based drop for " .. bacteria_name)
  end

  local ore_drop = rock_result(spec.rock, spec.product)
  if not ore_drop then
    error(spec.rock .. " must include a small raw drop of " .. spec.product)
  end
  local ore_probability = ore_drop.independent_probability or ore_drop.probability
  if not ore_probability or ore_probability >= 1 then
    error(spec.rock .. " must use a chance-based raw drop for " .. spec.product)
  end

  local cultivation_name = bacteria_name .. "-cultivation"
  local cultivation = data.raw.recipe and data.raw.recipe[cultivation_name]
  if not cultivation or ((cultivation.categories and cultivation.categories[1]) or cultivation.category) ~= "organic" then
    error("Missing native biochamber cultivation recipe: " .. cultivation_name)
  end
  if not recipe_consumes(cultivation, bacteria_name) or not recipe_produces(cultivation, bacteria_name) then
    error(cultivation_name .. " must multiply its own culture")
  end
  if not technology_unlocks("bacteria-cultivation", cultivation_name) then
    error(cultivation_name .. " must unlock with bacteria-cultivation")
  end

  local bioleaching_name = spec.key == "salt"
    and "fw-gleba-salt-biomineralization"
    or "fw-gleba-" .. spec.key .. "-bioleaching"
  local bioleaching = data.raw.recipe and data.raw.recipe[bioleaching_name]
  if not bioleaching or not recipe_consumes(bioleaching, bacteria_name) then
    error(bioleaching_name .. " must consume its dedicated culture " .. bacteria_name)
  end
end

for rock_name, expected_results in pairs({
  ["iron-stromatolite"] = { "stone", "iron-ore", "iron-bacteria" },
  ["copper-stromatolite"] = { "stone", "copper-ore", "copper-bacteria" },
}) do
  for _, item_name in ipairs(expected_results) do
    local result = rock_result(rock_name, item_name)
    if not result then
      error(rock_name .. " lost native mining result " .. item_name)
    end
    local probability = result.independent_probability or result.probability
    if not probability or probability >= 1 then
      error(rock_name .. " must randomize native mining result " .. item_name)
    end
  end
end

local gleba = data.raw.planet and data.raw.planet.gleba
local gleba_resources = gleba
  and gleba.map_gen_settings
  and gleba.map_gen_settings.autoplace_settings
  and gleba.map_gen_settings.autoplace_settings.entity
  and gleba.map_gen_settings.autoplace_settings.entity.settings
  or {}
if not gleba_resources["fw-silica-vein"] then
  error("Gleba must retain natural Silica Veins alongside its bacterial silicon loop")
end

for planet_name, branch in pairs(branches) do
  for index, recipe_name in ipairs(branch.recipes) do
    local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
    if not recipe then
      error("Missing " .. planet_name .. " self-sufficiency recipe: " .. recipe_name)
    end
    if ((recipe.categories and recipe.categories[1]) or recipe.category) ~= branch.category then
      error(recipe_name .. " must use the native " .. planet_name .. " recipe category " .. branch.category)
    end
    if not recipe_produces(recipe, expected_products[index]) then
      error(recipe_name .. " no longer produces required ore " .. expected_products[index])
    end
    if not technology_unlocks(branch.technology, recipe_name) then
      error(recipe_name .. " must unlock with " .. branch.technology .. " for surface recovery")
    end
  end

  local planet = data.raw.planet and data.raw.planet[planet_name]
  local entity_settings = planet
    and planet.map_gen_settings
    and planet.map_gen_settings.autoplace_settings
    and planet.map_gen_settings.autoplace_settings.entity
    and planet.map_gen_settings.autoplace_settings.entity.settings
    or {}
  for _, resource_name in ipairs(displaced_deposits) do
    if entity_settings[resource_name] then
      error(planet_name .. " should use its native ore recovery loop instead of worldgen resource " .. resource_name)
    end
  end
end

local scrap_recycling = data.raw.recipe and data.raw.recipe["scrap-recycling"]
if not scrap_recycling then
  error("Fulgora self-sufficiency requires the native scrap-recycling recipe")
end
for _, raw_resource in ipairs(expected_products) do
  if recipe_produces(scrap_recycling, raw_resource) then
    error("Native scrap recycling must not directly produce raw FluxWorks resource " .. raw_resource)
  end
end
for _, component_name in ipairs(fulgora_scrap_components) do
  if not recipe_produces(scrap_recycling, component_name) then
    error("Native scrap recycling must recover manufactured FluxWorks component " .. component_name)
  end
end
for _, recipe_name in ipairs(removed_fulgora_reclamation_recipes) do
  if data.raw.recipe and data.raw.recipe[recipe_name] then
    error("Targeted scrap reclamation recipe must not exist: " .. recipe_name)
  end
end

for _, material_name in ipairs(processed_materials) do
  local recovered
  for _, component_name in ipairs(fulgora_scrap_components) do
    local recycling = data.raw.recipe and data.raw.recipe[component_name .. "-recycling"]
    if recycling and recipe_produces(recycling, material_name) then
      recovered = true
      break
    end
  end
  if not recovered then
    error("Fulgora scrap components need a recycling path into " .. material_name)
  end
end

local fulgora = data.raw.planet and data.raw.planet.fulgora
local fulgora_resources = fulgora
  and fulgora.map_gen_settings
  and fulgora.map_gen_settings.autoplace_settings
  and fulgora.map_gen_settings.autoplace_settings.entity
  and fulgora.map_gen_settings.autoplace_settings.entity.settings
  or {}
for _, resource_name in ipairs(displaced_deposits) do
  if fulgora_resources[resource_name] then
    error("fulgora should use scrap recycling instead of worldgen resource " .. resource_name)
  end
end
