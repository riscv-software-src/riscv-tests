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
        srl a0, a0, XS_SHIFT;                                           \
        andi a0, a0, 3;                                                 \
        beqz a0, _skip_vector_restore;                                  \
        VECTOR_RESTORE;                                                 \
_skip_vector_restore:                                                   \
        csrr a0, mtime;                                                 \
        addi a0, a0, TIMER_INTERVAL;                                    \
        csrw mtimecmp, a0;                                              \
        csrr a0, mscratch;                                              \
        eret;                                                           \

#ifdef __riscv64

#define VECTOR_RESTORE                                                  \
_vector_restore: \
        la a0,regspill;                                                 \
        sd a1,0(a0);                                                    \
        sd a2,8(a0);                                                    \
        sd a3,16(a0);                                                   \
        sd a4,24(a0);                                                   \
        sd a5,32(a0);                                                   \
        sd a6,40(a0);                                                   \
        sd a7,48(a0);                                                   \
        vgetcfg a6;                                                     \
        vgetvl a7;                                                      \
        la a0,evac;                                                     \
        vxcptevac a0;                                                   \
        vsetcfg a6;                                                     \
        vsetvl a7,a7;                                                   \
        vxcpthold a0;                                                   \
        li a5,0;                                                        \
_handler_loop:                                                          \
        ld a1,0(a0);                                                    \
        addi a0,a0,8;                                                   \
        blt a1,x0,_done;                                                \
        srli a2,a1,32;                                                  \
        andi a2,a2,0x1;                                                 \
        beq a2,x0,_vcnt;                                                \
_vcmd:                                                                  \
        beq a5,x0,_vcmd_skip;                                           \
        venqcmd a4,a3;                                                  \
_vcmd_skip:                                                             \
        li a5,1;                                                        \
        move a4,a1;                                                     \
        srli a3,a4,36;                                                  \
        andi a3,a3,0x1;                                                 \
_vimm1:                                                                 \
        srli a2,a4,35;                                                  \
        andi a2,a2,0x1;                                                 \
        beq a2,x0,_vimm2;                                               \
        ld a1,0(a0);                                                    \
        addi a0,a0,8;                                                   \
        venqimm1 a1,a3;                                                 \
_vimm2:                                                                 \
        srli a2,a4,34;                                                  \
        andi a2,a2,0x1;                                                 \
        beq a2,x0,_end;                                                 \
        ld a1,0(a0);                                                    \
        addi a0,a0,8;                                                   \
        venqimm2 a1,a3;                                                 \
        j _end;                                                         \
_vcnt:                                                                  \
        ld a2,0(a0);                                                    \
        srli a2,a2,31;                                                  \
        andi a2,a2,0x2;                                                 \
        or a3,a3,a2;                                                    \
        venqcnt a1,a3;                                                  \
_end:                                                                   \
        j _handler_loop;                                                \
_done:                                                                  \
        beq a5,x0,_done_skip;                                           \
        venqcmd a4,a3;                                                  \
_done_skip:                                                             \
        la a0,regspill;                                                 \
        ld a1,0(a0);                                                    \
        ld a2,8(a0);                                                    \
        ld a3,16(a0);                                                   \
        ld a4,24(a0);                                                   \
        ld a5,32(a0);                                                   \
        ld a6,40(a0);                                                   \
        ld a7,48(a0);                                                   \

#else

#define VECTOR_RESTORE

#endif

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
