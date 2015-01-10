// See LICENSE for license details.

//**************************************************************************
// Vector-Thread Vector-vector add benchmark
//--------------------------------------------------------------------------
//
// This benchmark uses adds to vectors and writes the results to a third
// vector. The input data (and reference data) should be generated using the
// vvadd_gendata.pl perl script and dumped to a file named dataset.h.

// Choose which implementation you wish to test... but leave only one on!
// (only the first one will be executed).
//#define SCALAR_C
//#define SCALAR_ASM
#define VT_ASM

//--------------------------------------------------------------------------
// Input/Reference Data

//#include "dataset_test.h"
#include "dataset.h"

//--------------------------------------------------------------------------
// Helper functions

int verify( int n, float test[], float correct[] )
{
  int i;
  for ( i = 0; i < n; i++ ) {
//    if ( test[i] != correct[i] ) {
    if ( test[i] > 1.02*correct[i] 
       || test[i] < 0.98*correct[i]) {
#if HOST_DEBUG
      printf("    test[%d] : %3.2f\n", i, test[i]);
      printf("    corr[%d] : %3.2f\n", i, correct[i]);
#endif
      // tell us which index fails + 2
      // (so that if i==0,i==1 fails, we don't 
      // think it was a 'not-finished yet' or pass)
//      return i+10; 
      return 2; 
    }
  }
  return 1;
}
 
void finishTest( int correct, long long num_cycles, long long num_retired )
{
   int toHostValue = correct;
#if HOST_DEBUG
  if ( toHostValue == 1 )
    printf( "*** PASSED ***\n" );
  else
    printf( "*** FAILED *** (tohost = %d)\n", toHostValue );
  exit(0);
#else
  // we no longer run in -testrun mode, which means we can't use
  // the tohost register to communicate "test is done" and "test results"
  // so instead we will communicate through print* functions!
  if ( correct == 1 )
  {
    printstr( "*** PASSED *** (num_cycles = 0x" );
    printhex(num_cycles);
    printstr( ", num_inst_retired = 0x");
    printhex(num_retired);
    printstr( ")\n" );
  }
  else
  {
    printstr( "*** FAILED *** (num_cycles = 0x");
    printhex(num_cycles);
    printstr( ", num_inst_retired = 0x");
    printhex(num_retired);
    printstr( ")\n" );
  }
  exit();
#endif
}
 

// deprecated - cr10/stats-enable register no longer exists
void setStats( int enable )
{
#if ( !HOST_DEBUG && SET_STATS )
  asm( "mtpcr %0, cr10" : : "r" (enable) );
#endif
}
 
long long getCycles()
{
   long long cycles = 1337;
#if ( !HOST_DEBUG && SET_STATS )
  __asm__ __volatile__( "rdcycle %0" : "=r" (cycles) );
#endif
  return cycles;
}
          
long long getInstRetired()
{
   long long inst_retired = 1338;
#if ( !HOST_DEBUG && SET_STATS )
  __asm__ __volatile__( "rdinstret %0" : "=r" (inst_retired) );
#endif
  return inst_retired;
}
          
//--------------------------------------------------------------------------
// vvadd function

// scalar C implementation 
void vvadd( int n, float a[], float b[], float c[] )
{
  int i;
  for ( i = 0; i < n; i++ )
    c[i] = a[i] + b[i];
}

// assembly implementations can be found in *_asm.S

//--------------------------------------------------------------------------
// Main

int main( int argc, char* argv[] )
{
  float results_data[DATA_SIZE];
  long long start_cycles = 0;
  long long stop_cycles = 0;
  long long num_cycles; 
  long long start_retired = 0;
  long long stop_retired = 0;
  long long num_retired;

  // Output the input array

#if HOST_DEBUG
  printArray( "input1", DATA_SIZE, input1_data );
  printArray( "input2", DATA_SIZE, input2_data );
  printArray( "verify", DATA_SIZE, verify_data );
#endif

  // --------------------------------------------------
  // If needed we preallocate everything in the caches

#if PREALLOCATE
  
#ifdef SCALAR_C
  vvadd( DATA_SIZE, input1_data, input2_data, results_data );
#else
#ifdef SCALAR_ASM
  scalar_vvadd_asm( DATA_SIZE, input1_data, input2_data, results_data );
#else
#ifdef VT_ASM
  vt_vvadd_asm( DATA_SIZE, input1_data, input2_data, results_data );
#endif
#endif
#endif

#endif

  // --------------------------------------------------
  // Do the vvadd
  start_cycles = getCycles();
  start_retired = getInstRetired();

#ifdef SCALAR_C
  vvadd( DATA_SIZE, input1_data, input2_data, results_data );
#else
#ifdef SCALAR_ASM
  #if HOST_DEBUG==0
  scalar_vvadd_asm( DATA_SIZE, input1_data, input2_data, results_data );
  #endif
#else
#ifdef VT_ASM
  #if HOST_DEBUG==0
  vt_vvadd_asm( DATA_SIZE, input1_data, input2_data, results_data );
  #endif
#endif
#endif
#endif
  
  stop_cycles  = getCycles();
  stop_retired = getInstRetired();
  num_cycles = stop_cycles - start_cycles;
  num_retired = stop_retired - start_retired;

//  printstr("stop_cycles: "); printhex(stop_cycles); printstr("\n");
//  printstr("star_cycles: "); printhex(start_cycles); printstr("\n");

  // --------------------------------------------------
  // Print out the results

#if HOST_DEBUG
  printArray( "results", DATA_SIZE, results_data );
#endif

  // --------------------------------------------------
  // Check the results
  int correct = verify( DATA_SIZE, results_data, verify_data );
  finishTest(correct, num_cycles, num_retired);
}
