local shared = require("prototypes.updates.recipe_tweaks.shared")

if not shared.enabled then
  return
end

for _, module_name in ipairs({
  "prototypes.updates.recipe_tweaks.general",
  "prototypes.updates.recipe_tweaks.science",
  "prototypes.updates.recipe_tweaks.advanced",
  "prototypes.updates.recipe_tweaks.infrastructure",
  "prototypes.updates.recipe_tweaks.catalog",
}) do
  require(module_name)(shared)
end
