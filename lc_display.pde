//*************************************************************************************
// include the library code:
#include <LiquidCrystal.h>
//#include <WProgram.h>  //all things wiring / arduino
#include "lc_display.h"
// 
#define LCD_DB0 	10			// Using Ardiuno numbering, not port numbering
#define LCD_DB1	11				
#define LCD_DB2	12
#define LCD_DB3	13
#define LCD_ENABLE	9
#define LCD_RS 	8


// initialize the library with the numbers of the interface pins
LiquidCrystal lcd(LCD_RS, LCD_ENABLE, LCD_DB0, LCD_DB1, LCD_DB2, LCD_DB3);

extern long position[3];		

int pos_line=0;

//extern "C" void lcd_report_position();
//extern "C" void lcd_init();


void lcd_print_char(char character)
{
	lcd.print(character);
}

void lcd_print_long(long num)
{
	lcd.print(num);
}
void lcd_print_str(char * line)
{
	lcd.print(line);
}


void lcd_init() {

  // set up the LCD's number of columns and rows: 
  lcd.begin(16, 2);
  // Print a message to the LCD.
  lcd.print('X');
  lcd.setCursor(8,0);
  lcd.print("Z");
  lcd.setCursor(0,1);
  lcd.print("Y");

  pinMode(13,OUTPUT);
  digitalWrite(13, HIGH);

}


void lcd_print_count_as_mm(float count)
{
	long whole;
	long fraction;
	float answer;
	
	answer = count*DEFAULT_UM_PER_STEP;
	whole = round(answer/10.0);
	fraction = abs(whole) % 100;
	whole = whole/100;
	if (whole>=0) lcd.print(" "); // Allow space for - if required
	if (abs(whole)<100) lcd.print(" ");
	if (abs(whole)<10){
          if ((whole==0) & (answer<0)){
             lcd.print("-");
          } else {
             lcd.print(" ");
          }
        }

	lcd.print(whole);
	lcd.print(".");
	if (fraction<10) lcd.print("0");
	lcd.print(fraction);
} 


void lcd_report_position(void)
{

// Only report 1 of X, Y or Z position per time, allows time for other
// stuff to happen (ie doesn't hog the main thread for too long.

	switch (pos_line){
	case 0:  lcd.setCursor(1, 0);
			 lcd_print_count_as_mm(position[0]);
			 break;
	case 1:  lcd.setCursor(1, 1);
			 lcd_print_count_as_mm(position[1]);
			 break;
	case 2:  lcd.setCursor(10, 0);
			 lcd_print_count_as_mm(position[2]);
			 break;
	}
	pos_line++;
	if (pos_line>2) pos_line=0;

}

