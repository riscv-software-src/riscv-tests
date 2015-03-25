# See LICENSE for license details.

#*****************************************************************************
# ma_fetch.S
#-----------------------------------------------------------------------------
#
# Test misaligned fetch trap.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64S
RVTEST_CODE_BEGIN

#ifdef __MACHINE_MODE
  #define sscratch mscratch
  #define sstatus mstatus
  #define scause mcause
  #define sepc mepc
  #define stvec_handler mtvec_handler
#endif

#ifndef __rvc
  li TESTNUM, 2
  li t1, 0
  la t0, 1f
  jalr t1, t0, 2
1:
  j fail
#endif

  // This test should pass, since JALR ignores the target LSB
  li TESTNUM, 3
  la t0, 1f
  jalr t1, t0, 1
1:
  j 1f
  j fail
1:

#ifndef __rvc
  li TESTNUM, 4
  li t1, 0
  la t0, 3f
  jr t0, 3
3:
  j fail
#endif

  j pass

  TEST_PASSFAIL

stvec_handler:
  # tests 2 and 4 should trap
  li a0, 2
  beq TESTNUM, a0, 1f
  li a0, 4
  beq TESTNUM, a0, 1f
  j fail
1:

  # verify that return address was not written
  bnez t1, fail

  # verify trap cause
  li a1, CAUSE_MISALIGNED_FETCH
  csrr a0, scause
  bne a0, a1, fail

  # verify that epc == &jalr (== t0 - 4)
  csrr a1, sepc
  addi t0, t0, -4
  bne t0, a1, fail

  addi a1, a1, 8
  csrw sepc, a1
  sret

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
