local Startup = require("prototypes.lib.startup-settings")

if not Startup.enabled("fw-enable-combat-recipe-integration", true) then
  return
end

local function ingredient_name(ingredient)
  return ingredient and (ingredient.name or ingredient[1])
end

local function recipe_has(recipe_name, expected_name)
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if not recipe then
    return false
  end

  for _, ingredient in pairs(recipe.ingredients or {}) do
    if ingredient_name(ingredient) == expected_name then
      return true
    end
  end
  return false
end

local function recipe_produces_ammo(recipe)
  for _, result in pairs(recipe.results or {}) do
    local result_name = ingredient_name(result)
    if result_name and data.raw.ammo and data.raw.ammo[result_name] then return true end
  end
  return false
end

local material_roles = {
  ["lead-plate"] = {
    "firearm-magazine",
    "piercing-rounds-magazine",
    "uranium-rounds-magazine",
    "shotgun-shell",
    "piercing-shotgun-shell",
    "cannon-shell",
    "explosive-cannon-shell",
    "artillery-shell",
  },
  ["aluminum-plate"] = {
    "rocket",
    "explosive-rocket",
    "flamethrower-ammo",
    "capture-robot-rocket",
  },
  ["titanium-plate"] = {
    "railgun-ammo",
  },
}

for material_name, recipe_names in pairs(material_roles) do
  for _, recipe_name in ipairs(recipe_names) do
    if data.raw.recipe[recipe_name] and not recipe_has(recipe_name, material_name) then
      error(("Combat material role lost: %s must use %s"):format(recipe_name, material_name))
    end
  end
end

for recipe_name, recipe in pairs(data.raw.recipe or {}) do
  if ((recipe.categories and recipe.categories[1]) or recipe.category) ~= "recycling"
    and string.sub(recipe_name, 1, 22) ~= "fw-exchange-from-flux-"
    and recipe_produces_ammo(recipe)
    and recipe_has(recipe_name, "iron-plate")
  then
    error(("Combat material role lost: ammunition recipe %s must not use iron plate"):format(recipe_name))
  end
end

for _, recipe_name in ipairs({
  "firearm-magazine",
  "piercing-rounds-magazine",
  "uranium-rounds-magazine",
  "shotgun-shell",
  "piercing-shotgun-shell",
  "rocket",
  "explosive-rocket",
  "cannon-shell",
  "explosive-cannon-shell",
  "uranium-cannon-shell",
  "explosive-uranium-cannon-shell",
  "artillery-shell",
  "railgun-ammo",
}) do
  if data.raw.recipe[recipe_name] and not recipe_has(recipe_name, "fw-gunpowder") then
    error(("Combat material role lost: ballistic ammunition %s must use gunpowder"):format(recipe_name))
  end
end
