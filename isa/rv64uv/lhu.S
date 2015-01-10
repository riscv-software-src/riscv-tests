# See LICENSE for license details.

#*****************************************************************************
# lhu.S
#-----------------------------------------------------------------------------
#
# Test lhu instruction in a vf block.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UV
RVTEST_CODE_BEGIN

  vsetcfg 16,0
  li a4,512
  vsetvl a4,a4

  la a5,src
  vmsv vx2,a5
  lui a0,%hi(vtcode)
  vf %lo(vtcode)(a0)
  la a6,dest
  vsd vx1,a6
  fence

  li a2,0
loop:
  ld a0,0(a6)
  ld a1,0(a5)
  sll a3,a1,48
  srl a3,a3,48
  addi TESTNUM,a2,2
  bne a0,a3,fail
  addi a6,a6,8
  addi a5,a5,8
  addi a2,a2,1
  bne a2,a4,loop
  j pass

vtcode:
  utidx x3
  slli x3,x3,3
  add x2,x2,x3
  lhu x1,0(x2)
  stop

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

src:
#include "data_d.h"

dest:
  .skip 16384

RVTEST_DATA_END
