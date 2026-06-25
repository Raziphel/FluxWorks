# Late-Game Flux Utility Plan

This is the recommended FluxWorks-native take on three reference mods:

- Deep Storage Unit
- Fluid Memory Storage
- Telogistics

The goal is not to clone them literally. The goal is to make the same late-game fantasy feel like it belongs to FluxWorks, Space Age, and the current promethium-era progression.

## Stronger Integration Rules

If we want these to feel properly native, they need to obey FluxWorks' existing late-game language instead of behaving like imported utility blocks.

### 1. Each feature should belong to a real Flux discipline

- Phase Vaults belong to phase engineering, electromagnetic control, and promethium-safe containment.
- Spectral Reservoirs belong to thermal networks, cryochemistry, and sealed chemical handling.
- Rift Exchange belongs to convergence, harmonics, and cross-planet endgame infrastructure.

That means they should not all use the same ingredient logic with different art. Each needs a distinct branch identity.

### 2. Each feature should consume the correct Flux colors

- Purple: phase alignment, crystal ordering, anchor stability.
- Yellow: control, chemistry, and filter discipline.
- Red: transfer energy, compression force, burst-cycle transport.
- Green: recovery, buffer smoothing, and reduced waste on stabilized systems.

This matters because the current mod already treats the colors as meaningful lanes. These buildings should reinforce that, not flatten it.

### 3. These should be a utility family, not one-off capstones

The best version is a small late-game hardware family with:

- shared intermediates
- shared tab placement
- shared runtime helpers
- distinct jobs

That gives the player a proper "Flux infrastructure" layer after synthesis instead of three unrelated rewards.

## Reference Behaviors

### Deep Storage Unit

- One structure stores one item type.
- Effective capacity is infinite.
- Power draw scales upward with stored amount.
- The entity keeps a normal front inventory and compresses overflow into script state.
- On mining, the stored payload is preserved in an item-with-tags wrapper.
- It exposes the stored item and count to circuits.

### Fluid Memory Storage

- Same idea, but for one fluid.
- Keeps a real tank front buffer and stores overflow in script state.
- Power scales with stored amount.
- Carries temperature data.
- Circuit output reports the fluid and stored amount.

### Telogistics

- Cross-planet item movement after Space Age setup.
- Very high burst power cost.
- The mod's core behavior is "exchange inventories after a charge cycle."

## Best FluxWorks-Native Interpretation

### 1. Deep item storage should become `Phase Vaults`

Do not present this as generic "memory storage." Make it a Flux phase-compression machine.

Why this fits:

- FluxWorks already has `fw-flux-phase-manifold`, `fw-rift-stabilizer`, `fw-em-core`, and `fw-logic-matrix`.
- That gives us a believable late-game answer to "how are these items stored?"
- It also keeps the feature aligned with your current synthesis/convergence ladder instead of feeling like a random warehouse replacement.

Recommended concept:

- `fw-phase-vault`: stores one item type, effectively infinite.
- Visual language: sealed cermet pressure body, field coils, gauge cluster, heavy phase-ring accents.
- UX: chest-like access with a custom readout later if we want, but the first pass can ship with standard GUI plus circuit reporting.

Better integration direction:

- Treat this as matter compression, not warehousing.
- It should be best at dense high-value late-game items, not just "bigger chest."
- Its recipe should lean hardest into Purple, Electromagnetic, and Convergence-era hardware.

How it should work:

- Keep a real chest inventory as the front buffer.
- Keep overflow in `storage.phase_vaults[unit_number]`.
- Use a hidden `electric-energy-interface` for dynamic power draw.
- Use a hidden combinator for circuit output.
- Preserve contents on mining via `item-with-tags`.

Recommended twist versus the reference mod:

- Make power loss freeze compression and extraction above the front buffer instead of deleting or scrambling data.
- Make spoilable items invalid for storage. That keeps the mechanic clean and avoids weird late biological exploits.
- Give the vault a compression comfort band tuned around stack size so it behaves well with late-game dense components and still feels grounded.

### 2. Deep fluid storage should become `Spectral Reservoirs`

Do not ship this as just "infinite tank." Make it a stabilized multi-phase fluid retention system.

Why this fits:

- Fluids are already a big part of the Yellow/Red/Aquilo chain.
- `fw-flow-regulator`, `fw-thermal-buffer`, `fw-pressure-housing`, and `fw-cryo-coil` already imply serious fluid-control hardware.
- Temperature-sensitive storage becomes a real late-game reason to use FluxWorks hardware instead of just bigger tanks.

Recommended concept:

- `fw-spectral-reservoir`: stores one fluid, effectively infinite.
- Carries fluid temperature in script state.
- Uses a normal fluidbox as a front buffer, just like the reference mod.

Better integration direction:

- Treat this as a stabilized retention system for advanced chemistry, cryogenics, and promethium-adjacent fluids.
- It should be clearly more aligned with Aquilo and Yellow/Red process control than with generic petrochem expansion.

How it should work:

- Keep a real tank front volume.
- Push overflow into `storage.spectral_reservoirs[unit_number]`.
- Retain the weighted average temperature of stored contents.
- Lock the fluid filter once the first fluid enters.
- Circuit output reports fluid + amount.

Recommended twist versus the reference mod:

- Add a higher idle power floor for very hot/very cold fluids.
- Give it stronger synergy with late cryogenic and promethium recipes, so it feels like specialized infrastructure rather than a void substitute.
- Make it explicitly better for volatile or high-throughput late fluids such as fluoroketone, cryogenic blends, electrolyte, and conditioned Flux fluids.

### 3. Telogistics should become `Rift Exchange`, not full inventory swap

This is the biggest place where we should not copy the reference mod directly.

The "swap both inventories after 20 seconds" behavior is clever, but it feels like another mod's gimmick. FluxWorks should do directed packet transfer instead.

Recommended concept:

- `fw-rift-exchange-gate`: a paired cross-surface item teleporter.
- It sends packets from source to destination instead of swapping the whole inventories.
- It should be extremely power hungry and intentionally slower than local logistics, but dramatically easier than endless rocket micromanagement once you are deep into the endgame.

Better integration direction:

- Treat this as post-platform logistics infrastructure, not a replacement for the orbital phase.
- The reward is "I solved every planet, now my network behaves like one factory."
- It should feel like the final expression of `fw-rift-harmonics`, not a convenience addon.

Why this is the better version:

- It feels more like rift harmonics and phase-coherent matter transport.
- It avoids weird edge cases where a destination accidentally sends junk back.
- It creates room for better throughput tiers, filters, and circuit control later.

How it should work:

- Each gate has a pairing/channel setting.
- Each gate has a local chest inventory.
- On cycle completion, the source sends a limited packet to the destination.
- If the destination cannot accept the packet, the cycle aborts cleanly and keeps the items at the source.
- Circuits can control enable/disable, packet size cap, and maybe priority channel later.

Recommended FluxWorks flavor:

- A gate should need a stable rift anchor on both surfaces.
- Packet transfer cost should scale with stack count and maybe with quality tiers if you want quality-aware handling later.
- The first version should be items only. Fluids can stay local to the reservoir system for now.
- It should prefer manufactured and science-chain cargo, not bulk ore movement, by design of throughput and power cost.

## Planetary And Branch Ownership

This family gets much stronger if each building clearly "belongs" to the right planet rewards and branch hardware.

### Phase Vault ownership

Primary ties:

- Fulgora
- Aquilo
- Flux phase engineering

Why:

- Fulgora gives the electromagnetic hardware and field-control feel.
- Aquilo gives the containment and stability feel.
- Purple Flux and phase manifolds explain the compression fantasy.

### Spectral Reservoir ownership

Primary ties:

- Aquilo
- chemical synthesis
- thermal networks

Why:

- Temperature retention is a real late-game differentiator.
- This is where `fw-thermal-buffer`, `fw-cryo-coil`, and `fw-flow-regulator` become infrastructure instead of just recipe fillers.

### Rift Exchange ownership

Primary ties:

- all-planet convergence
- promethium stabilization
- rift harmonics

Why:

- This is the one that should only exist after the player has already proven every planetary branch.
- It should consume the most "whole-mod" late hardware of the three.

## Recommended Unlock Timing

These should not all unlock together.

### `fw-deep-phase-storage`

Unlock timing:

- After `fw-flux-synthesis`
- After `fw-superconductive-systems`
- After `fw-electromagnetic-architecture`

Why:

- This makes item compression a serious post-Fulgora/Aquilo utility reward.
- It lands after the player already has real factory scale and circuit expectations.

Science profile:

- Space science
- Electromagnetic science
- Cryogenic science

More integrated prerequisite recommendation:

- `fw-flux-synthesis`
- `fw-superconductive-systems`
- `fw-electromagnetic-architecture`
- `fw-flux-phase-engineering`

### `fw-spectral-fluid-retention`

Unlock timing:

- After `fw-deep-phase-storage`
- After `fw-aquilo-cryochemistry`
- After `fw-flux-thermal-networks`

Why:

- Fluid memory should come after the player already has the heat and cryo infrastructure to justify it.
- This keeps it from trivializing earlier petrochem and basic tank design.

Science profile:

- Space science
- Electromagnetic science
- Cryogenic science

More integrated prerequisite recommendation:

- `fw-deep-phase-storage`
- `fw-aquilo-cryochemistry`
- `fw-flux-thermal-networks`
- `fw-flux-chemical-synthesis`

### `fw-rift-logistics`

Unlock timing:

- After `fw-flux-convergence`
- After `fw-fusion-lattices`
- After `fw-rift-harmonics`
- Require `promethium-science-pack`

Why:

- This is the real "after several planets" reward.
- Cross-planet teleport logistics should be one of the capstone payoffs of the FluxWorks tree, not a convenience unlock in early orbital play.

Science profile:

- Space science
- Metallurgic science
- Agricultural science
- Electromagnetic science
- Cryogenic science
- Promethium science

More integrated prerequisite recommendation:

- `fw-flux-convergence`
- `fw-fusion-lattices`
- `fw-rift-harmonics`
- `fw-promethium-stabilization`
- `promethium-science-pack`

## New Intermediates To Add

These should be shared by the new buildings so the feature family feels cohesive.

### `fw-phase-anchor`

Purpose:

- The spatial stabilization heart for storage and teleport systems.

Suggested ingredients:

- `fw-flux-phase-manifold`
- `fw-rift-stabilizer`
- `fw-pressure-housing`
- `supercapacitor`

Use in:

- Phase Vault
- Rift Exchange Gate

Flux identity:

- Purple-heavy
- phase/coherence hardware

### `fw-entanglement-core`

Purpose:

- The control/telemetry brain for paired or compressed systems.

Suggested ingredients:

- `fw-em-core`
- `fw-logic-matrix`
- `fw-signal-conduit`
- `quantum-processor` or fallback quantum component

Use in:

- Phase Vault
- Spectral Reservoir
- Rift Exchange Gate

Flux identity:

- Yellow control
- Fulgora/Aquilo bridge hardware

### `fw-reservoir-lining`

Purpose:

- Specialized containment hardware for high-stress fluids.

Suggested ingredients:

- `fw-thermal-buffer`
- `fw-flow-regulator`
- `fw-ceramic-casing`
- `fw-rubber-sheet`

Use in:

- Spectral Reservoir

Flux identity:

- Yellow and Red process discipline
- Aquilo thermal control

### `fw-rift-coupler`

Purpose:

- The final late-game transport component that makes the teleporter feel distinct from storage.

Suggested ingredients:

- `fw-phase-anchor`
- `fw-entanglement-core`
- `fw-promethium-matrix`
- `fw-field-winding`

Use in:

- Rift Exchange Gate

Flux identity:

- endgame convergence hardware
- promethium/rift bridge component

### `fw-compression-baffle`

Purpose:

- The dedicated item-phase handling part that makes vaults feel different from tanks and teleporters.

Suggested ingredients:

- `fw-flow-regulator`
- `fw-flux-lattice`
- `fw-pressure-housing`
- `fw-sensor-diode`

Use in:

- Phase Vault

### `fw-thermal-phase-gasket`

Purpose:

- A crossover sealing part for fluid retention and rift-safe transport machinery.

Suggested ingredients:

- `fw-rubber-sheet`
- `fw-thermal-buffer`
- `fw-ceramic-insulator`
- `fw-flow-regulator`

Use in:

- Spectral Reservoir
- Rift Exchange Gate

## Recommended Entity Recipes

### `fw-phase-vault`

Recipe direction:

- `steel-chest` or `logistic-chest-storage`
- `fw-phase-anchor`
- `fw-entanglement-core`
- `fw-compression-baffle`
- `fw-pressure-housing`
- `fw-power-regulator`
- `superconductor`

Notes:

- Large, expensive, and clearly post-planetary.
- One item type only.
- Make this a meaningful sink for `fw-logic-matrix` and `fw-em-core`, because this is the first utility feature where those items should feel like infrastructure rather than recipe garnish.

### `fw-spectral-reservoir`

Recipe direction:

- `storage-tank`
- `fw-reservoir-lining`
- `fw-entanglement-core`
- `fw-thermal-phase-gasket`
- `fw-thermal-buffer`
- `fw-cryo-coil`
- `supercapacitor`

Notes:

- Slightly smaller than the item vault is fine.
- Stronger Aquilo tie-in than the item vault.
- This is a good place to spend `fw-flow-regulator` in quantity so the part stays relevant all the way into the endgame.

### `fw-rift-exchange-gate`

Recipe direction:

- `space-platform-hub` should not be a direct ingredient, but this should feel almost that expensive.
- `fw-rift-coupler`
- `fw-phase-anchor`
- `fw-entanglement-core`
- `fw-thermal-phase-gasket`
- `fw-promethium-matrix`
- `fusion-reactor-equipment`
- `superconductor`
- `quantum-processor`

Notes:

- This wants to feel like endgame infrastructure, not a better requester chest.
- It should probably consume more than one `fw-rift-coupler` so the teleporter family has a real apex intermediate sink.

## Family-Wide Recipe And Balance Integration

These buildings will feel more native if they also reshape surrounding late-game recipes instead of sitting off to the side.

### Phase Vault downstream integration

Once Phase Vaults exist, add selective recipe-tweak hooks to make them appear in extreme-scale logistics surfaces, not everywhere.

Best targets:

- `space-platform-hub`
- `cargo-bay`
- highest-tier logistic chest surfaces if appropriate
- a small number of promethium-era science or machine recipes where compressed material handling makes sense

Do not push them into ordinary belts/inserters/chests.

### Spectral Reservoir downstream integration

Best targets:

- advanced fluoroketone/cryogenic hardware
- endgame fluid-handling machines
- selected synthesis/condenser recipes that imply serious containment

Do not sprinkle them into basic tank, pipe, or refinery progression.

### Rift Exchange downstream integration

Best targets:

- space-facing infrastructure only
- maybe one or two endgame platform logistics recipes
- any future FluxWorks late orbital/planetary logistics entity family

Do not make it a generic ingredient in random machines.

## Tab And Group Routing

There is already a useful split in the current mod:

- `fw-flux-systems`
- `fw-flux-exchange`
- fabrication subgroups

Use that instead of inventing a new tab family.

Recommended routing:

- shared late intermediates like `fw-phase-anchor` and `fw-entanglement-core` -> `fw-flux-systems`
- teleport-only parts like `fw-rift-coupler` -> `fw-flux-exchange`
- `fw-phase-vault`, `fw-spectral-reservoir`, `fw-rift-exchange-gate` -> `fw-flux-exchange`

That makes the exchange subgroup become a real late utility destination instead of a mostly empty placeholder.

## Runtime Design That Feels More Native

The reference mods give the right implementation skeleton, but FluxWorks should add stronger identity in runtime behavior.

### Phase Vault runtime identity

- compresses inventory overflow into phase-held count
- front buffer remains visible and practical
- idle drain is meaningful, but scaling draw is driven mostly by stored mass volume
- optional later upgrade: better compression efficiency if powered by a strong late electrical network

### Spectral Reservoir runtime identity

- stores amount plus retained temperature
- idles at a nontrivial stabilization draw
- hotter or colder fluids add extra stabilization load
- if unpowered, the reservoir should stop moving long-range volume, but not destroy the stored state

### Rift Exchange runtime identity

- burst-cycle machine with a charge bar feel
- validates target, inventory room, and power before transfer
- transfers directed packets, not mirrored swaps
- can later support channelized logistics policy without changing the core machine fantasy

## Runtime Implementation Strategy

### Keep the storage pattern from the reference mods

The reference item/fluid memory mods already use the right broad runtime pattern:

- normal playable front buffer
- overflow stored in script state
- hidden power entity
- hidden combinator
- preservation tags on mining
- distributed updates across ticks

That is still the best technical base for FluxWorks.

### But do not dump all of this into the current `control.lua`

Recommended structure:

- `control.lua`
- `scripts/phase-vaults.lua`
- `scripts/spectral-reservoirs.lua`
- `scripts/rift-exchange.lua`
- `scripts/shared-power.lua`
- `scripts/shared-circuit.lua`

`control.lua` should just require/register modules and keep the existing rocket-remnant logic intact.

### Storage power model

Recommended formula shape:

- base idle draw
- plus scaled growth from stored amount
- plus optional thermal surcharge for reservoirs

Suggested philosophy:

- cheap enough to feel useful once unlocked
- expensive enough that "infinite" still means infrastructure commitment

I would keep the same broad nonlinear idea as the reference mods, but tune the constants much higher because these are late-game FluxWorks buildings.

### Rift Exchange power model

This should use burst energy per transfer cycle, not just passive drain.

Recommended first-pass behavior:

- gate charges over time
- if full power is available and a valid destination exists, transfer one packet
- packet size is limited by machine tier and energy budget
- no packet means no drain beyond idle stabilization

That will feel much better than a giant always-on drain.

## Pairing And UX Recommendations For `Rift Exchange`

The first version should stay simple.

### Pairing

Use a channel integer or string tag.

- gates with the same channel can pair
- each force owns its own network
- if more than one valid destination exists, use a deterministic priority rule instead of random selection

Best first-pass priority:

- same channel
- same force
- lowest unit number or earliest built destination

### Inventory behavior

Use directional transfer, not exchange.

Best first-pass rules:

- source pulls from its own inventory
- destination inserts into its own inventory
- overflow aborts cleanly
- no lossy teleportation

### Circuit behavior

First pass:

- read current paired state
- read packet count waiting
- enable/disable

Second pass later:

- set packet size by signal
- multi-destination priority routing

### Better first-pass circuit identity

Even in v1, the gates and storage should expose useful state:

- stored type
- stored amount
- powered / starved state
- paired / unpaired state for Rift Exchange
- charging / ready state for Rift Exchange

That is much more FluxWorks-native than a passive black-box teleporter.

## Factoriopedia, Locale, And Surface Consistency

These should launch with the same level of player-facing support as the newer FluxWorks machines.

Needed surfaces:

- locale names and descriptions
- recipe descriptions that explain the branch fantasy, not just the function
- technology descriptions that name the planetary reward logic
- Factoriopedia simulation entries for at least the Phase Vault and Rift Exchange Gate

The wording should mirror the rest of the mod:

- industrial
- branch-specific
- not jokey
- not generic sci-fi

## Startup Setting And Difficulty Interaction

These should respect the existing balance philosophy.

Recommended interaction:

- normal difficulty: standard costs
- hard difficulty: stronger late-machine and exchange hardware pressure
- easy difficulty: mainly reduce intermediate counts, not remove the branch identity

These do not need separate startup toggles in the first pass unless you want one explicit `fw-enable-rift-logistics` gate for players who prefer pure rocket logistics.

## Exact Repo Seams To Use

For a truly integrated implementation, the first coding pass should touch more than just one item file.

Data stage:

- `prototypes/items/flux-systems.lua`
- `prototypes/recipes/flux-systems.lua`
- `prototypes/technology/flux-systems.lua`
- likely a new `prototypes/entities/late-utility.lua`
- `prototypes/updates/crafting-tabs.lua`
- `prototypes/updates/recipe-tweaks.lua`
- `prototypes/updates/progression-gates.lua`
- `locale/en/base.cfg`

Control stage:

- keep `control.lua` thin
- add dedicated scripts for storage/exchange families
- share power/circuit helpers across the three systems

This is important because the feature will feel more integrated if it lands through the same routing, gating, and descriptive seams as the rest of FluxWorks.

## What Not To Do

- Do not unlock any of these before `fw-flux-synthesis`.
- Do not make Telogistics fluid-capable in the first pass.
- Do not make storage work for spoilage or mixed item types.
- Do not copy the inventory-swap teleporter behavior unless testing proves directional transfer is too awkward.
- Do not treat these as vanilla-tab logistics toys; route them through FluxWorks late systems and space-facing grouping.

## Best Build Order

If we implement this in stages, the best order is:

1. `fw-deep-phase-storage`
2. `fw-spectral-fluid-retention`
3. `fw-rift-logistics`

Why:

- Item storage gives the biggest immediate quality-of-life payoff.
- Fluid storage reuses most of the same backend pattern with temperature handling added.
- Rift logistics is the most design-sensitive and should come after the storage runtime helpers are proven.

## Recommended Next Implementation Pass

The next coding pass should do only the item-storage family:

- add the new intermediates
- add `fw-deep-phase-storage`
- add `fw-phase-vault`
- add tab routing and locale
- add modular control-stage support for one-item-type infinite storage
- add at least one selective recipe-tweak integration target so the family is not isolated

Once that is validated in-game, reuse the same runtime skeleton for the fluid version.
