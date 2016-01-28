// See LICENSE for license details.

#include "sort.h"

int
n_squared_sort (float * value, int * index, int len)
{
  int i, j;

  for (i = 0; i < len-1; i++)
  {
    for (j = 0; j < len-1; j++)
    {
      if (value[j] > value[j+1])
      {
	double val_tmp;
	int idx_tmp;

	val_tmp = value[j];
	value[j] = value[j+1];
	value[j+1] = val_tmp;

	idx_tmp = index[j];
	index[j] = index[j+1];
	index[j+1] = idx_tmp;
      }
    }
  }

  return 0;
}


extern void* fake_malloc_radix(size_t size);

int
radix_sort_tuples (int * value, int * index, int len, int radix_bits)
{
  int i, j;
  int max, min;
  int numBuckets = 1 << radix_bits;
  int bitMask = numBuckets - 1;
  int denShift;

  int * buckets = fake_malloc_radix ((numBuckets + 2) * sizeof(int));
  int * copy1_value = fake_malloc_radix (sizeof(int) * len);
  int * copy1_index = fake_malloc_radix (sizeof(int) * len);
  int * copy2_value = fake_malloc_radix (sizeof(int) * len);
  int * copy2_index = fake_malloc_radix (sizeof(int) * len);
  int * tmp_value;
  int * tmp_index;

  max = value[0];
  min = value[0];
  for (i = 0; i < len; i++) {
    copy1_value[i] = value[i];
    copy1_index[i] = index[i];
    if (max < value[i]) {
      max = value[i];
    }
    if (min > value[i]) {
      min = value[i];
    }
  }
  min = -min;
  max += min;

  for (i = 0; i < len; i++)
  {
    copy1_value[i] += min;
  }

  denShift = 0;
  for (i = 0; max != 0; max = max / numBuckets, i++)
  {
    for (j = 0; j < numBuckets + 2; j++)
    {
      buckets[j] = 0;
    }

    buckets += 2;

    for (j = 0; j < len; j++)
    {
      int myBucket = (int) (((int) copy1_value[j]) >> denShift) & bitMask;
      buckets[myBucket]++;
    }

    for (j = 1; j < numBuckets; j++)
    {
      buckets[j] += buckets[j-1];
    }

    buckets--;

    for (j = 0; j < len; j++)
    {
      int myBucket = (int) (((int) copy1_value[j]) >> denShift) & bitMask;
      int index = buckets[myBucket]++;
      copy2_value[index] = copy1_value[j];
      copy2_index[index] = copy1_index[j];
    }

    buckets--;
    denShift += radix_bits;

    tmp_value = copy1_value;
    copy1_value = copy2_value;
    copy2_value = tmp_value;

    tmp_index = copy1_index;
    copy1_index = copy2_index;
    copy2_index = tmp_index;
  }

  max = copy1_value[0];
  for (i = 0; i < len; i++) {
    if (max < copy1_value[i]) {
      max = copy1_value[i];
    }
  }

  for (i = 0; i < len; i++)
  {
    copy1_value[i] -= min;
  }

  for (i = 0; i < len; i++)
  {
    value[i] = copy1_value[i];
    index[i] = copy1_index[i];
  }

  return 0;
}

int
insertion_sort (float * value, int * index, int len)
{
  int i;

  for (i = 1; i < len; i++)
  {
    double current;
    int cur_index;
    int empty;

    current = value[i];
    cur_index = index[i];
    empty = i;

    while (empty > 0 && current < value[empty-1])
    {
      value[empty] = value[empty-1];
      index[empty] = index[empty-1];
      empty--;
    }

    value[empty] = current;
    index[empty] = cur_index;
  }

  return 0;
}


int
partition (float * array, int * index, int low, int high)
{
  int left, right, mid;
  int pivot;
  float cur;
  int idx;

  mid = (low + high) / 2;
  left = low;
  right = high;

  /* choose pivot as median of 3: low, high, and mid */
  if ((array[low] - array[mid]) * (array[high] - array[low]) >= 0)
    pivot = low;
  else if ((array[mid] - array[low]) * (array[high] - array[mid]) >= 0)
    pivot = mid;
  else
    pivot = high; 

  /* store value,index at the pivot */
  cur = array[pivot];
  idx = index[pivot];

  /* swap pivot with the first entry in the list */
  array[pivot] = array[low];
  array[low] = cur;
  
  index[pivot] = array[pivot];
  index[low] = idx;

  /* the quicksort itself */
  while (left < right)
  {
    while (array[left] <= cur && left < high)
      left++;
    while (array[right] > cur)
      right--;
    if (left < right)
    {
      float tmp_val;
      int tmp_idx;

      tmp_val = array[right];
      array[right] = array[left];
      array[left] = tmp_val;

      tmp_idx =  index[right];
      index[right] = index[left];
      index[left] = tmp_idx;
    }
  }

  /* pivot was in low, but now moves into position at right */
  array[low] = array[right];
  array[right] = cur;

  index[low] = index[right];
  index[right] = idx;

  return right;
}


int
quicksort_inner (float * array, int * index, int low, int high)
{
  int pivot;
  int length = high - low + 1;

  if (high > low)
  {
    if (length > MAX_THRESH) {
      pivot = partition (array, index, low, high);
      quicksort_inner (array, index, low, pivot-1);
      quicksort_inner (array, index, pivot+1, high);
    }
  }

  return 0;
}

int quicksort (float * array, int * index, int len)
{
  quicksort_inner (array, index, 0, len-1);
  insertion_sort (array, index, len);

  return 0;
}
