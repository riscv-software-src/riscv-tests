# See LICENSE for license details.

#*****************************************************************************
# amoxor_w.S
#-----------------------------------------------------------------------------
#
# Test amoxor.w instruction in a vf block.
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
  vsw vx1,a6
  fence

  li a1,0
  li a2,-1
loop:
  lw a0,0(a6)
  addi TESTNUM,a1,2
  bne a0,a2,fail
  addi a6,a6,4
  addi a1,a1,1
  li t0,0xcafe
  xor a2,a2,t0
  bne a1,a4,loop
  j pass

vtcode:
  li x3,0xcafe
  amoxor.w x1,x3,0(x2)
  stop

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

amodest:
  .word -1
dest:
  .skip 16384

RVTEST_DATA_END
