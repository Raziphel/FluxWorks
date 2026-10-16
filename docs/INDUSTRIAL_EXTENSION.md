# FluxWorks Industrial Foundries · eight optional manufacturing alternatives

FluxWorks 0.3 adds **eight new recipes** to its existing fourteen Spectrum Industries recipes. No new mandatory science packs, foreign-technology requirements, destinations or generated space connections are involved. These recipes are part of standalone FluxWorks, not a Razi-only DLC. All eight run in existing Synthesis Plants or Arc Foundries; they unlock from existing FluxWorks technologies and never alter Razi campaign research.

| Process | Spectrum | Output | Research owner |
| --- | --- | --- | --- |
| Reactor lining recovery | Fuel | 6 foundry linings | Flux metallurgy |
| Resonant mesh fabrication | Matter + Chemical | 12 metal mesh | Flux resonance |
| Precision seal molding | Chemical | 6 reinforced seals | Flux chemical synthesis |
| Living filtration | Biological | 7 inline filters | Green cultivation |
| Chromatic cermet recasting | Fuel + Chemical | 6 cermet | Industrial convergence |
| Regenerative substrate weaving | Matter + Biological | 3 resonance substrates | Industrial convergence |
| Thermal buffer lamination | Matter + Fuel | 4 thermal buffers | Aquilo industrial symbiosis |
| Sensor membrane reclamation | Chemical + Biological | 5 sensor packages | Industrial convergence |

All recipes use positive quantities of existing material inputs, consume Flux and time, allow no recipe productivity, require no more than two fluid inputs, and skip missing dependencies safely. Dual-spectrum icons use native Assets fluid emblems rather than requesting eight near-identical icons. The eight new routes are **opt-out** in startup settings: Core stays at 14, Expanded adds all eight if their ingredients exist.

Project machine power mode applies after the four project upgrade prototypes are generated. Efficient = 75% power, Standard = unchanged, Demanding = 130%; machine sizes, categories, ports, module counts and recipe IDs stay unchanged.

## Testing

Run `lua tests/lua/test_razi_industrial_extension.lua` with Lua 5.2+. Perform a real full-game load and check eight recipes, icons, fluid inputs, tech unlocks, K2SO aliases and energy display. The recipes are conservative starting values, **not** a claim of measured economic parity across the full modpack.

## Seven-system industrial progression

The core progression intentionally supplies familiar machinery before requiring cross-system imports:

| Razi chapter | Industrial role | Factory reward |
| --- | --- | --- |
| Calidus | quarrying, filtration, first Flux stabilization | manufacturing foundations and base Harvester |
| Solaris | heat-resistant composites and high-energy reduction | Foundry specialization and annealed cermet |
| Nyxaris | regenerative cultures and polymer recovery | seedable biological extraction, resin and nutrient beds |
| Vibrant | sensor lithography and resonant conduction | precision electronics and substrates |
| Vespera | cryogenic control and thermal management | stabilized Flux, cryogel and thermal buffers |
| Beetlejuice | paired precision materials and complex computation | quantum-grade electronics |
| Umbra | phase manifold stabilization and late interlinking | cross-spectrum recovery and advanced phase hardware |

These are *factory specializations*, not a second quest or compulsory research chain. Razi's seven regional and five paired technology definitions continue to live in the Razi repository and are imported after FluxWorks factories exist. FluxWorks does not alter their story, chapter tech-card requirements, map, or victory conditions.

## Energy, speed and optional depth

The extension's five front-page settings are **Industrial Depth** (14 / up to 22 optional processes), **Project Machine Power** (75 / 100 / 130%), **Convergence Multi-discipline** (synthesis only or synthesis + foundry), **Process Tempo** (75 / 100 / 130% crafting time on owned alternatives), and **Project Research** (75 / 100 / 130% cost on four project technologies). These settings do not modify outputs or globally multiply resources. FluxWorks preserves IDs, output items, and recipe ownership in either setting profile.

## World authority and compatibility

The six Gleba cultures have explicit seeding recipes from native iron/copper bacteria, rather than chance drop patches from native stromatolites. Shared asteroid crushing and scrap recycling remain Razi-owned even if a pre-0.3 settings file enabled legacy FluxWorks recipe overrides. Every FluxWorks final-pass validator is scoped either to the extension or to an explicitly standalone-only historical check.

## Save migration cautions

Keep `fw-` prototype IDs when upgrading an existing Razi save. Do not replace a landable standalone FluxWorks Shattered Planet save with the Razi host profile and assume planet state will survive. Preserve copies of important saves, especially worlds with extensive specialized machines and storage. Only test Razi + FluxWorks Dev + Assets 1.0.5 together until the full in-game validation matrix passes.
