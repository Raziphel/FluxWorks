local function box_width(box)
  return box and box[2] and box[1] and (box[2][1] - box[1][1]) or 0
end

local function assert_footprint(machine_name, expected_collision_width, expected_selection_width)
  local machine = data.raw["assembling-machine"] and data.raw["assembling-machine"][machine_name]
  if not machine then return end

  if math.abs(box_width(machine.collision_box) - expected_collision_width) > 0.01 then
    error(machine_name .. " collision footprint no longer matches its rendered base")
  end
  if math.abs(box_width(machine.selection_box) - expected_selection_width) > 0.01 then
    error(machine_name .. " selection footprint no longer matches its rendered base")
  end
end

local function count_recipes(category_name)
  local count = 0
  for _, recipe in pairs(data.raw.recipe or {}) do
    for _, recipe_category in pairs(recipe.categories or {}) do
      if recipe_category == category_name then
        count = count + 1
        break
      end
    end
  end
  return count
end

assert_footprint("fw-flux-harvester", 4.4, 5.0)
assert_footprint("fw-arc-foundry", 6.4, 7.0)
assert_footprint("fw-petrochemical-facility", 4.2, 4.4)

local harvester = data.raw["assembling-machine"] and data.raw["assembling-machine"]["fw-flux-harvester"]
local harvester_layers = harvester and harvester.graphics_set and harvester.graphics_set.animation.layers
local harvester_body = harvester_layers and harvester_layers[2]
if harvester_body then
  local first_stripe = harvester_body.stripes and harvester_body.stripes[1]
  if not (first_stripe and string.find(first_stripe.filename, "quantum-stabilizer", 1, true)) then
    error("Flux Harvester must retain its spectral-separation machine identity")
  end
  if harvester_body.scale > 0.4 then
    error("Flux Harvester graphic exceeds its five-tile footprint")
  end
end

local condenser_body = data.raw.animation and data.raw.animation["fw-flux-condenser-working-animation"]
local condenser_liquid = data.raw.animation and data.raw.animation["fw-flux-condenser-working-glow"]
if condenser_body and condenser_liquid then
  local body_y = condenser_body.shift and condenser_body.shift[2]
  local liquid_y = condenser_liquid.shift and condenser_liquid.shift[2]
  if not (body_y and liquid_y and liquid_y > body_y) then
    error("Flux condenser liquid mask must remain below the independently rendered body animation")
  end
end

for category_name, minimum_recipes in pairs({
  ["fw-petrochemistry"] = 6,
  ["fw-hydraulics"] = 9,
}) do
  local actual_recipes = count_recipes(category_name)
  if actual_recipes < minimum_recipes then
    error(("%s is underused: expected at least %d recipes, found %d"):format(
      category_name,
      minimum_recipes,
      actual_recipes
    ))
  end
end
