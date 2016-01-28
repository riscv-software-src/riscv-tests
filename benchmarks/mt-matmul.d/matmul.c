// See LICENSE for license details.

#include "dataset.h"
#include "util.h"

void __attribute__((noinline)) matmul(const int coreid, const int ncores, const int lda,  const data_t A[], const data_t B[], data_t C[] )
{
   int i, j, k;
   int block = lda / ncores;
   int start = block * coreid;
 
   for ( j = start; j < (start+block); j++ ) 
   {
      for ( k = 0; k < lda; k++ )  
      {
         for ( i = 0; i < lda; i++ ) 
         {
            C[i + j*lda] += A[j*lda + k] * B[k*lda + i];
         }
      }
   }
}
