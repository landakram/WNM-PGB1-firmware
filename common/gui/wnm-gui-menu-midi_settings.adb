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
with WNM.Project;

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
          when Clock_In | Clock_Out => MIDI_Clock,
          when others               => USB_MIDI);

   function On_Off (Value : Boolean) return String
   is (if Value then "On" else "Off");

   procedure Toggle_Current (This : in out Instance) is
   begin
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
   end Toggle_Current;

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
         when MIDI_Clock =>
            Draw_Title ("MIDI Clock", "");

            Draw_Volume (Id       => WNM.Project.A,
                         Value    => 0,
                         Label    => On_Off (Persistent.Data.MIDI_Clock_Input),
                         Selected => Sub = Clock_In);

            Draw_Volume (Id       => WNM.Project.B,
                         Value    => 0,
                         Label    =>
                           On_Off (Persistent.Data.MIDI_Clock_Output),
                         Selected => Sub = Clock_Out);

         when USB_MIDI =>
            Draw_Title ("USB MIDI", "");

            Draw_Volume (Id       => WNM.Project.A,
                         Value    => 0,
                         Label    => On_Off (Persistent.Data.USB_MIDI_Enabled),
                         Selected => Sub = USB_Enable);

            Draw_Volume (Id       => WNM.Project.B,
                         Value    => 0,
                         Label    => On_Off (Persistent.Data.USB_MIDI_Output),
                         Selected => Sub = USB_Output);

            Draw_Volume
              (Id       => WNM.Project.C,
               Value    => 0,
               Label    => On_Off (Persistent.Data.USB_MIDI_Thru_TRS_to_USB),
               Selected => Sub = USB_Thru_TRS_to_USB);

            Draw_Volume
              (Id       => WNM.Project.D,
               Value    => 0,
               Label    => On_Off (Persistent.Data.USB_MIDI_Thru_USB_to_TRS),
               Selected => Sub = USB_Thru_USB_to_TRS);

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
            Toggle_Current (This);

         when Down_Press =>
            Toggle_Current (This);

         when B_Press =>
            Menu.Pop (Exit_Value => Failure);

         when others =>
            null;
      end case;
   end On_Event;

end WNM.GUI.Menu.MIDI_Settings;
