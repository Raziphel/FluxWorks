-- FluxWorks 0.3 is an industrial extension. Razi Protocol owns the campaign,
-- world startup, Shattered Planet and the only victory handler.
local Events = require("__razi_lib__/runtime/events")
local registry = Events.new()
for _, module in ipairs({
  "scripts.rocket-remnants",
  "scripts.phase-vaults",
  "scripts.spectral-reservoirs",
  "scripts.flux-extractor",
  "scripts.rift-exchange",
}) do
  registry:include(require(module))
end
registry:install()
