#include "memcpy.h"
#include <stdlib.h>
#include <stdint.h>

void fill(int *arr, size_t n)
{
	for (int i = 0; i < n; i++) {
		arr[i] = i << 4;
	}
}

#pragma GCC optimize ("unroll-loops")

#define UNROLL 4

void fast_memcpy(void *dst, void *src, size_t len)
{
	uintptr_t ptr_mask = (uintptr_t) dst | (uintptr_t) src | len;

	if ((ptr_mask & (sizeof(uintptr_t) - 1)) == 0) {
		uintptr_t *d = dst, *s = src;
		size_t n = len / sizeof(uintptr_t);
		size_t lenu = ((n / UNROLL) * UNROLL) * sizeof(uintptr_t);

		while (d < (uintptr_t *)(dst + lenu)) {
			for (int i = 0; i < UNROLL; i++)
				d[i] = s[i];
			d += UNROLL;
			s += UNROLL;
		}

		while (d < (uintptr_t *)(dst + len))
			*(d++) = *(s++);
	} else {
		char *d = dst, *s = src;

		while (d < (char *)(dst + len))
			*(d++) = *(s++);
	}
}
