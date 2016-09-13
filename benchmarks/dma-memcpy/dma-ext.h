#ifndef __DMA_EXT_H__
#define __DMA_EXT_H__

#define SRC_STRIDE 0
#define DST_STRIDE 1
#define SEGMENT_SIZE 2
#define NSEGMENTS 3
#define ALLOC 4
#define RESP_STATUS 5

#define ALLOC_GET 1
#define ALLOC_PUT 2

static inline void dma_write_cr(int regnum, unsigned long value)
{
	asm volatile ("custom2 0, %[regnum], %[value], 5" ::
			[regnum] "r" (regnum), [value] "r" (value));
}

static inline unsigned long dma_read_cr(int regnum)
{
	int value;
	asm volatile ("custom2 %[value], %[regnum], 0, 4" : 
			[value] "=r" (value) : [regnum] "r" (regnum));
	return value;
}

static inline void dma_transfer(void *dst, void *src)
{
	asm volatile ("custom2 0, %[dst], %[src], 0" ::
			[dst] "r" (dst), [src] "r" (src));
}

static inline void dma_read_prefetch(void *dst)
{
	asm volatile ("custom2 0, %[dst], 0, 2" :: [dst] "r" (dst));
}

static inline void dma_write_prefetch(void *dst)
{
	asm volatile ("custom2 0, %[dst], 0, 3" :: [dst] "r" (dst));
}

#endif
