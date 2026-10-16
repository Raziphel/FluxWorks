-- Four optional, physically buildable rewards for FluxWorks' research projects.
-- These are new prototypes, not replacements: existing machines and saves keep
-- working without a migration or a runtime upgrade event.
local upgrades = {
  {
    name = "fw-industrial-harvester",
    badge = "industrial-harvester",
    from = "fw-flux-harvester",
    project = "fw-industrial-district-project",
    prerequisite = "fw-harvester-systems",
    colour = "yellow",
    glow = {r = 0.98, g = 0.82, b = 0.25},
    speed = 3.4,
    energy = "3.8MW",
    modules = 5,
    quality = true,
    time = 18,
    ingredients = {
      {"fw-flux-harvester", 1},
      {"fw-pressure-housing", 8},
      {"fw-cermet", 12},
      {"fw-transformer-core", 6},
      {"steel-plate", 50},
    },
  },
  {
    name = "fw-precision-synthesis-plant",
    badge = "precision-synthesis",
    from = "fw-synthesis-plant",
    project = "fw-autonomous-network-project",
    prerequisite = "fw-flux-stabilization",
    colour = "purple",
    glow = {r = 0.75, g = 0.38, b = 1},
    speed = 4.6,
    energy = "7.2MW",
    modules = 6,
    time = 22,
    ingredients = {
      {"fw-synthesis-plant", 1},
      {"fw-sensor-package", 8},
      {"fw-flow-regulator", 8},
      {"fw-circuit-substrate", 8},
      {"processing-unit", 20},
    },
  },
  {
    name = "fw-chromatic-arc-foundry",
    badge = "chromatic-foundry",
    from = "fw-arc-foundry",
    project = "fw-spectrum-control-project",
    prerequisite = "fw-flux-metallurgy",
    colour = "red",
    glow = {r = 1, g = 0.30, b = 0.20},
    speed = 5.1,
    energy = "10.5MW",
    modules = 6,
    time = 25,
    ingredients = {
      {"fw-arc-foundry", 1},
      {"fw-annealed-cermet", 12},
      {"fw-foundry-lining", 12},
      {"fw-field-winding", 12},
      {"tungsten-carbide", 20},
    },
  },
  {
    name = "fw-convergence-synthesis-plant",
    badge = "convergence",
    from = "fw-precision-synthesis-plant",
    project = "fw-convergence-directive-project",
    prerequisite = "fw-spectrum-control-project",
    colour = "purple",
    partner = "green",
    glow = {r = 0.86, g = 0.70, b = 1.0},
    speed = 6.3,
    energy = "13MW",
    modules = 7,
    time = 35,
    ingredients = {
      {"fw-precision-synthesis-plant", 1},
      {"fw-stabilized-flux-crystal", 10},
      {"fw-condensed-flux-matrix", 8},
      {"fw-resonance-substrate", 10},
      {"fw-flux-lattice", 12},
    },
  },
}

local function find_item(name)
  for _, kind in ipairs({"item", "tool"}) do
    local prototype = data.raw[kind] and data.raw[kind][name]
    if prototype then return prototype end
  end
end

local function icon_layers(source, badge)
  local icons
  if source.icons then icons = table.deepcopy(source.icons)
  elseif source.icon then icons = {{icon = source.icon, icon_size = source.icon_size or 64}}
  else return nil end
  -- Convergence upgrades a Precision plant: replace its project badge rather
  -- than stacking two different machine identities in one tiny icon.
  for index = #icons, 1, -1 do
    local path = icons[index].icon or ""
    if string.find(path, "__FluxWorksAssets__/graphics/icons/upgrade-badges/", 1, true) then
      table.remove(icons, index)
    end
  end
  icons[#icons + 1] = {
    icon = "__FluxWorksAssets__/graphics/icons/upgrade-badges/fw-" .. badge .. ".png",
    icon_size = 128, scale = 0.16, shift = {17, 17},
  }
  return icons
end

local function has_effect(technology, recipe)
  for _, effect in ipairs(technology.effects or {}) do
    if effect.type == "unlock-recipe" and effect.recipe == recipe then return true end
  end
  return false
end

local function ensure_prerequisite(technology, prerequisite)
  if not (data.raw.technology and data.raw.technology[prerequisite]) then return false end
  technology.prerequisites = technology.prerequisites or {}
  for _, current in ipairs(technology.prerequisites) do
    if current == prerequisite then return true end
  end
  technology.prerequisites[#technology.prerequisites + 1] = prerequisite
  return true
end

local function compatible_ingredients(sources)
  local ingredients = {}
  for _, source in ipairs(sources) do
    local name = source[1]
    if not find_item(name) then
      -- K2SO may rename an original Space Age item. Prefer the live prototype
      -- rather than changing K2SO-owned materials or items elsewhere.
      if name:sub(1, 3) == "fw-" or not find_item("kr-" .. name) then
        return nil
      end
      name = "kr-" .. name
    end
    ingredients[#ingredients + 1] = {type = "item", name = name, amount = source[2]}
  end
  return ingredients
end

local built = 0
for index, spec in ipairs(upgrades) do
  local machines = data.raw["assembling-machine"] or {}
  local original = machines[spec.from]
  local item = find_item(spec.from)
  local project = data.raw.technology and data.raw.technology[spec.project]
  local ingredients = compatible_ingredients(spec.ingredients)
  local icons = item and icon_layers(item, spec.badge)

  if original and item and project and ingredients and icons
    and ensure_prerequisite(project, spec.prerequisite) then
    if not machines[spec.name] then
      local machine = table.deepcopy(original)
      machine.name = spec.name
      machine.icon = nil
      machine.icon_size = nil
      machine.icons = table.deepcopy(icons)
      machine.localised_name = {"entity-name." .. spec.name}
      machine.localised_description = {"entity-description." .. spec.name}
      machine.minable = machine.minable or {mining_time = 1}
      machine.minable.result = spec.name
      machine.crafting_speed = spec.speed
      machine.energy_usage = spec.energy
      machine.module_slots = spec.modules
      -- The capstone combines synthesis, condensing, and arc manufacture in a
      -- single researched machine. Both families use at most two fluid inputs.
      local universal = settings and settings.startup
        and settings.startup["fw-rp-convergence-universal"]
      if spec.name == "fw-convergence-synthesis-plant"
        and (not universal or universal.value ~= false) then
        machine.crafting_categories = table.deepcopy(original.crafting_categories)
        local present = false
        for _, category in ipairs(machine.crafting_categories) do
          if category == "fw-arc-smelting" then present = true end
        end
        if not present then machine.crafting_categories[#machine.crafting_categories + 1] = "fw-arc-smelting" end
      end
      -- Industrial harvesting earns a genuine new capability: quality-module
      -- ore and recovered-material processing, while the basic Harvester is
      -- left untouched for existing factories.
      if spec.quality then
        machine.allowed_effects = machine.allowed_effects or {}
        local has_quality = false
        for _, effect in ipairs(machine.allowed_effects) do
          if effect == "quality" then has_quality = true end
        end
        if not has_quality then
          machine.allowed_effects[#machine.allowed_effects + 1] = "quality"
        end
      end
      -- Recolour only existing working lights, not baked animation frames or
      -- shadows. The artwork remains compatible with the original footprint.
      local visuals = machine.graphics_set and machine.graphics_set.working_visualisations
      if visuals then
        for _, visual in ipairs(visuals) do
          if visual.light then visual.light.color = table.deepcopy(spec.glow) end
        end
      end

      local upgraded_item = table.deepcopy(item)
      upgraded_item.name = spec.name
      upgraded_item.place_result = spec.name
      upgraded_item.icon = nil
      upgraded_item.icon_size = nil
      upgraded_item.icons = table.deepcopy(icons)
      upgraded_item.localised_name = {"item-name." .. spec.name}
      upgraded_item.order = ("z[fw-industrial-upgrades]-%02d"):format(index)

      local recipe = {
        type = "recipe",
        name = spec.name,
        icons = table.deepcopy(icons),
        localised_name = {"recipe-name." .. spec.name},
        enabled = false,
        energy_required = spec.time,
        auto_recycle = false,
        allow_productivity = false,
        ingredients = ingredients,
        results = {{type = "item", name = spec.name, amount = 1}},
        main_product = spec.name,
        subgroup = "production-machine",
        order = ("z[fw-industrial-upgrades]-%02d"):format(index),
      }

      data:extend({upgraded_item, recipe, machine})
    end

    if not has_effect(project, spec.name) then
      project.effects = project.effects or {}
      project.effects[#project.effects + 1] = {type = "unlock-recipe", recipe = spec.name}
    end

    -- Matching-sized upgrades are eligible for normal upgrade-planner actions.
    -- Do not change collision boxes, fluid ports, or crafting categories.
    if not original.next_upgrade then
      original.next_upgrade = spec.name
    end
    built = built + 1
  else
    log("FluxWorks industrial upgrades: unavailable " .. spec.name)
  end
end

log("FluxWorks industrial upgrades: " .. built .. " optional machine tiers registered")
