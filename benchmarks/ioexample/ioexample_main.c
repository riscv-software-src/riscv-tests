// See LICENSE for license details.

#include "util.h"

int main( int argc, char* argv[] )
{
  volatile long *base = (long *)0x48000000UL;
  for (long i = 0; i < 8; ++i) {
    base[i] = (i + (1UL << 8)) << 32UL;
    printf("base[%d]: %llx (0x%p)\n", i, base[i], &base[i]);
  }

  return 0;
}
