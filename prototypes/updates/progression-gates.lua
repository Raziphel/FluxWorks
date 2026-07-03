local function has_unlock_effect(effects, recipe_name)
  for _, effect in pairs(effects or {}) do
    if effect.type == "unlock-recipe" and effect.recipe == recipe_name then
      return true
    end
  end
  return false
end

local function gate_recipe_to_tech(recipe_name, tech_name)
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  local tech = data.raw.technology and data.raw.technology[tech_name]
  if not (recipe and tech) then
    return
  end

  recipe.enabled = false
  tech.effects = tech.effects or {}
  if not has_unlock_effect(tech.effects, recipe_name) then
    table.insert(tech.effects, { type = "unlock-recipe", recipe = recipe_name })
  end
end

local function ingredient_name(ingredient)
  return ingredient.name or ingredient[1]
end

local function recipe_has_ingredient(recipe_name, expected_ingredient)
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if not recipe then
    return false
  end

  for _, ingredient_set in ipairs({
    recipe.ingredients,
    recipe.normal and recipe.normal.ingredients or nil,
    recipe.expensive and recipe.expensive.ingredients or nil,
  }) do
    for _, ingredient in pairs(ingredient_set or {}) do
      if ingredient_name(ingredient) == expected_ingredient then
        return true
      end
    end
  end

  return false
end

local function assert_recipe_lacks_ingredient(recipe_name, forbidden_ingredient, reason)
  if recipe_has_ingredient(recipe_name, forbidden_ingredient) then
    error(("Progression gate failure: %s still depends on %s (%s)"):format(
      recipe_name,
      forbidden_ingredient,
      reason
    ))
  end
end

local function assert_recipe_unlock(recipe_name, tech_name)
  local tech = data.raw.technology and data.raw.technology[tech_name]
  if not tech then
    error("Missing technology for progression gate validation: " .. tech_name)
  end

  if not has_unlock_effect(tech.effects, recipe_name) then
    error(("Progression gate failure: %s is not unlocked by %s"):format(recipe_name, tech_name))
  end
end

-- Tiny sanity patch: circuit contacts belong at electronics, not floating around in limbo.
gate_recipe_to_tech("fw-circuit-contact", "electronics")

-- Branch anchor machines need to bootstrap their own lanes instead of depending on products
-- that only exist inside those same lanes.
assert_recipe_lacks_ingredient(
  "fw-petrochemical-facility",
  "fw-polymer-binder",
  "the branch-defining petrochemical machine must not require petrochemical output to exist first"
)
assert_recipe_lacks_ingredient(
  "fw-hydraulic-plant",
  "fw-hydraulic-actuator",
  "the first hydraulic machine must not require a hydraulic-only component from its own category"
)
assert_recipe_lacks_ingredient(
  "fw-flow-regulator",
  "fw-reinforced-seal",
  "core Flux control parts need to stay craftable before the dedicated hydraulics branch opens"
)

assert_recipe_unlock("fw-petrochemical-facility", "fw-petrochemical-engineering")
assert_recipe_unlock("fw-hydraulic-plant", "fw-hydraulic-systems")
assert_recipe_unlock("fw-flow-regulator", "fw-sealed-systems")
assert_recipe_unlock("fw-smelter-array", "fw-metallurgic-assemblies")
