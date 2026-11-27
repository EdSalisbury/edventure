# EdVenture

An adventure (roguelike) for the Atari 8-bit, written in 6502 assembly (MADS), built
episode by episode on Ed's YouTube channel, Mission: Ed Possible, from 2021.

**`main` is the current code.** As of 2026-11-27 that's episode 29's work: the monster
aggro bitfield (`episode_29_work`, 2026-04-06). Episodes 25 to 29 are written but not
yet recorded or published.

## Building

    mads -l -t main.asm

writes `main.obj`, an Atari executable (XEX). Run it in Altirra or atari800, or on
real hardware.

## Branches
Each episode is a commit on its own branch, so every episode can be built as it was:

| Branches | What |
|---|---|
| `episode_1` ... `episode_24` | the published episodes (2021-10 to 2025-04) |
| `episode_25_work` ... `episode_29_work` | episodes 25-29, written (2026-03/04), not yet published |
| `episode_N_work`, `work`, `work_9`, `epi_20_work`, `*_new`, `*_old` | work in progress along the way |
| `prototype-2021` | the July 2021 - January 2022 prototype from before episode 1, with the episode video snippets |
| `stash-episode-22`, `stash-episode-23-wip` | two old stashes, kept as branches |
| `stash` | a 2023 branch named "stash" (not a git stash) |

The branches don't form one straight line (episodes 10, 11, 13 and 16 started from
earlier points), so `main` was brought up to date with a merge rather than by moving it.

## Archive
Ed's archive keeps a playable Windows build (`EdVenture.exe`, the game inside an
emulator), a screenshot and a short video for every episode, in `Games\EdVenture`.

## Notes
- `docs/design_document.pdf`: the 2023 design document.
- `scripts/tile_maker.py`: PNG tile sheets to `.asm` character data.
