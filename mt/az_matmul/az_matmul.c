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
 

data_t ffmul(data_t a, data_t b) {
  data_t result = 0;

  for (int i=0; i < b; i++) {
    result += a;
  }

  return result;
}


//void __attribute__((noinline)) matmul(const int lda,  const data_t A[], const data_t B[], data_t C[] )
//{
//   
//   // ***************************** //
//   // **** ADD YOUR CODE HERE ***** //
//   // ***************************** //
//   //
//   // feel free to make a separate function for MI and MSI versions.
//
//    static __thread int i, j, k;
//    static __thread int jlda, ilda;
//    static __thread data_t tempA1, tempA2, tempA3, tempA4, tempA5, tempA6, tempA7, tempA8;
//    static __thread int start, end;
//
//    start = coreid*(lda>>1);
//    end = (coreid+1)*(lda>>1);
//
//    for (j=start; j < end; j+=1) {
//      jlda = j * lda;
//      for ( i=0; i < lda; i+=1 ) {
//        ilda = i*lda;
//        tempA1 = A[i   + jlda];
//        //tempA2 = A[i+1 + jlda];
//        //tempA3 = A[i+2 + jlda];
//        //tempA4 = A[i+3 + jlda];
//        //tempA5 = A[i+4 + jlda];
//        //tempA6 = A[i+5 + jlda];
//        //tempA7 = A[i+6 + jlda];
//        //tempA8 = A[i+7 + jlda];
//        //tempC1 = C[i + j*lda];
//        //tempC2 = C[i+1 + j*lda];
//        for(k=0; k < lda; k+=1) {
//          //C[k   + jlda] += tempA1 * B[k   + i*lda] + tempA2 * B[k   + (i+1)*lda] + tempA3 * B[k   + (i+2)*lda] + tempA4 * B[k   + (i+3)*lda] +
//          //                 tempA5 * B[k   + (i+4)*lda] + tempA6 * B[k   + (i+5)*lda] + tempA7 * B[k   + (i+6)*lda] + tempA8 * B[k   + (i+7)*lda]; 
//          
//          C[k   + jlda] += tempA1* B[k   + i*lda];// + ffmul(tempA2,B[k   + (i+1)*lda]) + tempA3 * B[k   + (i+2)*lda] + tempA4 * B[k   + (i+3)*lda] +
//          //                 tempA5 * B[k   + (i+4)*lda] + tempA6 * B[k   + (i+5)*lda] + tempA7 * B[k   + (i+6)*lda] + tempA8 * B[k   + (i+7)*lda]; 
//          //
//          //C[k+1 + jlda] += tempA1 * B[k+1 + i*lda] + tempA2 * B[k+1 + (i+1)*lda] + tempA3 * B[k+1 + (i+2)*lda] + tempA4 * B[k+1 + (i+3)*lda] +
//          //                 tempA5 * B[k+1   + (i+4)*lda] + tempA6 * B[k+1   + (i+5)*lda] + tempA7 * B[k+1   + (i+6)*lda] + tempA8 * B[k+1   + (i+7)*lda]; 
//          //
//          //C[k+2 + jlda] += tempA1 * B[k+2 + i*lda] + tempA2 * B[k+2 + (i+1)*lda] + tempA3 * B[k+2 + (i+2)*lda] + tempA4 * B[k+2 + (i+3)*lda] +
//          //                 tempA5 * B[k+2   + (i+4)*lda] + tempA6 * B[k+2   + (i+5)*lda] + tempA7 * B[k+2   + (i+6)*lda] + tempA8 * B[k+2   + (i+7)*lda]; 
//          //
//          //C[k+3 + jlda] += tempA1 * B[k+3 + i*lda] + tempA2 * B[k+3 + (i+1)*lda] + tempA3 * B[k+3 + (i+2)*lda] + tempA4 * B[k+3 + (i+3)*lda] +
//          //                 tempA5 * B[k+3   + (i+4)*lda] + tempA6 * B[k+3   + (i+5)*lda] + tempA7 * B[k+3   + (i+6)*lda] + tempA8 * B[k+3   + (i+7)*lda]; 
//          //
//          //C[k+4 + jlda] += tempA1 * B[k+4 + i*lda] + tempA2 * B[k+4 + (i+1)*lda] + tempA3 * B[k+4 + (i+2)*lda] + tempA4 * B[k+4 + (i+3)*lda] +
//          //                 tempA5 * B[k+4   + (i+4)*lda] + tempA6 * B[k+4   + (i+5)*lda] + tempA7 * B[k+4   + (i+6)*lda] + tempA8 * B[k+4   + (i+7)*lda]; 
//          //
//          //C[k+5 + jlda] += tempA1 * B[k+5 + i*lda] + tempA2 * B[k+5 + (i+1)*lda] + tempA3 * B[k+5 + (i+2)*lda] + tempA4 * B[k+5 + (i+3)*lda] +
//          //                 tempA5 * B[k+5   + (i+4)*lda] + tempA6 * B[k+5   + (i+5)*lda] + tempA7 * B[k+5   + (i+6)*lda] + tempA8 * B[k+5   + (i+7)*lda]; 
//          //
//          //C[k+6 + jlda] += tempA1 * B[k+6 + i*lda] + tempA2 * B[k+6 + (i+1)*lda] + tempA3 * B[k+6 + (i+2)*lda] + tempA4 * B[k+6 + (i+3)*lda] +
//          //                 tempA5 * B[k+6   + (i+4)*lda] + tempA6 * B[k+6   + (i+5)*lda] + tempA7 * B[k+6   + (i+6)*lda] + tempA8 * B[k+6   + (i+7)*lda]; 
//          //
//          //C[k+7 + jlda] += tempA1 * B[k+7 + i*lda] + tempA2 * B[k+7 + (i+1)*lda] + tempA3 * B[k+7 + (i+2)*lda] + tempA4 * B[k+7 + (i+3)*lda] +
//          //                 tempA5 * B[k+7   + (i+4)*lda] + tempA6 * B[k+7   + (i+5)*lda] + tempA7 * B[k+7   + (i+6)*lda] + tempA8 * B[k+7   + (i+7)*lda]; 
//          
//
//        }
//      }
//    }
//}


void __attribute__((noinline)) matmul(const int lda,  const data_t A[], const data_t B[], data_t C[] )
{
   
   // ***************************** //
   // **** ADD YOUR CODE HERE ***** //
   // ***************************** //
   //
   // feel free to make a separate function for MI and MSI versions.

    static __thread int i, j, k;
    static __thread data_t tempA0, tempA1, tempA2, tempA3, tempA4, tempA5, tempA6, tempA7;
    static __thread data_t tempC0, tempC1, tempC2, tempC3, tempC4, tempC5, tempC6, tempC7; //tempC8, tempC9, tempC10, tempC11, tempC12, tempC13, tempC14, tempC15;

    static __thread int start, end, jStride, jToRow, jToCol, iToRow;

    start = coreid << 9;
    end = (coreid+1) << 9;
    jStride = 8;

    for (j=start; j < end; j+=jStride) {
      jToRow = (j>>5)<<5;
      jToCol = j%32;
      tempC0  = 0;
      tempC1  = 0;
      tempC2  = 0;
      tempC3  = 0;
      tempC4  = 0;
      tempC5  = 0;
      tempC6  = 0;
      tempC7  = 0;
      //tempC8  = 0;
      //tempC9  = 0;
      //tempC10 = 0;
      //tempC11 = 0;
      //tempC12 = 0;
      //tempC13 = 0;
      //tempC14 = 0;
      //tempC15 = 0;
      
      for ( i=0; i < lda; i+=2 ) {
        iToRow = i << 5;

        tempA0 = A[i   + jToRow];
        tempA1 = A[i+1 + jToRow];
        //tempA2 = A[i+2 + jToRow];
        //tempA3 = A[i+3 + jToRow];
        //tempA4 = A[i+4 + jToRow];
        //tempA5 = A[i+5 + jToRow];
        //tempA6 = A[i+6 + jToRow];
        //tempA7 = A[i+7 + jToRow];
        
        tempC0  += tempA0 * B[(jToCol   ) + (iToRow)];
        tempC1  += tempA0 * B[(jToCol+1 ) + (iToRow)];
        tempC2  += tempA0 * B[(jToCol+2 ) + (iToRow)];
        tempC3  += tempA0 * B[(jToCol+3 ) + (iToRow)];
        tempC4  += tempA0 * B[(jToCol+4 ) + (iToRow)];
        tempC5  += tempA0 * B[(jToCol+5 ) + (iToRow)];
        tempC6  += tempA0 * B[(jToCol+6 ) + (iToRow)];
        tempC7  += tempA0 * B[(jToCol+7 ) + (iToRow)];
        //tempC8  += tempA0 * B[(jToCol+8 ) + (iToRow)];
        //tempC9  += tempA0 * B[(jToCol+9 ) + (iToRow)];
        //tempC10 += tempA0 * B[(jToCol+10) + (iToRow)];
        //tempC11 += tempA0 * B[(jToCol+11) + (iToRow)];
        //tempC12 += tempA0 * B[(jToCol+12) + (iToRow)];
        //tempC13 += tempA0 * B[(jToCol+13) + (iToRow)];
        //tempC14 += tempA0 * B[(jToCol+14) + (iToRow)];
        //tempC15 += tempA0 * B[(jToCol+15) + (iToRow)];
        
        iToRow += 32;
        tempC0  += tempA1 * B[(jToCol   ) + (iToRow)];
        tempC1  += tempA1 * B[(jToCol+1 ) + (iToRow)];
        tempC2  += tempA1 * B[(jToCol+2 ) + (iToRow)];
        tempC3  += tempA1 * B[(jToCol+3 ) + (iToRow)];
        tempC4  += tempA1 * B[(jToCol+4 ) + (iToRow)];
        tempC5  += tempA1 * B[(jToCol+5 ) + (iToRow)];
        tempC6  += tempA1 * B[(jToCol+6 ) + (iToRow)];
        tempC7  += tempA1 * B[(jToCol+7 ) + (iToRow)];
        //tempC8  += tempA1 * B[(jToCol+8 ) + (iToRow+32)];
        //tempC9  += tempA1 * B[(jToCol+9 ) + (iToRow+32)];
        //tempC10 += tempA1 * B[(jToCol+10) + (iToRow+32)];
        //tempC11 += tempA1 * B[(jToCol+11) + (iToRow+32)];
        //tempC12 += tempA1 * B[(jToCol+12) + (iToRow+32)];
        //tempC13 += tempA1 * B[(jToCol+13) + (iToRow+32)];
        //tempC14 += tempA1 * B[(jToCol+14) + (iToRow+32)];
        //tempC15 += tempA1 * B[(jToCol+15) + (iToRow+32)];
        
        //iToRow += 32;
        //tempC0  += tempA2 * B[(jToCol   ) + (iToRow)];
        //tempC1  += tempA2 * B[(jToCol+1 ) + (iToRow)];
        //tempC2  += tempA2 * B[(jToCol+2 ) + (iToRow)];
        //tempC3  += tempA2 * B[(jToCol+3 ) + (iToRow)];
        //tempC4  += tempA2 * B[(jToCol+4 ) + (iToRow)];
        //tempC5  += tempA2 * B[(jToCol+5 ) + (iToRow)];
        //tempC6  += tempA2 * B[(jToCol+6 ) + (iToRow)];
        //tempC7  += tempA2 * B[(jToCol+7 ) + (iToRow)];
        //tempC8  += tempA2 * B[(jToCol+8 ) + (iToRow)];
        //tempC9  += tempA2 * B[(jToCol+9 ) + (iToRow)];
        //tempC10 += tempA2 * B[(jToCol+10) + (iToRow)];
        //tempC11 += tempA2 * B[(jToCol+11) + (iToRow)];
        //tempC12 += tempA2 * B[(jToCol+12) + (iToRow)];
        //tempC13 += tempA2 * B[(jToCol+13) + (iToRow)];
        //tempC14 += tempA2 * B[(jToCol+14) + (iToRow)];
        //tempC15 += tempA2 * B[(jToCol+15) + (iToRow)];
        
        //iToRow += 32;
        //tempC0  += tempA3 * B[(jToCol   ) + (iToRow)];
        //tempC1  += tempA3 * B[(jToCol+1 ) + (iToRow)];
        //tempC2  += tempA3 * B[(jToCol+2 ) + (iToRow)];
        //tempC3  += tempA3 * B[(jToCol+3 ) + (iToRow)];
        //tempC4  += tempA3 * B[(jToCol+4 ) + (iToRow)];
        //tempC5  += tempA3 * B[(jToCol+5 ) + (iToRow)];
        //tempC6  += tempA3 * B[(jToCol+6 ) + (iToRow)];
        //tempC7  += tempA3 * B[(jToCol+7 ) + (iToRow)];
        //tempC8  += tempA3 * B[(jToCol+8 ) + (iToRow)];
        //tempC9  += tempA3 * B[(jToCol+9 ) + (iToRow)];
        //tempC10 += tempA3 * B[(jToCol+10) + (iToRow)];
        //tempC11 += tempA3 * B[(jToCol+11) + (iToRow)];
        //tempC12 += tempA3 * B[(jToCol+12) + (iToRow)];
        //tempC13 += tempA3 * B[(jToCol+13) + (iToRow)];
        //tempC14 += tempA3 * B[(jToCol+14) + (iToRow)];
        //tempC15 += tempA3 * B[(jToCol+15) + (iToRow)];
        
        //iToRow += 32;
        //tempC0 += tempA4 * B[(jToCol   ) + (iToRow)];
        //tempC1 += tempA4 * B[(jToCol+1 ) + (iToRow)];
        //tempC2 += tempA4 * B[(jToCol+2 ) + (iToRow)];
        //tempC3 += tempA4 * B[(jToCol+3 ) + (iToRow)];
        //tempC4 += tempA4 * B[(jToCol+4 ) + (iToRow)];
        //tempC5 += tempA4 * B[(jToCol+5 ) + (iToRow)];
        //tempC6 += tempA4 * B[(jToCol+6 ) + (iToRow)];
        //tempC7 += tempA4 * B[(jToCol+7 ) + (iToRow)];
        //
        //iToRow += 32;
        //tempC0 += tempA5 * B[(jToCol   ) + (iToRow)];
        //tempC1 += tempA5 * B[(jToCol+1 ) + (iToRow)];
        //tempC2 += tempA5 * B[(jToCol+2 ) + (iToRow)];
        //tempC3 += tempA5 * B[(jToCol+3 ) + (iToRow)];
        //tempC4 += tempA5 * B[(jToCol+4 ) + (iToRow)];
        //tempC5 += tempA5 * B[(jToCol+5 ) + (iToRow)];
        //tempC6 += tempA5 * B[(jToCol+6 ) + (iToRow)];
        //tempC7 += tempA5 * B[(jToCol+7 ) + (iToRow)];
        //
        //iToRow += 32;
        //tempC0 += tempA6 * B[(jToCol   ) + (iToRow)];
        //tempC1 += tempA6 * B[(jToCol+1 ) + (iToRow)];
        //tempC2 += tempA6 * B[(jToCol+2 ) + (iToRow)];
        //tempC3 += tempA6 * B[(jToCol+3 ) + (iToRow)];
        //tempC4 += tempA6 * B[(jToCol+4 ) + (iToRow)];
        //tempC5 += tempA6 * B[(jToCol+5 ) + (iToRow)];
        //tempC6 += tempA6 * B[(jToCol+6 ) + (iToRow)];
        //tempC7 += tempA6 * B[(jToCol+7 ) + (iToRow)];
        //
        //iToRow += 32;
        //tempC0 += tempA7 * B[(jToCol   ) + (iToRow)];
        //tempC1 += tempA7 * B[(jToCol+1 ) + (iToRow)];
        //tempC2 += tempA7 * B[(jToCol+2 ) + (iToRow)];
        //tempC3 += tempA7 * B[(jToCol+3 ) + (iToRow)];
        //tempC4 += tempA7 * B[(jToCol+4 ) + (iToRow)];
        //tempC5 += tempA7 * B[(jToCol+5 ) + (iToRow)];
        //tempC6 += tempA7 * B[(jToCol+6 ) + (iToRow)];
        //tempC7 += tempA7 * B[(jToCol+7 ) + (iToRow)];
        
      }
      C[j     ] = tempC0;
      C[j + 1 ] = tempC1;
      C[j + 2 ] = tempC2;
      C[j + 3 ] = tempC3;
      C[j + 4 ] = tempC4;
      C[j + 5 ] = tempC5;
      C[j + 6 ] = tempC6;
      C[j + 7 ] = tempC7;
      //C[j + 8 ] = tempC8 ;
      //C[j + 9 ] = tempC9 ;
      //C[j + 10] = tempC10;
      //C[j + 11] = tempC11;
      //C[j + 12] = tempC12;
      //C[j + 13] = tempC13;
      //C[j + 14] = tempC14;
      //C[j + 15] = tempC15;
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


   //// Execute the provided, naive matmul
   //barrier(nc);
   //stats(matmul_naive(DIM_SIZE, input1_data, input2_data, results_data); barrier(nc));
 
   //
   //// verify
   //verifyMT(ARRAY_SIZE, results_data, verify_data);
   //
   //// clear results from the first trial
   //size_t i;
   //if (coreid == 0) 
   //   for (i=0; i < ARRAY_SIZE; i++)
   //      results_data[i] = 0;
   //barrier(nc);

   
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

