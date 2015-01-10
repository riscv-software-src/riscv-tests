# See LICENSE for license details.

#*****************************************************************************
# imul.S
#-----------------------------------------------------------------------------
#
# Test imul instruction in a vf block.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UV
RVTEST_CODE_BEGIN

  vsetcfg 3,0
  li a3,2048
  vsetvl a3,a3

  li a4,20
  li s0,2
  vmsv vx1,a4
  lui a0,%hi(vtcode)
  vf %lo(vtcode)(a0)

  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  mul s1,a4,s0

  la a5,dest
  vsd vx1,a5
  fence

  li s2,40
  li TESTNUM,2
  bne s1,s2,fail

  li a1,0
  li a2,0
loop:
  ld a0,0(a5)
  addi TESTNUM,a2,3
  bne a0,a1,fail
  addi a5,a5,8
  addi a1,a1,20
  addi a2,a2,1
  bne a2,a3,loop
  j pass

vtcode:
  utidx x2
  mul x1,x2,x1
  stop

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

dest:
  .skip 16384

RVTEST_DATA_END
