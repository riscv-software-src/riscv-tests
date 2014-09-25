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
    
void printArrayMT( char name[], int n, data_t arr[] )
{
   int i;
   if (coreid != 0)
      return;
  
   printf( " %10s :", name );
   for ( i = 0; i < n; i++ )
      printf( " %3ld ", (long) arr[i] );
   printf( "\n" );
}
      
void __attribute__((noinline)) verifyMT(size_t n, const data_t* test, const data_t* correct)
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
/*
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
*/
}
 


void __attribute__((noinline)) matmul(const int lda,  const data_t A[], const data_t B[], data_t C[] )
{
	size_t c_start = lda / ncores * coreid;
	size_t c_row;
	size_t c_col;
	size_t colSplit = 0;
	size_t i;
	size_t useSplit = 0;
	data_t a1;
	data_t a2;
	data_t a3;
	data_t a4;
	data_t a5;	
	data_t a6;
	data_t a7;
	data_t a8;
	data_t c1;
	data_t c2;
	data_t c3;
	data_t c4;
	data_t c5;
	data_t c6;
	data_t c7;
	data_t c8;
	size_t block;
	for (block = 0; block < 2; block++) {	
		for (colSplit = 0; colSplit < 4; colSplit++) {
			useSplit = (coreid == 0) ? colSplit : (colSplit + 2 ) % 4;
			for (c_row = c_start + block * 8; c_row < c_start + block * 8 + 8; c_row += 2) {
				for (c_col = 0; c_col < lda; c_col+=4) {
					c1 = C[c_row*lda+c_col];
					c2 = C[(c_row+1)*lda+c_col];
					c3 = C[c_row*lda+c_col+1];
					c4 = C[(c_row+1)*lda+c_col+1];
					c5 = C[c_row*lda+c_col+2];
					c6 = C[(c_row+1)*lda+c_col+2];
					c7 = C[c_row*lda+c_col+3];
					c8 = C[(c_row+1)*lda+c_col+3];
					for (i = useSplit * lda / 4; i < (useSplit + 1) * lda / 4; i+=4) {
						a1 = A[c_row*lda+i];
						a2 = A[(c_row+1)*lda+i];
						a3 = A[c_row*lda+i+1];
						a4 = A[(c_row+1)*lda+i+1];
						a5 = A[c_row*lda+i+2];
						a6 = A[(c_row+1)*lda+i+2];
						a7 = A[c_row*lda+i+3];
						a8 = A[(c_row+1)*lda+i+3];

						c1 += a1 * B[i*lda+c_col];
						c2 += a2 * B[i*lda+c_col];

						c1 += a3 * B[(i+1)*lda+c_col];
						c2 += a4 * B[(i+1)*lda+c_col];

						c1 += a5 * B[(i+2)*lda+c_col];
						c2 += a6 * B[(i+2)*lda+c_col];

						c1 += a7 * B[(i+3)*lda+c_col];
						c2 += a8 * B[(i+3)*lda+c_col];

						c3 += a1 * B[i*lda+c_col+1];
						c4 += a2 * B[i*lda+c_col+1];

						c3 += a3 * B[(i+1)*lda+c_col+1];
						c4 += a4 * B[(i+1)*lda+c_col+1];

						c3 += a5 * B[(i+2)*lda+c_col+1];
						c4 += a6 * B[(i+2)*lda+c_col+1];

						c3 += a7 * B[(i+3)*lda+c_col+1];
						c4 += a8 * B[(i+3)*lda+c_col+1];

						c5 += a1 * B[i*lda+c_col+2];
						c6 += a2 * B[i*lda+c_col+2];

						c5 += a3 * B[(i+1)*lda+c_col+2];
						c6 += a4 * B[(i+1)*lda+c_col+2];

						c5 += a5 * B[(i+2)*lda+c_col+2];
						c6 += a6 * B[(i+2)*lda+c_col+2];

						c5 += a7 * B[(i+3)*lda+c_col+2];
						c6 += a8 * B[(i+3)*lda+c_col+2];

						c7 += a1 * B[i*lda+c_col+3];
						c8 += a2 * B[i*lda+c_col+3];

						c7 += a3 * B[(i+1)*lda+c_col+3];
						c8 += a4 * B[(i+1)*lda+c_col+3];

						c7 += a5 * B[(i+2)*lda+c_col+3];
						c8 += a6 * B[(i+2)*lda+c_col+3];

						c7 += a7 * B[(i+3)*lda+c_col+3];
						c8 += a8 * B[(i+3)*lda+c_col+3];
					}

					C[c_row*lda+c_col] = c1;
					C[(c_row+1)*lda+c_col] = c2;

					C[c_row*lda+c_col+1] = c3;
					C[(c_row+1)*lda+c_col+1] = c4;

					C[c_row*lda+c_col+2] = c5;
					C[(c_row+1)*lda+c_col+2] = c6;

					C[c_row*lda+c_col+3] = c7;
					C[(c_row+1)*lda+c_col+3] = c8;
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


   // Execute the provided, naive matmul
//   barrier(nc);
//   stats(matmul_naive(DIM_SIZE, input1_data, input2_data, results_data); barrier(nc));
 
   
   // verify
//   verifyMT(ARRAY_SIZE, results_data, verify_data);
   
   // clear results from the first trial
//   size_t i;
//   if (coreid == 0) 
//      for (i=0; i < ARRAY_SIZE; i++)
//         results_data[i] = 0;
//   barrier(nc);

   
   // Execute your faster matmul
   barrier(nc);
   stats(matmul(DIM_SIZE, input1_data, input2_data, results_data); barrier(nc));
 
#ifdef DEBUG
   printArrayMT("results:", ARRAY_SIZE, results_data);
   printArrayMT("verify :", ARRAY_SIZE, verify_data);
#endif
   
   // verify
   verifyMT(ARRAY_SIZE, results_data, verify_data);
   barrier(nc);

   exit(0);
}

