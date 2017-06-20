#include "encoding.h"

        .global main

        // Load constants into all registers so we can test no register are
        // clobbered after attaching.
main:
        csrr    x1, CSR_MISA
        slli    x2, x1, 1
        slli    x3, x2, 1
        slli    x4, x3, 1
        slli    x5, x4, 1
        slli    x6, x5, 1
        slli    x7, x6, 1
        slli    x8, x7, 1
        slli    x9, x8, 1
        slli    x10, x9, 1
        slli    x11, x10, 1
        slli    x12, x11, 1
        slli    x13, x12, 1
        slli    x14, x13, 1
        slli    x15, x14, 1
        slli    x16, x15, 1
        slli    x17, x16, 1
        slli    x18, x17, 1
        slli    x19, x18, 1
        slli    x20, x19, 1
        slli    x21, x20, 1
        slli    x22, x21, 1
        slli    x23, x22, 1
        slli    x24, x23, 1
        slli    x25, x24, 1
        slli    x26, x25, 1
        slli    x27, x26, 1
        slli    x28, x27, 1
        slli    x29, x28, 1
        slli    x30, x29, 1
        slli    x31, x30, 1
1:
        j       1b
