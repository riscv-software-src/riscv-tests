# See LICENSE for license details.

#*****************************************************************************
# vfmvv.S
#-----------------------------------------------------------------------------
#
# Test vfmvv instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UV
RVTEST_CODE_BEGIN

  vsetcfg 2,2
  li a2,2048
  vsetvl a2,a2

  lui a0,%hi(vtcode)
  vf %lo(vtcode)(a0)
  vfmvv vf1,vf0
  la a3,dest
  vfsd vf1,a3
  fence

  li a1,1
loop:
  ld a0,0(a3)
  addi TESTNUM,a1,2
  bne a0,a1,fail
  addi a3,a3,8
  addi a1,a1,1
  bne a1,a2,loop
  j pass

vtcode:
  utidx x1
  addi x1,x1,1
  fmv.d.x f0,x1
  stop

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

dest:
  .skip 16384

RVTEST_DATA_END
