#define ncores 2
#include "common.h"
#include <assert.h>
#include <stdlib.h>
#include "util.h"

void thread_entry(int cid, int nc)
{
  const int R = 8;
  int m, n, p;
  int have_vec = 1;
  
  if (have_vec) {
    m = HCBM;
    n = HCBN;
    p = HCBK;
  } else {
    m = CBM;
    n = CBN;
    p = CBK;
  }

  t a[m*p];
  t b[p*n];
  t c[m*n];

  for (size_t i = 0; i < m; i++)
    for (size_t j = 0; j < p; j++)
      a[i*p+j] = i+j;
  for (size_t i = 0; i < p; i++)
    for (size_t j = 0; j < n; j++)
      b[i*n+j] = i-j;
  memset(c, 0, m*n*sizeof(c[0]));

  size_t instret, cycles;
  if (have_vec) {
    for (int i = 0; i < R; i++)
    {
      instret = -rdinstret();
      cycles = -rdcycle();
      mm_rb_hwacha(m, n, p, a, p, b, n, c, n);
      instret += rdinstret();
      cycles += rdcycle();
    }
  } else {
    for (int i = 0; i < R; i++)
    {
      instret = -rdinstret();
      cycles = -rdcycle();
      mm(m, n, p, a, p, b, n, c, n);
      instret += rdinstret();
      cycles += rdcycle();
    }
  }

  printf("C%d: reg block %dx%dx%d, cache block %dx%dx%d\n",
         cid, HRBM, HRBN, HRBK, HCBM, HCBN, HCBK);
  printf("C%d: %d instructions\n", cid, (int)(instret));
  printf("C%d: %d cycles\n", cid, (int)(cycles));
  printf("C%d: %d flops\n", cid, 2*m*n*p);
  printf("C%d: %d Mflops @ 1 GHz\n", cid, 2000*m*n*p/(cycles));

#if 1
  for (size_t i = 0; i < m; i++)
  {
    for (size_t j = 0; j < n; j++)
    {
      t s = 0;
      for (size_t aik = i, bkj = -j; aik < i+p; aik++, bkj++)
        s += (t)aik*(t)bkj;
      if (fabs(c[i*n+j]-s*R) > 1e-6*s)
      {
        printf("C%d: c[%lu][%lu] %u != %u\n", cid, i, j, (unsigned long)c[i*n+j], (unsigned long)s);
        exit(1);
      }
    }
  }
#endif

  //barrier(nc);
  exit(0);
}
