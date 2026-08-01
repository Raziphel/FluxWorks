local Startup = require("prototypes.lib.startup-settings")
local Layout = require("prototypes.lib.crafting-tab-layout")
local Router = require("prototypes.lib.crafting-tab-router")

if not Startup.enabled("fw-enable-crafting-tab-reorganization", true) then
  return
end

for _, item_group in ipairs(Layout.item_groups) do
  Router.ensure_group(item_group)
end

for _, subgroup in ipairs(Layout.subgroups) do
  Router.ensure_subgroup(subgroup)
end

Router.purge_many({ "tool", "item", "recipe" }, {
  "fw-fabrication-science-pack",
  "fw-transport-science-pack",
  "fw-combustion-science-pack",
  "fw-solution-science-pack",
  "fw-instrumentation-science-pack",
})
Router.purge_many({ "item-subgroup" }, { "fw-science-facilities" })

local domains = {
  { setting = "fw-tab-science-organization", module = "science" },
  { setting = "fw-tab-logistics-organization", module = "logistics" },
  { module = "early-cross-domain" },
  { setting = "fw-tab-production-organization", module = "production" },
  { setting = "fw-tab-bioprocessing-organization", module = "bioprocessing" },
  { setting = "fw-tab-energy-organization", module = "energy" },
  { setting = "fw-tab-chemistry-organization", module = "chemistry" },
  { setting = "fw-tab-logistics-organization", module = "networks" },
  { setting = "fw-tab-flux-organization", module = "flux-materials" },
  { setting = "fw-tab-fabrication-organization", module = "fabrication" },
}

for _, domain in ipairs(domains) do
  if not domain.setting or Startup.enabled(domain.setting, true) then
    require("prototypes.updates.crafting_tabs." .. domain.module)(Router)
  end
end

-- A few shared prototypes sit at the boundary between otherwise independent
-- tabs and therefore have no single optional domain owner.
require("prototypes.updates.crafting_tabs.cross-domain")(Router)

if Startup.enabled("fw-tab-flux-organization", true) then
  require("prototypes.updates.crafting_tabs.flux-systems")(Router)
end

-- Recycling recipes are generated after their products choose an initial tab.
-- Mirror the finished item route so those recipes remain beside their product.
for recipe_name, recipe in pairs(data.raw.recipe or {}) do
  local recycled_name = string.match(recipe_name, "^(.*)%-recycling$")
  local recycled_subgroup = recycled_name and Router.item_subgroup(recycled_name)
  if recycled_subgroup then
    recipe.subgroup = recycled_subgroup
  end
end

for recipe_name, recipe in pairs(data.raw.recipe or {}) do
  if string.sub(recipe_name, 1, 3) == "fw-" and not recipe.subgroup then
    recipe.subgroup = Router.item_subgroup(Router.recipe_main_item_name(recipe))
  end
end
