# See LICENSE for license details.

#*****************************************************************************
# amomaxu_b.S
#-----------------------------------------------------------------------------
#
# Test amomaxu.b instruction.
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
    amomaxu.b	a4, a1, 0(a3); \
  )

  TEST_CASE(3, a5, 0xfffffffffffffff8, lb a5, 0(a3))

  TEST_CASE(4, a4, 0x0000000000000000, \
    li a1, 0xffffffffffffffff; \
    sb x0, 0(a3); \
    amomaxu.b	a4, a1, 0(a3); \
  )

  TEST_CASE(5, a5, 0xffffffffffffffff, lb a5, 0(a3))

  # The following two cases check that the upper bits are ignored on rv64
  # implementations. Only enable them for rv64.
  #if __riscv_xlen == 64
  TEST_CASE(6, a4, 0x0000000000000001, \
    li a0, 0x0000000000000001; \
    li a1, 0x8000000000000000; \
    la a3, amo_operand; \
    sb a0, 0(a3); \
    amomaxu.b	a4, a1, 0(a3); \
  )

  TEST_CASE(7, a5, 0x0000000000000001, lb a5, 0(a3))
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
