// See LICENSE for license details.

//**************************************************************************
// Vector-Thread Complex Multiply benchmark
//--------------------------------------------------------------------------
//
// This benchmark multiplies two complex numbers together.  The input data (and
// reference data) should be generated using the cmplxmult_gendata.pl perl
// script and dumped to a file named dataset.h. The riscv-gcc toolchain does
// not support system calls so printf's can only be used on a host system, not
// on the riscv-v processor simulator itself. 
//
// HOWEVER: printstr() and printhex() are provided, for a primitive form of
// printing strings and hexadecimal values to stdout.
 

// Choose which implementation you wish to test... but leave only one on!
// (only the first one will be executed).
//#define SCALAR_C
//#define SCALAR_ASM
#define VT_ASM
 
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
// Host Platform Includes

#if HOST_DEBUG
   #include <stdio.h>
   #include <stdlib.h>
#else
void printstr(const char*);
#endif

#include "util.h"


//--------------------------------------------------------------------------
// Complex Value Structs

struct Complex                                                               
{                                                                            
  float real;                                                                
  float imag;                                                                
};                                                                           


//--------------------------------------------------------------------------
// Input/Reference Data

//#include "dataset_test.h"
#include "dataset.h"


//--------------------------------------------------------------------------
// Helper functions

float absolute( float in)
{
  if (in > 0)
    return in;
  else
    return -in;
}


// are two floating point numbers "close enough"?
// this is pretty loose, because Perl is giving me pretty terrible answers
int close_enough(float a, float b)
{
   int close_enough = 1;

   if (  absolute(a) > 1.10*absolute(b) 
      || absolute(a) < 0.90*absolute(b)
      || absolute(a) > 1.10*absolute(b)
      || absolute(a) < 0.90*absolute(b))
   {
      if (absolute(absolute(a) - absolute(b)) > 0.1)
      {
         close_enough = 0;
      }
   }

   return close_enough;
}

int verify( int n, struct Complex test[], struct Complex correct[] )
{
  int i;
  for ( i = 0; i < n; i++ ) {
    if (  !close_enough(test[i].real, correct[i].real) 
       || !close_enough(test[i].imag, correct[i].imag))
    {
#if HOST_DEBUG
      printf("    test[%d] : {%3.2f, %3.2f}\n", i, test[i].real, test[i].imag);
      printf("    corr[%d] : {%3.2f, %3.2f}\n", i, correct[i].real, correct[i].imag);
#endif
      // tell us which index fails + 10
      // (so that if i==0,i==1 fails, we don't 
     // think it was a 'not-finished yet' or pass)
//      return i+10; 
      return 2;
    }
  }
  return 1;
}

//#if HOST_DEBUG
void printComplexArray( char name[], int n, struct Complex arr[] )
{
#if HOST_DEBUG
  int i;
  printf( " %10s :", name );
  for ( i = 0; i < n; i++ )
    printf( " {%03.2f,%03.2f} ", arr[i].real, arr[i].imag );
  printf( "\n" );
#else
  int i;
  printstr( name );
  for ( i = 0; i < n; i++ ) 
  {
    printstr(" {");
    printhex((int) arr[i].real);
    printstr(",");
    printhex((int) arr[i].imag);
    printstr("}");
  }
  printstr( "\n" );
#endif
}
//#endif

 
 
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
// complex multiply function

// scalar C implementation 
void cmplxmult( int n, struct Complex a[], struct Complex b[], struct Complex c[] )
{
  int i;
  for ( i = 0; i < n; i++ ) 
  {
    c[i].real = (a[i].real * b[i].real) - (a[i].imag * b[i].imag);
    c[i].imag = (a[i].imag * b[i].real) + (a[i].real * b[i].imag);
  }
}

// assembly implementations can be found in *_asm.S

//--------------------------------------------------------------------------
// Main

int main( int argc, char* argv[] )
{
  struct Complex results_data[DATA_SIZE];
  long long start_cycles = 0;
  long long stop_cycles = 0;
  long long num_cycles; 
  long long start_retired = 0;
  long long stop_retired = 0;
  long long num_retired;

  // Output the input array

#if HOST_DEBUG
  printComplexArray( "input1", DATA_SIZE, input1_data );
  printComplexArray( "input2", DATA_SIZE, input2_data );
  printComplexArray( "verify", DATA_SIZE, verify_data );
#endif

  // --------------------------------------------------
  // If needed we preallocate everything in the caches

#if PREALLOCATE

#ifdef SCALAR_C
  cmplxmult( DATA_SIZE, input1_data, input2_data, results_data );
#else
#ifdef SCALAR_ASM
  scalar_cmplxmult_asm( DATA_SIZE, input1_data, input2_data, results_data );
#else
#ifdef VT_ASM
  vt_cmplxmult_asm( DATA_SIZE, input1_data, input2_data, results_data );
#endif
#endif
#endif

#endif

  // --------------------------------------------------
  // Do the cmplxmult

  start_cycles = getCycles();
  start_retired = getInstRetired();
  
#ifdef SCALAR_C
  cmplxmult( DATA_SIZE, input1_data, input2_data, results_data );
#else
#ifdef SCALAR_ASM
  #if HOST_DEBUG==0
  scalar_cmplxmult_asm( DATA_SIZE, input1_data, input2_data, results_data );
  #endif
#else
#ifdef VT_ASM
  #if HOST_DEBUG==0
  vt_cmplxmult_asm( DATA_SIZE, input1_data, input2_data, results_data );
  #endif
#endif
#endif
#endif
  
  stop_cycles  = getCycles();
  stop_retired = getInstRetired();
  num_cycles = stop_cycles - start_cycles;
  num_retired = stop_retired - start_retired;

  // --------------------------------------------------
  // Print out the results

#if HOST_DEBUG
  printComplexArray( "results", DATA_SIZE, results_data );
  printComplexArray( "verify ", DATA_SIZE, verify_data );
#endif


  // --------------------------------------------------
  // Check the results
  int correct = verify( DATA_SIZE, results_data, verify_data );
  finishTest(correct, num_cycles, num_retired);

}
