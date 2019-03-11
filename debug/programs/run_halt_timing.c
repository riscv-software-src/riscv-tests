#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>

#include "init.h"

int main()
{
    int counter = 0;
    volatile uint64_t mtime_value;

    while (1) {
        counter = counter + 1;
        mtime_value = MTIME;
    }
}
