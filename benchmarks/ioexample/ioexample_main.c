// See LICENSE for license details.

#include "util.h"

const char *find_config_string(void)
{
  const int* boot_rom = (int*)(0x1000);
  const int config_string_addr_offset = 3;
  const char *config_string = (char *)((long)boot_rom[config_string_addr_offset]);
  return config_string;
}

int isspace(int c)
{
  if (c == ' ')  return 1;
  if (c == '\t') return 1;
  if (c == '\n') return 1;
  if (c == '\r') return 1;
  return 0;
}

const char *advance_until_slash(const char *path)
{
  while ((*path != '\0') && (*path != '/'))
    path++;
  if (*path == '/')
    path++;

  return path;
}

const char *advance_until_entered(const char *config_string)
{
  while ((*config_string != '\0') && (*config_string != '{'))
    config_string++;

  if (*config_string == '{')
    config_string++;

  return config_string;
}

const char *advance_until_over(const char *config_string)
{
  config_string = advance_until_entered(config_string);
  int open = 1;
  while ((*config_string != '\0') && (open > 0)) {
    if (*config_string == '{') open++;
    if (*config_string == '}') open--;
    config_string++;
  }
  if (*config_string == ';')
    config_string++;

  return config_string;
}

int compare_until_slash(const char *config_string, const char *path)
{
  while (isspace(*config_string)) config_string++;
  while ((*path != '\0') && (*path != '/') && (*config_string != '\0')) {
    if (*path != *config_string)
      return 0;
    path++;
    config_string++;
  }

  if (!isspace(*config_string))
    return 0;

  return 1;
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

const char *find_in_config_string(const char *config_string, const char *path)
{
  while (*path != '\0' && *config_string != '\0') {
    if (compare_until_slash(config_string, path)) {
      path = advance_until_slash(path);
      if (*path != '\0')
        config_string = advance_until_entered(config_string);
    } else {
      config_string = advance_until_over(config_string);
    }
  }

  /* Remove any whitespace from the config string, then strip off the key. */
  while (*config_string != '\0' &&  isspace(*config_string)) config_string++;
  while (*config_string != '\0' && !isspace(*config_string)) config_string++;
  while (*config_string != '\0' &&  isspace(*config_string)) config_string++;

  return config_string;
}

int main( int argc, char* argv[] )
{
  volatile long *base = (long *)(tolong(find_in_config_string(find_config_string(), "smiexample/addr")));
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
