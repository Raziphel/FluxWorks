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
