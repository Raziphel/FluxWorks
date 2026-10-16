# Industrial Machine Upgrades

FluxWorks' four optional **Industrial Project** research milestones now award permanent factory bonuses **and** a distinctive machine you can actually build. This is the next step in making FluxWorks about machinery rather than extra research obligations.

## Project rewards

| Research milestone | New machine | Base machine | Crafting speed | Module slots | Energy use |
| --- | --- | --- | ---: | ---: | ---: |
| Industrial District Project | Industrial Flux Harvester | Flux Harvester | 3.4 | 5 | 3.8 MW |
| Autonomous Network Project | Precision Synthesis Plant | Synthesis Plant | 4.6 | 6 | 7.2 MW |
| Spectrum Control Project | Chromatic Arc Foundry | Arc Foundry | 5.1 | 6 | 10.5 MW |
| Convergence Directive Project | Convergence Synthesis Plant | Precision Synthesis Plant | 6.3 | 7 | 13 MW |

The Industrial Flux Harvester also gains **quality-module support**, a capability the original Harvester does not have. A project researches its machine's recipe; the machine itself still needs to be built from its predecessor and several established industrial components. Every machine has higher throughput and power draw, so upgrades are a choice rather than a free efficiency multiplier.

The Convergence Synthesis Plant uses **two Flux-colour emblems** to signal its dual-spectrum identity. All four upgrade icons combine existing FluxWorks machinery and FluxWorksAssets art. Original world sprites are reused with recoloured working lights where available, so no duplicate graphics files or custom shaders are loaded.

## Reliability

- **No existing item, machine, or recipe prototype is deleted.** Old factories and blueprints continue to reference the same machine names.
- Matching upgrade tiers retain their predecessor's collision and selection boxes, pipe connections, crafting categories, fluid capacities and allowed module effects.
- Existing machines gain `next_upgrade` to support the standard Factorio upgrade planner. If a different mod already assigned an upgrade, FluxWorks does not overwrite it.
- The upgrade is crafted from the previous machine, so existing factory equipment can be converted rather than discarded.
- No runtime control code, polling, persistent globals, scripted custom effects, or per-tick visual handlers are involved.
- The existing four project science packs remain *optional specialist mastery* in Razi Protocol's companion profile.
- Each project has an explicit prerequisite ensuring its base machine's engineering research is available.
- Each recipe has only five item inputs, below the six-input FluxWorks complexity budget.

## Recommended playtest

With both FluxWorks 0.2.14+ and Razi Protocol Dev installed, check:
1. The four project technology rewards show their new machine unlocks.
2. The original Harvester, Synthesis Plant, and Arc Foundry are still craftable.
3. The upgrade planner correctly replaces machines without rotating/changing their fluid ports.
4. Products and science are still reachable in each chapter, especially K2SO's renamed materials.
5. Power networks can support the substantial increased energy demands of the machine variants.
6. Converted machines keep expected category access, module slots and oil/Flux connections.

The game engine remains the authoritative source for fully loaded integration. Do not promote to a stable modpack without a real Factorio 2.1 playtest.

## 0.3.1 industrial identity

All four upgrades ship with distinct **authored PNG icons** in FluxWorksAssets 1.0.5 (and editable SVG masters), rather than reusing the same generic Flux orb as a project badge. The Industrial Harvester's quality capability is retained. Precision Synthesis stays focused on controlled synthesis throughput, and Chromatic Arc Foundry keeps metallurgy at a high power cost.

The final **Convergence Synthesis Plant** now additionally accepts the `fw-arc-smelting` recipe category by default, while preserving the predecessor's collision footprint, fluid ports, module count, and upgrade-planner path. Players can turn off this cross-category capability using `fw-rp-convergence-universal`. Machines already placed on an existing save keep their prototype identity through the change.

Machine power draw and optional project research cost can be independently adjusted using the new FluxWorks extension settings. No new tick-based scripts, entity scans, effects spawners or costly rendering loops are required.
