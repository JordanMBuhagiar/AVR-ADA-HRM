--SAFETY PACKAGE IMPLEMENTED BY JORDAN L MAURO-BUHAGIAR
with LCD;
use LCD;

package body Safety is
	procedure HR_is (HR : in Integer) is
		status : Medical_State := Red_Alert_Low;
	begin
		status := HRCheck (HR);
		PrintHRStatus(status);
	end HR_is;

	function HRCheck (HR : Integer) return Medical_State is
	begin
		if (HR >= 120) then
			return Red_Alert_High;
		elsif (HR >=100) then
			return Amber_Alert_High;
		elsif (HR >= 83) then
			return Poor_High;
		elsif (HR >= 52) then
			return Excellent;
		elsif (HR >= 40) then
			return Poor_Low;
		elsif (HR < 40) then
			return Red_Alert_Low;
		end if;
	end HRCheck;

	--Knows how to print its result!
	procedure PrintHRStatus (status : in Medical_State) is
	begin
		if (status = Red_Alert_High) then
			LCD.GotoXY(1,2);
			LCD.Put("RED: At RISKK!");
		elsif (status = Amber_Alert_High) then
			LCD.GotoXY(1,2);
			LCD.Put("Amber: Risky!");
		elsif (status = Poor_High) then
			LCD.GotoXY(1,2);
			LCD.Put("Poor: No Risk");
		elsif (status = Excellent) then
			LCD.GotoXY(1,2);
			LCD.Put("RHR Excellent");
		elsif (status = Poor_Low) then
			LCD.GotoXY(1,2);
			LCD.Put("Poor: No Risk");
		elsif (status = Red_Alert_Low) then
			LCD.GotoXY(1,2);
			LCD.Put("RED: At RISKK!");
		end if;
	end PrintHRStatus;
end Safety;


