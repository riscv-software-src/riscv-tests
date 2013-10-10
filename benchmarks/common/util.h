// helpful utility and synch functions 

// relies on defining "ncores" before including this file...

#ifndef __UTIL_H
#define __UTIL_H

#include <machine/syscall.h>

#define rdcycle() ({ unsigned long _c; asm volatile ("rdcycle %0" : "=r"(_c) :: "memory"); _c; })
#define rdinstret() ({ unsigned long _c; asm volatile ("rdinstret %0" : "=r"(_c) :: "memory"); _c; })
                            
void __attribute__((noinline)) barrier()
{
  static volatile int sense;
  static volatile int count;
  static __thread int threadsense;

  __sync_synchronize();

  threadsense = !threadsense;
  if (__sync_fetch_and_add(&count, 1) == ncores-1)
  {
    count = 0;
    sense = threadsense;
  }
  else while(sense != threadsense)
    ;

  __sync_synchronize();
}





void finishTest(int test_result)
{
#if HOST_DEBUG
  if ( test_result == 1 )
    printf( "*** PASSED ***\n" );
  else
    printf( "*** FAILED *** (tohost = %d)\n", test_result);
  exit(0);
#else
   {
      // perform exit syscall
      asm volatile(
          "move a0,%0 ;"
          "li a1,0    ;"
          "li a2,0    ;"
          "li a3,0    ;"
          "li v0,%1   ;"
          "syscall" : : "r"(test_result) , "i"(SYS_exit));
   }
#endif
}

#endif //__UTIL_H

