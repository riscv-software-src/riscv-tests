#ifndef _ENV_PHYSICAL_SINGLE_CORE_TIMER_H
#define _ENV_PHYSICAL_SINGLE_CORE_TIMER_H

#include "pcr.h"

//-----------------------------------------------------------------------
// Begin Macro
//-----------------------------------------------------------------------

#define RVTEST_RV64U                                                    \

#define RVTEST_FP_ENABLE                                                \
  setpcr cr0, 2;                                                        \
  mfpcr a0, cr0;                                                        \
  and   a0, a0, 2;                                                      \
  beqz  a0, 1f;                                                         \
  mtfsr x0;                                                             \
1:

#define RVTEST_PASS_NOFP                                                \
  RVTEST_FP_ENABLE                                                      \
  bnez a0, 2f;                                                          \
  RVTEST_PASS                                                           \
2:                                                                      \

#define RVTEST_VEC_ENABLE                                               \
  mfpcr a0, cr0;                                                        \
  ori   a0, a0, 4;                                                      \
  mtpcr a0, cr0;                                                        \
  li    a0, 0xff;                                                       \
  mtpcr a0, cr18;                                                       \

#define RVTEST_CODE_BEGIN                                               \
        .text;                                                          \
        .align  4;                                                      \
        .global _start;                                                 \
_start:                                                                 \
        RVTEST_FP_ENABLE                                                \
        RVTEST_VEC_ENABLE                                               \
        mfpcr a0, cr10; 1: bnez a0, 1b;                                 \
        ENABLE_TIMER_INTERRUPT                                          \

//-----------------------------------------------------------------------
// End Macro
//-----------------------------------------------------------------------

#define RVTEST_CODE_END                                                 \
        XCPT_HANDLER                                                    \

//-----------------------------------------------------------------------
// Pass/Fail Macro
//-----------------------------------------------------------------------

#define RVTEST_PASS                                                     \
        fence;                                                          \
        li  x1, 1;                                                      \
        mtpcr x1, cr30;                                                 \
1:      b 1b;                                                           \

#define RVTEST_FAIL                                                     \
        fence;                                                          \
        beqz x28, 1f;                                                   \
        sll x28, x28, 1;                                                \
        or x28, x28, 1;                                                 \
        mtpcr x28, cr30;                                                \
1:      b 1b;                                                           \

//-----------------------------------------------------------------------
// Data Section Macro
//-----------------------------------------------------------------------

#define RVTEST_DATA_BEGIN                                               \
        .align 3; \
regspill:                          \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
evac:                              \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \
        .dword 0xdeadbeefcafebabe; \

#define RVTEST_DATA_END

//#define RVTEST_DATA_BEGIN .align 4; .global begin_signature; begin_signature:
//#define RVTEST_DATA_END .align 4; .global end_signature; end_signature:

//-----------------------------------------------------------------------
// Misc
//-----------------------------------------------------------------------

#define ENABLE_TIMER_INTERRUPT \
        mtpcr x0,ASM_CR(PCR_CLR_IPI);\
        mfpcr a0,ASM_CR(PCR_SR);     \
        li a1, SR_ET|SR_IM;          \
        or a0,a0,a1;                 \
        mtpcr a0,ASM_CR(PCR_SR);     \
        la a0,handler;               \
        mtpcr a0,ASM_CR(PCR_EVEC);   \
        mtpcr x0,ASM_CR(PCR_COUNT);  \
        addi a0,x0,60;               \
        mtpcr a0,ASM_CR(PCR_COMPARE);\

#define XCPT_HANDLER \
handler: \
        mtpcr a0,ASM_CR(PCR_K0);     \
        mtpcr a1,ASM_CR(PCR_K1);     \
        la a0,regspill;              \
        sd a2,0(a0);                 \
        sd a3,8(a0);                 \
        sd a4,16(a0);                \
        sd a5,24(a0);                \
        sd s0,32(a0);                \
        sd s1,40(a0);                \
        mfpcr s1,ASM_CR(PCR_VECBANK);\
        mfpcr s0,ASM_CR(PCR_VECCFG); \
        la a0,evac;                  \
        vxcptevac a0;                \
        mtpcr s1,ASM_CR(PCR_VECBANK);\
        srli a1,s0,12;               \
        andi a1,a1,0x3f;             \
        srli a2,s0,18;               \
        andi a2,a2,0x3f;             \
        vvcfg a1,a2;                 \
        li a2,0xfff;                 \
        and a1,s0,a2;                \
        vsetvl a1,a1;                \
        vxcpthold;                   \
        li a5,0;                     \
handler_loop: \
        ld a1,0(a0);                 \
        addi a0,a0,8;                \
        blt a1,x0,done;              \
        srli a2,a1,32;               \
        andi a2,a2,0x1;              \
        beq a2,x0,vcnt;              \
vcmd: \
        beq a5,x0,vcmd_skip;         \
        venqcmd a4,a3;               \
vcmd_skip: \
        li a5,1;                     \
        move a4,a1;                  \
        srli a3,a4,36;               \
        andi a3,a3,0x1;              \
vimm1: \
        srli a2,a4,35;               \
        andi a2,a2,0x1;              \
        beq a2,x0,vimm2;             \
        ld a1,0(a0);                 \
        addi a0,a0,8;                \
        venqimm1 a1,a3;              \
vimm2: \
        srli a2,a4,34;               \
        andi a2,a2,0x1;              \
        beq a2,x0,end;               \
        ld a1,0(a0);                 \
        addi a0,a0,8;                \
        venqimm2 a1,a3;              \
        j end;                       \
vcnt: \
        ld a2,0(a0);                 \
        srli a2,a2,31;               \
        andi a2,a2,0x2;              \
        or a3,a3,a2;                 \
        venqcnt a1,a3;               \
end: \
        j handler_loop;              \
done: \
        beq a5,x0,done_skip;         \
        venqcmd a4,a3;               \
done_skip: \
        la a0,regspill;              \
        ld a2,0(a0);                 \
        ld a3,8(a0);                 \
        ld a4,16(a0);                \
        ld a5,24(a0);                \
        ld s0,32(a0);                \
        ld s1,40(a0);                \
        mfpcr a0,ASM_CR(PCR_COUNT);  \
        addi a0,a0,60;               \
        mtpcr a0,ASM_CR(PCR_COMPARE);\
        mfpcr a0,ASM_CR(PCR_K0);     \
        mfpcr a1,ASM_CR(PCR_K1);     \
        eret;                        \

#endif
