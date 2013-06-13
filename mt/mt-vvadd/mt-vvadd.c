//**************************************************************************
// Vector-vector add benchmark
//--------------------------------------------------------------------------
// Author  : Andrew Waterman
// TA      : Christopher Celio
// Student : 
//
// This benchmark adds two vectors and writes the results to a
// third vector. The input data (and reference data) should be
// generated using the vvadd_gendata.pl perl script and dumped
// to a file named dataset.h 

// to print out arrays, etc.
//#define DEBUG

//--------------------------------------------------------------------------
// Includes 

#include <string.h>
#include <stdlib.h>
#include <stdio.h>


//--------------------------------------------------------------------------
// Input/Reference Data

typedef float data_t;
#include "dataset.h"
 
  
//--------------------------------------------------------------------------
// Basic Utilities and Multi-thread Support

__thread unsigned long coreid;
unsigned long ncores;

#include "util.h"
   
#define stringify_1(s) #s
#define stringify(s) stringify_1(s)
#define stats(code) do { \
    unsigned long _c = -rdcycle(), _i = -rdinstret(); \
    code; \
    _c += rdcycle(), _i += rdinstret(); \
    if (coreid == 0) \
      printf("%s: %ld cycles, %ld.%ld cycles/iter, %ld.%ld CPI\n", \
             stringify(code), _c, _c/DATA_SIZE, 10*_c/DATA_SIZE%10, _c/_i, 10*_c/_i%10); \
  } while(0)
 

//--------------------------------------------------------------------------
// Helper functions
 
void printArray( char name[], int n, data_t arr[] )
{
  int i;
  if (coreid != 0)
     return;

  printf( " %10s :", name );
  for ( i = 0; i < n; i++ )
    printf( " %4ld ", (long) arr[i] );
  printf( "\n" );
}
      
void __attribute__((noinline)) verify(size_t n, const data_t* test, const data_t* correct)
{
   if (coreid != 0)
      return;

   size_t i;
   for (i = 0; i < n; i++)
   {
      if (test[i] != correct[i])
      {
         printf("FAILED test[%d]= %4ld, correct[%d]= %4ld\n", 
            i, (long) test[i], i, (long)correct[i]);
         exit(-1);
      }
   }
   
   return;
}
 
//--------------------------------------------------------------------------
// vvadd function

//perform in-place vvadd
void __attribute__((noinline)) vvadd(size_t n, data_t* __restrict__ x, const data_t* __restrict__ y)
{
   size_t i;

   // interleave accesses
   for (i = coreid; i < n; i+=ncores)
   {
      x[i] = x[i] + y[i];
   }
}

void __attribute__((noinline)) vvadd_opt(size_t n, data_t* __restrict__ x, const data_t* __restrict__ y)
{
   // ***************************** //
   // **** ADD YOUR CODE HERE ***** //
   // ***************************** //
}

//--------------------------------------------------------------------------
// Main
//
// all threads start executing thread_entry(). Use their "coreid" to
// differentiate between threads (each thread is running on a separate core).
  
void thread_entry(int cid, int nc)
{
   coreid = cid;
   ncores = nc;

   // static allocates data in the binary, which is visible to both threads
   static data_t results_data[DATA_SIZE];
   
   // because we're going to perform an in-place vvadd (and we're going to run
   // it a couple of times) let's copy the input data to a temporary results
   // array
   
   size_t i;
   if (coreid == 0)
   {
      for (i = 0; i < DATA_SIZE; i++)
         results_data[i] = input1_data[i];
   }


   // Execute the provided, terrible vvadd
   barrier();
   stats(vvadd(DATA_SIZE, results_data, input2_data); barrier());
 
   
   // verify
   verify(DATA_SIZE, results_data, verify_data);
   
   // reset results from the first trial
   if (coreid == 0) 
   {
      for (i=0; i < DATA_SIZE; i++)
         results_data[i] = input1_data[i];
   }
   barrier();
                                            
   
   // Execute your faster vvadd
   barrier();
   stats(vvadd_opt(DATA_SIZE, results_data, input2_data); barrier());

#ifdef DEBUG
   printArray("results: ", DATA_SIZE, results_data);
   printArray("verify : ", DATA_SIZE, verify_data);
#endif
   
   // verify
   verify(DATA_SIZE, results_data, verify_data);
   barrier();

   exit(0);
}

