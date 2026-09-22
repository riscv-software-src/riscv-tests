# See LICENSE for license details.

#*****************************************************************************
# amoxor_h.S
#-----------------------------------------------------------------------------
#
# Test amoxor.h instruction.
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
    amoxor.h	a4, a1, 0(a3); \
  )

  TEST_CASE(3, a5, 0x0000000000007800, lh a5, 0(a3))

  # try again after a cache miss
  TEST_CASE(4, a4, 0x0000000000007800, \
    li  a1, 0xc001; \
    amoxor.h a4, a1, 0(a3); \
  )

  TEST_CASE(5, a5, 0xffffffffffffb801, lh a5, 0(a3))

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
