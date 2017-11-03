
# AVR-Ada-HRM
AVR-ADA used to develop a HRM Prototype,

For complete code, follow system intelligence folder.

System withholds an ATMega328P and code is written to initialize the following: ADC, Timer1 - CTC Mode and LCD in 4 Bit Mode.

Additionally, the controller has an Algorithm introduced as part of a Thesis called Thresh Peak Algorithm to detect the pulses.

Furthermore, the code has been designed to control the way the user interacts with the Sensor - A safety mechanism was applied.

Unless the system detects a peak, it will not execute. Thus, will run for a 10 second time frame as long as the peaks are being detected, otherwise it will wait for the user to position the sensor once again and proceed from the las timer count, preventing false values and enforcing reliability regarding system feedback. 

The Thesis will hopefully be published depending on the people who are interested on having a look at it. The thesis withholds a step-by-step Tutorial on how to install AVR-ADA under a linux distribution. A tutorial that has been tested on 2 separate Linux Ubuntu Distros in order to enforce consistency via error prevention/elimination. 

For further information or queries, contact me on:
# jordanleemauro@gmail.com
or
# jordan.mauro.buhagiar@hotmail.com
