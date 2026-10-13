-- Catch broken reward wiring and model-footprint regressions at load time.
-- These checks deliberately leave other mods' machines and recipes alone.
local upgrades = {
  {"fw-flux-harvester", "fw-industrial-harvester", "fw-industrial-district-project", 3.4, 5},
  {"fw-synthesis-plant", "fw-precision-synthesis-plant", "fw-autonomous-network-project", 4.6, 6},
  {"fw-arc-foundry", "fw-chromatic-arc-foundry", "fw-spectrum-control-project", 5.1, 6},
  {"fw-precision-synthesis-plant", "fw-convergence-synthesis-plant", "fw-convergence-directive-project", 6.3, 7},
}

local function present(entries, name, effect_type)
  for _, entry in ipairs(entries or {}) do
    if effect_type then
      if entry.type == effect_type and entry.recipe == name then return true end
    elseif entry == name then
      return true
    end
  end
  return false
end

local function footprint_equal(left, right)
  if not (left and right) then return false end
  for corner = 1, 2 do
    for axis = 1, 2 do
      if math.abs(left[corner][axis] - right[corner][axis]) > 0.001 then
        return false
      end
    end
  end
  return true
end

local function fluid_inputs(machine)
  local count = 0
  for _, box in ipairs(machine.fluid_boxes or {}) do
    if box.production_type == "input" or box.production_type == "input-output" then
      count = count + 1
    end
  end
  return count
end

for _, spec in ipairs(upgrades) do
  local original_name, upgrade_name, project_name, speed, slots =
    spec[1], spec[2], spec[3], spec[4], spec[5]
  local machines = data.raw["assembling-machine"] or {}
  local original, upgrade = machines[original_name], machines[upgrade_name]
  local recipe = data.raw.recipe and data.raw.recipe[upgrade_name]
  local item = data.raw.item and data.raw.item[upgrade_name]
  local project = data.raw.technology and data.raw.technology[project_name]

  if not (original and upgrade and recipe and item and project) then
    error("FluxWorks industrial upgrade missing prototype: " .. upgrade_name)
  end
  if original.next_upgrade ~= upgrade_name
    or original.fast_replaceable_group ~= upgrade.fast_replaceable_group
    or not footprint_equal(original.collision_box, upgrade.collision_box)
    or not footprint_equal(original.selection_box, upgrade.selection_box)
  then
    error("FluxWorks industrial upgrade cannot safely fast-replace " .. original_name)
  end

  if upgrade.crafting_speed ~= speed or upgrade.module_slots ~= slots
    or #upgrade.crafting_categories ~= #original.crafting_categories
    or fluid_inputs(upgrade) ~= fluid_inputs(original)
  then
    error("FluxWorks industrial upgrade lost recipe capability: " .. upgrade_name)
  end

  if not (item.place_result == upgrade_name and upgrade.minable
    and upgrade.minable.result == upgrade_name
    and present(project.effects, upgrade_name, "unlock-recipe"))
  then
    error("FluxWorks industrial upgrade has no usable unlock: " .. upgrade_name)
  end

  if recipe.enabled ~= false or recipe.allow_productivity ~= false then
    error("FluxWorks industrial upgrade must be manually built: " .. upgrade_name)
  end
  local consumes_old_machine = false
  for _, ingredient in ipairs(recipe.ingredients or {}) do
    if ingredient.name == original_name and ingredient.amount == 1 then
      consumes_old_machine = true
    end
  end
  if not consumes_old_machine then
    error("FluxWorks industrial upgrade must consume its previous machine: " .. upgrade_name)
  end
end
