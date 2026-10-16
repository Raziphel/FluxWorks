-- Independent FluxWorks runtime: industry utilities without a campaign host.
-- All persistent state remains in the existing RaziLib namespaces.
local Events=require("__razi_lib__/runtime/events")
local registry=Events.new()
for _,module in ipairs({
  "scripts.rocket-remnants",
  "scripts.phase-vaults",
  "scripts.spectral-reservoirs",
  "scripts.flux-extractor",
  "scripts.rift-exchange",
}) do registry:include(require(module)) end
registry:install()
-- On-demand progress help; does not register tick handlers or UI polling.
require("scripts.fluxworks-guide").register()
