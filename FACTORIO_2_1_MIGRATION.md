# Factorio 2.1 migration

FluxWorks, FluxWorks Assets, and RAZI Library target Factorio 2.1 exclusively.
The minimum supported engine version is 2.1.0; the migration was validated
against the 2.1.12 headless build with Space Age, Quality, Recycler, and the
declared 2.1 dependency versions enabled.

## Compatibility changes

- Recipe categories are normalized to the 2.1 `categories` array. RAZI Library
  exposes `set_categories`, `add_category`, and `normalize_all_2_1` so optional
  integrations can safely finish their edits before final normalization.
- Legacy result `probability` and freshness fields are migrated to 2.1 product
  fields, including minable products and loot products.
- FluxWorks science packs are ordinary items, matching 2.1's item-based lab and
  technology inputs.
- Runtime fluid transfers use the direct `LuaEntity` fluid methods rather than
  the removed `LuaFluidBox` interface.
- Asteroids use `damage_per_hp`; fluid connection visibility is configured on
  individual pipe connections; removed assembler picture globals are imported
  from the base assembler-picture module.
- The removed combined chemistry/cryogenics category is represented as a true
  multi-category recipe.
- AAI integration is reapplied intentionally during final fixes. The integration
  module is callable, avoiding Lua's module cache silently skipping the second
  pass after other mods rewrite recipes.

## 2.1 features available to future RAZI consumers

RAZI Library now provides helpers for multi-category recipes, quality
selectability, ingredient sorting, spoil-quality policies, and module quality
multipliers. New mods should author 2.1 fields directly; the normalization API
is primarily for broad compatibility passes and gradual migrations.

## Save warning

Factorio 2.1 can load 2.0 saves, but a save written by 2.1 cannot be opened in
2.0. Keep a backup of an existing FluxWorks save before first loading it in 2.1.
