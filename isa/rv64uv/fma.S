# See LICENSE for license details.

#*****************************************************************************
# fma.S
#-----------------------------------------------------------------------------
#
# Test fma instruction in a vf block.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UV
RVTEST_CODE_BEGIN

  vsetcfg 3,2
  li a3,2048
  vsetvl a3,a3

  la a4,src
  fld f0,0(a4)
  fld f1,8(a4)
  fmv.x.d s0,f0
  fmv.x.d s1,f1
  vmsv vx1,s0
  vmsv vx2,s1
  lui a0,%hi(vtcode)
  vf %lo(vtcode)(a0)

  li a7,0
  li a6,400
wait:
  addi a7,a7,1
  bne a7,a6,wait

  fadd.d f0,f0,f1
  fmv.x.d s2,f0

  la a5,dest
  vfsd vf0,a5
  fence

  la s3,result
  ld s4,0(s3)
  li TESTNUM,2
  bne s2,s4,fail

  li a2,0
loop:
  ld a0,0(a5)
  addi TESTNUM,a2,3
  bne a0,s4,fail
  addi a5,a5,8
  addi a2,a2,1
  bne a2,a3,loop
  j pass

vtcode:
  fmv.d.x f0,x1
  fmv.d.x f1,x2
  fadd.d f0,f0,f1
  stop

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

src:
  .double 1.0
  .double 2.0
result:
  .double 3.0
dest:
  .skip 16384

RVTEST_DATA_END
