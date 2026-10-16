-- Razi owns chapter research. Keep all four Flux science unlock technologies
-- as opt-in lab specializations, but do not require one for ordinary machines.
-- Do not mutate any technology outside the FluxWorks namespace.
local M={}
local domain_unlocks = {
  ["fw-industrial-methods-science"]=true,
  ["fw-systems-analysis-science"]=true,
  ["fw-flux-theory-science"]=true,
  ["fw-planetary-convergence-science"]=true,
}
local projects = {
  ["fw-industrial-district-project"]=true,
  ["fw-autonomous-network-project"]=true,
  ["fw-spectrum-control-project"]=true,
  ["fw-convergence-directive-project"]=true,
}
function M.apply()
  local removed=0
  for name,technology in pairs(data.raw.technology or {}) do
    if name:sub(1,3)=="fw-" and not projects[name]
      and not domain_unlocks[name] and technology.prerequisites then
      for index=#technology.prerequisites,1,-1 do
        if domain_unlocks[technology.prerequisites[index]] then
          table.remove(technology.prerequisites,index)
          removed=removed+1
        end
      end
    end
  end
  log("FluxWorks extension: retired " .. removed .. " redundant standalone science prerequisites")
  return removed
end
return M
