-- Run source-owned Razi integration after FluxWorks finishes the prototype graph.
-- Factorio's required dependency puts Razi before FluxWorks, not vice versa.
local M = {}
local modules = {
  "__razi-protocol__.prototypes.compat.fluxworks",
  "__razi-protocol__.prototypes.compat.fluxworks_specializations",
  "__razi-protocol__.prototypes.compat.fluxworks_industry_exchanges",
  "__razi-protocol__.prototypes.compat.fluxworks_research_clarity",
  "__razi-protocol__.prototypes.compat.fluxworks_machine_pacing",
}
function M.apply()
  if not (mods and mods["razi-protocol"]) then
    error("FluxWorks 0.3 requires the Razi Protocol host")
  end
  local executed = 0
  for _, path in ipairs(modules) do
    local integrator = require(path)
    if not (integrator and type(integrator.data_final_fixes) == "function") then
      error("Missing Razi industrial adapter: " .. path)
    end
    integrator.data_final_fixes()
    executed = executed + 1
  end
  log("FluxWorks Razi extension: " .. executed .. " source-owned integration passes")
end
return M
