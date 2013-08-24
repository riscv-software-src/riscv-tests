//**************************************************************************
// Median filter bencmark
//--------------------------------------------------------------------------
//
// This benchmark performs a 1D three element median filter. The
// input data (and reference data) should be generated using the
// median_gendata.pl perl script and dumped to a file named
// dataset1.h You should not change anything except the
// HOST_DEBUG and PREALLOCATE macros for your timing run.

#include "median.h"

//--------------------------------------------------------------------------
// Macros

// Set HOST_DEBUG to 1 if you are going to compile this for a host
// machine (ie Athena/Linux) for debug purposes and set HOST_DEBUG
// to 0 if you are compiling with the smips-gcc toolchain.

#ifndef HOST_DEBUG
#define HOST_DEBUG 0
#endif

// Set PREALLOCATE to 1 if you want to preallocate the benchmark
// function before starting stats. If you have instruction/data
// caches and you don't want to count the overhead of misses, then
// you will need to use preallocation.

#ifndef PREALLOCATE
#define PREALLOCATE 0
#endif

// Set SET_STATS to 1 if you want to carve out the piece that actually
// does the computation.

#ifndef SET_STATS
#define SET_STATS 0
#endif

//--------------------------------------------------------------------------
// Input/Reference Data

#include "dataset1.h"

//--------------------------------------------------------------------------
// Helper functions

int verify( int n, int test[], int correct[] )
{
  int i;
  for ( i = 0; i < n; i++ ) {
    if ( test[i] != correct[i] ) {
      return 2;
    }
  }
  return 1;
}

#if HOST_DEBUG
void printArray( char name[], int n, int arr[] )
{
  int i;
  printf( " %10s :", name );
  for ( i = 0; i < n; i++ )
    printf( " %3d ", arr[i] );
  printf( "\n" );
}
#endif

void finishTest( int toHostValue )
{
#if HOST_DEBUG
  if ( toHostValue == 1 )
    printf( "*** PASSED ***\n" );
  else
    printf( "*** FAILED *** (tohost = %d)\n", toHostValue );
  exit(0);
#else
  asm( "mtpcr %0, tohost" : : "r" (toHostValue) );
  while ( 1 ) { }
#endif
}

void setStats( int enable )
{
#if ( !HOST_DEBUG && SET_STATS )
  asm( "mtpcr %0, cr10" : : "r" (enable) );
#endif
}

//--------------------------------------------------------------------------
// Main

int main( int argc, char* argv[] )
{
  int results_data[DATA_SIZE];

  // Output the input array

#if HOST_DEBUG
  printArray( "input",  DATA_SIZE, input_data  );
  printArray( "verify", DATA_SIZE, verify_data );
#endif

  // If needed we preallocate everything in the caches

#if ( !HOST_DEBUG && PREALLOCATE )
  median( DATA_SIZE, input_data, results_data );
#endif

  // Do the filter

#if HOST_DEBUG
  median( DATA_SIZE, input_data, results_data );
#else
  setStats(1);
  median( DATA_SIZE, input_data, results_data );
  setStats(0);
#endif

  // Print out the results

#if HOST_DEBUG
  printArray( "results", DATA_SIZE, results_data );
#endif

  // Check the results

  finishTest(verify( DATA_SIZE, results_data, verify_data ));

}
