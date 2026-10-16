-- No native rock changes are required to obtain FluxWorks bacteria.
local parents = {
  lead="iron-bacteria", bauxite="copper-bacteria", tin="copper-bacteria",
  silicon="iron-bacteria", titanium="iron-bacteria", salt="copper-bacteria",
}
local tech = data.raw.technology and data.raw.technology["bacteria-cultivation"]
assert(tech, "Razi FluxWorks: missing bacteria-cultivation technology")
local function unlocked(name)
  for _, e in ipairs(tech.effects or {}) do
    if e.type == "unlock-recipe" and e.recipe == name then return true end
  end
end
for key,parent in pairs(parents) do
  local name = "fw-" .. key .. "-bacteria-seeding"
  local recipe = data.raw.recipe and data.raw.recipe[name]
  assert(recipe and recipe.enabled == false, "Missing specialist culture seeding " .. name)
  assert(recipe.category == "organic" and recipe.allow_productivity == false,
    "Invalid seeding category or productivity " .. name)
  assert(unlocked(name), "Culture seeding is not unlocked: " .. name)
  local found_parent, found_product = false,false
  for _,ingredient in ipairs(recipe.ingredients or {}) do
    if ingredient.name == parent and ingredient.amount > 0 then found_parent=true end
  end
  for _,result in ipairs(recipe.results or {}) do
    if result.name == "fw-" .. key .. "-bacteria" and result.amount > 0 then found_product=true end
  end
  assert(found_parent and found_product, "Self-dependent culture seeding " .. name)
end
