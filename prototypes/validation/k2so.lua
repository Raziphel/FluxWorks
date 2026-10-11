-- K2SO integration must remain strictly opt-in to the installed mod and
-- cannot replace K2SO's own research or basic recipes.
local Startup = require("prototypes.lib.startup-settings")
local enabled = mods["Krastorio2-spaced-out"] and Startup.enabled("fw-enable-k2so-integration", true)
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
  if data.raw.item[entry.pack] then
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
if recipe then
  assert(#(recipe.ingredients or {}) <= 6, "K2SO alternative Flux recipe is too complex")
  local tech = assert(data.raw.technology["fw-flux-synthesis"])
  local unlocked = false
  for _, effect in ipairs(tech.effects or {}) do
    if effect.type == "unlock-recipe" and effect.recipe == recipe.name then unlocked = true end
  end
  assert(unlocked, "K2SO alternate Flux synthesis has no research unlock")
end
