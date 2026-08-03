for simulation_name, simulation in pairs(require("prototypes.menu-simulations")) do
  local init = simulation.init or ""
  if not string.find(init, "exit_remote_view", 1, true) then
    error("FluxWorks menu simulation does not clear persisted remote view: " .. simulation_name)
  end
  if not string.find(init, "disable_space_map = true", 1, true) then
    error("FluxWorks menu simulation does not suppress the surface menu: " .. simulation_name)
  end
end
