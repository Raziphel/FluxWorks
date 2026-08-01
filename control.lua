local modules = {
  require("scripts.starting-wreckage"),
  require("scripts.rocket-remnants"),
  require("scripts.phase-vaults"),
  require("scripts.spectral-reservoirs"),
  require("scripts.rift-exchange"),
  require("scripts.shattered-planet"),
  require("scripts.true-ending"),
}

local Events = require("__razi_lib__/runtime/events")
local registry = Events.new()

for _, module in ipairs(modules) do
  registry:include(module)
end

registry:install()
