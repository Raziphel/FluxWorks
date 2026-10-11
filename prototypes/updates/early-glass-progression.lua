-- The legacy mode moved Space Age's Crusher to Nauvis and made it the
-- gateway to basic materials. In expansion mode, keep the native Crusher
-- on its intended planet and allow FluxWorks-owned mineral processes to use
-- the ordinary manufacturing chain.
local Startup = require("prototypes.lib.startup-settings")
if not Startup.enabled("fw-enable-early-industry-overhaul", false) then
  local comminution = data.raw.technology and data.raw.technology["fw-comminution"]
  if comminution then
    for index = #(comminution.effects or {}), 1, -1 do
      local effect = comminution.effects[index]
      if effect.type == "unlock-recipe" and effect.recipe == "crusher" then
        table.remove(comminution.effects, index)
      end
    end
  end

  -- A short, red-science FluxWorks branch rather than an early Crusher trap.
  for _, name in ipairs({ "sand-processing", "glass-processing" }) do
    local technology = data.raw.technology and data.raw.technology[name]
    if technology then
      technology.research_trigger = nil
      technology.unit = {
        count = 20,
        time = 15,
        ingredients = { { "automation-science-pack", 1 } },
      }
      technology.essential = false
      technology.prerequisites = {
        name == "sand-processing" and "fw-comminution" or "sand-processing",
      }
    end
  end

  -- Restrict the recipe edits to FluxWorks-owned production. Neither the base
  -- Crusher nor existing third-party crushers need a different recipe.
  local sand = data.raw.recipe and data.raw.recipe.sand
  if sand then sand.category = "crafting"; sand.categories = nil end
  for name, recipe in pairs(data.raw.recipe or {}) do
    if name:sub(1, 3) == "fw-"
      and ((recipe.categories and recipe.categories[1]) or recipe.category) == "basic-crushing" then
      recipe.category = "crafting"
      recipe.categories = nil
    end
  end
  return
end

-- Apply this after recipe and progression reconciliation. Glass belongs in the
-- Lab recipe, while Sand belongs in the Crusher, so both machine and material
-- must be obtainable through pre-laboratory action triggers.
local sand_recipe = data.raw.recipe and data.raw.recipe.sand
if sand_recipe then sand_recipe.category = "basic-crushing" end

local comminution = data.raw.technology and data.raw.technology["fw-comminution"]
if comminution then
  comminution.prerequisites = nil
  comminution.unit = nil
  comminution.research_trigger = { type = "mine-entity", entities = { "big-rock" }, count = 5 }
  comminution.essential = true
end

local sand_processing = data.raw.technology and data.raw.technology["sand-processing"]
if sand_processing then
  sand_processing.prerequisites = { "fw-comminution" }
  sand_processing.unit = nil
  sand_processing.research_trigger = { type = "craft-item", item = "crusher" }
  sand_processing.essential = true
end

local glass_processing = data.raw.technology and data.raw.technology["glass-processing"]
if glass_processing then
  glass_processing.prerequisites = { "sand-processing" }
  glass_processing.unit = nil
  glass_processing.research_trigger = { type = "craft-item", item = "sand", count = 4 }
  glass_processing.essential = true
end
