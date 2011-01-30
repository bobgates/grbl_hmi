long target[3];
long position[3];
float mm_per_step[3];

#include <Wire.h>
#include "lc_display.h"

void setup()
{
  Wire.begin(4);                // join i2c bus with address #4
  Wire.onReceive(receiveEvent); // register event
  Wire.onRequest(requestEvent); // register event
  Serial.begin(115200);           // start serial for output
  Serial.print("\nHello World\n");
  lcd_init();
  ps2_setup();
  
}

extern char ps2_data[5];      // 3 sliders linearized 0-7: x, y, z, followed by 8 buttons in one byte
                              // last byte is zero as end marker

#define XVAL 0
#define YVAL 1
#define ZVAL 2
#define BUTTONS 3

void loop()
{
  int i;
  
  delay(50);
  lcd_report_position();
  ps2_read();

  // For serial debugging enable the following lines:
  if (ps2_data[0]|ps2_data[1]|ps2_data[2]|ps2_data[3]){
    Serial.print("Stick Values:");
    Serial.print(ps2_data[XVAL], DEC);
    Serial.print(",");
    Serial.print(ps2_data[YVAL], DEC);
    Serial.print(",");
    Serial.print(ps2_data[ZVAL], DEC);
    Serial.print(",");
    Serial.print(ps2_data[BUTTONS], DEC);
    Serial.print(",");
    Serial.println(ps2_data[4], DEC);
  }
}

void format_measurement(long value)
{
   long whole;
   long fraction;
   float answer;
  
   answer = float(value)*DEFAULT_UM_PER_STEP;
   
   whole = round(answer/10);
   fraction = abs(whole % 100);
   whole = whole/100;
   
   if (whole>=0) Serial.print(" "); 
   if (abs(whole)<100) Serial.print(" ");
   if (abs(whole)<10){
     if ((whole==0) & (answer<0)){
         Serial.print("-");
     } else {
         Serial.print(" ");
     }
   }
   Serial.print(whole);
   Serial.print(".");
   if (fraction<10) Serial.print("0");
   Serial.print(fraction);
}

// function that executes whenever data is received from master
// this function is registered as an event, see setup()
void receiveEvent(int howMany)
{
  byte  channel;
  long  Value;

  channel = Wire.receive();
  
  //Serial.print((int) channel);
  //Serial.print(": ");
  
  Value = Wire.receive();
  Value = (Value << 8) | Wire.receive();
  Value = (Value << 8) | Wire.receive();
  Value = (Value << 8) | Wire.receive();
  
  if (channel<128){
    if (channel<3){
      mm_per_step[channel]=Value;  
    }
  } else {
    channel -= 128;
    if (channel<3){
      position[channel]=Value;
    } else if (channel<6) {
      target[channel-3]=Value;
    }
  }
  
//  Serial.println("  Rx");         // print the integer
}

void requestEvent()
{
  Wire.send((uint8_t *) ps2_data, 4);  // Must use this .send, because the one
                                      // that takes char* won't transmit a data
                                      // byte of zero.
                        // respond with message of 4 bytes
                        // as expected by master
/*                       
  Wire.send(1);
  Wire.send(2);
  Wire.send(3);
  Wire.send(4);
*/

  Serial.println("Tx");                     
}
