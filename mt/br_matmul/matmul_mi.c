//**************************************************************************
// Multi-threaded Matrix Multiply benchmark
//--------------------------------------------------------------------------
// TA     : Christopher Celio
// Student: Benjamin Han
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
#define stats(code) do {						\
    unsigned long _c = -rdcycle(), _i = -rdinstret();			\
    code;								\
    _c += rdcycle(), _i += rdinstret();					\
    if (coreid == 0)							\
      printf("%s: %ld cycles, %ld.%ld cycles/iter, %ld.%ld CPI\n",	\
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
  int j2, i2, k2, j, i, k; 
  int tmpC00, tmpC01, tmpC02, tmpC03, tmpC04, tmpC05, tmpC06, tmpC07;
  int tmpC10, tmpC11, tmpC12, tmpC13, tmpC14, tmpC15, tmpC16, tmpC17;
  int jBLOCK = 32;
  int iBLOCK = 16;
  int kBLOCK = 32;
  static __thread int tB[4096]; //__thread
  int startInd = 0;
  int endInd = lda >> 1;
  if (coreid == 1) {
    startInd = lda >> 1;
    endInd = lda;
  }    

  //tranpose B (block?)
  for (i = 0; i < lda; i += 2) {
    for (j = startInd; j < endInd; j += 2) {
      tB[j*lda + i] = B[i*lda + j];
      tB[(j + 1)*lda + i] = B[i*lda + j + 1];
      tB[j*lda + i + 1] = B[(i + 1)*lda + j];
      tB[(j + 1)*lda + i + 1] = B[(i + 1)*lda + j + 1];
    }
  }
  barrier();

  // compute C[j*n + i] += A[j*n + k] + Btranspose[i*n + k]
  for ( j2 = 0; j2 < lda; j2 += jBLOCK )
    for ( i2 = startInd; i2 < endInd; i2 += iBLOCK )
      for ( j = j2; j < j2 + jBLOCK; j += 2 ) 
	for ( k2 = 0; k2 < lda; k2 += kBLOCK )
	  for ( i = i2; i < i2 + iBLOCK; i += 4) {
	    tmpC00 = C[j*lda + i + 0]; tmpC10 = C[(j + 1)*lda + i + 0];
	    tmpC01 = C[j*lda + i + 1]; tmpC11 = C[(j + 1)*lda + i + 1];
	    tmpC02 = C[j*lda + i + 2]; tmpC12 = C[(j + 1)*lda + i + 2];
	    tmpC03 = C[j*lda + i + 3]; tmpC13 = C[(j + 1)*lda + i + 3];
	    //tmpC04 = C[j*lda + i + 4]; tmpC14 = C[(j + 1)*lda + i + 4];
	    //tmpC05 = C[j*lda + i + 5]; tmpC15 = C[(j + 1)*lda + i + 5];
	    //tmpC06 = C[j*lda + i + 6]; tmpC16 = C[(j + 1)*lda + i + 6];
	    //tmpC07 = C[j*lda + i + 7]; tmpC17 = C[(j + 1)*lda + i + 7];
	    for ( k = k2; k < k2 + kBLOCK; k += 4) {
	      tmpC00 += A[j*lda + k] * tB[(i + 0)*lda + k]; 
	      tmpC01 += A[j*lda + k] * tB[(i + 1)*lda + k]; 
	      tmpC02 += A[j*lda + k] * tB[(i + 2)*lda + k]; 
	      tmpC03 += A[j*lda + k] * tB[(i + 3)*lda + k]; 
	      //tmpC04 += A[j*lda + k] * tB[(i + 4)*lda + k]; 
	      //tmpC05 += A[j*lda + k] * tB[(i + 5)*lda + k]; 
	      //tmpC06 += A[j*lda + k] * tB[(i + 6)*lda + k]; 
	      //tmpC07 += A[j*lda + k] * tB[(i + 7)*lda + k]; 
	      tmpC10 += A[(j + 1)*lda + k] * tB[(i + 0)*lda + k]; 
	      tmpC11 += A[(j + 1)*lda + k] * tB[(i + 1)*lda + k]; 
	      tmpC12 += A[(j + 1)*lda + k] * tB[(i + 2)*lda + k]; 
	      tmpC13 += A[(j + 1)*lda + k] * tB[(i + 3)*lda + k]; 
	      //tmpC14 += A[(j + 1)*lda + k] * tB[(i + 4)*lda + k]; 
	      //tmpC15 += A[(j + 1)*lda + k] * tB[(i + 5)*lda + k]; 
	      //tmpC16 += A[(j + 1)*lda + k] * tB[(i + 6)*lda + k]; 
	      //tmpC17 += A[(j + 1)*lda + k] * tB[(i + 7)*lda + k]; 

	      tmpC00 += A[j*lda + k + 1] * tB[(i + 0)*lda + k + 1];
	      tmpC01 += A[j*lda + k + 1] * tB[(i + 1)*lda + k + 1];
	      tmpC02 += A[j*lda + k + 1] * tB[(i + 2)*lda + k + 1];
	      tmpC03 += A[j*lda + k + 1] * tB[(i + 3)*lda + k + 1];
	      //tmpC04 += A[j*lda + k + 1] * tB[(i + 4)*lda + k + 1];
	      //tmpC05 += A[j*lda + k + 1] * tB[(i + 5)*lda + k + 1];
	      //tmpC06 += A[j*lda + k + 1] * tB[(i + 6)*lda + k + 1];
	      //tmpC07 += A[j*lda + k + 1] * tB[(i + 7)*lda + k + 1];
	      tmpC10 += A[(j + 1)*lda + k + 1] * tB[(i + 0)*lda + k + 1];
	      tmpC11 += A[(j + 1)*lda + k + 1] * tB[(i + 1)*lda + k + 1];
	      tmpC12 += A[(j + 1)*lda + k + 1] * tB[(i + 2)*lda + k + 1];
	      tmpC13 += A[(j + 1)*lda + k + 1] * tB[(i + 3)*lda + k + 1];
	      //tmpC14 += A[(j + 1)*lda + k + 1] * tB[(i + 4)*lda + k + 1];
	      //tmpC15 += A[(j + 1)*lda + k + 1] * tB[(i + 5)*lda + k + 1];
	      //tmpC16 += A[(j + 1)*lda + k + 1] * tB[(i + 6)*lda + k + 1];
	      //tmpC17 += A[(j + 1)*lda + k + 1] * tB[(i + 7)*lda + k + 1];

	      tmpC00 += A[j*lda + k + 2] * tB[(i + 0)*lda + k + 2]; 
	      tmpC01 += A[j*lda + k + 2] * tB[(i + 1)*lda + k + 2]; 
	      tmpC02 += A[j*lda + k + 2] * tB[(i + 2)*lda + k + 2]; 
	      tmpC03 += A[j*lda + k + 2] * tB[(i + 3)*lda + k + 2]; 
	      //tmpC04 += A[j*lda + k + 2] * tB[(i + 4)*lda + k + 2]; 
	      //tmpC05 += A[j*lda + k + 2] * tB[(i + 5)*lda + k + 2]; 
	      //tmpC06 += A[j*lda + k + 2] * tB[(i + 6)*lda + k + 2]; 
	      //tmpC07 += A[j*lda + k + 2] * tB[(i + 7)*lda + k + 2]; 
	      tmpC10 += A[(j + 1)*lda + k + 2] * tB[(i + 0)*lda + k + 2]; 
	      tmpC11 += A[(j + 1)*lda + k + 2] * tB[(i + 1)*lda + k + 2]; 
	      tmpC12 += A[(j + 1)*lda + k + 2] * tB[(i + 2)*lda + k + 2]; 
	      tmpC13 += A[(j + 1)*lda + k + 2] * tB[(i + 3)*lda + k + 2]; 
	      //tmpC14 += A[(j + 1)*lda + k + 2] * tB[(i + 4)*lda + k + 2]; 
	      //tmpC15 += A[(j + 1)*lda + k + 2] * tB[(i + 5)*lda + k + 2]; 
	      //tmpC16 += A[(j + 1)*lda + k + 2] * tB[(i + 6)*lda + k + 2]; 
	      //tmpC17 += A[(j + 1)*lda + k + 2] * tB[(i + 7)*lda + k + 2]; 

	      tmpC00 += A[j*lda + k + 3] * tB[(i + 0)*lda + k + 3];
	      tmpC01 += A[j*lda + k + 3] * tB[(i + 1)*lda + k + 3];
	      tmpC02 += A[j*lda + k + 3] * tB[(i + 2)*lda + k + 3];
	      tmpC03 += A[j*lda + k + 3] * tB[(i + 3)*lda + k + 3];
	      //tmpC04 += A[j*lda + k + 3] * tB[(i + 4)*lda + k + 3];
	      //tmpC05 += A[j*lda + k + 3] * tB[(i + 5)*lda + k + 3];
	      //tmpC06 += A[j*lda + k + 3] * tB[(i + 6)*lda + k + 3];
	      //tmpC07 += A[j*lda + k + 3] * tB[(i + 7)*lda + k + 3]; 
	      tmpC10 += A[(j + 1)*lda + k + 3] * tB[(i + 0)*lda + k + 3];
	      tmpC11 += A[(j + 1)*lda + k + 3] * tB[(i + 1)*lda + k + 3];
	      tmpC12 += A[(j + 1)*lda + k + 3] * tB[(i + 2)*lda + k + 3];
	      tmpC13 += A[(j + 1)*lda + k + 3] * tB[(i + 3)*lda + k + 3];
	      //tmpC14 += A[(j + 1)*lda + k + 3] * tB[(i + 4)*lda + k + 3];
	      //tmpC15 += A[(j + 1)*lda + k + 3] * tB[(i + 5)*lda + k + 3];
	      //tmpC16 += A[(j + 1)*lda + k + 3] * tB[(i + 6)*lda + k + 3];
	      //tmpC17 += A[(j + 1)*lda + k + 3] * tB[(i + 7)*lda + k + 3];
	    }
	    C[j*lda + i + 0] = tmpC00; C[(j + 1)*lda + i + 0] = tmpC10; 
	    C[j*lda + i + 1] = tmpC01; C[(j + 1)*lda + i + 1] = tmpC11; 
	    C[j*lda + i + 2] = tmpC02; C[(j + 1)*lda + i + 2] = tmpC12; 
	    C[j*lda + i + 3] = tmpC03; C[(j + 1)*lda + i + 3] = tmpC13; 
	    //C[j*lda + i + 4] = tmpC04; C[(j + 1)*lda + i + 4] = tmpC14; 
	    //C[j*lda + i + 5] = tmpC05; C[(j + 1)*lda + i + 5] = tmpC15; 
	    //C[j*lda + i + 6] = tmpC06; C[(j + 1)*lda + i + 6] = tmpC16; 
	    //C[j*lda + i + 7] = tmpC07; C[(j + 1)*lda + i + 7] = tmpC17; 
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


//  // Execute the provided, naive matmul
//  barrier();
//  stats(matmul_naive(DIM_SIZE, input1_data, input2_data, results_data); barrier());
// 
//   
//  // verify
//  verify(ARRAY_SIZE, results_data, verify_data);
//   
//  // clear results from the first trial
//  size_t i;
//  if (coreid == 0) 
//    for (i=0; i < ARRAY_SIZE; i++)
//      results_data[i] = 0;
//  barrier();

   
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

