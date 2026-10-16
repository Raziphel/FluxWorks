local RaziSettings=require("__razi_lib__/lib/settings")
local Item=require("__razi_lib__/lib/item")
local Technology=require("__razi_lib__/lib/technology")
local IndustrialIcons=require("prototypes.lib.industrial-icons")
-- Razi-era industrial alternatives. These deliberately reuse established
-- outputs and machines; no extra science ladder or mandatory intermediates.
-- Skip missing source prototypes rather than rewriting external recipes.
if RaziSettings.value("fw-rp-industrial-depth","expanded")=="core" then return end

local function item(name, amount)
  return {type = "item", name = name, amount = amount}
end
local function fluid(name, amount)
  return {type = "fluid", name = name, amount = amount}
end
local processes = {
  {"reactor-lining-recovery", "red", nil, "fw-flux-metallurgy", "fw-arc-smelting", "fw-foundry-lining", 6, 12,
   {item("steel-plate", 12), item("fw-carbon", 8), item("fw-resin", 4), fluid("fw-red-flux", 60)}},
  {"resonant-mesh-fabrication", "purple", "yellow", "fw-flux-resonance", "fw-flux-synthesis", "fw-metal-mesh", 12, 15,
   {item("copper-plate", 24), item("fw-circuit-substrate", 4), fluid("fw-purple-flux", 60), fluid("fw-yellow-flux", 40)}},
  {"precision-seal-molding", "yellow", nil, "fw-flux-chemical-synthesis", "fw-flux-synthesis", "fw-reinforced-seal", 6, 11,
   {item("fw-resin", 6), item("fw-rubber-sheet", 8), item("fw-inline-filter", 3), fluid("fw-yellow-flux", 45)}},
  {"living-filtration", "green", nil, "fw-flux-green-cultivation", "fw-flux-synthesis", "fw-inline-filter", 7, 13,
   {item("fw-resin", 6), item("fw-nutrient-bed", 4), item("fw-metal-mesh", 2), fluid("fw-green-flux", 40)}},
  {"chromatic-cermet-recasting", "red", "yellow", "fw-cross-planetary-industrial-convergence", "fw-arc-smelting", "fw-cermet", 6, 18,
   {item("steel-plate", 12), item("copper-plate", 20), item("fw-carbon", 5), fluid("fw-red-flux", 75), fluid("fw-yellow-flux", 40)}},
  {"regenerative-substrate-weaving", "purple", "green", "fw-cross-planetary-industrial-convergence", "fw-flux-synthesis", "fw-resonance-substrate", 3, 21,
   {item("fw-sensor-package", 4), item("fw-resin", 6), item("fw-flux-lattice", 2), fluid("fw-purple-flux", 50), fluid("fw-green-flux", 50)}},
  {"thermal-buffer-lamination", "purple", "red", "fw-aquilo-thermal-symbiosis", "fw-flux-synthesis", "fw-thermal-buffer", 4, 18,
   {item("fw-ceramic-casing", 6), item("fw-annealed-cermet", 4), item("fw-aquilo-cryogel", 3), fluid("fw-purple-flux", 45), fluid("fw-red-flux", 30)}},
  {"sensor-membrane-reclamation", "yellow", "green", "fw-cross-planetary-industrial-convergence", "fw-flux-synthesis", "fw-sensor-package", 5, 18,
   {item("fw-circuit-substrate", 8), item("fw-capacitor", 4), item("fw-inline-filter", 4), fluid("fw-yellow-flux", 55), fluid("fw-green-flux", 30)}},
}
local function product(name)
  local found=Item.optional(name)
  return found and found:raw() or nil
end
local made = 0
for index, spec in ipairs(processes) do
  local id, colour, partner, tech_name, category, result, amount, time, inputs = table.unpack(spec, 1, 9)
  local recipe_name = "fw-industry-" .. id
  local tech = data.raw.technology and data.raw.technology[tech_name]
  local output = product(result)
  local liquid_count, valid = 0, true
  for _, ingredient in ipairs(inputs) do
    if ingredient.type == "fluid" then
      liquid_count = liquid_count + 1
      if not (data.raw.fluid and data.raw.fluid[ingredient.name]) then valid = false end
    elseif not product(ingredient.name) then valid = false end
  end
  if tech and output and valid and liquid_count <= 2
    and data.raw["recipe-category"] and data.raw["recipe-category"][category] then
    if not data.raw.recipe[recipe_name] then
      local image = IndustrialIcons.spectrum(output, colour, partner, "extension")
      if image then
        local subgroup = data.raw["item-subgroup"] and data.raw["item-subgroup"]["fw-flux-" .. colour]
          and "fw-flux-" .. colour or output.subgroup or "intermediate-product"
        data:extend({{
          type = "recipe", name = recipe_name, icons = image,
          localised_name = {"recipe-name." .. recipe_name},
          localised_description = {"recipe-description." .. recipe_name},
          subgroup = subgroup, category = category,
          order = string.format("zz[industrial-extension]-%02d", index),
          enabled = false, allow_productivity = false, auto_recycle = false,
          energy_required = time, ingredients = table.deepcopy(inputs),
          results = {item(result, amount)}, main_product = result,
        }})
      end
    end
    if data.raw.recipe[recipe_name] then
      Technology.get(tech_name):unlock(recipe_name)
      made = made + 1
    end
  else
    log("FluxWorks extension: skipped unavailable process " .. recipe_name)
  end
end
log("FluxWorks extension: " .. made .. " additional manufacturing alternatives")
