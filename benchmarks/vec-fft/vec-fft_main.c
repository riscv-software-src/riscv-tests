// See LICENSE for license details.

// *************************************************************************
// multiply filter bencmark
// -------------------------------------------------------------------------
//
// This benchmark tests the software multiply implemenation. The
// input data (and reference data) should be generated using the
// multiply_gendata.pl perl script and dumped to a file named
// dataset1.h You should not change anything except the
// HOST_DEBUG and VERIFY macros for your timing run.

#include "vec-fft.h"

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

// Set VERIFY to 1 if you want the program to check that the sort
// function returns the right answer. When you are doing your 
// benchmarking you should set this to 0 so that the verification
// is not included in your timing.

#ifndef VERIFY
#define VERIFY     1
#endif

// Set SET_STATS to 1 if you want to carve out the piece that actually
// does the computation.

#ifndef SET_STATS
#define SET_STATS 0
#endif

// Set MINIMAL to 1 if you want to run the core FFT kernel without
// any instrumentation or warm-up.
#ifndef MINIMAL
#define MINIMAL 1
#endif

//--------------------------------------------------------------------------
// Platform Specific Includes

#if HOST_DEBUG
   #include <stdio.h>
   #include <stdlib.h>
#else
void printstr(const char*);
void exit();
#endif


//--------------------------------------------------------------------------
// Input/Reference Data

#include "fft_const.h"

//--------------------------------------------------------------------------
// Helper functions

#if !MINIMAL

void setup_input(int n, fftval_t in_real[], fftval_t in_imag[])
{
  int i;
  for(i=0; i < n; i++) {
    in_real[i] = input_data_real[i];
    in_imag[i] = input_data_imag[i];
  }
}
void setup_warm_tf(int n, fftval_t in_real[], fftval_t in_imag[])
{
  int i;
  for(i=0; i < n; i++) {
    in_real[i] = tf_real[i];
    in_imag[i] = tf_imag[i];
  }
}

fftval_t calculate_error( int n, const fftval_t test_real[], const fftval_t test_imag[])
{
  fftval_t current_max = 0;
  printf("idx, real expected, real observed, imag expected, imag observed %d\n", 0);

#if defined(FFT_FIXED)
  for(int i = 0; i < n; i++)
  {
    const double scale = 1 << FIX_PT;
    const double real_diff = (test_real[i] - output_data_real[i])/scale;
    const double imag_diff = (test_imag[i] - output_data_imag[i])/scale;

    const double i_sq_error = real_diff*real_diff + imag_diff*imag_diff;
    if(i_sq_error > current_max) {
      printf("i = %d, current error: %d\n", i, (long)current_max);
      current_max = i_sq_error;
    }
  }
#elif defined(FFT_FLOATING)
  fftval_t real_expect = 0.0;
  fftval_t imag_expect = 0.0;
  for(int i = 0; i < n; i++)
  {
    /* TODO: Fix error caculation for half precision */
    const fftval_t real_diff = (test_real[i] - output_data_real[i]);
    const fftval_t imag_diff = (test_imag[i] - output_data_imag[i]);
    fftval_t i_sq_error = real_diff*real_diff + imag_diff*imag_diff;

#if 0
    long tr = (long)(test_real[i] * 1000000000);
    long ti = (long)(test_imag[i] * 1000000000);
    long er = (long)(output_data_real[i] * 1000000000);
    long ei = (long)(output_data_imag[i] * 1000000000);

    printf("i = %d, expected (%d,%d) and got (%d,%d), diff (%d,%d)\n",
           i, 
           er, ei,
           tr, ti,
           er-tr, ei-ti);
#endif

#if 1
    fftbit_t tr, ti, er, ei;
#ifdef FP_HALF
    tr = test_real[i];
    ti = test_imag[i];
    er = output_data_real[i];
    ei = output_data_imag[i];
#else
    union bits {
      fftval_t v;
      fftbit_t u;
    } bits;
    bits.v = test_real[i]; tr = bits.u;
    bits.v = test_imag[i]; ti = bits.u;
    bits.v = output_data_real[i]; er = bits.u;
    bits.v = output_data_imag[i]; ei = bits.u;
#endif
    printf("%d: %d %d %d %d\n", i, er, tr, ei, ti);
    // printf("%4d\t" FFT_PRI "\t" FFT_PRI "\t" FFT_PRI "\t" FFT_PRI "\n",
    //       i, er, tr, ei, ti);
#endif

#if 0
    if(i_sq_error > current_max) {
      printf("i = %d, max error (ppb): %ld\n", i, (long)(current_max * 1000000000));
      current_max = i_sq_error;
      real_expect = output_data_real[i];
      imag_expect = output_data_imag[i];
    }
#endif
  }
/*
  printf("real expected: %d\n", (long)(real_expect));
  printf("imag expected: %d\n", (long)(imag_expect));
*/
#endif
  
  return current_max;
}

void finishTest( double max_sq_error, long long num_cycles, long long num_retired)
{
  int passed = max_sq_error < 10e-8;

  if( passed ) printstr("*** PASSED ***");
  else printstr("*** FAILED ***");

  printf(" (num_cycles = %ld, num_inst_retired = %ld)\n", num_cycles, num_retired);

  passed = passed ? 1 : 2; // if it passed, return 1

  exit();
}

void setStats( int enable )
{
#if ( !HOST_DEBUG && SET_STATS )
  //asm( "mtpcr %0, cr10" : : "r" (enable) );
#endif
}

long long getCycles()
{
   long long cycles = 1337;
#if ( !HOST_DEBUG && SET_STATS )
  __asm__ __volatile__( "rdcycle %0" : "=r" (cycles) );
#endif
  return cycles;
}

long long getInstRetired()
{
   long long inst_retired = 1338;
#if ( !HOST_DEBUG && SET_STATS )
  __asm__ __volatile__( "rdinstret %0" : "=r" (inst_retired) );
#endif
  return inst_retired;
}

#endif /* !MINIMAL */

//--------------------------------------------------------------------------
// Main
#define HWACHA_RADIX 2

#ifdef DATA_IN_UNPERMUTED
void permute(fftval_t workspace_real[], fftval_t workspace_imag[])
{
  const int logradix = log2down(HWACHA_RADIX);
  const int term_mask = HWACHA_RADIX-1;
  const int num_term = log2down(FFT_SIZE)/logradix;
  for(int i = 0; i < FFT_SIZE; i++)
  {
    // Get permuted address
    int i_left = i;
    int permuted = 0;
    for(int cur_fft_size=HWACHA_RADIX; cur_fft_size <= FFT_SIZE; cur_fft_size = cur_fft_size << logradix)
    {
      permuted = (permuted << logradix) | (i_left & term_mask);
      i_left = i_left >> logradix;
    }
    // If addresses are different and i < permuted (so we only do permutation once)
    if(i < permuted)
    {
      fftval_t t = workspace_real[i];
      fftval_t u = workspace_imag[i];
      workspace_real[i] = workspace_real[permuted];
      workspace_imag[i] = workspace_imag[permuted];
      workspace_real[permuted] = t;
      workspace_imag[permuted] = u;
    }
  }
}
#endif /* DATA_IN_UNPERMUTED */

#if MINIMAL

int main(void)
{
#ifdef DATA_IN_UNPERMUTED
  permute(input_data_real, input_data_imag);
#endif
  fft(input_data_real, input_data_imag, tf_real, tf_imag);
//  calculate_error(FFT_SIZE, input_data_real, input_data_imag);
  exit();
}

#else /* !MINIMAL */

int main(void)
{
  static fftval_t workspace_real[FFT_SIZE];
  static fftval_t workspace_imag[FFT_SIZE];
  static fftval_t warm_tf_real[FFT_SIZE];
  static fftval_t warm_tf_imag[FFT_SIZE];
  setup_input(FFT_SIZE, workspace_real, workspace_imag);
  setup_warm_tf(FFT_SIZE, warm_tf_real, warm_tf_imag);

#if PREALLOCATE
  fft(workspace_real, workspace_imag, warm_tf_real, warm_tf_imag);
  setup_input(FFT_SIZE, workspace_real, workspace_imag);
#endif

  long long start_cycles, start_retired, stop_cycles, stop_retired;
  start_cycles = getCycles();
  start_retired = getInstRetired();

#ifdef DATA_IN_UNPERMUTED
  permute(workspace_real, workspace_imag);
#endif
  setStats(1);
  fft(workspace_real, workspace_imag, warm_tf_real, warm_tf_imag);
  setStats(0);
  
  stop_cycles = getCycles();
  stop_retired = getInstRetired();
  long long num_cycles = stop_cycles - start_cycles;
  long long num_retired = stop_retired - start_retired;
  
  const double max_sq_error = calculate_error(FFT_SIZE, workspace_real, workspace_imag); 
  
  // Check the results
  finishTest(max_sq_error, num_cycles, num_retired);
}

#endif /* MINIMAL */
