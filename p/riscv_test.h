// See LICENSE for license details.

#ifndef _ENV_PHYSICAL_SINGLE_CORE_H
#define _ENV_PHYSICAL_SINGLE_CORE_H

#include "../encoding.h"
#include "../hwacha_xcpt.h"

//-----------------------------------------------------------------------
// Begin Macro
//-----------------------------------------------------------------------

#define RVTEST_RV64U                                                    \
  .macro init;                                                          \
  .endm

#define RVTEST_RV64UF                                                   \
  .macro init;                                                          \
  RVTEST_FP_ENABLE;                                                     \
  .endm

#define RVTEST_RV64UV                                                   \
  .macro init;                                                          \
  RVTEST_FP_ENABLE;                                                     \
  RVTEST_VEC_ENABLE;                                                    \
  .endm

#define RVTEST_RV32U                                                    \
  .macro init;                                                          \
  RVTEST_32_ENABLE;                                                     \
  .endm

#define RVTEST_RV32UF                                                   \
  .macro init;                                                          \
  RVTEST_32_ENABLE;                                                     \
  RVTEST_FP_ENABLE;                                                     \
  .endm

#define RVTEST_RV32UV                                                   \
  .macro init;                                                          \
  RVTEST_32_ENABLE;                                                     \
  RVTEST_FP_ENABLE;                                                     \
  RVTEST_VEC_ENABLE;                                                    \
  .endm

#define RVTEST_RV64M                                                    \
  .macro init;                                                          \
  RVTEST_ENABLE_MACHINE;                                                \
  .endm

#define RVTEST_RV64S                                                    \
  .macro init;                                                          \
  RVTEST_ENABLE_SUPERVISOR;                                             \
  .endm

#define RVTEST_RV32M                                                    \
  .macro init;                                                          \
  RVTEST_ENABLE_MACHINE;                                                \
  RVTEST_32_ENABLE;                                                     \
  .endm

#define RVTEST_RV32S                                                    \
  .macro init;                                                          \
  RVTEST_ENABLE_SUPERVISOR;                                             \
  RVTEST_32_ENABLE;                                                     \
  .endm

#define RVTEST_32_ENABLE                                                \
  li a0, MSTATUS64_UA >> 31;                                            \
  slli a0, a0, 31;                                                      \
  csrc mstatus, a0;                                                     \
  li a0, MSTATUS64_SA >> 31;                                            \
  slli a0, a0, 31;                                                      \
  csrc mstatus, a0;                                                     \

#define RVTEST_ENABLE_SUPERVISOR                                        \
  li a0, MSTATUS_PRV1 & (MSTATUS_PRV1 >> 1);                            \
  csrs mstatus, a0;                                                     \

#define RVTEST_ENABLE_MACHINE                                           \
  li a0, MSTATUS_PRV1;                                                  \
  csrs mstatus, a0;                                                     \

#define RVTEST_FP_ENABLE                                                \
  li a0, SSTATUS_FS & (SSTATUS_FS >> 1);                                \
  csrs sstatus, a0;                                                     \
  csrr a1, sstatus;                                                     \
  and a0, a0, a1;                                                       \
  bnez a0, 2f;                                                          \
  RVTEST_PASS;                                                          \
2:fssr x0;                                                              \

#define RVTEST_VEC_ENABLE                                               \
  li a0, SSSTATUS_XS & (SSTATUS_XS >> 1);                               \
  csrs status, a0;                                                      \
  csrr a1, status;                                                      \
  and a0, a0, a1;                                                       \
  bnez a0, 2f;                                                          \
  RVTEST_PASS;                                                          \
2:                                                                      \

#define RISCV_MULTICORE_DISABLE                                         \
  csrr a0, hartid;                                                      \
  1: bnez a0, 1b

#define EXTRA_INIT
#define EXTRA_INIT_TIMER

#define RVTEST_CODE_BEGIN                                               \
        .text;                                                          \
        .align  6;                                                      \
tvec_user:                                                              \
        la t5, hcall;                                                   \
        csrr t6, mepc;                                                  \
        beq t5, t6, write_tohost;                                       \
        li t5, 0xbadbad0;                                               \
        csrr t6, stvec;                                                 \
        bne t5, t6, 2f;                                                 \
        ori TESTNUM, TESTNUM, 1337; /* some other exception occurred */ \
        write_tohost: csrw tohost, TESTNUM;                             \
        j write_tohost;                                                 \
        2: mrts;                                                        \
        .align  6;                                                      \
tvec_supervisor:                                                        \
        csrr t5, mcause;                                                \
        bgez t5, tvec_user;                                             \
        mrts;                                                           \
        .align  6;                                                      \
tvec_hypervisor:                                                        \
        RVTEST_FAIL; /* no hypervisor */                                \
        .align  6;                                                      \
tvec_machine:                                                           \
        .weak mtvec;                                                    \
        la t5, hcall;                                                   \
        csrr t6, mepc;                                                  \
        beq t5, t6, write_tohost;                                       \
        la t5, mtvec;                                                   \
1:      beqz t5, 1b;                                                    \
        j mtvec;                                                        \
        .align  6;                                                      \
        .globl _start;                                                  \
_start:                                                                 \
        RISCV_MULTICORE_DISABLE;                                        \
        li t0, 0xbadbad0; csrw stvec, t0;                               \
        li t0, MSTATUS_PRV1; csrc mstatus, t0;                          \
        init;                                                           \
        EXTRA_INIT;                                                     \
        EXTRA_INIT_TIMER;                                               \
        la t0, 1f;                                                      \
        csrw mepc, t0;                                                  \
        csrr a0, hartid;                                                \
        mret;                                                           \
1:

//-----------------------------------------------------------------------
// End Macro
//-----------------------------------------------------------------------

#define RVTEST_CODE_END                                                 \
hcall:  hcall;                                                          \
        j hcall

//-----------------------------------------------------------------------
// Pass/Fail Macro
//-----------------------------------------------------------------------

#define RVTEST_PASS                                                     \
        fence;                                                          \
        li TESTNUM, 1;                                                  \
        j hcall

#define TESTNUM x28
#define RVTEST_FAIL                                                     \
        fence;                                                          \
1:      beqz TESTNUM, 1b;                                               \
        sll TESTNUM, TESTNUM, 1;                                        \
        or TESTNUM, TESTNUM, 1;                                         \
        j hcall

//-----------------------------------------------------------------------
// Data Section Macro
//-----------------------------------------------------------------------

#define EXTRA_DATA

#define RVTEST_DATA_BEGIN EXTRA_DATA .align 4; .global begin_signature; begin_signature:
#define RVTEST_DATA_END .align 4; .global end_signature; end_signature:

#endif
