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
   
	data_t a1;
	data_t a2;
	data_t a3;
	data_t a4;
	data_t a5;
	data_t a6;
	data_t a7;
	data_t a8;
	data_t *b1;
	data_t *b2;
	data_t *b3;
	data_t *b4;
	data_t *b5;
	data_t *b6;
	data_t *b7;
	data_t *b8;
	data_t c1;
	data_t c2;
	data_t c3;
	data_t c4;
	data_t c5;
	data_t c6;
	data_t c7;
	data_t c8;
	int i, j, k;
	int start, end;
        static data_t BB[1024];


        //transpose B
        if (coreid == 0 | coreid == 1 ) {
                for ( k = 0; k < lda; k++) {
                        for ( i = coreid*(lda/2); i < (coreid+1)*(lda/2); i++ )  {
                                BB[i*lda + k] = B[k*lda + i];
                        }
                }
        }
        barrier();

	for ( int x = 0; x < ncores; x++) {
		//split the i values into two chunks so the threads don't interfere on the B loads
		//this could be generalized if needed, but I won't bother since it would be tricky
		//and we already know the size and numthreads
		start = coreid == x ? 0 : 16;
		end = coreid == x ? 16 : 32;
		for ( i = start; i < end; i+=8 ) { 
			for ( j = coreid*(lda/ncores); j < (coreid+1)*(lda/ncores); j++ )  {
				c1=0;c2=0;c3=0;c4=0;c5=0;c6=0;c7=0;c8=0;
			        b1 = &BB[(i+0)*lda];
				b2 = &BB[(i+1)*lda];
				b3 = &BB[(i+2)*lda];
				b4 = &BB[(i+3)*lda];
			        b5 = &BB[(i+4)*lda];
				b6 = &BB[(i+5)*lda];
				b7 = &BB[(i+6)*lda];
				b8 = &BB[(i+7)*lda];

				for ( k = 0; k < lda; k+=8 ) {
					a1 = A[j*lda + k+0];
					a2 = A[j*lda + k+1];
					a3 = A[j*lda + k+2];
					a4 = A[j*lda + k+3];
					a5 = A[j*lda + k+4];
					a6 = A[j*lda + k+5];
					a7 = A[j*lda + k+6];
					a8 = A[j*lda + k+7];

					c1 += a1 * b1[k+0];
					c1 += a2 * b1[k+1];
					c1 += a3 * b1[k+2];
					c1 += a4 * b1[k+3];
					c1 += a5 * b1[k+4];
					c1 += a6 * b1[k+5];
					c1 += a7 * b1[k+6];
					c1 += a8 * b1[k+7];

					c2 += a1 * b2[k+0];
					c2 += a2 * b2[k+1];
					c2 += a3 * b2[k+2];
					c2 += a4 * b2[k+3];
					c2 += a5 * b2[k+4];
					c2 += a6 * b2[k+5];
					c2 += a7 * b2[k+6];
					c2 += a8 * b2[k+7];

					c3 += a1 * b3[k+0];
					c3 += a2 * b3[k+1];
					c3 += a3 * b3[k+2];
					c3 += a4 * b3[k+3];
					c3 += a5 * b3[k+4];
					c3 += a6 * b3[k+5];
					c3 += a7 * b3[k+6];
					c3 += a8 * b3[k+7];

					c4 += a1 * b4[k+0];
					c4 += a2 * b4[k+1];
					c4 += a3 * b4[k+2];
					c4 += a4 * b4[k+3];
					c4 += a5 * b4[k+4];
					c4 += a6 * b4[k+5];
					c4 += a7 * b4[k+6];
					c4 += a8 * b4[k+7];

					c5 += a1 * b5[k+0];
					c5 += a2 * b5[k+1];
					c5 += a3 * b5[k+2];
					c5 += a4 * b5[k+3];
					c5 += a5 * b5[k+4];
					c5 += a6 * b5[k+5];
					c5 += a7 * b5[k+6];
					c5 += a8 * b5[k+7];

					c6 += a1 * b6[k+0];
					c6 += a2 * b6[k+1];
					c6 += a3 * b6[k+2];
					c6 += a4 * b6[k+3];
					c6 += a5 * b6[k+4];
					c6 += a6 * b6[k+5];
					c6 += a7 * b6[k+6];
					c6 += a8 * b6[k+7];

					c7 += a1 * b7[k+0];
					c7 += a2 * b7[k+1];
					c7 += a3 * b7[k+2];
					c7 += a4 * b7[k+3];
					c7 += a5 * b7[k+4];
					c7 += a6 * b7[k+5];
					c7 += a7 * b7[k+6];
					c7 += a8 * b7[k+7];

					c8 += a1 * b8[k+0];
					c8 += a2 * b8[k+1];
					c8 += a3 * b8[k+2];
					c8 += a4 * b8[k+3];
					c8 += a5 * b8[k+4];
					c8 += a6 * b8[k+5];
					c8 += a7 * b8[k+6];
					c8 += a8 * b8[k+7];
				}
				C[i+0 + j*lda] += c1;
				C[i+1 + j*lda] += c2;
				C[i+2 + j*lda] += c3;
				C[i+3 + j*lda] += c4;
				C[i+4 + j*lda] += c5;
				C[i+5 + j*lda] += c6;
				C[i+6 + j*lda] += c7;
				C[i+7 + j*lda] += c8;
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

/*
   // Execute the provided, naive matmul
   barrier();
   stats(matmul_naive(DIM_SIZE, input1_data, input2_data, results_data); barrier());
 
   
   // verify
   verify(ARRAY_SIZE, results_data, verify_data);
   
   // clear results from the first trial
   size_t i;
   if (coreid == 0) 
      for (i=0; i < ARRAY_SIZE; i++)
         results_data[i] = 0;
   barrier();
*/

   
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

