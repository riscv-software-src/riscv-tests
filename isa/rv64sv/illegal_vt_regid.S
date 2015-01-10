# See LICENSE for license details.

#*****************************************************************************
# xcpt_illegal_vt_regid.S
#-----------------------------------------------------------------------------
#
# Test illegal vt regid trap.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64S
RVTEST_CODE_BEGIN

  li a0, SR_EA
  csrs status, a0

  csrr a3,status
  li a4,(1 << IRQ_COP)
  slli a4,a4,SR_IM_SHIFT
  or a3,a3,a4 # enable IM[COP]
  csrw status,a3

  TEST_ILLEGAL_VT_REGID(2, 5, 5, add, x7, x1, x2)
  TEST_ILLEGAL_VT_REGID(3, 5, 5, add, x1, x7, x2)
  TEST_ILLEGAL_VT_REGID(4, 5, 5, add, x1, x2, x7)

  TEST_ILLEGAL_VT_REGID(5, 5, 5, fadd.d, f7, f1, f2)
  TEST_ILLEGAL_VT_REGID(6, 5, 5, fadd.d, f1, f7, f2)
  TEST_ILLEGAL_VT_REGID(7, 5, 5, fadd.d, f1, f2, f7)

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

src1:
  .dword 1
  .dword 2
  .dword 3
  .dword 4
src2:
  .dword 4
  .dword 3
  .dword 2
  .dword 1
dest:
  .dword 0xdeadbeefcafebabe
  .dword 0xdeadbeefcafebabe
  .dword 0xdeadbeefcafebabe
  .dword 0xdeadbeefcafebabe

RVTEST_DATA_END
