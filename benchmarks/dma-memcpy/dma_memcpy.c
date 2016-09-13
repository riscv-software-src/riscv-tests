#include "dma_memcpy.h"
#include "dma-ext.h"

void fill(int *arr, size_t n)
{
	for (int i = 0; i < n; i++) {
		arr[i] = i << 4;
	}
}

void dma_memcpy(void *dst, void *src, size_t len)
{
	dma_write_cr(NSEGMENTS, 1);
	dma_write_cr(SEGMENT_SIZE, len);
	dma_transfer(dst, src);
}
