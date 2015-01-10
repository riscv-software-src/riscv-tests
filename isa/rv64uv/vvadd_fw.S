# See LICENSE for license details.

#*****************************************************************************
# vvadd_fw.S
#-----------------------------------------------------------------------------
#
# Test vvadd fw.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UV
RVTEST_CODE_BEGIN

  vsetcfg 32,32
  li a3,4
  vsetvl a3,a3

  la a3,src1
  la a4,src2
  vflw vf2,a3
  vflw vf3,a4
  lui a0,%hi(vtcode)
  vf %lo(vtcode)(a0)
  la a5,dest
  vfsw vf2,a5
  fence
  la a6,result
  lw a1,0(a5)
  lw a2,0(a6)
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
  fadd.s f2,f2,f3
  stop

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

src1:
  .single 0.1
  .single 0.2
  .single 0.3
  .single 0.4
src2:
  .single 0.4
  .single 0.3
  .single 0.2
  .single 0.1
dest:
  .word 0xdeadbeef
  .word 0xdeadbeef
  .word 0xdeadbeef
  .word 0xdeadbeef
result:
  .single 0.5
  .single 0.5
  .single 0.5
  .single 0.5

RVTEST_DATA_END
