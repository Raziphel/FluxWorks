-- Legacy entrypoint kept for third-party code requiring this module.
-- FluxWorks is standalone. The Razi Protocol integration must be executed
-- from Razi's later data stage, never from a FluxWorks dependency.
local M={}
function M.apply()
  if not (mods and mods["razi-protocol"]) then return 0 end
  log("FluxWorks: Razi integration is owned by Razi's compatibility stage")
  return 0
end
return M
