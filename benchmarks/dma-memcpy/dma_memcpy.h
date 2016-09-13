#ifndef __DMA_MEMCPY_H__
#define __DMA_MEMCPY_H__

#include <stdlib.h>

void fill(int *arr, size_t n);
void dma_memcpy(void *dst, void *src, size_t len);

#endif
