# See LICENSE for license details.

#*****************************************************************************
# 2-stage_misaligned_load_crossing_page_boundary_gstage_fault.S
#-----------------------------------------------------------------------------
#
# Tests a misaligned HLV load that crosses a page boundary where the second
# page is mapped at VS-stage but unmapped at G-stage. A correct implementation
# splits the access and translates each page separately, taking a load
# guest-page fault on the second page. A faulty implementation translates only
# the base address and performs the whole load at once, so the fault is missed.
#
# This test assumes that misaligned load/stores to main memory are supported (Zicclsm)
#

#include "riscv_test.h"
#include "test_macros.h"

#define PAGE_A     0x80000000
#define PAGE_B     0xC0000000
#define LOAD_FROM  0xBFFFFFFC

RVTEST_RV64M
RVTEST_CODE_BEGIN

li TESTNUM, 2

# VS-stage: map both GVA 0x80000000 and GVA 0xC0000000 as identity
# gigapages, so the VS-stage walk succeeds for both halves.
vs_pt_init:
  li t0, PAGE_A
  srl t0, t0, RISCV_PGSHIFT - PTE_PPN_SHIFT
  ori t0, t0, PTE_V | PTE_R | PTE_W | PTE_X | PTE_A | PTE_D
  la t1, vspt_0
  li t2, 2       # VPN[2] = 2 for GVA 0x80000000 under Sv39
  sll t2, t2, 3
  add t1, t1, t2
  sd t0, 0(t1)   # vspt_0[2] = pte

  li t0, PAGE_B
  srl t0, t0, RISCV_PGSHIFT - PTE_PPN_SHIFT
  ori t0, t0, PTE_V | PTE_R | PTE_W | PTE_X | PTE_A | PTE_D
  la t1, vspt_0
  li t2, 3       # VPN[2] = 3 for GVA 0xC0000000
  sll t2, t2, 3
  add t1, t1, t2
  sd t0, 0(t1)   # vspt_0[3] = pte

init_vsatp:
  li t0, (SATP_MODE & ~(SATP_MODE<<1)) * SATP_MODE_SV39
  la t1, vspt_0
  srl t1, t1, RISCV_PGSHIFT
  or t1, t1, t0
  csrw vsatp, t1
  hfence.vvma

# G-stage: map GPA 0x80000000 -> SPA 0x80000000. This
# covers page A and the VS-stage page table. GPA 0xC0000000
# is left zero, so the second half has no G-stage mapping.
guest_pt_init:
  li t0, PAGE_A
  srl t0, t0, RISCV_PGSHIFT - PTE_PPN_SHIFT
  ori t0, t0, PTE_V | PTE_R | PTE_W | PTE_X | PTE_U | PTE_A | PTE_D
  la t1, gpt_0
  li t2, 2
  sll t2, t2, 3
  add t1, t1, t2
  sd t0, 0(t1)

init_hgatp:
  li t0, (HGATP64_MODE & ~(HGATP64_MODE<<1)) * HGATP_MODE_SV39X4
  la t1, gpt_0
  srl t1, t1, RISCV_PGSHIFT
  or t1, t1, t0
  csrw hgatp, t1
  hfence.gvma

hstatus_init:
  li t0, HSTATUS_SPVP
  csrs hstatus, t0

  la t0, check_fault
  csrw mtvec, t0

  li t0, LOAD_FROM
  # Replace HLV with HSV for testing stores
  hlv.d t2, 0(t0)

  j fail # A faulty implementation reaches here and raises no fault

.align 2
check_fault:
  la t0, trap_vector
  csrw mtvec, t0

  # G-stage fault on the page B half.
  csrr t0, mcause
  # Replace CAUSE_LOAD_GUEST_PAGE_FAULT with CAUSE_STORE_GUEST_PAGE_FAULT for testing stores
  li t1, CAUSE_LOAD_GUEST_PAGE_FAULT
  bne t0, t1, fail

  # mtval = faulting GVA, in page B.
  csrr t0, mtval
  li t1, PAGE_B
  bne t0, t1, fail

  # mtval2 = faulting GPA (page B) >> 2.
  csrr t0, mtval2
  li t1, PAGE_B
  srli t1, t1, 2
  bne t0, t1, fail

  # GVA must be 1
  csrr t0, mstatus
  li   t1, MSTATUS_GVA
  and  t2, t0, t1
  beqz t2, fail

  # MPV must be 0
  li   t1, MSTATUS_MPV
  and  t2, t0, t1
  bnez t2, fail

  # MPP must be 0b11 (M-Mode)
  csrr t0, mstatus
  li   t1, MSTATUS_MPP
  and  t2, t0, t1
  bne  t2, t1, fail

  RVTEST_PASS
  TEST_PASSFAIL

RVTEST_CODE_END

.data
RVTEST_DATA_BEGIN
  TEST_DATA

.align 12
vspt_0: .fill 4096, 1, 0 # VS-stage root page table

.align 14
gpt_0: .fill 16384, 1, 0 # G-Stage root page table

RVTEST_DATA_END
