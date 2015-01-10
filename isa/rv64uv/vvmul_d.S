# See LICENSE for license details.

#*****************************************************************************
# vvmul_d.S
#-----------------------------------------------------------------------------
#
# Test vvmul d.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UV
RVTEST_CODE_BEGIN

  vsetcfg 32,0
  li a3,4
  vsetvl a3,a3

  la a3,src1
  la a4,src2
  vld vx2,a3
  vld vx3,a4
  lui a0,%hi(vtcode)
  vf %lo(vtcode)(a0)
  la a5,dest
  vsd vx2,a5
  fence
  ld a1,0(a5)
  li a2,4
  li TESTNUM,2
  bne a1,a2,fail
  ld a1,8(a5)
  li a2,6
  li TESTNUM,3
  bne a1,a2,fail
  ld a1,16(a5)
  li a2,6
  li TESTNUM,4
  bne a1,a2,fail
  ld a1,24(a5)
  li a2,4
  li TESTNUM,5
  bne a1,a2,fail
  j pass

vtcode:
  mul x2,x2,x3
  stop

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

src1:
  .dword 1
  .dword 2
  .dword 3
  .dword 4
src2:
  .dword 4
  .dword 3
  .dword 2
  .dword 1
dest:
  .dword 0xdeadbeefcafebabe
  .dword 0xdeadbeefcafebabe
  .dword 0xdeadbeefcafebabe
  .dword 0xdeadbeefcafebabe

RVTEST_DATA_END
