# Lean FluxWorks extension audit · 2026-10-16

FluxWorks 0.3.5 runs **only** as a Razi Protocol industrial extension. This cleanup removes historical executables which are unreachable in the mandatory Razi build, without rewriting source-mod worlds.

## Removed (`26` files)

- `scripts/true-ending.lua`
- `scripts/shattered-planet.lua`
- `scripts/shattered-asteroids.lua`
- `prototypes/updates/shattered-planet.lua`
- `prototypes/resources/shattered-flux-vents.lua`
- `prototypes/lib/ion-storm-profiles.lua`
- `prototypes/menu-branding.lua`
- `prototypes/updates/menu-branding.lua`
- `prototypes/menu-simulations.lua`
- `menu-simulations/manifest.lua`
- `menu-simulations/fw-menu-biters.zip`
- `menu-simulations/fw-menu-defense.zip`
- `menu-simulations/fw-menu-sorting-ores.zip`
- `menu-simulations/fw-menu-mall.zip`
- `prototypes/updates/starting-loadout.lua`
- `prototypes/updates/space-platform-drag.lua`
- `prototypes/updates/player-tuning.lua`
- `prototypes/updates/asteroid-crushing.lua`
- `prototypes/updates/fulgora-scrap.lua`
- `prototypes/updates/technology-weave.lua`
- `prototypes/validation/menu-simulations.lua`
- `prototypes/validation/shattered-lightning.lua`
- `prototypes/validation/space-platform-drag.lua`
- `prototypes/validation/player-tuning.lua`
- `prototypes/validation/asteroid-crushing.lua`
- `prototypes/validation/optional-domain-science.lua`

The four `fw-menu-*.zip` archives were never used by the Razi-owned menu. Their menu setup/branding and validator are deleted together. The matching old `FluxWorksAssets/graphics/menu-simulations/fw-logo.png` is also retired.

## Explicitly retained

- `prototypes/technology/shattered-campaign.lua`
- `prototypes/recipes/shattered-campaign.lua`
- `prototypes/updates/factoriopedia-content.lua`
- `prototypes/updates/factoriopedia.lua`
- `prototypes/updates/rocket-reusability.lua`
- `scripts/rocket-remnants.lua`
- `scripts/rift-exchange.lua`
- `scripts/phase-vaults.lua`
- `scripts/spectral-reservoirs.lua`

Legacy Shattered **prototype IDs**, even where obsolete, are retained until actual save migration has been tested. Deleting research/recipe definitions can break existing researched states or item references. The legacy tech definitions must no longer unlock `shattered-planet`, and the old standalone research rewiring must not remove normal technology recipe unlocks under Razi.

## Historical settings policy

Old startup configuration IDs remain registered but hidden when they no longer have any effect in the Razi companion build. We deliberately avoid silently interpreting prior setting values as permission to restore global worldgen, space physics, or campaign overrides. This is a clean-up of unreachable code, not a save converter.

## Verification gates

1. Inspect direct requires in `data.lua`, `data-updates.lua`, `data-final-fixes.lua`, `control.lua`, and `prototypes/validation/init.lua`: none may load the removed modules.
2. Inspect existing recipes and technology names before deleting further prototype files; defer risky migration.
3. Verify the Assets package still contains all active icon and machine sprite references.
4. Test Factorio 2.1 + Razi + K2SO data startup, a fresh save, an existing save, and Factoriopedia.
5. No added GitHub Actions and no modifications to Razi Protocol or RaziLib.
