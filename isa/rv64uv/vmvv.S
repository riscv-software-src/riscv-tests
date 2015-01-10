# See LICENSE for license details.

#*****************************************************************************
# vmvv.S
#-----------------------------------------------------------------------------
#
# Test vmvv instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UV
RVTEST_CODE_BEGIN

  vsetcfg 3,0
  li a2,2048
  vsetvl a2,a2

  lui a0,%hi(vtcode)
  vf %lo(vtcode)(a0)
  vmvv vx2,vx1
  la a4,dest
  vsd vx2,a4
  fence

  li a1,1
loop:
  ld a0,0(a4)
  addi TESTNUM,a1,2
  bne a0,a1,fail
  addi a4,a4,8
  addi a1,a1,1
  bne a1,a2,loop
  j pass

vtcode:
  utidx x1
  addi x1,x1,1
  stop

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

dest:
  .skip 16384

RVTEST_DATA_END
