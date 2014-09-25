//**************************************************************************
// Multi-threaded Matrix Multiply benchmark
//--------------------------------------------------------------------------
// TA     : Christopher Celio
// Student: Anirudh Garg
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
	{
		for ( j = 0; j < lda; j++ )  
		{
			for ( k = 0; k < lda; k++ ) 
			{
				C[i + j*lda] += A[j*lda + k] * B[k*lda + i];
			}
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
	
	/*547287
	 for ( i = coreid*lda/ncores; i < (coreid+1)*lda/ncores; i++ )
	 {
	 for ( j = 0; j < lda; j++ )  
	 {
	 int aIndex = j*lda;
	 int cIndex = i + aIndex;
	 C[cIndex] += A[aIndex] * B[i];
	 C[cIndex] += A[aIndex + 1] * B[1*lda + i];
	 C[cIndex] += A[aIndex + 2] * B[2*lda + i];
	 C[cIndex] += A[aIndex + 3] * B[3*lda + i];
	 C[cIndex] += A[aIndex + 4] * B[4*lda + i];
	 C[cIndex] += A[aIndex + 5] * B[5*lda + i];
	 C[cIndex] += A[aIndex + 6] * B[6*lda + i];
	 C[cIndex] += A[aIndex + 7] * B[7*lda + i];
	 C[cIndex] += A[aIndex + 8] * B[8*lda + i];
	 C[cIndex] += A[aIndex + 9] * B[9*lda + i];
	 C[cIndex] += A[aIndex + 10] * B[10*lda + i];
	 C[cIndex] += A[aIndex + 11] * B[11*lda + i];
	 C[cIndex] += A[aIndex + 12] * B[12*lda + i];
	 C[cIndex] += A[aIndex + 13] * B[13*lda + i];
	 C[cIndex] += A[aIndex + 14] * B[14*lda + i];
	 C[cIndex] += A[aIndex + 15] * B[15*lda + i];
	 C[cIndex] += A[aIndex + 16] * B[16*lda + i];
	 C[cIndex] += A[aIndex + 17] * B[17*lda + i];
	 C[cIndex] += A[aIndex + 18] * B[18*lda + i];
	 C[cIndex] += A[aIndex + 19] * B[19*lda + i];
	 C[cIndex] += A[aIndex + 20] * B[20*lda + i];
	 C[cIndex] += A[aIndex + 21] * B[21*lda + i];
	 C[cIndex] += A[aIndex + 22] * B[22*lda + i];
	 C[cIndex] += A[aIndex + 23] * B[23*lda + i];
	 C[cIndex] += A[aIndex + 24] * B[24*lda + i];
	 C[cIndex] += A[aIndex + 25] * B[25*lda + i];
	 C[cIndex] += A[aIndex + 26] * B[26*lda + i];
	 C[cIndex] += A[aIndex + 27] * B[27*lda + i];
	 C[cIndex] += A[aIndex + 28] * B[28*lda + i];
	 C[cIndex] += A[aIndex + 29] * B[29*lda + i];
	 C[cIndex] += A[aIndex + 30] * B[30*lda + i];
	 C[cIndex] += A[aIndex + 31] * B[31*lda + i];	
	 }
	 }
	 */
  
	//492827
	/*	for ( i = coreid*lda/ncores; i < (coreid+1)*lda/ncores; i++ )
	 {
	 for ( j = 0; j < lda; j++ )  
	 {
	 
	 int aIndex = j*lda;
	 int cIndex = i + aIndex;
	 for ( k = 0; k < lda; k++) 
	 {
	 C[cIndex] += A[aIndex + k] * B[k*lda + i];
	 /*	C[cIndex] += A[aIndex + k+1] * B[(k+1)*lda + i];
	 C[cIndex] += A[aIndex + k+2] * B[(k+2)*lda + i];
	 C[cIndex] += A[aIndex + k+3] * B[(k+3)*lda + i];
	 C[cIndex] += A[aIndex + k+4] * B[(k+4)*lda + i];
	 C[cIndex] += A[aIndex + k+5] * B[(k+5)*lda + i];
	 C[cIndex] += A[aIndex + k+6] * B[(k+6)*lda + i];
	 C[cIndex] += A[aIndex + k+7] * B[(k+7)*lda + i];
	 C[cIndex] += A[aIndex + k+8] * B[(k+8)*lda + i];
	 C[cIndex] += A[aIndex + k+9] * B[(k+9)*lda + i];
	 C[cIndex] += A[aIndex + k+10] * B[(k+10)*lda + i];
	 C[cIndex] += A[aIndex + k+11] * B[(k+11)*lda + i];
	 C[cIndex] += A[aIndex + k+12] * B[(k+12)*lda + i];
	 C[cIndex] += A[aIndex + k+13] * B[(k+13)*lda + i];
	 C[cIndex] += A[aIndex + k+14] * B[(k+14)*lda + i];
	 C[cIndex] += A[aIndex + k+15] * B[(k+15)*lda + i];*/
	/*		}
	 }
	 }*/
	/*
	 //326378
	 data_t bTrans[1024];
	 
	 for (int counti = 0; counti < 32; counti++) {
	 for (int countj = 0; countj < 32; countj++) {
	 *(bTrans + counti + countj*lda) = *(B + countj + counti*lda);
	 }
	 }
	 
	 
	 int BLOCKSIZE = 8;
	 for ( i = 0; i < lda; i+=BLOCKSIZE )
	 {
	 for ( int iTemp = i; iTemp < i + BLOCKSIZE; iTemp++ ) {
	 int iFlag = iTemp*lda;
	 for ( j = coreid*lda/ncores; j < (coreid+1)*lda/ncores; j++ ) {
	 int jFlag = j*lda;
	 int cLoc = jFlag+iTemp;
	 for ( k = 0; k < lda; k+=8) {
	 *(C+cLoc) += *(A+jFlag+k) * *(bTrans+iFlag+k);
	 *(C+cLoc) += *(A+jFlag+k+1) * *(bTrans+iFlag+k+1);
	 *(C+cLoc) += *(A+jFlag+k+2) * *(bTrans+iFlag+k+2);
	 *(C+cLoc) += *(A+jFlag+k+3) * *(bTrans+iFlag+k+3);
	 *(C+cLoc) += *(A+jFlag+k+4) * *(bTrans+iFlag+k+4);
	 *(C+cLoc) += *(A+jFlag+k+5) * *(bTrans+iFlag+k+5);
	 *(C+cLoc) += *(A+jFlag+k+6) * *(bTrans+iFlag+k+6);
	 *(C+cLoc) += *(A+jFlag+k+7) * *(bTrans+iFlag+k+7);
	 }
	 }
	 }
	 }*/
	data_t bTrans[1024];
	
	for (int counti = coreid*32/ncores; counti < (coreid+1)*lda/ncores; counti++) {
		for (int countj = 0; countj < 32; countj++) {
			*(bTrans + counti + countj*lda) = *(B + countj + counti*lda);
		}
	}
	
	
	int BLOCKSIZE = 8;
	for ( j = 0; j < lda; j++ )
	{
		//for ( int jTemp = j; jTemp < j + BLOCKSIZE; jTemp++ ) {
		int jFlag = j*lda;
		for ( i = coreid*lda/ncores; i < (coreid+1)*lda/ncores; i+=BLOCKSIZE ) {
			for ( int iTemp = i; iTemp < i + BLOCKSIZE; iTemp++ ) {
				
				int iFlag = iTemp*lda;
				int cLoc = jFlag+iTemp;
				for ( k = 0; k < lda; k+=16) {
					*(C+cLoc) += *(A+jFlag+k) * *(bTrans+iFlag+k);
					*(C+cLoc) += *(A+jFlag+k+1) * *(bTrans+iFlag+k+1);
					*(C+cLoc) += *(A+jFlag+k+2) * *(bTrans+iFlag+k+2);
					*(C+cLoc) += *(A+jFlag+k+3) * *(bTrans+iFlag+k+3);
					*(C+cLoc) += *(A+jFlag+k+4) * *(bTrans+iFlag+k+4);
					*(C+cLoc) += *(A+jFlag+k+5) * *(bTrans+iFlag+k+5);
					*(C+cLoc) += *(A+jFlag+k+6) * *(bTrans+iFlag+k+6);
					*(C+cLoc) += *(A+jFlag+k+7) * *(bTrans+iFlag+k+7);
					*(C+cLoc) += *(A+jFlag+k+8) * *(bTrans+iFlag+k+8);
					*(C+cLoc) += *(A+jFlag+k+9) * *(bTrans+iFlag+k+9);
					*(C+cLoc) += *(A+jFlag+k+10) * *(bTrans+iFlag+k+10);
					*(C+cLoc) += *(A+jFlag+k+11) * *(bTrans+iFlag+k+11);
					*(C+cLoc) += *(A+jFlag+k+12) * *(bTrans+iFlag+k+12);
					*(C+cLoc) += *(A+jFlag+k+13) * *(bTrans+iFlag+k+13);
					*(C+cLoc) += *(A+jFlag+k+14) * *(bTrans+iFlag+k+14);
					*(C+cLoc) += *(A+jFlag+k+15) * *(bTrans+iFlag+k+15);
				}
			}
		}
		//}
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
	
	
//	// Execute the provided, naive matmul
//	barrier(nc);
//	stats(matmul_naive(DIM_SIZE, input1_data, input2_data, results_data); barrier(nc));
//	
//	
//	// verify
//	verifyMT(ARRAY_SIZE, results_data, verify_data);
//	
//	// clear results from the first trial
//	size_t i;
//	if (coreid == 0) 
//		for (i=0; i < ARRAY_SIZE; i++)
//			results_data[i] = 0;
//	barrier(nc);
	
	
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

