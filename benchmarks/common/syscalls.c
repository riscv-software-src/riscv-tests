#include <stdint.h>
#include <string.h>
#include <stdarg.h>
#include <machine/syscall.h>
#include "encoding.h"

void exit(int code)
{
  volatile uint64_t magic_mem[8] = {0};
  magic_mem[0] = SYS_exit;
  magic_mem[1] = code;
  __sync_synchronize();
  write_csr(tohost, (long)magic_mem);
  while(1);
}

void printstr(const char* s)
{
  volatile uint64_t magic_mem[8] = {0};
  magic_mem[0] = SYS_write;
  magic_mem[1] = 1;
  magic_mem[2] = (unsigned long)s;
  magic_mem[3] = strlen(s);
  __sync_synchronize();
  write_csr(tohost, (long)magic_mem);
  while (swap_csr(fromhost, 0) == 0);
}

int putchar(int ch)
{
  static char buf[64];
  static int buflen = 0;

  if(ch != -1)
    buf[buflen++] = ch;

  if(ch == -1 || buflen == sizeof(buf))
  {
    volatile uint64_t magic_mem[8] = {0};
    magic_mem[0] = SYS_write;
    magic_mem[1] = 1;
    magic_mem[2] = (long)buf;
    magic_mem[3] = buflen;
    __sync_synchronize();
    write_csr(tohost, (long)magic_mem);
    while (swap_csr(fromhost, 0) == 0);

    buflen = 0;
  }

  return 0;
}

void printhex(uint64_t x)
{
  char str[17];
  int i;
  for (i = 0; i < 16; i++)
  {
    str[15-i] = (x & 0xF) + ((x & 0xF) < 10 ? '0' : 'a'-10);
    x >>= 4;
  }
  str[16] = 0;

  printstr(str);
}

static void printnum(void (*putch)(int, void**), void **putdat,
                   unsigned long long num, unsigned base, int width, int padc)
{
  if (num >= base)
    printnum(putch, putdat, num / base, base, width - 1, padc);
  else while (--width > 0)
    putch(padc, putdat);

  putch("0123456789abcdef"[num % base], putdat);
}

static unsigned long long getuint(va_list *ap, int lflag)
{
  if (lflag >= 2)
    return va_arg(*ap, unsigned long long);
  else if (lflag)
    return va_arg(*ap, unsigned long);
  else
    return va_arg(*ap, unsigned int);
}

static long long getint(va_list *ap, int lflag)
{
  if (lflag >= 2)
    return va_arg(*ap, long long);
  else if (lflag)
    return va_arg(*ap, long);
  else
    return va_arg(*ap, int);
}

void vprintfmt(void (*putch)(int, void**), void **putdat, const char *fmt, va_list ap)
{
  register const char* p;
  const char* last_fmt;
  register int ch, err;
  unsigned long long num;
  int base, lflag, width, precision, altflag;
  char padc;

  while (1) {
    while ((ch = *(unsigned char *) fmt) != '%') {
      if (ch == '\0')
        return;
      fmt++;
      putch(ch, putdat);
    }
    fmt++;

    // Process a %-escape sequence
    last_fmt = fmt;
    padc = ' ';
    width = -1;
    precision = -1;
    lflag = 0;
    altflag = 0;
  reswitch:
    switch (ch = *(unsigned char *) fmt++) {

    // flag to pad on the right
    case '-':
      padc = '-';
      goto reswitch;
      
    // flag to pad with 0's instead of spaces
    case '0':
      padc = '0';
      goto reswitch;

    // width field
    case '1':
    case '2':
    case '3':
    case '4':
    case '5':
    case '6':
    case '7':
    case '8':
    case '9':
      for (precision = 0; ; ++fmt) {
        precision = precision * 10 + ch - '0';
        ch = *fmt;
        if (ch < '0' || ch > '9')
          break;
      }
      goto process_precision;

    case '*':
      precision = va_arg(ap, int);
      goto process_precision;

    case '.':
      if (width < 0)
        width = 0;
      goto reswitch;

    case '#':
      altflag = 1;
      goto reswitch;

    process_precision:
      if (width < 0)
        width = precision, precision = -1;
      goto reswitch;

    // long flag (doubled for long long)
    case 'l':
      lflag++;
      goto reswitch;

    // character
    case 'c':
      putch(va_arg(ap, int), putdat);
      break;

    // string
    case 's':
      if ((p = va_arg(ap, char *)) == NULL)
        p = "(null)";
      if (width > 0 && padc != '-')
        for (width -= strnlen(p, precision); width > 0; width--)
          putch(padc, putdat);
      for (; (ch = *p) != '\0' && (precision < 0 || --precision >= 0); width--) {
        if (altflag && (ch < ' ' || ch > '~'))
          putch('?', putdat);
        else
          putch(ch, putdat);
        p++;
      }
      for (; width > 0; width--)
        putch(' ', putdat);
      break;

    // (signed) decimal
    case 'd':
      num = getint(&ap, lflag);
      if ((long long) num < 0) {
        putch('-', putdat);
        num = -(long long) num;
      }
      base = 10;
      goto number;

    // unsigned decimal
    case 'u':
      num = getuint(&ap, lflag);
      base = 10;
      goto number;

    // (unsigned) octal
    case 'o':
      // should do something with padding so it's always 3 octits
      num = getuint(&ap, lflag);
      base = 8;
      goto number;

    // pointer
    case 'p':
      putch('0', putdat);
      putch('x', putdat);
      num = (unsigned long long)
        (uintptr_t) va_arg(ap, void *);
      base = 16;
      goto number;

    // (unsigned) hexadecimal
    case 'x':
      num = getuint(&ap, lflag);
      base = 16;
    number:
      printnum(putch, putdat, num, base, width, padc);
      break;

    // escaped '%' character
    case '%':
      putch(ch, putdat);
      break;
      
    // unrecognized escape sequence - just print it literally
    default:
      putch('%', putdat);
      fmt = last_fmt;
      break;
    }
  }
}

int printf(const char* fmt, ...)
{
  va_list ap;
  va_start(ap, fmt);

  vprintfmt((void*)putchar, 0, fmt, ap);
  putchar(-1);

  va_end(ap);
  return 0; // incorrect return value, but who cares, anyway?
}
