# FS22_BuildAnywhere

A Farming Simulator 22 mod that lets you **change everything on all land**, including farmland you don't own.

## Features

- Landscaping: raise, lower, smooth, flatten and slope terrain anywhere
- Paint terrain textures and foliage (grass, bushes, ...) anywhere
- Plant trees anywhere, and cut trees with the chainsaw anywhere
- Place buildings, fences and other placeables anywhere
- Still respected: money, farm permissions, restricted zones and the shop/vehicle spawn areas
- Vehicles are not affected: you still can't work or unload on fields you don't own
- Multiplayer: supported, the mod must also be active on the server

## Installation

1. Download `FS22_BuildAnywhere.zip` from the [Releases](../../releases) page, or zip the contents of this repository yourself. `modDesc.xml` must be at the root of the zip.
2. Put the zip in `Documents\My Games\FarmingSimulator2022\mods`.
3. Turn on **Build Anywhere** when you load your savegame.

## Usage

Nothing to configure. Open the build menu and landscape, paint or place things on any land.

To keep the chainsaw restricted to your own land, set `BuildAnywhere.ALLOW_CHAINSAW = false` in `scripts/BuildAnywhere.lua`.

## How it works

FS22 only checks land ownership in a few places. The mod skips the "land not owned" part of these checks and leaves the rest:

- `ConstructionBrush:verifyAccess`: the build menu check used by every brush (sculpt, paint, foliage, trees, fences, placeables)
- `Landscaping.isModificationAreaOnOwnedLand`: the server-side check for terrain sculpting and painting
- `Chainsaw:isCuttingAllowed`: the chainsaw check

## Status

This is an early version and hasn't been fully tested in game yet. If something doesn't work, open
`Documents\My Games\FarmingSimulator2022\log.txt`, search for `BuildAnywhere`, and open an issue with those lines.

## Files

- `modDesc.xml`: mod description
- `scripts/BuildAnywhere.lua`: the overrides for the land ownership checks

## Credits

Made by Timo.
