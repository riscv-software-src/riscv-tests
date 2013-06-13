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

   //-------------------------------------------------------------first working version best 500k
   /*
    static __thread int i, j, k;
   	if(coreid == 0)
	{
   for ( j = 0; j < lda; j+=2 )
     {
      for ( k = 0; k < lda; k++ )  
      {
         for ( i = 0; i < lda; i++) 
         {
            C[i + j*lda] += A[j*lda + k] * B[k*lda + i];
         }
      }
	 }
	}
	
	if(coreid ==1)
	{
	   for ( j = 1; j < lda; j+=2 )
     {
      for ( k = 0;k < lda; k++)
      {
         for ( i = 0; i < lda; i++) 
         {
            C[i + j*lda] += A[j*lda + k] * B[k*lda + i];

         }
      }
	 }
	}
	*/
	//-------------------------------------------------------------version1.1, take read out of inner loop,300k
	/*
	static __thread int i, j, k;
	static __thread data_t TempA;
	
	if(coreid == 0)
	{
	for ( j = 0; j < lda; j+=2 )
     {
      for ( k = 0; k < lda; k++ )  
      {
		 TempA = A[j*lda + k];
         for ( i = 0; i < lda; i++) 
         {
            C[i + j*lda] +=  TempA* B[k*lda + i];
         }
      }
	 }
	}
	
	if(coreid ==1)
	{
	   for ( j = 1; j < lda; j+=2 )
     {
      for ( k = 0;k < lda; k++)
      {
        TempA = A[j*lda + k];
         for ( i = 0; i < lda; i++) 
         {
            C[i + j*lda] +=  TempA* B[k*lda + i];
         }
      }
	 }
	}
	*/
	//-------------------------------------------------------------version2.0, read 8 elements in B at one time. 140k mi, MSI117.0k
	/*
	   static __thread int i, j, k, m, n;
	static __thread data_t TempA;
	static __thread data_t TempB[8];
	
	if(coreid == 0)
	{
	for ( j = 0; j < lda; j+=2 )
     {
      for ( k = 0; k < lda; k++ )  
      {
		 TempA = A[j*lda + k];
		for( n = 0; n < 4; n++)
		{

		 TempB[0] = B[k*lda+0+8*n]; 
		 TempB[1] = B[k*lda+1+8*n]; 
		 TempB[2] = B[k*lda+2+8*n]; 
		 TempB[3] = B[k*lda+3+8*n]; 
		 TempB[4] = B[k*lda+4+8*n]; 
		 TempB[5] = B[k*lda+5+8*n]; 
		 TempB[6] = B[k*lda+6+8*n]; 
		 TempB[7] = B[k*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA * TempB[0];
		 C[1+8*n+j*lda] += TempA * TempB[1];
		 C[2+8*n+j*lda] += TempA * TempB[2];
		 C[3+8*n+j*lda] += TempA * TempB[3];
		 C[4+8*n+j*lda] += TempA * TempB[4];
		 C[5+8*n+j*lda] += TempA * TempB[5];
		 C[6+8*n+j*lda] += TempA * TempB[6];
		 C[7+8*n+j*lda] += TempA * TempB[7];
		 
		}

      }
	 }
	}
	
	if(coreid == 1)
	{
	for ( j = 1; j < lda; j+=2 )
     {
      for ( k = 0; k < lda; k++ )  
      {
		 TempA = A[j*lda + k];
		for( n = 0; n < 4; n++)
		{

		 TempB[0] = B[k*lda+0+8*n]; 
		 TempB[1] = B[k*lda+1+8*n]; 
		 TempB[2] = B[k*lda+2+8*n]; 
		 TempB[3] = B[k*lda+3+8*n]; 
		 TempB[4] = B[k*lda+4+8*n]; 
		 TempB[5] = B[k*lda+5+8*n]; 
		 TempB[6] = B[k*lda+6+8*n]; 
		 TempB[7] = B[k*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA * TempB[0];
		 C[1+8*n+j*lda] += TempA * TempB[1];
		 C[2+8*n+j*lda] += TempA * TempB[2];
		 C[3+8*n+j*lda] += TempA * TempB[3];
		 C[4+8*n+j*lda] += TempA * TempB[4];
		 C[5+8*n+j*lda] += TempA * TempB[5];
		 C[6+8*n+j*lda] += TempA * TempB[6];
		 C[7+8*n+j*lda] += TempA * TempB[7];
		 
		}

      }
	 }
	}
	*/
	
		//-------------------------------------------------------------version2.1, optimize k. 700k. bad move to v2.2.
		//-------------------------------------------------------------version2.9 take off all inner loops for both cores, MSI,109K. MI 182k
		//-------------------------------------------------------------version2.10 use i= j*lda inside the n loop increase speed. but not out m and n. tried replace first 3, get 104.9k
	/*
	   static __thread int j, m, i,n;
	static __thread data_t TempA[8];
	static __thread data_t TempB[8];
	
	if(coreid == 1)
	{
	for ( j = 1; j < lda; j+=2 )
     {		
		  
      for ( m = 0; m < 4; m++ )  
      {
		  
		 TempA[0] = A[j*lda+0+8*m];
		 TempA[1] = A[j*lda+1+8*m];
		 TempA[2] = A[j*lda+2+8*m];
		 TempA[3] = A[j*lda+3+8*m];
		 TempA[4] = A[j*lda+4+8*m];
		 TempA[5] = A[j*lda+5+8*m];
		 TempA[6] = A[j*lda+6+8*m];
		 TempA[7] = A[j*lda+7+8*m];
		 
		for( n = 0; n < 4; n++)
		{
		i = j*lda;

		 TempB[0] = B[(0+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(0+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(0+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(0+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(0+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(0+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(0+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(0+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+i] += TempA[0] * TempB[0];
		 C[1+8*n+i] += TempA[0] * TempB[1];
		 C[2+8*n+i] += TempA[0] * TempB[2];
		 C[3+8*n+i] += TempA[0] * TempB[3];
		 C[4+8*n+i] += TempA[0] * TempB[4];
		 C[5+8*n+i] += TempA[0] * TempB[5];
		 C[6+8*n+i] += TempA[0] * TempB[6];
		 C[7+8*n+i] += TempA[0] * TempB[7];
		 


		 TempB[0] = B[(1+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(1+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(1+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(1+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(1+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(1+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(1+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(1+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+i] += TempA[1] * TempB[0];
		 C[1+8*n+i] += TempA[1] * TempB[1];
		 C[2+8*n+i] += TempA[1] * TempB[2];
		 C[3+8*n+i] += TempA[1] * TempB[3];
		 C[4+8*n+i] += TempA[1] * TempB[4];
		 C[5+8*n+i] += TempA[1] * TempB[5];
		 C[6+8*n+i] += TempA[1] * TempB[6];
		 C[7+8*n+i] += TempA[1] * TempB[7];
		 


		 TempB[0] = B[(2+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(2+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(2+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(2+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(2+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(2+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(2+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(2+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+i] += TempA[2] * TempB[0];
		 C[1+8*n+i] += TempA[2] * TempB[1];
		 C[2+8*n+i] += TempA[2] * TempB[2];
		 C[3+8*n+i] += TempA[2] * TempB[3];
		 C[4+8*n+i] += TempA[2] * TempB[4];
		 C[5+8*n+i] += TempA[2] * TempB[5];
		 C[6+8*n+i] += TempA[2] * TempB[6];
		 C[7+8*n+i] += TempA[2] * TempB[7];
		 


		 TempB[0] = B[(3+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(3+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(3+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(3+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(3+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(3+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(3+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(3+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+i] += TempA[3] * TempB[0];
		 C[1+8*n+i] += TempA[3] * TempB[1];
		 C[2+8*n+i] += TempA[3] * TempB[2];
		 C[3+8*n+i] += TempA[3] * TempB[3];
		 C[4+8*n+i] += TempA[3] * TempB[4];
		 C[5+8*n+i] += TempA[3] * TempB[5];
		 C[6+8*n+i] += TempA[3] * TempB[6];
		 C[7+8*n+i] += TempA[3] * TempB[7];


		 TempB[0] = B[(4+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(4+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(4+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(4+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(4+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(4+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(4+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(4+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+i] += TempA[4] * TempB[0];
		 C[1+8*n+i] += TempA[4] * TempB[1];
		 C[2+8*n+i] += TempA[4] * TempB[2];
		 C[3+8*n+i] += TempA[4] * TempB[3];
		 C[4+8*n+i] += TempA[4] * TempB[4];
		 C[5+8*n+i] += TempA[4] * TempB[5];
		 C[6+8*n+i] += TempA[4] * TempB[6];
		 C[7+8*n+i] += TempA[4] * TempB[7];
		 


		 TempB[0] = B[(5+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(5+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(5+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(5+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(5+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(5+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(5+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(5+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+i] += TempA[5] * TempB[0];
		 C[1+8*n+i] += TempA[5] * TempB[1];
		 C[2+8*n+i] += TempA[5] * TempB[2];
		 C[3+8*n+i] += TempA[5] * TempB[3];
		 C[4+8*n+i] += TempA[5] * TempB[4];
		 C[5+8*n+i] += TempA[5] * TempB[5];
		 C[6+8*n+i] += TempA[5] * TempB[6];
		 C[7+8*n+i] += TempA[5] * TempB[7];
		 


		 TempB[0] = B[(6+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(6+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(6+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(6+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(6+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(6+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(6+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(6+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+i] += TempA[6] * TempB[0];
		 C[1+8*n+i] += TempA[6] * TempB[1];
		 C[2+8*n+i] += TempA[6] * TempB[2];
		 C[3+8*n+i] += TempA[6] * TempB[3];
		 C[4+8*n+i] += TempA[6] * TempB[4];
		 C[5+8*n+i] += TempA[6] * TempB[5];
		 C[6+8*n+i] += TempA[6] * TempB[6];
		 C[7+8*n+i] += TempA[6] * TempB[7];


		 TempB[0] = B[(7+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(7+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(7+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(7+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(7+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(7+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(7+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(7+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+i] += TempA[7] * TempB[0];
		 C[1+8*n+i] += TempA[7] * TempB[1];
		 C[2+8*n+i] += TempA[7] * TempB[2];
		 C[3+8*n+i] += TempA[7] * TempB[3];
		 C[4+8*n+i] += TempA[7] * TempB[4];
		 C[5+8*n+i] += TempA[7] * TempB[5];
		 C[6+8*n+i] += TempA[7] * TempB[6];
		 C[7+8*n+i] += TempA[7] * TempB[7];
		}

      }
	 }
	}
	if(coreid == 0)
	{
	for ( j = 0; j < lda; j+=2 )
     {		
		  
      for ( m = 0; m < 4; m++ )  
      {
		  
		 TempA[0] = A[j*lda+0+8*m];
		 TempA[1] = A[j*lda+1+8*m];
		 TempA[2] = A[j*lda+2+8*m];
		 TempA[3] = A[j*lda+3+8*m];
		 TempA[4] = A[j*lda+4+8*m];
		 TempA[5] = A[j*lda+5+8*m];
		 TempA[6] = A[j*lda+6+8*m];
		 TempA[7] = A[j*lda+7+8*m];
		 
		for( n = 0; n < 4; n++)
		{
		i = j*lda;

		 TempB[0] = B[(0+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(0+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(0+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(0+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(0+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(0+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(0+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(0+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+i] += TempA[0] * TempB[0];
		 C[1+8*n+i] += TempA[0] * TempB[1];
		 C[2+8*n+i] += TempA[0] * TempB[2];
		 C[3+8*n+i] += TempA[0] * TempB[3];
		 C[4+8*n+i] += TempA[0] * TempB[4];
		 C[5+8*n+i] += TempA[0] * TempB[5];
		 C[6+8*n+i] += TempA[0] * TempB[6];
		 C[7+8*n+i] += TempA[0] * TempB[7];
		 


		 TempB[0] = B[(1+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(1+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(1+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(1+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(1+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(1+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(1+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(1+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+i] += TempA[1] * TempB[0];
		 C[1+8*n+i] += TempA[1] * TempB[1];
		 C[2+8*n+i] += TempA[1] * TempB[2];
		 C[3+8*n+i] += TempA[1] * TempB[3];
		 C[4+8*n+i] += TempA[1] * TempB[4];
		 C[5+8*n+i] += TempA[1] * TempB[5];
		 C[6+8*n+i] += TempA[1] * TempB[6];
		 C[7+8*n+i] += TempA[1] * TempB[7];
		 


		 TempB[0] = B[(2+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(2+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(2+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(2+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(2+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(2+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(2+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(2+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+i] += TempA[2] * TempB[0];
		 C[1+8*n+i] += TempA[2] * TempB[1];
		 C[2+8*n+i] += TempA[2] * TempB[2];
		 C[3+8*n+i] += TempA[2] * TempB[3];
		 C[4+8*n+i] += TempA[2] * TempB[4];
		 C[5+8*n+i] += TempA[2] * TempB[5];
		 C[6+8*n+i] += TempA[2] * TempB[6];
		 C[7+8*n+i] += TempA[2] * TempB[7];
		 


		 TempB[0] = B[(3+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(3+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(3+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(3+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(3+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(3+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(3+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(3+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+i] += TempA[3] * TempB[0];
		 C[1+8*n+i] += TempA[3] * TempB[1];
		 C[2+8*n+i] += TempA[3] * TempB[2];
		 C[3+8*n+i] += TempA[3] * TempB[3];
		 C[4+8*n+i] += TempA[3] * TempB[4];
		 C[5+8*n+i] += TempA[3] * TempB[5];
		 C[6+8*n+i] += TempA[3] * TempB[6];
		 C[7+8*n+i] += TempA[3] * TempB[7];


		 TempB[0] = B[(4+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(4+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(4+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(4+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(4+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(4+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(4+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(4+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+i] += TempA[4] * TempB[0];
		 C[1+8*n+i] += TempA[4] * TempB[1];
		 C[2+8*n+i] += TempA[4] * TempB[2];
		 C[3+8*n+i] += TempA[4] * TempB[3];
		 C[4+8*n+i] += TempA[4] * TempB[4];
		 C[5+8*n+i] += TempA[4] * TempB[5];
		 C[6+8*n+i] += TempA[4] * TempB[6];
		 C[7+8*n+i] += TempA[4] * TempB[7];
		 


		 TempB[0] = B[(5+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(5+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(5+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(5+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(5+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(5+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(5+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(5+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+i] += TempA[5] * TempB[0];
		 C[1+8*n+i] += TempA[5] * TempB[1];
		 C[2+8*n+i] += TempA[5] * TempB[2];
		 C[3+8*n+i] += TempA[5] * TempB[3];
		 C[4+8*n+i] += TempA[5] * TempB[4];
		 C[5+8*n+i] += TempA[5] * TempB[5];
		 C[6+8*n+i] += TempA[5] * TempB[6];
		 C[7+8*n+i] += TempA[5] * TempB[7];
		 


		 TempB[0] = B[(6+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(6+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(6+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(6+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(6+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(6+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(6+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(6+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+i] += TempA[6] * TempB[0];
		 C[1+8*n+i] += TempA[6] * TempB[1];
		 C[2+8*n+i] += TempA[6] * TempB[2];
		 C[3+8*n+i] += TempA[6] * TempB[3];
		 C[4+8*n+i] += TempA[6] * TempB[4];
		 C[5+8*n+i] += TempA[6] * TempB[5];
		 C[6+8*n+i] += TempA[6] * TempB[6];
		 C[7+8*n+i] += TempA[6] * TempB[7];


		 TempB[0] = B[(7+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(7+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(7+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(7+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(7+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(7+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(7+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(7+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+i] += TempA[7] * TempB[0];
		 C[1+8*n+i] += TempA[7] * TempB[1];
		 C[2+8*n+i] += TempA[7] * TempB[2];
		 C[3+8*n+i] += TempA[7] * TempB[3];
		 C[4+8*n+i] += TempA[7] * TempB[4];
		 C[5+8*n+i] += TempA[7] * TempB[5];
		 C[6+8*n+i] += TempA[7] * TempB[6];
		 C[7+8*n+i] += TempA[7] * TempB[7];
		}

      }
	 }
	}
	
	*/
		//-------------------------------------------------------------version2.2, optimize k. from 4 instead of 8 like v2.1, random failing on MI, unknown reason, MSI,350K, take off each inner loop for core 0 260k, both cores 134k
		//-------------------------------------------------------------try false sharing for core 0, 136k.
		/*
	static __thread int j, m, n;
	static __thread data_t TempA[4];
	static __thread data_t TempB[4];
	
	if(coreid == 1)
	{
	for ( j = 1; j < lda; j+=2 )
     {
      for ( m = 0; m < 8; m++ )  
      {
		 TempA[0] = A[j*lda+0+4*m];
		 TempA[1] = A[j*lda+1+4*m];
		 TempA[2] = A[j*lda+2+4*m];
		 TempA[3] = A[j*lda+3+4*m];
		 
		for( n = 0; n < 8; n++)
		{

		 TempB[0] = B[(0+4*m)*lda+0+4*n]; 
		 TempB[1] = B[(0+4*m)*lda+1+4*n]; 
		 TempB[2] = B[(0+4*m)*lda+2+4*n]; 
		 TempB[3] = B[(0+4*m)*lda+3+4*n]; 

		 
		 C[0+4*n+j*lda] += TempA[0] * TempB[0];
		 C[1+4*n+j*lda] += TempA[0] * TempB[1];
		 C[2+4*n+j*lda] += TempA[0] * TempB[2];
		 C[3+4*n+j*lda] += TempA[0] * TempB[3];

		 
		


		 TempB[0] = B[(1+4*m)*lda+0+4*n]; 
		 TempB[1] = B[(1+4*m)*lda+1+4*n]; 
		 TempB[2] = B[(1+4*m)*lda+2+4*n]; 
		 TempB[3] = B[(1+4*m)*lda+3+4*n]; 
 
		 
		 C[0+4*n+j*lda] += TempA[1] * TempB[0];
		 C[1+4*n+j*lda] += TempA[1] * TempB[1];
		 C[2+4*n+j*lda] += TempA[1] * TempB[2];
		 C[3+4*n+j*lda] += TempA[1] * TempB[3];
 
		

		 TempB[0] = B[(2+4*m)*lda+0+4*n]; 
		 TempB[1] = B[(2+4*m)*lda+1+4*n]; 
		 TempB[2] = B[(2+4*m)*lda+2+4*n]; 
		 TempB[3] = B[(2+4*m)*lda+3+4*n]; 

		 
		 C[0+4*n+j*lda] += TempA[2] * TempB[0];
		 C[1+4*n+j*lda] += TempA[2] * TempB[1];
		 C[2+4*n+j*lda] += TempA[2] * TempB[2];
		 C[3+4*n+j*lda] += TempA[2] * TempB[3];
	
		 


		 TempB[0] = B[(3+4*m)*lda+0+4*n]; 
		 TempB[1] = B[(3+4*m)*lda+1+4*n]; 
		 TempB[2] = B[(3+4*m)*lda+2+4*n]; 
		 TempB[3] = B[(3+4*m)*lda+3+4*n]; 

		 
		 C[0+4*n+j*lda] += TempA[3] * TempB[0];
		 C[1+4*n+j*lda] += TempA[3] * TempB[1];
		 C[2+4*n+j*lda] += TempA[3] * TempB[2];
		 C[3+4*n+j*lda] += TempA[3] * TempB[3];

		 
		}
	  }
	 }
	}
	if(coreid == 0)
	{
	for ( j = 0; j < lda; j+=2 )
     {
      for ( m = 0; m < 8; m++ )  
      {
		 TempA[0] = A[j*lda+0+4*m];
		 TempA[1] = A[j*lda+1+4*m];
		 TempA[2] = A[j*lda+2+4*m];
		 TempA[3] = A[j*lda+3+4*m];
		 
		for( n = 0; n < 8; n++)
		{



		 
		


		 TempB[0] = B[(1+4*m)*lda+0+4*n]; 
		 TempB[1] = B[(1+4*m)*lda+1+4*n]; 
		 TempB[2] = B[(1+4*m)*lda+2+4*n]; 
		 TempB[3] = B[(1+4*m)*lda+3+4*n]; 
 
		 
		 C[0+4*n+j*lda] += TempA[1] * TempB[0];
		 C[1+4*n+j*lda] += TempA[1] * TempB[1];
		 C[2+4*n+j*lda] += TempA[1] * TempB[2];
		 C[3+4*n+j*lda] += TempA[1] * TempB[3];
 
		

		 TempB[0] = B[(2+4*m)*lda+0+4*n]; 
		 TempB[1] = B[(2+4*m)*lda+1+4*n]; 
		 TempB[2] = B[(2+4*m)*lda+2+4*n]; 
		 TempB[3] = B[(2+4*m)*lda+3+4*n]; 

		 
		 C[0+4*n+j*lda] += TempA[2] * TempB[0];
		 C[1+4*n+j*lda] += TempA[2] * TempB[1];
		 C[2+4*n+j*lda] += TempA[2] * TempB[2];
		 C[3+4*n+j*lda] += TempA[2] * TempB[3];
	
		 


		 TempB[0] = B[(3+4*m)*lda+0+4*n]; 
		 TempB[1] = B[(3+4*m)*lda+1+4*n]; 
		 TempB[2] = B[(3+4*m)*lda+2+4*n]; 
		 TempB[3] = B[(3+4*m)*lda+3+4*n]; 

		 
		 C[0+4*n+j*lda] += TempA[3] * TempB[0];
		 C[1+4*n+j*lda] += TempA[3] * TempB[1];
		 C[2+4*n+j*lda] += TempA[3] * TempB[2];
		 C[3+4*n+j*lda] += TempA[3] * TempB[3];
		 
		 TempB[0] = B[(0+4*m)*lda+0+4*n]; 
		 TempB[1] = B[(0+4*m)*lda+1+4*n]; 
		 TempB[2] = B[(0+4*m)*lda+2+4*n]; 
		 TempB[3] = B[(0+4*m)*lda+3+4*n]; 

		 
		 C[0+4*n+j*lda] += TempA[0] * TempB[0];
		 C[1+4*n+j*lda] += TempA[0] * TempB[1];
		 C[2+4*n+j*lda] += TempA[0] * TempB[2];
		 C[3+4*n+j*lda] += TempA[0] * TempB[3];

		 
		}
	  }
	 }
	}
	*/
	

	
	//-------------------------------------------------------------version2.3, read 8 elements in B at one time. make k to 2. 150k mi 128k msi. worse than v2.0
	/*
	static __thread int i, j, k, m, n;
	static __thread data_t TempA[2];
	static __thread data_t TempB[8];
	
	if(coreid == 0)
	{
	for ( j = 0; j < lda; j+=2 )
     {
      for ( m = 0; m < 16; m++ )  
      {
		 TempA[0] = A[j*lda + 0 + 2*m];
		 TempA[1] = A[j*lda + 1 + 2*m];
		for( n = 0; n < 4; n++)
		{

		 TempB[0] = B[2*m*lda+0+8*n]; 
		 TempB[1] = B[2*m*lda+1+8*n]; 
		 TempB[2] = B[2*m*lda+2+8*n]; 
		 TempB[3] = B[2*m*lda+3+8*n]; 
		 TempB[4] = B[2*m*lda+4+8*n]; 
		 TempB[5] = B[2*m*lda+5+8*n]; 
		 TempB[6] = B[2*m*lda+6+8*n]; 
		 TempB[7] = B[2*m*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[0] * TempB[0];
		 C[1+8*n+j*lda] += TempA[0] * TempB[1];
		 C[2+8*n+j*lda] += TempA[0] * TempB[2];
		 C[3+8*n+j*lda] += TempA[0] * TempB[3];
		 C[4+8*n+j*lda] += TempA[0] * TempB[4];
		 C[5+8*n+j*lda] += TempA[0] * TempB[5];
		 C[6+8*n+j*lda] += TempA[0] * TempB[6];
		 C[7+8*n+j*lda] += TempA[0] * TempB[7];
		 
		 TempB[0] = B[(1+2*m)*lda+0+8*n]; 
		 TempB[1] = B[(1+2*m)*lda+1+8*n]; 
		 TempB[2] = B[(1+2*m)*lda+2+8*n]; 
		 TempB[3] = B[(1+2*m)*lda+3+8*n]; 
		 TempB[4] = B[(1+2*m)*lda+4+8*n]; 
		 TempB[5] = B[(1+2*m)*lda+5+8*n]; 
		 TempB[6] = B[(1+2*m)*lda+6+8*n]; 
		 TempB[7] = B[(1+2*m)*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[1] * TempB[0];
		 C[1+8*n+j*lda] += TempA[1] * TempB[1];
		 C[2+8*n+j*lda] += TempA[1] * TempB[2];
		 C[3+8*n+j*lda] += TempA[1] * TempB[3];
		 C[4+8*n+j*lda] += TempA[1] * TempB[4];
		 C[5+8*n+j*lda] += TempA[1] * TempB[5];
		 C[6+8*n+j*lda] += TempA[1] * TempB[6];
		 C[7+8*n+j*lda] += TempA[1] * TempB[7];
		 
		}

      }
	 }
	}
	
	if(coreid == 1)
	{
	for ( j = 1; j < lda; j+=2 )
     {
      for ( m = 0; m < 16; m++ )  
      {
		 TempA[0] = A[j*lda + 0 + 2*m];
		 TempA[1] = A[j*lda + 1 + 2*m];
		for( n = 0; n < 4; n++)
		{

		 TempB[0] = B[2*m*lda+0+8*n]; 
		 TempB[1] = B[2*m*lda+1+8*n]; 
		 TempB[2] = B[2*m*lda+2+8*n]; 
		 TempB[3] = B[2*m*lda+3+8*n]; 
		 TempB[4] = B[2*m*lda+4+8*n]; 
		 TempB[5] = B[2*m*lda+5+8*n]; 
		 TempB[6] = B[2*m*lda+6+8*n]; 
		 TempB[7] = B[2*m*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[0] * TempB[0];
		 C[1+8*n+j*lda] += TempA[0] * TempB[1];
		 C[2+8*n+j*lda] += TempA[0] * TempB[2];
		 C[3+8*n+j*lda] += TempA[0] * TempB[3];
		 C[4+8*n+j*lda] += TempA[0] * TempB[4];
		 C[5+8*n+j*lda] += TempA[0] * TempB[5];
		 C[6+8*n+j*lda] += TempA[0] * TempB[6];
		 C[7+8*n+j*lda] += TempA[0] * TempB[7];
		 
		 TempB[0] = B[(1+2*m)*lda+0+8*n]; 
		 TempB[1] = B[(1+2*m)*lda+1+8*n]; 
		 TempB[2] = B[(1+2*m)*lda+2+8*n]; 
		 TempB[3] = B[(1+2*m)*lda+3+8*n]; 
		 TempB[4] = B[(1+2*m)*lda+4+8*n]; 
		 TempB[5] = B[(1+2*m)*lda+5+8*n]; 
		 TempB[6] = B[(1+2*m)*lda+6+8*n]; 
		 TempB[7] = B[(1+2*m)*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[1] * TempB[0];
		 C[1+8*n+j*lda] += TempA[1] * TempB[1];
		 C[2+8*n+j*lda] += TempA[1] * TempB[2];
		 C[3+8*n+j*lda] += TempA[1] * TempB[3];
		 C[4+8*n+j*lda] += TempA[1] * TempB[4];
		 C[5+8*n+j*lda] += TempA[1] * TempB[5];
		 C[6+8*n+j*lda] += TempA[1] * TempB[6];
		 C[7+8*n+j*lda] += TempA[1] * TempB[7];
		 
		}

      }
	 }
	}
	*/
	//-------------------------------------------------------------version2.4, read 4 170k and 16 140k, error because not enough space elements in B at one time. 
	/*
	   static __thread int i, j, k, m, n;
	static __thread data_t TempA;
	static __thread data_t TempB[16];
	
	if(coreid == 0)
	{
	for ( j = 0; j < lda; j+=2 )
     {
      for ( k = 0; k < lda; k++ )  
      {
		 TempA = A[j*lda + k];
		for( n = 0; n < 2; n++)
		{

		 TempB[0] = B[k*lda+0+16*n]; 
		 TempB[1] = B[k*lda+1+16*n]; 
		 TempB[2] = B[k*lda+2+16*n]; 
		 TempB[3] = B[k*lda+3+16*n];
		 TempB[4] = B[k*lda+4+16*n]; 
		 TempB[5] = B[k*lda+5+16*n]; 
		 TempB[6] = B[k*lda+6+16*n]; 
		 TempB[7] = B[k*lda+7+16*n]; 
		 TempB[8] = B[k*lda+8+16*n]; 
		 TempB[9] = B[k*lda+9+16*n]; 
		 TempB[10] = B[k*lda+10+16*n]; 
		 TempB[11] = B[k*lda+11+16*n]; 
		 TempB[12] = B[k*lda+12+16*n]; 
		 TempB[13] = B[k*lda+13+16*n]; 
		 TempB[14] = B[k*lda+14+16*n]; 
		 TempB[15] = B[k*lda+15+16*n]; 

		 
		 C[0+16*n+j*lda] += TempA * TempB[0];
		 C[1+16*n+j*lda] += TempA * TempB[1];
		 C[2+16*n+j*lda] += TempA * TempB[2];
		 C[3+16*n+j*lda] += TempA * TempB[3];
		 C[4+16*n+j*lda] += TempA * TempB[4];
		 C[5+16*n+j*lda] += TempA * TempB[5];
		 C[6+16*n+j*lda] += TempA * TempB[6];
		 C[7+16*n+j*lda] += TempA * TempB[7];
		 C[8+16*n+j*lda] += TempA * TempB[8];
		 C[9+16*n+j*lda] += TempA * TempB[9];
		 C[10+16*n+j*lda] += TempA * TempB[10];
		 C[11+16*n+j*lda] += TempA * TempB[11];
		 C[12+16*n+j*lda] += TempA * TempB[12];
		 C[13+16*n+j*lda] += TempA * TempB[13];
		 C[14+16*n+j*lda] += TempA * TempB[14];
		 C[15+16*n+j*lda] += TempA * TempB[15];
		 
	
		 
		}

      }
	 }
	}
		if(coreid == 1)
	{
	for ( j = 1; j < lda; j+=2 )
     {
      for ( k = 0; k < lda; k++ )  
      {
		 TempA = A[j*lda + k];
		for( n = 0; n < 2; n++)
		{

		 TempB[0] = B[k*lda+0+16*n]; 
		 TempB[1] = B[k*lda+1+16*n]; 
		 TempB[2] = B[k*lda+2+16*n]; 
		 TempB[3] = B[k*lda+3+16*n];
		 TempB[4] = B[k*lda+4+16*n]; 
		 TempB[5] = B[k*lda+5+16*n]; 
		 TempB[6] = B[k*lda+6+16*n]; 
		 TempB[7] = B[k*lda+7+16*n]; 
		 TempB[8] = B[k*lda+8+16*n]; 
		 TempB[9] = B[k*lda+9+16*n]; 
		 TempB[10] = B[k*lda+10+16*n]; 
		 TempB[11] = B[k*lda+11+16*n]; 
		 TempB[12] = B[k*lda+12+16*n]; 
		 TempB[13] = B[k*lda+13+16*n]; 
		 TempB[14] = B[k*lda+14+16*n]; 
		 TempB[15] = B[k*lda+15+16*n]; 

		 
		 C[0+16*n+j*lda] += TempA * TempB[0];
		 C[1+16*n+j*lda] += TempA * TempB[1];
		 C[2+16*n+j*lda] += TempA * TempB[2];
		 C[3+16*n+j*lda] += TempA * TempB[3];
		 C[4+16*n+j*lda] += TempA * TempB[4];
		 C[5+16*n+j*lda] += TempA * TempB[5];
		 C[6+16*n+j*lda] += TempA * TempB[6];
		 C[7+16*n+j*lda] += TempA * TempB[7];
		 C[8+16*n+j*lda] += TempA * TempB[8];
		 C[9+16*n+j*lda] += TempA * TempB[9];
		 C[10+16*n+j*lda] += TempA * TempB[10];
		 C[11+16*n+j*lda] += TempA * TempB[11];
		 C[12+16*n+j*lda] += TempA * TempB[12];
		 C[13+16*n+j*lda] += TempA * TempB[13];
		 C[14+16*n+j*lda] += TempA * TempB[14];
		 C[15+16*n+j*lda] += TempA * TempB[15];
		 
	
		 
		}

      }
	 }
	}
	
	*/
		//-------------------------------------------------------------version2.5, read 10 elements in B at one time. has corner cases. Turns out it hangs.
	/*
	static __thread int j, k, n;
	static __thread data_t TempA;
	static __thread data_t TempB[10];
	
	if(coreid == 0)
	{
	for ( j = 0; j < lda; j+=2 )
     {
      for ( k = 0; k < lda; k++ )  
      {
		 TempA = A[j*lda + k];
		for( n = 0; n < 3; n++)
		{
		 TempB[0] = B[k*lda+0+10*n]; 
		 TempB[1] = B[k*lda+1+10*n]; 
		 TempB[2] = B[k*lda+2+10*n]; 
		 TempB[3] = B[k*lda+3+10*n]; 
		 TempB[4] = B[k*lda+4+10*n]; 
		 TempB[5] = B[k*lda+5+10*n]; 
		 TempB[6] = B[k*lda+6+10*n]; 
		 TempB[7] = B[k*lda+7+10*n]; 
		 TempB[8] = B[k*lda+8+10*n]; 
		 TempB[9] = B[k*lda+9+10*n]; 
		 
		 C[0+10*n+j*lda] += TempA * TempB[0];
		 C[1+10*n+j*lda] += TempA * TempB[1];
		 C[2+10*n+j*lda] += TempA * TempB[2];
		 C[3+10*n+j*lda] += TempA * TempB[3];
		 C[4+10*n+j*lda] += TempA * TempB[4];
		 C[5+10*n+j*lda] += TempA * TempB[5];
		 C[6+10*n+j*lda] += TempA * TempB[6];
		 C[7+10*n+j*lda] += TempA * TempB[7];
		 C[8+10*n+j*lda] += TempA * TempB[8];
		 C[9+10*n+j*lda] += TempA * TempB[9];		 
		}
		 TempB[0] = B[k*lda+30]; 
		 TempB[1] = B[k*lda+31]; 
		 C[30+j*lda] += TempA * TempB[0];
		 C[31+j*lda] += TempA * TempB[1];
      }
	 }
	}
		if(coreid == 1)
	{
	for ( j = 1; j < lda; j+=2 )
     {
      for ( k = 0; k < lda; k++ )  
      {
		 TempA = A[j*lda + k];
		for( n = 0; n < 3; n++)
		{
		 TempB[0] = B[k*lda+0+10*n]; 
		 TempB[1] = B[k*lda+1+10*n]; 
		 TempB[2] = B[k*lda+2+10*n]; 
		 TempB[3] = B[k*lda+3+10*n]; 
		 TempB[4] = B[k*lda+4+10*n]; 
		 TempB[5] = B[k*lda+5+10*n]; 
		 TempB[6] = B[k*lda+6+10*n]; 
		 TempB[7] = B[k*lda+7+10*n]; 
		 TempB[8] = B[k*lda+8+10*n]; 
		 TempB[9] = B[k*lda+9+10*n]; 
		 
		 C[0+10*n+j*lda] += TempA * TempB[0];
		 C[1+10*n+j*lda] += TempA * TempB[1];
		 C[2+10*n+j*lda] += TempA * TempB[2];
		 C[3+10*n+j*lda] += TempA * TempB[3];
		 C[4+10*n+j*lda] += TempA * TempB[4];
		 C[5+10*n+j*lda] += TempA * TempB[5];
		 C[6+10*n+j*lda] += TempA * TempB[6];
		 C[7+10*n+j*lda] += TempA * TempB[7];
		 C[8+10*n+j*lda] += TempA * TempB[8];
		 C[9+10*n+j*lda] += TempA * TempB[9];		 
		}
		 TempB[0] = B[k*lda+30]; 
		 TempB[1] = B[k*lda+31]; 
		 C[30+j*lda] += TempA * TempB[0];
		 C[31+j*lda] += TempA * TempB[1];
      }
	 }
	}
	
 */
 
 	//-------------------------------------------------------------version2.6, optimize 2.0. take off n loop and tried different order of reading B 
	/*
	   static __thread int j, k, n;
	static __thread data_t TempA;
	static __thread data_t TempB[8];
	
	if(coreid == 0)
	{
	for ( j = 0; j < lda; j+=2 )
     {
      for ( k = 0; k < lda; k++ )  
      {
		 TempA = A[j*lda + k];

		 TempB[0] = B[k*lda+0]; 
		 TempB[1] = B[k*lda+1]; 
		 TempB[2] = B[k*lda+2]; 
		 TempB[3] = B[k*lda+3]; 
		 TempB[4] = B[k*lda+4]; 
		 TempB[5] = B[k*lda+5]; 
		 TempB[6] = B[k*lda+6]; 
		 TempB[7] = B[k*lda+7]; 
		 
		 C[0+j*lda] += TempA * TempB[0];
		 C[1+j*lda] += TempA * TempB[1];
		 C[2+j*lda] += TempA * TempB[2];
		 C[3+j*lda] += TempA * TempB[3];
		 C[4+j*lda] += TempA * TempB[4];
		 C[5+j*lda] += TempA * TempB[5];
		 C[6+j*lda] += TempA * TempB[6];
		 C[7+j*lda] += TempA * TempB[7];
		 
		 TempB[0] = B[k*lda+8]; 
		 TempB[1] = B[k*lda+9]; 
		 TempB[2] = B[k*lda+10]; 
		 TempB[3] = B[k*lda+11]; 
		 TempB[4] = B[k*lda+12]; 
		 TempB[5] = B[k*lda+13]; 
		 TempB[6] = B[k*lda+14]; 
		 TempB[7] = B[k*lda+15]; 
		 
		 C[8+j*lda] += TempA * TempB[0];
		 C[9+j*lda] += TempA * TempB[1];
		 C[10+j*lda] += TempA * TempB[2];
		 C[11+j*lda] += TempA * TempB[3];
		 C[12+j*lda] += TempA * TempB[4];
		 C[13+j*lda] += TempA * TempB[5];
		 C[14+j*lda] += TempA * TempB[6];
		 C[15+j*lda] += TempA * TempB[7];
		 
		 TempB[0] = B[k*lda+16]; 
		 TempB[1] = B[k*lda+17]; 
		 TempB[2] = B[k*lda+18]; 
		 TempB[3] = B[k*lda+19]; 
		 TempB[4] = B[k*lda+20]; 
		 TempB[5] = B[k*lda+21]; 
		 TempB[6] = B[k*lda+22]; 
		 TempB[7] = B[k*lda+23]; 
		 
		 C[16+j*lda] += TempA * TempB[0];
		 C[17+j*lda] += TempA * TempB[1];
		 C[18+j*lda] += TempA * TempB[2];
		 C[19+j*lda] += TempA * TempB[3];
		 C[20+j*lda] += TempA * TempB[4];
		 C[21+j*lda] += TempA * TempB[5];
		 C[22+j*lda] += TempA * TempB[6];
		 C[23+j*lda] += TempA * TempB[7];
		 
		 TempB[0] = B[k*lda+24]; 
		 TempB[1] = B[k*lda+25]; 
		 TempB[2] = B[k*lda+26]; 
		 TempB[3] = B[k*lda+27]; 
		 TempB[4] = B[k*lda+28]; 
		 TempB[5] = B[k*lda+29]; 
		 TempB[6] = B[k*lda+30]; 
		 TempB[7] = B[k*lda+31]; 
		 
		 C[24+j*lda] += TempA * TempB[0];
		 C[25+j*lda] += TempA * TempB[1];
		 C[26+j*lda] += TempA * TempB[2];
		 C[27+j*lda] += TempA * TempB[3];
		 C[28+j*lda] += TempA * TempB[4];
		 C[29+j*lda] += TempA * TempB[5];
		 C[30+j*lda] += TempA * TempB[6];
		 C[31+j*lda] += TempA * TempB[7];
		 
		

      }
	 }
	}
	
	if(coreid == 1)
	{
	for ( j = 1; j < lda; j+=2 )
     {
      for ( k = 0; k < lda; k++ )  
      {
		 TempA = A[j*lda + k];
		 
		 		 
		 TempB[0] = B[k*lda+24]; 
		 TempB[1] = B[k*lda+25]; 
		 TempB[2] = B[k*lda+26]; 
		 TempB[3] = B[k*lda+27]; 
		 TempB[4] = B[k*lda+28]; 
		 TempB[5] = B[k*lda+29]; 
		 TempB[6] = B[k*lda+30]; 
		 TempB[7] = B[k*lda+31]; 
		 
		 C[24+j*lda] += TempA * TempB[0];
		 C[25+j*lda] += TempA * TempB[1];
		 C[26+j*lda] += TempA * TempB[2];
		 C[27+j*lda] += TempA * TempB[3];
		 C[28+j*lda] += TempA * TempB[4];
		 C[29+j*lda] += TempA * TempB[5];
		 C[30+j*lda] += TempA * TempB[6];
		 C[31+j*lda] += TempA * TempB[7];

		 TempB[0] = B[k*lda+0]; 
		 TempB[1] = B[k*lda+1]; 
		 TempB[2] = B[k*lda+2]; 
		 TempB[3] = B[k*lda+3]; 
		 TempB[4] = B[k*lda+4]; 
		 TempB[5] = B[k*lda+5]; 
		 TempB[6] = B[k*lda+6]; 
		 TempB[7] = B[k*lda+7]; 
		 
		 C[0+j*lda] += TempA * TempB[0];
		 C[1+j*lda] += TempA * TempB[1];
		 C[2+j*lda] += TempA * TempB[2];
		 C[3+j*lda] += TempA * TempB[3];
		 C[4+j*lda] += TempA * TempB[4];
		 C[5+j*lda] += TempA * TempB[5];
		 C[6+j*lda] += TempA * TempB[6];
		 C[7+j*lda] += TempA * TempB[7];

		 TempB[0] = B[k*lda+8]; 
		 TempB[1] = B[k*lda+9]; 
		 TempB[2] = B[k*lda+10]; 
		 TempB[3] = B[k*lda+11]; 
		 TempB[4] = B[k*lda+12]; 
		 TempB[5] = B[k*lda+13]; 
		 TempB[6] = B[k*lda+14]; 
		 TempB[7] = B[k*lda+15]; 
		 
		 C[8+j*lda] += TempA * TempB[0];
		 C[9+j*lda] += TempA * TempB[1];
		 C[10+j*lda] += TempA * TempB[2];
		 C[11+j*lda] += TempA * TempB[3];
		 C[12+j*lda] += TempA * TempB[4];
		 C[13+j*lda] += TempA * TempB[5];
		 C[14+j*lda] += TempA * TempB[6];
		 C[15+j*lda] += TempA * TempB[7];
		 
		 TempB[0] = B[k*lda+16]; 
		 TempB[1] = B[k*lda+17]; 
		 TempB[2] = B[k*lda+18]; 
		 TempB[3] = B[k*lda+19]; 
		 TempB[4] = B[k*lda+20]; 
		 TempB[5] = B[k*lda+21]; 
		 TempB[6] = B[k*lda+22]; 
		 TempB[7] = B[k*lda+23]; 
		 
		 C[16+j*lda] += TempA * TempB[0];
		 C[17+j*lda] += TempA * TempB[1];
		 C[18+j*lda] += TempA * TempB[2];
		 C[19+j*lda] += TempA * TempB[3];
		 C[20+j*lda] += TempA * TempB[4];
		 C[21+j*lda] += TempA * TempB[5];
		 C[22+j*lda] += TempA * TempB[6];
		 C[23+j*lda] += TempA * TempB[7];

		 

		 
		

      }
	 }
	}
   */
 //-------------------------------------------------------------version2.7, use m=l*da, i=k*lda,out of stack, only i, MI 150k, only m, MSI 117.9k slower than v2.0
	/*
	   static __thread int i, j, k, m, n;
	static __thread data_t TempA;
	static __thread data_t TempB[8];
	
	if(coreid == 0)
	{
	for ( j = 0; j < lda; j+=2 )
     { 
		 m = j * lda;
      for ( k = 0; k < lda; k++ )  
      {
		 TempA = A[m+ k];
		for( n = 0; n < 4; n++)
		{

		 TempB[0] = B[k *lda+0+8*n]; 
		 TempB[1] = B[k *lda+1+8*n]; 
		 TempB[2] = B[k *lda+2+8*n]; 
		 TempB[3] = B[k *lda+3+8*n]; 
		 TempB[4] = B[k *lda+4+8*n]; 
		 TempB[5] = B[k *lda+5+8*n]; 
		 TempB[6] = B[k *lda+6+8*n]; 
		 TempB[7] = B[k *lda+7+8*n]; 
		 
		 C[0+8*n+m] += TempA * TempB[0];
		 C[1+8*n+m] += TempA * TempB[1];
		 C[2+8*n+m] += TempA * TempB[2];
		 C[3+8*n+m] += TempA * TempB[3];
		 C[4+8*n+m] += TempA * TempB[4];
		 C[5+8*n+m] += TempA * TempB[5];
		 C[6+8*n+m] += TempA * TempB[6];
		 C[7+8*n+m] += TempA * TempB[7];
		 
		}

      }
	 }
	}
if(coreid == 1)
	{
	for ( j = 1; j < lda; j+=2 )
     { 
		 m = j * lda;
      for ( k = 0; k < lda; k++ )  
      {
		 TempA = A[m+ k];
		for( n = 0; n < 4; n++)
		{

		 TempB[0] = B[k *lda+0+8*n]; 
		 TempB[1] = B[k *lda+1+8*n]; 
		 TempB[2] = B[k *lda+2+8*n]; 
		 TempB[3] = B[k *lda+3+8*n]; 
		 TempB[4] = B[k *lda+4+8*n]; 
		 TempB[5] = B[k *lda+5+8*n]; 
		 TempB[6] = B[k *lda+6+8*n]; 
		 TempB[7] = B[k *lda+7+8*n]; 
		 
		 C[0+8*n+m] += TempA * TempB[0];
		 C[1+8*n+m] += TempA * TempB[1];
		 C[2+8*n+m] += TempA * TempB[2];
		 C[3+8*n+m] += TempA * TempB[3];
		 C[4+8*n+m] += TempA * TempB[4];
		 C[5+8*n+m] += TempA * TempB[5];
		 C[6+8*n+m] += TempA * TempB[6];
		 C[7+8*n+m] += TempA * TempB[7];
		 
		}

      }
	 }
	}
	*/
//-------------------------------------------------------------version2.8 deal with false sharing, MSI,118K vs v2.0 117.0K. MI 147.629K. 
/*	
static __thread int i, j, k, m, n;
	static __thread data_t TempA;
	static __thread data_t TempB[8];
	
	if(coreid == 0)
	{
	for ( j = 0; j < lda; j+=2 )
     {
      for ( k = 0; k < lda; k++ )  
      {
		 TempA = A[j*lda + k];
		for( n = 0; n < 2; n++)
		{

		 TempB[0] = B[k*lda+0+16*n]; 
		 TempB[1] = B[k*lda+1+16*n]; 
		 TempB[2] = B[k*lda+2+16*n]; 
		 TempB[3] = B[k*lda+3+16*n];
		 TempB[4] = B[k*lda+4+16*n]; 
		 TempB[5] = B[k*lda+5+16*n]; 
		 TempB[6] = B[k*lda+6+16*n]; 
		 TempB[7] = B[k*lda+7+16*n]; 


		 
		 C[0+16*n+j*lda] += TempA * TempB[0];
		 C[1+16*n+j*lda] += TempA * TempB[1];
		 C[2+16*n+j*lda] += TempA * TempB[2];
		 C[3+16*n+j*lda] += TempA * TempB[3];
		 C[4+16*n+j*lda] += TempA * TempB[4];
		 C[5+16*n+j*lda] += TempA * TempB[5];
		 C[6+16*n+j*lda] += TempA * TempB[6];
		 C[7+16*n+j*lda] += TempA * TempB[7];
		 
		 TempB[0] = B[k*lda+8+16*n]; 
		 TempB[1] = B[k*lda+9+16*n]; 
		 TempB[2] = B[k*lda+10+16*n]; 
		 TempB[3] = B[k*lda+11+16*n]; 
		 TempB[4] = B[k*lda+12+16*n]; 
		 TempB[5] = B[k*lda+13+16*n]; 
		 TempB[6] = B[k*lda+14+16*n]; 
		 TempB[7] = B[k*lda+15+16*n]; 
		 
		 C[8+16*n+j*lda] += TempA * TempB[0];
		 C[9+16*n+j*lda] += TempA * TempB[1];
		 C[10+16*n+j*lda] += TempA * TempB[2];
		 C[11+16*n+j*lda] += TempA * TempB[3];
		 C[12+16*n+j*lda] += TempA * TempB[4];
		 C[13+16*n+j*lda] += TempA * TempB[5];
		 C[14+16*n+j*lda] += TempA * TempB[6];
		 C[15+16*n+j*lda] += TempA * TempB[7];
		 
	
		 
		}

      }
	 }
	}
		if(coreid == 1)
	{
	for ( j = 1; j < lda; j+=2 )
     {
      for ( k = 0; k < lda; k++ )  
      {
		 TempA = A[j*lda + k];
		for( n = 0; n < 2; n++)
		{


		 
		 TempB[0] = B[k*lda+8+16*n]; 
		 TempB[1] = B[k*lda+9+16*n]; 
		 TempB[2] = B[k*lda+10+16*n]; 
		 TempB[3] = B[k*lda+11+16*n]; 
		 TempB[4] = B[k*lda+12+16*n]; 
		 TempB[5] = B[k*lda+13+16*n]; 
		 TempB[6] = B[k*lda+14+16*n]; 
		 TempB[7] = B[k*lda+15+16*n]; 
		 
		 C[8+16*n+j*lda] += TempA * TempB[0];
		 C[9+16*n+j*lda] += TempA * TempB[1];
		 C[10+16*n+j*lda] += TempA * TempB[2];
		 C[11+16*n+j*lda] += TempA * TempB[3];
		 C[12+16*n+j*lda] += TempA * TempB[4];
		 C[13+16*n+j*lda] += TempA * TempB[5];
		 C[14+16*n+j*lda] += TempA * TempB[6];
		 C[15+16*n+j*lda] += TempA * TempB[7];
		 
		 TempB[0] = B[k*lda+0+16*n]; 
		 TempB[1] = B[k*lda+1+16*n]; 
		 TempB[2] = B[k*lda+2+16*n]; 
		 TempB[3] = B[k*lda+3+16*n];
		 TempB[4] = B[k*lda+4+16*n]; 
		 TempB[5] = B[k*lda+5+16*n]; 
		 TempB[6] = B[k*lda+6+16*n]; 
		 TempB[7] = B[k*lda+7+16*n]; 


		 
		 C[0+16*n+j*lda] += TempA * TempB[0];
		 C[1+16*n+j*lda] += TempA * TempB[1];
		 C[2+16*n+j*lda] += TempA * TempB[2];
		 C[3+16*n+j*lda] += TempA * TempB[3];
		 C[4+16*n+j*lda] += TempA * TempB[4];
		 C[5+16*n+j*lda] += TempA * TempB[5];
		 C[6+16*n+j*lda] += TempA * TempB[6];
		 C[7+16*n+j*lda] += TempA * TempB[7];
	
		 
		}

      }
	 }
	}
	*/
	
	//----------------------------------------------------------------version 2.11 optmize j,use core 1 j from 0 to 15 MSI 98k i = j*lda
	//----------------------------------------------------------------version 2.12 not use i = j *lda MSI  95k
	/*
	static __thread data_t TempA[8];
	static __thread data_t TempB[8];
	static __thread int j,m,n,i,k;
	
	if(coreid == 1)
	{
	for ( j = 16; j < 32; j++ )
     {		
		  
      for ( m = 0; m < 4; m++ )  
      {
		  
		 TempA[0] = A[j*lda+0+8*m];
		 TempA[1] = A[j*lda+1+8*m];
		 TempA[2] = A[j*lda+2+8*m];
		 TempA[3] = A[j*lda+3+8*m];
		 TempA[4] = A[j*lda+4+8*m];
		 TempA[5] = A[j*lda+5+8*m];
		 TempA[6] = A[j*lda+6+8*m];
		 TempA[7] = A[j*lda+7+8*m];
		 
		for( n = 0; n < 4; n++)
		{
	
		 TempB[0] = B[(0+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(0+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(0+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(0+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(0+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(0+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(0+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(0+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[0] * TempB[0];
		 C[1+8*n+j*lda] += TempA[0] * TempB[1];
		 C[2+8*n+j*lda] += TempA[0] * TempB[2];
		 C[3+8*n+j*lda] += TempA[0] * TempB[3];
		 C[4+8*n+j*lda] += TempA[0] * TempB[4];
		 C[5+8*n+j*lda] += TempA[0] * TempB[5];
		 C[6+8*n+j*lda] += TempA[0] * TempB[6];
		 C[7+8*n+j*lda] += TempA[0] * TempB[7];
		 


		 TempB[0] = B[(1+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(1+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(1+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(1+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(1+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(1+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(1+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(1+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[1] * TempB[0];
		 C[1+8*n+j*lda] += TempA[1] * TempB[1];
		 C[2+8*n+j*lda] += TempA[1] * TempB[2];
		 C[3+8*n+j*lda] += TempA[1] * TempB[3];
		 C[4+8*n+j*lda] += TempA[1] * TempB[4];
		 C[5+8*n+j*lda] += TempA[1] * TempB[5];
		 C[6+8*n+j*lda] += TempA[1] * TempB[6];
		 C[7+8*n+j*lda] += TempA[1] * TempB[7];
		 


		 TempB[0] = B[(2+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(2+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(2+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(2+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(2+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(2+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(2+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(2+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[2] * TempB[0];
		 C[1+8*n+j*lda] += TempA[2] * TempB[1];
		 C[2+8*n+j*lda] += TempA[2] * TempB[2];
		 C[3+8*n+j*lda] += TempA[2] * TempB[3];
		 C[4+8*n+j*lda] += TempA[2] * TempB[4];
		 C[5+8*n+j*lda] += TempA[2] * TempB[5];
		 C[6+8*n+j*lda] += TempA[2] * TempB[6];
		 C[7+8*n+j*lda] += TempA[2] * TempB[7];
		 


		 TempB[0] = B[(3+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(3+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(3+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(3+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(3+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(3+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(3+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(3+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[3] * TempB[0];
		 C[1+8*n+j*lda] += TempA[3] * TempB[1];
		 C[2+8*n+j*lda] += TempA[3] * TempB[2];
		 C[3+8*n+j*lda] += TempA[3] * TempB[3];
		 C[4+8*n+j*lda] += TempA[3] * TempB[4];
		 C[5+8*n+j*lda] += TempA[3] * TempB[5];
		 C[6+8*n+j*lda] += TempA[3] * TempB[6];
		 C[7+8*n+j*lda] += TempA[3] * TempB[7];


		 TempB[0] = B[(4+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(4+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(4+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(4+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(4+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(4+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(4+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(4+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[4] * TempB[0];
		 C[1+8*n+j*lda] += TempA[4] * TempB[1];
		 C[2+8*n+j*lda] += TempA[4] * TempB[2];
		 C[3+8*n+j*lda] += TempA[4] * TempB[3];
		 C[4+8*n+j*lda] += TempA[4] * TempB[4];
		 C[5+8*n+j*lda] += TempA[4] * TempB[5];
		 C[6+8*n+j*lda] += TempA[4] * TempB[6];
		 C[7+8*n+j*lda] += TempA[4] * TempB[7];
		 


		 TempB[0] = B[(5+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(5+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(5+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(5+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(5+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(5+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(5+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(5+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[5] * TempB[0];
		 C[1+8*n+j*lda] += TempA[5] * TempB[1];
		 C[2+8*n+j*lda] += TempA[5] * TempB[2];
		 C[3+8*n+j*lda] += TempA[5] * TempB[3];
		 C[4+8*n+j*lda] += TempA[5] * TempB[4];
		 C[5+8*n+j*lda] += TempA[5] * TempB[5];
		 C[6+8*n+j*lda] += TempA[5] * TempB[6];
		 C[7+8*n+j*lda] += TempA[5] * TempB[7];
		 


		 TempB[0] = B[(6+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(6+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(6+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(6+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(6+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(6+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(6+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(6+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[6] * TempB[0];
		 C[1+8*n+j*lda] += TempA[6] * TempB[1];
		 C[2+8*n+j*lda] += TempA[6] * TempB[2];
		 C[3+8*n+j*lda] += TempA[6] * TempB[3];
		 C[4+8*n+j*lda] += TempA[6] * TempB[4];
		 C[5+8*n+j*lda] += TempA[6] * TempB[5];
		 C[6+8*n+j*lda] += TempA[6] * TempB[6];
		 C[7+8*n+j*lda] += TempA[6] * TempB[7];


		 TempB[0] = B[(7+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(7+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(7+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(7+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(7+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(7+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(7+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(7+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[7] * TempB[0];
		 C[1+8*n+j*lda] += TempA[7] * TempB[1];
		 C[2+8*n+j*lda] += TempA[7] * TempB[2];
		 C[3+8*n+j*lda] += TempA[7] * TempB[3];
		 C[4+8*n+j*lda] += TempA[7] * TempB[4];
		 C[5+8*n+j*lda] += TempA[7] * TempB[5];
		 C[6+8*n+j*lda] += TempA[7] * TempB[6];
		 C[7+8*n+j*lda] += TempA[7] * TempB[7];
		}

      }
	 }
	}
	if(coreid ==0)
		{
	for ( j = 0; j < 16; j++ )
     {		
		  
      for ( m = 0; m < 4; m++ )  
      {
		  
		 TempA[0] = A[j*lda+0+8*m];
		 TempA[1] = A[j*lda+1+8*m];
		 TempA[2] = A[j*lda+2+8*m];
		 TempA[3] = A[j*lda+3+8*m];
		 TempA[4] = A[j*lda+4+8*m];
		 TempA[5] = A[j*lda+5+8*m];
		 TempA[6] = A[j*lda+6+8*m];
		 TempA[7] = A[j*lda+7+8*m];
		 
		for( n = 0; n < 4; n++)
		{
		
		 TempB[0] = B[(0+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(0+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(0+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(0+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(0+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(0+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(0+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(0+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[0] * TempB[0];
		 C[1+8*n+j*lda] += TempA[0] * TempB[1];
		 C[2+8*n+j*lda] += TempA[0] * TempB[2];
		 C[3+8*n+j*lda] += TempA[0] * TempB[3];
		 C[4+8*n+j*lda] += TempA[0] * TempB[4];
		 C[5+8*n+j*lda] += TempA[0] * TempB[5];
		 C[6+8*n+j*lda] += TempA[0] * TempB[6];
		 C[7+8*n+j*lda] += TempA[0] * TempB[7];
		 


		 TempB[0] = B[(1+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(1+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(1+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(1+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(1+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(1+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(1+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(1+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[1] * TempB[0];
		 C[1+8*n+j*lda] += TempA[1] * TempB[1];
		 C[2+8*n+j*lda] += TempA[1] * TempB[2];
		 C[3+8*n+j*lda] += TempA[1] * TempB[3];
		 C[4+8*n+j*lda] += TempA[1] * TempB[4];
		 C[5+8*n+j*lda] += TempA[1] * TempB[5];
		 C[6+8*n+j*lda] += TempA[1] * TempB[6];
		 C[7+8*n+j*lda] += TempA[1] * TempB[7];
		 


		 TempB[0] = B[(2+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(2+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(2+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(2+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(2+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(2+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(2+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(2+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[2] * TempB[0];
		 C[1+8*n+j*lda] += TempA[2] * TempB[1];
		 C[2+8*n+j*lda] += TempA[2] * TempB[2];
		 C[3+8*n+j*lda] += TempA[2] * TempB[3];
		 C[4+8*n+j*lda] += TempA[2] * TempB[4];
		 C[5+8*n+j*lda] += TempA[2] * TempB[5];
		 C[6+8*n+j*lda] += TempA[2] * TempB[6];
		 C[7+8*n+j*lda] += TempA[2] * TempB[7];
		 


		 TempB[0] = B[(3+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(3+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(3+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(3+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(3+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(3+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(3+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(3+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[3] * TempB[0];
		 C[1+8*n+j*lda] += TempA[3] * TempB[1];
		 C[2+8*n+j*lda] += TempA[3] * TempB[2];
		 C[3+8*n+j*lda] += TempA[3] * TempB[3];
		 C[4+8*n+j*lda] += TempA[3] * TempB[4];
		 C[5+8*n+j*lda] += TempA[3] * TempB[5];
		 C[6+8*n+j*lda] += TempA[3] * TempB[6];
		 C[7+8*n+j*lda] += TempA[3] * TempB[7];


		 TempB[0] = B[(4+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(4+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(4+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(4+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(4+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(4+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(4+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(4+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[4] * TempB[0];
		 C[1+8*n+j*lda] += TempA[4] * TempB[1];
		 C[2+8*n+j*lda] += TempA[4] * TempB[2];
		 C[3+8*n+j*lda] += TempA[4] * TempB[3];
		 C[4+8*n+j*lda] += TempA[4] * TempB[4];
		 C[5+8*n+j*lda] += TempA[4] * TempB[5];
		 C[6+8*n+j*lda] += TempA[4] * TempB[6];
		 C[7+8*n+j*lda] += TempA[4] * TempB[7];
		 


		 TempB[0] = B[(5+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(5+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(5+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(5+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(5+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(5+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(5+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(5+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[5] * TempB[0];
		 C[1+8*n+j*lda] += TempA[5] * TempB[1];
		 C[2+8*n+j*lda] += TempA[5] * TempB[2];
		 C[3+8*n+j*lda] += TempA[5] * TempB[3];
		 C[4+8*n+j*lda] += TempA[5] * TempB[4];
		 C[5+8*n+j*lda] += TempA[5] * TempB[5];
		 C[6+8*n+j*lda] += TempA[5] * TempB[6];
		 C[7+8*n+j*lda] += TempA[5] * TempB[7];
		 


		 TempB[0] = B[(6+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(6+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(6+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(6+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(6+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(6+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(6+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(6+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[6] * TempB[0];
		 C[1+8*n+j*lda] += TempA[6] * TempB[1];
		 C[2+8*n+j*lda] += TempA[6] * TempB[2];
		 C[3+8*n+j*lda] += TempA[6] * TempB[3];
		 C[4+8*n+j*lda] += TempA[6] * TempB[4];
		 C[5+8*n+j*lda] += TempA[6] * TempB[5];
		 C[6+8*n+j*lda] += TempA[6] * TempB[6];
		 C[7+8*n+j*lda] += TempA[6] * TempB[7];


		 TempB[0] = B[(7+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(7+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(7+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(7+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(7+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(7+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(7+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(7+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[7] * TempB[0];
		 C[1+8*n+j*lda] += TempA[7] * TempB[1];
		 C[2+8*n+j*lda] += TempA[7] * TempB[2];
		 C[3+8*n+j*lda] += TempA[7] * TempB[3];
		 C[4+8*n+j*lda] += TempA[7] * TempB[4];
		 C[5+8*n+j*lda] += TempA[7] * TempB[5];
		 C[6+8*n+j*lda] += TempA[7] * TempB[6];
		 C[7+8*n+j*lda] += TempA[7] * TempB[7];
		}

      }
	 }
	}
	*/
	//-----------------------------------------------------------------version 2.14 optimize C. when tempc[8] inside n loop, MSI, 98K MI,158k
	//-----------------------------------------------------------------version 2.15 optimize v2.14 a little MSI 89k. MI, 161K. don't decare tempc[8]=0 in the loop
	/*
	static __thread data_t TempA[8];
	static __thread data_t TempB[8];
	static __thread data_t TempC[8];
	static __thread int j,m,n,i,k;
	
	if(coreid == 1)
	{
	for ( j = 16; j < 32; j++ )
     {		
		  
      for ( m = 0; m < 4; m++ )  
      {
		  
		 TempA[0] = A[j*lda+0+8*m];
		 TempA[1] = A[j*lda+1+8*m];
		 TempA[2] = A[j*lda+2+8*m];
		 TempA[3] = A[j*lda+3+8*m];
		 TempA[4] = A[j*lda+4+8*m];
		 TempA[5] = A[j*lda+5+8*m];
		 TempA[6] = A[j*lda+6+8*m];
		 TempA[7] = A[j*lda+7+8*m];
		 

		 
		for( n = 0; n < 4; n++)
		{
	     
		 
		 TempB[0] = B[(0+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(0+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(0+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(0+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(0+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(0+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(0+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(0+8*m)*lda+7+8*n]; 
		 
		 
		 TempC[0] = TempA[0] * TempB[0];
		 TempC[1] = TempA[0] * TempB[1];
		 TempC[2] = TempA[0] * TempB[2];
		 TempC[3] = TempA[0] * TempB[3];
		 TempC[4] = TempA[0] * TempB[4];
		 TempC[5] = TempA[0] * TempB[5];
		 TempC[6] = TempA[0] * TempB[6];
		 TempC[7] = TempA[0] * TempB[7];
		 


		 TempB[0] = B[(1+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(1+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(1+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(1+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(1+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(1+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(1+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(1+8*m)*lda+7+8*n]; 
		 
		 TempC[0] += TempA[1] * TempB[0];
		 TempC[1] += TempA[1] * TempB[1];
		 TempC[2] += TempA[1] * TempB[2];
		 TempC[3] += TempA[1] * TempB[3];
		 TempC[4] += TempA[1] * TempB[4];
		 TempC[5] += TempA[1] * TempB[5];
		 TempC[6] += TempA[1] * TempB[6];
		 TempC[7] += TempA[1] * TempB[7];
		 


		 TempB[0] = B[(2+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(2+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(2+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(2+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(2+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(2+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(2+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(2+8*m)*lda+7+8*n]; 
		 
		 TempC[0] += TempA[2] * TempB[0];
		 TempC[1] += TempA[2] * TempB[1];
		 TempC[2] += TempA[2] * TempB[2];
		 TempC[3] += TempA[2] * TempB[3];
		 TempC[4] += TempA[2] * TempB[4];
		 TempC[5] += TempA[2] * TempB[5];
		 TempC[6] += TempA[2] * TempB[6];
		 TempC[7] += TempA[2] * TempB[7];
		 


		 TempB[0] = B[(3+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(3+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(3+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(3+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(3+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(3+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(3+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(3+8*m)*lda+7+8*n]; 
		 
		 TempC[0] += TempA[3] * TempB[0];
		 TempC[1] += TempA[3] * TempB[1];
		 TempC[2] += TempA[3] * TempB[2];
		 TempC[3] += TempA[3] * TempB[3];
		 TempC[4] += TempA[3] * TempB[4];
		 TempC[5] += TempA[3] * TempB[5];
		 TempC[6] += TempA[3] * TempB[6];
		 TempC[7] += TempA[3] * TempB[7];


		 TempB[0] = B[(4+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(4+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(4+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(4+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(4+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(4+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(4+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(4+8*m)*lda+7+8*n]; 
		 
		 TempC[0] += TempA[4] * TempB[0];
		 TempC[1] += TempA[4] * TempB[1];
		 TempC[2] += TempA[4] * TempB[2];
		 TempC[3] += TempA[4] * TempB[3];
		 TempC[4] += TempA[4] * TempB[4];
		 TempC[5] += TempA[4] * TempB[5];
		 TempC[6] += TempA[4] * TempB[6];
		 TempC[7] += TempA[4] * TempB[7];
		 


		 TempB[0] = B[(5+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(5+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(5+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(5+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(5+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(5+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(5+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(5+8*m)*lda+7+8*n]; 
		 
		 TempC[0] += TempA[5] * TempB[0];
		 TempC[1] += TempA[5] * TempB[1];
		 TempC[2] += TempA[5] * TempB[2];
		 TempC[3] += TempA[5] * TempB[3];
		 TempC[4] += TempA[5] * TempB[4];
		 TempC[5] += TempA[5] * TempB[5];
		 TempC[6] += TempA[5] * TempB[6];
		 TempC[7] += TempA[5] * TempB[7];
		 


		 TempB[0] = B[(6+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(6+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(6+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(6+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(6+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(6+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(6+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(6+8*m)*lda+7+8*n]; 
		 
		 TempC[0] += TempA[6] * TempB[0];
		 TempC[1] += TempA[6] * TempB[1];
		 TempC[2] += TempA[6] * TempB[2];
		 TempC[3] += TempA[6] * TempB[3];
		 TempC[4] += TempA[6] * TempB[4];
		 TempC[5] += TempA[6] * TempB[5];
		 TempC[6] += TempA[6] * TempB[6];
		 TempC[7] += TempA[6] * TempB[7];


		 TempB[0] = B[(7+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(7+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(7+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(7+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(7+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(7+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(7+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(7+8*m)*lda+7+8*n]; 
		 
		 TempC[0] += TempA[7] * TempB[0];
		 TempC[1] += TempA[7] * TempB[1];
		 TempC[2] += TempA[7] * TempB[2];
		 TempC[3] += TempA[7] * TempB[3];
		 TempC[4] += TempA[7] * TempB[4];
		 TempC[5] += TempA[7] * TempB[5];
		 TempC[6] += TempA[7] * TempB[6];
		 TempC[7] += TempA[7] * TempB[7];
		 

		
		 C[0+8*n+j*lda] += TempC[0];
		 C[1+8*n+j*lda] += TempC[1];
		 C[2+8*n+j*lda] += TempC[2];
		 C[3+8*n+j*lda] += TempC[3];
		 C[4+8*n+j*lda] += TempC[4];
		 C[5+8*n+j*lda] += TempC[5];
		 C[6+8*n+j*lda] += TempC[6];
		 C[7+8*n+j*lda] += TempC[7];
		 }
      }
	 }
	}
		if(coreid == 0)
	{
	for ( j = 0; j < 16; j++ )
     {		
		  
      for ( m = 0; m < 4; m++ )  
      {
		  
		 TempA[0] = A[j*lda+0+8*m];
		 TempA[1] = A[j*lda+1+8*m];
		 TempA[2] = A[j*lda+2+8*m];
		 TempA[3] = A[j*lda+3+8*m];
		 TempA[4] = A[j*lda+4+8*m];
		 TempA[5] = A[j*lda+5+8*m];
		 TempA[6] = A[j*lda+6+8*m];
		 TempA[7] = A[j*lda+7+8*m];
		 
		for( n = 0; n < 4; n++)
		{

		 
		 TempB[0] = B[(0+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(0+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(0+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(0+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(0+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(0+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(0+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(0+8*m)*lda+7+8*n]; 
		 
		 
		 TempC[0] = TempA[0] * TempB[0];
		 TempC[1] = TempA[0] * TempB[1];
		 TempC[2] = TempA[0] * TempB[2];
		 TempC[3] = TempA[0] * TempB[3];
		 TempC[4] = TempA[0] * TempB[4];
		 TempC[5] = TempA[0] * TempB[5];
		 TempC[6] = TempA[0] * TempB[6];
		 TempC[7] = TempA[0] * TempB[7];
		 


		 TempB[0] = B[(1+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(1+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(1+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(1+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(1+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(1+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(1+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(1+8*m)*lda+7+8*n]; 
		 
		 TempC[0] += TempA[1] * TempB[0];
		 TempC[1] += TempA[1] * TempB[1];
		 TempC[2] += TempA[1] * TempB[2];
		 TempC[3] += TempA[1] * TempB[3];
		 TempC[4] += TempA[1] * TempB[4];
		 TempC[5] += TempA[1] * TempB[5];
		 TempC[6] += TempA[1] * TempB[6];
		 TempC[7] += TempA[1] * TempB[7];
		 


		 TempB[0] = B[(2+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(2+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(2+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(2+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(2+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(2+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(2+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(2+8*m)*lda+7+8*n]; 
		 
		 TempC[0] += TempA[2] * TempB[0];
		 TempC[1] += TempA[2] * TempB[1];
		 TempC[2] += TempA[2] * TempB[2];
		 TempC[3] += TempA[2] * TempB[3];
		 TempC[4] += TempA[2] * TempB[4];
		 TempC[5] += TempA[2] * TempB[5];
		 TempC[6] += TempA[2] * TempB[6];
		 TempC[7] += TempA[2] * TempB[7];
		 


		 TempB[0] = B[(3+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(3+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(3+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(3+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(3+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(3+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(3+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(3+8*m)*lda+7+8*n]; 
		 
		 TempC[0] += TempA[3] * TempB[0];
		 TempC[1] += TempA[3] * TempB[1];
		 TempC[2] += TempA[3] * TempB[2];
		 TempC[3] += TempA[3] * TempB[3];
		 TempC[4] += TempA[3] * TempB[4];
		 TempC[5] += TempA[3] * TempB[5];
		 TempC[6] += TempA[3] * TempB[6];
		 TempC[7] += TempA[3] * TempB[7];


		 TempB[0] = B[(4+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(4+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(4+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(4+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(4+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(4+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(4+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(4+8*m)*lda+7+8*n]; 
		 
		 TempC[0] += TempA[4] * TempB[0];
		 TempC[1] += TempA[4] * TempB[1];
		 TempC[2] += TempA[4] * TempB[2];
		 TempC[3] += TempA[4] * TempB[3];
		 TempC[4] += TempA[4] * TempB[4];
		 TempC[5] += TempA[4] * TempB[5];
		 TempC[6] += TempA[4] * TempB[6];
		 TempC[7] += TempA[4] * TempB[7];
		 


		 TempB[0] = B[(5+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(5+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(5+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(5+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(5+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(5+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(5+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(5+8*m)*lda+7+8*n]; 
		 
		 TempC[0] += TempA[5] * TempB[0];
		 TempC[1] += TempA[5] * TempB[1];
		 TempC[2] += TempA[5] * TempB[2];
		 TempC[3] += TempA[5] * TempB[3];
		 TempC[4] += TempA[5] * TempB[4];
		 TempC[5] += TempA[5] * TempB[5];
		 TempC[6] += TempA[5] * TempB[6];
		 TempC[7] += TempA[5] * TempB[7];
		 


		 TempB[0] = B[(6+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(6+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(6+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(6+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(6+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(6+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(6+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(6+8*m)*lda+7+8*n]; 
		 
		 TempC[0] += TempA[6] * TempB[0];
		 TempC[1] += TempA[6] * TempB[1];
		 TempC[2] += TempA[6] * TempB[2];
		 TempC[3] += TempA[6] * TempB[3];
		 TempC[4] += TempA[6] * TempB[4];
		 TempC[5] += TempA[6] * TempB[5];
		 TempC[6] += TempA[6] * TempB[6];
		 TempC[7] += TempA[6] * TempB[7];


		 TempB[0] = B[(7+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(7+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(7+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(7+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(7+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(7+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(7+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(7+8*m)*lda+7+8*n]; 
		 
		 TempC[0] += TempA[7] * TempB[0];
		 TempC[1] += TempA[7] * TempB[1];
		 TempC[2] += TempA[7] * TempB[2];
		 TempC[3] += TempA[7] * TempB[3];
		 TempC[4] += TempA[7] * TempB[4];
		 TempC[5] += TempA[7] * TempB[5];
		 TempC[6] += TempA[7] * TempB[6];
		 TempC[7] += TempA[7] * TempB[7];
		 
		 C[0+8*n+j*lda] += TempC[0];
		 C[1+8*n+j*lda] += TempC[1];
		 C[2+8*n+j*lda] += TempC[2];
		 C[3+8*n+j*lda] += TempC[3];
		 C[4+8*n+j*lda] += TempC[4];
		 C[5+8*n+j*lda] += TempC[5];
		 C[6+8*n+j*lda] += TempC[6];
		 C[7+8*n+j*lda] += TempC[7];
		}

      }
	 }
	}
	*/
	//-----------------------------------------------------------------version 2.16, optimize v2.15 get rid of tempb. MSI 83K.w/ test one 81K.

	
	static __thread data_t TempA[8];
	static __thread data_t TempB[8];
	static __thread data_t TempC[8];
	static __thread int j,m,n;
	
			if(coreid == 1)
	{
	for ( j = 16; j < 32; j++ )
     {		
		  
      for ( m = 0; m < 4; m++ )  
      {
		  
		 TempA[0] = A[j*lda+0+8*m];
		 TempA[1] = A[j*lda+1+8*m];
		 TempA[2] = A[j*lda+2+8*m];
		 TempA[3] = A[j*lda+3+8*m];
		 TempA[4] = A[j*lda+4+8*m];
		 TempA[5] = A[j*lda+5+8*m];
		 TempA[6] = A[j*lda+6+8*m];
		 TempA[7] = A[j*lda+7+8*m];
		 

		 
		for( n = 0; n < 4; n++)
		{
	     
		 

		 
		 
		 TempC[0] = TempA[0] * B[(0+8*m)*lda+0+8*n]; 
		 TempC[1] = TempA[0] * B[(0+8*m)*lda+1+8*n]; 
		 TempC[2] = TempA[0] * B[(0+8*m)*lda+2+8*n]; 
		 TempC[3] = TempA[0] * B[(0+8*m)*lda+3+8*n]; 
		 TempC[4] = TempA[0] * B[(0+8*m)*lda+4+8*n]; 
		 TempC[5] = TempA[0] * B[(0+8*m)*lda+5+8*n]; 
		 TempC[6] = TempA[0] * B[(0+8*m)*lda+6+8*n]; 
		 TempC[7] = TempA[0] * B[(0+8*m)*lda+7+8*n]; 
		 
		 
		 TempC[0] += TempA[1] * B[(1+8*m)*lda+0+8*n]; 
		 TempC[1] += TempA[1] * B[(1+8*m)*lda+1+8*n]; 
		 TempC[2] += TempA[1] * B[(1+8*m)*lda+2+8*n]; 
		 TempC[3] += TempA[1] * B[(1+8*m)*lda+3+8*n]; 
		 TempC[4] += TempA[1] * B[(1+8*m)*lda+4+8*n]; 
		 TempC[5] += TempA[1] * B[(1+8*m)*lda+5+8*n]; 
		 TempC[6] += TempA[1] * B[(1+8*m)*lda+6+8*n]; 
		 TempC[7] += TempA[1] * B[(1+8*m)*lda+7+8*n]; 
		 


		 TempC[0] += TempA[2] * B[(2+8*m)*lda+0+8*n]; 
		 TempC[1] += TempA[2] * B[(2+8*m)*lda+1+8*n]; 
		 TempC[2] += TempA[2] * B[(2+8*m)*lda+2+8*n]; 
		 TempC[3] += TempA[2] * B[(2+8*m)*lda+3+8*n]; 
		 TempC[4] += TempA[2] * B[(2+8*m)*lda+4+8*n]; 
		 TempC[5] += TempA[2] * B[(2+8*m)*lda+5+8*n]; 
		 TempC[6] += TempA[2] * B[(2+8*m)*lda+6+8*n]; 
		 TempC[7] += TempA[2] * B[(2+8*m)*lda+7+8*n]; 
		 


		 TempC[0] += TempA[3] * B[(3+8*m)*lda+0+8*n]; 
		 TempC[1] += TempA[3] * B[(3+8*m)*lda+1+8*n]; 
		 TempC[2] += TempA[3] * B[(3+8*m)*lda+2+8*n]; 
		 TempC[3] += TempA[3] * B[(3+8*m)*lda+3+8*n]; 
		 TempC[4] += TempA[3] * B[(3+8*m)*lda+4+8*n]; 
		 TempC[5] += TempA[3] * B[(3+8*m)*lda+5+8*n]; 
		 TempC[6] += TempA[3] * B[(3+8*m)*lda+6+8*n]; 
		 TempC[7] += TempA[3] * B[(3+8*m)*lda+7+8*n]; 

		 TempC[0] += TempA[4] * B[(4+8*m)*lda+0+8*n]; 
		 TempC[1] += TempA[4] * B[(4+8*m)*lda+1+8*n]; 
		 TempC[2] += TempA[4] * B[(4+8*m)*lda+2+8*n]; 
		 TempC[3] += TempA[4] * B[(4+8*m)*lda+3+8*n]; 
		 TempC[4] += TempA[4] * B[(4+8*m)*lda+4+8*n]; 
		 TempC[5] += TempA[4] * B[(4+8*m)*lda+5+8*n]; 
		 TempC[6] += TempA[4] * B[(4+8*m)*lda+6+8*n]; 
		 TempC[7] += TempA[4] * B[(4+8*m)*lda+7+8*n]; 


		 TempC[0] += TempA[5] * B[(5+8*m)*lda+0+8*n]; 
		 TempC[1] += TempA[5] * B[(5+8*m)*lda+1+8*n]; 
		 TempC[2] += TempA[5] * B[(5+8*m)*lda+2+8*n]; 
		 TempC[3] += TempA[5] * B[(5+8*m)*lda+3+8*n]; 
		 TempC[4] += TempA[5] * B[(5+8*m)*lda+4+8*n]; 
		 TempC[5] += TempA[5] * B[(5+8*m)*lda+5+8*n]; 
		 TempC[6] += TempA[5] * B[(5+8*m)*lda+6+8*n]; 
		 TempC[7] += TempA[5] * B[(5+8*m)*lda+7+8*n]; 
		 


		 TempC[0] += TempA[6] * B[(6+8*m)*lda+0+8*n]; 
		 TempC[1] += TempA[6] * B[(6+8*m)*lda+1+8*n]; 
		 TempC[2] += TempA[6] * B[(6+8*m)*lda+2+8*n]; 
		 TempC[3] += TempA[6] * B[(6+8*m)*lda+3+8*n]; 
		 TempC[4] += TempA[6] * B[(6+8*m)*lda+4+8*n]; 
		 TempC[5] += TempA[6] * B[(6+8*m)*lda+5+8*n]; 
		 TempC[6] += TempA[6] * B[(6+8*m)*lda+6+8*n]; 
		 TempC[7] += TempA[6] * B[(6+8*m)*lda+7+8*n]; 


		 TempC[0] += TempA[7] * B[(7+8*m)*lda+0+8*n]; 
		 TempC[1] += TempA[7] * B[(7+8*m)*lda+1+8*n]; 
		 TempC[2] += TempA[7] * B[(7+8*m)*lda+2+8*n]; 
		 TempC[3] += TempA[7] * B[(7+8*m)*lda+3+8*n]; 
		 TempC[4] += TempA[7] * B[(7+8*m)*lda+4+8*n]; 
		 TempC[5] += TempA[7] * B[(7+8*m)*lda+5+8*n]; 
		 TempC[6] += TempA[7] * B[(7+8*m)*lda+6+8*n]; 
		 TempC[7] += TempA[7] * B[(7+8*m)*lda+7+8*n]; 
		 

		
		 C[0+8*n+j*lda] += TempC[0];
		 C[1+8*n+j*lda] += TempC[1];
		 C[2+8*n+j*lda] += TempC[2];
		 C[3+8*n+j*lda] += TempC[3];
		 C[4+8*n+j*lda] += TempC[4];
		 C[5+8*n+j*lda] += TempC[5];
		 C[6+8*n+j*lda] += TempC[6];
		 C[7+8*n+j*lda] += TempC[7];
		 }
      }
	 }
	}
			if(coreid == 0)
	{
	for ( j = 0; j < 16; j++ )
     {		
		  
      for ( m = 0; m < 4; m++ )  
      {
		  
		 TempA[0] = A[j*lda+0+8*m];
		 TempA[1] = A[j*lda+1+8*m];
		 TempA[2] = A[j*lda+2+8*m];
		 TempA[3] = A[j*lda+3+8*m];
		 TempA[4] = A[j*lda+4+8*m];
		 TempA[5] = A[j*lda+5+8*m];
		 TempA[6] = A[j*lda+6+8*m];
		 TempA[7] = A[j*lda+7+8*m];
		 

		 
		for( n = 0; n < 4; n++)
		{
	     
		 

		 
		 
		 TempC[0] = TempA[0] * B[(0+8*m)*lda+0+8*n]; 
		 TempC[1] = TempA[0] * B[(0+8*m)*lda+1+8*n]; 
		 TempC[2] = TempA[0] * B[(0+8*m)*lda+2+8*n]; 
		 TempC[3] = TempA[0] * B[(0+8*m)*lda+3+8*n]; 
		 TempC[4] = TempA[0] * B[(0+8*m)*lda+4+8*n]; 
		 TempC[5] = TempA[0] * B[(0+8*m)*lda+5+8*n]; 
		 TempC[6] = TempA[0] * B[(0+8*m)*lda+6+8*n]; 
		 TempC[7] = TempA[0] * B[(0+8*m)*lda+7+8*n]; 
		 
		 
		 TempC[0] += TempA[1] * B[(1+8*m)*lda+0+8*n]; 
		 TempC[1] += TempA[1] * B[(1+8*m)*lda+1+8*n]; 
		 TempC[2] += TempA[1] * B[(1+8*m)*lda+2+8*n]; 
		 TempC[3] += TempA[1] * B[(1+8*m)*lda+3+8*n]; 
		 TempC[4] += TempA[1] * B[(1+8*m)*lda+4+8*n]; 
		 TempC[5] += TempA[1] * B[(1+8*m)*lda+5+8*n]; 
		 TempC[6] += TempA[1] * B[(1+8*m)*lda+6+8*n]; 
		 TempC[7] += TempA[1] * B[(1+8*m)*lda+7+8*n]; 
		 


		 TempC[0] += TempA[2] * B[(2+8*m)*lda+0+8*n]; 
		 TempC[1] += TempA[2] * B[(2+8*m)*lda+1+8*n]; 
		 TempC[2] += TempA[2] * B[(2+8*m)*lda+2+8*n]; 
		 TempC[3] += TempA[2] * B[(2+8*m)*lda+3+8*n]; 
		 TempC[4] += TempA[2] * B[(2+8*m)*lda+4+8*n]; 
		 TempC[5] += TempA[2] * B[(2+8*m)*lda+5+8*n]; 
		 TempC[6] += TempA[2] * B[(2+8*m)*lda+6+8*n]; 
		 TempC[7] += TempA[2] * B[(2+8*m)*lda+7+8*n]; 
		 


		 TempC[0] += TempA[3] * B[(3+8*m)*lda+0+8*n]; 
		 TempC[1] += TempA[3] * B[(3+8*m)*lda+1+8*n]; 
		 TempC[2] += TempA[3] * B[(3+8*m)*lda+2+8*n]; 
		 TempC[3] += TempA[3] * B[(3+8*m)*lda+3+8*n]; 
		 TempC[4] += TempA[3] * B[(3+8*m)*lda+4+8*n]; 
		 TempC[5] += TempA[3] * B[(3+8*m)*lda+5+8*n]; 
		 TempC[6] += TempA[3] * B[(3+8*m)*lda+6+8*n]; 
		 TempC[7] += TempA[3] * B[(3+8*m)*lda+7+8*n]; 

		 TempC[0] += TempA[4] * B[(4+8*m)*lda+0+8*n]; 
		 TempC[1] += TempA[4] * B[(4+8*m)*lda+1+8*n]; 
		 TempC[2] += TempA[4] * B[(4+8*m)*lda+2+8*n]; 
		 TempC[3] += TempA[4] * B[(4+8*m)*lda+3+8*n]; 
		 TempC[4] += TempA[4] * B[(4+8*m)*lda+4+8*n]; 
		 TempC[5] += TempA[4] * B[(4+8*m)*lda+5+8*n]; 
		 TempC[6] += TempA[4] * B[(4+8*m)*lda+6+8*n]; 
		 TempC[7] += TempA[4] * B[(4+8*m)*lda+7+8*n]; 


		 TempC[0] += TempA[5] * B[(5+8*m)*lda+0+8*n]; 
		 TempC[1] += TempA[5] * B[(5+8*m)*lda+1+8*n]; 
		 TempC[2] += TempA[5] * B[(5+8*m)*lda+2+8*n]; 
		 TempC[3] += TempA[5] * B[(5+8*m)*lda+3+8*n]; 
		 TempC[4] += TempA[5] * B[(5+8*m)*lda+4+8*n]; 
		 TempC[5] += TempA[5] * B[(5+8*m)*lda+5+8*n]; 
		 TempC[6] += TempA[5] * B[(5+8*m)*lda+6+8*n]; 
		 TempC[7] += TempA[5] * B[(5+8*m)*lda+7+8*n]; 
		 


		 TempC[0] += TempA[6] * B[(6+8*m)*lda+0+8*n]; 
		 TempC[1] += TempA[6] * B[(6+8*m)*lda+1+8*n]; 
		 TempC[2] += TempA[6] * B[(6+8*m)*lda+2+8*n]; 
		 TempC[3] += TempA[6] * B[(6+8*m)*lda+3+8*n]; 
		 TempC[4] += TempA[6] * B[(6+8*m)*lda+4+8*n]; 
		 TempC[5] += TempA[6] * B[(6+8*m)*lda+5+8*n]; 
		 TempC[6] += TempA[6] * B[(6+8*m)*lda+6+8*n]; 
		 TempC[7] += TempA[6] * B[(6+8*m)*lda+7+8*n]; 


		 TempC[0] += TempA[7] * B[(7+8*m)*lda+0+8*n]; 
		 TempC[1] += TempA[7] * B[(7+8*m)*lda+1+8*n]; 
		 TempC[2] += TempA[7] * B[(7+8*m)*lda+2+8*n]; 
		 TempC[3] += TempA[7] * B[(7+8*m)*lda+3+8*n]; 
		 TempC[4] += TempA[7] * B[(7+8*m)*lda+4+8*n]; 
		 TempC[5] += TempA[7] * B[(7+8*m)*lda+5+8*n]; 
		 TempC[6] += TempA[7] * B[(7+8*m)*lda+6+8*n]; 
		 TempC[7] += TempA[7] * B[(7+8*m)*lda+7+8*n]; 
		 

		
		 C[0+8*n+j*lda] += TempC[0];
		 C[1+8*n+j*lda] += TempC[1];
		 C[2+8*n+j*lda] += TempC[2];
		 C[3+8*n+j*lda] += TempC[3];
		 C[4+8*n+j*lda] += TempC[4];
		 C[5+8*n+j*lda] += TempC[5];
		 C[6+8*n+j*lda] += TempC[6];
		 C[7+8*n+j*lda] += TempC[7];
		 }
      }
	 }
	}
	
		//-----------------------------------------------------------------version 2.13 optimize j
	/*
	static __thread data_t TempA[8];
	static __thread data_t TempB[8];
	static __thread data_t TempC[8];
	static __thread int j,m,n,i,k;
	
	if(coreid == 1)
	{
	for ( j = 16; j < 32; j++ )
     {		
		  
      for ( m = 0; m < 4; m++ )  
      {
		  
		 TempA[0] = A[j*lda+0+8*m];
		 TempA[1] = A[j*lda+1+8*m];
		 TempA[2] = A[j*lda+2+8*m];
		 TempA[3] = A[j*lda+3+8*m];
		 TempA[4] = A[j*lda+4+8*m];
		 TempA[5] = A[j*lda+5+8*m];
		 TempA[6] = A[j*lda+6+8*m];
		 TempA[7] = A[j*lda+7+8*m];
		 
		for( n = 0; n < 4; n++)
		{
		 TempB[0] = B[(0+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(0+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(0+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(0+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(0+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(0+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(0+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(0+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[0] * TempB[0];
		 C[1+8*n+j*lda] += TempA[0] * TempB[1];
		 C[2+8*n+j*lda] += TempA[0] * TempB[2];
		 C[3+8*n+j*lda] += TempA[0] * TempB[3];
		 C[4+8*n+j*lda] += TempA[0] * TempB[4];
		 C[5+8*n+j*lda] += TempA[0] * TempB[5];
		 C[6+8*n+j*lda] += TempA[0] * TempB[6];
		 C[7+8*n+j*lda] += TempA[0] * TempB[7];
		 


		 TempB[0] = B[(1+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(1+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(1+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(1+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(1+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(1+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(1+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(1+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[1] * TempB[0];
		 C[1+8*n+j*lda] += TempA[1] * TempB[1];
		 C[2+8*n+j*lda] += TempA[1] * TempB[2];
		 C[3+8*n+j*lda] += TempA[1] * TempB[3];
		 C[4+8*n+j*lda] += TempA[1] * TempB[4];
		 C[5+8*n+j*lda] += TempA[1] * TempB[5];
		 C[6+8*n+j*lda] += TempA[1] * TempB[6];
		 C[7+8*n+j*lda] += TempA[1] * TempB[7];
		 


		 TempB[0] = B[(2+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(2+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(2+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(2+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(2+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(2+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(2+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(2+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[2] * TempB[0];
		 C[1+8*n+j*lda] += TempA[2] * TempB[1];
		 C[2+8*n+j*lda] += TempA[2] * TempB[2];
		 C[3+8*n+j*lda] += TempA[2] * TempB[3];
		 C[4+8*n+j*lda] += TempA[2] * TempB[4];
		 C[5+8*n+j*lda] += TempA[2] * TempB[5];
		 C[6+8*n+j*lda] += TempA[2] * TempB[6];
		 C[7+8*n+j*lda] += TempA[2] * TempB[7];
		 


		 TempB[0] = B[(3+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(3+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(3+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(3+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(3+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(3+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(3+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(3+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[3] * TempB[0];
		 C[1+8*n+j*lda] += TempA[3] * TempB[1];
		 C[2+8*n+j*lda] += TempA[3] * TempB[2];
		 C[3+8*n+j*lda] += TempA[3] * TempB[3];
		 C[4+8*n+j*lda] += TempA[3] * TempB[4];
		 C[5+8*n+j*lda] += TempA[3] * TempB[5];
		 C[6+8*n+j*lda] += TempA[3] * TempB[6];
		 C[7+8*n+j*lda] += TempA[3] * TempB[7];


		 TempB[0] = B[(4+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(4+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(4+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(4+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(4+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(4+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(4+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(4+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[4] * TempB[0];
		 C[1+8*n+j*lda] += TempA[4] * TempB[1];
		 C[2+8*n+j*lda] += TempA[4] * TempB[2];
		 C[3+8*n+j*lda] += TempA[4] * TempB[3];
		 C[4+8*n+j*lda] += TempA[4] * TempB[4];
		 C[5+8*n+j*lda] += TempA[4] * TempB[5];
		 C[6+8*n+j*lda] += TempA[4] * TempB[6];
		 C[7+8*n+j*lda] += TempA[4] * TempB[7];
		 


		 TempB[0] = B[(5+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(5+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(5+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(5+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(5+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(5+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(5+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(5+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[5] * TempB[0];
		 C[1+8*n+j*lda] += TempA[5] * TempB[1];
		 C[2+8*n+j*lda] += TempA[5] * TempB[2];
		 C[3+8*n+j*lda] += TempA[5] * TempB[3];
		 C[4+8*n+j*lda] += TempA[5] * TempB[4];
		 C[5+8*n+j*lda] += TempA[5] * TempB[5];
		 C[6+8*n+j*lda] += TempA[5] * TempB[6];
		 C[7+8*n+j*lda] += TempA[5] * TempB[7];
		 


		 TempB[0] = B[(6+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(6+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(6+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(6+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(6+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(6+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(6+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(6+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[6] * TempB[0];
		 C[1+8*n+j*lda] += TempA[6] * TempB[1];
		 C[2+8*n+j*lda] += TempA[6] * TempB[2];
		 C[3+8*n+j*lda] += TempA[6] * TempB[3];
		 C[4+8*n+j*lda] += TempA[6] * TempB[4];
		 C[5+8*n+j*lda] += TempA[6] * TempB[5];
		 C[6+8*n+j*lda] += TempA[6] * TempB[6];
		 C[7+8*n+j*lda] += TempA[6] * TempB[7];


		 TempB[0] = B[(7+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(7+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(7+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(7+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(7+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(7+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(7+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(7+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[7] * TempB[0];
		 C[1+8*n+j*lda] += TempA[7] * TempB[1];
		 C[2+8*n+j*lda] += TempA[7] * TempB[2];
		 C[3+8*n+j*lda] += TempA[7] * TempB[3];
		 C[4+8*n+j*lda] += TempA[7] * TempB[4];
		 C[5+8*n+j*lda] += TempA[7] * TempB[5];
		 C[6+8*n+j*lda] += TempA[7] * TempB[6];
		 C[7+8*n+j*lda] += TempA[7] * TempB[7];
		}

      }
	 }
	}
	if(coreid == 0)
	{
	for ( j = 0; j < 16; j++ )
     {		
		  
      for ( m = 0; m < 4; m++ )  
      {
		  
		 TempA[0] = A[j*lda+0+8*m];
		 TempA[1] = A[j*lda+1+8*m];
		 TempA[2] = A[j*lda+2+8*m];
		 TempA[3] = A[j*lda+3+8*m];
		 TempA[4] = A[j*lda+4+8*m];
		 TempA[5] = A[j*lda+5+8*m];
		 TempA[6] = A[j*lda+6+8*m];
		 TempA[7] = A[j*lda+7+8*m];
		 
		for( n = 0; n < 4; n++)
		{
		 TempB[0] = B[(0+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(0+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(0+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(0+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(0+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(0+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(0+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(0+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[0] * TempB[0];
		 C[1+8*n+j*lda] += TempA[0] * TempB[1];
		 C[2+8*n+j*lda] += TempA[0] * TempB[2];
		 C[3+8*n+j*lda] += TempA[0] * TempB[3];
		 C[4+8*n+j*lda] += TempA[0] * TempB[4];
		 C[5+8*n+j*lda] += TempA[0] * TempB[5];
		 C[6+8*n+j*lda] += TempA[0] * TempB[6];
		 C[7+8*n+j*lda] += TempA[0] * TempB[7];
		 


		 TempB[0] = B[(1+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(1+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(1+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(1+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(1+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(1+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(1+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(1+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[1] * TempB[0];
		 C[1+8*n+j*lda] += TempA[1] * TempB[1];
		 C[2+8*n+j*lda] += TempA[1] * TempB[2];
		 C[3+8*n+j*lda] += TempA[1] * TempB[3];
		 C[4+8*n+j*lda] += TempA[1] * TempB[4];
		 C[5+8*n+j*lda] += TempA[1] * TempB[5];
		 C[6+8*n+j*lda] += TempA[1] * TempB[6];
		 C[7+8*n+j*lda] += TempA[1] * TempB[7];
		 


		 TempB[0] = B[(2+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(2+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(2+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(2+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(2+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(2+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(2+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(2+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[2] * TempB[0];
		 C[1+8*n+j*lda] += TempA[2] * TempB[1];
		 C[2+8*n+j*lda] += TempA[2] * TempB[2];
		 C[3+8*n+j*lda] += TempA[2] * TempB[3];
		 C[4+8*n+j*lda] += TempA[2] * TempB[4];
		 C[5+8*n+j*lda] += TempA[2] * TempB[5];
		 C[6+8*n+j*lda] += TempA[2] * TempB[6];
		 C[7+8*n+j*lda] += TempA[2] * TempB[7];
		 


		 TempB[0] = B[(3+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(3+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(3+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(3+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(3+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(3+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(3+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(3+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[3] * TempB[0];
		 C[1+8*n+j*lda] += TempA[3] * TempB[1];
		 C[2+8*n+j*lda] += TempA[3] * TempB[2];
		 C[3+8*n+j*lda] += TempA[3] * TempB[3];
		 C[4+8*n+j*lda] += TempA[3] * TempB[4];
		 C[5+8*n+j*lda] += TempA[3] * TempB[5];
		 C[6+8*n+j*lda] += TempA[3] * TempB[6];
		 C[7+8*n+j*lda] += TempA[3] * TempB[7];


		 TempB[0] = B[(4+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(4+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(4+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(4+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(4+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(4+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(4+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(4+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[4] * TempB[0];
		 C[1+8*n+j*lda] += TempA[4] * TempB[1];
		 C[2+8*n+j*lda] += TempA[4] * TempB[2];
		 C[3+8*n+j*lda] += TempA[4] * TempB[3];
		 C[4+8*n+j*lda] += TempA[4] * TempB[4];
		 C[5+8*n+j*lda] += TempA[4] * TempB[5];
		 C[6+8*n+j*lda] += TempA[4] * TempB[6];
		 C[7+8*n+j*lda] += TempA[4] * TempB[7];
		 


		 TempB[0] = B[(5+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(5+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(5+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(5+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(5+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(5+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(5+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(5+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[5] * TempB[0];
		 C[1+8*n+j*lda] += TempA[5] * TempB[1];
		 C[2+8*n+j*lda] += TempA[5] * TempB[2];
		 C[3+8*n+j*lda] += TempA[5] * TempB[3];
		 C[4+8*n+j*lda] += TempA[5] * TempB[4];
		 C[5+8*n+j*lda] += TempA[5] * TempB[5];
		 C[6+8*n+j*lda] += TempA[5] * TempB[6];
		 C[7+8*n+j*lda] += TempA[5] * TempB[7];
		 


		 TempB[0] = B[(6+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(6+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(6+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(6+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(6+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(6+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(6+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(6+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[6] * TempB[0];
		 C[1+8*n+j*lda] += TempA[6] * TempB[1];
		 C[2+8*n+j*lda] += TempA[6] * TempB[2];
		 C[3+8*n+j*lda] += TempA[6] * TempB[3];
		 C[4+8*n+j*lda] += TempA[6] * TempB[4];
		 C[5+8*n+j*lda] += TempA[6] * TempB[5];
		 C[6+8*n+j*lda] += TempA[6] * TempB[6];
		 C[7+8*n+j*lda] += TempA[6] * TempB[7];


		 TempB[0] = B[(7+8*m)*lda+0+8*n]; 
		 TempB[1] = B[(7+8*m)*lda+1+8*n]; 
		 TempB[2] = B[(7+8*m)*lda+2+8*n]; 
		 TempB[3] = B[(7+8*m)*lda+3+8*n]; 
		 TempB[4] = B[(7+8*m)*lda+4+8*n]; 
		 TempB[5] = B[(7+8*m)*lda+5+8*n]; 
		 TempB[6] = B[(7+8*m)*lda+6+8*n]; 
		 TempB[7] = B[(7+8*m)*lda+7+8*n]; 
		 
		 C[0+8*n+j*lda] += TempA[7] * TempB[0];
		 C[1+8*n+j*lda] += TempA[7] * TempB[1];
		 C[2+8*n+j*lda] += TempA[7] * TempB[2];
		 C[3+8*n+j*lda] += TempA[7] * TempB[3];
		 C[4+8*n+j*lda] += TempA[7] * TempB[4];
		 C[5+8*n+j*lda] += TempA[7] * TempB[5];
		 C[6+8*n+j*lda] += TempA[7] * TempB[6];
		 C[7+8*n+j*lda] += TempA[7] * TempB[7];
		}

      }
	 }
	}
	*/
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

