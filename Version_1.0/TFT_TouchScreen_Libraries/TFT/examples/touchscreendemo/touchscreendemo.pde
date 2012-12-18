#include <stdint.h>
#include <TouchScreen.h>
#include <TFT.h>

//Measured ADC values for (0,0) and (240-1,320-1)
//TS_MINX corresponds to ADC value when X = 0
//TS_MINY corresponds to ADC value when Y = 0
//TS_MAXX corresponds to ADC value when X = 240 -1
//TS_MAXY corresponds to ADC value when Y = 320 -1

static unsigned int TS_MINX, TS_MAXX, TS_MINY, TS_MAXY;

//Touch Screen Co-ordinate mapping register
static unsigned int MapX1, MapX2, MapY1, MapY2;

// For better pressure precision, we need to know the resistance
// between X+ and X- Use any multimeter to read it
// The 2.8" TFT Touch shield has 300 ohms across the X plate

/* Usage: TouchScreen ts = TouchScreen(XP, YP, XM, YM, 300); 
   Where, XP = X plus, YP = Y plus, XM = X minus and YM = Y minus */
//init TouchScreen port pins. This would be reinitialized in setup() based on the hardware detected.
TouchScreen ts = TouchScreen(17, A2, A1, 14, 300); 

void setup(void) {
  Serial.begin(9600);
  Tft.init();
  initTouchScreenParameters(); // initializes Touch Screen parameters based on the detected TFT Touch Schield hardware
  Tft.setPixel(0,0,GREEN);     //Reference Pixel (0,0) in GREEN
  Tft.setPixel(239,319,BLUE);  //Reference Pixel (239,319) in BLUE
  Tft.setPixel(10,10,RED);
  Tft.drawString("(10,10)",12,12,1,CYAN);
  Tft.setPixel(100,60,YELLOW);
  Tft.drawString("(100,60)",102,62,1,WHITE);
}

void loop(void) {
  // a point object holds x y and z coordinates
  Point p = ts.getPoint();

  if (p.z > ts.pressureThreshhold) {
     Serial.print("Raw X = "); Serial.print(p.x);
     Serial.print("\tRaw Y = "); Serial.print(p.y);
     Serial.print("\tPressure = "); Serial.println(p.z);
  }
  
 
  p.x = map(p.x, TS_MINX, TS_MAXX, MapX1, MapX2);
  p.y = map(p.y, TS_MINY, TS_MAXY, MapY1, MapY2);
  
  // we have some minimum pressure we consider 'valid'
  // pressure of 0 means no pressing!
  if (p.z > ts.pressureThreshhold) {
     Serial.print("X = "); Serial.print(p.x);
     Serial.print("\tY = "); Serial.print(p.y);
     Serial.print("\tPressure = "); Serial.println(p.z);
  }

  delay(10);
}

void initTouchScreenParameters()
{
    //This function initializes Touch Screen parameters based on the detected TFT Touch Schield hardware

    if(Tft.IC_CODE == 0x5408) //SPFD5408A TFT driver based Touchscreen hardware detected
    {
#if defined(__AVR_ATmega1280__) || defined(__AVR_ATmega2560__)
        ts = TouchScreen(54, A1, A2, 57, 300); //init TouchScreen port pins
#else 
        ts = TouchScreen(14, A1, A2, 17, 300); //init TouchScreen port pins
#endif
        //Touchscreen parameters for this hardware
        TS_MINX = 120;
        TS_MAXX = 910;
        TS_MINY = 120;
        TS_MAXY = 950;

        MapX1 = 239;
        MapX2 = 0;
        MapY1 = 0;
        MapY2 = 319;
    }
    else //ST7781R TFT driver based Touchscreen hardware detected
    {
#if defined(__AVR_ATmega1280__) || defined(__AVR_ATmega2560__)
        ts = TouchScreen(57, A2, A1, 54, 300); //init TouchScreen port pins
#else 
        ts = TouchScreen(17, A2, A1, 14, 300); //init TouchScreen port pins
#endif 

        //Touchscreen parameters for this hardware
        TS_MINX = 140;
        TS_MAXX = 900;
        TS_MINY = 120;
        TS_MAXY = 940;

        MapX1 = 239;
        MapX2 = 0;
        MapY1 = 319;
        MapY2 = 0;
    }
}

