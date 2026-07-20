local concise_recipes = {
  "fw-kr-steel-pump",
  "fw-kr-big-storage-tank",
  "fw-kr-huge-storage-tank",
  "fw-kr-strongbox",
  "fw-kr-passive-provider-strongbox",
  "fw-kr-active-provider-strongbox",
  "fw-kr-buffer-strongbox",
  "fw-kr-storage-strongbox",
  "fw-kr-requester-strongbox",
  "fw-kr-warehouse",
  "fw-kr-passive-provider-warehouse",
  "fw-kr-active-provider-warehouse",
  "fw-kr-buffer-warehouse",
  "fw-kr-storage-warehouse",
  "fw-kr-requester-warehouse",
}

for _, recipe_name in ipairs(concise_recipes) do
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if not recipe then
    error("FluxWorks concise logistics validation references missing recipe " .. recipe_name)
  end
  if #(recipe.ingredients or {}) > 5 then
    error(recipe_name .. " has regressed into a parts-checklist recipe")
  end
end
