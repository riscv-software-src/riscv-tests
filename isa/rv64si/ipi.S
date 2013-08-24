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
  mtpcr a0, evec
  mtpcr x0, clear_ipi
  mfpcr a0, status
  li a1, SR_EI | (1 << (IRQ_IPI + SR_IM_SHIFT))
  or a0, a0, a1
  mtpcr a0, status

  # wait for all cores to boot
  la a0, coreid
  li a1, 1
  amoadd.w x0, a1, 0(a0)
  lw a3, 4(x0)
  1: lw a1, 0(a0)
  blt a1, a3, 1b

  # IPI dominoes
  mfpcr a0, hartid
  1: bnez a0, 1b
  add a0, a0, 1
  rem a0, a0, a3
  mtpcr a0, send_ipi
  1: b 1b

  handler:
  mfpcr a0, hartid
  bnez a0, 2f
  RVTEST_PASS

  TEST_PASSFAIL

  2: add a0, a0, 1
  rem a0, a0, a3
  mtpcr a0, send_ipi
  1: b 1b

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

coreid: .word 0
foo: .word 0

RVTEST_DATA_END
