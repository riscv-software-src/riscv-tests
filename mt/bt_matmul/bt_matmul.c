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
  
	  int i, j, k , jj , kk;
		int start_i = coreid*lda/2;
		int end_i = start_i + lda/2;
		int step_j, step_k;
		int start_k, end_k, start_j, end_j;
		int j_lda;
		int pos_A , pos_B, pos_C;
		data_t temp00, temp01,temp02,temp03,temp04,temp05,temp06,temp07;
		data_t temp10, temp11,temp12,temp13,temp14,temp15,temp16,temp17;
		data_t temp_A0, temp_A1, temp_A2, temp_A3, temp_A4, temp_A5, temp_A6, temp_A7;

		if (coreid == 0)
		{
			step_k = 1;
			start_k= 0;
			end_k = lda;

			step_j = 2;
			start_j= 0;
			end_j = lda;

		}else
		{

			step_k = -1;
			start_k = lda-1;
			end_k = -1;

			step_j = -2;
			start_j= lda-2;
			end_j = -2;
		}
			
		for( kk = start_k ; kk!= end_k ; kk+=(step_k*16) )
		{
			for( jj = start_j ; jj!= end_j ; jj+=(step_j*8) )
			{			
				for ( i = start_i; i < end_i; i+=8 )
				{
					//pos_C = i + jj*lda;
					for ( j = jj; j != (jj+(step_j*8)) ; j+=step_j )
					{					
					
							pos_C = i + j*lda;
							temp00 = C[(pos_C + 0)];
							temp01 = C[(pos_C + 1)];
							temp02 = C[(pos_C + 2)];
							temp03 = C[(pos_C + 3)];
							temp04 = C[(pos_C + 4)];
							temp05 = C[(pos_C + 5)];
							temp06 = C[(pos_C + 6)];
							temp07 = C[(pos_C + 7)];
						
							//pos_C += lda;
							pos_C = i + (j+1)*lda;

							temp10 = C[(pos_C + 0)];
							temp11 = C[(pos_C + 1)];
							temp12 = C[(pos_C + 2)];
							temp13 = C[(pos_C + 3)];
							temp14 = C[(pos_C + 4)];
							temp15 = C[(pos_C + 5)];
							temp16 = C[(pos_C + 6)];
							temp17 = C[(pos_C + 7)];
						
						pos_B = kk*lda + i;
						pos_A = j*lda + kk;
						for ( k = kk; k != (kk+(step_k*16)) ; k+=step_k ) 
						{
						 	temp_A0 = A[ pos_A ] ;
						 	temp_A1 = A[pos_A +lda];
					
							temp00 += temp_A0 * B[(pos_B + 0)];
							temp01 += temp_A0 * B[(pos_B + 1)];
							temp02 += temp_A0 * B[(pos_B + 2)];
							temp03 += temp_A0 * B[(pos_B + 3)];
							temp04 += temp_A0 * B[(pos_B + 4)];
							temp05 += temp_A0 * B[(pos_B + 5)];
							temp06 += temp_A0 * B[(pos_B + 6)];
							temp07 += temp_A0 * B[(pos_B + 7)];
					
							temp10 += temp_A1 * B[(pos_B + 0)];
							temp11 += temp_A1 * B[(pos_B + 1)];
							temp12 += temp_A1 * B[(pos_B + 2)];
							temp13 += temp_A1 * B[(pos_B + 3)];
							temp14 += temp_A1 * B[(pos_B + 4)];
							temp15 += temp_A1 * B[(pos_B + 5)];
							temp16 += temp_A1 * B[(pos_B + 6)];
							temp17 += temp_A1 * B[(pos_B + 7)];
							
							pos_B += (lda*step_k) ;
							pos_A += step_k;
						}
						//barrier();

					  	C[(pos_C + 0)] = temp10;
						C[(pos_C + 1)] = temp11;
						C[(pos_C + 2)] = temp12;
						C[(pos_C + 3)] = temp13;
						C[(pos_C + 4)] = temp14;
						C[(pos_C + 5)] = temp15;
						C[(pos_C + 6)] = temp16;
						C[(pos_C + 7)] = temp17;
						//barrier();
				
						pos_C = i + j*lda;
						//pos_C -= lda;
					  	C[(pos_C + 0)] = temp00;
						C[(pos_C + 1)] = temp01;
						C[(pos_C + 2)] = temp02;
						C[(pos_C + 3)] = temp03;
						C[(pos_C + 4)] = temp04;
						C[(pos_C + 5)] = temp05;
						C[(pos_C + 6)] = temp06;
						C[(pos_C + 7)] = temp07;
						//barrier();
						//pos_C += step_j * lda;
					}
					//barrier();
				}
				//barrier();

			}
			//barrier();
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

   
	//printf("input1_data");
exit(0);

}
