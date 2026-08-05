local MAXIMUM_INGREDIENTS = 6
local INGREDIENT_CAP_OVERRIDES = {
  -- These are explicit four-planet convergence recipes. Their width represents
  -- independent production lanes rather than repeated subcomponents.
  ["fw-converged-quantum-processor"] = 7,
}
local CURATED_SHARED_RECIPES = {
  "artillery-turret", "artillery-wagon", "assembling-machine-3", "beacon",
  "big-electric-pole", "big-mining-drill", "biochamber", "biolab",
  "bulk-inserter", "cargo-bay", "cargo-landing-pad", "centrifuge",
  "cryogenic-plant", "electric-furnace", "electromagnetic-plant",
  "electromagnetic-science-pack", "fission-reactor-equipment", "fluoroketone",
  "foundry", "fusion-generator", "fusion-power-cell", "fusion-reactor",
  "fusion-reactor-equipment", "heat-pipe", "laser-turret", "mech-armor",
  "nuclear-reactor", "oil-refinery", "personal-roboport-equipment",
  "personal-roboport-mk2-equipment", "power-armor-mk2", "quantum-processor",
  "rail-chain-signal", "rail-signal", "railgun", "railgun-turret", "recycler",
  "roboport", "rocket-silo", "rocket-turret", "space-platform-starter-pack",
  "spidertron", "tank", "teslagun", "tesla-turret", "train-stop",
  "turbo-splitter",
}
local COMPACT_COMPONENTS = {
  "fw-ceramic-casing",
  "fw-control-assembly",
  "fw-field-winding",
  "fw-flow-regulator",
  "fw-foundry-lining",
  "fw-power-regulator",
  "fw-pressure-housing",
  "fw-sensor-package",
  "fw-signal-conduit",
  "fw-transformer-core",
}

local function is_fluxworks_recipe(recipe_name)
  return type(recipe_name) == "string" and string.sub(recipe_name, 1, 3) == "fw-"
end

local complexity_violations = {}

for recipe_name, recipe in pairs(data.raw.recipe or {}) do
  -- FluxWorks can enforce a total complexity budget for recipes it owns. A
  -- base or third-party recipe merely consuming a FluxWorks component remains
  -- under its owner's control; shared recipe boundaries are handled by the
  -- targeted normalizer instead of a global ingredient-count assertion.
  if is_fluxworks_recipe(recipe_name) then
    for _, ingredients in ipairs({
      recipe.ingredients,
      recipe.normal and recipe.normal.ingredients,
      recipe.expensive and recipe.expensive.ingredients,
    }) do
      local maximum = INGREDIENT_CAP_OVERRIDES[recipe_name] or MAXIMUM_INGREDIENTS
      if ingredients and #ingredients > maximum then
        complexity_violations[#complexity_violations + 1] = ("%s has %d ingredients"):format(
          recipe_name, #ingredients
        )
      end
    end
  end
end

for _, recipe_name in ipairs(CURATED_SHARED_RECIPES) do
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if recipe then
    for _, ingredients in ipairs({
      recipe.ingredients,
      recipe.normal and recipe.normal.ingredients,
      recipe.expensive and recipe.expensive.ingredients,
    }) do
      if ingredients and #ingredients > MAXIMUM_INGREDIENTS then
        complexity_violations[#complexity_violations + 1] = ("%s has %d ingredients"):format(
          recipe_name, #ingredients
        )
      end
    end
  end
end

if #complexity_violations > 0 then
  table.sort(complexity_violations)
  error(("FluxWorks-owned and curated shared recipes are capped at %d ingredients to avoid parts-checklist crafting:\n  - %s"):format(
    MAXIMUM_INGREDIENTS, table.concat(complexity_violations, "\n  - ")
  ))
end

-- Four inputs is enough detail for parts that recur throughout the factory.
for _, recipe_name in ipairs(COMPACT_COMPONENTS) do
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  local ingredients = recipe and recipe.ingredients
  if not ingredients then
    error("Missing compact component recipe " .. recipe_name)
  end
  if #ingredients > 4 then
    error(("%s has %d ingredients; recurring components are capped at 4"):format(
      recipe_name, #ingredients
    ))
  end
end
