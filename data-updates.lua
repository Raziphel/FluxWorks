local function require_many(modules)
  for _, module_name in ipairs(modules) do
    require(module_name)
  end
end

require_many({
  "prototypes.updates.crusher-integration",
  "prototypes.updates.fulgora-scrap",
  "prototypes.updates.planetary-self-sufficiency",
  "prototypes.updates.progression-gates",
  "prototypes.updates.powered-machines",
})

-- Establish AAI substitutions before final-stage recipe classification. The
-- integration is deliberately callable again after other mods finish rewriting
-- recipes in data-final-fixes.
require("prototypes.updates.aai-industry")()
