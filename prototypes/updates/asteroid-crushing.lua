-- Make orbital industry self-sufficient for FluxWorks ammunition and distribute
-- the extended raw-resource catalog across the advanced asteroid recipes.

local function item_result(name, amount, probability)
  if not (data.raw.item and data.raw.item[name]) then
    error("FluxWorks asteroid crushing references missing item " .. name)
  end
  local result = { type = "item", name = name, amount = amount }
  if probability then result.probability = probability end
  return result
end

local function replace_results(recipe_name, results)
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if not recipe then error("FluxWorks asteroid crushing is missing recipe " .. recipe_name) end
  recipe.results = results
  recipe.main_product = nil
end

-- Basic chunks close the firearm-magazine loop in orbit:
-- metallic -> lead, carbonic -> coal + salt for early gunpowder.
replace_results("metallic-asteroid-crushing", {
  item_result("iron-ore", 10),
  item_result("lead-ore", 10),
  item_result("metallic-asteroid-chunk", 1, 0.20),
})

replace_results("carbonic-asteroid-crushing", {
  item_result("carbon", 6),
  item_result("coal", 4),
  item_result("fw-salt", 4),
  item_result("carbonic-asteroid-chunk", 1, 0.20),
})

-- Advanced crushing owns the complete extended raw-resource catalog, divided
-- by asteroid identity so each chunk family has a distinct logistical role.
replace_results("advanced-metallic-asteroid-crushing", {
  item_result("iron-ore", 10),
  item_result("copper-ore", 4),
  item_result("lead-ore", 4),
  item_result("tin-ore", 3),
  item_result("metallic-asteroid-chunk", 1, 0.05),
})

replace_results("advanced-carbonic-asteroid-crushing", {
  item_result("carbon", 5),
  item_result("sulfur", 2),
  item_result("coal", 3),
  item_result("fw-salt", 6),
  item_result("carbonic-asteroid-chunk", 1, 0.05),
})

replace_results("advanced-oxide-asteroid-crushing", {
  item_result("ice", 3),
  item_result("calcite", 2),
  item_result("bauxite-ore", 4),
  item_result("titanium-ore", 2),
  item_result("silicon-ore", 5),
  item_result("oxide-asteroid-chunk", 1, 0.05),
})
