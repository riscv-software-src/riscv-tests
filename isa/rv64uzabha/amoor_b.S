# See LICENSE for license details.

#*****************************************************************************
# amoor_b.S
#-----------------------------------------------------------------------------
#
# Test amoor.b instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

.option arch, +zabha

RVTEST_RV64U
RVTEST_CODE_BEGIN

  TEST_CASE(2, a4, 0xffffffffffffff80, \
    li a0, 0xffffffffffffff80; \
    li a1, 0xfffffffffffffff8; \
    la a3, amo_operand; \
    sb a0, 0(a3); \
    amoor.b	a4, a1, 0(a3); \
  )

  TEST_CASE(3, a5, 0xfffffffffffffff8, lb a5, 0(a3))

  # try again after a cache miss
  TEST_CASE(4, a4, 0xfffffffffffffff8, \
    li  a1, 1; \
    amoor.b a4, a1, 0(a3); \
  )

  TEST_CASE(5, a5, 0xfffffffffffffff9, lb a5, 0(a3))

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

  .bss
  .align 3
amo_operand:
  .dword 0
