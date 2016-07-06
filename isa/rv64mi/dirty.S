# See LICENSE for license details.

#*****************************************************************************
# dirty.S
#-----------------------------------------------------------------------------
#
# Test VM referenced and dirty bits.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

  # Turn on VM with superpage identity mapping
  la a1, page_table_1
  srl a1, a1, RISCV_PGSHIFT
  la a2, page_table_2
  srl a2, a2, RISCV_PGSHIFT
  csrw sptbr, a1
  sfence.vm
  li a1, ((MSTATUS_VM & ~(MSTATUS_VM<<1)) * VM_SV39) | ((MSTATUS_MPP & ~(MSTATUS_MPP<<1)) * PRV_S)
  csrs mstatus, a1
  la a1, 1f - DRAM_BASE
  csrw mepc, a1
  la a1, stvec_handler - DRAM_BASE
  csrw stvec, a1
  mret
1:

  # Try a faulting store to make sure dirty bit is not set
  li TESTNUM, 2
  li t0, 1
  sw t0, dummy, t1

  # Load new page table
  li TESTNUM, 3
  csrw sptbr, a2
  sfence.vm

  # Try a non-faulting store to make sure dirty bit is set
  sw t0, dummy, t1

  # Make sure R and D bits are set
  lw t0, page_table_2
  li t1, PTE_A | PTE_D
  and t0, t0, t1
  bne t0, t1, die
  
  RVTEST_PASS

  TEST_PASSFAIL

stvec_handler:
  csrr t0, scause
  li t1, 2
  bne TESTNUM, t1, 1f
  # Make sure R bit is set
  lw t0, page_table_1
  li t1, PTE_A
  and t0, t0, t1
  bne t0, t1, die

  # Make sure D bit is clear
  lw t0, page_table_1
  li t1, PTE_D
  and t0, t0, t1
  beq t0, t1, die

  csrr t0, sepc
  add t0, t0, 4
  csrw sepc, t0
  sret

die:
  RVTEST_FAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

.align 12
page_table_1: .dword (DRAM_BASE/RISCV_PGSIZE << PTE_PPN_SHIFT) | PTE_V | PTE_U | PTE_R | PTE_X
dummy: .dword 0
.align 12
page_table_2: .dword (DRAM_BASE/RISCV_PGSIZE << PTE_PPN_SHIFT) | PTE_V | PTE_U | PTE_R | PTE_X | PTE_W

RVTEST_DATA_END
