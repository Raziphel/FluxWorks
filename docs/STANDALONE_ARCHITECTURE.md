# FluxWorks: standalone industrial architecture

FluxWorks 0.5 changes the direction from a Razi-hosted industrial add-on to a **self-contained Space Age expansion**.

## Core identity and dependency contract

The required dependencies are its graphics, RaziLib, Factorio/Space Age, and the other explicitly listed shared libraries in `info.json`. **Razi Protocol is never required**, including by an ordering-only optional dependency. This avoids a dependency cycle because Razi can independently declare a dependency on FluxWorks. Razi-specific adapter logic must run from Razi's own data stage, after FluxWorks prototypes exist; the former reverse bridge in FluxWorks is now a non-executing legacy shim.

The independent mod is not a separate victory scenario. It does not own a campaign or replace Space Age's Promethium route. Old Shattered research and prototype IDs remain for save compatibility where still referenced, but they do not grant or remove planet access.

## Standalone manufacturing

The four engineering families each have a FluxWorks-owned research program. Chemical, thermal, biological and phase programs add four recipes each where the real science packs, laboratory inputs, output prototypes and machines permit. The program rewards use existing factory materials. Razi contributes **no required outputs** to these production chains.

The existing Reborn/Legacy toggle keeps old recipe IDs and migration options. Reborn applies 73 authored bill-of-material profiles, five original engineered intermediates and eleven specialist machine capabilities. The late Forge executes four dedicated solid-feedstock jobs.

## Resource design

The **Additive** setting registers FluxWorks deposits on known Space Age worlds only where its own resource prototypes actually exist. It does not delete `iron-ore`, `copper-ore`, `coal`, `stone`, alter map presets, or suppress enemies. The Off setting leaves planet resource placements unchanged.

Gleba culture seeding consumes iron/copper bacteria, bioflux and nutrients. Native stromatolite result tables are not modified in either standalone or Razi mode. If cultures are disabled, the seeding recipes are not registered.

## Optional partners

- **K2SO:** existing K2SO material aliases, optional alternative processes and factory hybrid recipes are retained. No K2SO research or native recipe is replaced.
- **Razi Protocol:** external world catalog and paired-freight recipes are registered only where a real source planet, source material and discoverable technology exist. Razi still owns its route maps, story, destinations and its own compatibility passes.
- **Other planets:** source metadata and guarded prototypes are preferred to hardcoded assumptions. Unsupported factories are skipped and logged rather than fabricating resource names.

## Release gates

Test a fresh Factorio 2.1 save in **four configurations**: FluxWorks + Space Age; with K2SO; with Razi; with both Razi and K2SO. Verify no dependency errors, no duplicate technologies, no broken science/recipe unlocks, basic deposits, Gleba bootstrap, fluid-port compatibility, the research programs and the late Forge.

Then test an **existing FluxWorks 0.4.x save** with the new version. Preserve all save-facing entity IDs and persistent storage identifiers. Research, recipe and worldgen migration remains the largest unresolved risk until an actual playtest.

No GitHub Actions workflow is introduced in this version.
