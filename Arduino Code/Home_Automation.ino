/* Home Automation IoT Project (EasyLite)
 * 
 *  Author: Martin Tarnowski
 * 
 *  Board: Arduino UNO WiFi R2
 *  
 *  Sensors:
 *    - Light Dependant Resistor (LDR12)  --> Pin A0
 *    - Passive Infrared Radiation (HC-SR501) --> Pin 2
 *  
 *  Actuator:
 *    - Sunfounder 2 Channel 5V Relay Module --> Pin 3
 */

#include <SPI.h>
#include <WiFiNINA.h>
#include "header.h"
#include "ThingSpeak.h"

// LDR Associated Values
int ldrPin = A0;                                // takes input from LDR (A0)
int ldrValue = 0;                               // value of LDR read from A0
int threshold = 700;                            // determines when to send signal to turn off/on light (700 is default)

// PIR Associated Values
int pirPin = 2;                                 // pin connected to PIR (2)
int pirState = LOW;                             // PIR State, no motion to start
int pirValue = 0;                               // stores PIR status read from pirPin

// Actuator Associated Value
int actuatorPin = 3;                            // pin connected to actuator (3)
int actuatorState = 0;                          // tracks actuator state (on/off)
int manualMode = 0;                             // tracks whether the system is in automatic or manual mode


// WiFi Associate Values
char ssid[] = SSID_NAME;                        // stores name of SSID
char passwrd[] = SSID_PASSWRD;                  // stores password to SSID
int status = WL_IDLE_STATUS;                    // indicates status of WiFi connection
int statusCode = 0;                             // stores the connection status code
WiFiClient client;                              // initialize WiFiClient

// ThingSpeak Keys and Channels
const char * w_key = W_KEY;                     // write key for ThingSpeak API
const char * r_key = R_KEY;                     // read key for ThingSpeak API
unsigned long channel_number = CHANNEL_ID;      // ThingSpeak channel ID


/* Setup Function
 * Purpose: This function will establish a baud rate of 9600, initialize the actuator,
 * PIR pin, set the actuator state to HIGH (light off), call the function to connect
 * the board to the specified SSID, and start the ThingSpeak client.
 */
void setup() {
  Serial.begin(9600);                          // baud rate 9600
  pinMode(actuatorPin, OUTPUT);                // set actuatorPin as OUTPUT
  pinMode(pirPin, INPUT);                      // set pirPin as INPUT
  digitalWrite(actuatorPin, HIGH);             // set actuatorPin to HIGH
  connect_WiFi();                              // connect board to WiFi
  ThingSpeak.begin(client);                    // start the ThingSpeak client connection
}

/* Loop Function
 * Purpose: This function will check if the board has been set to manual mode,
 * and if not it will call functions resonsible for collecting sensor data and 
 * writing it to ThingSpeak. It collects the relevant values from ThingSpeak. It 
 * will then call a function to take action based on the values extracted. There 
 * is a delay of 20 seconds after each loop.
 */
void loop() {
  write_data();
  read_data();
  if(manualMode == 0) {
    take_action();
    delay(20000);
 } else {
  delay(20000);
 }
}

/* WiFi Connection Function
 * Purpose: This function is responsible for using the information provided
 * in the header file to establish a WiFi connection between the Arduino
 * board and the entered network. 
 */
void connect_WiFi() {
   while (!Serial) {
    ;
   }
   
   if (WiFi.status() == WL_NO_MODULE) {
    Serial.println("Communication with WiFi module failed");
    while(true);
   }
   
   if (WiFi.status() != WL_CONNECTED) {
    Serial.print("Attempting to connect to SSID: ");
    Serial.println(ssid);
    while(WiFi.status() != WL_CONNECTED){
      WiFi.begin(ssid, passwrd);
      delay(5000);
    }
    Serial.println("\nConnected");
   }   
}

/* Write Data Function
 * Purpose: This function will collect the information provided by the board by means
 * of the PIR sensors,LDR sensor, and actuator state. The manualMode and actuatorState
 * variable are written as well to ensure each entry in the ThingSpeak feed is not null. 
 * (Makes for easier reading)
 */
void write_data() {
  Serial.println("\nWriting Data to ThingSpeak...");
  
  ldrValue = analogRead(ldrPin);
  ThingSpeak.setField(1, ldrValue);

  pirValue = digitalRead(pirPin); 
  if (pirValue == HIGH) {
    ThingSpeak.setField(2, 1);
  } else {
    ThingSpeak.setField(2, 0);
  }

  ThingSpeak.setField(3, actuatorState);
  ThingSpeak.setField(4, manualMode);
  ThingSpeak.setField(5, threshold);

  int x = ThingSpeak.writeFields(channel_number, w_key);
  if(x == 200){
    Serial.println("HTTP OK - Channel update successful!\nWaiting 20 seconds before next write.");
  } else {
    Serial.println("Problem updating channel, HTTP error code " + String(x));
  }  
}

/* Read Data Function 
 * Purpose: This function will parse the ThingSpeak API and extract the data from all of the fields. 
 * Global variables are reassigned based on the values returned. The read and write functions rely
 * on the imported ThingSpeak library.
 */
void read_data() {
  Serial.println("\nReading data from ThingSpeak");
  ldrValue = ThingSpeak.readIntField(channel_number,1, r_key);
  statusCode = ThingSpeak.getLastReadStatus();
  if(statusCode = 200){
    Serial.println("The current LDR value is: " + String(ldrValue) + ".");
  }
  else {
    Serial.println("Problem retrieving data from channel. HTTP error code: " + String(statusCode));
  }
  pirValue = ThingSpeak.readIntField(channel_number,2, r_key);
  statusCode = ThingSpeak.getLastReadStatus();
  if(statusCode = 200){
    Serial.println("The current PIR State is: " + String(pirState) + ".");
  }
  else {
    Serial.println("Problem retrieving data from channel. HTTP error code: " + String(statusCode));
  }
  actuatorState = ThingSpeak.readIntField(channel_number,3, r_key);
  statusCode = ThingSpeak.getLastReadStatus();
  if(statusCode = 200){
    Serial.println("The current Actuator state is: " + String(actuatorState) + ".");
  }
  else {
    Serial.println("Problem retrieving data from channel. HTTP error code: " + String(statusCode));
  }
  manualMode = ThingSpeak.readIntField(channel_number,4, r_key);
  statusCode = ThingSpeak.getLastReadStatus();
  if(statusCode = 200){
    Serial.println("Manual Mode Value: " + String(manualMode) + ".");
  }
  else {
    Serial.println("Problem retrieving data from channel. HTTP error code: " + String(statusCode));
  }
  threshold = ThingSpeak.readIntField(channel_number,5, r_key);
  statusCode = ThingSpeak.getLastReadStatus();
  if(statusCode = 200){
    Serial.println("User set Threshold is: " + String(threshold) + ".");
  }
  else {
    Serial.println("Problem retrieving data from channel. HTTP error code: " + String(statusCode));
  }
}

/* Take Action Function
 * Purpose: This function is responsible for analyzing the variables collected from the sensors and
 * ThingSpeak, and determining what actions should be taken.
 */
void take_action() {
  if (int(ldrValue) > threshold) { /* Light outside, light will turn OFF, will not parse motion */
    Serial.println("\nLDR Value is above the threshold, light is off");
    digitalWrite(actuatorPin, HIGH); // turning off light
    actuatorState = 0;
  }
  else { /* Dark outside, check threshold and motion state */
    if((pirValue == HIGH) && (ldrValue < threshold)) { /* Motion Detected */
      digitalWrite(actuatorPin, LOW); /* Turn the light ON */
      actuatorState = 1;

      if(pirState == LOW) {   
        Serial.println("Motion Detected");
        Serial.println("Turning Light ON");
        pirState = HIGH;
      }
    }
    else {
      digitalWrite(actuatorPin, HIGH); /* Turn OFF the light */
      actuatorState = 0;

      if(pirState == HIGH) {
        Serial.println("Motion Ended");
        pirState = LOW;
      }
    }
  }
}
