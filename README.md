# FluxWorks 0.3 · Industrial Extension for Razi Protocol

**Razi Protocol owns the galaxy. FluxWorks builds the factories that make it worth exploring.**

FluxWorks now **requires Razi Protocol 2.1.118+**, Factorio 2.1/Space Age, K2SO through Razi's curated pack, and FluxWorksAssets. It is installed separately: Razi alone remains playable and must not list FluxWorks as an optional dependency, because the reverse edge causes a dependency cycle.

## Four engineering spectra

| Spectrum | Specialty | Factory payoff |
| --- | --- | --- |
| **Matter · Purple** | phase stabilization, advanced lattice and conductive fabrication | compact advanced industrial components |
| **Chemical · Yellow** | processing, reclamation, high-precision material handling | cleaner recovery and specialized electronics |
| **Fuel · Red** | metallurgy, high-temperature chemistry and propellant | power-hungry high-output foundries |
| **Biological · Green** | regenerative processing and biopolymer cultures | renewable feedstocks and waste recovery |

## Your factory's industrial career

1. **Early industry:** mine and crush material, sort ore, establish mechanical foundations; no replacement of Razi's early chapter or default Nauvis resource profiles.
2. **Specialized engineering:** produce four Flux fluids, pressure and control components, and the core Flux Harvester, Synthesis Plant and Arc Foundry.
3. **Production alternatives:** fourteen existing Spectrum Industries processes and **eight new industrial foundry routes** when Expanded depth is selected.
4. **Regional mastery:** Razi's seven optional industrial specialties in Calidus, Solaris, Nyxaris, Vibrant, Vespera, Beetlejuice and Umbra.
5. **Paired factories:** five Razi-owned cross-system exchanges and four upgradeable Industrial Project machines, ending with Convergence Synthesis.

Manufacturing alternatives consume actual materials and power; they do not create resources from nothing, replace native recipes, or gate planet access. All `fw-` and `razi-fw-` IDs are kept stable. The existing four domain science packs remain specialist research, not an extra mandatory path through Razi's story.

## New settings

- **Industrial depth: Core / Expanded.** Core keeps the existing fourteen Spectrum Industries processes. Expanded adds eight new, guarded alternatives. Default: Expanded.
- **Industrial power: Efficient / Standard / Demanding.** Adjusts power use only for the four Industrial Project machine upgrades. Default: Standard.

Historical settings and their IDs remain registered so saved configurations do not silently disappear; Razi has final authority over global resource placement, asteroid pressure, platform drag, spoilage, route progression, main menu and victory.

## Engine and asset boundaries

The extension runtime registers only industry modules (rockets/remnants, phase vaults, spectral reservoirs, Flux extractor and Rift Exchange). Old FluxWorks starting scenarios, Shattered Planet world hooks and standalone victory handlers are not loaded. Historical standalone-only prototypes remain defined where possible to reduce missing-ID save risks, but this does **not** guarantee old standalone save migration.

See [Razi ownership and migration](docs/RAZI_PROTOCOL.md), [new industrial processes](docs/INDUSTRIAL_EXTENSION.md), [existing Spectrum Industries](docs/SPECTRUM_INDUSTRIES.md), [machine upgrades](docs/INDUSTRIAL_MACHINE_UPGRADES.md), and [third-party compatibility API](COMPATIBILITY_API.md). FluxWorksAssets has separate [art direction](https://github.com/Raziphel/FluxWorksAssets/blob/overhaul/razi-industrial-extension/docs/ART_DIRECTION.md).

## Release policy

This is a development branch, **not a published compatibility guarantee**. Run source tests, then start a full Factorio 2.1 + Razi Dev + FluxWorks 0.3 + Assets + K2SO pack. Validate recipes, tech graph, Shattered Planet space-location identity, regional Codex previews, Rift Exchange gating, sprite references, and disposable copies of important saves before release.

## Industrial Projects 0.3.1

The four upgrade-planner-compatible machines now have **four distinct new emblems** shipped in Assets 1.0.5: drill head, reaction network, furnace crucible, and four-way convergence. They replace stacked spectrum color spots without modifying any placed machine's sprite sheet, footprint, or fluid ports. The final Convergence Synthesis Plant can craft both synthesis and Arc Foundry recipes by default (opt-out). Project research, existing manufacturing process tempo, and upgrade electricity usage have separate user-selectable settings. No global campaign progression, hazard or science costs are modified by these controls.

Gleba specialist bacteria now have six native-bacteria seeding recipes and no longer change natural stromatolite drops in Razi-hosted mode. This preserves the source planet's loot curves while retaining FluxWorks cultivation. See [World ownership](docs/RAZI_PROTOCOL.md).

### No surprise global edits

The old opt-in asteroid crushing and Fulgora scrap patches are disabled when Razi Protocol is present, even if legacy settings were stored as enabled. Obsolete standalone Shattered expedition research is quietly hidden only when the finished technology graph proves it isn't an active prerequisite. No research IDs are deleted.

### Research ownership, verified

FluxWorks science packs are **specialist project bottles** under Razi Protocol, not another required ladder in the normal campaign. Startup validation now checks that the four dedicated Industrial Project technologies still consume their matching science packs, that no other Razi/base/FluxWorks research acquires one, and that no FluxWorks technology can unlock Razi's Shattered Planet location.
