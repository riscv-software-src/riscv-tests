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
  la a0, handler
  csrw evec, a0
  csrw clear_ipi, x0
  li a0, SR_EI | (1 << (IRQ_IPI + SR_IM_SHIFT))
  csrs status, a0

  # wait for all cores to boot
  la a0, coreid
  li a1, 1
  amoadd.w x0, a1, 0(a0)
  lw a3, 4(x0)
  1: lw a1, 0(a0)
  blt a1, a3, 1b

  # IPI dominoes
  csrr a0, hartid
  1: bnez a0, 1b
  add a0, a0, 1
  rem a0, a0, a3
  csrw send_ipi, a0
  1: b 1b

  handler:
  csrr a0, hartid
  bnez a0, 2f
  RVTEST_PASS

  TEST_PASSFAIL

  2: add a0, a0, 1
  rem a0, a0, a3
  csrw send_ipi, a0
  1: b 1b

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

coreid: .word 0
foo: .word 0

RVTEST_DATA_END
