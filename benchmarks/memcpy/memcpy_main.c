#include <stdio.h>
#include <string.h>
#include "util.h"
#include "memcpy.h"

#define MAX_SIZE 256 * 1024
#define START_SIZE 1024

int a[MAX_SIZE / sizeof(int)];
int b[MAX_SIZE / sizeof(int)];

void thread_entry(int cid, int nc)
{

	int copy_size = START_SIZE;

	fill(a, MAX_SIZE / sizeof(uint64_t));

	while (copy_size <= MAX_SIZE) {
		// These two make sure the cache starts in approx. same state
		memcpy(b, a, MAX_SIZE);
		memset(b, 0, MAX_SIZE);
		printf("%d: ", copy_size);
		stats(asm volatile ("fence"); fast_memcpy(b, a, copy_size) ; asm volatile ("fence"), 3);
		verify(copy_size / sizeof(int), b, a);
		copy_size *= 2;
	}

	exit(0);
}
