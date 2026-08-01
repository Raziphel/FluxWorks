local function amount_of(entries, name)
  for _, entry in ipairs(entries or {}) do
    if type(entry) == "table" and (entry.name or entry[1]) == name then
      return entry.amount or entry[2] or 0
    end
  end
  return 0
end

local steel = data.raw.recipe and data.raw.recipe["steel-plate"]
if not steel then
  error("FluxWorks requires the default steel-plate recipe")
end

if data.raw.item["fw-steel-bloom"] or data.raw.recipe["fw-steel-bloom"] then
  error("FluxWorks steel blooms should remain removed")
end

if ((steel.categories and steel.categories[1]) or steel.category) ~= "smelting"
    or steel.enabled ~= false
    or steel.energy_required ~= 16
    or #(steel.ingredients or {}) ~= 1
    or amount_of(steel.ingredients, "iron-plate") ~= 5
    or #(steel.results or {}) ~= 1
    or amount_of(steel.results, "steel-plate") ~= 1 then
  error("FluxWorks steel must retain the default 5 iron plate to 1 steel plate smelting recipe")
end
