#include "dataset.h"
#include "util.h"

//--------------------------------------------------------------------------
// single-thread, naive version
//
void __attribute__((noinline)) matmul(const int coreid, const int ncores, const int lda,  const data_t A[], const data_t B[], data_t C[] )
{
   int i, j, k;
  
   for ( i = 0; i < lda; i++ )
   {
      for ( j = 0; j < lda; j++ )  
      {
         for ( k = coreid; k < lda; k+=ncores ) 
         {
            C[i + j*lda] += A[j*lda + k] * B[k*lda + i];
         }
         barrier(ncores);
      }
   }
}
