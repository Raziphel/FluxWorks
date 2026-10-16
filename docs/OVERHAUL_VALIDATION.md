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
