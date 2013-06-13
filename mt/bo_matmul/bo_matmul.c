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

void __attribute__((noinline)) matmul_MI_transpose(const int lda,  const data_t A[], const data_t B[], data_t C[] )
{
    int i, j, k;
    data_t B_trans[32*32];
    data_t acc_temp0, acc_temp1;
    data_t *A_j, *B_i;
    data_t *A_j_k, *B_i_k;
    int z;

    //for (i = 0; i < 32; i++) {
    //    for (j = 0; j < 32; j++) {
    //        B_trans[i*lda+j] = B[i+j*lda];
    //    }
    //}

    if (coreid == 0) {
        for (i = 0; i < 32; i++) {
            B_i = B_trans+i*32;
            for (z = 0; z < 32; z++) {
                *(B_i+z) = B[i+z*32];
            }
            for (j = 0; j < 16; j+=2) {
                A_j = A+j*lda;
                acc_temp0 = 0;
                for (k = 0; k < 32; k+=8) {
                    A_j_k = A_j+k;
                    B_i_k = B_i+k;
                    acc_temp0 += *(A_j_k)     * *(B_i_k);
                    acc_temp0 += *(A_j_k + 1) * *(B_i_k + 1);
                    acc_temp0 += *(A_j_k + 2) * *(B_i_k + 2);
                    acc_temp0 += *(A_j_k + 3) * *(B_i_k + 3);
                    acc_temp0 += *(A_j_k + 4) * *(B_i_k + 4);
                    acc_temp0 += *(A_j_k + 5) * *(B_i_k + 5);
                    acc_temp0 += *(A_j_k + 6) * *(B_i_k + 6);
                    acc_temp0 += *(A_j_k + 7) * *(B_i_k + 7);
                }
                A_j += 32;

                acc_temp1 = 0;
                for (k = 0; k < 32; k+=8) {
                    acc_temp1 += *(A_j+k) * *(B_i+k);
                    acc_temp1 += *(A_j+k + 1) * *(B_i+k + 1);
                    acc_temp1 += *(A_j+k + 2) * *(B_i+k + 2);
                    acc_temp1 += *(A_j+k + 3) * *(B_i+k + 3);
                    acc_temp1 += *(A_j+k + 4) * *(B_i+k + 4);
                    acc_temp1 += *(A_j+k + 5) * *(B_i+k + 5);
                    acc_temp1 += *(A_j+k + 6) * *(B_i+k + 6);
                    acc_temp1 += *(A_j+k + 7) * *(B_i+k + 7);
                }

                C[i + j*lda] = acc_temp0;
                C[i + (j+1)*lda] = acc_temp1;
            }
        }
    } else if (coreid == 1) {
        for (i = 0; i < 32; i++) {
            B_i = B_trans+i*32;
            for (z = 0; z < 32; z++) {
                *(B_i+z) = B[i+z*32];
            }
            for (j = 16; j < 32; j+=2) {
                A_j = A+j*lda;
                acc_temp0 = 0;
                for (k = 0; k < 32; k+=8) {
                    acc_temp0 += *(A_j+k) * *(B_i+k);
                    acc_temp0 += *(A_j+k + 1) * *(B_i+k + 1);
                    acc_temp0 += *(A_j+k + 2) * *(B_i+k + 2);
                    acc_temp0 += *(A_j+k + 3) * *(B_i+k + 3);
                    acc_temp0 += *(A_j+k + 4) * *(B_i+k + 4);
                    acc_temp0 += *(A_j+k + 5) * *(B_i+k + 5);
                    acc_temp0 += *(A_j+k + 6) * *(B_i+k + 6);
                    acc_temp0 += *(A_j+k + 7) * *(B_i+k + 7);
                }
                A_j += 32;

                acc_temp1 = 0;
                for (k = 0; k < 32; k+=8) {
                    acc_temp1 += *(A_j+k) * *(B_i+k);
                    acc_temp1 += *(A_j+k + 1) * *(B_i+k + 1);
                    acc_temp1 += *(A_j+k + 2) * *(B_i+k + 2);
                    acc_temp1 += *(A_j+k + 3) * *(B_i+k + 3);
                    acc_temp1 += *(A_j+k + 4) * *(B_i+k + 4);
                    acc_temp1 += *(A_j+k + 5) * *(B_i+k + 5);
                    acc_temp1 += *(A_j+k + 6) * *(B_i+k + 6);
                    acc_temp1 += *(A_j+k + 7) * *(B_i+k + 7);
                }
                C[i + j*lda] = acc_temp0;
                C[i + (j+1)*lda] = acc_temp1;
            }
        }
    }
}
 
void __attribute__((noinline)) matmul_MI(const int lda,  const data_t A[], const data_t B[], data_t C[] )
{
    int i, j, k;
    data_t acc_temp;
    data_t *A_j, *B_i;
    int j_start = coreid*16;
    int j_end = (coreid*16)+16;
    if (coreid == 0) {
        for ( i = 0; i < 32; i++ ) {
            B_i = B + i;
            for ( j = j_start; j < j_end; j++ )  
            {
                acc_temp = 0;
                A_j = A + j*32;
                for ( k = 0; k < 32; k++ ) 
                {
                    acc_temp += *(A_j + k) * *(B_i + k*32);
                }
                C[i + j*32] = acc_temp;
            }
        }
    } else if (coreid == 1) {
        for ( i = 16; i < 32; i++ ) {
            B_i = B + i;
            for ( j = j_start; j < j_end; j++ )  
            {
                acc_temp = 0;
                A_j = A + j*32;
                for ( k = 0; k < 32; k+=4 ) 
                {
                    acc_temp += *(A_j + k) * *(B_i + k*32);
                    acc_temp += *(A_j + k + 1) * *(B_i + (k+1)*32);
                    acc_temp += *(A_j + k + 2) * *(B_i + (k+2)*32);
                    acc_temp += *(A_j + k + 3) * *(B_i + (k+3)*32);
                }
                C[i + j*32] = acc_temp;
            }
        }
        for ( i = 0; i < 16; i++ ) {
            B_i = B + i;
            for ( j = j_start; j < j_end; j++ )  
            {
                acc_temp = 0;
                A_j = A + j*32;
                for ( k = 0; k < 32; k+=4 ) 
                {
                    acc_temp += *(A_j + k) * *(B_i + k*32);
                    acc_temp += *(A_j + k + 1) * *(B_i + (k+1)*32);
                    acc_temp += *(A_j + k + 2) * *(B_i + (k+2)*32);
                    acc_temp += *(A_j + k + 3) * *(B_i + (k+3)*32);
                }
                C[i + j*32] = acc_temp;
            }
        }

    }
}

void __attribute__((noinline)) matmul_MSI(const int lda,  const data_t A[], const data_t B[], data_t C[] )
{
    int i, j, k;
    data_t acc_temp;
    data_t *A_j, *B_i;
    int j_start = coreid*16;
    int j_end = (coreid*16)+16;
    for ( i = 0; i < 32; i++ ) {
        B_i = B + i;
        for ( j = j_start; j < j_end; j++ )  
        {
            acc_temp = 0;
            A_j = A + j*32;
            for ( k = 0; k < 32; k++ ) 
            {
                acc_temp += *(A_j + k) * *(B_i + k*32);
            }
            C[i + j*32] = acc_temp;
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
    // ENABLE_SHARING = false is MI
    // ENABLE_SHARING = true is MSI
    matmul_MI_transpose(lda, A, B, C);
    //matmul_MSI(lda, A, B, C);
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
//   //stats(matmul_naive(DIM_SIZE, input1_data, input2_data, results_data); barrier());
// 
//   
//   // verify
//   //verify(ARRAY_SIZE, results_data, verify_data);
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

