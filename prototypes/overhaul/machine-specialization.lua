-- FluxWorks Reborn: source-owned industrial equipment has genuinely different
-- throughput, energy and utility roles. Existing IDs, pipes and footprints stay.
local M={}
local profiles={
  ["fw-flux-harvester"]={speed=2.65,power="2.8MW"},
  ["fw-arc-foundry"]={speed=3.45,power="7.8MW"},
  ["fw-synthesis-plant"]={speed=3.15,power="6.5MW"},
  ["fw-petrochemical-facility"]={speed=3.20,power="5.4MW"},
  ["fw-hydraulic-plant"]={speed=3.05,power="2.8MW"},
  ["fw-atomic-enricher"]={speed=3.75,power="9.6MW"},
  ["fw-origin-forge"]={speed=1.85,power="22MW"},
  ["fw-industrial-harvester"]={speed=4.15,power="4.9MW"},
  ["fw-precision-synthesis-plant"]={speed=5.40,power="9.2MW"},
  ["fw-chromatic-arc-foundry"]={speed=5.85,power="13.2MW"},
  ["fw-convergence-synthesis-plant"]={speed=6.80,power="18MW"},
}
function M.apply()
  local factory=(data.raw["assembling-machine"] or {})
  local switched=0
  for name,profile in pairs(profiles) do
    local machine=factory[name]
    if machine then
      -- Preserve collision, selection, fluid connections and animation sheets.
      machine.crafting_speed=profile.speed
      machine.energy_usage=profile.power
      switched=switched+1
    end
  end
  -- Final convergence is built from all four disciplines rather than a stack
  -- of generic old Flux intermediates. Preserve the predecessor machine.
  local recipe=data.raw.recipe and data.raw.recipe["fw-convergence-synthesis-plant"]
  if recipe and data.raw.item and data.raw.item["fw-convergence-chassis"] then
    local ingredients={
      {type="item",name="fw-precision-synthesis-plant",amount=1},
      {type="item",name="fw-convergence-chassis",amount=2},
      {type="item",name="fw-flux-lattice",amount=5},
      {type="item",name="fw-resonance-substrate",amount=5},
      {type="item",name="fw-condensed-flux-matrix",amount=3},
    }
    recipe.ingredients=table.deepcopy(ingredients)
    if recipe.normal then recipe.normal.ingredients=table.deepcopy(ingredients) end
    if recipe.expensive then recipe.expensive.ingredients=table.deepcopy(ingredients) end
    recipe.energy_required=50
  end
  log("FluxWorks Reborn: assigned "..switched.." distinct factory machine roles")
  return switched
end
M.profiles=profiles
return M
