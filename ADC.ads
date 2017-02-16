with Interfaces;		use Interfaces;

package ADC is
	type ADC_16bit_Unsigned is new Unsigned_16 range 0 .. 2**10-1;

	type Result_Record is
	  record
		High_Byte : Unsigned_8 := 0; -- ADCH
		Low_Byte  : Unsigned_8 := 0; -- ADCL
		Completed : Boolean := False;
	 end record;

	--Delta specified must be a power of 2, so it is used directly,
	--Unless using a specific range - delta must be a power of 10 - ARM Page 81
	type To_Volts is delta 0.005 range 0.0 .. 5.0; -- 5.0 volts
	for  To_Volts'Size use 16;

	procedure Initialize;

	procedure Start_Conversion;

	function Conv_Complete return Boolean;

	function Get_Result return Result_Record;

	function Compute_Volts_From_ADC return To_Volts;

end ADC;
