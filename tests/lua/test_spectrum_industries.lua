-- Run from the FluxWorks repository root with Lua 5.2+:
--   lua tests/lua/test_spectrum_industries.lua
-- Does not require Factorio. The game engine must still validate prototypes.
local function deepcopy(value)
  if type(value) ~= "table" then return value end
  local copied = {}
  for key, entry in pairs(value) do copied[deepcopy(key)] = deepcopy(entry) end
  return copied
end
table.deepcopy = deepcopy

local all_items = {
  "processing-unit", "advanced-circuit", "fw-sensor-package",
  "electronic-circuit", "superconductor", "copper-cable",
  "fw-stabilized-flux-crystal", "fw-flux-lattice", "fw-metal-mesh",
  "plastic-bar", "coal", "fw-resin", "battery", "copper-plate",
  "iron-plate", "fw-salt", "fw-circuit-substrate", "fw-lens-array",
  "fw-capacitor", "steel-plate", "fw-carbon", "low-density-structure",
  "fw-cermet", "rocket-fuel", "solid-fuel", "fw-gunpowder",
  "spoilage", "nutrients", "carbon-fiber", "yumako-mash", "bioflux",
  "fw-nutrient-bed", "fw-resonance-substrate",
}
local techs = {
  "fw-flux-phase-engineering", "fw-superconductive-systems",
  "fw-flux-resonance", "fw-flux-chemical-synthesis",
  "fw-fulgora-electrochemistry", "fw-sensor-integration",
  "fw-flux-metallurgy", "fw-vulcanus-industrial-symbiosis",
  "fw-propellant-synthesis", "fw-flux-green-cultivation",
  "fw-gleba-regenerative-symbiosis", "fw-flux-green-propagation",
  "fw-cross-planetary-industrial-convergence",
}
local fluids = {
  "fw-purple-flux", "fw-yellow-flux", "fw-red-flux",
  "fw-green-flux", "sulfuric-acid", "light-oil",
}

local function world(with_missing_item)
  local raw = {
    item = {}, fluid = {}, technology = {}, recipe = {},
    ["recipe-category"] = {}, ["item-subgroup"] = {},
  }
  for _, name in ipairs(all_items) do
    if name ~= with_missing_item then
      raw.item[name] = {name = name, icon = "__base__/graphics/icons/iron-plate.png",
        icon_size = 64, subgroup = "intermediate-product"}
    end
  end
  for _, name in ipairs(fluids) do raw.fluid[name] = {name = name} end
  for _, name in ipairs(techs) do
    raw.technology[name] = {
      name = name, effects = {}, prerequisites = {},
      unit = {ingredients = {{"automation-science-pack", 1}}, count = 100, time = 30},
    }
  end
  for _, category in ipairs({"fw-flux-synthesis", "fw-arc-smelting"}) do
    raw["recipe-category"][category] = {name = category}
  end
  for _, spectrum in ipairs({"purple", "yellow", "red", "green"}) do
    local subgroup = "fw-flux-" .. spectrum
    raw["item-subgroup"][subgroup] = {name = subgroup}
  end
  _G.data = {raw = raw}
  function data:extend(prototypes)
    for _, prototype in ipairs(prototypes) do
      assert(not raw[prototype.type][prototype.name], "Duplicate: " .. prototype.name)
      raw[prototype.type][prototype.name] = prototype
    end
  end
  _G.log = function() end
  return raw
end

local raw = world()
dofile("prototypes/recipes/spectrum-industries.lua")
local count, paired = 0, 0
for name, recipe in pairs(raw.recipe) do
  count = count + 1
  assert(name:sub(1, 12) == "fw-spectrum-", "Unexpected recipe " .. name)
  assert(recipe.enabled == false and recipe.allow_productivity == false,
    "Alternative should not be a free, productive recipe: " .. name)
  assert(recipe.icons and #recipe.icons >= 2, "Spectrum overlay missing")
  assert(recipe.main_product == recipe.results[1].name, "Product mismatch")
  assert(raw.item[recipe.main_product] ~= nil)
  assert(recipe.category == "fw-arc-smelting" or recipe.category == "fw-flux-synthesis")
  assert(recipe.localised_name[1] == "recipe-name." .. name)
  assert(recipe.localised_description[1] == "recipe-description." .. name)
  local inputs, output_found = 0, false
  for _, ingredient in ipairs(recipe.ingredients) do
    assert(ingredient.amount > 0)
    if ingredient.type == "fluid" then
      inputs = inputs + 1
      assert(raw.fluid[ingredient.name], "Missing fluid " .. ingredient.name)
    else
      assert(raw.item[ingredient.name], "Missing item " .. ingredient.name)
    end
  end
  assert(inputs <= 2, "Too many fluid inputs: " .. name)
  if #recipe.icons == 3 then paired = paired + 1 end
  for _, tech in pairs(raw.technology) do
    for _, effect in ipairs(tech.effects) do
      if effect.type == "unlock-recipe" and effect.recipe == name then
        assert(not output_found, "Multiple unlockers for " .. name)
        output_found = true
      end
    end
  end
  assert(output_found, "No source technology unlocks " .. name)
end
assert(count == 14, "Expected fourteen processes, found " .. count)
assert(paired == 2, "Expected two dual-spectrum processes")

-- Repeated invocation must never duplicate unlocks or redefine recipes.
dofile("prototypes/recipes/spectrum-industries.lua")
local after = 0
for _ in pairs(raw.recipe) do after = after + 1 end
assert(after == 14)
for _, tech in pairs(raw.technology) do
  local seen = {}
  for _, effect in ipairs(tech.effects) do
    assert(not seen[effect.recipe], "Duplicate recipe unlock " .. effect.recipe)
    seen[effect.recipe] = true
  end
end

-- Optional products and ingredients are skipped, not invented by FluxWorks.
local missing = world("carbon-fiber")
dofile("prototypes/recipes/spectrum-industries.lua")
assert(not missing.recipe["fw-spectrum-carbon-fiber-cultivation"])
assert(missing.recipe["fw-spectrum-arc-steel-reduction"])
print("Spectrum Industries: 14 manufacturing processes, 2 dual spectra, guards OK")
