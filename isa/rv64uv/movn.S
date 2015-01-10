# See LICENSE for license details.

#*****************************************************************************
# movn.S
#-----------------------------------------------------------------------------
#
# Test movn instruction in a vf block.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UV
RVTEST_CODE_BEGIN

  vsetcfg 4,0
  li a6,2048
  vsetvl a6,a6

  lui a0,%hi(vtcode)
  vf %lo(vtcode)(a0)
  la a7,dest
  vsd vx3,a7
  fence

  li a1,0
  li a2,-1
loop:
  ld a0,0(a7)
  slt a4,a1,10
  slli a4,a4,63
  srai a4,a4,63
  and a5,a2,a4
  addi s8,a1,2
  bne a0,a5,fail
  addi a7,a7,8
  addi a1,a1,1
  bne a1,a6,loop
  j pass

vtcode:
  utidx x1
  slti x2,x1,10
  li x1,-1
  li x3,0
  movn x3,x2,x1
  stop

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

dest:
  .skip 16384

RVTEST_DATA_END
