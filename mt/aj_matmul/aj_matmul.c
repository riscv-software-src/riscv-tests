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

void matrix_sub(int size, data_t A[], data_t B[], data_t C[]) {
	if (coreid != 0)
		return;

	for(int i = 0; i < size; i++){
		C[i] = A[i] + B[i];
	}
}

void matrix_add(int size, data_t A[], data_t B[], data_t C[]) {
	if (coreid != 0)
		return;

	for(int i = 0; i < size; i++){
		C[i] = A[i] - B[i];
	}
}

void strassen_mult(int dime, const data_t sA[],  const data_t sB[], data_t sC[]) {

	if (coreid != 0)
		return;

	int height, width;
	int sub_size = dime*dime/4;

//	data_t 	A_11[sub_size], B_11[sub_size], C_11[sub_size],
//			A_12[sub_size], B_12[sub_size], C_12[sub_size],
//			A_21[sub_size], B_21[sub_size], C_21[sub_size],
//			A_22[sub_size], B_22[sub_size], C_22[sub_size];

	data_t *A_11 = malloc(sub_size*sizeof(data_t));
	data_t *A_12 = malloc(sub_size*sizeof(data_t));
	data_t *A_21 = malloc(sub_size*sizeof(data_t));
	data_t *A_22 = malloc(sub_size*sizeof(data_t));
	data_t *B_11 = malloc(sub_size*sizeof(data_t));
	data_t *B_12 = malloc(sub_size*sizeof(data_t));
	data_t *B_21 = malloc(sub_size*sizeof(data_t));
	data_t *B_22 = malloc(sub_size*sizeof(data_t));
	
	for(height=0; height < dime/2; height++) {
		for(width= 0; width < dime/2; width++) {
			A_11[width+(height*dime/2)] = sA[width + height*dime];
			B_11[width+(height*dime/2)] = sB[width + height*dime];
			
			A_12[width+(height*dime/2)] = sA[dime/2 + width + height*dime];
			B_12[width+(height*dime/2)] = sB[dime/2 + width + height*dime];
			
			A_21[width+(height*dime/2)] = sA[(dime*dime)/2 + width + height*dime];
			B_21[width+(height*dime/2)] = sB[(dime*dime)/2 + width + height*dime];
			
			A_22[width+(height*dime/2)] = sA[(dime*dime)/2 + dime/2 + width + height*dime];
			B_22[width+(height*dime/2)] = sB[(dime*dime)/2 + dime/2 + width + height*dime];
		}
	}
	
//	data_t		H_1[sub_size], H_2[sub_size], H_3[sub_size], H_4[sub_size], H_5[sub_size], 
//			H_6[sub_size], H_7[sub_size], H_8[sub_size], H_9[sub_size], H_10[sub_size], 
//			H_11[sub_size], H_12[sub_size], H_13[sub_size], H_14[sub_size], 
//			H_15[sub_size], H_16[sub_size], H_17[sub_size], H_18[sub_size];

	data_t *H_1 = malloc(sub_size*sizeof(data_t));
	data_t *H_2 = malloc(sub_size*sizeof(data_t));
	data_t *H_3 = malloc(sub_size*sizeof(data_t));
	data_t *H_4 = malloc(sub_size*sizeof(data_t));
	data_t *H_5 = malloc(sub_size*sizeof(data_t));
	data_t *H_6 = malloc(sub_size*sizeof(data_t));
	data_t *H_7 = malloc(sub_size*sizeof(data_t));
	data_t *H_8 = malloc(sub_size*sizeof(data_t));
	data_t *H_9 = malloc(sub_size*sizeof(data_t));
	data_t *H_10 = malloc(sub_size*sizeof(data_t));

	matrix_add(sub_size, A_11, A_22, H_1); //Helper1
	matrix_add(sub_size, B_11, B_22, H_2); //Helper2
	matrix_add(sub_size, A_21, A_22, H_3); //Helper3
	matrix_sub(sub_size, B_12, B_22, H_4); //Helper4
	matrix_sub(sub_size, B_21, B_11, H_5); //Helper5
	matrix_add(sub_size, A_11, A_12, H_6); //Helper6
	matrix_sub(sub_size, A_21, A_11, H_7); //Helper7
	matrix_add(sub_size, B_11, B_12, H_8); //Helper8
	matrix_sub(sub_size, A_12, A_22, H_9); //Helper9
	matrix_add(sub_size, B_21, B_22, H_10); //Helper10

	free(A_12);
	free(A_21);
	free(B_12);
	free(B_21);

	A_12 = NULL;
	A_21 = NULL;
	B_12 = NULL;
	B_21 = NULL;

//	data_t		M_1[sub_size], M_2[sub_size], M_3[sub_size], M_4[sub_size],
//			M_5[sub_size], M_6[sub_size], M_7[sub_size];

	data_t *M_1 = malloc(sub_size*sizeof(data_t));
	data_t *M_2 = malloc(sub_size*sizeof(data_t));
	data_t *M_3 = malloc(sub_size*sizeof(data_t));
	data_t *M_4 = malloc(sub_size*sizeof(data_t));
	data_t *M_5 = malloc(sub_size*sizeof(data_t));
	data_t *M_6 = malloc(sub_size*sizeof(data_t));
	data_t *M_7 = malloc(sub_size*sizeof(data_t));

	if (sub_size == 1) {
		M_1[0] = H_1[0]*H_2[0];
		M_2[0] = H_3[0]*B_11[0];
		M_3[0] = A_11[0]*H_4[0];
		M_4[0] = A_22[0]*H_5[0];
		M_5[0] = H_6[0]*B_22[0];
		M_6[0] = H_7[0]*H_8[0];
		M_7[0] = H_9[0]*H_10[0];
	} else {
		strassen_mult(dime/2, H_1, H_2, M_1);
		strassen_mult(dime/2, H_3, B_11, M_2);
		strassen_mult(dime/2, A_11, H_4, M_3);
		strassen_mult(dime/2, A_22, H_5, M_4);
		strassen_mult(dime/2, H_6, B_22, M_5);
		strassen_mult(dime/2, H_7, H_8, M_6);
		strassen_mult(dime/2, H_9, H_10, M_7);
	}

	free(A_11);
	free(A_22);
	free(B_11);
	free(B_22);

	A_11 = NULL;
	A_22 = NULL;
	B_11 = NULL;
	B_22 = NULL;

	free(H_1);
	free(H_2);
	free(H_3);
	free(H_4);
	free(H_5);
	free(H_6);
	free(H_7);
	free(H_8);
	free(H_9);
	free(H_10);

	H_1 = NULL;
	H_2 = NULL;
	H_3 = NULL;
	H_4 = NULL;
	H_5 = NULL;
	H_6 = NULL;
	H_7 = NULL;
	H_8 = NULL;
	H_9 = NULL;
	H_10 = NULL;

	data_t *H_11 = malloc(sub_size*sizeof(data_t));
	data_t *H_12 = malloc(sub_size*sizeof(data_t));
	data_t *H_13 = malloc(sub_size*sizeof(data_t));
	data_t *H_14 = malloc(sub_size*sizeof(data_t));

	data_t *C_11 = malloc(sub_size*sizeof(data_t));
	data_t *C_12 = malloc(sub_size*sizeof(data_t));
	data_t *C_21 = malloc(sub_size*sizeof(data_t));
	data_t *C_22 = malloc(sub_size*sizeof(data_t));

	matrix_add(sub_size, M_1, M_4, H_11);
	matrix_add(sub_size, M_5, M_7, H_12);
	matrix_sub(sub_size, H_11, H_12, C_11);

	matrix_add(sub_size, M_3, M_5, C_12);

	matrix_add(sub_size, M_2, M_4, C_21);

	matrix_sub(sub_size, M_1, M_2, H_13);
	matrix_add(sub_size, M_3, M_6, H_14);
	matrix_add(sub_size, H_13, H_14, C_22);

	free(H_11);
	free(H_12);
	free(H_13);
	free(H_14);

	H_11 = NULL;
	H_12 = NULL;
	H_13 = NULL;
	H_14 = NULL;


	for(height=0; height < dime/2; height++) {
		for(width= 0; width < dime/2; width++) {
			sC[width + height*dime] 				= C_11[width+(height*dime/2)];
			sC[dime/2 + width + height*dime] 			= C_12[width+(height*dime/2)];
			sC[(dime*dime)/2 + width + height*dime] 		= C_21[width+(height*dime/2)];
			sC[(dime*dime)/2 + dime/2 + width + height*dime] = C_22[width+(height*dime/2)];
		}
	}

	free(C_11);
	free(C_12);
	free(C_21);
	free(C_22);

	C_11 = NULL;
	C_12 = NULL;
	C_21 = NULL;
	C_22 = NULL;

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

	if (coreid > 0)
	return; 

	strassen_mult(lda, A, B, C);

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

