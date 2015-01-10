# See LICENSE for license details.

#*****************************************************************************
# vvadd_packed.S
#-----------------------------------------------------------------------------
#
# Test packed half-precision vvadd
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UV
RVTEST_CODE_BEGIN

	li x1, 12 # number of test elements
	move x10, x1
	vsetucfg x2, 0x2
	vsetcfg x2, 3, 1
loop:
	vsetvl x4, x1
	la x2, addr
	vmsv vx1, x2
	la x3, test
	vf 0(x3)
	sub x1, x1, x4
	bnez x1, loop
	fence
	j check

enable_accel:
	csrr x2, status
	ori x2, x2, 0x100
	csrw status, x2
	# test if set
	csrr x2, status
	andi x2, x2, 0x100
	beqz x2, fail
	ret

enable_fp:
	csrr x2, status
	ori x2, x2, 0x10
	csrw status, x2
	# test if set
	csrr x2, status
	andi x2, x2, 0x10
	beqz x2, fail
	ret

test:
	utidx x2
	slli x2, x2, 2
	add x1, x1, x2
	flh f0, 0(x1)
	fmul.h f0, f0, f0
	fsh f0, 0(x1)
	stop

check:
	la x2, addr
        la x4, expc

check_loop:
	lw x3, 0(x4)
	lw x1, 0(x2)
	bne x1, x3, fail
	addi x10, x10, -1
	addi x4, x4, 0x4
	addi x2, x2, 0x4
	bnez x10, check_loop
	j pass

	TEST_PASSFAIL

.data
RVTEST_DATA_BEGIN

	TEST_DATA

addr: .word 0x4000
      .word 0x4400
      .word 0x4800
      .word 0x5000
      .word 0x4001
      .word 0x4401
      .word 0x4801
      .word 0x5001
      .word 0x4002
      .word 0x4402
      .word 0x4802
      .word 0x5002

expc: .word 0x4400
      .word 0x4c00
      .word 0x5400
      .word 0x6400
      .word 0x4402
      .word 0x4c02
      .word 0x5402
      .word 0x6402
      .word 0x4404
      .word 0x4c04
      .word 0x5404
      .word 0x6404

RVTEST_DATA_END
