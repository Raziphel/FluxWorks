# Razi Industrial Foundries · eight optional manufacturing alternatives

FluxWorks 0.3 adds **eight new recipes** to its existing fourteen Spectrum Industries recipes. No new mandatory science packs, technology branches, entities, fluids, destinations or generated space connections are involved. All eight run in existing Synthesis Plants or Arc Foundries; they unlock from existing FluxWorks technologies and never alter Razi campaign research.

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
