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
   
   // ***************************** //
   // **** ADD YOUR CODE HERE ***** //
   // ***************************** //
   //
   // feel free to make a separate function for MI and MSI versions.
    int i, j, k;
    int space=lda/ncores;
    int max= space*coreid+space;
	data_t temp=0;

	data_t temp1=0;
	data_t temp2=0;
	data_t temp3=0;
	data_t temp4=0;
	
	data_t temp_1=0;

	data_t temp1_1=0;
	data_t temp2_1=0;
	data_t temp3_1=0;
	data_t temp4_1=0;
	
	data_t temp_2=0;

	data_t temp1_2=0;
	data_t temp2_2=0;
	data_t temp3_2=0;
	data_t temp4_2=0;
	
	data_t temp_3=0;

	data_t temp1_3=0;
	data_t temp2_3=0;
	data_t temp3_3=0;
	data_t temp4_3=0;

	if (coreid!=ncores-1){
	//main loop
		for (i=space*coreid;i<max/4*4;i+=4)
		{
			for(j=0;j<lda;j+=4)
			{
				temp1=C[j+i*lda];
				temp2=C[j+1+i*lda];
				temp3=C[j+2+i*lda];
				temp4=C[j+3+i*lda];
		
				temp1_1=C[j+(i+1)*lda];
				temp2_1=C[j+1+(i+1)*lda];
				temp3_1=C[j+2+(i+1)*lda];
				temp4_1=C[j+3+(i+1)*lda];
				
				temp1_2=C[j+(i+2)*lda];
				temp2_2=C[j+1+(i+2)*lda];
				temp3_2=C[j+2+(i+2)*lda];
				temp4_2=C[j+3+(i+2)*lda];
				
				temp1_3=C[j+(i+3)*lda];
				temp2_3=C[j+1+(i+3)*lda];
				temp3_3=C[j+2+(i+3)*lda];
				temp4_3=C[j+3+(i+3)*lda];
				for (k=0;k<lda;k++)
				{
					temp=A[k+i*lda];
					temp1+=temp*B[j+k*lda];
					temp2+=temp*B[j+1+k*lda];
					temp3+=temp*B[j+2+k*lda];
					temp4+=temp*B[j+3+k*lda];
					
					temp_1=A[k+(i+1)*lda];
					temp1_1+=temp_1*B[j+k*lda];
					temp2_1+=temp_1*B[j+1+k*lda];
					temp3_1+=temp_1*B[j+2+k*lda];
					temp4_1+=temp_1*B[j+3+k*lda];
					
					temp_2=A[k+(i+2)*lda];
					temp1_2+=temp_2*B[j+k*lda];
					temp2_2+=temp_2*B[j+1+k*lda];
					temp3_2+=temp_2*B[j+2+k*lda];
					temp4_2+=temp_2*B[j+3+k*lda];
					
					temp_3=A[k+(i+3)*lda];
					temp1_3+=temp_3*B[j+k*lda];
					temp2_3+=temp_3*B[j+1+k*lda];
					temp3_3+=temp_3*B[j+2+k*lda];
					temp4_3+=temp_3*B[j+3+k*lda];

				}
				C[j+i*lda]=temp1;
				C[j+1+i*lda]=temp2;
				C[j+2+i*lda]=temp3;
				C[j+3+i*lda]=temp4;
				
				C[j+(i+1)*lda]=temp1_1;
				C[j+1+(i+1)*lda]=temp2_1;
				C[j+2+(i+1)*lda]=temp3_1;
				C[j+3+(i+1)*lda]=temp4_1;
				
				C[j+(i+2)*lda]=temp1_2;
				C[j+1+(i+2)*lda]=temp2_2;
				C[j+2+(i+2)*lda]=temp3_2;
				C[j+3+(i+2)*lda]=temp4_2;
				
				C[j+(i+3)*lda]=temp1_3;
				C[j+1+(i+3)*lda]=temp2_3;
				C[j+2+(i+3)*lda]=temp3_3;
				C[j+3+(i+3)*lda]=temp4_3;

			}
			
		}
		
	
		
	}
	
	//second core
	else{
		for (i=space*coreid;i<lda/4*4;i+=4)
		{
			for(j=0;j<lda;j+=4)
			{
				temp1=C[j+i*lda];
				temp2=C[j+1+i*lda];
				temp3=C[j+2+i*lda];
				temp4=C[j+3+i*lda];
		
				temp1_1=C[j+(i+1)*lda];
				temp2_1=C[j+1+(i+1)*lda];
				temp3_1=C[j+2+(i+1)*lda];
				temp4_1=C[j+3+(i+1)*lda];
				
				temp1_2=C[j+(i+2)*lda];
				temp2_2=C[j+1+(i+2)*lda];
				temp3_2=C[j+2+(i+2)*lda];
				temp4_2=C[j+3+(i+2)*lda];
				
				temp1_3=C[j+(i+3)*lda];
				temp2_3=C[j+1+(i+3)*lda];
				temp3_3=C[j+2+(i+3)*lda];
				temp4_3=C[j+3+(i+3)*lda];
				for (k=0;k<lda;k++)
				{
					temp=A[k+i*lda];
					temp1+=temp*B[j+k*lda];
					temp2+=temp*B[j+1+k*lda];
					temp3+=temp*B[j+2+k*lda];
					temp4+=temp*B[j+3+k*lda];
					
					temp_1=A[k+(i+1)*lda];
					temp1_1+=temp_1*B[j+k*lda];
					temp2_1+=temp_1*B[j+1+k*lda];
					temp3_1+=temp_1*B[j+2+k*lda];
					temp4_1+=temp_1*B[j+3+k*lda];
					
					temp_2=A[k+(i+2)*lda];
					temp1_2+=temp_2*B[j+k*lda];
					temp2_2+=temp_2*B[j+1+k*lda];
					temp3_2+=temp_2*B[j+2+k*lda];
					temp4_2+=temp_2*B[j+3+k*lda];
					
					temp_3=A[k+(i+3)*lda];
					temp1_3+=temp_3*B[j+k*lda];
					temp2_3+=temp_3*B[j+1+k*lda];
					temp3_3+=temp_3*B[j+2+k*lda];
					temp4_3+=temp_3*B[j+3+k*lda];

				}
				C[j+i*lda]=temp1;
				C[j+1+i*lda]=temp2;
				C[j+2+i*lda]=temp3;
				C[j+3+i*lda]=temp4;
				
				C[j+(i+1)*lda]=temp1_1;
				C[j+1+(i+1)*lda]=temp2_1;
				C[j+2+(i+1)*lda]=temp3_1;
				C[j+3+(i+1)*lda]=temp4_1;
				
				C[j+(i+2)*lda]=temp1_2;
				C[j+1+(i+2)*lda]=temp2_2;
				C[j+2+(i+2)*lda]=temp3_2;
				C[j+3+(i+2)*lda]=temp4_2;
				
				C[j+(i+3)*lda]=temp1_3;
				C[j+1+(i+3)*lda]=temp2_3;
				C[j+2+(i+3)*lda]=temp3_3;
				C[j+3+(i+3)*lda]=temp4_3;

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


//   // Execute the provided, naive matmul
//   barrier(nc);
//   stats(matmul_naive(DIM_SIZE, input1_data, input2_data, results_data); barrier(nc));
// 
//   
//   // verify
//   verifyMT(ARRAY_SIZE, results_data, verify_data);
//   
//   // clear results from the first trial
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

