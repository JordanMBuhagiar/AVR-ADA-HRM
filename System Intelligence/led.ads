--LED PACKAGE IMPLEMENTED BY JORDAN L MAURO-BUHAGIAR
with interfaces;
use interfaces;

package LED is

procedure Setup_LED_Ports;
procedure Turn_Red_On (Item : in Boolean);
procedure Turn_Blue_On (Item : in Boolean);

end LED;
