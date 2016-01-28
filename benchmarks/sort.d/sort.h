// See LICENSE for license details.

#include <string.h>
#include <stdint.h>
#include <stdbool.h>

#define USE_N_SQUARED_SORT

#define FAKE_MALLOC_INIT(words, name) \
  uint32_t heap_##name[words]; \
  const size_t max_alloc_##name = (words) * sizeof(uint32_t); \
  size_t cur_pos_##name; \
  void* fake_malloc_##name( size_t size ) \
  { \
    static bool init = false; \
    if(!init) { \
      cur_pos_##name = 0; \
      init = true; \
    } \
    if(cur_pos_##name < (words)) {  \
      void *ptr = (void*) &heap_##name[cur_pos_##name]; \
      cur_pos_##name += size & ~((uint32_t)3) + 1; \
      return ptr; \
    } else { \
      return NULL; \
    } \
  }

    

#ifndef _TAV_SORT_H_
#define _TAV_SORT_H_


int
n_squared_sort (float * value, int * index, int len);

int
radix_sort_tuples (int * value, int * index, int len, int radix_bits);

int
insertion_sort (float * value, int * index, int len);

int
quicksort (float * array, int * index, int len);

/* This defines the length at quicksort switches to insertion sort */
#ifndef MAX_THRESH
#define MAX_THRESH 10
#endif

#ifndef RADIX_BITS
#define RADIX_BITS (8)
#endif


#endif /* _TAV_SORT_H_ */
