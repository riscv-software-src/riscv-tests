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
   // feel free to make a separate function for MI and MSI versions.
   int i, j, k, x;
   data_t temp0, temp1, temp2, temp3, temp4, temp5, temp6, temp7;
   data_t temp8, temp9, temp10, temp11, temp12, temp13, temp14, temp15;


   if(coreid == 0) {
      for(j = 0; j < 32; j++) {
         temp0  = C[j*lda];
         temp1  = C[1  + j*lda];
         temp2  = C[2  + j*lda];
         temp3  = C[3  + j*lda];
         temp4  = C[4  + j*lda];
         temp5  = C[5  + j*lda];
         temp6  = C[6  + j*lda];
         temp7  = C[7  + j*lda];
         temp8  = C[8  + j*lda];
         temp9  = C[9  + j*lda];
         temp10 = C[10 + j*lda];
         temp11 = C[11 + j*lda];
         temp12 = C[12 + j*lda];
         temp13 = C[13 + j*lda];
         temp14 = C[14 + j*lda];
         temp15 = C[15 + j*lda];
         for(k = 0; k < 32; k++) {
            temp0  += A[j*lda + k] * B[k*lda];
            temp1  += A[j*lda + k] * B[1  + k*lda];
            temp2  += A[j*lda + k] * B[2  + k*lda];
            temp3  += A[j*lda + k] * B[3  + k*lda];
            temp4  += A[j*lda + k] * B[4  + k*lda];
            temp5  += A[j*lda + k] * B[5  + k*lda];
            temp6  += A[j*lda + k] * B[6  + k*lda];
            temp7  += A[j*lda + k] * B[7  + k*lda];
            temp8  += A[j*lda + k] * B[8  + k*lda];
            temp9  += A[j*lda + k] * B[9  + k*lda];
            temp10 += A[j*lda + k] * B[10 + k*lda];
            temp11 += A[j*lda + k] * B[11 + k*lda];
            temp12 += A[j*lda + k] * B[12 + k*lda];
            temp13 += A[j*lda + k] * B[13 + k*lda];
            temp14 += A[j*lda + k] * B[14 + k*lda];
            temp15 += A[j*lda + k] * B[15 + k*lda];
         }
         C[j*lda] = temp0;
         C[1  + j*lda] = temp1;
         C[2  + j*lda] = temp2;
         C[3  + j*lda] = temp3;
         C[4  + j*lda] = temp4;
         C[5  + j*lda] = temp5;
         C[6  + j*lda] = temp6;
         C[7  + j*lda] = temp7;
         C[8  + j*lda] = temp8;
         C[9  + j*lda] = temp9;
         C[10 + j*lda] = temp10;
         C[11 + j*lda] = temp11;
         C[12 + j*lda] = temp12;
         C[13 + j*lda] = temp13;
         C[14 + j*lda] = temp14;
         C[15 + j*lda] = temp15;
      }
   }

   else  {
      for(j = 16; j < 32; j++) {
         temp0  = C[16 + j*lda];
         temp1  = C[17 + j*lda];
         temp2  = C[18 + j*lda];
         temp3  = C[19 + j*lda];
         temp4  = C[20 + j*lda];
         temp5  = C[21 + j*lda];
         temp6  = C[22 + j*lda];
         temp7  = C[23 + j*lda];
         temp8  = C[24 + j*lda];
         temp9  = C[25 + j*lda];
         temp10 = C[26 + j*lda];
         temp11 = C[27 + j*lda];
         temp12 = C[28 + j*lda];
         temp13 = C[29 + j*lda];
         temp14 = C[30 + j*lda];
         temp15 = C[31 + j*lda];
         for(k = 0; k < 32; k++) {
            temp0  += A[j*lda + k] * B[16 + k*lda];
            temp1  += A[j*lda + k] * B[17 + k*lda];
            temp2  += A[j*lda + k] * B[18 + k*lda];
            temp3  += A[j*lda + k] * B[19 + k*lda];
            temp4  += A[j*lda + k] * B[20 + k*lda];
            temp5  += A[j*lda + k] * B[21 + k*lda];
            temp6  += A[j*lda + k] * B[22 + k*lda];
            temp7  += A[j*lda + k] * B[23 + k*lda];
            temp8  += A[j*lda + k] * B[24 + k*lda];
            temp9  += A[j*lda + k] * B[25 + k*lda];
            temp10 += A[j*lda + k] * B[26 + k*lda];
            temp11 += A[j*lda + k] * B[27 + k*lda];
            temp12 += A[j*lda + k] * B[28 + k*lda];
            temp13 += A[j*lda + k] * B[29 + k*lda];
            temp14 += A[j*lda + k] * B[30 + k*lda];
            temp15 += A[j*lda + k] * B[31 + k*lda];
         }
         C[16 + j*lda] = temp0;
         C[17 + j*lda] = temp1;
         C[18 + j*lda] = temp2;
         C[19 + j*lda] = temp3;
         C[20 + j*lda] = temp4;
         C[21 + j*lda] = temp5;
         C[22 + j*lda] = temp6;
         C[23 + j*lda] = temp7;
         C[24 + j*lda] = temp8;
         C[25 + j*lda] = temp9;
         C[26 + j*lda] = temp10;
         C[27 + j*lda] = temp11;
         C[28 + j*lda] = temp12;
         C[29 + j*lda] = temp13;
         C[30 + j*lda] = temp14;
         C[31 + j*lda] = temp15;
      }
      for(j = 0; j <16; j++) {
         temp0  = C[16 + j*lda];
         temp1  = C[17 + j*lda];
         temp2  = C[18 + j*lda];
         temp3  = C[19 + j*lda];
         temp4  = C[20 + j*lda];
         temp5  = C[21 + j*lda];
         temp6  = C[22 + j*lda];
         temp7  = C[23 + j*lda];
         temp8  = C[24 + j*lda];
         temp9  = C[25 + j*lda];
         temp10 = C[26 + j*lda];
         temp11 = C[27 + j*lda];
         temp12 = C[28 + j*lda];
         temp13 = C[29 + j*lda];
         temp14 = C[30 + j*lda];
         temp15 = C[31 + j*lda];
         for(k = 0; k < 32; k++) {
            temp0  += A[j*lda + k] * B[16 + k*lda];
            temp1  += A[j*lda + k] * B[17 + k*lda];
            temp2  += A[j*lda + k] * B[18 + k*lda];
            temp3  += A[j*lda + k] * B[19 + k*lda];
            temp4  += A[j*lda + k] * B[20 + k*lda];
            temp5  += A[j*lda + k] * B[21 + k*lda];
            temp6  += A[j*lda + k] * B[22 + k*lda];
            temp7  += A[j*lda + k] * B[23 + k*lda];
            temp8  += A[j*lda + k] * B[24 + k*lda];
            temp9  += A[j*lda + k] * B[25 + k*lda];
            temp10 += A[j*lda + k] * B[26 + k*lda];
            temp11 += A[j*lda + k] * B[27 + k*lda];
            temp12 += A[j*lda + k] * B[28 + k*lda];
            temp13 += A[j*lda + k] * B[29 + k*lda];
            temp14 += A[j*lda + k] * B[30 + k*lda];
            temp15 += A[j*lda + k] * B[31 + k*lda];
         }
         C[16 + j*lda] = temp0;
         C[17 + j*lda] = temp1;
         C[18 + j*lda] = temp2;
         C[19 + j*lda] = temp3;
         C[20 + j*lda] = temp4;
         C[21 + j*lda] = temp5;
         C[22 + j*lda] = temp6;
         C[23 + j*lda] = temp7;
         C[24 + j*lda] = temp8;
         C[25 + j*lda] = temp9;
         C[26 + j*lda] = temp10;
         C[27 + j*lda] = temp11;
         C[28 + j*lda] = temp12;
         C[29 + j*lda] = temp13;
         C[30 + j*lda] = temp14;
         C[31 + j*lda] = temp15;
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


//   // Execute the provided, naive matmul
//   barrier();
//   stats(matmul_naive(DIM_SIZE, input1_data, input2_data, results_data); barrier());
// 
//   
//   // verify
//   verify(ARRAY_SIZE, results_data, verify_data);
//   
//   // clear results from the first trial
//   size_t i;
//   if (coreid == 0) 
//      for (i=0; i < ARRAY_SIZE; i++)
//         results_data[i] = 0;
//   barrier();

   
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

