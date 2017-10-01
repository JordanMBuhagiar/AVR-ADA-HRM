-- HRM - CONTROLLER PACKAGE IMPLEMENTED BY JORDAN L MAURO-BUHAGIAR
-- USING THRESH PEAK ALGORITHM FOR PULSE OR PEAK DETECTION
with ADC;
use ADC;

with LCD;
use LCD;

with Timer;
use Timer;

with Safety;
use Safety;

with LED;
use LED;

--Main Program makes used of ADC and LCD packages (Timer Package will be added if testing of its functionality is accomplished)
procedure Controller is
-- Declare Values of interest globally
-- Initialize values of interest to a default value
    PrevPrev    : ADC.To_Volts := 0.0;
    Prev        : ADC.To_Volts := 0.0;
    Current     : ADC.To_Volts := 0.0;
    Next        : ADC.To_Volts := 0.0;
    NextNext    : ADC.To_Volts := 0.0;
--Declare and Initialize Counter, Pulse and HR
    pulse	: Integer := 0;
    Counter : Integer := 0;
    HR : Integer := 0;
begin
    Setup_LED_Ports;
    Turn_Red_On(True);
    --Initialize
    ADC.Initialize;
    LCD.Initialize;
    LCD.Clear_Screen;
    LCD.Calibrate_System_UI;
    loop
        -- Start Conversion
        ADC.Start_Conversion;
        -- We test if conversion is completed, if True (result is stored into the array)
        -- We increase the counter every time a conversion is complete and stored
        if ADC.Conv_Complete then
            NextNext := ADC.Compute_Volts_From_ADC;
            --threshold of 2.7 volts anything below is ignored
            if (NextNext >= 2.7) then
                -- Assign Values of Interest
                PrevPrev := Prev;
                Prev     := Current;
                Current  := Next;
                Next     := NextNext;
                --if current is bigger than all values of interest then we have located a peak/pulse
                if (Current > Prev and Current > PrevPrev and Current > Next and Current > NextNext) then
                    --pulse detected so we increment number of pulses
                    pulse := pulse + 1;
                    if (pulse = 1) then
                        Timer.Init;
                        Turn_Blue_On(True);
                        Turn_Red_On(False);
                    end if;
                end if;
                LCD.Put("Detecting BPM...");
                --Interrupt is set when the TimerCounter1 Hits 62499 (which is the value set on the output compare register)
                --When Flag is reset by writing a logical one to it, the timerCounter1 resets automatically and restarts counting.
                --Every interrupt is triggered after 1 second, thus, we wait for the interrupt to be triggered 10 times.
                if (Timer.CounterCompare_InterruptSet) then
                    LCD.Clear_Screen;
                    Counter := Counter +1;
                    if(Counter =10) then
                        -- calculate BPM and display it
                        HR := pulse * 6;
                        LCD.Put("BPM:");
                        LCD.GotoXY(7,1);
                        LCD.Display_Int(HR);
                        Turn_Blue_On(False);
                        Turn_Red_On(True);
                        Safety.HR_is(HR);
                        exit;
                    else
                        LCD.Clear_Screen;
                    end if;
                    Timer.ResetFlag;
                end if;
                LCD.Clear_Screen;
            else
                -- Values remain the same
                PrevPrev := PrevPrev;
                Prev     := Prev;
                Current  := Current;
                Next     := Next;
                NextNext := NextNext;
            end if;
        end if;
     end loop;
end Controller;


