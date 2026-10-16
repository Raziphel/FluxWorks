-- Razi-hosted science rules are verified by razi-domain-science.lua.
if require("prototypes.lib.companion-mode").razi_protocol then
  require("prototypes.validation.razi-domain-science")
  return
end

-- Production research must no longer require the two early optional
-- discipline packs. They belong exclusively to opt-in factory upgrade programs.
local Startup = require("prototypes.lib.startup-settings")
if Startup.enabled("fw-enable-early-domain-science-gates", false) then return end

local programs = {
  ["fw-industrial-yield"] = "fw-industrial-methods-science-pack",
  ["fw-material-handling"] = "fw-industrial-methods-science-pack",
  ["fw-autonomous-logistics"] = "fw-systems-analysis-science-pack",
  ["fw-rail-network-control"] = "fw-systems-analysis-science-pack",
  ["fw-research-methodology"] = "fw-systems-analysis-science-pack",
}
local unlocked_by = {
  ["fw-industrial-methods-science-pack"] = "fw-industrial-methods-science",
  ["fw-systems-analysis-science-pack"] = "fw-systems-analysis-science",
}
local function entry_name(entry)
  return type(entry) == "table" and (entry.name or entry[1]) or entry
end
local function contains(entries, value)
  for _, entry in ipairs(entries or {}) do
    if entry_name(entry) == value then return true end
  end
  return false
end
local function program_pack(name)
  for stem, pack in pairs(programs) do
    for tier = 1, 3 do
      if name == stem .. "-" .. tier then return pack, tier end
    end
  end
  return nil, nil
end

local technologies = data.raw.technology or {}
for name, tech in pairs(technologies) do
  local expected_pack, tier = program_pack(name)
  if name:sub(1, 3) == "fw-" then
    for pack, unlock in pairs(unlocked_by) do
      local consumes = contains(tech.unit and tech.unit.ingredients, pack)
      if consumes ~= (pack == expected_pack) then
        error("Optional science scope violation: " .. name .. " / " .. pack)
      end
      if expected_pack == pack and tier == 1 and not contains(tech.prerequisites, unlock) then
        error("First upgrade tier needs its optional science milestone: " .. name)
      end
      if not (expected_pack == pack and tier == 1)
        and contains(tech.prerequisites, unlock) then
        error("Mandatory FluxWorks progression still requires optional science: " .. name)
      end
    end
  end
end

-- Never weave optional factory-upgrade science into the native/K2SO tree.
for name, tech in pairs(technologies) do
  if name:sub(1, 3) ~= "fw-" then
    for pack in pairs(unlocked_by) do
      if contains(tech.unit and tech.unit.ingredients, pack) then
        error("Unrelated research was made dependent on optional FluxWorks science: " .. name)
      end
    end
  end
end

-- The optional science recipes should be compact yet profitable.
for pack in pairs(unlocked_by) do
  local recipe = assert(data.raw.recipe and data.raw.recipe[pack],
    "Optional science pack recipe is missing: " .. pack)
  if #((recipe.ingredients) or {}) ~= 3 then
    error("Optional factory-upgrade science should have exactly three ingredients: " .. pack)
  end
  local output = recipe.results and recipe.results[1]
  if not output or entry_name(output) ~= pack or output.amount ~= 4 then
    error("Optional factory-upgrade science should produce four packs per craft: " .. pack)
  end
end

-- Flux Theory and Planetary Convergence deliberately remain major milestones.
for _, tech_name in ipairs({
  "fw-flux-synthesis", "fw-rift-harmonics", "fw-shattered-expedition-planning",
}) do
  local technology = assert(technologies[tech_name], "Missing late FluxWorks milestone: " .. tech_name)
  local expected = tech_name == "fw-shattered-expedition-planning"
    and "fw-planetary-convergence-science-pack"
    or "fw-flux-theory-science-pack"
  if not contains(technology.unit and technology.unit.ingredients, expected) then
    error("Late FluxWorks science was unintentionally made optional: " .. tech_name)
  end
end
