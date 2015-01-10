# See LICENSE for license details.

#*****************************************************************************
# vvadd_w.S
#-----------------------------------------------------------------------------
#
# Test vvadd w.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UV
RVTEST_CODE_BEGIN

  vsetcfg 32,0
  li a3,9
  vsetvl a3,a3

  la a3,src1
  la a4,src2
  vlw vx2,a3
  vlw vx3,a4
  lui a0,%hi(vtcode)
  vf %lo(vtcode)(a0)
  la a5,dest
  vsw vx2,a5
  fence
  lw a1,0(a5)
  li a2,10
  li TESTNUM,2
  bne a1,a2,fail
  lw a1,4(a5)
  li TESTNUM,3
  bne a1,a2,fail
  lw a1,8(a5)
  li TESTNUM,4
  bne a1,a2,fail
  lw a1,12(a5)
  li TESTNUM,5
  bne a1,a2,fail
  j pass

vtcode:
  addw x2,x2,x3
  stop

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

src1:
  .word 1
  .word 2
  .word 3
  .word 4
  .word 5
  .word 6
  .word 7
  .word 8
  .word 9
src2:
  .word 9
  .word 8
  .word 7
  .word 6
  .word 5
  .word 4
  .word 3
  .word 2
  .word 1
dest:
  .word 0xdeadbeef
  .word 0xdeadbeef
  .word 0xdeadbeef
  .word 0xdeadbeef
  .word 0xdeadbeef
  .word 0xdeadbeef
  .word 0xdeadbeef
  .word 0xdeadbeef
  .word 0xdeadbeef

RVTEST_DATA_END
