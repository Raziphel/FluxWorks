# FluxWorks 0.5.0

**Independent industrial expansion for Factorio 2.1 / Space Age.**

FluxWorks is a complete, separately installable industrial mod built around four physical Flux disciplines, specialized machines, manufacturing chains, and its own research. **Razi Protocol is not required.** Installing Razi can enrich the experience with additional worlds and story, but the base factory game belongs to FluxWorks.

## The four disciplines

| Spectrum | Industrial specialty | Signature component |
| --- | --- | --- |
| Purple · Matter | Phase alignment, quantum manufacturing and resonance | Phase Alignment Wafer |
| Yellow · Chemistry | Catalysis, filtration and electronic materials | Catalytic Separation Membrane |
| Red · Thermal | Refractory metallurgy, thermal processing and power | Chromatic Thermal Core |
| Green · Biological | Regenerative cultures, bioengineering and recycling | Cultured Living Fiber |

All four build toward the **Convergence Chassis**, advanced machinery and the high-power Convergence Forge.

## What you can build

The Reborn factory profile authors 73 replacements for original FluxWorks manufacturing recipes, with simpler production bills and physically limited fluid ports. Eleven machine profiles, four tangible project upgrades, specialist research science, and a wide industrial materials roster form the mod's primary gameplay.

Four standalone industrial research programs offer **up to sixteen** additional high-throughput processes, guarded by real installed items, machines, labs and science packs. Each technology has its own visual identity in FluxWorksAssets. They are independent of Razi's chapters and research.

## Install

FluxWorks needs **Factorio 2.1 + Space Age** and its declared dependencies in [info.json](info.json), including **FluxWorksAssets >= 1.0.9** and **RaziLib >= 1.2.0**.

**Razi Protocol is optional and not listed as an ordering dependency.** K2SO is optional, too. Their respective integrations only activate where the required source prototypes actually exist.

## Vanilla and world ownership

The default world policy adds FluxWorks material deposits without deleting vanilla ores, suppressing enemies, or replacing map presets. Its Gleba culture process uses native iron and copper bacteria rather than editing stromatolite drops. Both policies have their own settings. World-generation settings generally affect newly generated terrain, not chunks already explored.

FluxWorks owns industrial manufacturing, specialized machinery, industrial research and factory runtime tools. Razi owns its galaxy, story, routes, chapters and victory. RaziLib supplies shared APIs. K2SO retains its own research and recipes.

Read [Standalone Architecture](docs/STANDALONE_ARCHITECTURE.md), [Galaxy Integration](docs/GALAXY_FACTORIES.md), and [Overhaul Validation](docs/OVERHAUL_VALIDATION.md) for the details.

**Development status:** Published to GitHub `main`, but not yet verified by a full Factorio load or old-save migration test. Treat 0.5.0 as an experimental build until those checks succeed.
