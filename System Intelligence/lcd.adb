--LCD PACKAGE IMPLEMENTED BY JORDAN L MAURO-BUHAGIAR
--(ALTERED CRUCIAL PROCEDURES FROM LCD MAIN PACKAGE TO SUIT THE PROJECT SPECS)
--EMPLOYED NEW PROCEDURES TO SUIT PROJECT SPECS
with Interfaces;                   			use Interfaces;
with AVR;
with AVR.MCU;
with AVR.Wait;								use AVR;
with AVR.Strings;							use AVR.Strings;
with AVR.Strings.Edit.Generic_Integers;		use AVR.Strings.Edit.Generic_Integers;
with LCD.Wiring;
--LCD Package used by Main Program
package body LCD is

   Processor_Speed : constant := LCD.Wiring.Processor_Speed;

------------------------------------------------------------------------

   procedure Wait_10ms is new AVR.Wait.Generic_Wait_Usecs
     (Crystal_Hertz => Processor_Speed,
      Micro_Seconds => 10_000);

   procedure Wait_1ms is new AVR.Wait.Generic_Wait_Usecs
     (Crystal_Hertz => Processor_Speed,
      Micro_Seconds => 1_000);

------------------------------------------------------------------------

   procedure Toggle_Enable is
      use Wiring;
	  use AVR.Wait;
   begin
      Enable := True;
      Wait_4_Cycles (1);
      Enable := False;
   end Toggle_Enable;

------------------------------------------------------------------------

	procedure Initialize is
		use LCD.Wiring;
	begin
		--Make PortD as Output using LCD-Wiring
		Enable_DD         := DD_Output;
		ReadWrite_DD      := DD_Output;
		RegisterSelect_DD := DD_Output;

		Data0_DD := DD_Output;
		Data1_DD := DD_Output;
		Data2_DD := DD_Output;
		Data3_DD := DD_Output;

		--  power up delay required 16ms

		Wait_10ms;
		Wait_10ms;

		--  send command 0x30 3 times to reset the LCD and tell it: it will be used in 4 bit mode.

		Data0 := True;
		Data1 := True;
		Toggle_Enable;

		Wait_10ms;

		--  send last command again (is still in register, just toggle E)

		Toggle_Enable;
		Wait_1ms;

		--  send last command a third time

		Toggle_Enable;
		Wait_1ms;

		--  select bus width (0x30 - for 8-bit and 0x20 for 4-bit) in this case 0x20.

		Data0 := False;

		--  send new command to the command register to enable 4bit.

		Toggle_Enable;
		Wait_1ms;

		--  select modes for operation

		Command (Commands.Mode_4bit_2line);
		Command (Commands.Display_On);
		Clear_Screen;
		Command (Commands.Entry_Inc);

	end Initialize;

------------------------------------------------------------------------

	procedure Output (Cmd : Unsigned_8; Is_Data : Boolean := False) is
		use Wiring;
	begin
		--  control pins
		ReadWrite := False;
		RegisterSelect := Is_Data;

		--  higher nibble is read first
		Data0 := (Cmd and 16#10#) /= 0;
		Data1 := (Cmd and 16#20#) /= 0;
		Data2 := (Cmd and 16#40#) /= 0;
		Data3 := (Cmd and 16#80#) /= 0;

		--  toggling enable bit initiates the commands (writes it to the chosen register)
		Toggle_Enable;

		--  then low nibble
		Data0 := (Cmd and 16#01#) /= 0;
		Data1 := (Cmd and 16#02#) /= 0;
		Data2 := (Cmd and 16#04#) /= 0;
		Data3 := (Cmd and 16#08#) /= 0;

		Toggle_Enable;

		if Is_Data then
			Wait_1ms;
		else
			Wait_10ms;
		end if;

	end Output;

------------------------------------------------------------------------

	--  output at the current cursor location
	procedure Put (C : Character) is
	begin
		Output (Character'Pos (C), Is_Data => True);
	end Put;

------------------------------------------------------------------------

	--  output a string using an overloaded method, traverse the string characters and output each char using Put (Char)
	procedure Put (S : AVR_String) is
	begin
		for C in S'Range loop
			Put (S(C));
		end loop;
	end Put;

------------------------------------------------------------------------

	--  output the command code Cmd to the display
	procedure Command (Cmd : Command_Type) is
	begin
		Output (Unsigned_8 (Cmd), Is_Data => False);
	end Command;

------------------------------------------------------------------------

	--  clear display and move cursor to home position
	procedure Clear_Screen is
	begin
		Command (Commands.Clear);
	end Clear_screen;

------------------------------------------------------------------------

	--  move cursor to home position
	procedure Home is
	begin
		Command (16#02#);
	end Home;

------------------------------------------------------------------------

	--  move cursor into line Y and before character position X.  Lines
	--  are numbered 1 to 2 (or 1 to 4 on big displays).  The left most
	--  character position is Y = 1.  The right most position is
	--  defined by Lcd.Display.Width;
	procedure GotoXY (X : Char_Position; Y : Line_Position) is
	begin
		case Y is
			when 1 => Command (16#80# + Command_Type (X) - 1);
			when 2 => Command (16#C0# + Command_Type (X) - 1);
		end case;
	end GotoXY;

	procedure Display_Int(Result : in Integer) is
		L : Unsigned_8;
		T : AVR_String(1 .. L) := (others => ' ');
	begin
			Put_U32 (Value  => Unsigned_32(Result),
				Target => T,
				Last   => L);
			Put(T(2..L)); --displays the integer into a string
	end Display_Int;

	procedure Calibrate_System_UI is
	begin
			LCD.Put("Greetings :}");
			LCD.GotoXY(1,2);
			LCD.Put("I am Ada.");
			delay 2.0;
			LCD.Clear_Screen;
			LCD.Put("I am going to");
			LCD.GotoXY(1,2);
			LCD.Put("Examine Your HR");
			delay 2.0;
			LCD.Clear_Screen;
			LCD.Put("Position Sensor");
			LCD.GotoXY(1,2);
			LCD.Put("Carefully! :}");
			delay 3.0;
			LCD.Clear_Screen;
			LCD.Put(".");
			delay 2.0;
			LCD.GotoXY(2,1);
			LCD.Put(".");
			delay 2.0;
			LCD.GotoXY(3,1);
			LCD.Put(".");
			delay 2.0;
			LCD.GotoXY(4,1);
			LCD.Put("Ready?");
			delay 1.0;
			LCD.Clear_Screen;
			LCD.Put("Detecting BPM");
			LCD.GotoXY(1,2);
			LCD.Put("NOW..");
			delay 1.0;
	end Calibrate_System_UI;
end LCD;


