dofile("tests/lua/support/razi_lib_bootstrap.lua").install()
local raw={["bool-setting"]={},["string-setting"]={}}
_G.data={raw=raw}
function data:extend(values)
  for _,proto in ipairs(values) do
    assert(not raw[proto.type][proto.name],"Duplicate setting "..proto.name)
    raw[proto.type][proto.name]=proto
  end
end
dofile("settings.lua")
assert(raw["bool-setting"]["fw-rp-convergence-universal"].default_value==true)
assert(raw["string-setting"]["fw-rp-industrial-depth"].default_value=="expanded")
assert(raw["bool-setting"]["fw-rp-galactic-industry"].default_value==true)
assert(raw["bool-setting"]["fw-starting-crash-loadout"]==nil)
assert(raw["string-setting"]["fw-starting-crash-loadout"].hidden==true)
assert(raw["bool-setting"]["fw-worldgen-enable-standalone-ores"].hidden==true)
assert(raw["string-setting"]["fw-rp-project-research"].allowed_values[3]=="monumental")
print("RaziLib factory settings prototypes and legacy hidden IDs preserved")
