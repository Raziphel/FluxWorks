# FluxWorks 0.7: The Subtractive Industrial Redesign

## Design statement

The factory itself is the game. Four Flux disciplines give existing Space Age machines and resources new uses without also demanding a duplicate set of lead, tin, aluminum, titanium, bronze, special ores, bacteria and science packs.

Yellow handles chemical separation, Red handles advanced heat, Green handles cultivated bio-composites and Purple handles electronic phase alignment. Convergence brings their finished components together.

## New default boundaries

| System | Focused |
| --- | --- |
| Added ore patches | **0** |
| Core manufacturing recipes | **26** |
| Flux fluid spectra | **4** |
| Signature materials | **5** |
| Core research tiers | **7** |
| Additional required science packs | **0** |
| Optional 44 + 16 + 12 galaxy recipes | **Off** |
| Mineral bacteria | **Off** |
| Shattered Planet campaign | **Off** |
| Old teleport, vault, reservoir and rocket runtime | **Off** |

Stone, sulfur and water make a starter crystalline Flux recovery recipe, complementing the existing item-to-Flux Condenser. The Harvester has two recovery processes, the Arc Foundry handles Red thermal manufacturing, the Synthesis Plant handles complex Flux components, and the Convergence Forge receives three genuine solid-material jobs.

### Retired from the player's normal experience

The original raw ore veins, six mineral bacteria, alternative metal plates, crushed-ore forms, inflated intermediate families, four additional science bottles, legacy expansion research and excessive factory variants are no longer offered as part of Focused progression. Seventy-two speculative optional regional factory registrations default to Off. The optional Seven Foundries still produce actual focused outputs when Razi is installed.

### Backwards compatibility, not a promise of painless migration

The historical prototype registration files are still loaded so old saves have matching item, entity, technology and recipe IDs. The Focused curator strips ore autoplace rules and hides unused craftable recipes and research after those prototypes exist. No already-generated ore patches are destroyed.

**Use Legacy for existing worlds** until a real migration test has been completed. Changing a running factory to Focused can deactivate old machines and recipes even though their inventory objects survive. All legacy sprite assets must remain until their old prototypes are actually migrated or removed.

### Release gate

Test a new Factorio 2.1 save with Space Age, then K2SO, then Razi, then both. Verify all 26 recipe unlocks, actual input-port access, research progression, absence of new ore patches, workable raw Flux bootstrap and Forge output. Separately test an existing save in Legacy and a backed-up transition to Focused. None of those engine tests have yet been completed.
