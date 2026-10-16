-- Real RaziLib 1.2.0 runtime API contract; no Factorio engine required.
dofile("tests/lua/support/razi_lib_bootstrap.lua").install()
local Storage=require("__razi_lib__/runtime/storage")
local Remote=require("__razi_lib__/runtime/remote")
_G.storage={
  platform_type_whitelist={player={custom=true},alpha={["special-platform"]=true}},
  phase_vault_units={[101]={name="legacy-vault"}},
  spectral_reservoir_units={[102]={name="legacy-reservoir"}},
  rift_exchange={[103]={name="legacy-rift"}},
}
local vaults=Storage.namespace("phase_vault_units",{})
assert(vaults:ensure()[101].name=="legacy-vault")
local reservoirs=Storage.namespace("spectral_reservoir_units",{})
assert(reservoirs:ensure()[102].name=="legacy-reservoir")
local exchanges=Storage.namespace("rift_exchange",{})
assert(exchanges:ensure()[103].name=="legacy-rift")
local extractors=Storage.namespace("flux_extractors",{})
assert(next(extractors:ensure())==nil)
extractors:set(1,{name="extractor"})
assert(extractors:get(1).name=="extractor")
extractors:reset()
assert(next(storage.flux_extractors)==nil)
_G.remote={interfaces={}}
function remote.add_interface(name,callbacks)
  assert(not remote.interfaces[name],"Remote was registered twice")
  remote.interfaces[name]=callbacks
end
function remote.call(interface,method,...)
  return remote.interfaces[interface][method](...)
end
_G.commands={commands={}}
function commands.add_command(name,description,callback)
  assert(not commands.commands[name])
  commands.commands[name]={help=description,callback=callback}
end
local rock=dofile("scripts/rocket-remnants.lua")
assert(Remote.has("rocket-reusability"))
rock.on_init()
assert(storage.platform_type_whitelist.player.custom==true)
assert(storage.platform_type_whitelist.alpha["special-platform"]==true)
assert(Remote.require("rocket-reusability","is_whitelisted","space-platform-starter-pack"))
Remote.require("rocket-reusability","add_whitelist","extra-platform","alpha")
assert(Remote.require("rocket-reusability","is_whitelisted","extra-platform","alpha"))
rock.on_configuration_changed()
assert(Remote.require("rocket-reusability","is_whitelisted","extra-platform","alpha"))
dofile("scripts/rocket-remnants.lua")
assert(Remote.has("rocket-reusability"))
commands.commands["reset-whitelist"].callback()
assert(storage.platform_type_whitelist.player["space-platform-starter-pack"])
assert(storage.platform_type_whitelist.alpha==nil)
assert(storage.phase_vault_units[101].name=="legacy-vault")
assert(storage.spectral_reservoir_units[102].name=="legacy-reservoir")
assert(storage.rift_exchange[103].name=="legacy-rift")
print("Genuine RaziLib runtime: saved state, namespaces, remote idempotence and reset OK")
