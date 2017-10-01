--LCD WIRELESS IMPLEMENTED BY JORDAN L MAURO-BUHAGIAR
--MANIPULATED ORIGINAL LCD-WIRING PACKAGE TO ADAPT MCU/LCD IO SPECS
with AVR;                          use AVR;
with AVR.MCU;			   use AVR.MCU;
with AVR.Atmega328P;
with Interfaces; use Interfaces;
private package LCD.Wiring is
   pragma Preelaborate;
   --LCD data buses
   Data0             : Boolean renames MCU.PORTD_Bits (PORTD0_Bit);
   Data1             : Boolean renames MCU.PORTD_Bits (PORTD1_Bit);
   Data2             : Boolean renames MCU.PORTD_Bits (PORTD2_Bit);
   Data3             : Boolean renames MCU.PORTD_Bits (PORTD3_Bit);
   Data0_DD          : Boolean renames MCU.DDRD_Bits (DDD0_Bit);
   Data1_DD          : Boolean renames MCU.DDRD_Bits (DDD1_Bit);
   Data2_DD          : Boolean renames MCU.DDRD_Bits (DDD2_Bit);
   Data3_DD          : Boolean renames MCU.DDRD_Bits (DDD3_Bit);

   --LCD control bits

   RegisterSelect    : Boolean renames MCU.PORTD_Bits (PORTD4_Bit);
   RegisterSelect_DD : Boolean renames MCU.DDRD_Bits (DDD4_Bit);
   ReadWrite         : Boolean renames MCU.PORTD_Bits (PORTD5_Bit);
   ReadWrite_DD      : Boolean renames MCU.DDRD_Bits (DDD5_Bit);
   Enable            : Boolean renames MCU.PORTD_Bits (PORTD6_Bit);
   Enable_DD         : Boolean renames MCU.DDRD_Bits (DDD6_Bit);

   --processor

   Processor_Speed   : constant := 16_000_000;

end LCD.Wiring;
