# FluxWorks compatibility API

FluxWorks provides a small data-stage API for compatibility and expansion mods.
Use it when your mod knows more than FluxWorks can safely infer automatically.

The API can define:

- Recoverable values and Flux composition for items and fluids
- Quality-specific recovery rules
- Items that must never be recoverable
- FluxWorks components added to exact recipes or whole recipe families
- Recipes that automatic compatibility must leave alone

FluxWorks already scans modded recipes automatically. Most mods need only a
small manifest for unusual resources, scripted items, or signature machines.

## Quick start

Add FluxWorks as an optional dependency:

```json
{
  "dependencies": [
    "base >= 2.1.0",
    "? FluxWorks >= 1.0.0"
  ]
}
```

Create or update your mod's `data-updates.lua`:

```lua
if not mods["FluxWorks"] then return end

local fluxworks =
  require("__FluxWorks__/prototypes/lib/compatibility-api")

fluxworks.register({
  items = {
    {
      name = "my-mod-superalloy",
      value = 240,
      spectrum = { matter = 3, chemical = 1 },
    },
    {
      name = "my-mod-script-token",
      exclude_recovery = true,
    },
  },

  fluids = {
    {
      name = "my-mod-reactive-slurry",
      value = 0.85,
      spectrum = { matter = 0.35, chemical = 0.65 },
    },
  },

  recipe_parts = {
    {
      recipe = "my-mod-advanced-pump",
      part = "fw-reinforced-seal",
      amount = 2,
    },
  },

  exclude_recipes = {
    "my-mod-controller-recycling",
  },
})
```

That is a complete integration. Missing optional prototype targets are reported
in `factorio-current.log` without preventing the game from loading.

Register during `data-updates.lua`. Registrations made by an optional dependent
mod during `data-final-fixes.lua` arrive after FluxWorks has consumed them.

## Flux composition

Use the same names players see in game:

| API name | Represents | Common examples |
| --- | --- | --- |
| `matter` | Solid material and structure | Ores, plates, frames, storage |
| `chemical` | Chemistry and process control | Acids, catalysts, circuits |
| `fuel` | Stored energy and heat | Fuels, explosives, reactors |
| `bio` | Living or organic material | Biomass, nutrients, seeds |

Composition numbers are relative weights. They do not need to total `1`:

```lua
spectrum = { matter = 3, chemical = 1 }
```

The color keys `purple`, `yellow`, `red`, and `green` are also accepted as
compact aliases for Matter, Chemical, Fuel, and Bio.

Only declare a composition when your mod understands the item better than
automatic classification. FluxWorks otherwise derives it from ingredients,
processes, fuel properties, spoilage, placed entities, and other evidence.

## Item registration

```lua
fluxworks.register_item({
  name = "my-mod-reactor-core",
  value = 850,
  spectrum = { fuel = 0.8, chemical = 0.2 },
  quality_multipliers = { legendary = 3.5 },
})
```

Supported fields:

- `name` — item prototype name
- `value` — trusted minimum material value
- `locked` — make `value` authoritative instead of a minimum
- `spectrum` — relative Matter, Chemical, Fuel, and Bio weights
- `exclude_recovery` — prevent Flux extraction from this item
- `quality_multipliers` — per-quality recovery multipliers
- `excluded_qualities` — quality tiers that cannot be recovered

Register multiple items with `register_items({ ... })` or place them in the
top-level `register({ items = { ... } })` manifest.

Use locked values sparingly. Ordinary intermediates should use an unlocked
minimum or automatic derivation. Locks are intended for scripted rewards,
artifacts, or acquisition costs that recipes cannot express.

## Fluid registration

Fluid values are per unit:

```lua
fluxworks.register_fluid({
  name = "my-mod-reactive-slurry",
  value = 0.85,
  spectrum = { matter = 0.35, chemical = 0.65 },
})
```

Use `register_fluids({ ... })` for a batch. The lower-level
`register_fluid_value` and `register_fluid_spectrum` helpers are also available.

## Recovery and quality safety

Exclude free, scripted, stateful, or exploit-prone items:

```lua
fluxworks.exclude_from_recovery("my-mod-script-token")

fluxworks.exclude_items_from_recovery({
  "my-mod-free-currency",
  "my-mod-container-with-hidden-state",
})
```

Quality multipliers must be positive and cannot exceed `8`. Normal quality
cannot be excluded; exclude the entire item instead.

```lua
fluxworks.register_item_quality_multiplier(
  "my-mod-superalloy",
  "legendary",
  3.5
)

fluxworks.exclude_item_quality("my-mod-artifact", "legendary")
```

A mod that owns a custom quality may register a global policy:

```lua
fluxworks.register_quality_multiplier("mythic", 5.0)
```

## Exact recipe integration

Add a FluxWorks component to one construction recipe:

```lua
fluxworks.register_recipe_part(
  "my-mod-advanced-pump",
  "fw-reinforced-seal",
  2
)
```

Or register several in the manifest:

```lua
fluxworks.register({
  recipe_parts = {
    { recipe = "my-mod-pump", part = "fw-reinforced-seal", amount = 2 },
    { recipe = "my-mod-controller", part = "fw-signal-conduit" },
  },
})
```

FluxWorks adds the part when absent and raises an existing amount when it is too
low. Exact registrations are reapplied after broad compatibility processing.

## Recipe family integration

Use a family when several machines share a clear industrial identity:

```lua
fluxworks.register_recipe_family({
  name = "my-mod-pressurized-machinery",
  part = "fw-reinforced-seal",
  ingredient_amount = 2,
  item_name_patterns = { "^my%-mod%-pressure%-" },
  subgroups = { "my-mod-fluid-machinery" },
  min_ingredients = 2,
  max_ingredients = 8,
})
```

Selectors:

- `item_names`
- `item_name_patterns`
- `item_types`
- `entity_types` or `types`
- `subgroups`
- `subgroup_patterns`

Controls:

- `name` — diagnostic name for the family
- `part` — FluxWorks component to add
- `ingredient_amount` — amount added, default `1`
- `min_ingredients` — minimum existing ingredient entries, default `2`
- `max_ingredients` — maximum existing ingredient entries, default `6`

Patterns are Lua patterns. Family integration only targets recipes with one
clear primary item result and a real bill of materials. Hidden, ambiguous,
free-output, packing, and conversion recipes are deliberately conservative.

Use `register_recipe_families({ ... })` for several families. Registering the
same family name again replaces its earlier definition, which makes conditional
compatibility overrides predictable.

## Keep automatic integration away from special recipes

```lua
fluxworks.exclude_recipe("my-mod-free-conversion")

fluxworks.exclude_recipes({
  "my-mod-packing",
  "my-mod-unpacking",
  "my-mod-recycling",
})
```

Use exclusions for recycling, voiding, free conversion, script-managed recipes,
or anything where adding a construction component would be incorrect.

## Small conditional registrations

The single manifest is recommended, but every helper can be called directly:

```lua
if data.raw.item["my-mod-optional-artifact"] then
  fluxworks.register_item({
    name = "my-mod-optional-artifact",
    value = 1200,
    locked = true,
    spectrum = { matter = 0.6, chemical = 0.4 },
  })
end
```

## Diagnostics

FluxWorks validates registered targets during `data-final-fixes.lua`.

Input mistakes fail immediately with a specific API error, including empty
prototype names, invalid values, unknown Flux kinds, negative weights, empty
compositions, inverted family bounds, and excessive quality multipliers.

Missing optional items, fluids, recipes, parts, or qualities are collected into
one log message instead of crashing startup. Search `factorio-current.log` for:

```text
FluxWorks compatibility API:
```

For debugging, inspect a safe copy of the current registry:

```lua
log(serpent.block(fluxworks.snapshot()))
```

## Integration checklist

- Add FluxWorks as an optional dependency.
- Register from `data-updates.lua`.
- Let automatic valuation handle ordinary recipe-driven items.
- Override only what your mod understands better.
- Use Matter, Chemical, Fuel, and Bio names in new integrations.
- Exclude free, scripted, stateful, recycling, and conversion loops.
- Prefer one `register({ ... })` manifest for a complete integration.
- Test with FluxWorks compatibility mode set to both conservative and broad.
