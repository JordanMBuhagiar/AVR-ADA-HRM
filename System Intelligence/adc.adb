-- ADC PACKAGE IMPLEMENTED BY JORDAN L MAURO-BUHAGIAR
with AVR.MCU;				use AVR;
with AVR.Real_Time.Delays; 	use AVR.Real_Time.Delays;
with AVR.Strings;			use AVR.Strings;
--ADC Package used by Main
package body ADC is

	--Bits of interest

 	ADC_Start_Conversion 	: Boolean renames MCU.ADCSRA_Bits (MCU.ADSC_Bit);
  	ADC_Enable 				: Boolean renames MCU.ADCSRA_Bits (MCU.ADEN_Bit);
	ADC_Interrupt_Flag 		: Boolean renames MCU.ADCSRA_Bits (MCU.ADIF_Bit);
	ADC_Left_Just_Read		: Boolean renames MCU.ADMUX_Bits (MCU.ADLAR_Bit);

-----------------------------------------------------------------------------------------------------------------------
	procedure Initialize is
	begin
		--set Analogue Port to Input
			MCU.DDRC_Bits := (others => DD_Input);

		--ADC Multiplexer Selection Register := ADMUX:
		--Select Reference Source : AVcc := 5v : REFS1:=0 REFS0:=1
		--Select ADC Channel to Read : MUX3:0 := 0000 Channel0 PortC0
		--Set_ADC Left Adjust Result : ADLAR := 1 or 0 to Right_Adjust ---> A328p.ADMUX := 2#0100_0000#
			MCU.ADMUX :=  MCU.ADMUX and 2#0100_0000#;

		--ADC Status and Control Register := ADCSRA:
		--Select Prescaler 128 := ADPS2:0 : 111 --> 16MHZ/128 = 125KHz
		--Set: ADENable:= 1 : ADSC:= 0 (StartConversion when required)
		--Set: ADInteruptFlag : ADIF:= 0 : ADIE:= 0 ---> A328P.ADCSRA := 2#1000_0111#
			MCU.ADCSRA := 2#1000_0111#;

		--Disable Digital Input for the ADC Pins: A328P.DIDR0 := 2#1111_1111# --reduces power consumption during buffer
			MCU.DIDR0 := 2#1111_1111#;

	end Initialize;

-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

	procedure Start_Conversion is

		Result : Result_Record;

	begin
		-- The Start_Convertion () routine is called whenever the application needs an ADC conversion.

		-- Set the Start Conversion bit (ADSC:6) in ADCSRA to start a single conversion.

		 ADC_Start_Conversion := True;

		-- Poll (wait) for the Interrupt Flag (ADIF) bit in the ADCSRA register to be set,
		-- indicating that a new conversion is completed.
		-- At this instance conversion completion is active.. i.e.

		Result.Completed := False;

	end Start_Conversion;

-----------------------------------------------------------------------------------------------------------------------

	function Conv_Complete return Boolean is

		--  Once the conversion is over (ADIF bit ADCSRA:4) becomes high,
		--  then read the ADC data register pair (ADCL/ADCH) to get the 10-bit result.
	begin

		return ADC_Interrupt_Flag /= False;		-- ADIF is set

	end Conv_Complete;

-----------------------------------------------------------------------------------------------------------------------

	function Get_Result return Result_Record is
		Result : Result_Record;
	begin

		if Conv_Complete then -- ADIF is set

			--DS:ADIF is cleared by writing a logical one to the flag.

			ADC_Interrupt_Flag := True;

			Result.Low_Byte		:= MCU.ADCL; -- ADC Data Register Low Byte
			Result.High_Byte	:= MCU.ADCH; -- ADC Data Register High Byte
			Result.Completed	:= True;

		else

			return Result;

		end if;

		return Result;

	end Get_Result;

-----------------------------------------------------------------------------------------------------------------------

	function Compute_Volts_From_ADC return ADC.To_Volts is

		-- Declare Variables of type Result_Record, To_Volts and Lowest Significant bit of a 10Bit Unsigned value
		ADC_Reading 				: Result_Record;
		ADC_Reading_in_Volts		: ADC.To_Volts;

		-- LSB -- Specify Resolution of 10Bit: 5.0/1024. Since delta is 0.005, some precision is lost. however, it is minor.
		LSB10 						: constant Float := 0.004882812;

	begin

		-- Get ADC Result
		ADC_Reading := ADC.Get_Result;

		declare 		-- Code Block

			-- new 16Bit type to store our value
			ADC_10_Bit :  ADC_16bit_Unsigned;

		begin
				--	Shift Left 8 spaces our ADCH Byte to create our 10 bit by concatenating our ADCL byte on the lower 0 - 7 bits
				ADC_10_Bit  := Shift_Left(ADC_16bit_Unsigned(ADC_Reading.High_Byte),8)
				                     + ADC_16bit_Unsigned(ADC_Reading.Low_Byte);

			Calculate_Reading_10:	-- New Code Block to perform our final calculation

			declare

				-- Perform checks using Compiler Directive pragma Suppress:

				pragma SUPPRESS(ALL_CHECKS);

				-- This will give permission to this implementation to omit certain language-defined checks

			begin

				-- Multiply our LSB by the 10 bit value to get reading in volts. Convert to the required type: To_Volts

				ADC_Reading_in_Volts   := ADC.To_Volts(LSB10 * Float(ADC_10_Bit ));

			end Calculate_Reading_10;

		end;

		return ADC_Reading_in_Volts;

	end Compute_Volts_From_ADC;

end ADC;

