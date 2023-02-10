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



//--------------------------------------------------------------------------
// Main
//
// all threads start executing thread_entry(). Use their "coreid" to
// differentiate between threads (each thread is running on a separate core).

void thread_entry(int cid, int nc)
{
   // static allocates data in the binary, which is visible to both threads
   static long results_data[DATA_SIZE];

   size_t block = (DATA_SIZE / nc) + 1;
   size_t n = (nc == cid + 1) ? DATA_SIZE - cid * block : block;


   // First do out-of-place memcpy
#if PREALLOCATE
   barrier(nc);
   memcpy(results_data + block * cid, input_data + block * cid, sizeof(long) * n);
#endif

   barrier(nc);
   stats(memcpy(results_data + block * cid, input_data + block * cid, sizeof(long) * n); barrier(nc), DATA_SIZE);
   barrier(nc);

   if (cid == 0) {
     int res = verify(DATA_SIZE * sizeof(long) / sizeof(int), (int*) results_data, (int*) input_data);
     if (res) exit(res);
   }
   barrier(nc);
   exit(0);
}
