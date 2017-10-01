# AVR-Ada-HRM
AVR-ADA used to develop a HRM Prototype,

for complete code, follow system intelligence folder.

System withholds an ATMega328P and code is written to initialize ADC, Timer1 on CTC Mode and LCD on 4 Bit Mode.

Additionally, the controller has an Algorithm introduced as part of a Thesis called Thresh Peak Algorithm to detect the pulses.

Furthermore, the code has been designed to control the way the user interacts with the Sensor.

Unless the system detects a peak, it will not execute. Thus, will run for a 10 second time frame as long as the peaks are being detected, otherwise it will wait for the user to have the sensor placed back and then proceed. This forbids users from getting unreliable results.

The Thesis will hopefully be published depending on the people who are interested on having a look at it. It withholds a Tutorial on how to install AVR-ADA step by step under a linux distribution. It has been tested on 2 separate OS and has proved to be effective. Tools will be provided soon  with the thesis.

Any queries contact me on:
# jordanleemauro@gmail.com

