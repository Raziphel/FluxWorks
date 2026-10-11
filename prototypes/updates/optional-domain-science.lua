-- Keep the two early FluxWorks science bottles as optional upgrade-program
-- research rather than mandatory tolls across the industrial tech tree.
-- Late Flux Theory and Planetary Convergence remain full progression gates.
local Startup = require("prototypes.lib.startup-settings")
if Startup.enabled("fw-enable-early-domain-science-gates", false) then return end

local early_packs = {
  ["fw-industrial-methods-science-pack"] = true,
  ["fw-systems-analysis-science-pack"] = true,
}
local early_unlocks = {
  ["fw-industrial-methods-science"] = true,
  ["fw-systems-analysis-science"] = true,
}
local optional_programs = {
  ["fw-industrial-yield"] = "fw-industrial-methods-science-pack",
  ["fw-material-handling"] = "fw-industrial-methods-science-pack",
  ["fw-autonomous-logistics"] = "fw-systems-analysis-science-pack",
  ["fw-rail-network-control"] = "fw-systems-analysis-science-pack",
  ["fw-research-methodology"] = "fw-systems-analysis-science-pack",
}

local function program_pack(name)
  for stem, pack in pairs(optional_programs) do
    if name == stem .. "-1" or name == stem .. "-2" or name == stem .. "-3" then
      return pack, name == stem .. "-1"
    end
  end
  return nil, false
end

local function entry_name(entry)
  return type(entry) == "table" and (entry.name or entry[1]) or entry
end

local technologies = data.raw.technology or {}
for technology_name, technology in pairs(technologies) do
  if technology_name:sub(1, 3) == "fw-" then
    local permitted_pack, first_tier = program_pack(technology_name)
    local unit = technology.unit
    if unit and unit.ingredients then
      for index = #unit.ingredients, 1, -1 do
        local name = entry_name(unit.ingredients[index])
        if early_packs[name] and name ~= permitted_pack then
          table.remove(unit.ingredients, index)
        end
      end
      -- Do not silently create a zero-science research node. Failing here
      -- identifies a technology requiring explicit rebalance.
      if #unit.ingredients == 0 then
        error("FluxWorks optional science conversion left no research packs on " .. technology_name)
      end
    end

    local prerequisites = technology.prerequisites
    if prerequisites then
      for index = #prerequisites, 1, -1 do
        local name = prerequisites[index]
        if early_unlocks[name] and (not permitted_pack or not first_tier) then
          table.remove(prerequisites, index)
        end
      end
    end

    -- Make each optional program tier-1 explicitly depend on the recipe
    -- unlock for its science bottle. Later tiers chain through the first.
    if first_tier then
      local unlock = permitted_pack == "fw-industrial-methods-science-pack"
        and "fw-industrial-methods-science"
        or "fw-systems-analysis-science"
      technology.prerequisites = technology.prerequisites or {}
      local found = false
      for _, prerequisite in ipairs(technology.prerequisites) do
        if prerequisite == unlock then found = true end
      end
      if not found then
        technology.prerequisites[#technology.prerequisites + 1] = unlock
      end
    end
  end
end
