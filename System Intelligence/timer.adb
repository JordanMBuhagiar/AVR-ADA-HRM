--TIMER PACKAGE IMPLEMENTED BY JORDAN L MAURO-BUHAGIAR
with AVR;
use AVR;

with AVR.MCU;
use AVR.MCU;

with Interfaces;
use Interfaces;
--ATMEGA328P Timer1 Setup CTC Mode

package body Timer is

	CS12 : Boolean renames MCU.TCCR1B_Bits (MCU.CS12_Bit);
	CS11 : Boolean renames MCU.TCCR1B_Bits (MCU.CS11_Bit);
	CS10 : Boolean renames MCU.TCCR1B_Bits (MCU.CS10_Bit);
	WGM12 : Boolean renames MCU.TCCR1B_Bits (MCU.WGM12_Bit);
	Interrupt_Flag : Boolean renames MCU.TIFR1_Bits (MCU.OCF1A_Bit);
	TCNT1 : Unsigned_16 renames MCU.TCNT1;

	procedure Init is
	begin
		--Initializes Prescaler 256 and CTC Mode (TCCR1B (CS12 ---> 1) WGM12 ---> 1)
		--MCU.TCCR1B := (MCU.TCCR1B and 2#1111_0100#) or 2#0000_1011#;
		CS12 := True;  WGM12 := True;

		--Initialize Counter
		TCNT1 := 0;

		--Initialize Compare Value: 16MHz/256 = 1/62500 = (1000msDelay/0.016ms) -1 = 62499
		MCU.OCR1A := 62499;
	end Init;

	function CounterCompare_InterruptSet return Boolean is
		--Check the TIFR Register for the OCF1A Flag
		--When a match is found after the comparison Flag becomes active
		--we return true if flag is active
	begin
		return Interrupt_Flag /= False;		-- OCF1A is set
	end CounterCompare_InterruptSet;

	procedure ResetFlag is
	begin
		--write a logical one to reset i.e.flag becomes true (1)
		Interrupt_Flag := True;
	end resetflag;

end Timer;
