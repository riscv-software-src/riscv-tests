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

// The INSERTION_THRESHOLD is the size of the subarray when the
// algorithm switches to using an insertion sort instead of
// quick sort.

#define INSERTION_THRESHOLD 7

// NSTACK is the required auxiliary storage.
// It must be at least 2*lg(DATA_SIZE)

#define NSTACK 50

// Swap macro for swapping two values.

#define SWAP(a,b) temp=(a);(a)=(b);(b)=temp;

//--------------------------------------------------------------------------
// Input/Reference Data

#include "dataset1.h"

//--------------------------------------------------------------------------
// Quicksort function

void sort( int n, int arr[] )
{
  int i,j,k;
  int ir = n;
  int l = 1;
  int jstack = 0;
  int a, temp;

  int istack[NSTACK];

  for (;;) {

#if HOST_DEBUG
    printArray( "", n, arr );
#endif

    // Insertion sort when subarray small enough.
    if ( ir-l < INSERTION_THRESHOLD ) {

      for ( j = l+1; j <= ir; j++ ) {
        a = arr[j-1];
        for ( i = j-1; i >= l; i-- ) {
          if ( arr[i-1] <= a ) break;
          arr[i] = arr[i-1];
        }
        arr[i] = a;
      }

      if ( jstack == 0 ) break;

      // Pop stack and begin a new round of partitioning.
      ir = istack[jstack--];
      l = istack[jstack--];

    }
    else {

      // Choose median of left, center, and right elements as
      // partitioning element a. Also rearrange so that a[l-1] <= a[l] <= a[ir-].

      k = (l+ir) >> 1;
      SWAP(arr[k-1],arr[l])
      if ( arr[l-1] > arr[ir-1] ) {
        SWAP(arr[l-1],arr[ir-1])
      }
      if ( arr[l] > arr[ir-1] ) {
        SWAP(arr[l],arr[ir-1])
      }
      if ( arr[l-1] > arr[l] ) {
        SWAP(arr[l-1],arr[l])
      }

      // Initialize pointers for partitioning.
      i = l+1;
      j = ir;

      // Partitioning element.
      a = arr[l];

      for (;;) {                       // Beginning of innermost loop.
        do i++; while (arr[i-1] < a);  // Scan up to find element > a.
        do j--; while (arr[j-1] > a);  // Scan down to find element < a.
        if (j < i) break;              // Pointers crossed. Partitioning complete.
        SWAP(arr[i-1],arr[j-1]);       // Exchange elements.
      }                                // End of innermost loop.

      // Insert partitioning element.
      arr[l] = arr[j-1];
      arr[j-1] = a;
      jstack += 2;

      // Push pointers to larger subarray on stack,
      // process smaller subarray immediately.

#if HOST_DEBUG
      if ( jstack > NSTACK ) { printf("NSTACK too small in sort.\n"); exit(1); }
#endif

      if ( ir-i+1 >= j-l ) {
        istack[jstack]   = ir;
        istack[jstack-1] = i;
        ir = j-1;
      }
      else {
        istack[jstack]   = j-1;
        istack[jstack-1] = l;
        l = i;
      }
    }

  }

}

//--------------------------------------------------------------------------
// Main

int main( int argc, char* argv[] )
{
  // Output the input array
  printArray( "input", DATA_SIZE, input_data );
  printArray( "verify", DATA_SIZE, verify_data );

#if PREALLOCATE
  // If needed we preallocate everything in the caches
  sort( DATA_SIZE, input_data );
#endif

  // Do the sort
  setStats(1);
  sort( DATA_SIZE, input_data );
  setStats(0);

  // Print out the results
  printArray( "test", DATA_SIZE, input_data );

  // Check the results
  return verify( DATA_SIZE, input_data, verify_data );
}
