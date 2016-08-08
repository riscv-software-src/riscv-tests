# See LICENSE for license details.

#*****************************************************************************
# ma_addr.S
#-----------------------------------------------------------------------------
#
# Test misaligned ld/st trap.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

  .option norvc

  la s0, data

  # indicate it's a load test
  li s1, CAUSE_MISALIGNED_LOAD

#define MISALIGNED_LDST_TEST(testnum, insn, base, offset) \
  li TESTNUM, testnum; \
  insn x0, offset(base); \
  j fail \

  MISALIGNED_LDST_TEST(2,  lh,  s0, 1)
  MISALIGNED_LDST_TEST(3,  lhu, s0, 1)
  MISALIGNED_LDST_TEST(4,  lw,  s0, 1)
  MISALIGNED_LDST_TEST(5,  lw,  s0, 2)
  MISALIGNED_LDST_TEST(6,  lw,  s0, 3)

#ifdef __riscv64
  MISALIGNED_LDST_TEST(7,  lwu, s0, 1)
  MISALIGNED_LDST_TEST(8,  lwu, s0, 2)
  MISALIGNED_LDST_TEST(9,  lwu, s0, 3)

  MISALIGNED_LDST_TEST(10, ld, s0, 1)
  MISALIGNED_LDST_TEST(11, ld, s0, 2)
  MISALIGNED_LDST_TEST(12, ld, s0, 3)
  MISALIGNED_LDST_TEST(13, ld, s0, 4)
  MISALIGNED_LDST_TEST(14, ld, s0, 5)
  MISALIGNED_LDST_TEST(15, ld, s0, 6)
  MISALIGNED_LDST_TEST(16, ld, s0, 7)
#endif

  # indicate it's a store test
  li s1, CAUSE_MISALIGNED_STORE

  MISALIGNED_LDST_TEST(22,  sh,  s0, 1)
  MISALIGNED_LDST_TEST(23,  sw,  s0, 1)
  MISALIGNED_LDST_TEST(24,  sw,  s0, 2)
  MISALIGNED_LDST_TEST(25,  sw,  s0, 3)

#ifdef __riscv64
  MISALIGNED_LDST_TEST(26, sd, s0, 1)
  MISALIGNED_LDST_TEST(27, sd, s0, 2)
  MISALIGNED_LDST_TEST(28, sd, s0, 3)
  MISALIGNED_LDST_TEST(29, sd, s0, 4)
  MISALIGNED_LDST_TEST(30, sd, s0, 5)
  MISALIGNED_LDST_TEST(31, sd, s0, 6)
  MISALIGNED_LDST_TEST(32, sd, s0, 7)
#endif

  TEST_PASSFAIL

  .align 3
mtvec_handler:
  csrr t0, mcause
  bne t0, s1, fail

  csrr t0, mepc
  addi t0, t0, 8
  csrw mepc, t0
  mret

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

data:
  .dword 0

  TEST_DATA

RVTEST_DATA_END
