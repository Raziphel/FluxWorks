# The Four Works and the Seven Foundries · FluxWorks 0.6.1

FluxWorks remains a **standalone industrial expansion**. The Razi integration is a special additional factory experience, not the reason FluxWorks exists.

## Core identity: The Four Works

Four production disciplines share one common foundation:

| Work | Method | Native engineered materials |
| --- | --- | --- |
| Yellow Chemistry | separation, purification, reclamation | Catalytic Separation Membrane |
| Red Thermal | heat, pressure, metallurgy | Chromatic Thermal Core |
| Green Biological | cultivation, restoration, renewable systems | Cultured Living Fiber |
| Purple Phase | resonance, quantum alignment, structured matter | Phase Alignment Wafer |

The **Charter of the Four Works** is a late research standard requiring mastery of all four standalone research programs. Its four physical manufacturing processes produce logic matrices, refractory linings, resilient seals and condensed Flux matrices. It does **not** trigger campaign completion or modify anyone else's science. Its icon is original FluxWorks art in FluxWorksAssets.

The Charter can be disabled independently. Old factory prototypes and saved-state names remain untouched.

## With Razi Protocol: The Seven Foundries

When Razi Protocol is present, and its real locations, source materials, machines and discovery technologies are available, FluxWorks optionally registers seven **field engineering commissions**. They are Razi-flavored without belonging to Razi's quest or journal systems.

| System | Representative source world | Identity | Practical output |
| --- | --- | --- | --- |
| Calidus | Nauvis | The First Furnace | Metal mesh |
| Solaris | Vulcanus | Under the Crucible | Annealed cermet |
| Nyxaris | Gleba | The Living Engine | Resin |
| Vibrant | Fulgora | The Silent Circuit | Resonance substrate |
| Vespera | Aquilo | The Cold Equation | Cryogenic coils |
| Beetlejuice | Secretas, Linox or Ferrum (first real supported world) | The Impossible Machine | Quantum computers |
| Umbra | Tenebris or Vesta (first real supported world) | The Last Alignment | Phase manifolds |

Each registered field operation consumes a real source-world-produced material, a FluxWorks specialty intermediate and one matching Flux fluid. It produces useful industrial parts **plus a physical calibration record**. No fictional planet materials or route shortcuts are created.

Once four or more supported field commissions can be registered, an optional **Atlas of the Seven Foundries** research can combine the real available records into two regional folios. Those folios, plus Convergence Chassis, fit into a three-input Convergence Forge production recipe, rewarding interstellar logistics with condensed matrices and quantum computers. The four-system minimum is intentionally adaptable when players install fewer of the modpack's optional planets.

The Atlas does not unlock locations, alter Razi's technologies or victory, write journal entries, grant invisible bonuses or run per-tick scripts. It is a physical manufacturing ledger with its own Seven Foundries artwork.

## Dependency and mod ownership

Razi is not a required or optional **ordering** dependency in `info.json`. All Seven Foundries registrations test `mods["razi-protocol"]` and real loaded prototypes before doing anything. Without Razi, they return immediately, leaving the Charter, original factory, science and processes intact.

FluxWorks remains responsible for its factory economy. Razi owns its routes, chapters, narrative and own integration modules. FluxWorksAssets 1.1.0 ships both distinct identity emblems with SVG masters.

## Testing

`prototypes/validation/industrial-identity.lua` checks Charter recipes, per-system Razi commissions, optional Atlas folios, physical input limits and the standalone isolation boundary. Source tests and asset checks are necessary but insufficient to claim real Factorio compatibility.

Before publishing to the mod portal, test Factorio 2.1 + Space Age with FluxWorks alone, then with Razi, and also both configurations with K2SO; verify an existing 0.5.x save and a Razi-hosted save. No release workflow or GitHub Actions job has been added.

## Field manual and production hygiene (0.6.1)

The **`/fw-guide`** command is an on-demand orientation guide. **`/fw-guide status`** shows which of the four specialty research programs your force has finished and whether the Charter is researched. **`/fw-guide atlas`** explains Razi-exclusive field commissions and recognizes an unavailable Atlas without inventing systems. The runtime command uses Factorio 2.1's `script.active_mods`, does not create GUI state, and registers no events or timers.

Each available planetary calibration operation creates useful production **plus one physical record**. Once enough records have been reserved for the Atlas, the matching **field reconciliation recipe** converts six surplus records into two useful components. It is unlocked alongside the source commission, uses a regular crafting machine, and requires no fluid pipes. This prevents indefinite record accumulation and gives players a reason to keep regional operations running.

Crafting menu icons now show the **actual product** together with a Charter or system badge; technology and calibration-item emblems remain distinct. The former Origin Forge is displayed as the **Convergence Forge** for new players, while its `fw-origin-forge` prototype ID stays unchanged for save migration. Old Shattered Planet victory descriptions are replaced by accurate standalone industrial language; Razi owns planetary location descriptions.
