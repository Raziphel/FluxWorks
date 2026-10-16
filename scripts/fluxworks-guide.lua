-- FluxWorks: an optional, player-requested field manual.
-- A command, not a periodic event, GUI overlay, or campaign controller.
local M={}
local commands_table={"help","status","atlas"}
local disciplines={
  {"chemical","fw-industrial-program-chemical"},
  {"thermal","fw-industrial-program-thermal"},
  {"biological","fw-industrial-program-biological"},
  {"phase","fw-industrial-program-phase"},
}
local systems={
  "calidus","solaris","nyxaris","vibrant","vespera","beetlejuice","umbra"
}
local function emit(player,key,...)
  local line={key,...}
  if player and player.valid then player.print(line)
  else game.print(line) end
end
local function researched(force,name)
  local technology=force.technologies[name]
  return technology and technology.researched
end
local function on_command(command)
  local player=command.player_index and game.get_player(command.player_index)
  local force=player and player.valid and player.force
  local action=(command.parameter or ""):lower():match("^%s*(.-)%s*$")
  if action=="" then action="help" end
  local valid=false
  for _,v in ipairs(commands_table) do if action==v then valid=true end end
  if not valid then
    emit(player,"fw-guide.usage")
    return
  end
  emit(player,"fw-guide.title")
  if action=="help" then
    emit(player,"fw-guide.intro")
    emit(player,"fw-guide.four")
    emit(player,"fw-guide.next")
    if game.active_mods and game.active_mods["razi-protocol"] then
      emit(player,"fw-guide.razi")
    end
  elseif action=="status" then
    if not force then
      emit(player,"fw-guide.player-only")
      return
    end
    local mastered=0
    for _,record in ipairs(disciplines) do
      if researched(force,record[2]) then mastered=mastered+1 end
    end
    emit(player,"fw-guide.progress",mastered,#disciplines)
    local charter=force.technologies["fw-four-works-charter"]
    if charter then
      emit(player,charter.researched and "fw-guide.charter-complete" or
        "fw-guide.charter-remaining")
    else
      emit(player,"fw-guide.charter-inactive")
    end
    if game.active_mods and game.active_mods["razi-protocol"] then
      local commissions,completed=0,0
      for _,system in ipairs(systems) do
        local tech=force.technologies["fw-foundry-commission-"..system]
        if tech then
          commissions=commissions+1
          if tech.researched then completed=completed+1 end
        end
      end
      emit(player,"fw-guide.foundries",completed,commissions)
    end
  elseif action=="atlas" then
    if not (game.active_mods and game.active_mods["razi-protocol"]) then
      emit(player,"fw-guide.no-razi")
      return
    end
    emit(player,"fw-guide.atlas")
    if force then
      local atlas=force.technologies["fw-foundry-atlas"]
      if atlas then
        emit(player,atlas.researched and "fw-guide.atlas-complete" or
          "fw-guide.atlas-locked")
      else
        emit(player,"fw-guide.atlas-unavailable")
      end
    end
  end
end
function M.register()
  if not commands or not commands.add_command then return false end
  if commands.commands and commands.commands["fw-guide"] then return false end
  commands.add_command("fw-guide",{"fw-guide.command-help"},on_command)
  return true
end
M.handler=on_command
return M
