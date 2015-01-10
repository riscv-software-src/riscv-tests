// See LICENSE for license details.

#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>

#include "cvt16.h"

typedef float fftval_t;
#include "fft_data_generic.c"

static void _array(const char *s, const fftval_t *v, unsigned int n)
{
	union single {
		float f;
		uint32_t u;
	} bits;
	unsigned int i;

	printf("fftval_t %s[%u] = { ", s, n);
	for (i = 0; i < n; i++) {
		bits.f = v[i];
		printf("0x%04" PRIx16 ", ", cvt_sh(bits.u, RNE));
	}
	puts("};");
}

#define array(v) _array(#v, (v), (sizeof(v) / sizeof(0[v])))

int main(void)
{
	array(input_data_real);
	array(input_data_imag);
	array(output_data_real);
	array(output_data_imag);
	array(tf_real);
	array(tf_imag);
	return 0;
}
