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
  csrs mstatus, MSTATUS_MIE
  csrs mie, MIP_MSIP

  # get a unique core id
  la a0, coreid
  li a1, 1
  amoadd.w a2, a1, (a0)
  
  # for now, only run this on core 0
  1:li a3, 1
  bgeu a2, a3, 1b
  
  # send a self-IPI
  csrwi mipi, 1
  1: j 1b

mtvec_handler:
  bnez a2, fail
  RVTEST_PASS

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

coreid: .word 0
foo: .word 0

RVTEST_DATA_END
