#include "Wire.h"
#include "Adafruit_INA219.h"

Adafruit_INA219 ina219;

int PWM_FREQUENCY = 20000; 
int PWM_CHANNEL = 0; 
int PWM_RESOLUTION = 10; 
int GPIOPIN = 5; 
int dutyCycle = 127;
// int A = 21;
// int B = 22;
// int C = 23;
int ANALOG_PIN_0 = 2;
int analog_value;
int alto = 15;

//para o adc
int potValue = 0;


void setup()
{
  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }

  if (! ina219.begin()) {
    Serial.println("Failed to find INA219 chip");
    while (1) { delay(10); }
  }
analog_value = 0;
pinMode(GPIOPIN,OUTPUT);
ledcSetup(PWM_CHANNEL, PWM_FREQUENCY, PWM_RESOLUTION);
ledcAttachPin(GPIOPIN, PWM_CHANNEL);
Serial.print("BV"); Serial.print("\t"); // Bus Voltage
Serial.print("SV"); Serial.print("\t"); // Shunt Voltage
Serial.print("LV"); Serial.print("\t"); // Load Voltage
Serial.print("C"); Serial.print("\t");  // Current
Serial.println("P");  // Power

 
ledcWrite(PWM_CHANNEL, dutyCycle);
// pinMode(A,INPUT);
// pinMode(B,INPUT);
// pinMode(C,INPUT);

}

void loop() {

digitalWrite(alto, HIGH);
analog_value = analogRead(ANALOG_PIN_0);
dutyCycle = map(analog_value, 0, 255, 0, 255);

 
ledcWrite(PWM_CHANNEL, dutyCycle);

// int SA = digitalRead(A);
// int SB = digitalRead(B);
// int SC = digitalRead(C);

float shuntvoltage = 0;
float busvoltage = 0;
float current_mA = 0;
float loadvoltage = 0;
float power_mW = 0;

shuntvoltage = ina219.getShuntVoltage_mV();
busvoltage = ina219.getBusVoltage_V();
current_mA = ina219.getCurrent_mA();
power_mW = ina219.getPower_mW();
loadvoltage = busvoltage + (shuntvoltage / 1000);

Serial.print(busvoltage); Serial.print("\t"); 
Serial.print(shuntvoltage); Serial.print("\t");
Serial.print(loadvoltage); Serial.print("\t");
Serial.print(current_mA); Serial.print("\t");
Serial.println(power_mW);
delay(1000);

//Serial.print(SA);
//Serial.print(SB);
//Serial.print(SC);
Serial.println("");

}