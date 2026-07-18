local function item_prototype(name)
  for _, prototype_type in ipairs({ "item", "tool", "ammo", "capsule", "module", "armor" }) do
    if data.raw[prototype_type] and data.raw[prototype_type][name] then
      return data.raw[prototype_type][name]
    end
  end
end

local function icons(item_name)
  local item = assert(item_prototype(item_name), "Missing Shattered campaign icon item: " .. item_name)
  local overlay
  if item.icons and item.icons[1] then
    overlay = table.deepcopy(item.icons[1])
  else
    overlay = { icon = item.icon, icon_size = item.icon_size or 64 }
  end
  overlay.icon_size = overlay.icon_size or item.icon_size or 64
  overlay.scale = (overlay.scale or (64 / overlay.icon_size)) * 0.48
  overlay.shift = { 12, 12 }
  return {
    { icon = "__space-age__/graphics/icons/shattered-planet.png", icon_size = 64 },
    overlay,
  }
end

local all_sciences = {
  "automation-science-pack", "logistic-science-pack", "chemical-science-pack",
  "production-science-pack", "utility-science-pack", "space-science-pack",
  "metallurgic-science-pack", "agricultural-science-pack",
  "electromagnetic-science-pack", "cryogenic-science-pack", "promethium-science-pack",
}

local function unit(count, time)
  local ingredients = {}
  for _, science in ipairs(all_sciences) do ingredients[#ingredients + 1] = { science, 1 } end
  return { count = count, ingredients = ingredients, time = time or 75 }
end

local function unlock(recipe)
  return { type = "unlock-recipe", recipe = recipe }
end

-- Promethium science opens the route to the edge, not the planet itself. FluxWorks owns the
-- actual expedition gate so every planetary discipline and the mature rift branch matter.
local promethium_technology = data.raw.technology and data.raw.technology["promethium-science-pack"]
if promethium_technology then
  local effects = {}
  for _, effect in ipairs(promethium_technology.effects or {}) do
    if not (effect.type == "unlock-space-location" and effect.space_location == "shattered-planet") then
      effects[#effects + 1] = effect
    end
  end
  promethium_technology.effects = effects
end

data:extend({
  {
    type = "technology", name = "fw-shattered-expedition-planning",
    icons = icons("fw-rift-stabilizer"),
    prerequisites = {
      "promethium-science-pack", "fw-cross-planetary-industrial-convergence",
      "fw-rift-harmonics", "fw-fusion-lattices",
    },
    unit = unit(2400, 75),
    effects = {
      { type = "unlock-space-location", space_location = "shattered-planet" },
      unlock("fw-shattered-expedition-supplies"),
    },
    order = "f-a[shattered-expedition]",
  },
  {
    type = "technology", name = "fw-shattered-platform-hardening",
    icons = icons("fw-annealed-cermet"),
    prerequisites = { "fw-shattered-expedition-planning", "advanced-asteroid-processing" },
    unit = unit(2700, 80), effects = { unlock("fw-shattered-platform-armoring") },
    order = "f-b[shattered-platform]",
  },
  {
    type = "technology", name = "fw-shattered-landing-protocols",
    icons = icons("foundation"),
    prerequisites = { "fw-shattered-platform-hardening", "fw-rift-logistics" },
    unit = unit(3000, 85), effects = { unlock("fw-shattered-landing-foundation") },
    order = "f-c[shattered-landing]",
  },
  {
    type = "technology", name = "fw-shattered-vulcanus-bridgehead",
    icons = icons("fw-vulcanus-slag-cermet"),
    prerequisites = { "fw-shattered-landing-protocols", "fw-vulcanus-industrial-symbiosis" },
    unit = unit(3200, 90), effects = { unlock("fw-shattered-red-bridgehead-forging") },
    order = "f-d-a[shattered-vulcanus]",
  },
  {
    type = "technology", name = "fw-shattered-gleba-bridgehead",
    icons = icons("fw-gleba-spore-resin"),
    prerequisites = { "fw-shattered-landing-protocols", "fw-gleba-regenerative-symbiosis" },
    unit = unit(3200, 90), effects = { unlock("fw-shattered-green-bridgehead-cultivation") },
    order = "f-d-b[shattered-gleba]",
  },
  {
    type = "technology", name = "fw-shattered-fulgora-bridgehead",
    icons = icons("fw-fulgora-static-mesh"),
    prerequisites = { "fw-shattered-landing-protocols", "fw-fulgora-electromagnetic-symbiosis" },
    unit = unit(3200, 90), effects = { unlock("fw-shattered-yellow-bridgehead-reclamation") },
    order = "f-d-c[shattered-fulgora]",
  },
  {
    type = "technology", name = "fw-shattered-aquilo-bridgehead",
    icons = icons("fw-aquilo-cryogel"),
    prerequisites = { "fw-shattered-landing-protocols", "fw-aquilo-thermal-symbiosis" },
    unit = unit(3200, 90), effects = { unlock("fw-shattered-purple-bridgehead-annealing") },
    order = "f-d-d[shattered-aquilo]",
  },
  {
    type = "technology", name = "fw-shattered-vent-harmonics",
    icons = icons("fw-condensed-flux-matrix"),
    prerequisites = {
      "fw-shattered-vulcanus-bridgehead", "fw-shattered-gleba-bridgehead",
      "fw-shattered-fulgora-bridgehead", "fw-shattered-aquilo-bridgehead",
    },
    unit = unit(3800, 95), effects = { unlock("fw-shattered-vent-spectrum-condensation") },
    order = "f-e[shattered-vents]",
  },
  {
    type = "technology", name = "fw-ion-storm-survival",
    icons = icons("fw-thermal-buffer"),
    prerequisites = { "fw-shattered-vent-harmonics", "fw-superconductive-systems" },
    unit = unit(4200, 100), effects = { unlock("fw-ion-storm-shielded-foundation") },
    order = "f-f[ion-storm-survival]",
  },
  {
    type = "technology", name = "fw-shattered-network-logistics",
    icons = icons("fw-rift-coupler"),
    prerequisites = { "fw-ion-storm-survival", "fw-rift-logistics" },
    unit = unit(4600, 105), effects = {
      unlock("fw-model-lattice"),
      unlock("fw-shattered-rift-coupler-array"),
    },
    order = "f-g[shattered-logistics]",
  },
  {
    type = "technology", name = "fw-shattered-origin-survey",
    icons = icons("fw-model-lattice"),
    prerequisites = { "fw-shattered-network-logistics", "fw-shattered-vent-harmonics" },
    unit = unit(5200, 110), effects = {
      unlock("fw-harmonic-lattice-core"),
      unlock("fw-shattered-origin-survey-lattice"),
    },
    order = "f-h[origin-survey]",
  },
  {
    type = "technology", name = "fw-ion-storm-capture",
    icons = icons("fw-origin-forge"),
    prerequisites = { "fw-shattered-origin-survey", "fw-origin-infrastructure" },
    unit = unit(6200, 120), effects = { unlock("fw-ion-storm-harmonic-core") },
    order = "f-i[ion-storm-capture]",
  },
})

local function remove_unlock(technology_name, recipe_name)
  local technology = data.raw.technology and data.raw.technology[technology_name]
  if not technology then return end
  local effects = {}
  for _, effect in ipairs(technology.effects or {}) do
    if not (effect.type == "unlock-recipe" and effect.recipe == recipe_name) then
      effects[#effects + 1] = effect
    end
  end
  technology.effects = effects
end

local function add_prerequisite(technology_name, prerequisite_name)
  local technology = data.raw.technology and data.raw.technology[technology_name]
  if not technology then return end
  technology.prerequisites = technology.prerequisites or {}
  for _, prerequisite in ipairs(technology.prerequisites) do
    if prerequisite == prerequisite_name then return end
  end
  technology.prerequisites[#technology.prerequisites + 1] = prerequisite_name
end

remove_unlock("fw-rift-harmonics", "fw-model-lattice")
remove_unlock("fw-origin-infrastructure", "fw-harmonic-lattice-core")
add_prerequisite("fw-origin-infrastructure", "fw-shattered-origin-survey")
add_prerequisite("fw-storm-megastructures", "fw-ion-storm-capture")
