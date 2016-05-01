# See LICENSE for license details.

#*****************************************************************************
# csr.S
#-----------------------------------------------------------------------------
#
# Test CSRRx and CSRRxI instructions.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64S
RVTEST_CODE_BEGIN

#ifdef __MACHINE_MODE
  #define sscratch mscratch
  #define sstatus mstatus
  #define scause mcause
  #define sepc mepc
  #define sret mret
  #define stvec_handler mtvec_handler
  #undef SSTATUS_SPP
  #define SSTATUS_SPP MSTATUS_MPP
#endif

  csrwi sscratch, 3
  TEST_CASE( 2, a0,         3, csrr a0, sscratch);
  TEST_CASE( 3, a1,         3, csrrci a1, sscratch, 1);
  TEST_CASE( 4, a2,         2, csrrsi a2, sscratch, 4);
  TEST_CASE( 5, a3,         6, csrrwi a3, sscratch, 2);
  TEST_CASE( 6, a1,         2, li a0, 0xbad1dea; csrrw a1, sscratch, a0);
  TEST_CASE( 7, a0, 0xbad1dea, li a0, 0x0001dea; csrrc a0, sscratch, a0);
  TEST_CASE( 8, a0, 0xbad0000, li a0, 0x000beef; csrrs a0, sscratch, a0);
  TEST_CASE( 9, a0, 0xbadbeef, csrr a0, sscratch);

  # Make sure writing the cycle counter causes an exception.
  # Don't run in supervisor, as we don't delegate illegal instruction traps.
#ifdef __MACHINE_MODE
  TEST_CASE(10, a0, 255, li a0, 255; csrrw a0, cycle, x0);
#endif

  # jump to user land
  li t0, SSTATUS_SPP
  csrc sstatus, t0
  la t0, 1f
  csrw sepc, t0
  sret
  1:

  # Make sure reading status in user mode causes an exception.
  # Don't run in supervisor, as we don't delegate illegal instruction traps.
#ifdef __MACHINE_MODE
  TEST_CASE(11, a0, 255, li a0, 255; csrr a0, sstatus)
#else
  TEST_CASE(11, x0, 0, nop)
#endif

  RVTEST_PASS

  # We should only fall through to this if scall failed.
  TEST_PASSFAIL

stvec_handler:
  # Trapping on tests 10 and 11 is good news.
  # Note that since the test didn't complete, TESTNUM is smaller by 1.
  li t0, 9
  beq TESTNUM, t0, privileged
  li t0, 10
  beq TESTNUM, t0, privileged

  # catch RVTEST_PASS and kick it up to M-mode
  csrr t0, scause
  li t1, CAUSE_USER_ECALL
  bne t0, t1, fail
  RVTEST_PASS

privileged:
  # Make sure scause indicates a lack of privilege.
  csrr t0, scause
  li t1, CAUSE_ILLEGAL_INSTRUCTION
  bne t0, t1, fail
  # Return to user mode, but skip the trapping instruction.
  csrr t0, sepc
  addi t0, t0, 4
  csrw sepc, t0
  sret

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
