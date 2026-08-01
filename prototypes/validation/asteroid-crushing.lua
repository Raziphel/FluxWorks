local function result_amount(recipe_name, item_name)
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if not recipe then error("Asteroid crushing validation is missing recipe " .. recipe_name) end
  for _, result in pairs(recipe.results or {}) do
    if result.type == "item" and result.name == item_name then
      return result.amount or result.amount_min or 0
    end
  end
  return 0
end

local required_outputs = {
  ["metallic-asteroid-crushing"] = { "iron-ore", "lead-ore" },
  ["carbonic-asteroid-crushing"] = { "carbon", "coal", "fw-salt" },
  ["advanced-metallic-asteroid-crushing"] = { "iron-ore", "copper-ore", "lead-ore", "tin-ore" },
  ["advanced-carbonic-asteroid-crushing"] = { "carbon", "sulfur", "coal", "fw-salt" },
  ["advanced-oxide-asteroid-crushing"] = { "ice", "calcite", "bauxite-ore", "titanium-ore", "silicon-ore" },
}

for recipe_name, item_names in pairs(required_outputs) do
  for _, item_name in ipairs(item_names) do
    if result_amount(recipe_name, item_name) <= 0 then
      error(recipe_name .. " must produce " .. item_name)
    end
  end
end

if result_amount("metallic-asteroid-crushing", "iron-ore")
  ~= result_amount("metallic-asteroid-crushing", "lead-ore")
then
  error("Basic metallic asteroid crushing must maintain a 50/50 iron-to-lead yield")
end
