# See LICENSE for license details.

#*****************************************************************************
# 2-stage_translation.S
#-----------------------------------------------------------------------------
#
# Set 2 stage translation, do a simple load store.
#

#include "riscv_test.h"
#include "test_macros.h"

#define vspt0_gpa 0x0 
#define vspt1_gpa 0x1000 
#define vspt2_gpa 0x2000
#define GPA 0x200000 

RVTEST_RV64M
RVTEST_CODE_BEGIN

  li TESTNUM, 2

# map GVA 0x0~0xfff to GPA 0x200000~0x200fff
vs_pt_init:
  li t0, vspt1_gpa
  srl t0, t0, RISCV_PGSHIFT - PTE_PPN_SHIFT
  ori t0, t0, PTE_V
  sd t0, vspt_0, t1

  li t0, vspt2_gpa
  srl t0, t0, RISCV_PGSHIFT - PTE_PPN_SHIFT
  ori t0, t0, PTE_V
  sd t0, vspt_1, t1

  li t0, GPA
  srl t0, t0, RISCV_PGSHIFT - PTE_PPN_SHIFT
  ori t0, t0, PTE_V | PTE_X | PTE_A | PTE_D | PTE_R | PTE_W
  sd t0, vspt_2, t1
  
init_vsatp:
  li a0, (SATP_MODE & ~(SATP_MODE<<1)) * SATP_MODE_SV39
  la a1, vspt0_gpa
  srl a1, a1, RISCV_PGSHIFT
  or a1, a1, a0
  csrw vsatp, a1
  hfence.vvma


# map GPA 0x200000~0x200fff to data_page
guest_pt_init:
  la t0, gpt_1
  srl t0, t0, RISCV_PGSHIFT - PTE_PPN_SHIFT
  ori t0, t0, PTE_V
  sd t0, gpt_0, t1

  la t0, gpt_2
  srl t0, t0, RISCV_PGSHIFT - PTE_PPN_SHIFT
  ori t0, t0, PTE_V
  sd t0, gpt_1, t1

  la t0, gpt_3
  srl t0, t0, RISCV_PGSHIFT - PTE_PPN_SHIFT
  ori t0, t0, PTE_V
  sd t0, gpt_1 + 8, t1

  la t0, vspt_0
  srl t0, t0, RISCV_PGSHIFT - PTE_PPN_SHIFT
  ori t0, t0, PTE_V | PTE_R | PTE_W | PTE_A | PTE_D | PTE_U
  sd t0, gpt_2, t1

  la t0, vspt_1
  srl t0, t0, RISCV_PGSHIFT - PTE_PPN_SHIFT
  ori t0, t0, PTE_V | PTE_R | PTE_W | PTE_A | PTE_D | PTE_U
  sd t0, gpt_2 + 8, t1

  la t0, vspt_2
  srl t0, t0, RISCV_PGSHIFT - PTE_PPN_SHIFT
  ori t0, t0, PTE_V | PTE_R | PTE_W | PTE_A | PTE_D | PTE_U
  sd t0, gpt_2 + 16, t1

  la t0, data_page
  srl t0, t0, RISCV_PGSHIFT - PTE_PPN_SHIFT
  ori t0, t0, PTE_V | PTE_R | PTE_W | PTE_A | PTE_D | PTE_U
  sd t0, gpt_3, t1
  
init_hgatp:
  li a0, (SATP_MODE & ~(SATP_MODE<<1)) * SATP_MODE_SV39
  la a1, gpt_0
  srl a1, a1, RISCV_PGSHIFT
  or a1, a1, a0
  csrw hgatp, a1
  hfence.gvma

hstatus_init:
  li a0, HSTATUS_SPVP
  csrs hstatus, a0

  la a0, data_page
  li a1, 0x12345678
  sw a1, 0(a0)

  li t0, 0x0
  hlv.w t2, 0(t0) # should be 0x12345678
  hsv.w t2, 0(t0)
  bne t2, a1, fail
  
  RVTEST_PASS

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

.align 12
vspt_0: .dword 0
.align 12
vspt_1: .dword 0
.align 12
vspt_2: .dword 0

.align 14
gpt_0: .dword 0
.align 14
gpt_1: .dword 0
.align 12
gpt_2: .dword 0
.align 12
gpt_3: .dword 0
.align 12
data_page: .dword 0

RVTEST_DATA_END
