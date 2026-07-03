local shared = require("prototypes.updates.recipe_tweaks.shared")

if not shared.enabled then
  return
end

for _, module_name in ipairs({
  "prototypes.updates.recipe_tweaks.early_integration",
  "prototypes.updates.recipe_tweaks.science_and_relief",
  "prototypes.updates.recipe_tweaks.high_tier",
  "prototypes.updates.recipe_tweaks.core_replacements",
  "prototypes.updates.recipe_tweaks.final_cleanup",
}) do
  require(module_name)(shared)
end
