#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>


#ifndef MLP
  #define MLP 32
#endif
#ifndef STEP
  #define STEP 64
#endif


void InitStream(int *a, int n) {
  for (int i=0; i<n; i++)
    a[i] = (i+STEP) % n;
}

// TODO: Verify this does the random shuffling well
void ShuffleStream(int *a, int n) {
  if (n>1) {
    int i;
    for (i = 0; i < n-1; i++) {
        int j = i + rand() / (RAND_MAX / (n-i)+1);
        int t = a[j];
        a[j] = a[i];
        a[i] = t;
    }
  }
}


void Chase(int *a, int n, int iterations) {
  int loc[MLP];
  for (int m=0; m<MLP; m++)
    loc[m] = m * (n/MLP) + m;

  for (int k=0; k<iterations; k++) {
    for (int i=0; i<n/MLP; i++) {
      for (int m=0; m<MLP; m++) {
        loc[m] = a[loc[m]];
      }
    }
  }
  for (int m=0; m<MLP; m++) {
    if (loc[m] < 0) {
      //printf("woah\n");
    }
  }
}


void RandGenBench(int n) {
  long total=0;
  for (int i=0; i<n; i++) {
    total += (rand() % 1) + 1;
  }
}



int main(int argc, char* argv[]) {
 
  int num_iters = 2;
  int length = 1<<6;
  int randomize = 1;

  int stream[length];
  InitStream(stream, length);
  
  if (randomize) {
    ShuffleStream(stream, length);
  }
  Chase(stream, length, num_iters);

}
