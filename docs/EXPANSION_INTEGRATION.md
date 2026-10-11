# Expansion-first FluxWorks: integration notes

This development branch changes FluxWorks' default role from a full Space Age recipe/technology overhaul to a substantial **additive industrial and endgame expansion**. Existing Flux machinery, its four spectra, planetary systems, and the Shattered Planet campaign remain enabled.

## Supported configurations

| Configuration | Expected behavior |
| --- | --- |
| Space Age + FluxWorks | Standard Space Age infrastructure and research paths remain available. FluxWorks provides its own industrial research and content. |
| Space Age + Krastorio 2 Spaced Out + FluxWorks | K2SO remains the base overhaul. Optional FluxWorks integration consumes K2SO advanced cards and materials in FluxWorks-only content. |
| Legacy FluxWorks overhaul | Startup switches allow previous recipe and technology rewrites to be re-enabled. |

K2SO is an optional dependency: `Krastorio2-spaced-out`. Do **not** make it a required dependency. Its separate Krastorio 2 dependency remains K2SO's responsibility.

## Changes in this first pass

- Default **off**: global recipe integration, core material substitutions, military substitutions, orbital recipe substitutions, machine-part rehoming, broad recipe auto-compatibility, crafting-tab takeover, incomplete rocket parts, and *early-industry Crusher relocation*.
- New, default **off**: legacy technology weaving and replacement of Space Age asteroid-crushing results.
- New, default **on**: dedicated K2SO integration, effective only if K2SO is installed.
- Base research no longer consumes the four FluxWorks domain science packs by default. FluxWorks' own technologies still use them.
- Standard space logistics, asteroid threat tuning, and spoiling behavior retain their existing *normal* presets.
- K2SO canonical material aliases for sand, glass, silicon, chlorine, hydrogen, oxygen, lithium, and ammonia are respected by FluxWorks-owned recipes and research triggers.
- **Pass two:** The Space Age Crusher, electric mining drill and steel recipes are no longer rehomed or rewritten by default. Standalone FluxWorks sand, glass, and basic mineral manufacturing use ordinary expansion technology rather than a new mandatory Nauvis Crusher.
- **Pass two:** With K2SO installed, FluxWorks reuses the native `kr-stone-processing` milestone for sand and glass, hiding its duplicate science stops and recipes without deleting existing prototype IDs.
- **Pass two:** Four optional K2SO-supported alternatives add local resource/Flux synergies on Vulcanus (imersium), Gleba (biomass), Fulgora (rare metals), and Aquilo (lithium).
- K2SO advanced, matter, and singularity technology cards connect to increasingly late FluxWorks research.
- Selected late FluxWorks components use K2SO AI cores, imersium, imersite, charged matter stabilizers, and matter cubes.
- A new optional, six-ingredient imersite-assisted stabilized Flux crystal recipe is unlocked by Flux Synthesis. The original recipe remains.

## Deliberate boundaries

These remain for a later compatibility refactor because cutting them prematurely risks inaccessible items and broken research:

- The remaining FluxWorks-only materials and intermediate parts. Their recipes are no longer prerequisites for standard starting machinery.
- The current four domain science packs and their many **FluxWorks-owned** consumers.
- Certain legacy prototype fixes that also repair FluxWorks' internal recipe unlocks.
- All existing Flux endgame machinery and Shattered Planet progression.

Any later removal should be accompanied by migration planning, rewritten unlock paths, and validation against both supported mod configurations.

## Fresh-save test matrix

1. **Space Age only:** initialize data stage, confirm Crusher stays in its original technology and electric mining drill/steel recipes remain native, craft FluxWorks sand and silicon without an early Crusher, verify circuit/pipe/rocket silo ingredients, inspect Space Age science, unlock Flux extraction, reach the four base planets and Shattered Planet.
2. **Space Age + K2SO:** initialize data stage, confirm `kr-stone-processing` is the only active sand/glass unlock, verify `kr-glass`, `kr-silicon`, K2SO matter tech cards, labs and Flux item aliases, build each of the four K2SO planetary alternatives, then advance into Flux quantum and Shattered technologies.
3. **Legacy switches:** verify tech weaving, global ingredient replacements, rocket-part overhaul and asteroid recipe overrides independently.
4. **Mod compatibility:** inspect Factoripedia, K2SO recycling, cargo/platform conditions and any extended planetary mods before declaring full compatibility.

The Lua data-stage validators check selected contracts, but **they are not a substitute for loading and playing both full mod configurations**. This branch has not yet been verified inside a Factorio executable.

## Saved games

These startup defaults are aimed at **new games**. Existing saves may retain the old settings, existing research, production chains and items. Changing multiple recipe/technology startup options in an established factory may require a migration. Do not assume a save built for overhaul mode can be switched to expansion mode without an audit.
