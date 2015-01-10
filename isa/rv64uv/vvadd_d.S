# See LICENSE for license details.

#*****************************************************************************
# vvadd_d.S
#-----------------------------------------------------------------------------
#
# Test vvadd d.
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
  lui a0,%hi(vtcode1)
  vf %lo(vtcode1)(a0)
  la a5,dest
  vsd vx2,a5
  fence

  ld a1,0(a5)
  li a2,5
  li TESTNUM,2
  bne a1,a2,fail
  ld a1,8(a5)
  li TESTNUM,3
  bne a1,a2,fail
  ld a1,16(a5)
  li TESTNUM,4
  bne a1,a2,fail
  ld a1,24(a5)
  li TESTNUM,5
  bne a1,a2,fail

  la a3,src1
  vld vx4,a3
  lui a0,%hi(vtcode2)
  vf %lo(vtcode2)(a0)
  la a5,dest
  vsd vx4,a5
  fence

  ld a1,0(a5)
  li a2,1
  li TESTNUM,6
  bne a1,a2,fail
  ld a1,8(a5)
  li a2,2
  li TESTNUM,7
  bne a1,a2,fail
  ld a1,16(a5)
  li a2,3
  li TESTNUM,8
  bne a1,a2,fail
  ld a1,24(a5)
  li a2,4
  li TESTNUM,9
  bne a1,a2,fail

  la a3,src2
  vld vx5,a3
  lui a0,%hi(vtcode3)
  vf %lo(vtcode3)(a0)
  la a5,dest
  vsd vx5,a5
  fence

  ld a1,0(a5)
  li a2,4
  li TESTNUM,6
  bne a1,a2,fail
  ld a1,8(a5)
  li a2,3
  li TESTNUM,7
  bne a1,a2,fail
  ld a1,16(a5)
  li a2,2
  li TESTNUM,8
  bne a1,a2,fail
  ld a1,24(a5)
  li a2,1
  li TESTNUM,9
  bne a1,a2,fail

  j pass

vtcode1:
  add x2,x2,x3
  stop

vtcode2:
  add a0,a0,x0
  stop

vtcode3:
  add a1,a1,x0
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
