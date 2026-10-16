# Galaxy-wide FluxWorks workshop registry

This is the authored catalog of **44 planet slots**, **16 K2SO hybrid slots**, and **12 paired freight slots**. A slot only materializes if the exact installed planet, a genuine native item producer, a non-hidden output and feedstock, the discovery technology, its Flux machine and a lab accepting the research packs all exist. The registry logs guarded skips. No count here is a claim of confirmed in-game availability.

The existing seven Razi-owned regional specialties and five paired exchanges remain independent and unchanged. These are additional optional FluxWorks recipes and their own research. No worldgen, route, loot, map, science-card, native recipe, K2SO machine or victory is edited.

**Installation:** FluxWorks requires Razi Protocol; K2SO hybrid slots activate only when Krastorio2-spaced-out is installed and the new toggle is enabled. Original K2SO planetary and science alternatives remain in FluxWorks. Unknown/renamed native item prototypes are skipped rather than replaced with fabricated materials.

## Authored systems

| System | Target worlds |
| --- | --- |
| calidus | nauvis, muluna |
| solaris | vulcanus, castra, arig, hyarion, tellus, corrundum, igrys |
| nyxaris | gleba, moshine, apia, carnova, panglia, foliax, rabbasca, pelagos, deadia, dea-dia |
| vibrant | fulgora, ribbonia, paracelsin, cerys, shchierbin |
| vespera | muria, aquilo, rubia, maraxsis, balack, athos |
| beetlejuice | cubium, linox, secretas, frozeta, ferrum, wit |
| umbra | tenebris, crucible, vesta, carna, arcanyx, obsidiax |
| deep-space | aegis, bellicos |

## Economy principles

- All new recipes consume a physical native item, a different real FluxWorks intermediate, and 35+ units of one Flux discipline. Some also consume a second spectrum, a K2SO intermediate, or freight imported from another researched planet.
- All produce existing items or existing FluxWorks specialist science, and allow neither productivity nor auto-recycling. No new bootstrapping planets or custom science tolls on Razi research.
- Fresh optional researches require the actual planet's discovered unlock, an appropriate Flux discipline and normal compatible lab science. Paired freight researches additionally require the second source world's discovery.
- Existing production lines keep running. This adds alternative factories, not a new compulsory logistics network.

## Validation and caveats

Run the offline Lua mock tests and then a Factorio 2.1 data-raw dump with every installed planet/K2SO. Count the recipes actually added, inspect each guarded skip in the Factorio log, confirm each native ingredient producer and physical machine, check all research prerequisites and complete at least one full batch for every enabled planet. Balancing is provisional until real factory metrics are measured.

## K2SO science unlock safety

Two late K2SO native-material hybrid recipes offer optional manufacturing of Flux Theory and Planetary Convergence specialist packs. They additionally require the corresponding **original FluxWorks science unlock technology**. Their technology nodes never appear as Razi chapter prerequisites, and no recipe overwrites a native K2SO science-card definition.
