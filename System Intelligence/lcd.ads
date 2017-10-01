--LCD PACKAGE IMPLEMENTED BY JORDAN L MAURO-BUHAGIAR
--(ALTERED CRUCIAL PROCEDURES FROM LCD MAIN PACKAGE TO SUIT PROJECT SPECS)
--EMPLOYED NEW PROCEDURES TO SUIT PROJECT SPECS
with Interfaces;		use Interfaces;
with AVR.Strings;		use AVR.Strings;

package LCD is
	pragma Preelaborate;

	type Line_Position is new Unsigned_8 range 1 .. 2;
	type Char_Position is new Unsigned_8 range 1 .. 16;
	type Command_Type is new Unsigned_8;

------------------------------------------------------------------------

	procedure Toggle_Enable;

	procedure Output (Cmd : Unsigned_8; Is_Data : Boolean := False);

	procedure Initialize;

	procedure Put (C : Character);

	procedure Put (S : AVR_String);

	procedure Command (Cmd : Command_Type);

	procedure Clear_Screen;

	procedure Home;

	procedure GotoXY (X : Char_Position; Y : Line_Position);

	procedure Display_Int(Result : in Integer);

	procedure Calibrate_System_UI;

------------------------------------------------------------------------

	package Commands is
		Clear                   : constant Command_Type := 16#01#;
		Home                    : constant Command_Type := 16#02#;

		--  interface data width and number of lines
		Mode_4bit_1line         : constant Command_Type := 16#20#;
		Mode_4bit_2line         : constant Command_Type := 16#28#;
		Mode_8bit_1line         : constant Command_Type := 16#30#;
		Mode_8bit_2line         : constant Command_Type := 16#38#;

		--  display on/off, cursor on/off, blinking char at cursor position
		Display_Off             : constant Command_Type := 16#08#;
		Display_On              : constant Command_Type := 16#0C#;
		Display_On_Blink        : constant Command_Type := 16#0D#;
		Display_On_Cursor       : constant Command_Type := 16#0E#;
		Display_On_Cursor_Blink : constant Command_Type := 16#0F#;

		--  entry mode
		Entry_Inc               : constant Command_Type := 16#06#;
		Entry_Dec               : constant Command_Type := 16#04#;
		Entry_Shift_Inc         : constant Command_Type := 16#07#;
		Entry_Shift_Dec         : constant Command_Type := 16#05#;

		--  cursor/shift display
		Move_Cursor_Left        : constant Command_Type := 16#10#;
		Move_Cursor_Right       : constant Command_Type := 16#14#;
		Move_Display_Left       : constant Command_Type := 16#18#;
		Move_Display_Right      : constant Command_Type := 16#1C#;
	end Commands;

private
	pragma Inline (Command);

end LCD;
