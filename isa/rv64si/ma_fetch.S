# See LICENSE for license details.

#*****************************************************************************
# ma_fetch.S
#-----------------------------------------------------------------------------
#
# Test misaligned fetch trap.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64S
RVTEST_CODE_BEGIN

#ifdef __MACHINE_MODE
  #define sscratch mscratch
  #define sstatus mstatus
  #define scause mcause
  #define sbadaddr mbadaddr
  #define sepc mepc
  #define sret mret
  #define stvec_handler mtvec_handler
#endif

  .align 2
  .option norvc

  # Without RVC, the jalr should trap, and the handler will skip ahead.
  # With RVC, the jalr should not trap, and "j fail" should get skipped.
  li TESTNUM, 2
  li t1, 0
  la t0, 1f
  jalr t1, t0, 2
1:
  .option rvc
  c.j 1f
  c.j 2f
  .option norvc
1:
  j fail
2:

  // This test should pass, since JALR ignores the target LSB
  li TESTNUM, 3
  la t0, 1f
  jalr t1, t0, 1
1:
  j 1f
  j fail
1:

  li TESTNUM, 4
  li t1, 0
  la t0, 1f
  jalr t1, t0, 3
1:
  .option rvc
  c.j 1f
  c.j 2f
  .option norvc
1:
  j fail
2:

  # Like test 2, but with jal instead of jalr.
  li TESTNUM, 5
  li t1, 0
  la t0, 1f
  jal t1, 2f
1:
  .option rvc
  c.j 1f
2:
  c.j 2f
  .option norvc
1:
  j fail
2:

  # Like test 2, but with a taken branch instead of jalr.
  li TESTNUM, 6
  li t1, 0
  la t0, 1f
  beqz x0, 2f
1:
  .option rvc
  c.j 1f
2:
  c.j 2f
  .option norvc
1:
  j fail
2:

  # Not-taken branches should not trap, even without RVC.
  li TESTNUM, 7
  bnez x0, 1f
  j 2f
  .option rvc
  c.j 1f
1:
  c.j 1f
  .option norvc
1:
  j fail
2:

#ifdef __MACHINE_MODE
  # If RVC can be disabled, then disabling it should cause a misaligned
  # instruction exception on the next instruction.  (This test assumes
  # no other extensions that support misalignment are present.)
  li TESTNUM, 8
  csrr t2, misa
  andi t2, t2, 1 << ('c' - 'a')
  beqz t2, 2f

  la t0, 1f
  .option rvc
  c.nop
  csrci misa, 1 << ('c' - 'a')
1:
  c.j 1f
  .option norvc

  # If we got here, we trapped.  Re-enable RVC and proceed.
  csrsi misa, 1 << ('c' - 'a')
  j 2f

1:
  # If we got here, we didn't trap, so RVC had better be enabled.
  csrr t2, misa
  andi t2, t2, 1 << ('c' - 'a')
  beqz t2, fail

2:
  # mret to a misaligned mepc should either align the mepc or raise a
  # misaligned instruction exception.
  la t0, 1f
  addi t0, t0, -2
  csrw mepc, t0

  # Try to disable RVC; if it can't be disabled, skip the test.
  csrci misa, 1 << ('c' - 'a')
  csrr t2, misa
  andi t2, t2, 1 << ('c' - 'a')
  bnez t2, 2f

  li t2, MSTATUS_MPP
  csrs mstatus, t2
  mret

  # If the implementation chose to align mepc, mret will transfer control
  # to this branch.  Otherwise, it will transfer control two bytes into
  # the branch, which happens to be the illegal instruction c.unimp.
  # But c.unimp should not be executed, since the PC is misaligned.
  beqz x0, 1f
1:
  j 2f

test8_handler:
  # verify trap cause
  li a1, CAUSE_MISALIGNED_FETCH
  csrr a0, mcause
  bne a0, a1, fail

  # check that mepc == t0, and advance mepc past the misalignment
  csrr a0, mepc
  bne a0, t0, fail
  addi a0, a0, 2
  csrw mepc, a0

  # check that badaddr == t0 or zero
  csrr a0, mbadaddr
  beqz a0, 1f
  bne a0, t0, fail
1:
  mret

2:
#endif

  j pass

  TEST_PASSFAIL

  .align 2
  .global stvec_handler
stvec_handler:
  # tests 2, 4, 5, 6, and 8 should trap
  li a0, 2
  beq TESTNUM, a0, 1f
  li a0, 4
  beq TESTNUM, a0, 1f
  li a0, 5
  beq TESTNUM, a0, 1f
  li a0, 6
  beq TESTNUM, a0, 1f
#ifdef __MACHINE_MODE
  li a0, 8
  beq TESTNUM, a0, test8_handler
#endif
  j fail
1:

  # verify that return address was not written
  bnez t1, fail

  # verify trap cause
  li a1, CAUSE_MISALIGNED_FETCH
  csrr a0, scause
  bne a0, a1, fail

  # verify that epc == &jalr (== t0 - 4)
  csrr a1, sepc
  addi a1, a1, 4
  bne t0, a1, fail

  # verify that badaddr == 0 or badaddr == t0+2.
  csrr a0, sbadaddr
  beqz a0, 1f
  addi a0, a0, -2
  bne a0, t0, fail
1:

  addi a1, a1, 12
  csrw sepc, a1
  sret

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
