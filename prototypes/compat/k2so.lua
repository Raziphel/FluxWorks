-- Additive Krastorio 2 Spaced Out integration. Do not replace Krastorio 2's
-- recipes or science tree; reuse its late materials in FluxWorks-owned content.
local Startup = require("prototypes.lib.startup-settings")
if not mods["Krastorio2-spaced-out"] or not Startup.enabled("fw-enable-k2so-integration", true) then
  return
end

local function item_exists(name)
  return data.raw.item and data.raw.item[name]
end

local function add_science(technology_name, science_name)
  local technology = data.raw.technology and data.raw.technology[technology_name]
  if not technology or not ((data.raw.tool and data.raw.tool[science_name]) or item_exists(science_name))
    or not technology.unit then return end
  technology.unit.ingredients = technology.unit.ingredients or {}
  for _, ingredient in ipairs(technology.unit.ingredients) do
    if (ingredient.name or ingredient[1]) == science_name then return end
  end
  technology.unit.ingredients[#technology.unit.ingredients + 1] = { science_name, 1 }
end

local function add_prerequisite(technology_name, prerequisite_name)
  local technology = data.raw.technology and data.raw.technology[technology_name]
  if not technology or not data.raw.technology[prerequisite_name] then return end
  technology.prerequisites = technology.prerequisites or {}
  for _, prerequisite in ipairs(technology.prerequisites) do
    if prerequisite == prerequisite_name then return end
  end
  technology.prerequisites[#technology.prerequisites + 1] = prerequisite_name
end

-- Maintain the production era of each discipline. All science requirements are
-- added to FluxWorks technologies only, never to K2SO or vanilla research.
add_science("fw-cross-planetary-industrial-convergence", "kr-advanced-tech-card")
add_science("fw-planetary-convergence-science", "kr-matter-tech-card")
add_science("fw-shattered-expedition-planning", "kr-singularity-tech-card")
add_prerequisite("fw-origin-infrastructure", "kr-matter-cube")

-- Replace individual components in the completed six-ingredient FluxWorks
-- recipes. Do not append onto the global factory recipe catalog.
local function replace_part(recipe_name, original_name, new_name, amount)
  if not item_exists(new_name) then return end
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if not recipe then return end
  local function replace(ingredients)
    for _, ingredient in ipairs(ingredients or {}) do
      if (ingredient.type or "item") == "item"
        and (ingredient.name or ingredient[1]) == original_name then
        ingredient.name = new_name
        ingredient[1] = nil
        ingredient.amount = amount or ingredient.amount or ingredient[2] or 1
        ingredient[2] = nil
        ingredient.type = "item"
      end
    end
  end
  replace(recipe.ingredients)
  if recipe.normal then replace(recipe.normal.ingredients) end
  if recipe.expensive then replace(recipe.expensive.ingredients) end
end

replace_part("fw-quantum-computer", "fw-memory-die", "kr-ai-core", 1)
replace_part("fw-entanglement-core", "fw-em-core", "kr-imersium-plate", 2)
replace_part("fw-promethium-matrix", "fw-logic-matrix", "kr-imersite-crystal", 3)
replace_part("fw-rift-coupler", "fw-thermal-phase-gasket", "kr-charged-matter-stabilizer", 2)
replace_part("fw-origin-forge", "fusion-power-cell", "kr-matter-cube", 1)

-- A K2SO-specific alternative to Flux crystal stabilization. The ordinary
-- FluxWorks recipe remains available, so K2SO resources never become a forced
-- global substitute for Flux manufacturing.
if item_exists("kr-imersite-crystal") and data.raw.item["fw-stabilized-flux-crystal"]
  and data.raw.technology["fw-flux-synthesis"] then
  local name = "fw-k2so-imersite-resonance"
  if not data.raw.recipe[name] then
    data:extend({ {
      type = "recipe",
      name = name,
      icons = table.deepcopy(data.raw.item["fw-stabilized-flux-crystal"].icons),
      category = "fw-flux-synthesis",
      subgroup = "fw-flux-systems",
      order = "b[systems]-a[stabilized-flux-crystal]-z[imersite]",
      enabled = false,
      energy_required = 8,
      allow_productivity = true,
      ingredients = {
        { type = "item", name = "kr-imersite-crystal", amount = 2 },
        { type = "item", name = "fw-crystalised-flux", amount = 2 },
        { type = "item", name = "fw-flux-catalyst", amount = 1 },
        { type = "fluid", name = "fw-purple-flux", amount = 30 },
        { type = "fluid", name = "fw-yellow-flux", amount = 15 },
        { type = "fluid", name = "fw-red-flux", amount = 8 },
      },
      results = {
        { type = "item", name = "fw-stabilized-flux-crystal", amount = 3 },
      },
      main_product = "fw-stabilized-flux-crystal",
    } })
  end
  local effects = data.raw.technology["fw-flux-synthesis"].effects or {}
  data.raw.technology["fw-flux-synthesis"].effects = effects
  local found = false
  for _, effect in ipairs(effects) do
    if effect.type == "unlock-recipe" and effect.recipe == name then found = true end
  end
  if not found then effects[#effects + 1] = { type = "unlock-recipe", recipe = name } end
end
