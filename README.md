# EasyLite Home Automation System

# Table of Contents
1. [Project Description](#ProjectDescription)
2. [Technologies Used](#TechnologiesUsed)
3. [Hardware](#Hardware)
4. [Software](#Software)
   1. [ThingSpeak](#ThingSpeak)
   2. [Arduino](#Arduino)
   3. [Flutter UI](#FlutterUI)
5. [Project Overview](#ProjectOverview)
   
## Project Description <a name="ProjectDescription"><a/>
EasyLite is a proof of concept Internet of Things (IoT) home automation system capable of automatically monitoring the environment, changing the state of electronics based on collected physical data, and providing the user real time updates and system controls via a mobile application.

The main goal of EasyLite was to provide a means of conserving energy, and reducing the overall cost of electricity for a user, while improving the quality of life of the user via automated features. This is primarily done by taking the need for human interaction out of the equation, while also giving the user a means of monitoring and controlling their home system remotely through the use of a mobile application. This is done by creating an IoT system, by interlacing an embedded system, multiple cloud services, and a mobile application.


## Technologies Used <a name="TechnologiesUsed"><a/>
Some of the technlogies used to create this system include:
- Arduino
- ThingSpeak
- Google Firestore
- Flutter

## Hardware <a name="Hardware"><a/>
A list of the hardware components used in this project can be found below:
  
**Board**    
*Arduino UNO WiFi R2*  
[Specifications](https://store-usa.arduino.cc/products/arduino-uno-wifi-rev2?selectedStore=us)  
  
**Sensors**  
*Light Dependant Resistor (LDR)*
Model: LDR12  
[Specifications](https://www.nteinc.com/resistor_web/pdf/LDR-Series.pdf)  
  
Notes: The LDR sensor uses the analog input pin A0 on the Arduino board. This LDR sensor is coupled  
with a 10k ohm resistor to ensure it provides a wide range of values. Having a larger range of  
values to compare to a threshold, allows the user to easily make adjustments.  
  
*Passive Infrared Radiation (PIR)*
Model: HC-SR501  
[Specifications](https://www.mpja.com/download/31227sc.pdf)  

Notes: PIR Sensor uses Pin 2 on the Arduino board. 
  
**Actuator**
*2 Channel 5V Relay Module*
Model: Sunfounder  
[Specifications](http://wiki.sunfounder.cc/index.php?title=2_Channel_5V_Relay_Module)  

Notes: Actuator uses Pin 3 on the Arduino board.

**Additional Components**
- Breadboard
- 120V LightBulb
- Resistor (10k ohm)
- Jumpers

General hardware schematic can be found here:  
  
<img src="https://github.com/tarnowm/EasyLite/blob/main/Screenshots/Arduino%20Circuit.png" width=500 height=600>   
   
## Software <a name="Software"><a/>

### ThingSpeak <a name="ThingSpeak"><a/>

ThingSpeak is an IoT analytics platform service that allows a user to aggregate, visualize and analyze live data streams in the cloud.
For this project, a total of 5 different fields were used to collect and monitor data:

Field 1: LDR Value - Represents the brightness value of the room (0 - 1023)  
Field 2: PIR Value - Pepresents the presence or absence of motion in the room (0 - No Motion, 1 - Motion)  
Field 3: Actuator State - Displays whether the light is currently ON of OFF (0 - OFF, 1 - ON)  
Field 4: System State - Represents whether the system is in Automatic or Manual Mode (0 - Automatic, 1 - Manual)  
Field 5: Input Threshold - User chosen value that is compared to the LDR Value (600 - 1023)  


![ThingSpeak](https://github.com/tarnowm/EasyLite/blob/main/Screenshots/ThingSpeak.PNG)

### Arduino <a name="Arduino"><a/>

The Arduino board was programmed using the Arduino IDE. The board has mutliple responsibilities including:
  
- Collecting physical data from the sensors  
- Write data to ThingSpeak
- Read data from ThingSpeak  (http write/read requests are handled by the [ThingSpeak Library](https://github.com/mathworks/thingspeak-arduino))  
- Send signals to the actuator  
- Connect the board to the internet via WiFi  
- Host the logic that decides whether the state of the light needs to be changed

Below is an illustration of the the serial output demonstrating the program:  
  
![Serial Output](https://github.com/tarnowm/EasyLite/blob/main/Screenshots/Serial%20Output.PNG)  


### Flutter UI <a name="FlutterUI"><a/>


   
  
## Project Overview <a name="ProjectOverview"><a/>
An overview of how the system operates:

![Overview](https://github.com/tarnowm/EasyLite/blob/main/Screenshots/Overview.PNG)

The general outline of how EasyLite works is as as follows:
- Data is collected by the LDR and PIR sensors attached to the arduino board. 
- This data is then written to the storage cloud service. (ThingSpeak)
- After the ThingSpeak fields have been updated, this new data is ready to be read by the board and the mobile application.
- If the most recently collected data points warrant a change, the board will send a signal to the actuator, changing the state of the electronics.
- If no change is warranted the processes repeats at regularly timed intervals. 
- On the left hand side of the diagram, the user and mobile application can be found. Using the mobile application the user can check the state of the system at anytime as long as there is a WiFi connection. The user can also set the threshold value (a value that determines when the light will turn on/off) within the application, and change the system from automatic to manual mode (Gives the user the ability to change the state of electronics manually).
- A security and storage cloud service (Google Firebase) is also integrated into the mobile application. It provides a means of creating new user accounts, authenticating existing user logins and storing data pertaining to the user.






   




