# EasyLite Home Automation System

# Table of Contents
1. [Project Description](#ProjectDescription)
2. [Technologies Used](#TechnologiesUsed)
3. [Hardware](#Hardware)
4. [Software](#Software)
   1. [ThingSpeak](#ThingSpeak)
   2. [Arduino](#Arduino)
   3. [Flutter UI](#FlutterUI)
   4. [Google Firebase](#GoogleFirebase)
5. [Project Overview](#ProjectOverview)
   1. [Manual vs Automatic](#MvA)
   2. [Scenario Table](#ScenTable)
6. [Future Version Plans](#FutureVersions)
7. [Conclusion](#Conclusion)
   
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

<details><summary><b>General Schematic</b></summary>
   
![GFAuth](https://github.com/tarnowm/EasyLite/blob/main/Screenshots/Arduino%20Circuit.png)
   
</details>
    
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

<details><summary><b>Serial Monitor Example</b></summary>
   
![GFAuth](https://github.com/tarnowm/EasyLite/blob/main/Screenshots/Serial%20Output.PNG)
   
</details> 
  
### Flutter UI <a name="FlutterUI"><a/>

Flutter was used for this project due to its ability to develop applicatons for different operating systems simultaneously.  
This sections will show off some of the screens used within the application, and explain the intended use of each of them.  

|Login Screen|Description|
|:-:|:-:|
|![LoginScreen](https://github.com/tarnowm/EasyLite/blob/main/Screenshots/Login%20Screen.PNG)| When the application is launched, the first screen the user encounters is the log in screen. Here the user will either enter their existing credentials, or have the option to create an account. User information and log in authentication is done with Google Firebase. If the user wishes to create an account, the program will direct the user to the data entry screen.|
|Data Entry Screen|Description|
|![DataEntry](https://github.com/tarnowm/EasyLite/blob/main/Screenshots/DataEntryScreen.PNG)| The data entry screen is shown when a user chooses to create a new account. Information such as first/last name, email, password, and power rate will be collected from the user. An account is created for the user, and all information given is stored using Google Firebase.|
|Primary Screen|Description|
|![PrimaryScreen](https://github.com/tarnowm/EasyLite/blob/main/Screenshots/Primary%20Screen.PNG)| This is the primary screen of the application. Here the user will be able to track the status of the home automation system, set new brightness thresholds, and switch the system between manual and automatic modes. The screen is refreshed every 5 seconds with newly collected values from ThingSpeak.|
|Profile Page|Description|
|![Profile](https://github.com/tarnowm/EasyLite/blob/main/Screenshots/Profile.PNG)| The profile page gives a brief summary of information belonging to the user. On this page, energy calculations can be found that pertain to the users systems are shown. NOTE: At the moment the calculations are hard coded to show off the concept, but in future versions, values will be combined with user entered power rates, and values collected from major power companies to deduce savings.|

### Google Firebase <a name="GoogleFirebase"><a/>

When the user creates an account within the application, the information is registered and stored using Google Firebase. When logging in, credentials are authenticated using the service. At the moment, the information is collected from the user, but a Firebase API call to reference the information belonging to a specific user is not implemented. The profile screen at the moment contains hard-coded values. 

<details><summary><b>Firebase Authentication</b></summary>
   
![GFAuth](https://github.com/tarnowm/EasyLite/blob/main/Screenshots/GFAuth.PNG)
   
</details>

<details><summary><b>Firebase Authentication</b></summary>
   
![GFStore](https://github.com/tarnowm/EasyLite/blob/main/Screenshots/GFStore.PNG)
   
</details>
   
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

### Manual Mode vs. Automatic Mode <a name="MvA"><a/>
When the system is in automatic mode, all of the steps above are performed automatically.  
Within the application, the user has the ability to toggle Manual Mode. When the system is in manual mode,  
the arduino board will continue to read and write newly collected values to ThingSpeak, but the ability to  
take action based on the new values is disabled. In manual mode, the user has the option to write new actuator  
values to Thingspeak and change the state of the actuator. 

   
### Scenario Table <a name="ScenTable"><a/>
   
**Key Terms**
In order to gain a better understanding of how the system is expected to work, here is a list of terms used throughout the upcoming scenarios:
   
- *Threshold* - A user chosen value that determines when the light will turn on or off in terms of brightness (value is set in the mobile application)

- *Brightness* - Analog value that is collected from the light dependent resistor (LDR) that is converted into a digital value by the Arduino board.

- *Motion* - Motion is categorized by being absent or present, and is represented by 0 or 1 respectively. 

| Scenario | Brightness | Threshold | Motion | System Mode | State of Light | Comments
|---|---|---|---|---|---|---|
| Daytime - NO Motion | 800 | 650 | NO | AUTO | OFF | Brightness is above the threshold, light turns/remains OFF. Motion not read. |
| Daytime - Motion | 800 | 650 | YES | AUTO | OFF | Brightness is above the threshold, light turns/remains OFF. Motion not read. |
| Nighttime - NO Motion | 500 | 650 | NO | AUTO | OFF | Brightness below threshold, but no motion detected. Light turns/remains OFF. |
| Nighttime - Motion | 500 | 650 | YES | AUTO | ON | Brightness below threshold, with motion detected in area. Light turns/remains ON. |
| Manual Mode | 800 | 650 | YES | MANUAL | DEPENDS | Manual Mode is on, system stops automatically taking action. User controls electronic states |


## Future Version Plans <a name="FutureVersions"><a/>

Looking forward, there are a many different improvements I would like to introduce to the EasyLite system. Some of the major changes that are planned for future versions include: 

1. Energy Saving Calculations
One of the driving reasons for developing this project was to try to increase overall savings on power bills, by reducing the total energy consumption of forgotten lights. While I believe that in it's current version the system has successfully incorporated a means of more efficient lighting, the total saving calculations remain incomplete. In it's current form, the calculations are hard coded into the profile to act as a proof of concept, and are derived from loose estimations from different generalized calculations found on power sites. Moving forward, implementing accurate saving calculations using reliable information from the user's power company of choice is a top priority. 
   
2. Modularity/Scalability
The idea for this home automation system was to be able to incorporate a large variety of different electronics. At the moment, in order to show a proof of concept, the system is limited to lighting. Expanding the system to be able to accommodate different products is a top priority and can be done due to the flexibility that the power relay/actuator provides (A wide variety of different electronics can be attached to the actuator such as a Coffee Maker or Air Conditioner). Perhaps the program could be expanded in such a way that when a user initially creates an account they are presented with a variety of electronics to choose from. 
   
3. Performance
In order to read and write data, we used a cloud service called ThingSpeak. For learning purposes, the free platform was more than enough to demonstrate the technology working. The free account ThingSpeak has a restriction of approximately 20 seconds in between writes. This means that changes given to the system can sometimes take up to 20 seconds to be reflected in the hardware or software. Timing manual writes such as the Threshold alteration between the automatic writes proved to be sometimes challenging. If this project were to be adapted into a fully functional product, research into more responsive cloud services would have to be done. The overall goal would be to create a more responsive system. 
   

## Conclusion <a name="Conclusion"><a/>

I believe that the original goal of creating a proof of concept home automation system with a companion mobile application was successfully executed. The system is able to collect light and motion data from the environment and make the correct decisions on when to turn the light on or off automatically. The mobile application has the ability to display the system's status in real time, and gives the user the ability to manually control the light. 
   
One of the driving reasons for developing this project was to expose myself to a wide variety of different technologies and frameworks I've never seen before. Each of these technologies having it's own learning curve. Working with an embedded system for the first time was a fun yet challenging experience. A lot of initial project time was devoted to researching the specifics of the hardware and how each component would interact with one another. Performing calculations to choose the correct LDR/resistor combination, the intricies of how PIR sensors work, how to connect the system to the internet, and working with mains power supply to incorporate an actuator and light was very educational. Working with the APIs was very rewarding. Although I just scratched the surface, starting to familiarize myself with a current technology such as Google Firebase was a great learning experience. Using Flutter to create the mobile application was a fun journey. The original plan was to use my previous experience with Android Studio to build the application. I'm glad that I chose to branch out to a new technology. It provded to be very intuitive, and the amount of available resources online was staggerlingly abundant. 
   
Overall, I learned a lot from building this project, and I firmly beleive that many of the technologies and concepts learned will benefit my growth as a developer. 





