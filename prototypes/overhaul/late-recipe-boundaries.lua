-- Existing Total Raw / recycling guards ran before optional late factories
-- were registered. Apply the same policy to all FluxWorks-owned recipes now.
-- This also protects Razi-imported FluxWorks industrial alternatives.
local M={}
function M.apply()
  local touched=0
  for name,recipe in pairs(data.raw.recipe or {}) do
    if name:sub(1,3)=="fw-" then
      recipe.allow_decomposition=false
      if recipe.normal then recipe.normal.allow_decomposition=false end
      if recipe.expensive then recipe.expensive.allow_decomposition=false end
      touched=touched+1
    end
  end
  log("FluxWorks Reborn: completed Total Raw boundaries for "..touched.." owned recipes")
  return touched
end
return M
