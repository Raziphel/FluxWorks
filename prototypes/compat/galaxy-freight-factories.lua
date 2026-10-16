-- Pair two source planets for optional physical freight manufacturing.
-- Conditional recipes never change planets, source items, native crafting, or Razi tech.
local register=require("prototypes.compat.galactic-industry-framework").register
local specs={
  {id="vulcanus-gleba-freight",family="freight",world="vulcanus",secondworld="gleba",native={"tungsten-carbide"},second_native={"bioflux"},product="fw-annealed-cermet",spectrum="red",partner="yellow",feed="fw-cermet",yield=3,cost=500,duration=18},
  {id="fulgora-moshine-freight",family="freight",world="fulgora",secondworld="moshine",native={"holmium-plate"},second_native={"optical-cable"},product="fw-resonance-substrate",spectrum="yellow",feed="fw-circuit-substrate",yield=3,cost=500,duration=18},
  {id="paracelsin-moshine-freight",family="freight",world="paracelsin",secondworld="moshine",native={"zinc-plate"},second_native={"optical-cable"},product="fw-sensor-package",spectrum="yellow",feed="fw-circuit-substrate",yield=3,cost=500,duration=18},
  {id="aquilo-vulcanus-freight",family="freight",world="aquilo",secondworld="vulcanus",native={"ice"},second_native={"tungsten-carbide"},product="fw-thermal-buffer",spectrum="purple",partner="yellow",feed="fw-ceramic-casing",yield=3,cost=500,duration=18},
  {id="secretas-linox-freight",family="freight",world="secretas",secondworld="linox",native={"gold-plate"},second_native={"rare-earth-powder","linox-rare-earth-powder"},product="fw-quantum-computer",spectrum="purple",feed="fw-logic-matrix",yield=3,cost=740,duration=20},
  {id="tenebris-gleba-freight",family="freight",world="tenebris",secondworld="gleba",native={"chitosan"},second_native={"bioflux"},product="fw-flux-phase-manifold",spectrum="green",feed="fw-resonance-substrate",yield=3,cost=740,duration=20},
  {id="vesta-linox-freight",family="freight",world="vesta",secondworld="linox",native={"supermagnet"},second_native={"rare-earth-powder","linox-rare-earth-powder"},product="fw-rift-stabilizer",spectrum="purple",partner="yellow",feed="fw-resonance-substrate",yield=3,cost=740,duration=20},
  {id="rubia-paracelsin-freight",family="freight",world="rubia",secondworld="paracelsin",native={"craptonite-frame","craptonite-plate"},second_native={"zinc-plate"},product="fw-composite-panel",spectrum="red",feed="fw-foundry-lining",yield=3,cost=740,duration=20},
  {id="ferrum-fulgora-freight",family="freight",world="ferrum",secondworld="fulgora",native={"rare-earth-magnet","ferrum-rare-earth-magnet"},second_native={"holmium-plate"},product="fw-field-winding",spectrum="yellow",feed="fw-cermet",yield=3,cost=980,duration=22},
  {id="maraxsis-tenebris-freight",family="freight",world="maraxsis",secondworld="tenebris",native={"maraxsis-sand","maraxsis-salvage"},second_native={"chitosan"},product="fw-reinforced-seal",spectrum="green",partner="yellow",feed="fw-resin",yield=3,cost=980,duration=22},
  {id="cubium-secretas-freight",family="freight",world="cubium",secondworld="secretas",native={"cube","cubium-cube"},second_native={"gold-plate"},product="fw-logic-matrix",spectrum="purple",feed="fw-sensor-package",yield=3,cost=980,duration=22},
  {id="moshine-paracelsin-freight",family="freight",world="moshine",secondworld="paracelsin",native={"optical-cable"},second_native={"zinc-plate"},product="fw-circuit-substrate",spectrum="yellow",feed="fw-metal-mesh",yield=3,cost=980,duration=22},
}
return register(specs,"fw-rp-interplanetary-factories")
