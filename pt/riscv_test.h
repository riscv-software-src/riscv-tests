// See LICENSE for license details.

#ifndef _ENV_PHYSICAL_SINGLE_CORE_TIMER_H
#define _ENV_PHYSICAL_SINGLE_CORE_TIMER_H

#include "../p/riscv_test.h"

#define TIMER_INTERVAL 2

#undef EXTRA_TVEC_USER
#define EXTRA_TVEC_USER                                                 \
        csrw mscratch, a0;                                              \
        csrr a0, mcause;                                                \
        bltz a0, _interrupt_handler;                                    \
_skip:                                                                  \

#undef EXTRA_INIT_TIMER
#define EXTRA_INIT_TIMER                                                \
        ENABLE_TIMER_INTERRUPT;                                         \
        j _jump_around_interrupt_handler;                               \
        INTERRUPT_HANDLER;                                              \
_jump_around_interrupt_handler:                                         \

#define ENABLE_TIMER_INTERRUPT                                          \
        li a0, MIP_MTIP;                                                \
        csrs mie, a0;                                                   \
        csrr a0, mtime;                                                 \
        addi a0, a0, TIMER_INTERVAL;                                    \
        csrw mtimecmp, a0;                                              \

#if SSTATUS_XS != 0xc000
# error
#endif
#define XS_SHIFT 14

#define INTERRUPT_HANDLER                                               \
_interrupt_handler:                                                     \
        slli a0, a0, 1;                                                 \
        srli a0, a0, 1;                                                 \
        add a0, a0, -IRQ_TIMER;                                         \
        bnez a0, _skip;                                                 \
        csrr a0, mtime;                                                 \
        addi a0, a0, TIMER_INTERVAL;                                    \
        csrw mtimecmp, a0;                                              \
        csrr a0, mscratch;                                              \
        eret;                                                           \

//-----------------------------------------------------------------------
// Data Section Macro
//-----------------------------------------------------------------------

#undef EXTRA_DATA
#define EXTRA_DATA                                                      \
        .align 3;                                                       \
regspill:                                                               \
        .dword 0xdeadbeefcafebabe;                                      \
        .dword 0xdeadbeefcafebabe;                                      \
        .dword 0xdeadbeefcafebabe;                                      \
        .dword 0xdeadbeefcafebabe;                                      \
        .dword 0xdeadbeefcafebabe;                                      \
        .dword 0xdeadbeefcafebabe;                                      \
        .dword 0xdeadbeefcafebabe;                                      \
        .dword 0xdeadbeefcafebabe;                                      \
        .dword 0xdeadbeefcafebabe;                                      \
        .dword 0xdeadbeefcafebabe;                                      \
        .dword 0xdeadbeefcafebabe;                                      \
        .dword 0xdeadbeefcafebabe;                                      \
        .dword 0xdeadbeefcafebabe;                                      \
        .dword 0xdeadbeefcafebabe;                                      \
        .dword 0xdeadbeefcafebabe;                                      \
        .dword 0xdeadbeefcafebabe;                                      \
        .dword 0xdeadbeefcafebabe;                                      \
        .dword 0xdeadbeefcafebabe;                                      \
        .dword 0xdeadbeefcafebabe;                                      \
        .dword 0xdeadbeefcafebabe;                                      \
        .dword 0xdeadbeefcafebabe;                                      \
        .dword 0xdeadbeefcafebabe;                                      \
        .dword 0xdeadbeefcafebabe;                                      \
        .dword 0xdeadbeefcafebabe;                                      \
evac:                                                                   \
        .skip 32768;                                                    \

#endif
