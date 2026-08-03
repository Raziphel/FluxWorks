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

local reach_cache = {}

local function reaches(technology_name, prerequisite_name, visiting)
  if technology_name == prerequisite_name then return true end
  reach_cache[technology_name] = reach_cache[technology_name] or {}
  if reach_cache[technology_name][prerequisite_name] ~= nil then
    return reach_cache[technology_name][prerequisite_name]
  end
  visiting = visiting or {}
  if visiting[technology_name] then return false end
  visiting[technology_name] = true

  local technology = data.raw.technology and data.raw.technology[technology_name]
  for _, prerequisite in pairs((technology and technology.prerequisites) or {}) do
    if reaches(prerequisite, prerequisite_name, visiting) then
      visiting[technology_name] = nil
      reach_cache[technology_name][prerequisite_name] = true
      return true
    end
  end

  visiting[technology_name] = nil
  reach_cache[technology_name][prerequisite_name] = false
  return false
end

for _, domain in ipairs(domains) do
  local pack = data.raw.item and data.raw.item[domain.pack]
  local recipe = data.raw.recipe and data.raw.recipe[domain.pack]
  local unlock = data.raw.technology and data.raw.technology[domain.technology]
  if not (pack and recipe and unlock) then
    error("FluxWorks domain science is missing a pack, recipe, or unlock technology: " .. domain.pack)
  end

  local expected_icon = "__FluxWorksAssets__/graphics/icons/science/" .. domain.pack .. ".png"
  if pack.icon ~= expected_icon or pack.icon_size ~= 64 or pack.icons then
    error("FluxWorks science pack must use its own clean, single-layer bottle icon: " .. domain.pack)
  end

  local minimum_consumers = domain.pack == "fw-planetary-convergence-science-pack" and 20 or 25
  if #domain.consumers + #(domain.ingredient_consumers or {}) < minimum_consumers then
    error("FluxWorks domain science needs broad research utility, not a token consumer list: " .. domain.pack)
  end
  if #(domain.external_consumers or {}) < 15 then
    error("FluxWorks domain science must be woven into the wider technology tree: " .. domain.pack)
  end
  if domain.pack ~= "fw-planetary-convergence-science-pack"
    and #(domain.supporting_consumers or {}) < 5
  then
    error("FluxWorks domain science needs deliberate cross-domain follow-through: " .. domain.pack)
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
    if not reaches(technology_name, domain.technology) then
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


  for _, technology_name in ipairs(domain.ingredient_consumers or {}) do
    local technology = data.raw.technology[technology_name]
    if not technology or not contains(technology.unit and technology.unit.ingredients, domain.pack) then
      error(technology_name .. " does not consume pivotal domain science " .. domain.pack)
    end
  end

  for _, technology_name in ipairs(domain.supporting_consumers or {}) do
    local technology = data.raw.technology[technology_name]
    if not technology
      or not reaches(technology_name, domain.technology)
      or not contains(technology.unit and technology.unit.ingredients, domain.pack)
    then
      error(technology_name .. " does not preserve supporting discipline " .. domain.pack)
    end
  end
end

local expected_profiles = {
  ["fw-computational-arrays"] = {
    "fw-industrial-methods-science-pack",
    "fw-systems-analysis-science-pack",
  },
  ["fw-flux-field-theory"] = {
    "fw-systems-analysis-science-pack",
    "fw-flux-theory-science-pack",
  },
  ["fw-rift-harmonics"] = {
    "fw-flux-theory-science-pack",
    "fw-planetary-convergence-science-pack",
  },
  ["fw-origin-transcendence"] = {
    "fw-systems-analysis-science-pack",
    "fw-flux-theory-science-pack",
    "fw-planetary-convergence-science-pack",
  },
}

for technology_name, packs in pairs(expected_profiles) do
  local technology = data.raw.technology and data.raw.technology[technology_name]
  for _, pack in ipairs(packs) do
    if not technology or not contains(technology.unit and technology.unit.ingredients, pack) then
      error(technology_name .. " lost its cross-domain science profile: " .. pack)
    end
  end
end

-- These contracts are the player-facing identity of the four bottles. Keep
-- them explicit: broad consumer counts can look healthy while a signature
-- promise quietly drifts onto the wrong science lane.
local advertised_promises = {
  ["fw-industrial-methods-science-pack"] = {
    "fw-advanced-fabrication",
    "fw-hydraulic-systems",
    "fw-metallurgic-assemblies",
    "fw-flux-extraction",
    "fw-actinide-reforging",
  },
  ["fw-systems-analysis-science-pack"] = {
    "fw-computational-arrays",
    "fw-logic-weaving",
    "fw-power-regulation",
    "fw-rift-network-synchronization",
    "fw-spectral-reservoir-density",
  },
  ["fw-flux-theory-science-pack"] = {
    "fw-flux-synthesis",
    "fw-rift-harmonics",
    "fw-flux-purple-transmutation",
    "fw-unified-spectrum-control",
    "fw-flux-synthesis-mastery",
  },
  ["fw-planetary-convergence-science-pack"] = {
    "fw-shattered-expedition-planning",
    "fw-ion-storm-capture",
    "fw-rift-logistics",
    "fw-convergence-research",
    "fw-shattered-planet-yield",
  },
}

for pack_name, technology_names in pairs(advertised_promises) do
  for _, technology_name in ipairs(technology_names) do
    local technology = data.raw.technology and data.raw.technology[technology_name]
    if not technology or not contains(technology.unit and technology.unit.ingredients, pack_name) then
      error(technology_name .. " no longer fulfills the advertised promise of " .. pack_name)
    end
  end
end

local flux_extraction = data.raw.technology and data.raw.technology["fw-flux-extraction"]
if not flux_extraction
  or contains(flux_extraction.unit and flux_extraction.unit.ingredients, "cryogenic-science-pack")
then
  error("Flux Extraction must remain a midgame technology and must not consume Cryogenic Science")
end
if not contains(flux_extraction.unit and flux_extraction.unit.ingredients, "fw-industrial-methods-science-pack") then
  error("Flux Extraction must consume Industrial Methods Science")
end

local recipe_identities = {
  ["fw-industrial-methods-science-pack"] = {
    "fw-metal-mesh", "fw-iron-beam", "glass", "fw-carbon",
  },
  ["fw-systems-analysis-science-pack"] = {
    "fw-sensor-package", "fw-signal-conduit", "fw-microchip", "battery",
  },
  ["fw-flux-theory-science-pack"] = {
    "fw-stabilized-flux-crystal", "fw-flux-catalyst",
    "fw-resonance-substrate", "fw-purple-flux",
  },
  ["fw-planetary-convergence-science-pack"] = {
    "fw-promethium-matrix", "fw-rift-stabilizer", "fw-condensed-flux-matrix",
  },
}

for recipe_name, signature_inputs in pairs(recipe_identities) do
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  for _, input_name in ipairs(signature_inputs) do
    if not recipe or not contains(recipe.ingredients, input_name) then
      error(recipe_name .. " lost identity-defining ingredient " .. input_name)
    end
  end
end

local convergence_feeder_identities = {
  ["fw-rift-stabilizer"] = {
    "fw-aquilo-cryogel", "fw-gleba-spore-resin",
    "fw-fulgora-static-mesh", "fw-vulcanus-slag-cermet",
  },
  ["fw-condensed-flux-matrix"] = {
    "fw-purple-flux", "fw-yellow-flux", "fw-red-flux", "fw-green-flux",
  },
}

for recipe_name, signature_inputs in pairs(convergence_feeder_identities) do
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  for _, input_name in ipairs(signature_inputs) do
    if not recipe or not contains(recipe.ingredients, input_name) then
      error(recipe_name .. " no longer feeds Convergence Science with " .. input_name)
    end
  end
end

local function technology_unlocks(technology_name, effect_type, target_key, target_name)
  local technology = data.raw.technology and data.raw.technology[technology_name]
  for _, effect in ipairs(technology and technology.effects or {}) do
    if effect.type == effect_type and effect[target_key] == target_name then
      return true
    end
  end
  return false
end

if not technology_unlocks(
  "fw-shattered-expedition-planning", "unlock-space-location", "space_location", "shattered-planet"
) then
  error("Planetary Convergence Science must unlock the Shattered Planet surface")
end

for _, gate_recipe in ipairs({ "fw-rift-exchange-gate", "fw-rift-exchange-fluid-gate" }) do
  if not technology_unlocks("fw-rift-logistics", "unlock-recipe", "recipe", gate_recipe) then
    error("Planetary Convergence teleportation promise lost recipe " .. gate_recipe)
  end
end

local transmutation_unlock_found = false
local transmutation = data.raw.technology and data.raw.technology["fw-flux-purple-transmutation"]
for _, effect in ipairs(transmutation and transmutation.effects or {}) do
  local recipe = effect.type == "unlock-recipe"
    and data.raw.recipe
    and data.raw.recipe[effect.recipe]
  if recipe and (
    recipe.subgroup == "fw-transmutation-upcycle"
    or recipe.subgroup == "fw-transmutation-downcycle"
  ) then
    transmutation_unlock_found = true
    break
  end
end
if not transmutation_unlock_found then
  error("Flux Theory Science must unlock the advertised transmutation ladder")
end

if #domains.all_science_consumers == 0 then
  error("FluxWorks did not detect any complete-catalog research technologies")
end

for _, technology_name in ipairs(domains.all_science_consumers) do
  local technology = data.raw.technology[technology_name]
  for _, domain in ipairs(domains) do
    if not contains(technology.unit and technology.unit.ingredients, domain.pack) then
      error(technology_name .. " claims to use every science but omits " .. domain.pack)
    end
  end
end

local research_productivity = data.raw.technology and data.raw.technology["research-productivity"]
for _, domain in ipairs(domains) do
  if not research_productivity
    or not contains(research_productivity.unit and research_productivity.unit.ingredients, domain.pack)
  then
    error("Research Productivity must consume every FluxWorks science pack: " .. domain.pack)
  end
end
