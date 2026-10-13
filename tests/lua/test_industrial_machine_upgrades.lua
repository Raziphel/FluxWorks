-- Run from the FluxWorks repository root with Lua 5.2+:
-- lua tests/lua/test_industrial_machine_upgrades.lua
-- Small data-stage mock; an actual Factorio 2.1 load is still essential.
local function copy(value)
  if type(value) ~= "table" then return value end
  local result = {}
  for key, item in pairs(value) do result[copy(key)] = copy(item) end
  return result
end
table.deepcopy = copy

local machines = {
  "fw-flux-harvester", "fw-synthesis-plant", "fw-arc-foundry",
}
local source_speeds = {2.2, 2.9, 3.2}
local machine_categories = {
  "fw-flux-harvesting", "fw-flux-synthesis", "fw-arc-smelting",
}
local base_items = {
  "fw-pressure-housing", "fw-cermet", "fw-transformer-core",
  "steel-plate", "fw-sensor-package", "fw-flow-regulator",
  "fw-circuit-substrate", "processing-unit", "fw-annealed-cermet",
  "fw-foundry-lining", "fw-field-winding", "tungsten-carbide",
  "fw-stabilized-flux-crystal", "fw-condensed-flux-matrix",
  "fw-resonance-substrate", "fw-flux-lattice",
}
local raw = {
  item = {}, recipe = {}, technology = {}, ["assembling-machine"] = {},
}
local function add_machine(name, index)
  raw.item[name] = {
    name = name, icon = "test/" .. name .. ".png", icon_size = 64,
    place_result = name, subgroup = "production-machine", stack_size = 10,
  }
  raw["assembling-machine"][name] = {
    name = name, crafting_speed = source_speeds[index],
    crafting_categories = {machine_categories[index]},
    energy_usage = "2MW", module_slots = 4,
    minable = {mining_time = 1, result = name},
    collision_box = {{-2, -2}, {2, 2}},
    selection_box = {{-2.5, -2.5}, {2.5, 2.5}},
    fast_replaceable_group = "fw-flux-processing",
    allowed_effects = {"speed", "consumption"},
    fluid_boxes = {
      {production_type = "input", pipe_connections = {}},
      {production_type = "input", pipe_connections = {}},
    },
    graphics_set = {working_visualisations = {{light = {color = {r = 1, g = 1, b = 1}}}}},
  }
end

for index, name in ipairs(machines) do add_machine(name, index) end
for _, name in ipairs(base_items) do raw.item[name] = {name = name} end
for _, name in ipairs({
  "fw-industrial-district-project",
  "fw-autonomous-network-project",
  "fw-spectrum-control-project",
  "fw-convergence-directive-project",
  "fw-harvester-systems", "fw-flux-stabilization", "fw-flux-metallurgy",
}) do
  raw.technology[name] = {name = name, prerequisites = {}, effects = {}}
end

_G.data = {raw = raw}
function data:extend(prototypes)
  for _, prototype in ipairs(prototypes) do
    local bucket = assert(raw[prototype.type], "Unexpected prototype type")
    assert(not bucket[prototype.name], "Duplicate prototype " .. prototype.name)
    bucket[prototype.name] = prototype
  end
end
_G.log = function() end

local source = "prototypes/updates/industrial-machine-upgrades.lua"
dofile(source)

local upgraded = {
  {"fw-industrial-harvester", "fw-flux-harvester", "fw-industrial-district-project", 3.4, 5},
  {"fw-precision-synthesis-plant", "fw-synthesis-plant", "fw-autonomous-network-project", 4.6, 6},
  {"fw-chromatic-arc-foundry", "fw-arc-foundry", "fw-spectrum-control-project", 5.1, 6},
  {"fw-convergence-synthesis-plant", "fw-precision-synthesis-plant", "fw-convergence-directive-project", 6.3, 7},
}

for _, spec in ipairs(upgraded) do
  local name, original, technology, speed, slots =
    spec[1], spec[2], spec[3], spec[4], spec[5]
  local entity, recipe, item = raw["assembling-machine"][name], raw.recipe[name], raw.item[name]
  assert(entity and recipe and item, "Missing advanced machine: " .. name)
  assert(entity.crafting_speed == speed and entity.module_slots == slots)
  if name == "fw-industrial-harvester" then
    local has_quality = false
    for _, effect in ipairs(entity.allowed_effects) do
      if effect == "quality" then has_quality = true end
    end
    assert(has_quality, "Industrial harvester should accept quality modules")
    assert(#raw["assembling-machine"][original].allowed_effects == 2,
      "Basic harvester must retain its original effect restrictions")
  end
  assert(recipe.ingredients[1].name == original, "Previous machine is not consumed")
  assert(raw["assembling-machine"][original].next_upgrade == name)
  assert(item.place_result == name and entity.minable.result == name)
  assert(entity.crafting_categories[1] == raw["assembling-machine"][original].crafting_categories[1])
  local unlocked = false
  for _, effect in ipairs(raw.technology[technology].effects) do
    if effect.type == "unlock-recipe" and effect.recipe == name then
      assert(not unlocked, "Duplicate unlock")
      unlocked = true
    end
  end
  assert(unlocked, "Missing research reward " .. name)
end

-- Running the registration twice never creates duplicate items or effects.
dofile(source)
local count = 0
for name in pairs(raw.recipe) do
  if name:sub(1, 3) == "fw-" then count = count + 1 end
end
assert(count == 4)
assert(#raw.item["fw-convergence-synthesis-plant"].icons == 3,
  "Convergence should show both purple and green Flux icons")

-- The same structural checks used in the actual Factorio data stage.
dofile("prototypes/validation/industrial-machine-upgrades.lua")
print("FluxWorks: four industrial machine upgrades and research unlocks OK")
