// See LICENSE for license details.

#ifndef __VEC_FFT_H
#define __VEC_FFT_H

#include "fft_const.h"

// Simple C version

int log2down(int in);
void fft(fftval_t workspace_real[], fftval_t workspace_imag[], const fftval_t tf_real[], const fftval_t tf_imag[]);

// VF blocks - DO NOT CALL FROM SCALAR CORE
extern void vf_test();
extern void vf_fft_init();
extern void vf_fft_scale();
extern void vf_fft_exec();
extern void vf_fft_store1();
extern void vf_fft_store2();

#endif /* __VEC_FFT_H */
