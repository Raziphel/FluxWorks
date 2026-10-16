-- Lean FluxWorks companion-mode regression. Run from the repository root.
local removed={
 "scripts/true-ending.lua","scripts/shattered-planet.lua",
 "scripts/shattered-asteroids.lua","prototypes/updates/shattered-planet.lua",
 "prototypes/resources/shattered-flux-vents.lua",
 "prototypes/menu-simulations.lua","prototypes/menu-branding.lua",
 "prototypes/updates/menu-branding.lua","menu-simulations/manifest.lua",
 "menu-simulations/fw-menu-biters.zip","menu-simulations/fw-menu-defense.zip",
 "menu-simulations/fw-menu-sorting-ores.zip","menu-simulations/fw-menu-mall.zip",
 "prototypes/updates/space-platform-drag.lua",
 "prototypes/updates/player-tuning.lua",
 "prototypes/updates/asteroid-crushing.lua",
 "prototypes/updates/fulgora-scrap.lua",
 "prototypes/updates/technology-weave.lua",
}
for _,path in ipairs(removed) do
  local file=io.open(path,"rb")
  if file then file:close() end
  assert(not file,"Obsolete standalone file restored: "..path)
end
local live={
 "data.lua","data-updates.lua","data-final-fixes.lua",
 "control.lua","prototypes/validation/init.lua",
}
for _,path in ipairs(live) do
  local file=assert(io.open(path,"rb"))
  local source=file:read("*a")
  file:close()
  for _,removed_path in ipairs(removed) do
    if removed_path:sub(-4)==".lua" then
      local module=removed_path:sub(1,-5):gsub("/",".")
      assert(not source:find('require("'..module..'")',1,true),
        "Entry point still imports retired module: "..module)
    end
  end
end
_G.data={raw={technology={
  ["promethium-science-pack"]={effects={
    {type="unlock-space-location",space_location="shattered-planet"}
  }},
  ["fw-rift-harmonics"]={effects={
    {type="unlock-recipe",recipe="fw-model-lattice"}
  }},
  ["fw-origin-infrastructure"]={effects={
    {type="unlock-recipe",recipe="fw-harmonic-lattice-core"}
  }},
}}}
function data:extend(techs)
  for _,proto in ipairs(techs) do
    assert(proto.type=="technology")
    assert(not self.raw.technology[proto.name])
    self.raw.technology[proto.name]=proto
  end
end
package.loaded["prototypes.lib.companion-mode"]={razi_protocol=true}
dofile("prototypes/technology/shattered-campaign.lua")
local techs=data.raw.technology
local function unlocks(name,recipe)
  for _,effect in ipairs(techs[name].effects or {}) do
    if effect.type=="unlock-recipe" and effect.recipe==recipe then return true end
  end
end
assert(unlocks("fw-rift-harmonics","fw-model-lattice"),
  "Razi companion mode stole standard model lattice recipe")
assert(unlocks("fw-origin-infrastructure","fw-harmonic-lattice-core"),
  "Razi companion mode stole standard harmonic lattice recipe")
local native=techs["promethium-science-pack"].effects[1]
assert(native.type=="unlock-space-location" and native.space_location=="shattered-planet",
  "Razi's source-owned location unlock must be left unchanged")
for name,tech in pairs(techs) do
  if name:sub(1,3)=="fw-" then
    for _,effect in ipairs(tech.effects or {}) do
      assert(not (effect.type=="unlock-space-location"
        and effect.space_location=="shattered-planet"),
        "FluxWorks must not claim Razi's Shattered Planet: "..name)
    end
  end
end
print("FluxWorks lean extension: retired sources, preserved legacy IDs and Razi destination ownership")
