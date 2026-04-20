# See LICENSE for license details.

#*****************************************************************************
# 2-stage_translation_implicit_store_error_hs.S
#-----------------------------------------------------------------------------
#
# Tests that an implicit G-stage store fault on PTE A/D writeback during
# a VS-stage page table walk is correctly delegated to HS-mode.
#

#include "riscv_test.h"
#include "test_macros.h"

#define STORE_PSEUDOINSTRUCTION_RV64 0x3020

# Address used as GVA, GPA, and SPA (identity-mapped gigapage)
#define IDENTITY_ADDR 0x80000000

RVTEST_RV64M
RVTEST_CODE_BEGIN

li TESTNUM, 2

# Enable hardware A/D update (Svadu) in both M and HS environment
# configuration registers. Required for the A/D-bit writeback that
# triggers the implicit G-stage store fault under test.
machine_setup:
  li t0, MENVCFG_HADE
  csrs menvcfg, t0

  li t0, HENVCFG_HADE
  csrs henvcfg, t0

  RVTEST_ENABLE_SUPERVISOR
  la a0, vs_pt_init
  csrw mepc, a0

  # Delegate to HS-Mode
  li t0, (1 << CAUSE_STORE_GUEST_PAGE_FAULT)
  csrw medeleg, t0

  mret

# Map GVA 0x80000000 -> GPA 0x80000000
vs_pt_init:
  li t0, IDENTITY_ADDR
  srl t0, t0, RISCV_PGSHIFT - PTE_PPN_SHIFT
  ori t0, t0, PTE_V | PTE_R | PTE_W | PTE_X
  la t1, vspt_0
  li t2, 2       # VPN[2] = 2 for GVA 0x80000000 under Sv39
  sll t2, t2, 3  # byte offset = 2 * 8 (PTE size)
  add t1, t1, t2 # vspt_0 + byte offset
  sd t0, 0(t1)   # vspt_0[2] = pte

init_vsatp:
  li t0, (SATP_MODE & ~(SATP_MODE<<1)) * SATP_MODE_SV39
  la t1, vspt_0
  srl t1, t1, RISCV_PGSHIFT
  or t1, t1, t0
  csrw vsatp, t1
  hfence.vvma

# Map GPA 0x80000000 -> SPA 0x80000000
#
# PTE_W is omitted so that G-stage grants read (the VS-stage walk can reach
# the leaf PTE) but denies write, causing the implicit PTE store for the
# A/D writeback to fail.
guest_pt_init:
  li t0, IDENTITY_ADDR
  srl t0, t0, RISCV_PGSHIFT - PTE_PPN_SHIFT
  ori t0, t0, PTE_V | PTE_R | PTE_X | PTE_U # No PTE_W
  la t1, gpt_0
  li t2, 2
  sll t2, t2, 3
  add t1, t1, t2
  sd t0, 0(t1)

init_hgatp:
  li t0, (SATP_MODE & ~(SATP_MODE<<1)) * SATP_MODE_SV39
  la t1, gpt_0
  srl t1, t1, RISCV_PGSHIFT
  or t1, t1, t0
  csrw hgatp, t1
  hfence.gvma

hstatus_init:
  li t0, HSTATUS_SPVP
  csrs hstatus, t0

  la t0, check_fault
  csrw stvec, t0

  li t0, IDENTITY_ADDR
  hsv.w t2, 0(t0)

  j fail # Should not reach here

check_fault:
  # Check scause
  csrr t0, scause
  li t1, CAUSE_STORE_GUEST_PAGE_FAULT
  bne t0, t1, fail

  # Check stval
  csrr t0, stval
  li t1, IDENTITY_ADDR
  bne t0, t1, fail

  # Check htval == faulting PTE address (&vspt_0[2]) >> 2
  la t0, vspt_0
  li t1, 2
  sll t1, t1, 3
  add t0, t0, t1
  srli t0, t0, 2
  csrr t2, htval
  bne t2, t0, fail

  # Check htinst
  csrr t0, htinst
  li t1, STORE_PSEUDOINSTRUCTION_RV64
  bne t0, t1, fail

  RVTEST_PASS
  TEST_PASSFAIL

RVTEST_CODE_END

.data
RVTEST_DATA_BEGIN
  TEST_DATA

.align 12
vspt_0: .dword 0 # 4 KiB, Sv39 root page table

.align 14
gpt_0: .fill 512, 8, 0 # 16 KiB, Sv39x4 G-stage root page table

RVTEST_DATA_END
