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

  vsetcfg 3,16
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

# verify 1st fadd
  li a2,0
loop1:
  ld a0,0(a5)
  addi TESTNUM,a2,3
  bne a0,s4,fail
  addi a5,a5,8
  addi a2,a2,1
  bne a2,a3,loop1

# verify 2nd fmadd
  la a5,dest
  vfsd vf2,a5
  fence
  ld s4,8(s3)

  li a2,0
loop2:
  ld a0,0(a5)
  addi TESTNUM,a2,3
  bne a0,s4,fail
  addi a5,a5,8
  addi a2,a2,1
  bne a2,a3,loop2

# verify 3rd fmul
  la a5,dest
  vfsd vf5,a5
  fence
  ld s4,16(s3)

  li a2,0
loop3:
  ld a0,0(a5)
  addi TESTNUM,a2,3
  bne a0,s4,fail
  addi a5,a5,8
  addi a2,a2,1
  bne a2,a3,loop3

# verify 4th fmul
  la a5,dest
  vfsd vf8,a5
  fence
  ld s4,24(s3)

  li a2,0
loop4:
  ld a0,0(a5)
  addi TESTNUM,a2,3
  bne a0,s4,fail
  addi a5,a5,8
  addi a2,a2,1
  bne a2,a3,loop4

# verify 5th fmadd
  la a5,dest
  vfsd vf9,a5
  fence
  ld s4,32(s3)

  li a2,0
loop5:
  ld a0,0(a5)
  addi TESTNUM,a2,3
  bne a0,s4,fail
  addi a5,a5,8
  addi a2,a2,1
  bne a2,a3,loop5

# verify 6th fnmadd
  la a5,dest
  vfsd vf11,a5
  fence
  ld s4,40(s3)

  li a2,0
loop6:
  ld a0,0(a5)
  addi TESTNUM,a2,3
  bne a0,s4,fail
  addi a5,a5,8
  addi a2,a2,1
  bne a2,a3,loop6

  j pass

vtcode:
  fmv.d.x f0,x1
  fmv.d.x f1,x2
  fmv.d.x f2,x1
  fmv.d.x f3,x2
  fmv.d.x f4,x1
  fmv.d.x f5,x2
  fmv.d.x f6,x1
  fmv.d.x f7,x2
  fmv.d.x f8,x1
  fmv.d.x f9,x2
  fmv.d.x f10,x1
  fmv.d.x f11,x2
  fmv.d.x f12,x1
  fmv.d.x f13,x2
  fmv.d.x f14,x1
  fmv.d.x f15,x2
  fadd.d f0,f0,f1
  fmadd.d f2,f2,f3,f4
  fmul.d f5,f5,f6
  fmul.d f8,f5,f7
  fmadd.d f9,f9,f10,f9
  fnmadd.d f11,f12,f13,f14
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
  .double 3.0
  .double 2.0
  .double 4.0
  .double 4.0
  .double -3.0
dest:
  .skip 16384

RVTEST_DATA_END
