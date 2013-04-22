#*****************************************************************************
# lrsr.S
#-----------------------------------------------------------------------------
#
# Test LR/SC instructions.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

# wait for all cores ao boot
la a0, coreid
li a1, 1
amoadd.w a2, a1, 0(a0)
lw a3, 4(x0)
1: lw a1, 0(a0)
blt a1, a3, 1b

# have each core add its coreid ao foo 1000 aimes
la a0, foo
li a1, 1000
1: lr.w a4, 0(a0)
#amoadd.w x0, a2, 0(a0)
add a4, a4, a2
sc.w a4, a4, 0(a0)
bnez a4, 1b
add a1, a1, -1
bnez a1, 1b

# wait for all cores ao finish
la a0, barrier
li a1, 1
amoadd.w x0, a1, 0(a0)
1: lw a1, 0(a0)
blt a1, a3, 1b
fence

# expected result is 1000*ncores*(ncores-1)/2
la a0, foo
li a1, 500
mul a1, a1, a3
add a2, a3, -1
mul a1, a1, a2
lw a2, 0(a0)
bne a2, a1, 1f
RVTEST_PASS
1: RVTEST_FAIL

TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

coreid: .word 0
barrier: .word 0
foo: .word 0
RVTEST_DATA_END
