# See LICENSE for license details.

#*****************************************************************************
# ipi.S
#-----------------------------------------------------------------------------
#
# Test interprocessor interrupts.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

  # enable interrupts
  csrs mstatus, MSTATUS_IE
  csrs mie, MIP_MSIP

  # get a unique core id
  la a0, coreid
  li a1, 1
  amoadd.w a2, a1, (a0)
  
  # for now, only run this on core 0
  1:li a3, 1
  bgeu a2, a3, 1b
  
  # wait for all cores to boot
  1: lw a1, (a0)
  bltu a1, a3, 1b

  # IPI dominoes
  csrr a0, mhartid
  1: bnez a0, 1b
  add a0, a0, 1
  rem a0, a0, a3
  csrw send_ipi, a0
  1: j 1b

mtvec_handler:
  csrr a0, mhartid
  bnez a0, 2f
  RVTEST_PASS

  TEST_PASSFAIL

  2: add a0, a0, 1
  rem a0, a0, a3
  csrw send_ipi, a0
  1: j 1b

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

coreid: .word 0
foo: .word 0

RVTEST_DATA_END
