# Credits

FluxWorks ships a mix of original work and adapted third-party assets. This file tracks the outside source families that are visibly present in the current mod files.

## Live source families

- `brevven` Factorio mods (MIT):
  - Sources:
    - https://github.com/brevven/silicon
    - https://github.com/brevven/titanium
    - https://github.com/brevven/lead
    - https://github.com/brevven/tin
    - https://github.com/brevven/chlorine
    - https://github.com/brevven/aluminum
    - https://github.com/brevven/carbon
  - Used for adapted ore, plate, chemistry, and resource-art foundations across the FluxWorks asset pack, especially:
    - `FluxWorksAssets/graphics/resources/ores/*`
    - `FluxWorksAssets/graphics/resources/fluids/chlorine.png`
    - `FluxWorksAssets/graphics/icons/items/fw-bz-*`
    - `FluxWorksAssets/graphics/icons/items/*plate*.png`
  - Runtime note:
    - FluxWorks now points directly at `Krastorio2Assets` for the live silicon icon path, chlorine fluid icon surfaces, greenhouse/quantum-computer technology art, and fuel-refinery-style chemistry tech art instead of shipping more local lookalikes.

- Rocket Reusability by `Lylac`: (MIT)
  - Source:
    - https://mods.factorio.com/mod/rocket-reusability
  - Used for adapted rocket-reuse concepts and asset families, especially:
    - `FluxWorksAssets/graphics/icons/items/reusable-rocket-*.png`
    - `FluxWorksAssets/graphics/icons/items/fw-rocket-*.png`
    - `FluxWorksAssets/graphics/resources/asteroids/fw-used-rocket*.png`
    - `FluxWorksAssets/graphics/resources/asteroids/fw-rocket-chunk*.png`
  - Runtime note:
    - This is the one source family intentionally kept local in `FluxWorksAssets` rather than added as a hard dependency.

- Memory Storage / deep-storage-unit by `notnotmelon` (MIT):
  - Sources:
    - https://mods.factorio.com/mod/deep-storage-unit
    - https://github.com/notnotmelon/deep-storage-unit
  - Used for adapted late-game deep-storage visuals and interaction patterns, especially:
    - `graphics/late-utility/deep-storage-unit/*`
    - `graphics/icons/items/deep-storage-unit/*`
    - `graphics/technology/deep-storage-unit/*`
  - FluxWorks also adapts the memory-unit style GUI and hidden-helper-entity pattern for:
    - `scripts/phase-vaults.lua`
    - `scripts/memory-shared.lua`

- Fluid Memory Storage by `notnotmelon` (MIT):
  - Sources:
    - https://mods.factorio.com/mod/fluid-memory-storage
    - https://github.com/notnotmelon/fluid-memory-storage
  - Used for adapted fluid-memory visuals and interaction patterns, especially:
    - `graphics/late-utility/fluid-memory-storage/*`
    - `graphics/icons/items/fluid-memory-storage/*`
    - `graphics/technology/fluid-memory-storage/*`
  - FluxWorks also adapts the fluid-memory style GUI, tinting, and hidden-helper-entity pattern for:
    - `scripts/spectral-reservoirs.lua`
    - `scripts/memory-shared.lua`

- Telogistics by `S6X` (GPLv3):
  - Source:
    - https://mods.factorio.com/mod/Telogistics
  - Used as a gameplay reference for the cross-planet teleporter exchange concept and GUI/control flow inspiration in:
    - `scripts/rift-exchange.lua`
    - `prototypes/entities/late-utility.lua`
  - No Telogistics source files or art assets are currently shipped directly inside FluxWorks.

- Artisanal Reskins alien fluid icons:
  - Used directly for the colored Flux fluids:
    - `FluxWorksAssets/graphics/icons/fluids/ArtisanalReskins_alien-acid.png`
    - `FluxWorksAssets/graphics/icons/fluids/ArtisanalReskins_alien-explosive.png`
    - `FluxWorksAssets/graphics/icons/fluids/ArtisanalReskins_alien-fire.png`
    - `FluxWorksAssets/graphics/icons/fluids/ArtisanalReskins_alien-poison.png`

- `unused-renders` by `malcolmriley` (CC BY 4.0):
  - Source:
    - https://github.com/malcolmriley/unused-renders
  - Used for adapted part and component renders, with some leftovers still parked as references under:
    - `FluxWorksAssets/graphics/icons/items/part-*.png`
    - `FluxWorksAssets/graphics/icons/items/unused-assets/*`

- 248k mod graphics: (GNU GPLv3)
  - Source:
    - https://mods.factorio.com/mod/248k-Redux-graphics
  - Used for adapted gravitation-endgame iconography in:
    - runtime references to `__248k-Redux-graphics__/ressources/gravitation/gr_black_hole/gr_black_hole_item.png`

- Krastorio 2 assets:
  - Sources:
    - `/mnt/omega/Coding/Assets/Krastorio2_2.0.16`
    - `/mnt/omega/Coding/Assets/Krastorio2Assets_2.0.4`
  - Used for adapted singularity-megastructure building art in:
    - `FluxWorksAssets/graphics/late-utility/origin-singularity/*`
  - Runtime note:
    - FluxWorks now points directly at `Krastorio2Assets` for the imersite-rift resource art, imersite-style flux crystal icons, the singularity-lab sprite used by late utility structures, and energy-control-unit technology art where the shipped files were exact copies.

- Age of Production Graphics:
  - Source:
    - `/mnt/omega/Coding/Assets/Age-of-Production-Graphics`
  - Runtime note:
    - FluxWorks now points directly at `Age-of-Production-Graphics` for the copied core-miner, arc-furnace, petrochemical-facility, hydraulic-plant, synthesizer, atomic-enricher, quantum-computer, and related sound/icon families, including the live `fw-liquid-mining`, `fw-petrochemical-engineering`, `fw-hydraulic-systems`, and `fw-metallurgic-assemblies` technology art.

## Notes

- `unused-renders` is CC BY 4.0 and requires attribution.
- The `brevven` repositories listed above are MIT-licensed.
- `deep-storage-unit` and `fluid-memory-storage` are MIT-licensed.
- Telogistics is GPLv3; FluxWorks currently credits it as a gameplay/reference influence rather than shipping its source or art directly.
- Some files have been recolored, renamed, cropped, or folded into larger FluxWorks systems, so the shipped filenames do not always match upstream names exactly.
- If new third-party assets are imported, add the source family and the specific shipped path pattern here at the same time.
