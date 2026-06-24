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

-- Tiny sanity patch: circuit contacts belong at electronics, not floating around in limbo.
gate_recipe_to_tech("fw-circuit-contact", "electronics")
