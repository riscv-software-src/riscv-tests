# See LICENSE for license details.

#*****************************************************************************
# amoadd_b.S
#-----------------------------------------------------------------------------
#
# Test amoadd.b instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

.option arch, +zabha

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # Add 1 to the top bit of a byte
  TEST_CASE(2, a4, 0xffffffffffffff80, \
    li a0, 0xffffffffffffff80; \
    li a1, 0xfffffffffffffff8; \
    la a3, amo_operand; \
    sb a0, 0(a3); \
    amoadd.b	a4, a1, 0(a3); \
  )

  # Check the memory
  TEST_CASE(3, a5, 0x0000000000000078, lb a5, 0(a3))

  # Try again
  TEST_CASE(4, a4, 0x0000000000000078, \
    li  a1, 0xffffffffffffff80; \
    amoadd.b a4, a1, 0(a3); \
  )

  TEST_CASE(5, a5, 0xfffffffffffffff8, lb a5, 0(a3))

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
