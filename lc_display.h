#define MICROSTEPS 8
#define DEFAULT_UM_PER_STEP (1270.0/(200*MICROSTEPS))


// 1.27 mm = 200 steps x 8/10 microsteps

#define DEFAULT_X_UM_PER_STEP (1000* 1.27/(200*10))
#define DEFAULT_Y_UM_PER_STEP (1000* 1.27/(200*8))
#define DEFAULT_Z_UM_PER_STEP (1000* 1.27/(200*8))

#define X_AXIS 0
#define Y_AXIS 1
#define Z_AXIS 2

// Connections to LCD panel
#define LCD_DB0 	10			// Using Ardiuno numbering, not port numbering
#define LCD_DB1	11				
#define LCD_DB2	12
#define LCD_DB3	13
#define LCD_ENABLE	9
#define LCD_RS 	8


//void lcd_report_position();
//void lcd_init();
