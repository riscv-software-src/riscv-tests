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
  data_t temp_mat[16] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
	if (coreid == 0) {
		//making a 16x16 block 
		//First block: Top 16x16 block left of A and top left of B = top left of C
		//Second block: top right 16x16 right block of A and top right of B = top right of C
		for (j2= 0; j2 < 2; j2++) {
		  for (i2 = 0; i2 < 2; i2++) {
				//for (j2= 0; j2 < 2; j2++) {
					//K represents which row of A and C
					for (k = 0; k < block_size; k++) {
						int rowIndex = k*32;
						for (i = i2*block_size; i < i2*block_size+block_size; i++) {
							int elementA = A[rowIndex+i];
							int columnIndex = i%32*32;
							for (j = 0; j < block_size; j++) {
								temp_mat[j] += elementA*B[columnIndex+j+j2*block_size];
					    }
						}
						//Put temp_mat into actual result Matrix	
						for (k2 = 0; k2 < block_size; k2++) {	   
							C[rowIndex+k2+j2*block_size] += temp_mat[k2];
							temp_mat[k2] = 0;
						}
					}
				}
			}
	} else {
		for (j2= 0; j2 < 2; j2++) {	  
	  		for (i2 = 0; i2 < 2; i2++) {
				//for (j2= 0; j2 < 2; j2++) {
				//K represents which row of A and C
					for (k = block_size; k < lda; k++) {
						int rowIndex = k*32;
						for (i = i2*block_size; i < i2*block_size+block_size; i++) {
							int elementA = A[rowIndex+i];
							int columnIndex = i%32*32;
							for (j = 0; j < block_size; j++) {
								temp_mat[j] += elementA*B[columnIndex+j+j2*block_size];
						  }
						}
						//Put temp_mat into actual result Matrix	
						for (k2 = 0; k2 < block_size; k2++) {	   
							C[rowIndex+k2+j2*block_size] += temp_mat[k2];
							temp_mat[k2] = 0;
						}
					}
				}
			}
	}


  //size_t half_lda = lda/2;
	// k = which pair of row we're on 

   




/*
  for (k = coreid*lda/ncores; k < (lda/ncores + coreid*lda/ncores); k += 2) {
	  //printf("%d", k);
  	for (i = 0; i < lda ; i++) {
			int elementA = A[32*k+i];
			int elementA2 = A[i + 32*(k+1)];
			int column = i%32*32;
	    for (j = 0; j < lda; j++) {
				C[32*k + j] += elementA*B[column+j];
				C[32*(k+1) + j] += elementA2*B[column+j]; 
			}
		}

	}
*/	
	
/*
    data_t element=A[i];
    data_t element2 = A[i+1];
    data_t element3 = A[i+2];
    data_t element4 = A[i+3];
    data_t element5 = A[i+4];
    data_t element6 = A[i+5];
    data_t element7 = A[i+6];
    data_t element8 = A[i+7];
    int row= (int)(i/32)*32;
    int row2 = (i+1)/32*32;
    int row3 = (i+2)/32*32;
    int row4 = (i+3)/32*32;
    int row5 = (i+4)/32*32;
    int row6 = (i+5)/32*32;
    int row7 = (i+6)/32*32;
    int row8 = (i+7)/32*32;
    int column = i%32*32;
    int column2 = (i+1)%32*32;
    int column3 = (i+2)%32*32;
    int column4 = (i+3)%32*32;
    int column5 = (i+4)%32*32;
    int column6 = (i+5)%32*32;
    int column7 = (i+6)%32*32;

	*/

    //int column8 = (i+7)%32*32;

  /*
    for (j=0; j < lda; j++) {
	sum = B[
      C[row+j]+=element*B[column+j];
      C[row2+j]+=element2*B[column2+j];
      C[row3+j]+=element3*B[column3+j];
      C[row4+j]+=element4*B[column4+j];
      C[row5+j]+=element5*B[column5+j];
      C[row6+j]+=element6*B[column6+j];
      C[row7+j]+=element7*B[column7+j];
      C[row8+j]+=element8*B[column8+j];
      C[row+j]+=element*B[column+j]+element2*B[column2+j]+element3*B[column3+j]+element4*B[column4+j]+element5*B[column5+j]+element6*B[column6+j]+element7*B[column7+j]+element8*B[column8+j];
    }
  }
	*/


  

      
   
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
   barrier(nc);
   stats(matmul_naive(DIM_SIZE, input1_data, input2_data, results_data); barrier(nc));
 
   
   // verify
   verifyMT(ARRAY_SIZE, results_data, verify_data);
   
   // clear results from the first trial
   size_t i;
   if (coreid == 0) 
      for (i=0; i < ARRAY_SIZE; i++)
         results_data[i] = 0;
   barrier(nc);

   
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
