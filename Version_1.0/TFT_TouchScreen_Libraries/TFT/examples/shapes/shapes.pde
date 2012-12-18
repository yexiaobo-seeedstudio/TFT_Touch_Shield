// Draw Concentric circles with random colors

#include <stdint.h>
#include <TFT.h>

void setup()
{

Tft.init();  //init TFT library

}

void loop()
{
   for(int r=0;r<115;r=r+2)
   {
       Tft.drawCircle(119,160,r,random(0xFFFF));
   }
  
}
