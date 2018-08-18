# See LICENSE for license details.

#*****************************************************************************
# scall.S
#-----------------------------------------------------------------------------
#
# Test syscall trap.
#
# If the pmp registers are implemented, then the pmp registers have 
# to be configured before jumping to the privilaged modes

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

  li TESTNUM, 2

#ifdef __MACHINE_MODE
  # If running in M mode, use mstatus.MPP to check existence of U mode.
  # Otherwise, if in S mode, then U mode must exist and we don't need to check.

  la t0, user_mode_end
  srli t0, t0, PMP_SHIFT
  csrr t1, pmpcfg0
  csrw pmpaddr0, t0
  csrr t1, pmpaddr0
  bne t0, t1, fail
  li t0, (PMP_R | PMP_W | PMP_X)   # giving read, write and execute permissions
  or t0, t0, PMP_TOR  # setting mode to TOR
  li t1, 255
  csrrc t1, pmpcfg0, t1
  csrrs t1, pmpcfg0, t0
  csrr  t1, pmpcfg0
  andi  t1, t1, 255
  bne t0, t1, fail
.global no_pmp_implemented
no_pmp_implemented:
  li t0, MSTATUS_MPP
  csrc mstatus, t0
  csrr t1, mstatus
  and t0, t0, t1
  
# This is the expected trap code.
  li t1, CAUSE_USER_ECALL
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

  .align 2
  .global user_mode_end
user_mode_end:
  nop

  TEST_PASSFAIL

  .align 2
  .global stvec_handler
stvec_handler:
  csrr t0, scause
  bne t0, t1, check_for_pmp
  la t2, do_scall
  csrr t0, sepc
  bne t0, t2, fail
  j pass

check_for_pmp: 
  li t1, CAUSE_ILLEGAL_INSTRUCTION
  bne t0, t1, fail
  j no_pmp_implemented
RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
