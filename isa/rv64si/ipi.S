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
  mtpcr a0, cr3
  mtpcr x0, cr9
  mfpcr a0, cr0
  li a1, 0x00ff0001
  or a0, a0, a1
  mtpcr a0, cr0

  # wait for all cores to boot
  la a0, coreid
  li a1, 1
  amoadd.w x0, a1, 0(a0)
  lw a3, 4(x0)
  1: lw a1, 0(a0)
  blt a1, a3, 1b

  # IPI dominoes
  mfpcr a0, cr10
  1: bnez a0, 1b
  add a0, a0, 1
  rem a0, a0, a3
  mtpcr a0, cr8
  1: b 1b

  handler:
  mfpcr a0, cr10
  bnez a0, 2f
  RVTEST_PASS

  TEST_PASSFAIL

  2: add a0, a0, 1
  rem a0, a0, a3
  mtpcr a0, cr8
  1: b 1b

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

coreid: .word 0
foo: .word 0

RVTEST_DATA_END
