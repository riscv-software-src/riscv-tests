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
  size_t i, j, k, l;
  int row,row2, column, column2, column3, column4, column5, column6, column7, column8;
  data_t element, element2, element3, element4, element5, element6, element7, element8;
  data_t temp_mat[32]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
  data_t temp_mat2[32]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
  //for (i=coreid*max_dim/ncores; i<(max_dim/ncores+coreid*max_dim/ncores); i+=8){
  for (l=coreid*32/ncores; l<32*(1+coreid)/ncores; l+=2){
    row=l*lda;
    row2=(l+1)*lda;
    for (i=0; i<lda; i+=4){
      element = A[row+i];
      element2 = A[row+i+1];
      element3 = A[row+i+2];
      element4 = A[row+i+3];

      element5 = A[row2+i];
      element6 = A[row2+i+1];
      element7 = A[row2+i+2];
      element8 = A[row2+i+3];

      column=i*lda;
      column2=(i+1)*lda;
      column3=(i+2)*lda;
      column4=(i+3)*lda;

      for (j=0; j<lda; j+=4){
				temp_mat[j]+=element*B[column+j]+element2*B[column2+j]+element3*B[column3+j]+element4*B[column4+j];
				temp_mat[j+1]+=element*B[column+j+1]+element2*B[column2+j+1]+element3*B[column3+j+1]+element4*B[column4+j+1];
				temp_mat[j+2]+=element*B[column+j+2]+element2*B[column2+j+2]+element3*B[column3+j+2]+element4*B[column4+j+2];
				temp_mat[j+3]+=element*B[column+j+3]+element2*B[column2+j+3]+element3*B[column3+j+3]+element4*B[column4+j+3];

				temp_mat2[j]+=element5*B[column+j]+element6*B[column2+j]+element7*B[column3+j]+element8*B[column4+j];
				temp_mat2[j+1]+=element5*B[column+j+1]+element6*B[column2+j+1]+element7*B[column3+j+1]+element8*B[column4+j+1];
				temp_mat2[j+2]+=element5*B[column+j+2]+element6*B[column2+j+2]+element7*B[column3+j+2]+element8*B[column4+j+2];
				temp_mat2[j+3]+=element5*B[column+j+3]+element6*B[column2+j+3]+element7*B[column3+j+3]+element8*B[column4+j+3];
      }

      }

			for(k=0; k<32; k++){
				C[row+k]=temp_mat[k];
				temp_mat[k]=0;
				C[row2+k]=temp_mat2[k];
				temp_mat2[k]=0;


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
