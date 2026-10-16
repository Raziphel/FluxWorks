-- No Factorio engine and no RaziLib shim needed: test Lua runtime command API.
local emitted={}
local player={
  valid=true,
  force={technologies={
    ["fw-industrial-program-chemical"]={researched=true},
    ["fw-industrial-program-thermal"]={researched=false},
    ["fw-industrial-program-biological"]={researched=true},
    ["fw-industrial-program-phase"]={researched=false},
    ["fw-four-works-charter"]={researched=false},
  }}
}
function player.print(message) emitted[#emitted+1]=message end
_G.game={
  get_player=function(index) assert(index==1);return player end,
  print=function(message) emitted[#emitted+1]=message end,
}
_G.script={active_mods={}}
_G.commands={commands={}}
function commands.add_command(name,help,callback)
  assert(not commands.commands[name],"Command registered twice")
  commands.commands[name]={help=help,run=callback}
end
local guide=dofile("scripts/fluxworks-guide.lua")
assert(guide.register())
assert(not guide.register(),"Command must register at most once per Lua state")
local callback=commands.commands["fw-guide"].run
local function seen(key)
  for _,line in ipairs(emitted) do
    if line[1]==key then return true end
  end
  return false
end
callback({player_index=1,parameter=""})
assert(seen("fw-guide.four") and not seen("fw-guide.razi"))
emitted={}
callback({player_index=1,parameter="status"})
assert(seen("fw-guide.progress") and seen("fw-guide.work-status"))
assert(#emitted>=7 and not seen("fw-guide.foundries"))
emitted={}
callback({player_index=1,parameter="atlas"})
assert(seen("fw-guide.no-razi"))
script.active_mods["razi-protocol"]="2.1.0"
player.force.technologies["fw-foundry-commission-calidus"]={researched=true}
player.force.technologies["fw-foundry-commission-nyxaris"]={researched=false}
player.force.technologies["fw-foundry-atlas"]={researched=false}
emitted={}
callback({player_index=1,parameter="status"})
assert(seen("fw-guide.foundries"))
emitted={}
callback({player_index=1,parameter="atlas"})
assert(seen("fw-guide.atlas") and seen("fw-guide.atlas-locked"))
emitted={}
callback({parameter="status"})
assert(seen("fw-guide.player-only"),"Server console without force must be safe")
emitted={}
callback({player_index=1,parameter="not-a-command"})
assert(seen("fw-guide.usage"))
print("FluxWorks field manual: no-Razi, Razi, 4 program states, atlas and console guard pass")
