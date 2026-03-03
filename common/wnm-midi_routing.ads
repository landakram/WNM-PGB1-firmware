with MIDI;

package WNM.MIDI_Routing is

   type MIDI_Source is (External_TRS, USB, Internal);

   procedure Handle_Input (Source : MIDI_Source; Msg : MIDI.Message);

   procedure Send_Output (Msg : MIDI.Message);

end WNM.MIDI_Routing;
