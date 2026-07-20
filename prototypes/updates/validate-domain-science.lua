local domains = require("prototypes.updates.domain-science-integration")

local function contains(entries, name)
  for _, entry in ipairs(entries or {}) do
    local entry_name = type(entry) == "table" and (entry.name or entry[1]) or entry
    if entry_name == name then
      return true
    end
  end
  return false
end

for _, domain in ipairs(domains) do
  local pack = data.raw.tool and data.raw.tool[domain.pack]
  local recipe = data.raw.recipe and data.raw.recipe[domain.pack]
  local unlock = data.raw.technology and data.raw.technology[domain.technology]
  if not (pack and recipe and unlock) then
    error("FluxWorks domain science is missing a pack, recipe, or unlock technology: " .. domain.pack)
  end

  local expected_icon = "__FluxWorksAssets__/graphics/icons/science/" .. domain.pack .. ".png"
  if pack.icon ~= expected_icon or pack.icon_size ~= 64 or pack.icons then
    error("FluxWorks science pack must use its own clean, single-layer bottle icon: " .. domain.pack)
  end

  if #domain.consumers < 15 then
    error("FluxWorks domain science needs broad research utility, not a token consumer list: " .. domain.pack)
  end
  if #(domain.external_consumers or {}) < 15 then
    error("FluxWorks domain science must be woven into the wider technology tree: " .. domain.pack)
  end

  local unlocks_recipe = false
  for _, effect in ipairs(unlock.effects or {}) do
    if effect.type == "unlock-recipe" and effect.recipe == domain.pack then
      unlocks_recipe = true
      break
    end
  end
  if not unlocks_recipe then
    error(domain.technology .. " does not unlock " .. domain.pack)
  end

  for lab_name, lab in pairs(data.raw.lab or {}) do
    if not contains(lab.inputs, domain.pack) then
      error("FluxWorks domain science pack " .. domain.pack .. " is missing from lab " .. lab_name)
    end
  end

  for _, technology_name in ipairs(domain.consumers) do
    local technology = data.raw.technology[technology_name]
    if not contains(technology.prerequisites, domain.technology) then
      error(technology_name .. " is not gated by " .. domain.technology)
    end
    if not contains(technology.unit and technology.unit.ingredients, domain.pack) then
      error(technology_name .. " does not consume " .. domain.pack)
    end
  end


  for _, technology_name in ipairs(domain.external_consumers or {}) do
    if technology_name:sub(1, 3) == "fw-" then
      error("External domain-science consumer must not be a FluxWorks technology: " .. technology_name)
    end
    local technology = data.raw.technology[technology_name]
    if not technology or not contains(technology.unit and technology.unit.ingredients, domain.pack) then
      error(technology_name .. " does not consume " .. domain.pack)
    end
  end
end
