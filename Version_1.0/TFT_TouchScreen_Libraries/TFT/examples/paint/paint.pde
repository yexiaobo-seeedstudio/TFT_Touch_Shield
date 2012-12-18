// Paint application - Demonstrate both TFT and Touch Screen

#include <stdint.h>
#include <TouchScreen.h>
#include <TFT.h>

//Measured ADC values for (0,0) and (210-1,320-1)
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

int color = WHITE;  //Default Paint brush color

void setup()
{
    Tft.init();  //init TFT library
    initTouchScreenParameters(); // initializes Touch Screen parameters based on the detected TFT Touch Schield hardware

   // Serial.begin(9600); //debug

    //Draw the palette
    Tft.fillRectangle(0,0,30,10,BLACK);
    Tft.fillRectangle(30,0,30,10,RED);
    Tft.fillRectangle(60,0,30,10,GREEN);
    Tft.fillRectangle(90,0,30,10,BLUE);
    Tft.fillRectangle(120,0,30,10,CYAN);
    Tft.fillRectangle(150,0,30,10,YELLOW);
    Tft.fillRectangle(180,0,30,10,WHITE);
    Tft.fillRectangle(210,0,30,10,GRAY1);

}

void loop()
{

   // Serial.println(Tft.IC_CODE,HEX); //debug

    // a point object holds x y and z coordinates.
    Point p = ts.getPoint();

    // we have some minimum pressure we consider 'valid'
    // pressure of 0 means no pressing!

    if (p.z > ts.pressureThreshhold) {

    //map the ADC value read to into pixel co-ordinates

    p.x = map(p.x, TS_MINX, TS_MAXX, MapX1, MapX2);
    p.y = map(p.y, TS_MINY, TS_MAXY, MapY1, MapY2);


        // Detect  paint brush color change
        if(p.y < 15)
        {
            if(p.x >= 0 && p.x < 30)
            {
                color = BLACK;
            }
            if(p.x >= 30 && p.x < 60)
            {
                color = RED;
            }
            if(p.x >= 60 && p.x < 90)
            {
                color = GREEN;
            }
            if(p.x >= 90 && p.x < 110)
            {
                color = BLUE;
            }
            if(p.x >= 120 && p.x < 150)
            {
                color = CYAN;
            }
            if(p.x >= 150 && p.x < 180)
            {
                color = YELLOW;
            }
            if(p.x >= 180 && p.x < 210)
            {
                color = WHITE;
            }
            if(p.x >= 210 && p.x < 240)
            {
                color = GRAY1;
            }
        }
        else
        {
            Tft.fillCircle(p.x,p.y,2,color);
        }

    }

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
