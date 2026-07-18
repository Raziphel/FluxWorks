local function require_many(modules)
  for _, module_name in ipairs(modules) do
    require(module_name)
  end
end

require_many({
  "prototypes.updates.crusher-integration",
  "prototypes.updates.fulgora-scrap",
  "prototypes.updates.progression-gates",
  "prototypes.updates.powered-machines",
  "prototypes.updates.aai-industry",
})
