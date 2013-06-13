// helpful utility and synch functions 

// relies on defining "ncores" before including this file...

#ifndef __UTIL_H
#define __UTIL_H

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
   
#endif //__UTIL_H

