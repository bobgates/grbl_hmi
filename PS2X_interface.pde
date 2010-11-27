#include <PS2X_lib.h>

char ps2_data[5];      // 3 sliders linearized 0-7: x, y, z, followed by 8 buttons in one byte

#define XVAL 0
#define YVAL 1
#define ZVAL 2
#define BUTTONS 3

PS2X ps2x; // create PS2 Controller Class

//right now, the library does NOT support hot pluggable controllers, meaning 
//you must always either restart your Arduino after you conect the controller, 
//or call config_gamepad(pins) again after connecting the controller.
int error = 0; 
byte vibrate = 0;

void ps2_setup(){
 //Serial.begin(115200);

 ps2_data[4]=0;
  
 error = ps2x.config_gamepad(4,5,6,7);   //setup GamePad(clock, command, attention, data) pins, check for error
 
 if(error == 0){
   Serial.println("Found Controller, configured successful");
   Serial.println("Try out all the buttons, X will vibrate the controller, faster as you press harder;");
  Serial.println("holding L1 or R1 will print out the analog stick values.");
  Serial.println("Go to www.billporter.info for updates and to report bugs.");
 }
   
  else if(error == 1)
   Serial.println("No controller found, check wiring, see readme.txt to enable debug. visit www.billporter.info for troubleshooting tips");
   
  else if(error == 2)
   Serial.println("Controller found but not accepting commands. see readme.txt to enable debug. Visit www.billporter.info for troubleshooting tips");
   
   //Serial.print(ps2x.Analog(1), HEX);
 
 
 ps2x.enableRumble();              //enable rumble vibration motors
 ps2x.enablePressures();           //enable reading the pressure values from the buttons. 
  

  
}

char linearize(byte value)
{
  /* Button linearize:
  if (value>64){
    return (value-64)/24;
  } else {
    return 0;
  }
  */
  // Joystick linearize:
  // Returns a value from 1-7 positive or negative, with a generous dead band around zero
  if (value<128){
    return (value-112)/16;
  } else {
    return (value-128)/16;
  }
}


//***************************************************************************************************
void ps2_read(){
   /* You must Read Gamepad to get new values
   Read GamePad and set vibration values
   ps2x.read_gamepad(small motor on/off, larger motor strenght from 0-255)
   if you don't enable the rumble, use ps2x.read_gamepad(); with no values
   
   you should call this at least once a second
   */
 if(error != 0)
  return; 
  
  ps2x.read_gamepad();
  //false, vibrate);          //read controller and set large motor to spin at 'vibrate' speed


/*  
  if(ps2x.Button(PSB_START))                   //will be TRUE as long as button is pressed
       Serial.println("Start is being held");
  if(ps2x.Button(PSB_SELECT))
       Serial.println("Select is being held");
       
       
   if(ps2x.Button(PSB_PAD_UP)) {         //will be TRUE as long as button is pressed
     Serial.print("Up held this hard: ");
     Serial.println(linearize(ps2x.Analog(PSAB_PAD_UP)), DEC);
    }
    if(ps2x.Button(PSB_PAD_RIGHT)){
     Serial.print("Right held this hard: ");
      Serial.println(linearize(ps2x.Analog(PSAB_PAD_RIGHT)), DEC);
    }
    if(ps2x.Button(PSB_PAD_LEFT)){
     Serial.print("LEFT held this hard: ");
     Serial.println(linearize(ps2x.Analog(PSAB_PAD_LEFT)), DEC);
    }
    if(ps2x.Button(PSB_PAD_DOWN)){
     Serial.print("LEFT held this hard: ");
     Serial.println(linearize(ps2x.Analog(PSAB_PAD_DOWN)), DEC);
    }
    if(ps2x.Button(PSB_RED)){
     Serial.print("RED held this hard: ");
     Serial.println(linearize(ps2x.Analog(PSAB_RED)), DEC);
    }
    if(ps2x.Button(PSB_PINK)){
     Serial.print("RED held this hard: ");
     Serial.println(linearize(ps2x.Analog(PSAB_PINK)), DEC);
    }
*/

//  char x_val, y_val, z_val;


//   Serial.print("Stick Values:");
   
   if (ps2x.Button(PSB_L1)){
     ps2_data[ZVAL] = 0-linearize(ps2x.Analog(PSS_RY));
     ps2_data[XVAL] = 0;
     ps2_data[YVAL] = 0;
   } else {
     ps2_data[XVAL] = linearize(ps2x.Analog(PSS_RX));
     ps2_data[YVAL] = 0-linearize(ps2x.Analog(PSS_LY));
     ps2_data[ZVAL] = 0;
   }
   
   ps2_data[BUTTONS] =  (char)(ps2x.ButtonDataByte()>>4) & 0x0F;
   ps2_data[BUTTONS] |=  (char)(ps2x.ButtonDataByte()>>8) & 0xF0;
   
   
   
/*   
   
   Serial.print(linearize(x_val), DEC);
   Serial.print(",");
   Serial.print(linearize(y_val), DEC);
   Serial.print(",");
   Serial.println(linearize(z_val), DEC);
*/  
}



void ps2_read_old(){
   /* You must Read Gamepad to get new values
   Read GamePad and set vibration values
   ps2x.read_gamepad(small motor on/off, larger motor strenght from 0-255)
   if you don't enable the rumble, use ps2x.read_gamepad(); with no values
   
   you should call this at least once a second
   */
 if(error != 0)
  return; 
  
  ps2x.read_gamepad(false, vibrate);          //read controller and set large motor to spin at 'vibrate' speed
  
  if(ps2x.Button(PSB_START))                   //will be TRUE as long as button is pressed
       Serial.println("Start is being held");
  if(ps2x.Button(PSB_SELECT))
       Serial.println("Select is being held");
       
       
   if(ps2x.Button(PSB_PAD_UP)) {         //will be TRUE as long as button is pressed
     Serial.print("Up held this hard: ");
     Serial.println(ps2x.Analog(PSAB_PAD_UP), DEC);
    }
    if(ps2x.Button(PSB_PAD_RIGHT)){
     Serial.print("Right held this hard: ");
      Serial.println(ps2x.Analog(PSAB_PAD_RIGHT), DEC);
    }
    if(ps2x.Button(PSB_PAD_LEFT)){
     Serial.print("LEFT held this hard: ");
      Serial.println(ps2x.Analog(PSAB_PAD_LEFT), DEC);
    }
    if(ps2x.Button(PSB_PAD_DOWN)){
     Serial.print("DOWN held this hard: ");
   Serial.println(ps2x.Analog(PSAB_PAD_DOWN), DEC);
    }   

  
    vibrate = ps2x.Analog(PSAB_BLUE);        //this will set the large motor vibrate speed based on 
                                            //how hard you press the blue (X) button    
  
  if (ps2x.NewButtonState())               //will be TRUE if any button changes state (on to off, or off to on)
  {
   
     
       
      if(ps2x.Button(PSB_L3))
       Serial.println("L3 pressed");
      if(ps2x.Button(PSB_R3))
       Serial.println("R3 pressed");
      if(ps2x.Button(PSB_L2))
       Serial.println("L2 pressed");
      if(ps2x.Button(PSB_R2))
       Serial.println("R2 pressed");
      if(ps2x.Button(PSB_GREEN))
       Serial.println("Triangle pressed");
       
  }   
       
  
  if(ps2x.ButtonPressed(PSB_RED))             //will be TRUE if button was JUST pressed
       Serial.println("Circle just pressed");
       
  if(ps2x.ButtonReleased(PSB_PINK))             //will be TRUE if button was JUST released
       Serial.println("Square just released");     
  
  if(ps2x.NewButtonState(PSB_BLUE))            //will be TRUE if button was JUST pressed OR released
       Serial.println("X just changed");    
  
  
  if(ps2x.Button(PSB_L1) || ps2x.Button(PSB_R1)) // print stick values if either is TRUE
  {
      Serial.print("Stick Values:");
      Serial.print(ps2x.Analog(PSS_LY), DEC); //Left stick, Y axis. Other options: LX, RY, RX  
      Serial.print(",");
      Serial.print(ps2x.Analog(PSS_LX), DEC); 
      Serial.print(",");
      Serial.print(ps2x.Analog(PSS_RY), DEC); 
      Serial.print(",");
      Serial.println(ps2x.Analog(PSS_RX), DEC); 
  } 
    
 delay(50);
     
 

     
}
