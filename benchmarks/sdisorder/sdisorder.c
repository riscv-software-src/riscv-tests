#include "util.h"

#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>


#ifndef MLP
  #define MLP 32
#endif
#ifndef STEP
  #define STEP 64
#endif


void InitStream(uint *a, uint n) {
  for (uint i=0; i<n; i++)
    a[i] = (i+STEP) % n;
}

// TODO: Verify this does the random shuffling well
void ShuffleStream(uint *a, uint n) {
  if (n>1) {
    uint i;
    for (i = 0; i < n-1; i++) {
      uint j = (i + rand() / (RAND_MAX / (n-i)+1)) % n;
        uint t = a[j];
        a[j] = a[i];
        a[i] = t;
    }
  }
}


int Chase(uint *a, uint n, uint iterations) {
  uint loc[MLP];
  for (uint m=0; m<MLP; m++)
    loc[m] = (m * (n/MLP) + m) % n;

  for (uint k=0; k<iterations; k++) {
    for (uint i=0; i<n/MLP; i++) {
      for (uint m=0; m<MLP; m++) {
        loc[m] = a[loc[m]];
      }
    }
  }
  for (uint m=0; m<MLP; m++) {
    if (loc[m] < 0) {
      //printf("woah\n");
    }
  }
  return loc[n];
}


void RandGenBench(int n) {
  long total=0;
  for (int i=0; i<n; i++) {
    total += (rand() % 1) + 1;
  }
}


void thread_entry(int cid, int nc)
{
  while (cid != 0) {
    //    clogMem(1<<18, 64<<3,1<<7);
  }
}

int main(int argc, char* argv[]) {

  uint num_iters = 1;
  uint length = 1<<18;
  uint randomize = 0;

  uint stream[length];
  InitStream(stream, length);

  if (randomize) {
    ShuffleStream(stream, length);
  }

  randomize = Chase(stream, length, num_iters);

}
