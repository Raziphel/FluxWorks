-- FluxWorks science is its own industrial research, never mandatory for
-- another mod's campaign. Use profile-specific data-stage contracts.
if require("prototypes.lib.companion-mode").razi_protocol then
  return require("prototypes.validation.razi-domain-science")
end
return require("prototypes.validation.independent-science")
