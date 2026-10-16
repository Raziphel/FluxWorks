-- Both standalone and Razi-hosted games must use the same non-invasive
-- specialist culture seeding. Never demand altered vanilla rock drops.
local enabled=not (settings.startup and settings.startup["fw-native-cultures"]
  and settings.startup["fw-native-cultures"].value==false)
if enabled then require("prototypes.validation.razi-bacteria-seeding") end
local rocks=data.raw["simple-entity"] or {}
for _,name in ipairs({"iron-stromatolite","copper-stromatolite"}) do
  local rock=rocks[name]
  assert(rock and rock.minable, "FluxWorks expected native Gleba source: "..name)
end
