# Spectrum Industries

FluxWorks is not another campaign. The reward for its progression is getting to build factories which do things ordinary machines cannot.

**Spectrum Industries** adds fourteen alternative industrial processes to existing FluxWorks machines. They do not introduce a new science pack, material tier, or technology branch. Each is unlocked by a **pre-existing** engineering technology, and all are optional.

## How it looks in the factory

Recipe icons reuse their product's normal icon with small, coloured Flux emblems:
- **Purple, Matter Flux:** electronics, superconductors, resonance lattices.
- **Yellow, Chemical Flux:** plastic, batteries, precision sensors.
- **Red, Fuel Flux:** steel, lightweight aerospace structures, rocket propellant.
- **Green, Biological Flux:** resin recovery, carbon fibre, renewable bioflux.
- **Chromatic, dual-spectrum:** late cermet and resonance production using two different Flux supplies.

Single-colour recipes have one coloured emblem. Dual-spectrum recipes have two. These overlays use graphics already in FluxWorksAssets.

## Production list

| Spectrum | Process | Machine | Source technology |
| --- | --- | --- | --- |
| Purple | Circuit Annealing | Synthesis Plant | Flux Phase Engineering |
| Purple | Superconductor Alignment | Synthesis Plant | Superconductive Systems |
| Purple | Flux Lattice Weaving | Synthesis Plant | Flux Resonance |
| Yellow | Catalytic Polymerization | Synthesis Plant | Flux Chemical Synthesis |
| Yellow | Battery Electroforming | Synthesis Plant | Fulgora Electrochemistry |
| Yellow | Sensor Photolithography | Synthesis Plant | Sensor Integration |
| Red | Arc Steel Reduction | Arc Foundry | Flux Metallurgy |
| Red | Structural Flux Casting | Arc Foundry | Vulcanus Industrial Symbiosis |
| Red | Propellant Intensification | Synthesis Plant | Propellant Synthesis |
| Green | Resin Bioreclamation | Synthesis Plant | Green Cultivation |
| Green | Carbon Fiber Cultivation | Synthesis Plant | Gleba Regenerative Symbiosis |
| Green | Bioflux Fermentation | Synthesis Plant | Green Propagation |
| Red + Yellow | Chromatic Cermet | Arc Foundry | Cross-Planetary Industrial Convergence |
| Purple + Green | Chromatic Resonance | Synthesis Plant | Cross-Planetary Industrial Convergence |

Every process uses the original item's prototype and an existing machine's crafting category. There are **no new intermediate item IDs**. All recipes are optional alternatives: the canonical production route remains valid.

## Balancing rules

- Every bonus has a cost in Flux fluid, industrial material, or both.
- No recipe accepts more than **two different fluid inputs**, matching the existing Arc Foundry and Synthesis Plant plumbing.
- The processes have `allow_productivity = false`, to avoid excessive multiplier stacking with existing quality, research, and K2SO effects.
- The final two Chromatic methods require Cross-Planetary Industrial Convergence. They are rewards for sharing materials, not a requirement to leave a system.
- K2SO item aliases are resolved when prototypes are created. Missing products or inputs cause just that alternative to be skipped, rather than a whole-mod startup failure.
- Recipe registration is one data-stage pass. There are no new entities, ticks, event handlers, or background scans.
- The recipes are registered after FluxWorks' extraction valuation stage, so the item valuation/recovery solver cannot treat these subsidized production alternatives as a new raw-value baseline.

## Razi Protocol

Razi continues to own the planet gates, routes, chapters, and main victory. The new processes slot into its existing FluxWorks industrial research; several planetary technologies are already connected to the corresponding Razi system discovery.

These should be treated as a second route for a resource, not a substitute for interplanetary shipping, planetary science, or unlocking a destination.

## Developer checks

The quick mock-prototype test can be run without Factorio:

```sh
lua tests/lua/test_spectrum_industries.lua
```

Before release, use the full Factorio 2.1 + K2SO + Razi modset to check every recipe, chemistry input, machine selection, and research unlock in-game. **Do not rely on a static test alone.** Test both companion and standalone saves on disposable copies.
