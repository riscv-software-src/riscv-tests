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
  size_t j;
  size_t k;
  size_t max_dim = 32*32;
  data_t temp_mat[32]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
  data_t temp_mat2[32]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
  //for (i=coreid*max_dim/ncores; i<(max_dim/ncores+coreid*max_dim/ncores); i+=8){
   for (i=coreid*max_dim/ncores; i<(max_dim/ncores+coreid*max_dim/ncores)/2; i+=8){
    data_t element=A[i];
    data_t element2 = A[i+1];
    data_t element3 = A[i+2];
    data_t element4 = A[i+3];
    data_t element5 = A[i+4];
    data_t element6 = A[i+5];
    data_t element7 = A[i+6];
    data_t element8 = A[i+7];
    data_t elementA2 = A[i+32*8];
      data_t elementA21 = A[i+32*8+1];
      data_t elementA22 = A[i+32*8+2];
      data_t elementA23 = A[i+32*8+3];
      data_t elementA24 = A[i+32*8+4];
      data_t elementA25 = A[i+32*8+5];
      data_t elementA26 = A[i+32*8+6];
      data_t elementA27 = A[i+32*8+7];
    int row= (int)(i/32)*32;
    int row2 = row+8*32;
    int column = i%32*32;
    int column2 = (i+1)%32*32;
    int column3 = (i+2)%32*32;
    int column4 = (i+3)%32*32;
    int column5 = (i+4)%32*32;
    int column6 = (i+5)%32*32;
    int column7 = (i+6)%32*32;
    int column8 = (i+7)%32*32;
    
    for (j=0; j<32; j++){
      temp_mat[j]+=element*B[column+j]+element2*B[column2+j]+element3*B[column3+j]+element4*B[column4+j]+element5*B[column5+j]+element6*B[column6+j]+element7*B[column7+j]+element8*B[column8+j];
      
      temp_mat2[j]+=elementA2*B[column+j]+elementA21*B[column2+j]+elementA22*B[column3+j]+elementA23*B[column4+j]+elementA24*B[column5+j]+elementA25*B[column6+j]+elementA26*B[column7+j]+elementA27*B[column8+j];
    }
    if (i%32==24){
      for(k=0; k<32; k++){
	C[row+k]=temp_mat[k];
	C[row2+k]=temp_mat2[k];
	temp_mat[k]=0;
	temp_mat2[k]=0;
	
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

