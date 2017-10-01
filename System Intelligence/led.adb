--LED PACKAGE IMPLEMENTED BY JORDAN L MAURO-BUHAGIAR
with AVR.MCU;
use AVR;

package body LED is

	LED  : Boolean renames MCU.PORTB_Bits(1);
	LED0 : Boolean renames MCU.PORTB_Bits(0);

	procedure Setup_LED_Ports is
	begin

		MCU.DDRB_Bits (1) := DD_Output;
		MCU.DDRB_Bits (0) := DD_Output;

	end Setup_LED_Ports;

	procedure Turn_Red_On (Item : in Boolean) is
	begin
		LED0 := Item;
	end Turn_Red_On;

	procedure Turn_Blue_On (Item : in Boolean) is
	begin
		LED := Item;
	end Turn_Blue_On;

end LED;
