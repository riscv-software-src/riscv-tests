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
   
   // ***************************** //
   // **** ADD YOUR CODE HERE ***** //
   // ***************************** //
   //
   // feel free to make a separate function for MI and MSI versions.

    int m, i, j, k, iB0, iB1;
    data_t tempC0, tempC1, tempC2, tempC3, tempC4, tempC5, tempC6, tempC7;
    data_t tempA0, tempA1;
  
    if (coreid == 0){
        for (m = 0; m < 2; m++){
            for (j = 0; j < lda/2; j++){
                for (i = 0; i < lda; i+=8){
                    tempC0 = C[i + j*lda];
                    tempC1 = C[i + j*lda+1];
                    tempC2 = C[i + j*lda+2];
                    tempC3 = C[i + j*lda+3];
                    tempC4 = C[i + j*lda+4];
                    tempC5 = C[i + j*lda+5];
                    tempC6 = C[i + j*lda+6];
                    tempC7 = C[i + j*lda+7];
                    iB0 = m*lda*lda/2+i;
                    iB1 = iB0+lda;
                    for (k = m*lda/2; k < (m+1)*lda/2; k+=2){
                        tempA0 = A[j*lda+k];
                        tempA1 = A[j*lda+k+1];
                        tempC0 += tempA0*B[iB0]+tempA1*B[iB1];
                        tempC1 += tempA0*B[iB0+1]+tempA1*B[iB1+1];
                        tempC2 += tempA0*B[iB0+2]+tempA1*B[iB1+2];
                        tempC3 += tempA0*B[iB0+3]+tempA1*B[iB1+3];
                        tempC4 += tempA0*B[iB0+4]+tempA1*B[iB1+4];
                        tempC5 += tempA0*B[iB0+5]+tempA1*B[iB1+5];
                        tempC6 += tempA0*B[iB0+6]+tempA1*B[iB1+6];
                        tempC7 += tempA0*B[iB0+7]+tempA1*B[iB1+7];
                        iB0 += 2*lda;
                        iB1 += 2*lda;
                        
                    }
                    C[i + j*lda] = tempC0;
                    C[i + j*lda + 1] = tempC1;
                    C[i + j*lda + 2] = tempC2;
                    C[i + j*lda + 3] = tempC3;
                    C[i + j*lda + 4] = tempC4;
                    C[i + j*lda + 5] = tempC5;
                    C[i + j*lda + 6] = tempC6;
                    C[i + j*lda + 7] = tempC7;
                }
            }
        }
    } else {
        for (m = 2; m > 0; m--){
            for (j = lda-1; j >= lda/2; j--){
                for (i = lda-1; i >= 0; i-=8){
                    tempC0 = C[i + j*lda];
                    tempC1 = C[i + j*lda - 1];
                    tempC2 = C[i + j*lda - 2];
                    tempC3 = C[i + j*lda - 3];
                    tempC4 = C[i + j*lda - 4];
                    tempC5 = C[i + j*lda - 5];
                    tempC6 = C[i + j*lda - 6];
                    tempC7 = C[i + j*lda - 7];
                    for (k = m*lda/2-1; k >= (m-1)*lda/2; k-=2){
                        tempA0 = A[j*lda+k];
                        tempA1 = A[j*lda+k-1];
                        tempC0 += tempA0*B[k*lda+i]+tempA1*B[(k-1)*lda+i];
                        tempC1 += tempA0*B[k*lda+i-1]+tempA1*B[(k-1)*lda+i-1];
                        tempC2 += tempA0*B[k*lda+i-2]+tempA1*B[(k-1)*lda+i-2];
                        tempC3 += tempA0*B[k*lda+i-3]+tempA1*B[(k-1)*lda+i-3];
                        tempC4 += tempA0*B[k*lda+i-4]+tempA1*B[(k-1)*lda+i-4];
                        tempC5 += tempA0*B[k*lda+i-5]+tempA1*B[(k-1)*lda+i-5];
                        tempC6 += tempA0*B[k*lda+i-6]+tempA1*B[(k-1)*lda+i-6];
                        tempC7 += tempA0*B[k*lda+i-7]+tempA1*B[(k-1)*lda+i-7];
                    }
                    C[i + j*lda] = tempC0;
                    C[i + j*lda - 1] = tempC1;
                    C[i + j*lda - 2] = tempC2;
                    C[i + j*lda - 3] = tempC3;
                    C[i + j*lda - 4] = tempC4;
                    C[i + j*lda - 5] = tempC5;
                    C[i + j*lda - 6] = tempC6;
                    C[i + j*lda - 7] = tempC7;
                }
            }
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

