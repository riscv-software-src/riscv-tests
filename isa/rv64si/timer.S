#*****************************************************************************
# ipi.S
#-----------------------------------------------------------------------------
#
# Test interprocessor interrupts.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64S
RVTEST_CODE_BEGIN

  # clear pending IPIs then enable interrupts
  li s9, 0
  la a0, handler
  csrw evec, a0
  csrw count, x0
  li a1, 5000
  csrw compare, a1
  li a0, SR_EI | (1 << (IRQ_TIMER + SR_IM_SHIFT))
  csrs status, a0

  # advance an LFSR 1000 times
  li s0, 1023
  li s1, 1023
  li s4, 0
1:srl s2,s0,3
  xor s2,s2,s0
  and s2,s2,1
  srl s0,s0,1
  sll s2,s2,9
  or  s0,s2,s0
  sll s0,s0,54
  srl s0,s0,54
  add s4, s4, 1
  bne s0,s1,1b

  csrc status, SR_EI

  li TESTNUM, 2
  beqz s9, fail    # make sure we took at least one interrupt
  li TESTNUM, 3
  bne s4, s1, fail # make sure the LFSR period was correct

  RVTEST_PASS

  TEST_PASSFAIL

handler:
  csrr t0, cause
  li t1, 0x8000000000000007
  bne t0, t1, fail

  csrr t0, compare
  addi t0, t0, 99
  csrw compare, t0

  add s9, s9, 1

  sret

RVTEST_CODE_END
