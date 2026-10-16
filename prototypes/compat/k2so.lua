-- Additive Krastorio 2 Spaced Out integration. Do not replace Krastorio 2's
-- recipes or science tree; reuse its late materials in FluxWorks-owned content.
local RaziSettings=require("__razi_lib__/lib/settings")
local Technology=require("__razi_lib__/lib/technology")
local Graph=require("__razi_lib__/lib/technology_graph")
local Recipe=require("__razi_lib__/lib/recipe")
local Icons=require("__razi_lib__/lib/icons")
if not mods["Krastorio2-spaced-out"] or not RaziSettings.enabled("fw-enable-k2so-integration", true) then
  return
end

local function item_exists(name)
  return data.raw.item and data.raw.item[name]
end

local function add_science(tech_name,science_name)
  local tech=Technology.optional(tech_name)
  if tech and tech.unit
    and ((data.raw.tool and data.raw.tool[science_name]) or item_exists(science_name)) then
    tech:add_pack(science_name,1)
  end
end
local function add_prerequisite(tech_name,parent)
  local technologies=data.raw.technology or {}
  if technologies[parent] and technologies[tech_name]
    and not Graph.reaches(technologies,parent,tech_name) then
    Technology.get(tech_name):add_prerequisite(parent)
  end
end

-- Maintain the production era of each discipline. All science requirements are
-- added to FluxWorks technologies only, never to K2SO or vanilla research.
add_science("fw-cross-planetary-industrial-convergence", "kr-advanced-tech-card")
add_science("fw-planetary-convergence-science", "kr-matter-tech-card")
add_science("fw-shattered-expedition-planning", "kr-singularity-tech-card")
add_prerequisite("fw-origin-infrastructure", "kr-matter-cube")

-- Replace individual components in the completed six-ingredient FluxWorks
-- recipes. Do not append onto the global factory recipe catalog.
local function replace_part(recipe_name,original_name,new_name,amount)
  if not item_exists(new_name) then return end
  local recipe=Recipe.optional(recipe_name)
  if not recipe then return end
  -- Preserve original ingredient position and legacy variants. RaziLib's
  -- each_variant walks all three without a home-grown variant loop.
  recipe:each_variant(function(variant)
    for _,ingredient in ipairs(variant.ingredients or {}) do
      if (ingredient.type or "item")=="item"
        and (ingredient.name or ingredient[1])==original_name then
        ingredient.name=new_name
        ingredient[1]=nil
        ingredient.amount=amount or ingredient.amount or ingredient[2] or 1
        ingredient[2]=nil
        ingredient.type="item"
      end
    end
  end)
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
  if not data.raw.recipe[name] and #Icons.from_prototype(data.raw.item["fw-stabilized-flux-crystal"])>0 then
    data:extend({ {
      type = "recipe",
      name = name,
      icons = Icons.from_prototype(data.raw.item["fw-stabilized-flux-crystal"]),
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
      },
      results = {
        { type = "item", name = "fw-stabilized-flux-crystal", amount = 3 },
      },
      main_product = "fw-stabilized-flux-crystal",
    } })
  end
  if data.raw.recipe[name] then
    Technology.get("fw-flux-synthesis"):unlock(name)
  end
end
