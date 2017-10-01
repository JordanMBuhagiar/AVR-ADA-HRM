--TIMER PACKAGE IMPLEMENTED BY JORDAN L MAURO-BUHAGIAR
with AVR;
use AVR;

with AVR.MCU;
use AVR.MCU;

with Interfaces;
use interfaces;

package Timer is

	procedure Init;
	function CounterCompare_InterruptSet return Boolean;
	procedure ResetFlag;
end Timer;
