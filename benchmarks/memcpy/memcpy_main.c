#include <stdio.h>
#include "util.h"
#include "memcpy.h"

#define MAX_SIZE 4 * 4096
#define START_SIZE 256

int a[MAX_SIZE / sizeof(int)];
int b[MAX_SIZE / sizeof(int)];

void thread_entry(int cid, int nc)
{

	int copy_size = START_SIZE;

	fill(a, MAX_SIZE / sizeof(uint64_t));
	asm volatile ("fence");

	while (copy_size <= MAX_SIZE) {
		memcpy(b, a, MAX_SIZE);
		printf("%d: ", copy_size);
		stats(fast_memcpy(b, a, copy_size), 3);
		verify(copy_size / sizeof(int), b, a);
		copy_size *= 2;
	}

	exit(0);
}
