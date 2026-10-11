-- K2SO integration must remain strictly opt-in to the installed mod and
-- cannot replace K2SO's own research or basic recipes.
local Startup = require("prototypes.lib.startup-settings")
local enabled = mods["Krastorio2-spaced-out"] and Startup.enabled("fw-enable-k2so-integration", true)
-- Even with optional cross-mod content disabled, FluxWorks must consume the
-- K2SO material identities after K2SO hides the original items and fluids.
if mods["Krastorio2-spaced-out"] then
  local aliases = {
    oxygen = "kr-oxygen", hydrogen = "kr-hydrogen", chlorine = "kr-chlorine",
    sand = "kr-sand", glass = "kr-glass", silicon = "kr-silicon",
    lithium = "kr-lithium", ammonia = "kr-ammonia",
  }
  for recipe_name, candidate in pairs(data.raw.recipe or {}) do
    if recipe_name:sub(1, 3) == "fw-" then
      for _, ingredient in ipairs(candidate.ingredients or {}) do
        local name = ingredient.name or ingredient[1]
        local kind = ingredient.type == "fluid" and "fluid" or "item"
        local canonical = aliases[name]
        if canonical and data.raw[kind] and data.raw[kind][canonical] then
          error("K2SO material normalization missed " .. recipe_name .. ": " .. name)
        end
      end
    end
  end
  local glass_processing = data.raw.technology and data.raw.technology["glass-processing"]
  if glass_processing and data.raw.item["kr-sand"] then
    assert(glass_processing.research_trigger
      and glass_processing.research_trigger.item == "kr-sand",
      "Glass research trigger still targets hidden pre-K2SO sand")
  end
end
local recipe = data.raw.recipe and data.raw.recipe["fw-k2so-imersite-resonance"]
if not enabled then
  if recipe then error("K2SO-only Flux resonance recipe exists outside K2SO integration") end
  return
end

local function contains(entries, name)
  for _, entry in ipairs(entries or {}) do
    if (entry.name or entry[1]) == name then return true end
  end
  return false
end

local science = {
  { tech = "fw-cross-planetary-industrial-convergence", pack = "kr-advanced-tech-card" },
  { tech = "fw-planetary-convergence-science", pack = "kr-matter-tech-card" },
  { tech = "fw-shattered-expedition-planning", pack = "kr-singularity-tech-card" },
}
for _, entry in ipairs(science) do
  if (data.raw.tool and data.raw.tool[entry.pack]) or (data.raw.item and data.raw.item[entry.pack]) then
    local tech = assert(data.raw.technology[entry.tech], "Missing FluxWorks K2SO science consumer " .. entry.tech)
    assert(contains(tech.unit and tech.unit.ingredients, entry.pack),
      entry.tech .. " must consume K2SO science " .. entry.pack)
  end
end

local uses = {
  { "fw-quantum-computer", "kr-ai-core" },
  { "fw-entanglement-core", "kr-imersium-plate" },
  { "fw-promethium-matrix", "kr-imersite-crystal" },
  { "fw-rift-coupler", "kr-charged-matter-stabilizer" },
  { "fw-origin-forge", "kr-matter-cube" },
}
for _, entry in ipairs(uses) do
  if data.raw.item[entry[2]] then
    local r = assert(data.raw.recipe[entry[1]], "Missing integrated FluxWorks recipe " .. entry[1])
    assert(contains(r.ingredients, entry[2]), entry[1] .. " does not consume K2SO material " .. entry[2])
  end
end
if data.raw.technology["kr-matter-cube"] and data.raw.technology["fw-origin-infrastructure"] then
  local prerequisites = data.raw.technology["fw-origin-infrastructure"].prerequisites or {}
  local linked = false
  for _, prerequisite in ipairs(prerequisites) do
    if prerequisite == "kr-matter-cube" then linked = true end
  end
  assert(linked, "K2SO Matter Cube must precede FluxWorks Origin Infrastructure")
end
if recipe then
  assert(#(recipe.ingredients or {}) <= 6, "K2SO alternative Flux recipe is too complex")
  local tech = assert(data.raw.technology["fw-flux-synthesis"])
  local unlocked = false
  for _, effect in ipairs(tech.effects or {}) do
    if effect.type == "unlock-recipe" and effect.recipe == recipe.name then unlocked = true end
  end
  assert(unlocked, "K2SO alternate Flux synthesis has no research unlock")
end
