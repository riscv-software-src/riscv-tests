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

  .option norvc

  #
  # Test the eventuality property
  #

  la t0, insn
  li t1, 0x00100513   # li a0, 1
  li t5, 0x00000513   # li a0, 0
  li t3, 0x00100593   # li a1, 1
  li t4, 0x00000593   # li a1, 0

  sw t5, (t0)
  fence.i

  li a1, 100
insn:
  .word 0

  addi a1, a1, -1
  bnez a1, 1f
  # modify instruction on 100th iteration
  sw t1, (t0)
1:
  # break out of loop if the modified instruction is executed
  beqz a0, insn

  TEST_CASE(2, x0, 0, nop)


  #
  # Test the ordering property
  #
  la t0, loop2
  li a2, 16
  j loop2

  .balign 4096
loop2:
  li a0, 0
  .balign 64
  li a1, 0

  sw t3, 64(t0)
  fence
  sw t1, 0(t0)

  bnez a1, next_loop2

  # detect illegal outcome a0=1, a1=0
  TEST_CASE(3, a0, 0, nop)

  # try to evict force an I$ eviction
  addi a3, a2, -1; bltz a3, loop2; j 1f; .balign 8192; 1:
  addi a3, a3, -1; bltz a3, loop2; j 1f; .balign 8192; 1:
  addi a3, a3, -1; bltz a3, loop2; j 1f; .balign 8192; 1:
  addi a3, a3, -1; bltz a3, loop2; j 1f; .balign 8192; 1:
  addi a3, a3, -1; bltz a3, loop2; j 1f; .balign 8192; 1:
  addi a3, a3, -1; bltz a3, loop2; j 1f; .balign 8192; 1:
  addi a3, a3, -1; bltz a3, loop2; j 1f; .balign 8192; 1:
  addi a3, a3, -1; bltz a3, loop2; j 1f; .balign 8192; 1:
  addi a3, a3, -1; bltz a3, loop2; j 1f; .balign 8192; 1:
  addi a3, a3, -1; bltz a3, loop2; j 1f; .balign 8192; 1:
  addi a3, a3, -1; bltz a3, loop2; j 1f; .balign 8192; 1:
  addi a3, a3, -1; bltz a3, loop2; j 1f; .balign 8192; 1:
  addi a3, a3, -1; bltz a3, loop2; j 1f; .balign 8192; 1:
  addi a3, a3, -1; bltz a3, loop2; j 1f; .balign 8192; 1:
  addi a3, a3, -1; bltz a3, loop2; j 1f; .balign 8192; 1:
  addi a3, a3, -1; bltz a3, loop2; j 1f; .balign 8192; 1:

  j loop2

next_loop2:
  sw t4, 64(t0)
  sw t5, 0(t0)
  fence.i
  addi a2, a2, -1
  bgez a2, loop2

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
