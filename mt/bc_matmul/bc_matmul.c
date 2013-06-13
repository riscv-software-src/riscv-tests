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

#define REG_I 8
#define REG_J 2
//#define BLOCK_I 32
#define BLOCK_J 16
#define BLOCK_K 16
#define LDA 32
#define NCORES 2
#define MIN(X,Y) (X < Y ? X : Y)

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

  int i, j, k, ri, rj, ii, jj, kk;
  data_t *Aj, *Cj, *Bi;
  data_t c[REG_I][REG_J], a[REG_J], b[REG_I];
  size_t start = coreid * (LDA / NCORES), end = (coreid == NCORES - 1 ? LDA : (coreid + 1) * (LDA / NCORES));
     
  /* if (coreid > 0) { */
  /*   return; */
  /* } */
  /* start = 0, end = lda; */
  if (ncores == NCORES && lda == LDA) {
    for (jj = start; jj < end; jj += BLOCK_J)
      for (kk = 0; kk < LDA; kk += BLOCK_K)
	//for (ii = 0; ii < LDA; ii += BLOCK_I)
	for (j = jj; j < MIN(end, jj + BLOCK_J); j += REG_J) {
	  Aj = A + j*LDA;
	  Cj = C + j*LDA;
	  for (i = 0; i < LDA; i += REG_I) {
	    /* Load C in register blocks. */
	    Bi = B + i;
	    for (ri = 0; ri < REG_I; ri++) {
	      for (rj = 0; rj < REG_J; rj++) {
		c[ri][rj] = Cj[i + ri + ( rj)*LDA];
	      }
	    }
	    
	    
	    for (k = kk; k < MIN(LDA, kk + BLOCK_K); k++) {
	      /* Load a,b in register blocks. */
	      /*	  for (rj = 0; rj < REG_J; rj++) {
			  a[rj] = A[(j + rj)*LDA + k];
			  }*/
	      /* for (ri = 0; ri < REG_I; ri++) { */
	      /* 	b[ri] = Bi[k*LDA  + ri]; */
	      /* } */
	      /* /\* Compute C in register blocks. *\/ */
	      /* for (rj = 0; rj < REG_J; rj++) { */
	      /* 	a[rj] = Aj[( rj)*LDA + k]; */
	      /* 	for (ri = 0; ri < REG_I; ri++) { */
	      /* 	  c[ri][rj] += a[rj] * b[ri]; */
	      /* 	} */
	      /* } */
	      a[0] = Aj[k];
	      a[1] = Aj[k + LDA];
	      b[0] = Bi[k*LDA];
	      b[1] = Bi[k*LDA + 1];
	      b[2] = Bi[k*LDA + 2];
	      b[3] = Bi[k*LDA + 3];
	      b[4] = Bi[k*LDA + 4];
	      b[5] = Bi[k*LDA + 5];
	      b[6] = Bi[k*LDA + 6];
	      b[7] = Bi[k*LDA + 7];

	      
	      c[0][0] += b[0] * a[0];
	      c[0][1] += b[0] * a[1];
	      c[1][0] += b[1] * a[0];
	      c[1][1] += b[1] * a[1];
	      c[2][0] += b[2] * a[0];
	      c[2][1] += b[2] * a[1];
	      c[3][0] += b[3] * a[0];
	      c[3][1] += b[3] * a[1];
	      c[4][0] += b[4] * a[0];
	      c[4][1] += b[4] * a[1];
	      c[5][0] += b[5] * a[0];
	      c[5][1] += b[5] * a[1];
	      c[6][0] += b[6] * a[0];
	      c[6][1] += b[6] * a[1];
	      c[7][0] += b[7] * a[0];
	      c[7][1] += b[7] * a[1];
	      

	      /* c[0][0] +=  b[0] * a[0];	       */
	      /* c[1][1] +=  b[1] * a[1];              */
	      /* c[2][0] +=  b[2] * a[0];	       */
	      /* c[3][1] +=  b[3] * a[1];	       */
	      /* c[4][0] +=  b[4] * a[0];	       */
	      /* c[5][1] +=  b[5] * a[1];	       */
	      /* c[6][0] +=  b[6] * a[0];	       */
	      /* c[7][1] +=  b[7] * a[1];	       */
	      /* c[0][0] +=  b[0] * a[0];	       */
	      /* c[1][1] +=  b[1] * a[1];	       */
	      /* c[2][0] +=  b[2] * a[0];	       */
	      /* c[3][1] +=  b[3] * a[1];	       */
	      /* c[4][0] +=  b[4] * a[0];	       */
	      /* c[5][1] +=  b[5] * a[1];	       */
	      /* c[6][0] +=  b[6] * a[0];	       */
	      /* c[7][1] +=  b[7] * a[1];	       */

	    }
      
	    /* store C in register blocks. */
	    for (ri = 0; ri < REG_I; ri++) {
	      for (rj = 0; rj < REG_J; rj++) {
		Cj[i + ri + (rj)*LDA] = c[ri][rj];
	      }
	    }
	  }
	  
	  
	  
	  
	}
    /* We only care about performance for 32x32 matrices and 2 cores. Otherwise just naive mat_mul */
  } else {
    if (coreid > 0)
      return;
    
    for ( i = 0; i < lda; i++ )
      for ( j = 0; j < lda; j++ )  
	for ( k = 0; k < lda; k++ ) 
	  C[i + j*lda] += A[j*lda + k] * B[k*lda + i];
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


//   /* // Execute the provided, naive matmul */
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

