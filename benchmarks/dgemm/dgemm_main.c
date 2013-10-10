//**************************************************************************
// Double-precision general matrix multiplication benchmark
//--------------------------------------------------------------------------

int ncores = 1;
#include "util.h"

//--------------------------------------------------------------------------
// Macros

// Set HOST_DEBUG to 1 if you are going to compile this for a host
// machine (ie Athena/Linux) for debug purposes and set HOST_DEBUG
// to 0 if you are compiling with the smips-gcc toolchain.

#ifndef HOST_DEBUG
#define HOST_DEBUG 0
#endif

// Set PREALLOCATE to 1 if you want to preallocate the benchmark
// function before starting stats. If you have instruction/data
// caches and you don't want to count the overhead of misses, then
// you will need to use preallocation.

#ifndef PREALLOCATE
#define PREALLOCATE 0
#endif

// Set SET_STATS to 1 if you want to carve out the piece that actually
// does the computation.

#ifndef SET_STATS
#define SET_STATS 0
#endif

//--------------------------------------------------------------------------
// Input/Reference Data

#include "dataset1.h"

//--------------------------------------------------------------------------
// Helper functions

int verify( long n, const double test[], const double correct[] )
{
  int i;
  for ( i = 0; i < n; i++ ) {
    if ( test[i] != correct[i] ) {
      return 2;
    }
  }
  return 1;
}

#if HOST_DEBUG
#include <stdio.h>
#include <stdlib.h>
void printArray( char name[], long n, const double arr[] )
{
  int i;
  printf( " %10s :", name );
  for ( i = 0; i < n; i++ )
    printf( " %8.1f ", arr[i] );
  printf( "\n" );
}
#endif

void setStats( int enable )
{
#if ( !HOST_DEBUG && SET_STATS )
  asm( "mtpcr %0, cr10" : : "r" (enable) );
#endif
}

//--------------------------------------------------------------------------
// square_dgemm function

void square_dgemm( long n0, const double a0[], const double b0[], double c0[] )
{
  long n = (n0+2)/3*3;
  double a[n*n], b[n*n], c[n*n];

  for (long i = 0; i < n0; i++)
  {
    long j;
    for (j = 0; j < n0; j++)
    {
      a[i*n+j] = a0[i*n0+j];
      b[i*n+j] = b0[j*n0+i];
    }
    for ( ; j < n; j++)
    {
      a[i*n+j] = b[i*n+j] = 0;
    }
  }
  for (long i = n0; i < n; i++)
    for (long j = 0; j < n; j++)
      a[i*n+j] = b[i*n+j] = 0;

  long i, j, k;
  for (i = 0; i < n; i+=3)
  {
    for (j = 0; j < n; j+=3)
    {
      double *a0 = a + (i+0)*n, *b0 = b + (j+0)*n;
      double *a1 = a + (i+1)*n, *b1 = b + (j+1)*n;
      double *a2 = a + (i+2)*n, *b2 = b + (j+2)*n;

      double s00 = 0, s01 = 0, s02 = 0;
      double s10 = 0, s11 = 0, s12 = 0;
      double s20 = 0, s21 = 0, s22 = 0;

      while (a0 < a + (i+1)*n)
      {
        double a00 = a0[0], a01 = a0[1], a02 = a0[2];
        double b00 = b0[0], b01 = b0[1], b02 = b0[2];
        double a10 = a1[0], a11 = a1[1], a12 = a1[2];
        double b10 = b1[0], b11 = b1[1], b12 = b1[2];
        asm ("" ::: "memory");
        double a20 = a2[0], a21 = a2[1], a22 = a2[2];
        double b20 = b2[0], b21 = b2[1], b22 = b2[2];

        s00 = a00*b00 + (a01*b01 + (a02*b02 + s00));
        s01 = a00*b10 + (a01*b11 + (a02*b12 + s01));
        s02 = a00*b20 + (a01*b21 + (a02*b22 + s02));
        s10 = a10*b00 + (a11*b01 + (a12*b02 + s10));
        s11 = a10*b10 + (a11*b11 + (a12*b12 + s11));
        s12 = a10*b20 + (a11*b21 + (a12*b22 + s12));
        s20 = a20*b00 + (a21*b01 + (a22*b02 + s20));
        s21 = a20*b10 + (a21*b11 + (a22*b12 + s21));
        s22 = a20*b20 + (a21*b21 + (a22*b22 + s22));

        a0 += 3; b0 += 3;
        a1 += 3; b1 += 3;
        a2 += 3; b2 += 3;
      }

      c[(i+0)*n+j+0] = s00; c[(i+0)*n+j+1] = s01; c[(i+0)*n+j+2] = s02;
      c[(i+1)*n+j+0] = s10; c[(i+1)*n+j+1] = s11; c[(i+1)*n+j+2] = s12;
      c[(i+2)*n+j+0] = s20; c[(i+2)*n+j+1] = s21; c[(i+2)*n+j+2] = s22;
    }
  }

  for (long i = 0; i < n0; i++)
  {
    long j;
    for (j = 0; j < n0 - 2; j+=3)
    {
      c0[i*n0+j+0] = c[i*n+j+0];
      c0[i*n0+j+1] = c[i*n+j+1];
      c0[i*n0+j+2] = c[i*n+j+2];
    }
    for ( ; j < n0; j++)
      c0[i*n0+j] = c[i*n+j];
  }
}

//--------------------------------------------------------------------------
// Main

int main( int argc, char* argv[] )
{
  double results_data[DATA_SIZE*DATA_SIZE];

  // Output the input array

#if HOST_DEBUG
  printArray( "input1", DATA_SIZE*DATA_SIZE, input1_data );
  printArray( "input2", DATA_SIZE*DATA_SIZE, input2_data );
  printArray( "verify", DATA_SIZE*DATA_SIZE, verify_data );
#endif

  // If needed we preallocate everything in the caches

#if PREALLOCATE
  square_dgemm( DATA_SIZE, input1_data, input2_data, results_data );
#endif

  // Do the dgemm

  setStats(1);
  square_dgemm( DATA_SIZE, input1_data, input2_data, results_data );
  setStats(0);

  // Print out the results

#if HOST_DEBUG
  printArray( "results", DATA_SIZE*DATA_SIZE, results_data );
#endif

  // Check the results

  finishTest(verify( DATA_SIZE*DATA_SIZE, results_data, verify_data ));

}
