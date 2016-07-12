// See LICENSE for license details.

#include "util.h"
#include "libamf/src/amf.h"

const char *find_config_string(void)
{
  const int* boot_rom = (int*)(0x1000);
  const int config_string_addr_offset = 3;
  const char *config_string = (char *)((long)boot_rom[config_string_addr_offset]);
  return config_string;
}

long fromhex(char c)
{
  if (c >= 'A' && c <= 'F') return c - 'A' + 10;
  if (c >= 'a' && c <= 'f') return c - 'a' + 10;
  if (c >= '0' && c <= '9') return c - '0' +  0;
  return -1;
}

long tolong(const char *config_snippet)
{
  if (config_snippet[0] == '0' && config_snippet[1] == 'x')
    config_snippet += 2;

  long out = 0;
  while (*config_snippet != '\0' && *config_snippet != ';')
    out = (out << 4) + fromhex(*config_snippet++);

  return out;
}

int main( int argc, char* argv[] )
{
  volatile long *base = (long *)(tolong(amf_lookup(find_config_string(), "smiexample/addr")));
  printf("smiexample/addr: %lx\n", base);

  base[1] = 10; // Period
  base[2] = 2;  // Duty Cycle
  base[0] = 1;  // Enable

  printf("Peroid: %d\n", base[1]);

  base[1] = 15; // Peroid
  base[2] = 7;  // Duty Cycle

  printf("Peroid: %d\n", base[1]);

  return 0;
}
