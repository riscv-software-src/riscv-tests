#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>


int main()
{

  volatile int forever = 1;
  while (forever);

  return 1;
}
