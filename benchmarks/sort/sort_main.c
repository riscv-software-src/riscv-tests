// ****************************************************************************
// sort benchmark from DARPA PERFECT TAV suite
// ---------------------------------------------------------------------------- 
#include "sort.h"
#include "util.h"
#include "dataset.h"

#define USE_RADIX_SORT

// Need 7 times the input size for: input data, indices, 
// four copies, and buckets.
FAKE_MALLOC_INIT( (8 * DATA_SIZE_SORT), radix )

int main( int argc, char* argv[] )
{
  int err;

  int* index = fake_malloc_radix (sizeof(int) * DATA_SIZE_SORT);
  for ( int i = 0; i < DATA_SIZE_SORT; i++ )
    index[i] = i;

#ifdef PREALLOCATE
  // Access every element of input_data_sort to make sure it's in cache
  // (or at least that as much as possible of its beginning is).
  float sum = 0;
  for(int i = DATA_SIZE_SORT-1; i >= 0; i--) {
    sum += input_data_sort[i];
  }
  if(sum < 0.1)
    return 1;

  const bool prealloc = true;
#else
  const bool prealloc = false;
#endif
  
  setStats(1);

#define read_csr_safe(reg) ({ long __tmp = 0; \
  asm volatile ("csrr %0, " #reg : "+r"(__tmp)); \
  __tmp; })


  long cycles = read_csr_safe(cycle);
  long instret = read_csr_safe(instret);

  // Do sorting
#if defined(USE_N_SQUARED_SORT)
  const char* algo = "N_SQUARED";
  err = n_squared_sort ( input_data_sort, index, DATA_SIZE_SORT );
#elif defined(USE_RADIX_SORT)
  const char* algo = "RADIX";
  err = radix_sort_tuples ( (int *) input_data_sort, index, DATA_SIZE_SORT, RADIX_BITS );
#elif defined(USE_INSERTION_SORT)
  const char* algo = "INSERTION";
  err = insertion_sort ( input_data_sort, index, DATA_SIZE_SORT );
#else
  const char* algo = "QUICKSORT";
  err = quicksort ( input_data_sort, index, DATA_SIZE_SORT );
#endif
  
  cycles = read_csr_safe(cycle) - cycles;
  instret = read_csr_safe(instret) - instret;

  setStats(0);

  // Validate result
  err = 0;
  for(int i = 0; i < DATA_SIZE_SORT-1; i++)
  {
    if((unsigned int) input_data_sort[i] > (unsigned int) input_data_sort[i+1])
    {
      err = i;
      for(int j = 0; j < DATA_SIZE_SORT; j++)
        printf("%d:\t%d\n", j, input_data_sort[j]);
      break;
    }
  }

  /*printf("sort_cycles  = %ld\n", cycles);
  printf("sort_instret = %d\n", instret);
  printf("sort_size    = %d\n", DATA_SIZE_SORT);
  printf("sort_algo    = %s\n", algo);
  printf("sort_radix_bits = %d\n", RADIX_BITS);
  printf("sort_prealloc = %s\n", prealloc ? "true" : "false");
  printf("sort_err = %d\n", err);
  */

  return err;
}



