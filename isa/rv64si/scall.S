# See LICENSE for license details.

#*****************************************************************************
# scall.S
#-----------------------------------------------------------------------------
#
# Test syscall trap.
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
  #undef SSTATUS_SPP
  #define SSTATUS_SPP MSTATUS_MPP
#endif

  li TESTNUM, 2

  # This is the expected trap code.
  li t1, CAUSE_USER_ECALL

#ifdef __MACHINE_MODE
  # If running in M mode, use mstatus.MPP to check existence of U mode.
  # Otherwise, if in S mode, then U mode must exist and we don't need to check.
  li t0, MSTATUS_MPP
  csrc mstatus, t0
  csrr t2, mstatus
  and t0, t0, t2
  beqz t0, 1f

  # If U mode doesn't exist, mcause should indicate ECALL from M mode.
  li t1, CAUSE_MACHINE_ECALL
#endif

1:
  li t0, SSTATUS_SPP
  csrc sstatus, t0
  la t0, 1f
  csrw sepc, t0
  sret
1:

  li TESTNUM, 1
do_scall:
  scall
  j fail

  TEST_PASSFAIL

# make the linker not find the symbol stvec_handler when running in machine
# mode. env/p/riscv_test.h sets stvec to the address of that symbol in case it
# is non-zero. thus, effectively, we don't register a handler for scalls, so
# that the default handler (trap_vector) is used.
#ifndef __MACHINE_MODE
  .align 2
  .global stvec_handler
stvec_handler:
  csrr t0, scause
  bne t0, t1, fail
  la t2, do_scall
  csrr t0, sepc
  bne t0, t2, fail
  j pass
#endif

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
