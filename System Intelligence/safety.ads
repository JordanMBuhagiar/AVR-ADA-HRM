-- SAFETY PACKAGE IMPLEMENTED BY JORDAN L MAURO-BUHAGIAR

package Safety is

	type Medical_State is ( Red_Alert_High,
				Amber_Alert_High,
				Poor_High,
				Excellent,
				Poor_Low,
				Red_Alert_Low);

	procedure HR_is (HR : in Integer);
	function HRCheck (HR : Integer) return Medical_State;
	procedure PrintHRStatus (status : in Medical_State);

end Safety;




--# with
--#	   	Post => ((if (HR >= 120) then HRCheck'Result = Red_Alert_High)
--#	and (if (HR >= 100 and HR < 120) then HRCheck'Result = Amber_Alert_High)
--#	and (if (HR >= 80 and HR < 100) then HRCheck'Result = Poor_High)
--#	and (if (HR >= 54 and HR < 80) then HRCheck'Result = Excellent)
--#	and (if (HR >= 40 and HR < 54) then HRCheck'Result = Poor_Low)
--#	and (if (HR < 40) then HRCheck'Result = Red_Alert_Low));
