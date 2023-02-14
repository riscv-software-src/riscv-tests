// See LICENSE for license details.

//**************************************************************************
// Strcmp benchmark
//--------------------------------------------------------------------------
//
// This benchmark tests a vectorized strcmp implementation.

#include <string.h>
#include "util.h"

//--------------------------------------------------------------------------
// Input/Reference Data

const char* test_str = "The quick brown fox jumped over the lazy dog";
const char* same_str = "The quick brown fox jumped over the lazy dog";
char* diff_str = "The quick brown fox jumped over the lazy cat";

//--------------------------------------------------------------------------
// Main

int vec_strcmp(const char *src1, const char* src2);

int main( int argc, char* argv[] )
{
  // Do the strcmp
  setStats(1);
  int r0 = vec_strcmp(test_str, same_str);
  int r1 = vec_strcmp(test_str, diff_str);
  setStats(0);

  // Check the results
  return !(r0 == 0 && r1 != 0);
}
