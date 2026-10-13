# FluxWorks

FluxWorks is a Space Age industrial expansion built around specialized production, advanced manufacturing, and the four Flux spectra. It can run as its own expansion or alongside Razi Protocol.

**The idea:** build interesting factories, not another mandatory technology overhaul. Industrial components and dedicated machines have their own uses; the four Flux spectra become a new manufacturing language rather than a replacement for every other mod's recipes.

## The four Flux spectra

| Spectrum | Focus |
| --- | --- |
| Purple (matter) | Matter extraction, stabilization, phase systems |
| Yellow (chemical) | Processing, recovery, precision chemistry |
| Red (fuel) | High-energy synthesis, metallurgy, thermal processes |
| Green (biological) | Bioprocessing, renewable materials, cultivation |

FluxWorks includes quarrying, purification, advanced industrial machines, synthesizers, phase reservoirs, and late logistics. Standalone FluxWorks still has its own extended Shattered Planet expedition and finale.

## Industrial Project machine upgrades

The four existing Industrial Project researches now unlock buildable improvements to core FluxWorks machines: an **Industrial Flux Harvester**, **Precision Synthesis Plant**, **Chromatic Arc Foundry**, and the endgame **Convergence Synthesis Plant**.

All four upgrades consume their predecessor machines, retain compatible footprints and fluid ports, and work with the regular Factorio upgrade planner. They demand more power in exchange for throughput and module capacity, without adding another science branch or any scripted runtime overhead. The upgraded Industrial Harvester also supports quality modules for premium material recovery.

See [Industrial Machine Upgrades](docs/INDUSTRIAL_MACHINE_UPGRADES.md) for the complete upgrade ladder and safety checks.

## Spectrum Industries: fourteen factory alternatives

Matter, Chemical, Fuel, and Biological Flux now each power three optional industrial processes, from superconductor alignment and sensor photolithography to renewable resin, bioflux, rocket propellant, and steel. Two late Chromatic processes consume **two different Flux spectra** and reward cross-system logistics.

These recipes use the existing **Synthesis Plant** and **Arc Foundry**, unlock through technologies already in FluxWorks, and carry small coloured Flux emblems for easy recognition. No extra science packs or disposable intermediate items were added.

See [Spectrum Industries](docs/SPECTRUM_INDUSTRIES.md) for the fourteen processes, machines, unlocks, and balancing rules.

## With Razi Protocol

Razi Protocol owns the galaxy, research chapters, planetary entry, starmap, and overall victory. FluxWorks provides the industrial machinery.

When both mods are installed, the companion profile activates automatically:
- The original Shattered Planet **remains a space location**. FluxWorks does not replace it with its standalone landable world.
- Razi keeps its victory system. FluxWorks does not register its independent Origin Singularity victory handler.
- Razi keeps planet/resource identities and standard Nauvis ores. FluxWorks adds its introductory Flux and mixed deposits on Nauvis without globally scattering its deposits over every modded planet.
- Razi keeps global platform physics, spoilage rules, asteroid pressure, and space logistics tuning.
- FluxWorks does not replace the main-menu simulations or starter loadout.
- Rift Exchange is restricted until **Outer Frontier Mastery** in Razi, so it cannot replace early interstellar logistics.

Razi adds chapter-sensitive alternatives to FluxWorks' existing production branches and keeps its four domain science packs for *optional specialist mastery*. Regular FluxWorks engineering does not need four additional mandatory science pipelines in this mode.

See [Razi Protocol companion details](docs/RAZI_PROTOCOL.md).

## Standalone gameplay

Standalone behaviour remains unchanged unless a setting is explicitly modified. The original Shattered Planet, starting scenario, victory, and research are retained.

## Compatibility and existing saves

Do **not** add or remove either mod on an important save without a backup. In particular, a standalone FluxWorks save with an already generated, landable Shattered Planet should not be assumed to migrate safely into the Razi companion profile, because that destination retains the original space-location identity instead.

This code is pending a full Factorio 2.1 load test with the full Razi mod list. Check the prototype graph and both a new world and a copy of an existing save before release.
