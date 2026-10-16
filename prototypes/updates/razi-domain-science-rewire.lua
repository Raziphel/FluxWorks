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
local packs = {
  ["fw-industrial-methods-science-pack"]=true,
  ["fw-systems-analysis-science-pack"]=true,
  ["fw-flux-theory-science-pack"]=true,
  ["fw-planetary-convergence-science-pack"]=true,
}
function M.apply()
  local removed=0
  for name,technology in pairs(data.raw.technology or {}) do
    if not projects[name] then
      -- The old standalone weave used Flux bottles across ordinary factory,
      -- Razi and optional native planet research. Keep them only in the four
      -- voluntary Industrial Project technologies.
      local unit=technology.unit
      if unit and unit.ingredients then
        for index=#unit.ingredients,1,-1 do
          local entry=unit.ingredients[index]
          if packs[entry.name or entry[1]] then
            table.remove(unit.ingredients,index)
            removed=removed+1
          end
        end
        if #unit.ingredients==0 then
          if data.raw.tool and data.raw.tool["automation-science-pack"] then
            unit.ingredients={{"automation-science-pack",1}}
          elseif data.raw.item and data.raw.item["automation-science-pack"] then
            unit.ingredients={{"automation-science-pack",1}}
          else
            error("FluxWorks removed the last science ingredient from "..name)
          end
        end
      end
    end
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
  log("FluxWorks extension: retired " .. removed .. " standalone science tolls")
  return removed
end
return M
