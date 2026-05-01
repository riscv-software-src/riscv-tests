// See LICENSE for license details.

//**************************************************************************
// Memcpy benchmark
//--------------------------------------------------------------------------
// Author  : Jerry Zhao
// TA      :
// Student :
//
// This benchmark tests the memcpy implementation in syscalls.c.
// The input data (and reference data) should be generated using
// the memcpy_gendata.pl perl script and dumped to a file named
// dataset1.h.


//--------------------------------------------------------------------------
// Includes

#include <string.h>
#include <stdlib.h>
#include <stdio.h>


//--------------------------------------------------------------------------
// Input/Reference Data

#include "dataset1.h"


//--------------------------------------------------------------------------
// Basic Utilities and Multi-thread Support

#include "util.h"

static barrier_global_data_t bar;

//--------------------------------------------------------------------------
// Main
//
// all threads start executing thread_entry(). Use their "coreid" to
// differentiate between threads (each thread is running on a separate core).

void thread_entry(int cid, int nc)
{
   // static allocates data in the binary, which is visible to both threads
   static long results_data[DATA_SIZE];
   barrier_local_data_t lbar = {nc};

   size_t block = (DATA_SIZE / nc) + 1;
   size_t n = (nc == cid + 1) ? DATA_SIZE - cid * block : block;


   // First do out-of-place memcpy
#if PREALLOCATE
   barrier(&bar, &lbar);
   memcpy(results_data + block * cid, input_data + block * cid, sizeof(long) * n);
#endif

   barrier(&bar, &lbar);
   stats(memcpy(results_data + block * cid, input_data + block * cid, sizeof(long) * n); barrier(&bar, &lbar), DATA_SIZE);
   barrier(&bar, &lbar);

   if (cid == 0) {
     int res = verify(DATA_SIZE * sizeof(long) / sizeof(int), (int*) results_data, (int*) input_data);
     if (res) exit(res);
   }
   barrier(&bar, &lbar);
   exit(0);
}
