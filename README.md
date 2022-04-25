# EasyLite Home Automation System

# Project Description
EasyLite is a proof of concept Internet of Things (IoT) home automation system capable of automatically monitoring the environment, changing the state of electronics based on collected physical data, and providing the user real time updates and system controls via a mobile application.

The main goal of EasyLite was to provide a means of conserving energy, and reducing the overall cost of electricity for a user, while improving the quality of life of the user via automated features. This is primarily done by taking the need for human interaction out of the equation, while also giving the user a means of monitoring and controlling their home system remotely through the use of a mobile application. This is done by creating an IoT system, by interlacing an embedded system, multiple cloud services, and a mobile application.


# Technologies Used
Some of the technlogies used to create this system include:
- Arduino
- ThingSpeak
- Google Firestore
- Flutter

# Hardware
A list of the hardware components used in this project can be found below:
  
Board    
Type: Arduino UNO WiFi R2  
Specifications: https://store-usa.arduino.cc/products/arduino-uno-wifi-rev2?selectedStore=us
  
Sensors  
Type: Light Dependant Resistor (LDR)
Model: LDR12  
Specifications: https://www.nteinc.com/resistor_web/pdf/LDR-Series.pdf
  
Type: Passive Infrared Radiation (PIR)
Model: HC-SR501  
Specifications: https://www.mpja.com/download/31227sc.pdf
  
Actuator
Type: 2 Channel 5V Relay Module
Model: Sunfounder  
Specifications: http://wiki.sunfounder.cc/index.php?title=2_Channel_5V_Relay_Module

Additional Components
- Breadboard
- 120V LightBulb
- Resistor (10k ohm)
- Jumpers

General hardware schematic can be found within the repository under "Arduino Circuit.png".

# Project Overview
An overview of how the system operates:

![Overview](https://github.com/tarnowm/EasyLite/blob/main/Overview.PNG)

The general outline of how EasyLite works is as as follows:
- Data is collected by the LDR and PIR sensors attached to the arduino board. 
- This data is then written to the storage cloud service. (ThingSpeak)
- After the ThingSpeak fields have been updated, this new data is ready to be read by the board and the mobile application.
- If the most recently collected data points warrant a change, the board will send a signal to the actuator, changing the state of the electronics.
- If no change is warranted the processes repeats at regularly timed intervals. 
- On the left hand side of the diagram, the user and mobile application can be found. Using the mobile application the user can check the state of the system at anytime as long as there is a WiFi connection. The user can also set the threshold value (a value that determines when the light will turn on/off) within the application, and change the system from automatic to manual mode (Gives the user the ability to change the state of electronics manually).
- A security and storage cloud service (Google Firebase) is also integrated into the mobile application. It provides a means of creating new user accounts, authenticating existing user logins and storing data pertaining to the user.


ThingSpeak

ThingSpeak is an IoT analytics platform service that allows a user to aggregate, visualize and analyze live data streams in the cloud.
For this project, 

































