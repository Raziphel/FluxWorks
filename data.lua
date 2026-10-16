-- Deliberately small, standalone registry. Nothing from the former ore,
-- metallurgy, Shattered Planet, or global recipe overhaul survives here.
require("prototypes.fluids.fluids")
require("prototypes.resources.flux-rift-resource")
require("prototypes.items.flux-systems")
require("prototypes.overhaul.spectrum-materials")
require("prototypes.entities.flux-condenser")
require("prototypes.entities.flux-processing-machines")
require("prototypes.technology.flux-systems")
for name,fluid in pairs(data.raw.fluid or {}) do
  if name:sub(1,3)=="fw-" then fluid.auto_barrel=false end
end
