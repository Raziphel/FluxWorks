-- Four deliberately additive K2SO + FluxWorks planetary recipes. These
-- consume a K2SO resource *alongside* the corresponding Flux discipline,
-- rather than placing a new toll on native planet technologies or science.
local Startup = require("prototypes.lib.startup-settings")
if not mods["Krastorio2-spaced-out"]
  or not Startup.enabled("fw-enable-k2so-integration", true) then return end

local alternatives = {
  {
    name = "fw-k2so-vulcanus-imersium-cermet",
    product = "fw-vulcanus-slag-cermet",
    technology = "fw-vulcanus-industrial-symbiosis",
    category = "metallurgy",
    subgroup = "fw-chemistry-materials",
    energy_required = 14,
    amount = 2,
    inputs = {
      { type = "item", name = "kr-imersium-plate", amount = 2 },
      { type = "item", name = "tungsten-carbide", amount = 2 },
      { type = "item", name = "fw-cermet", amount = 2 },
      { type = "fluid", name = "fw-red-flux", amount = 30 },
    },
  },
  {
    name = "fw-k2so-gleba-biomass-resin",
    product = "fw-gleba-spore-resin",
    technology = "fw-gleba-regenerative-symbiosis",
    category = "organic",
    subgroup = "fw-chemistry-materials",
    energy_required = 12,
    amount = 2,
    inputs = {
      { type = "item", name = "kr-biomass", amount = 6 },
      { type = "item", name = "bioflux", amount = 2 },
      { type = "item", name = "fw-resin", amount = 2 },
      { type = "fluid", name = "fw-green-flux", amount = 24 },
    },
  },
  {
    name = "fw-k2so-fulgora-rare-metal-mesh",
    product = "fw-fulgora-static-mesh",
    technology = "fw-fulgora-electromagnetic-symbiosis",
    category = "electromagnetics",
    subgroup = "fw-chemistry-materials",
    energy_required = 12,
    amount = 2,
    inputs = {
      { type = "item", name = "kr-rare-metals", amount = 3 },
      { type = "item", name = "holmium-plate", amount = 2 },
      { type = "item", name = "fw-metal-mesh", amount = 1 },
      { type = "fluid", name = "fw-yellow-flux", amount = 24 },
    },
  },
  {
    name = "fw-k2so-aquilo-lithium-cryogel",
    product = "fw-aquilo-cryogel",
    technology = "fw-aquilo-thermal-symbiosis",
    category = "cryogenics",
    subgroup = "fw-chemistry-materials",
    energy_required = 15,
    amount = 2,
    inputs = {
      { type = "item", name = "kr-lithium", amount = 3 },
      { type = "item", name = "ice", amount = 4 },
      { type = "item", name = "fw-thermal-buffer", amount = 1 },
      { type = "fluid", name = "fw-red-flux", amount = 30 },
    },
  },
}

local function exists(entry)
  if entry.type == "fluid" then
    return data.raw.fluid and data.raw.fluid[entry.name]
  end
  return data.raw.item and data.raw.item[entry.name]
end

for index, spec in ipairs(alternatives) do
  local product = data.raw.item and data.raw.item[spec.product]
  local tech = data.raw.technology and data.raw.technology[spec.technology]
  local missing = nil
  for _, input in ipairs(spec.inputs) do
    if not exists(input) then missing = input.name; break end
  end
  -- Missing K2SO items are version-compatible no-ops, not broken recipes.
  if product and tech and not missing then
    local result = {
      type = "recipe",
      name = spec.name,
      category = spec.category,
      subgroup = spec.subgroup,
      order = ("z[k2so-planetary]-%02d"):format(index),
      enabled = false,
      energy_required = spec.energy_required,
      allow_productivity = true,
      ingredients = table.deepcopy(spec.inputs),
      results = { { type = "item", name = spec.product, amount = spec.amount } },
      main_product = spec.product,
    }
    if product.icons then
      result.icons = table.deepcopy(product.icons)
    else
      result.icon = product.icon
      result.icon_size = product.icon_size
    end
    if not data.raw.recipe[spec.name] then data:extend({ result }) end
    tech.effects = tech.effects or {}
    local found = false
    for _, effect in ipairs(tech.effects) do
      if effect.type == "unlock-recipe" and effect.recipe == spec.name then
        found = true
        break
      end
    end
    if not found then
      tech.effects[#tech.effects + 1] = { type = "unlock-recipe", recipe = spec.name }
    end
  end
end
return alternatives
