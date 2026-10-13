-- The campaign owns discovery, routes, victory, and global balancing.
-- Keep FluxWorks focused on manufacturing when Razi Protocol is installed.
-- Detect the mod by its real Factorio ID; Razi's optional dependency on
-- FluxWorks provides the required data-stage ordering without a cycle.
local M = {
  razi_protocol = mods ~= nil and mods["razi-protocol"] ~= nil,
}
return M
