#include <stdint.h>

uint32_t converter(uint32_t x) {
  uint32_t D = x & 0x000000FF;
  uint32_t C = x & 0x0000FF00;
  uint32_t B = x & 0x00FF0000;
  uint32_t A = x & 0xFF000000;
  uint32_t d = D << 24;
  uint32_t c = C << 8;
  uint32_t b = B >> 8;
  uint32_t a = A >> 24;
  uint32_t res = a | b | c | d;
  return res;
}

uint32_t rot_left_5(uint32_t x) { return (x << 5) | (x >> 27); }
