require("prototypes.updates.resource-placement")
require("prototypes.updates.rocket-reusability-final-fixes")
require("prototypes.updates.factoriopedia")
require("prototypes.recipes.flux-condensing")
require("prototypes.recipes.red-flux-fuels")
require("prototypes.recipes.purple-flux-materials")
require("prototypes.recipes.yellow-flux-mechanics")
require("prototypes.recipes.red-flux-sources")
require("prototypes.recipes.red-flux-mechanics")
require("prototypes.recipes.green-flux-mechanics")
require("prototypes.updates.chemistry-integration")
require("prototypes.updates.recipe-tweaks")
require("prototypes.updates.difficulty-overrides")
require("prototypes.updates.crafting-tabs")
require("prototypes.updates.flux-tooltips")
require("prototypes.updates.recipe-icons")
require("prototypes.updates.validate-progression-ladders")
require("prototypes.updates.validate-technology-icons")
require("prototypes.updates.validate-crafting-tabs")

local foundation_item = data.raw.item and data.raw.item["foundation"]
local foundation_place_as_tile = foundation_item and foundation_item.place_as_tile
local foundation_tile_condition = foundation_place_as_tile and foundation_place_as_tile.tile_condition

if foundation_tile_condition then
  local has_shattered_space = false

  for _, tile_name in ipairs(foundation_tile_condition) do
    if tile_name == "fw-shattered-space" then
      has_shattered_space = true
      break
    end
  end

  if not has_shattered_space then
    foundation_tile_condition[#foundation_tile_condition + 1] = "fw-shattered-space"
  end
end
