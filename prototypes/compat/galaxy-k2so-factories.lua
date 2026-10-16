-- K2SO + actual native planet resources combine into advanced factory alternatives.
-- Conditional recipes never change planets, source items, native crafting, or Razi tech.
-- Honor both the legacy K2SO integration switch and the new planet-factory
-- switch; opting out of K2SO must disable every new K2SO hybrid as well.
if not (mods and mods["Krastorio2-spaced-out"]) then return 0,0 end
local legacy=settings and settings.startup and settings.startup["fw-enable-k2so-integration"]
if legacy and legacy.value==false then return 0,0 end
local register=require("prototypes.compat.galactic-industry-framework").register
local specs={
  {id="nauvis-electronic-components-0",family="k2-galaxy",world="nauvis",system="calidus",native={"iron-plate"},k2={"kr-electronic-components"},product="fw-sensor-package",spectrum="yellow",feed="fw-circuit-substrate",yield=3,cost=420,duration=18},
  {id="vulcanus-rare-metals-1",family="k2-galaxy",world="vulcanus",system="solaris",native={"tungsten-carbide"},k2={"kr-rare-metals"},product="fw-annealed-cermet",spectrum="red",feed="fw-cermet",yield=3,cost=420,duration=18},
  {id="gleba-biomass-2",family="k2-galaxy",world="gleba",system="nyxaris",native={"bioflux"},k2={"kr-biomass"},product="fw-resin",spectrum="green",feed="fw-nutrient-bed",yield=3,cost=420,duration=18},
  {id="fulgora-electronic-components-3",family="k2-galaxy",world="fulgora",system="vibrant",native={"holmium-plate"},k2={"kr-electronic-components"},product="fw-logic-matrix",spectrum="yellow",feed="fw-circuit-substrate",yield=3,cost=420,duration=18},
  {id="aquilo-lithium-4",family="k2-galaxy",world="aquilo",system="vespera",native={"ice"},k2={"kr-lithium"},product="fw-thermal-buffer",spectrum="purple",feed="fw-cermet",yield=3,cost=680,duration=20},
  {id="moshine-electronic-components-5",family="k2-galaxy",world="moshine",system="nyxaris",native={"optical-cable","silicon-cell"},k2={"kr-electronic-components"},product="fw-sensor-package",spectrum="purple",feed="fw-circuit-substrate",yield=3,cost=680,duration=20},
  {id="paracelsin-rare-metals-6",family="k2-galaxy",world="paracelsin",system="vibrant",native={"zinc-plate","electric-coil","zinc-rivet"},k2={"kr-rare-metals"},product="fw-reinforced-seal",spectrum="yellow",feed="fw-resin",yield=3,cost=680,duration=20},
  {id="rubia-steel-beam-7",family="k2-galaxy",world="rubia",system="vespera",native={"craptonite-frame","craptonite-plate","craptonite"},k2={"kr-steel-beam"},product="fw-foundry-lining",spectrum="red",feed="fw-ceramic-casing",yield=3,cost=680,duration=20},
  {id="linox-rare-metals-8",family="k2-galaxy",world="linox",system="beetlejuice",native={"rare-earth-powder","linox-rare-earth-powder","linox-science-pack"},k2={"kr-rare-metals"},product="fw-field-winding",spectrum="yellow",feed="fw-sensor-package",yield=3,cost=940,duration=22},
  {id="secretas-ai-core-9",family="k2-galaxy",world="secretas",system="beetlejuice",native={"gold-plate"},k2={"kr-ai-core"},product="fw-quantum-computer",spectrum="purple",feed="fw-logic-matrix",yield=3,cost=940,duration=22},
  {id="tenebris-charged-matter-stabilizer-10",family="k2-galaxy",world="tenebris",system="umbra",native={"chitosan"},k2={"kr-charged-matter-stabilizer"},product="fw-rift-stabilizer",spectrum="green",feed="fw-flux-lattice",yield=3,cost=940,duration=22},
  {id="vesta-imersium-plate-11",family="k2-galaxy",world="vesta",system="umbra",native={"supermagnet"},k2={"kr-imersium-plate"},product="fw-flux-phase-manifold",spectrum="purple",feed="fw-resonance-substrate",yield=3,cost=940,duration=22},
  {id="ferrum-rare-metals-12",family="k2-galaxy",world="ferrum",system="beetlejuice",native={"rare-earth-magnet","ferrum-rare-earth-magnet","ferrum-science-pack"},k2={"kr-rare-metals"},product="fw-field-winding",spectrum="red",feed="fw-cermet",yield=3,cost=1200,duration=24},
  {id="cerys-imersite-crystal-13",family="k2-galaxy",world="cerys",system="vibrant",native={"plutonium-239","cerys-science-pack","ceria-ore"},k2={"kr-imersite-crystal"},product="fw-stabilized-flux-crystal",spectrum="purple",feed="fw-sensor-package",yield=3,cost=1200,duration=24},
  {id="fulgora-imersite-crystal-14",family="k2-galaxy",world="fulgora",system="vibrant",native={"holmium-plate"},k2={"kr-imersite-crystal"},product="fw-flux-theory-science-pack",spectrum="purple",feed="fw-stabilized-flux-crystal",yield=3,cost=1200,duration=24},
  {id="aquilo-matter-cube-15",family="k2-galaxy",world="aquilo",system="vespera",native={"ice"},k2={"kr-matter-cube"},product="fw-planetary-convergence-science-pack",spectrum="purple",feed="fw-condensed-flux-matrix",yield=3,cost=1200,duration=24},
}
-- Alternative K2SO science-pack manufacture must not leapfrog the native
-- FluxWorks specialist-science research unlock.
for _,spec in ipairs(specs) do
  if spec.product=="fw-flux-theory-science-pack" then
    spec.science_unlock="fw-flux-theory-science"
  elseif spec.product=="fw-planetary-convergence-science-pack" then
    spec.science_unlock="fw-planetary-convergence-science"
  end
end
return register(specs,"fw-rp-k2so-galaxy-industry")
