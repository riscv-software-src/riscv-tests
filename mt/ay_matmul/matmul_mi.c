//**************************************************************************
// Multi-threaded Matrix Multiply benchmark
//--------------------------------------------------------------------------
// TA     : Christopher Celio
// Student: 
//
//
// This benchmark multiplies two 2-D arrays together and writes the results to
// a third vector. The input data (and reference data) should be generated
// using the matmul_gendata.pl perl script and dumped to a file named
// dataset.h. 


// print out arrays, etc.
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
             stringify(code), _c, _c/DIM_SIZE/DIM_SIZE/DIM_SIZE, 10*_c/DIM_SIZE/DIM_SIZE/DIM_SIZE%10, _c/_i, 10*_c/_i%10); \
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
      printf( " %3ld ", (long) arr[i] );
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
         printf("FAILED test[%d]= %3ld, correct[%d]= %3ld\n", 
            i, (long)test[i], i, (long)correct[i]);
         exit(-1);
      }
   }
   
   return;
}
 
//--------------------------------------------------------------------------
// matmul function
 
// single-thread, naive version
void __attribute__((noinline)) matmul_naive(const int lda,  const data_t A[], const data_t B[], data_t C[] )
{
   int i, j, k;

   if (coreid > 0)
      return;
  
   for ( i = 0; i < lda; i++ )
      for ( j = 0; j < lda; j++ )  
      {
         for ( k = 0; k < lda; k++ ) 
         {
            C[i + j*lda] += A[j*lda + k] * B[k*lda + i];
         }
      }

}
 
void __attribute__((noinline)) matmul(const int lda,  const data_t A[], const data_t B[], data_t C[] )
{
  static __thread int i, j, k;
  static __thread data_t tempA0, tempA1, tempA2, tempA3, tempA4, tempA5, tempA6, tempA7;
  static __thread data_t tempC0, tempC1, tempC2, tempC3, tempC4, tempC5, tempC6, tempC7, tempC8, tempC9, tempC10, tempC11, tempC12, tempC13, tempC14, tempC15;

  static __thread int start, end, jStride, jToRow, jToCol;
  static data_t A1[1024], B1[1024];;
  
  start = coreid << 9;
  end = (coreid+1) << 9;
  jStride = 8;

  if (coreid == 0) { 
    for (j=start; j < end; j+=jStride) {
      jToRow = (j>>5)<<5;
      jToCol = j%32;
      tempC0  = 0;
      tempC1  = 0;
      tempC2  = 0;
      tempC3  = 0;
      tempC4  = 0;
      tempC5  = 0;
      tempC6  = 0;
      tempC7  = 0;
      for ( i=0; i < lda; i+=2 ) {
        tempA0 = A[i   + jToRow];
        tempA1 = A[i+1 + jToRow];
        tempC0  += tempA0 * B[(jToCol   ) + (i<<5)];
        tempC1  += tempA0 * B[(jToCol+1 ) + (i<<5)];
        tempC2  += tempA0 * B[(jToCol+2 ) + (i<<5)];
        tempC3  += tempA0 * B[(jToCol+3 ) + (i<<5)];
        tempC4  += tempA0 * B[(jToCol+4 ) + (i<<5)];
        tempC5  += tempA0 * B[(jToCol+5 ) + (i<<5)];
        tempC6  += tempA0 * B[(jToCol+6 ) + (i<<5)];
        tempC7  += tempA0 * B[(jToCol+7 ) + (i<<5)];
        tempC0  += tempA1 * B[(jToCol   ) + ((i+1)<<5)];
        tempC1  += tempA1 * B[(jToCol+1 ) + ((i+1)<<5)];
        tempC2  += tempA1 * B[(jToCol+2 ) + ((i+1)<<5)];
        tempC3  += tempA1 * B[(jToCol+3 ) + ((i+1)<<5)];
        tempC4  += tempA1 * B[(jToCol+4 ) + ((i+1)<<5)];
        tempC5  += tempA1 * B[(jToCol+5 ) + ((i+1)<<5)];
        tempC6  += tempA1 * B[(jToCol+6 ) + ((i+1)<<5)];
        tempC7  += tempA1 * B[(jToCol+7 ) + ((i+1)<<5)];
      }
      C[j] =tempC0;
      C[j + 1 ]=tempC1;
      C[j + 2 ]=tempC2;
      C[j + 3 ]=tempC3;
      C[j + 4 ]=tempC4;
      C[j + 5 ]=tempC5;
      C[j + 6 ]=tempC6;
      C[j + 7 ]=tempC7;
    }
  }
  else { 
    for (i = 0; i < 1024; i++) {
      A1[i] = A[i];
      B1[i] = B[i];
    }
    for (j=start; j < end; j+=jStride) {
      jToRow = (j>>5)<<5;
      jToCol = j%32;
      tempC0  = 0;
      tempC1  = 0;
      tempC2  = 0;
      tempC3  = 0;
      tempC4  = 0;
      tempC5  = 0;
      tempC6  = 0;
      tempC7  = 0;
      for ( i=0; i < lda; i+=2 ) {
        tempA0 = A1[i   + jToRow];
        tempA1 = A1[i+1 + jToRow];
        tempC0  += tempA0 * B1[(jToCol   ) + (i<<5)];
        tempC1  += tempA0 * B1[(jToCol+1 ) + (i<<5)];
        tempC2  += tempA0 * B1[(jToCol+2 ) + (i<<5)];
        tempC3  += tempA0 * B1[(jToCol+3 ) + (i<<5)];
        tempC4  += tempA0 * B1[(jToCol+4 ) + (i<<5)];
        tempC5  += tempA0 * B1[(jToCol+5 ) + (i<<5)];
        tempC6  += tempA0 * B1[(jToCol+6 ) + (i<<5)];
        tempC7  += tempA0 * B1[(jToCol+7 ) + (i<<5)];
        tempC0  += tempA1 * B1[(jToCol   ) + ((i+1)<<5)];
        tempC1  += tempA1 * B1[(jToCol+1 ) + ((i+1)<<5)];
        tempC2  += tempA1 * B1[(jToCol+2 ) + ((i+1)<<5)];
        tempC3  += tempA1 * B1[(jToCol+3 ) + ((i+1)<<5)];
        tempC4  += tempA1 * B1[(jToCol+4 ) + ((i+1)<<5)];
        tempC5  += tempA1 * B1[(jToCol+5 ) + ((i+1)<<5)];
        tempC6  += tempA1 * B1[(jToCol+6 ) + ((i+1)<<5)];
        tempC7  += tempA1 * B1[(jToCol+7 ) + ((i+1)<<5)];
      }
      C[j] =tempC0;
      C[j + 1 ]=tempC1;
      C[j + 2 ]=tempC2;
      C[j + 3 ]=tempC3;
      C[j + 4 ]=tempC4;
      C[j + 5 ]=tempC5;
      C[j + 6 ]=tempC6;
      C[j + 7 ]=tempC7;
    }
  }
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
   static data_t results_data[ARRAY_SIZE];


   //// Execute the provided, naive matmul
   //barrier();
   //stats(matmul_naive(DIM_SIZE, input1_data, input2_data, results_data); barrier());
 
   //
   //// verify
   //verify(ARRAY_SIZE, results_data, verify_data);
   //
   //// clear results from the first trial
   //size_t i;
   //if (coreid == 0) 
   //   for (i=0; i < ARRAY_SIZE; i++)
   //      results_data[i] = 0;
   //barrier();

   
   // Execute your faster matmul
   barrier();
   stats(matmul(DIM_SIZE, input1_data, input2_data, results_data); barrier());
 
#ifdef DEBUG
   printArray("results:", ARRAY_SIZE, results_data);
   printArray("verify :", ARRAY_SIZE, verify_data);
#endif
   
   // verify
   verify(ARRAY_SIZE, results_data, verify_data);
   barrier();

   exit(0);
}


