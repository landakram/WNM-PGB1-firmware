-------------------------------------------------------------------------------
--                                                                           --
--                              Wee Noise Maker                              --
--                                                                           --
--                  Copyright (C) 2026 Fabien Chouteau                       --
--                                                                           --
--    Wee Noise Maker is free software: you can redistribute it and/or       --
--    modify it under the terms of the GNU General Public License as         --
--    published by the Free Software Foundation, either version 3 of the     --
--    License, or (at your option) any later version.                        --
--                                                                           --
--    Wee Noise Maker is distributed in the hope that it will be useful,     --
--    but WITHOUT ANY WARRANTY; without even the implied warranty of         --
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU       --
--    General Public License for more details.                               --
--                                                                           --
--    You should have received a copy of the GNU General Public License      --
--    along with We Noise Maker. If not, see <http://www.gnu.org/licenses/>. --
--                                                                           --
-------------------------------------------------------------------------------

with MIDI; use MIDI;

with WNM.Coproc;
with WNM.MIDI_Clock;
with WNM.Persistent;
with WNM.Project;
with WNM_HAL;

package body WNM.MIDI_Routing is

   ------------------
   -- Handle_Input --
   ------------------

   procedure Handle_Input (Source : MIDI_Source; Msg : MIDI.Message) is
   begin
      case Msg.Kind is
         when MIDI.Sys =>
            case Msg.Cmd is
               when MIDI.Start_Song =>
                  if Persistent.Data.MIDI_Clock_Input then
                     WNM.MIDI_Clock.External_Start;
                  end if;

               when MIDI.Stop_Song =>
                  WNM.MIDI_Clock.External_Stop;

               when MIDI.Continue_Song =>
                  if Persistent.Data.MIDI_Clock_Input then
                     WNM.MIDI_Clock.External_Continue;
                  end if;

               when MIDI.Timming_Tick =>
                  WNM.MIDI_Clock.External_Tick;

               when others =>
                  null;
            end case;

         when Note_On | Note_Off | Continous_Controller =>
            if Msg.Chan = 0 then
               WNM.Project.Handle_MIDI (Msg);
            else
               WNM.Coproc.Push_To_Synth ((Kind     => WNM.Coproc.MIDI_Event,
                                          MIDI_Evt => Msg));
            end if;

         when others =>
            null;
      end case;

      case Source is
         when External_TRS =>
            if Persistent.Data.USB_MIDI_Enabled
              and then Persistent.Data.USB_MIDI_Thru_TRS_to_USB
            then
               WNM_HAL.Send_USB (Msg);
            end if;

         when USB =>
            if Persistent.Data.USB_MIDI_Enabled
              and then Persistent.Data.USB_MIDI_Thru_USB_to_TRS
            then
               WNM_HAL.Send_External (Msg);
            end if;

         when Internal =>
            null;
      end case;
   end Handle_Input;

   -----------------
   -- Send_Output --
   -----------------

   procedure Send_Output (Msg : MIDI.Message) is
   begin
      WNM_HAL.Send_External (Msg);

      if Persistent.Data.USB_MIDI_Enabled
        and then Persistent.Data.USB_MIDI_Output
      then
         WNM_HAL.Send_USB (Msg);
      end if;
   end Send_Output;

end WNM.MIDI_Routing;
