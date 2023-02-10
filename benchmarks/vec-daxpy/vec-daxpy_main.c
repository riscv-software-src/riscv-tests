// See LICENSE for license details.

//**************************************************************************
// Memcpy benchmark
//--------------------------------------------------------------------------
//
// This benchmark tests a vectorized sazpy implementation.
// The input data (and reference data) should be generated using
// the daxpy_gendata.pl perl script and dumped to a file named
// dataset1.h.

#include <string.h>
#include "util.h"

//--------------------------------------------------------------------------
// Input/Reference Data

typedef double data_t;
#include "dataset1.h"

//--------------------------------------------------------------------------
// Main

void vec_daxpy(size_t n, const double a, const double *x, const double *y, double* z);


int main( int argc, char* argv[] )
{
  data_t results_data[DATA_SIZE];

#if PREALLOCATE
  // If needed we preallocate everything in the caches
  vec_daxpy(DATA_SIZE, input0, input1_data, input2_data, results_data);
#endif

  // Do the daxpy
  setStats(1);
  vec_daxpy(DATA_SIZE, input0, input1_data, input2_data, results_data);
  setStats(0);

  // Check the results
  return verifyDouble( DATA_SIZE, results_data, verify_data );
}
