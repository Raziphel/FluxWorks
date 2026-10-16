-- FluxWorks-only art policy on top of RaziLib's 1.2.0 layered-icon API.
-- Never mutate source-mod icons and never change prototype IDs.
local Icons = require("__razi_lib__/lib/icons")
local M = {}
local badge_prefix="__FluxWorksAssets__/graphics/icons/upgrade-badges/"
local spectrum_prefix="__FluxWorksAssets__/graphics/icons/fluids/flux-"
local world_prefix="__FluxWorksAssets__/graphics/icons/system-badges/fw-"
local systems={
  calidus=true,solaris=true,nyxaris=true,vibrant=true,
  vespera=true,beetlejuice=true,umbra=true,["deep-space"]=true
}
local function base(prototype)
  if not prototype then return nil end
  local layers=Icons.from_prototype(prototype)
  return #layers>0 and layers or nil
end
function M.spectrum(product, colour, partner, layout)
  local layers=base(product)
  if not layers then return nil end
  layout=layout or "galaxy"
  local galaxy=layout=="galaxy"
  local y=galaxy and 16 or 14
  local x=galaxy and (partner and -13 or 14) or (partner and -12 or 15)
  local other_x=galaxy and 13 or 12
  local scale=galaxy and 0.065 or 0.07
  layers[#layers+1]=Icons.layer(spectrum_prefix..colour..".png",256,
    {scale=scale,shift={x,y}})
  if partner then
    layers[#layers+1]=Icons.layer(spectrum_prefix..partner..".png",256,
      {scale=scale,shift={other_x,y}})
  end
  return layers
end
function M.galaxy(product,colour,partner,system)
  local layers=M.spectrum(product,colour,partner,"galaxy")
  if layers and systems[system] then
    layers[#layers+1]=Icons.layer(world_prefix..system.."-industry.png",128,
      {scale=0.12,shift={-17,-16}})
  end
  return layers
end
function M.project(product,badge)
  local layers=base(product)
  if not layers then return nil end
  -- A Convergence upgrade replaces a Precision badge rather than stacking.
  for i=#layers,1,-1 do
    local path=layers[i].icon or ""
    if path:sub(1,#badge_prefix)==badge_prefix then table.remove(layers,i) end
  end
  layers[#layers+1]=Icons.layer(badge_prefix.."fw-"..badge..".png",128,
    {scale=0.16,shift={17,17}})
  return layers
end
return M
