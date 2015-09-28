// See LICENSE for license details.

#ifndef _ENV_PHYSICAL_SINGLE_CORE_H
#define _ENV_PHYSICAL_SINGLE_CORE_H

#include "../encoding.h"

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

#define RVTEST_RV32U                                                    \
  .macro init;                                                          \
  .endm

#define RVTEST_RV32UF                                                   \
  .macro init;                                                          \
  RVTEST_FP_ENABLE;                                                     \
  .endm

#define RVTEST_RV64M                                                    \
  .macro init;                                                          \
  RVTEST_ENABLE_MACHINE;                                                \
  .endm

#define RVTEST_RV64S                                                    \
  .macro init;                                                          \
  RVTEST_ENABLE_SUPERVISOR;                                             \
  .endm

#define RVTEST_RV64SV                                                   \
  .macro init;                                                          \
  RVTEST_ENABLE_SUPERVISOR;                                             \
  .endm

#define RVTEST_RV32M                                                    \
  .macro init;                                                          \
  RVTEST_ENABLE_MACHINE;                                                \
  .endm

#define RVTEST_RV32S                                                    \
  .macro init;                                                          \
  RVTEST_ENABLE_SUPERVISOR;                                             \
  .endm

#ifdef __riscv64
# define CHECK_XLEN csrr a0, mcpuid; bltz a0, 1f; RVTEST_PASS; 1:
#else
# define CHECK_XLEN csrr a0, mcpuid; bgez a0, 1f; RVTEST_PASS; 1:
#endif

#define RVTEST_ENABLE_SUPERVISOR                                        \
  li a0, MSTATUS_PRV1 & (MSTATUS_PRV1 >> 1);                            \
  csrs mstatus, a0;                                                     \

#define RVTEST_ENABLE_MACHINE                                           \
  li a0, MSTATUS_PRV1;                                                  \
  csrs mstatus, a0;                                                     \

#define RVTEST_FP_ENABLE                                                \
  li a0, MSTATUS_FS & (MSTATUS_FS >> 1);                                \
  csrs mstatus, a0;                                                     \
  csrwi fcsr, 0

#define RISCV_MULTICORE_DISABLE                                         \
  csrr a0, mhartid;                                                     \
  1: bnez a0, 1b

#define EXTRA_TVEC_USER
#define EXTRA_TVEC_SUPERVISOR
#define EXTRA_TVEC_HYPERVISOR
#define EXTRA_TVEC_MACHINE
#define EXTRA_INIT
#define EXTRA_INIT_TIMER

#define RVTEST_CODE_BEGIN                                               \
        .text;                                                          \
        .align  6;                                                      \
        .weak stvec_handler;                                            \
        .weak mtvec_handler;                                            \
tvec_user:                                                              \
        EXTRA_TVEC_USER;                                                \
        /* test whether the test came from pass/fail */                 \
        la t5, ecall;                                                   \
        csrr t6, mepc;                                                  \
        beq t5, t6, write_tohost;                                       \
        /* test whether the stvec_handler target exists */              \
        la t5, stvec_handler;                                           \
        bnez t5, mrts_routine;                                          \
        /* test whether the mtvec_handler target exists */              \
        la t5, mtvec_handler;                                           \
        bnez t5, mtvec_handler;                                         \
        /* some other exception occurred */                             \
        j other_exception;                                              \
        .align  6;                                                      \
tvec_supervisor:                                                        \
        EXTRA_TVEC_SUPERVISOR;                                          \
        csrr t5, mcause;                                                \
        bgez t5, tvec_user;                                             \
  mrts_routine:                                                         \
        mrts;                                                           \
        .align  6;                                                      \
tvec_hypervisor:                                                        \
        EXTRA_TVEC_HYPERVISOR;                                          \
        /* renting some space out here */                               \
  other_exception:                                                      \
  1:    ori TESTNUM, TESTNUM, 1337; /* some other exception occurred */ \
  write_tohost:                                                         \
        csrw mtohost, TESTNUM;                                          \
        j write_tohost;                                                 \
        .align  6;                                                      \
tvec_machine:                                                           \
        EXTRA_TVEC_MACHINE;                                             \
        la t5, ecall;                                                   \
        csrr t6, mepc;                                                  \
        beq t5, t6, write_tohost;                                       \
        la t5, mtvec_handler;                                           \
        bnez t5, mtvec_handler;                                         \
        j other_exception;                                              \
        .align  6;                                                      \
        .globl _start;                                                  \
_start:                                                                 \
        RISCV_MULTICORE_DISABLE;                                        \
        CHECK_XLEN;                                                     \
        li TESTNUM, 0;                                                  \
        la t0, stvec_handler;                                           \
        beqz t0, 1f;                                                    \
        csrw stvec, t0;                                                 \
1:      li t0, MSTATUS_PRV1 | MSTATUS_PRV2 | MSTATUS_IE1 | MSTATUS_IE2; \
        csrc mstatus, t0;                                               \
        init;                                                           \
        EXTRA_INIT;                                                     \
        EXTRA_INIT_TIMER;                                               \
        la t0, 1f;                                                      \
        csrw mepc, t0;                                                  \
        csrr a0, mhartid;                                               \
        eret;                                                           \
1:

//-----------------------------------------------------------------------
// End Macro
//-----------------------------------------------------------------------

#define RVTEST_CODE_END                                                 \
ecall:  ecall;                                                          \
        j ecall

//-----------------------------------------------------------------------
// Pass/Fail Macro
//-----------------------------------------------------------------------

#define RVTEST_PASS                                                     \
        fence;                                                          \
        li TESTNUM, 1;                                                  \
        j ecall

#define TESTNUM x28
#define RVTEST_FAIL                                                     \
        fence;                                                          \
1:      beqz TESTNUM, 1b;                                               \
        sll TESTNUM, TESTNUM, 1;                                        \
        or TESTNUM, TESTNUM, 1;                                         \
        j ecall

//-----------------------------------------------------------------------
// Data Section Macro
//-----------------------------------------------------------------------

#define EXTRA_DATA

#define RVTEST_DATA_BEGIN EXTRA_DATA .align 4; .global begin_signature; begin_signature:
#define RVTEST_DATA_END .align 4; .global end_signature; end_signature:

#endif
