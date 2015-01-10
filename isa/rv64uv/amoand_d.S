# See LICENSE for license details.

#*****************************************************************************
# amoand_d.S
#-----------------------------------------------------------------------------
#
# Test amoand.d instruction in a vf block.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UV
RVTEST_CODE_BEGIN

  vsetcfg 4,0
  li a4,2048
  vsetvl a4,a4

  la a5,amodest
  vmsv vx2,a5
  lui a0,%hi(vtcode)
  vf %lo(vtcode)(a0)
  la a6,dest
  vsd vx1,a6
  fence

  li a1,0
  li a2,0
loop:
  ld a0,0(a6)
  addi TESTNUM,a1,2
  bne a0,a2,fail
  addi a6,a6,8
  addi a1,a1,1
  bne a1,a4,loop
  j pass

vtcode:
  li x3,-1
  amoand.d x1,x3,0(x2)
  stop

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

amodest:
  .dword 0
dest:
  .skip 16384

RVTEST_DATA_END
