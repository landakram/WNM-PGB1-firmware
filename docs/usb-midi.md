# USB MIDI Bridge Mode

This firmware adds a USB MIDI bridge/routing layer so the PGB-1 can forward MIDI between USB and DIN directions, while still supporting local sequencing behavior.

## What changed

- Added a dedicated MIDI routing layer:
  - `common/wnm-midi_routing.ads`
  - `common/wnm-midi_routing.adb`
- Integrated routing into MIDI utility/task paths:
  - incoming MIDI handling
  - note-off sequencing path
  - short-term sequencer/task processing hooks
- Added persistent settings and UI menu controls for MIDI routing options.
- Added device-side USB support dependency in `device/alire.toml`.
- Added HAL-side USB MIDI implementation on device and simulator HALs.

## User-facing behavior

The routing layer supports bidirectional MIDI thru behavior (USB <-> external MIDI) with settings in MIDI/global menu pages.

At a high level you can configure whether to:

- pass external MIDI in to USB out
- pass USB MIDI in to external MIDI out
- send sequencer/project MIDI output to USB

`USB MIDI` now acts as a master enable for USB bridge behavior:

- TRS -> USB thru only forwards when `USB MIDI` is enabled
- USB -> TRS thru only forwards when `USB MIDI` is enabled
- USB input is ignored when `USB MIDI` is disabled

The MIDI settings UI is split into two top-level tabs/groups:

- `MIDI Clock` (`Clock In`, `Clock Out`)
- `USB MIDI` (`USB MIDI`, `USB MIDI Output`, `TRS -> USB Thru`, `USB -> TRS Thru`)

## Firmware architecture notes

- Routing is centralized so one source event can fan out to multiple sinks.
- Local synth/sequencer handling remains active; routing options control bridge/output
  forwarding behavior.
- Settings are persisted so bridge behavior survives reboot/project transitions.

## Hardware caveats

- This is USB MIDI bridging on the existing USB-C device interface.
- No additional hardware changes are required for the implemented bridge mode.

## Files touched by USB MIDI work

- `common/wnm-midi_routing.ads`
- `common/wnm-midi_routing.adb`
- `common/gui/wnm-gui-menu-midi_settings.ads`
- `common/gui/wnm-gui-menu-midi_settings.adb`
- `common/wnm-midi_utils.adb`
- `common/wnm-note_off_sequencer.adb`
- `common/wnm-persistent.ads`
- `common/wnm-persistent.adb`
- `common/wnm-project-step_sequencer.adb`
- `common/wnm-short_term_sequencer.adb`
- `common/wnm-tasks.adb`
- `common/wnm_hal.ads`
- `device/src/wnm_hal.adb`
- `simulator/src/wnm_hal.adb`
- `device/alire.toml`
- `device/wnm_pgb1_device.gpr`
