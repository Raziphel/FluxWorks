-- Offline-focused-profile contract, independent of the installed Factorio binary.
local function read(path)
  local file=assert(io.open(path,"rb"))
  local text=file:read("*a");file:close();return text
end
local code=read("prototypes/focused/prune.lua")
local recipe_count=0
for _ in code:gmatch('{id="fw%-') do recipe_count=recipe_count+1 end
-- Includes exactly 25 manufacturing profiles and seven tech definitions.
assert(recipe_count==32,recipe_count)
assert(code:find("no_custom_patches()",1,true))
assert(code:find("proto.autoplace=nil",1,true))
assert(code:find("proto.hidden=true",1,true))
assert(code:find("tech.hidden=true",1,true))
assert(code:find('"fw-salvaged-flux"',1,true))
assert(code:find('"stone",8',1,true))
assert(code:find('raw("technology"',1,true)~=nil)
local entry=read("data-final-fixes.lua")
assert(entry:find('require("prototypes.focused.prune").apply()',1,true))
local validation=read("prototypes/validation/init.lua")
assert(validation:find("prototypes.validation.focused-core",1,true))
local setting=read("settings.lua")
assert(setting:find('"fw-design-profile","focused"',1,true))
assert(setting:find('"fw-native-cultures",false',1,true))
assert(setting:find('"fw-world-policy","off"',1,true))
assert(setting:find('"fw-rp-galactic-industry", false',1,true))
assert(setting:find('"fw-rp-k2so-galaxy-industry", false',1,true))
assert(setting:find('"fw-rp-interplanetary-factories", false',1,true))
print("Focused FluxWorks: 25 core recipes, seven research tiers and no default ore patches")
