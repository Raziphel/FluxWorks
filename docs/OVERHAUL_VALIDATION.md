# FluxWorks 0.3.1 · Development validation matrix

This extension is not stable-release ready based on source inspection alone. The following should be done before merging or publishing.

## Source checks (Lua 5.2+, run manually)

```sh
lua tests/lua/test_spectrum_industries.lua
lua tests/lua/test_razi_industrial_extension.lua
lua tests/lua/test_razi_industrial_validation.lua
lua tests/lua/test_razi_industry_tech_clarity.lua
lua tests/lua/test_razi_domain_science.lua
lua tests/lua/test_razi_domain_science_rewire.lua
lua tests/lua/test_razi_bacteria_seeding.lua
lua tests/lua/test_industrial_machine_upgrades.lua
```

None of the tests invokes GitHub Actions. They use mock prototype tables, not Factorio's full engine. A missing command/interpreter is not a passing test.

## Full-game test matrix

1. **Razi Dev without FluxWorks.** Main galaxy, chapter research, routes and victory remain unchanged.
2. **Razi Dev + FluxWorks 0.3.1 + FluxWorksAssets 1.0.5 + K2SO.** Confirm startup and icon atlas load, locale and Factorio 2.1 compatibility.
3. **New game, Calidus.** Native iron/copper supply remains and FluxWorks's early deposits/Harvester are usable.
4. **Gleba.** Native stromatolite loot curves are unchanged; six specialist cultures can be seeded in a biochamber from the native parent strains, then multiplied and bioleached.
5. **Four Flux spectra.** Quality modules work in the Industrial Harvester, two-fluid crafting works in the specialist plants, and every new output has a craftable input path.
6. **Seven star systems.** Seven regional Razi-owned specializations and five inter-system exchanges appear as optional Codex goals with exact recipe/machine previews.
7. **Industrial Projects.** Four machine upgrades are craftable from predecessors, keep footprints and pipe positions, and work with the upgrade planner. Verify endgame Convergence Plant with arc recipes on/off.
8. **Five startup settings.** Test defaults and variants, restart and confirm each effect is scoped to FluxWorks.
9. **Victory and Shattered Planet.** Only Razi can unlock the native space location or finish the campaign. No independent FluxWorks ending or landable planet.
10. **Performance.** Compare prototype loading and actual UPS on a large factory; no new scripted scans were introduced.

## Save tests

Make disposable save copies. Check both a fresh Razi save with the extension added and an existing Razi + FluxWorks companion save. Do **not** claim automatic conversion from old standalone FluxWorks saves featuring a landable Shattered Planet. Preserve IDs, inventories and storage prototypes as far as the engine permits.

## Known remaining work

Dedicated full in-world machine sprite sheets and animations have **not** been repainted, only four new project icon badges have been shipped. Actual throughput economics and long-running K2SO + full seven-system performance still need Factorio gameplay measurements.

## 0.3.2 galaxy regression

Run `lua tests/lua/test_galaxy_factories.lua` to test the source-native registry's guards and `python3 scripts/validate_extension_assets.py` from the FluxWorksAssets root for eight system emblems and four machine badges. These tests are designed for manual execution with no GitHub Actions workload.

The 72 catalogue slots should be inspected individually against the actual merged game prototypes. Count successful `fw-planet-*`, `fw-k2-galaxy-*` and `fw-freight-*` registrations in the Factorio log. A skipped optional world is not automatically a bug, but unexpectedly missing important installed worlds should prompt native prototype and producer-unlock inspection rather than guessing resource IDs.

## RaziLib 1.2 integration regression suite

FluxWorks now delegates recipe/technology lookups, idempotent unlocks, icon copying and badge composition, science/lab checks, settings definitions, and graph-cycle protection to genuine RaziLib 1.2.0 APIs. The offline suite **must load the actual installed RaziLib sources**, not test-only helper lookalikes. With both repositories checked out side-by-side:

```sh
lua tests/lua/test_razi_lib_integration.lua
lua tests/lua/test_razi_lib_settings.lua
lua tests/lua/test_razi_lib_k2so.lua
lua tests/lua/test_spectrum_industries.lua
lua tests/lua/test_razi_industrial_extension.lua
lua tests/lua/test_galaxy_factories.lua
lua tests/lua/test_industrial_machine_upgrades.lua
```

If RaziLib is checked out elsewhere, set `RAZILIB_PATH=/path/to/RaziLib` for each command. The bootstrap fails clearly if the real shared library is absent. Test both K2SO installed and missing using actual Factorio; no CI workflow was added.

**K2SO shared-library regression:** the new Lua test verifies normal/expensive recipe replacement through RaziLib, duplicate-safe science and technology unlocks, planetary alternative icon cloning, and both default-on and opted-out K2SO states.

## Runtime RaziLib 1.2 checks

The event registry was already in use. FluxWorks now also uses RaziLib's `runtime/storage.namespace` for **existing save keys** (`platform_type_whitelist`, `flux_extractors`, `phase_vault_units`, `spectral_reservoir_units`, `rift_exchange`) and `runtime/remote.add_interface` for the rocket-reusability remote API. These keep the same stored tables, interface name and command; they do **not** rename data or introduce global state migration. Run `lua tests/lua/test_razi_lib_runtime.lua` with the real sibling library to test persistence and interface idempotence. Confirm actual save migration in-game before publishing.
