// See LICENSE for license details.

#ifndef __FFT_CONST_H
#define __FFT_CONST_H

#ifndef FFT_SIZE
#define FFT_SIZE 1024
#endif /* FFT_SIZE */

#if 0
  #define FFT_FIXED
  #define DATA_IN_PERMUTED
#else
//  #define DATA_IN_UNPERMUTED
  #define FFT_FLOATING
  #define FFT_FLOATING_PREC 64
#endif

#if defined(FFT_FIXED)
  #define FIX_PT 20
  #define DATA_WIDTH 32
#elif defined(FFT_FLOATING)
  #if FFT_FLOATING_PREC == 16
    #define FP_HALF
  #elif FFT_FLOATING_PREC == 32
    #define FP_SINGLE
  #elif FFT_FLOATING_PREC == 64
    #define FP_DOUBLE
  #else
    #error "Unsupported floating-point configuration"
  #endif
  #define DATA_WIDTH FFT_FLOATING_PREC
#else
  #error "Define fixed or floating point in fft_const.h"
#endif

#if !defined(__ASSEMBLY__)

#include <stdint.h>
#include <inttypes.h>

#if defined(FFT_FIXED)
  typedef int fftval_t;
  typedef int fftbit_t;
  #define FFT_PRI "%08x"
#elif defined(FFT_FLOATING)
  #if defined(FP_HALF)
    typedef uint16_t fftval_t;
    typedef uint16_t fftbit_t;
    #define FFT_PRI "%04" PRIx16
  #elif defined(FP_SINGLE)
    typedef float fftval_t;
    typedef uint32_t fftbit_t;
    #define FFT_PRI "%08" PRIx32
  #elif defined(FP_DOUBLE)
    typedef double fftval_t;
    typedef uint64_t fftbit_t;
    #define FFT_PRI "%016" PRIx64
  #endif
#endif

extern fftval_t input_data_real[FFT_SIZE];
extern fftval_t input_data_imag[FFT_SIZE];
extern fftval_t output_data_real[FFT_SIZE];
extern fftval_t output_data_imag[FFT_SIZE];
extern fftval_t tf_real[FFT_SIZE];
extern fftval_t tf_imag[FFT_SIZE];

#endif /* __ASSEMBLY__ */

#endif /* __FFT_CONST_H */
