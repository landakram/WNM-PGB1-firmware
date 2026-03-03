-------------------------------------------------------------------------------
--                                                                           --
--                              Wee Noise Maker                              --
--                                                                           --
--                  Copyright (C) 2016-2023 Fabien Chouteau                  --
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

with WNM.GUI.Menu.Drawing; use WNM.GUI.Menu.Drawing;
with WNM.Persistent;

package body WNM.GUI.Menu.MIDI_Settings is

   Singleton : aliased Instance;

   -----------------
   -- Push_Window --
   -----------------

   procedure Push_Window is
   begin
      Push (Singleton'Access);
   end Push_Window;

   ------------
   -- To_Top --
   ------------

   function To_Top (S : Sub_Settings) return Top_Settings
   is (case S is
          when others => MIDI_Misc);

   ----------
   -- Draw --
   ----------

   overriding
   procedure Draw (This   : in out Instance) is
      Sub : constant Sub_Settings := This.Current_Setting;
      Top : constant Top_Settings := To_Top (Sub);

   begin
      Draw_Menu_Box
        ("MIDI settings",
         Count => Top_Settings_Count,
         Index => Top_Settings'Pos (To_Top (This.Current_Setting)));

      case Top is
         when MIDI_Misc =>
            case This.Current_Setting is
               when Clock_In =>
                  Draw_Title ("MIDI Clock Input", "");
                  Draw_Value ((if Persistent.Data.MIDI_Clock_Input then "On"
                               else "Off"),
                              Selected => True);
               when Clock_Out =>
                  Draw_Title ("MIDI Clock Output", "");
                  Draw_Value ((if Persistent.Data.MIDI_Clock_Output then "On"
                               else "Off"),
                              Selected => True);
               when USB_Enable =>
                  Draw_Title ("USB MIDI", "");
                  Draw_Value ((if Persistent.Data.USB_MIDI_Enabled then "On"
                               else "Off"),
                              Selected => True);
               when USB_Output =>
                  Draw_Title ("USB MIDI Output", "");
                  Draw_Value ((if Persistent.Data.USB_MIDI_Output then "On"
                               else "Off"),
                              Selected => True);
               when USB_Thru_TRS_to_USB =>
                  Draw_Title ("TRS -> USB Thru", "");
                  Draw_Value ((if Persistent.Data.USB_MIDI_Thru_TRS_to_USB
                               then "On" else "Off"),
                              Selected => True);
               when USB_Thru_USB_to_TRS =>
                  Draw_Title ("USB -> TRS Thru", "");
                  Draw_Value ((if Persistent.Data.USB_MIDI_Thru_USB_to_TRS
                               then "On" else "Off"),
                              Selected => True);
            end case;

      end case;
   end Draw;

   --------------
   -- On_Event --
   --------------

   overriding
   procedure On_Event (This  : in out Instance;
                       Event : Menu_Event)
   is
   begin
      case Event.Kind is
         when Left_Press =>
            Prev (This.Current_Setting);
         when Right_Press =>
            Next (This.Current_Setting);

         when Up_Press =>
            case This.Current_Setting is
               when Clock_In =>
                  Persistent.Data.MIDI_Clock_Input := not @;
               when Clock_Out =>
                  Persistent.Data.MIDI_Clock_Output := not @;
               when USB_Enable =>
                  Persistent.Data.USB_MIDI_Enabled := not @;
               when USB_Output =>
                  Persistent.Data.USB_MIDI_Output := not @;
               when USB_Thru_TRS_to_USB =>
                  Persistent.Data.USB_MIDI_Thru_TRS_to_USB := not @;
               when USB_Thru_USB_to_TRS =>
                  Persistent.Data.USB_MIDI_Thru_USB_to_TRS := not @;
            end case;

         when Down_Press =>
            case This.Current_Setting is
               when Clock_In =>
                  Persistent.Data.MIDI_Clock_Input := not @;
               when Clock_Out =>
                  Persistent.Data.MIDI_Clock_Output := not @;
               when USB_Enable =>
                  Persistent.Data.USB_MIDI_Enabled := not @;
               when USB_Output =>
                  Persistent.Data.USB_MIDI_Output := not @;
               when USB_Thru_TRS_to_USB =>
                  Persistent.Data.USB_MIDI_Thru_TRS_to_USB := not @;
               when USB_Thru_USB_to_TRS =>
                  Persistent.Data.USB_MIDI_Thru_USB_to_TRS := not @;
            end case;

         when B_Press =>
            Menu.Pop (Exit_Value => Failure);

         when others =>
            null;
      end case;
   end On_Event;

end WNM.GUI.Menu.MIDI_Settings;
