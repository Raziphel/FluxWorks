# FluxWorks companion mode for Razi Protocol

## Ownership

Razi Protocol is the campaign and star-map authority. FluxWorks is the industrial systems provider. Companion mode is detected through the Factorio mod ID `razi-protocol` at data stage and through `script.active_mods` at runtime.

Razi lists `? FluxWorks >= 0.2.12` in its dependencies. **Do not add the reverse optional dependency to FluxWorks**: that would create a circular dependency and break loading.

## What changes

| Feature | FluxWorks standalone | Installed with Razi |
| --- | --- | --- |
| Shattered Planet | Landable four-spectrum world | Preserves the original Space Age space location |
| Final victory | Origin Singularity | Razi's campaign victory |
| Starting wreckage | FluxWorks loadouts | Native/Razi scenario |
| Nauvis deposits | Mixed FluxWorks resource layout | Original ores plus Flux and mixed deposits |
| Planet-wide Flux placement | Standalone distribution | Razi-defined planet identities |
| Platform drag, global spoilage and asteroid balance | FluxWorks settings | Razi/source-mod authority |
| Main menu | FluxWorks simulations | Host modpack simulations |
| Rift Exchange | Normal FluxWorks research | Requires Razi Outer Frontier Mastery |
| Domain science | FluxWorks-owned industrial research | Optional specialist mastery; Razi removes extra domain-pack tolls from ordinary Flux research |

The purple, yellow, red and green Flux systems, machine prototypes, source items, recipes, K2SO alternatives, valuation engine, and specialist machinery remain intact.

The native resource placement pass avoids modifying Razi's star systems. FluxWorks' existing planet-specific extraction and bioprocessing recipes remain available.

## Implementation boundaries

- FluxWorks does not import or rewrite Razi Protocol's tech cards or starmap.
- The Razi-side integration lives in `prototypes/compat/fluxworks.lua` in the Razi repo and runs late in `data-final-fixes.lua`.
- The Razi-side pass keeps FluxWorks item and recipe prototype names stable. It only changes research costs/unlocks and contributes additive recipes.
- Existing FluxWorks technology IDs are not removed.
- Rift Exchange access is checked both when starting a transfer and immediately before swapping inventories/fluids, so an in-flight transfer cannot bypass a changed research state.

## Test matrix before release

1. **Standalone FluxWorks:** fresh game, early research, multi-spectrum processing, landable Shattered Planet, and its own victory.
2. **Razi only:** vanilla Shattered Planet space location, route gates, no new FluxWorks requirements.
3. **Razi + FluxWorks:** both mods load, standard Nauvis ores remain present, no duplicate planet ID, no duplicate victory.
4. **Progression:** first visit to each of Solaris/Nyxaris/Vibrant/Vespera requires only Razi/source research. FluxWorks' optional production recipes unlock afterward.
5. **Logistics:** Rift Exchange does not transfer anything before Outer Frontier Mastery, and does afterward, with the normal power cost.
6. **Old saves:** use disposable copies, particularly saves created with standalone FluxWorks' landable Shattered Planet.
7. **Performance:** compare prototype-building time and `/time-usage` runtime on the same installed mod set.

Note: FluxWorks' standalone Shattered Planet research branch remains defined in companion mode for save/prototype stability, but cannot override Razi's location unlock. A future pass can replace the obsolete chapter with optional Deep Space engineering projects after engine tests.
