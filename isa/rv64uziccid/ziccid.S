# See LICENSE for license details.

#*****************************************************************************
# ziccid.S
#-----------------------------------------------------------------------------
#
# Test Ziccid eventuality property.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UF
RVTEST_CODE_BEGIN

  la t0, insn
  li t1, 0x00100513   # li a0, 1
  li t2, 0x00000513   # li a0, 0

  sw t2, (t0)
  fence.i

  li a1, 100
loop:
  .balign 2
insn:
  .word 0

  addi a1, a1, -1
  bnez a1, 1f
  # modify instruction on 100th iteration
  sw t1, (t0)
1:
  # break out of loop if the modified instruction is executed
  beqz a0, loop

  TEST_CASE(2, x0, 0, nop)

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
