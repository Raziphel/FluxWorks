-- Verify FluxWorks' added Razi industrial alternatives after all source
-- integrations and Factorio 2.1 normalization. No per-tick or runtime overhead.
local setting = settings and settings.startup and settings.startup["fw-rp-industrial-depth"]
if setting and setting.value == "core" then return end

local processes = {
  "reactor-lining-recovery",
  "resonant-mesh-fabrication",
  "precision-seal-molding",
  "living-filtration",
  "chromatic-cermet-recasting",
  "regenerative-substrate-weaving",
  "thermal-buffer-lamination",
  "sensor-membrane-reclamation",
}
local source_machines = {}
for _, machine in pairs(data.raw["assembling-machine"] or {}) do
  for _, category in ipairs(machine.crafting_categories or {}) do
    source_machines[category] = true
  end
end
for _, process in ipairs(processes) do
  local name = "fw-industry-" .. process
  local recipe = data.raw.recipe and data.raw.recipe[name]
  -- Missing optional resources cause this particular alternative to be
  -- omitted. This is a supported condition, not a reason to abort Razi.
  if recipe then
    assert(recipe.enabled == false, "Optional industry started enabled: " .. name)
    assert(recipe.allow_productivity == false, "Industry must not multiply recovery: " .. name)
    assert(not recipe.auto_recycle, "Industry output must not auto-recycle: " .. name)
    assert(recipe.energy_required and recipe.energy_required > 0, "Invalid process duration: " .. name)
    assert(source_machines[recipe.category], "No buildable machine for industry recipe: " .. name)
    assert(recipe.icons and #recipe.icons >= 2, "Missing spectrum icon overlays: " .. name)
    local fluids = 0
    for _, ingredient in ipairs(recipe.ingredients or {}) do
      if ingredient.type == "fluid" then fluids = fluids + 1 end
      assert(ingredient.amount and ingredient.amount > 0, "Invalid industry input amount: " .. name)
    end
    assert(fluids <= 2, "Industry exceeds synthesis/fluid input capacity: " .. name)
    local main_product = recipe.main_product
    local found_output = false
    for _, result in ipairs(recipe.results or {}) do
      if result.name == main_product and (result.amount or 0) > 0 then
        found_output = true
      end
    end
    assert(found_output, "Industry has no valid main output: " .. name)
    local unlocks = 0
    for _, tech in pairs(data.raw.technology or {}) do
      for _, effect in ipairs(tech.effects or {}) do
        if effect.type == "unlock-recipe" and effect.recipe == name then
          unlocks = unlocks + 1
        end
      end
    end
    assert(unlocks == 1, "Industry must have exactly one research unlock: " .. name)
  end
end
