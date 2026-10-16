-- Two user-facing options. No global overhaul controls or legacy modes.
local RaziSettings=require("__razi_lib__/lib/settings")
data:extend({
  RaziSettings.bool("fw-four-works-charter","startup",true,"a[works]"),
  RaziSettings.bool("fw-razi-seven-foundries","startup",true,"b[foundries]")
})
