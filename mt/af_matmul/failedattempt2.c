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
  size_t i;
	size_t i2;
  size_t j;
	size_t j2;
	size_t k;
	size_t k2;
  size_t max_dim = lda*lda;
	size_t block_size = lda/2;
	int result = 0;
	data_t temp_mat1[32] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
	if (coreid == 0) {
		for (k = 0; k < lda/2; k++) {
			int columnIndex = 32*k;

			//temp_mat1 will store the kth column of B
			for (i = 0; i < lda; i++) {
				temp_mat1[i] = B[32*i + k];
			}
			
			for (j =0; j < lda; j++) {
				int rowIndex = 32*j;
				//iterate through each element of A in row J and accumulate result
				for (i2 = 0; i2 <lda; i2 += 4) {
					int elementA = A[rowIndex+i2];
					int elementA2 = A[rowIndex+i2+1];
					int elementA3 = A[rowIndex+i2+2];
					int elementA4 = A[rowIndex+i2+3];
					result += elementA*temp_mat1[i2] + elementA2*temp_mat1[i2+1] + elementA3*temp_mat1[i2+2] + elementA4*temp_mat1[i2+3] ;
				}
				C[k+rowIndex] = result;
				result = 0;
			}

		}
	} else {
	 	for (k = lda/2; k < lda; k++) {
			int columnIndex = 32*k;

			//temp_mat1 will store the kth column of B
			for (i = 0; i < lda; i++) {
				temp_mat1[i] = B[32*i + k];
			}
			
			for (j =0; j < lda; j++) {
				int rowIndex = 32*j;
				//iterate through each element of A in row J and accumulate result
				for (i2 = 0; i2 <lda; i2 += 4) {
					int elementA = A[rowIndex+i2];
					int elementA2 = A[rowIndex+i2+1];
					int elementA3 = A[rowIndex+i2+2];
					int elementA4 = A[rowIndex+i2+3];
					result += elementA*temp_mat1[i2] + elementA2*temp_mat1[i2+1] + elementA3*temp_mat1[i2+2] + elementA4*temp_mat1[i2+3] ;
				}
				C[k+rowIndex] = result;
				result = 0;
			}

		}
		 
	}

 
      
   
   // ***************************** //
   // **** ADD YOUR CODE HERE ***** //
   // ***************************** //
   //
   // feel free to make a separate function for MI and MSI versions.
 
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
