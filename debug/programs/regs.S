#ifdef __riscv64
# define LREG ld
# define SREG sd
# define REGBYTES 8
#else
# define LREG lw
# define SREG sw
# define REGBYTES 4
#endif

#include "../../env/encoding.h"

        .global main
main:
        j       main

write_regs:
        SREG    x1, 0(a0)
        SREG    x2, 8(a0)
        SREG    x3, 16(a0)
        SREG    x4, 24(a0)
        SREG    x5, 32(a0)
        SREG    x6, 40(a0)
        SREG    x7, 48(a0)
        SREG    x8, 56(a0)
        SREG    x9, 64(a0)
        SREG    x11, 72(a0)
        SREG    x12, 80(a0)
        SREG    x13, 88(a0)
        SREG    x14, 96(a0)
        SREG    x15, 104(a0)
        SREG    x16, 112(a0)
        SREG    x17, 120(a0)
        SREG    x18, 128(a0)
        SREG    x19, 136(a0)
        SREG    x20, 144(a0)
        SREG    x21, 152(a0)
        SREG    x22, 160(a0)
        SREG    x23, 168(a0)
        SREG    x24, 176(a0)
        SREG    x25, 184(a0)
        SREG    x26, 192(a0)
        SREG    x27, 200(a0)
        SREG    x28, 208(a0)
        SREG    x29, 216(a0)
        SREG    x30, 224(a0)
        SREG    x31, 232(a0)

        csrr    x1, CSR_MSCRATCH

all_done:
        j       all_done

        .balign  16
data:
        .fill   64, 8, 0
