# See LICENSE for license details.

#*****************************************************************************
# amomax_h.S
#-----------------------------------------------------------------------------
#
# Test amomax.h instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

.option arch, +zabha

RVTEST_RV64U
RVTEST_CODE_BEGIN

  TEST_CASE(2, a4, 0xffffffffffff8000, \
    li a0, 0xffffffffffff8000; \
    li a1, 0xfffffffffffff800; \
    la a3, amo_operand; \
    sh a0, 0(a3); \
    amomax.h	a4, a1, 0(a3); \
  )

  TEST_CASE(3, a5, 0xfffffffffffff800, lh a5, 0(a3))

  # Test max(0,1)
  TEST_CASE(4, a4, 0x0000000000000000, \
    li a1, 1; \
    sh x0, 0(a3); \
    amomax.h	a4, a1, 0(a3); \
  )

  TEST_CASE(5, a5, 0x0000000000000001, lh a5, 0(a3))

  # Test max(1,-1)
  TEST_CASE(6, a4, 0x0000000000000001, \
    li a0, 0x0000000000000001; \
    li a1, 0x0000000000008000; \
    la a3, amo_operand; \
    sh a0, 0(a3); \
    amomax.h	a4, a1, 0(a3); \
  )

  TEST_CASE(7, a5, 0x0000000000000001, lh a5, 0(a3))

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
