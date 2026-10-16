# Start from Zero

FluxWorks is being reimagined rather than refactored. This file contains **questions, not decisions**.

1. What should a player *want* to do with FluxWorks, even without another mod installed?
2. Which one mechanic makes it distinctive and worth keeping installed?
3. What is the smallest complete progression loop that proves that mechanic is fun?
4. What existing Factorio materials, machines and research can be reused rather than duplicated?
5. Only after the standalone loop works: how, if at all, should Razi Protocol add narrative or planetary depth?

## Current code contract

- Factorio 2.1 base mod only.
- `data.lua` intentionally registers **zero prototypes**.
- No `control.lua`, custom assets, global recipe edits or external integrations.
- No historic source files, tests, settings, or lore carried over.
- Every new system must have a specific gameplay reason and a tested minimal implementation before expansion.

## Archive and compatibility

Pre-reset code is recoverable from `archive/pre-zero-restart-2026-10-16` (commit `ea7134d5a204c89760ad726bd46de759483fac27`). This branch is historical reference, **not part of the active game**. Saves built with the old mod should keep its matching version.
