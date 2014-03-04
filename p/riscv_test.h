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

#define RVTEST_RV64S                                                    \
  .macro init;                                                          \
  .endm

#define RVTEST_RV32S                                                    \
  .macro init;                                                          \
  RVTEST_32_ENABLE;                                                     \
  .endm

#define RVTEST_32_ENABLE                                                \
  li a0, SR_S64;                                                        \
  csrc status, a0;                                                      \

#define RVTEST_FP_ENABLE                                                \
  li a0, SR_EF;                                                         \
  csrs status, a0;                                                      \
  csrr a1, status;                                                      \
  and a0, a0, a1;                                                       \
  bnez a0, 2f;                                                          \
  RVTEST_PASS;                                                          \
2:fssr x0;                                                              \

#define RVTEST_VEC_ENABLE                                               \
  li a0, SR_EA;                                                         \
  csrs status, a0;                                                      \
  csrr a1, status;                                                      \
  and a0, a0, a1;                                                       \
  bnez a0, 2f;                                                          \
  RVTEST_PASS;                                                          \
2:                                                                      \

#define RISCV_MULTICORE_DISABLE                                         \
  csrr a0, hartid;                                                      \
  1: bnez a0, 1b;                                                       \

#define EXTRA_INIT
#define EXTRA_INIT_TIMER

#define RVTEST_CODE_BEGIN                                               \
        .text;                                                          \
        .align  4;                                                      \
        .global _start;                                                 \
_start:                                                                 \
        RISCV_MULTICORE_DISABLE;                                        \
        init;                                                           \
        EXTRA_INIT;                                                     \
        EXTRA_INIT_TIMER;                                               \

//-----------------------------------------------------------------------
// End Macro
//-----------------------------------------------------------------------

#define RVTEST_CODE_END                                                 \

//-----------------------------------------------------------------------
// Pass/Fail Macro
//-----------------------------------------------------------------------

#define RVTEST_PASS                                                     \
        fence;                                                          \
        csrw tohost, 1;                                                 \
1:      b 1b;                                                           \

#define TESTNUM x28
#define RVTEST_FAIL                                                     \
        fence;                                                          \
        beqz TESTNUM, 1f;                                               \
        sll TESTNUM, TESTNUM, 1;                                        \
        or TESTNUM, TESTNUM, 1;                                         \
        csrw tohost, TESTNUM;                                           \
1:      b 1b;                                                           \

//-----------------------------------------------------------------------
// Data Section Macro
//-----------------------------------------------------------------------

#define EXTRA_DATA

#define RVTEST_DATA_BEGIN EXTRA_DATA .align 4; .global begin_signature; begin_signature:
#define RVTEST_DATA_END .align 4; .global end_signature; end_signature:

#endif
