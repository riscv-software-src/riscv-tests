# See LICENSE for license details.

#*****************************************************************************
# fsd.S
#-----------------------------------------------------------------------------
#
# Test fsd instruction in a vf block.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UV
RVTEST_CODE_BEGIN

  vsetcfg 4,1
  li a4,2048
  vsetvl a4,a4

  la a5,src
  vfld vf0,a5
  la a6,dest
  vmsv vx2,a6
  lui a0,%hi(vtcode)
  vf %lo(vtcode)(a0)
  fence

  li a2,0
loop:
  ld a0,0(a6)
  addi TESTNUM,a2,2
  ld a1,0(a5)
  bne a0,a1,fail
  addi a6,a6,8
  addi a5,a5,8
  addi a2,a2,1
  bne a2,a4,loop
  j pass

vtcode:
  utidx x3
  slli x3,x3,3
  add x2,x2,x3
  fsd f0,0(x2)
  stop

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

src:
#include "data_fd.h"

dest:
  .skip 16384

RVTEST_DATA_END
