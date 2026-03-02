#include <stdint.h>
#include "wasm4.h"

void draw_pixel(uint32_t px, uint8_t c);

uint32_t max_fb_size = 6400;

void start(){
  PALETTE[0] = 0xffffff;
  PALETTE[1] = 0xff0000;
  PALETTE[2] = 0x00ff00;
  PALETTE[3] = 0x0000ff;
}

void update () {
  draw_pixel(6399, 0x70); // 0x70 = 0111 0000
}


// DRAW_COLORS = 0xffffff (16 bit).
// FRAMEBUFFEr = the framebuffer. 2 bits / pixel (each bytes contains 4 pixels). the screen resolution is 160x160
// First assignement: write a function that writes a color to the a pixel in the specific coordinates x and y (passed as args) using direct framebuffer access
//

void draw_pixel(uint32_t px, uint8_t c){
  // calculate  pixel index (in what byte the pixel is located)
  // then access the specific pixel from the byte (calculate the shift from the bit at which the pixel is located) -> 0b00 00 00 00 (4 px/byte)
  // then manipulate the valua at each pixel to correspond to a color from 0 to 3
  framebuffer[px] = c;
}
