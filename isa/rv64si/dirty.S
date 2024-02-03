# See LICENSE for license details.

#*****************************************************************************
# dirty.S
#-----------------------------------------------------------------------------
#
# Test VM referenced and dirty bits.
#

#include "riscv_test.h"
#include "test_macros.h"

#if (DRAM_BASE >> 30 << 30) != DRAM_BASE
# error This test requires DRAM_BASE be SV39 superpage-aligned
#endif 

RVTEST_RV64M
RVTEST_CODE_BEGIN

  # Turn on VM
  li a0, (SATP_MODE & ~(SATP_MODE<<1)) * SATP_MODE_SV39
  la a1, page_table_1
  srl a1, a1, RISCV_PGSHIFT
  or a1, a1, a0
  csrw sptbr, a1
  sfence.vma

  # Set up MPRV with MPP=S, so loads and stores use S-mode
  li a1, ((MSTATUS_MPP & ~(MSTATUS_MPP<<1)) * PRV_S) | MSTATUS_MPRV
  csrs mstatus, a1

  # Try a faulting store to make sure dirty bit is not set
  li TESTNUM, 2
  li t2, 1
  sw t2, dummy - DRAM_BASE, a0

  li TESTNUM, 3
  # set ADUE to 0
#if __riscv_xlen == 64
  li a1, MENVCFG_ADUE
  csrc menvcfg, a1
#else
  li a1, MENVCFGH_ADUE
  csrc menvcfgh, a1
#endif

  # We do this test twice (as 3 and again as 4). For the second run,
  # we'll have toggled ADUE and branch to here:
1:
  # Set SUM=1 so user memory access is permitted
  li a1, ((MSTATUS_MPP & ~(MSTATUS_MPP<<1)) * PRV_S) | MSTATUS_SUM
  csrs mstatus, a1

  # Make sure SUM=1 works
  lw t0, dummy - DRAM_BASE
  bnez t0, die

  # Clear D bit, then do a non-faulting store and ensure D bit is set
  # Leave MPRV
  li t0, MSTATUS_MPRV
  csrc mstatus, t0

  # Clear D bit
  lw t0, page_table_1
  li a0, ~(PTE_D)
  and t0, t0, a0
  sw t0, page_table_1, a0
  sfence.vma

  # Enter MPRV again
  li t0, MSTATUS_MPRV
  csrs mstatus, t0

  # Now, the non-faulting store
  addi t2, t2, 1
  sw t2, dummy - DRAM_BASE, a0

  # Make sure it succeeded
  lw t0, dummy - DRAM_BASE
  bne t0, t2, die

  # Leave MPRV
  li t0, MSTATUS_MPRV
  csrc mstatus, t0

  # Make sure D bit is set
  sfence.vma
  lw t0, page_table_1
  li a0, PTE_A | PTE_D
  and t0, t0, a0
  bne t0, a0, die

  # Enter MPRV again
  li t0, MSTATUS_MPRV
  csrs mstatus, t0

  addi TESTNUM, TESTNUM, 1
  li t0, 5
  beq TESTNUM, t0, 1f

  # reset this value:
  sw zero, dummy - DRAM_BASE, a0

  # set ADUE to 1
#if __riscv_xlen == 64
  li a1, MENVCFG_ADUE
  csrs menvcfg, a1
#else
  li a1, MENVCFGH_ADUE
  csrs menvcfgh, a1
#endif

  j 1b
1:
  # Make sure that superpage entries trap when PPN LSBs are set.
  li TESTNUM, 5
  lw a0, page_table_1 - DRAM_BASE
  or a0, a0, 1 << PTE_PPN_SHIFT
  sw a0, page_table_1 - DRAM_BASE, t0
  sfence.vma
  sw a0, page_table_1 - DRAM_BASE, t0
  j die
  
  RVTEST_PASS

  TEST_PASSFAIL

  .align 2
  .global mtvec_handler
mtvec_handler:
  csrr t0, mcause
  add t0, t0, -CAUSE_STORE_PAGE_FAULT
  bnez t0, die

  li t1, 2
  bne TESTNUM, t1, 1f
  # Make sure D bit is clear
  lw t0, page_table_1
  and t1, t0, PTE_D
  bnez t1, die
skip:
  csrr t0, mepc
  add t0, t0, 4
  csrw mepc, t0
  mret

1:
  li t1, 4
  bgt TESTNUM, t1, 1f
  # The implementation doesn't appear to set D bits in HW.
  # Verify that ADUE is 0.
#if __riscv_xlen == 64
  csrr a1, menvcfg
  li t0, MENVCFG_ADUE
  and a1, a1, t0
  bnez a1, die
#else
  csrr a1, menvcfgh
  li t0, MENVCFGH_ADUE
  and a1, a1, t0
  bnez a1, die
#endif
  # Make sure the D bit really is clear.
  lw t0, page_table_1
  and t1, t0, PTE_D
  bnez t1, die
  # Set the D bit.
  or t0, t0, PTE_D
  sw t0, page_table_1, t1
  sfence.vma
  mret

1:
  li t1, 5
  bne TESTNUM, t1, 1f
  j pass

1:
die:
  RVTEST_FAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

.align 12
page_table_1: .dword (DRAM_BASE/RISCV_PGSIZE << PTE_PPN_SHIFT) | PTE_V | PTE_U | PTE_R | PTE_W | PTE_X | PTE_A
dummy: .dword 0

RVTEST_DATA_END
