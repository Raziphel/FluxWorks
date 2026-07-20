local function require_many(modules)
  for _, module_name in ipairs(modules) do
    require(module_name)
  end
end

require_many({
  "prototypes.updates.resource-placement",
  "prototypes.updates.rocket-reusability-final-fixes",
  "prototypes.technology.domain-science",
  "prototypes.technology.progression-projects",
  "prototypes.technology.industrial-research-programs",
  "prototypes.updates.factoriopedia",
  "prototypes.recipes.flux-condensing",
  "prototypes.recipes.red-flux-fuels",
  "prototypes.recipes.purple-flux-materials",
  "prototypes.recipes.yellow-flux-mechanics",
  "prototypes.recipes.red-flux-sources",
  "prototypes.recipes.red-flux-mechanics",
  "prototypes.recipes.green-flux-mechanics",
  "prototypes.updates.chemistry-integration",
  "prototypes.updates.recipe-tweaks",
  "prototypes.updates.difficulty-overrides",
  "prototypes.updates.technology-weave",
  "prototypes.updates.domain-science-integration",
  "prototypes.updates.crafting-tabs",
  "prototypes.updates.flux-tooltips",
  "prototypes.updates.flux-composition-doctrine",
  "prototypes.updates.recipe-icons",
  "prototypes.updates.visual-identity",
  "prototypes.updates.recipe-decomposition",
  "prototypes.updates.ore-icon-final-fixes",
  "prototypes.updates.aai-industry",
  "prototypes.updates.recipe-complexity-normalization",
  "prototypes.updates.validate-aai-industry",
  "prototypes.updates.validate-item-uses",
  "prototypes.updates.validate-coke-steel",
  "prototypes.updates.validate-logistics-recipes",
  "prototypes.updates.validate-recipe-complexity",
  "prototypes.updates.validate-flux-composition-doctrine",
  "prototypes.updates.validate-domain-science",
  "prototypes.updates.validate-progression-projects",
  "prototypes.updates.validate-research-programs",
  "prototypes.updates.validate-progression-graph",
  "prototypes.updates.validate-progression-ladders",
  "prototypes.updates.validate-recipe-decomposition",
  "prototypes.updates.validate-prototype-icons",
  "prototypes.updates.validate-technology-icons",
  "prototypes.updates.validate-crafting-tabs",
})

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
