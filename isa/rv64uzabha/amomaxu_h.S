# See LICENSE for license details.

#*****************************************************************************
# amomaxu_h.S
#-----------------------------------------------------------------------------
#
# Test amomaxu.h instruction.
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
    amomaxu.h	a4, a1, 0(a3); \
  )

  TEST_CASE(3, a5, 0xfffffffffffff800, lh a5, 0(a3))

  TEST_CASE(4, a4, 0x0000000000000000, \
    li a1, 0xffffffffffffffff; \
    sh x0, 0(a3); \
    amomaxu.h	a4, a1, 0(a3); \
  )

  TEST_CASE(5, a5, 0xffffffffffffffff, lh a5, 0(a3))

  # The following two cases check that the upper bits are ignored on rv64
  # implementations. Only enable them for rv64.
  #if __riscv_xlen == 64
  TEST_CASE(6, a4, 0x0000000000000001, \
    li a0, 0x0000000000000001; \
    li a1, 0x8000000000000000; \
    la a3, amo_operand; \
    sh a0, 0(a3); \
    amomaxu.h	a4, a1, 0(a3); \
  )

  TEST_CASE(7, a5, 0x0000000000000001, lh a5, 0(a3))
  #endif

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
