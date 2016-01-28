// See LICENSE for license details.

//**************************************************************************
// Quicksort benchmark
//--------------------------------------------------------------------------
//
// This benchmark uses quicksort to sort an array of integers. The
// implementation is largely adapted from Numerical Recipes for C. The
// input data (and reference data) should be generated using the
// qsort_gendata.pl perl script and dumped to a file named
// dataset1.h The smips-gcc toolchain does not support system calls
// so printf's can only be used on a host system, not on the smips
// processor simulator itself. You should not change anything except
// the HOST_DEBUG and PREALLOCATE macros for your timing run.

#include "util.h"
#include <string.h>
#include <limits.h>

//--------------------------------------------------------------------------
// Input/Reference Data

#define type unsigned int
#include "dataset1.h"

#define LOG_BASE 8
#define BASE (1 << LOG_BASE)

void sort(size_t n, type* arrIn, type* scratchIn)
{
  size_t log_exp = 0;
  size_t buckets[BASE];
  size_t *bucket = buckets;
  asm("":"+r"(bucket));
  type *arr = arrIn, *scratch = scratchIn, *p;
  size_t *b;
 
  while (log_exp < CHAR_BIT * sizeof(type))
  {
    for (b = bucket; b < bucket + BASE; b++)
      *b = 0;

    for (p = arr; p < &arr[n-3]; p += 4)
    {
      type a0 = p[0];
      type a1 = p[1];
      type a2 = p[2];
      type a3 = p[3];
      __sync_fetch_and_add(&bucket[(a0 >> log_exp) % BASE], 1);
      __sync_fetch_and_add(&bucket[(a1 >> log_exp) % BASE], 1);
      __sync_fetch_and_add(&bucket[(a2 >> log_exp) % BASE], 1);
      __sync_fetch_and_add(&bucket[(a3 >> log_exp) % BASE], 1);
    }
    for ( ; p < &arr[n]; p++)
      bucket[(*p >> log_exp) % BASE]++;

    size_t prev = bucket[0];
    prev += __sync_fetch_and_add(&bucket[1], prev);
    for (b = &bucket[2]; b < bucket + BASE; b += 2)
    {
      prev += __sync_fetch_and_add(&b[0], prev);
      prev += __sync_fetch_and_add(&b[1], prev);
    }
    static_assert(BASE % 2 == 0);

    for (p = &arr[n-1]; p >= &arr[3]; p -= 4)
    {
      type a0 = p[-0];
      type a1 = p[-1];
      type a2 = p[-2];
      type a3 = p[-3];
      size_t* pb0 = &bucket[(a0 >> log_exp) % BASE];
      size_t* pb1 = &bucket[(a1 >> log_exp) % BASE];
      size_t* pb2 = &bucket[(a2 >> log_exp) % BASE];
      size_t* pb3 = &bucket[(a3 >> log_exp) % BASE];
      type* s0 = scratch + __sync_fetch_and_add(pb0, -1);
      type* s1 = scratch + __sync_fetch_and_add(pb1, -1);
      type* s2 = scratch + __sync_fetch_and_add(pb2, -1);
      type* s3 = scratch + __sync_fetch_and_add(pb3, -1);
      s0[-1] = a0;
      s1[-1] = a1;
      s2[-1] = a2;
      s3[-1] = a3;
    }
    for ( ; p >= &arr[0]; p--)
      scratch[--bucket[(*p >> log_exp) % BASE]] = *p;

    type* tmp = arr;
    arr = scratch;
    scratch = tmp;

    log_exp += LOG_BASE;
  }
  if (arr != arrIn)
    memcpy(arr, scratch, n*sizeof(type));
}

//--------------------------------------------------------------------------
// Main

int main( int argc, char* argv[] )
{
  static type scratch[DATA_SIZE];
  // Output the input array
  printArray( "input", DATA_SIZE, input_data );
  printArray( "verify", DATA_SIZE, verify_data );

#if PREALLOCATE
  // If needed we preallocate everything in the caches
  sort(DATA_SIZE, verify_data, scratch);
  if (verify(DATA_SIZE, input_data, input_data))
    return 1;
#endif

  // Do the sort
  setStats(1);
  sort(DATA_SIZE, input_data, scratch);
  setStats(0);

  // Print out the results
  printArray( "test", DATA_SIZE, input_data );

  // Check the results
  return verify( DATA_SIZE, input_data, verify_data );
}
