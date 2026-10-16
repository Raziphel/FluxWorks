local RaziSettings=require("__razi_lib__/lib/settings")
local Technology=require("__razi_lib__/lib/technology")
local Icons=require("__razi_lib__/lib/icons")
-- K2SO manufacturing alternatives for the optional early research disciplines.
-- The Space Age-only recipes stay intact, and no K2SO tech card is rewritten.
if not mods["Krastorio2-spaced-out"]
  or not RaziSettings.enabled("fw-enable-k2so-integration",true) then return end

local alternatives = {
  {
    name = "fw-k2so-industrial-standards",
    pack = "fw-industrial-methods-science-pack",
    unlock = "fw-industrial-methods-science",
    time = 12,
    amount = 5,
    ingredients = {
      { type = "item", name = "fw-metal-mesh", amount = 1 },
      { type = "item", name = "kr-steel-beam", amount = 2 },
      { type = "item", name = "kr-electronic-components", amount = 1 },
    },
  },
  {
    name = "fw-k2so-systems-benchmarking",
    pack = "fw-systems-analysis-science-pack",
    unlock = "fw-systems-analysis-science",
    time = 14,
    amount = 5,
    ingredients = {
      { type = "item", name = "fw-sensor-package", amount = 1 },
      { type = "item", name = "kr-electronic-components", amount = 2 },
      { type = "item", name = "battery", amount = 2 },
    },
  },
}

for index, spec in ipairs(alternatives) do
  local pack = data.raw.item and data.raw.item[spec.pack]
  local technology = data.raw.technology and data.raw.technology[spec.unlock]
  local available = pack ~= nil and technology ~= nil
  for _, input in ipairs(spec.ingredients) do
    if not (data.raw.item and data.raw.item[input.name]) then
      available = false
      break
    end
  end
  if available then
    if not data.raw.recipe[spec.name] then
      data:extend({ {
        type = "recipe",
        name = spec.name,
        icons = Icons.from_prototype(pack),
        category = "advanced-crafting",
        subgroup = "fw-science-packs",
        order = ("d[domain]-z[k2so]-%02d"):format(index),
        enabled = false,
        energy_required = spec.time,
        allow_productivity = true,
        ingredients = table.deepcopy(spec.ingredients),
        results = { { type = "item", name = spec.pack, amount = spec.amount } },
        main_product = spec.pack,
      } })
    end
    Technology.get(spec.unlock):unlock(spec.name)
  end
end

return alternatives
