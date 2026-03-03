# Macro Instrument Routing (Tracks 12–16)

This firmware adds 4 extra macro synth slots exposed as **Macro 1..4**.

## What changed

- Added four extra macro instances on dedicated internal channels:
  - `Macro 1` -> internal synth channel `Lead2_Channel`
  - `Macro 2` -> internal synth channel `Lead3_Channel`
  - `Macro 3` -> internal synth channel `Lead4_Channel`
  - `Macro 4` -> internal synth channel `Lead5_Channel`
- Added new track modes:
  - `Macro1_Mode`, `Macro2_Mode`, `Macro3_Mode`, `Macro4_Mode`
- Restricted mode selection for tracks `12..16`:
  - Allowed: `MIDI`, `Macro 1`, `Macro 2`, `Macro 3`, `Macro 4`
  - Disallowed: all other instrument/FX modes
- Non-12..16 tracks cannot select macro modes.

## Defaults

Default mode assignment now is:

- Track 12: `Macro 1`
- Track 13: `Macro 2`
- Track 14: `Macro 3`
- Track 15: `Macro 4`
- Track 16: `MIDI`

## Runtime behavior and resource model

- Only **four extra** macro instances are allocated.
- All four extra instances use shared DSP buffer slices in `WNM.Shared_Buffers`.
- Extra instance structs are placed in `.scratch_x` RAM.
- Extra channels are actively gated:
  - If no track uses `Macro 1..4`, the corresponding synth channel is marked inactive.
  - Channel activity is recomputed on every track mode change, including transitions
    between `Macro X` and `MIDI` on tracks `12..16`.
  - Inactive extra channels do not process MIDI events, param application, LFO modulation, or rendering.
  - This avoids idle-channel noise/FX bleed.

## Project file compatibility

Project storage format is now version `3`.

- v1 projects: legacy track mode boolean is still mapped via defaults.
- v2 projects: track mode entries are consumed but mode falls back to track defaults.
- v3 projects: full enum track mode serialization for `Macro 1..4`.

## Notes

- The original `Lead` and `Bass` tracks (tracks 4 and 5) remain unchanged.
- `Macro 1..4` use the same macro engine catalog used by lead/bass macro voices.
