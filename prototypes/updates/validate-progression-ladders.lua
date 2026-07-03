local Startup = require("prototypes.lib.startup-settings")

local function has_unlock_effect(effects, recipe_name)
  for _, effect in pairs(effects or {}) do
    if effect.type == "unlock-recipe" and effect.recipe == recipe_name then
      return true
    end
  end

  return false
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

local function assert_recipe_unlocks(tech_name, recipe_names)
  local tech = data.raw.technology and data.raw.technology[tech_name]
  if not tech then
    error("Missing technology for progression validation: " .. tech_name)
  end

  for _, recipe_name in ipairs(recipe_names) do
    if not has_unlock_effect(tech.effects, recipe_name) then
      error(("Progression ladder failure: %s does not unlock %s"):format(tech_name, recipe_name))
    end
  end
end

local function assert_true(condition, message)
  if not condition then
    error(message)
  end
end

local function assert_recipe_lacks_ingredients(recipe_name, forbidden_ingredients, reason)
  for _, forbidden_ingredient in ipairs(forbidden_ingredients) do
    if recipe_has_ingredient(recipe_name, forbidden_ingredient) then
      error(("Progression ladder failure: %s still depends on %s (%s)"):format(
        recipe_name,
        forbidden_ingredient,
        reason
      ))
    end
  end
end

local function assert_recipe_has_ingredient(recipe_name, required_ingredient, reason)
  if not recipe_has_ingredient(recipe_name, required_ingredient) then
    error(("Progression ladder failure: %s is missing %s (%s)"):format(
      recipe_name,
      required_ingredient,
      reason
    ))
  end
end

assert_recipe_unlocks("fw-petrochemical-engineering", {
  "fw-petrochemical-facility",
  "fw-polymer-binder",
  "fw-chlorinated-binder-stock",
})
assert_recipe_unlocks("fw-polymer-stabilization", {
  "fw-elastomer-matrix",
  "fw-reinforced-seal",
})
assert_recipe_unlocks("fw-hydraulic-systems", {
  "fw-hydraulic-plant",
  "fw-hydraulic-actuator",
  "fw-servo-valve",
})
assert_recipe_unlocks("fw-fluid-control-architecture", {
  "fw-hydraulic-manifold",
})

assert_recipe_lacks_ingredients(
  "fw-petrochemical-facility",
  {
    "fw-polymer-binder",
    "fw-chlorinated-binder-stock",
    "fw-elastomer-matrix",
    "fw-reinforced-seal",
    "fw-hydraulic-actuator",
    "fw-servo-valve",
    "fw-hydraulic-manifold",
  },
  "the petrochemical bootstrap must not consume products from deeper petrochem or hydraulic tiers"
)
assert_recipe_lacks_ingredients(
  "fw-hydraulic-plant",
  {
    "fw-hydraulic-actuator",
    "fw-servo-valve",
    "fw-hydraulic-manifold",
  },
  "the first hydraulic machine must bootstrap the branch instead of requiring later hydraulic parts"
)
assert_recipe_lacks_ingredients(
  "fw-flow-regulator",
  {
    "fw-reinforced-seal",
    "fw-hydraulic-actuator",
    "fw-servo-valve",
    "fw-hydraulic-manifold",
  },
  "core control hardware must stay craftable before the dedicated hydraulic lane opens"
)

assert_recipe_unlocks("fw-isotope-conditioning", {
  "fw-atomic-enricher",
  "fw-shielded-fuel-casing",
  "fw-fuel-pellet-bundle",
  "fw-moderator-lattice",
  "fw-isotope-matrix",
  "fw-reactor-grade-fuel-cell",
})
assert_recipe_unlocks("fw-reactor-doping", {
  "fw-control-rod-assembly",
  "fw-reactor-coolant-cartridge",
  "fw-reactor-dopant",
})
assert_recipe_unlocks("fw-actinide-recovery", {
  "fw-spent-fuel-reconditioning",
  "fw-radioactive-scrap-sorting",
  "fw-isotope-recovery",
})
assert_recipe_unlocks("fw-reactor-instrumentation", {
  "fw-nuclear-fuel-overdrive",
})

assert_recipe_lacks_ingredients(
  "fw-atomic-enricher",
  {
    "fw-isotope-matrix",
    "fw-fuel-pellet-bundle",
    "fw-moderator-lattice",
    "fw-control-rod-assembly",
    "fw-reactor-coolant-cartridge",
    "fw-reactor-dopant",
    "fw-recovered-actinides",
  },
  "the atomic branch machine must unlock before the isotope and reactor-part products it exists to make"
)
assert_recipe_lacks_ingredients(
  "fw-reactor-grade-fuel-cell",
  {
    "fw-reactor-dopant",
    "fw-reactor-coolant-cartridge",
  },
  "the first upgraded fuel-cell recipe must come online before the deeper reactor-doping layer"
)

if Startup.enabled("fw-enable-recipe-integration", true)
  and Startup.enabled("fw-enable-orbital-and-planetary-integration", true) then
  assert_recipe_has_ingredient(
    "chemical-plant",
    "fw-reinforced-seal",
    "the petrochem and hydraulic branch should visibly feed vanilla machine construction once integration is on"
  )
  assert_recipe_has_ingredient(
    "rocket-silo",
    "fw-hydraulic-manifold",
    "orbital hardware should reflect the late hydraulic control branch when integration is enabled"
  )
  assert_recipe_has_ingredient(
    "storage-tank",
    "fw-hydraulic-manifold",
    "fluid infrastructure should consume hydraulic control hardware after the integration sweep"
  )
  assert_recipe_has_ingredient(
    "superconductor",
    "fw-polymer-binder",
    "late electrical materials should consume the petrochemical branch after the integration sweep"
  )
  assert_recipe_has_ingredient(
    "quantum-processor",
    "fw-chlorinated-binder-stock",
    "late computation parts should depend on the heavier petrochemical branch once integrated"
  )
  assert_recipe_has_ingredient(
    "fusion-power-cell",
    "fw-reactor-dopant",
    "fusion power cells should reflect the atomic late-game branch once integration is enabled"
  )
  assert_recipe_has_ingredient(
    "fusion-power-cell",
    "fw-reactor-coolant-cartridge",
    "fusion power cells should consume the atomic thermal-control branch once integration is enabled"
  )
end
