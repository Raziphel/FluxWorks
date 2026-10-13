local modules = {
  require("scripts.rocket-remnants"),
  require("scripts.phase-vaults"),
  require("scripts.spectral-reservoirs"),
  require("scripts.flux-extractor"),
  require("scripts.rift-exchange"),
}

-- Razi Protocol owns the starting scenario, remote frontier, and victory.
-- Standalone FluxWorks continues to register its original campaign handlers.
if not (script.active_mods and script.active_mods["razi-protocol"]) then
  modules[#modules + 1] = require("scripts.starting-wreckage")
  modules[#modules + 1] = require("scripts.shattered-planet")
  modules[#modules + 1] = require("scripts.shattered-asteroids")
  modules[#modules + 1] = require("scripts.true-ending")
end

local Events = require("__razi_lib__/runtime/events")
local registry = Events.new()

for _, module in ipairs(modules) do
  registry:include(module)
end

registry:install()
