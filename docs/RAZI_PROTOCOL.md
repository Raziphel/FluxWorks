# FluxWorks extension ownership for Razi Protocol (0.3)

Razi Protocol is a **required dependency**, not an optional detected companion. Factorio mod ID: `razi-protocol`; minimum Razi Dev build for this branch: **2.1.118**. Never add `FluxWorks` as a Razi dependency, even optional, because the reverse direction creates a dependency cycle.

## Authority

| Razi Protocol controls | FluxWorks controls |
| --- | --- |
| star systems, travel, discovery, chapter cards, story, Codex quests and victory | four Flux spectra, factories, material valuation and recipes |
| planetary identities and surface resource maps | only its own optional extraction and manufacturing |
| Shattered Planet as original Space Age **space location** | advanced industrial projects, not a new landable Shattered Planet |
| shared asteroid curves, platform physics, spoilage and starting scenario | recipe-local production rewards and late power-hungry factory upgrades |

Razi's five integration modules now run from `FluxWorks/data-final-fixes.lua` **after** FluxWorks' generated prototypes. They remain authored in Razi, including seven regional workshops, five paired exchanges, research-graph clarification and machine pacing. This changes load order without copying Razi's route and research algorithms into the extension.

## Identity and save migration

Keep existing `fw-` items, machines, fluids, technologies and recipe names. Legacy Shattered Planet technologies may continue existing but must not revoke native Space Age location unlocks, replace the space location, trigger a standalone victory, or gate Razi core research. Razi unlock and mastery rules take precedence. Do not assume migration of a previous standalone save featuring a landable Shattered Planet into this required-host configuration. Test with copied saves.

## Test matrix

1. Razi alone must load with the same route and victory graph, no FluxWorks dependencies.
2. Razi + FluxWorks + Assets must load with one Shattered Planet space location and one victory.
3. Seven optional research workshops and five dual-region exchanges must register where all dependencies are present.
4. Core/Expanded industrial depth and three machine power tiers must keep native recipes available and change no third-party machine.
5. All `fw-` recipes must have valid inputs, icon paths, and research unlocks; both fluid-box limits and K2SO item aliases matter.
6. Rift Exchange must remain locked behind Razi Outer Frontier Mastery.
7. Compare early factory setup and late throughput in a fresh save and disposable old-save copies; validate graphical rendering in the real Factorio client.

The sources and mock tests alone do not prove that a full Factorio modpack loads.

## Host authority safety, 0.3.1

Even when previously saved legacy startup settings remain active, Razi-hosted FluxWorks does not patch Razi's native asteroid-crushing recipes or Fulgora scrap-recycling outputs. Its bespoke Flux asteroid prototypes stay defined for existing item references, but global production is host-owned. Old landable-Shattered expedition research IDs remain registered; obsolete branches are hidden only when no visible technology requires them. Normal Razi travel, research and achievement unlocks are untouched.

Gleba now acquires the six resource-specific cultures using physical organic recipes seeded from normal iron/copper bacteria. Native stromatolite drops are never edited. Optional host-owned workshops are still imported from Razi's five existing source modules, not copied into FluxWorks.

## Science validation ownership

In companion mode the original standalone science validators are replaced by a strict extension contract: preserve four science-pack items and recipes, preserve their owning unlock technologies, retain four project-specific science consumers, reject any normal or planetary research requiring those FluxWorks packs, and reject any FluxWorks unlock-space-location effect on Shattered Planet. The standalone tests remain in source for legacy documentation, but cannot veto Razi's campaign rules.
