-- Focused industry only registers the universal Flux extractor and the
-- on-demand field manual. Old save-facing storage and rocket handlers remain
-- opt-in under the explicitly named Legacy profile.
local Events=require("__razi_lib__/runtime/events")
local profile=(settings.startup or {})["fw-design-profile"]
local legacy=profile and profile.value=="legacy"
local registry=Events.new()
registry:include(require("scripts.flux-extractor"))
if legacy then
  for _,module in ipairs({
    "scripts.rocket-remnants","scripts.phase-vaults",
    "scripts.spectral-reservoirs","scripts.rift-exchange",
  }) do registry:include(require(module)) end
end
registry:install()
require("scripts.fluxworks-guide").register()
