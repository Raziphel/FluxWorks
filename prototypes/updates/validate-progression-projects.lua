local projects = require("prototypes.technology.progression-projects")

local function contains(entries, name)
  for _, entry in ipairs(entries or {}) do
    local entry_name = type(entry) == "table" and (entry.name or entry[1]) or entry
    if entry_name == name then
      return true
    end
  end
  return false
end

for project_index, project in ipairs(projects) do
  local item = data.raw.item and data.raw.item[project.item]
  local recipe = data.raw.recipe and data.raw.recipe[project.item]
  local technology = data.raw.technology and data.raw.technology[project.technology]
  local domain = data.raw.technology and data.raw.technology[project.domain]
  if not (item and recipe and technology and domain) then
    error("FluxWorks progression project is incomplete: " .. project.item)
  end
  if recipe.enabled ~= false or recipe.allow_productivity ~= false then
    error("FluxWorks progression project recipe drifted: " .. project.item)
  end
  if item.icon ~= project.item_icon or item.icon_size ~= 64 or item.icons then
    error("FluxWorks progression project must use its clean single-layer project icon: " .. project.item)
  end
  if recipe.icon ~= item.icon or recipe.icon_size ~= item.icon_size or recipe.icons then
    error("FluxWorks progression project recipe icon drifted from its item: " .. project.item)
  end
  if not item.icon:find("__Krastorio2Assets__/icons/cards/", 1, true) then
    error("FluxWorks progression projects must share the research-data card silhouette: " .. project.item)
  end
  if not technology.research_trigger
    or technology.research_trigger.type ~= "craft-item"
    or technology.research_trigger.item ~= project.item
  then
    error("FluxWorks progression project has an invalid craft trigger: " .. project.technology)
  end
  if not technology.effects or #technology.effects == 0 then
    error("FluxWorks progression project has no permanent reward: " .. project.technology)
  end

  local unlock_found = false
  for _, effect in ipairs(domain.effects or {}) do
    if effect.type == "unlock-recipe" and effect.recipe == project.item then
      unlock_found = true
      break
    end
  end
  if not unlock_found then
    error(project.domain .. " does not unlock project recipe " .. project.item)
  end

  local previous = projects[project_index - 1]
  if previous then
    if not contains(recipe.ingredients, previous.item) then
      error(project.item .. " must consume the preceding project charter " .. previous.item)
    end
    if not contains(technology.prerequisites, previous.technology) then
      error(project.technology .. " must follow the preceding project " .. previous.technology)
    end
  end
end
