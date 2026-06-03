# See LICENSE for license details.

#*****************************************************************************
# pnclipi_h.S
#-----------------------------------------------------------------------------
#
# Test pnclipi.h instruction (packed narrow clip immediate halfword, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # pnclipi.h rd, rs1, imm
  # Narrows 32-bit elements to 16-bit by shifting right by immediate and saturating (signed)
  # Uses rs1 register pair (rs1, rs1+1) as 64-bit input

  # Test case 1: Shift right by 1 with saturation
  TEST_CASE( 2, x14, 0x00010001, \
    li x10, 0x00000002; \
    li x11, 0x00000002; \
    pnclipi.h x14, x10, 1 );

  # Test case 2: Saturation to max positive (0x7FFF)
  TEST_CASE( 3, x14, 0x7fff7fff, \
    li x10, 0x7fffffff; \
    li x11, 0x7fffffff; \
    pnclipi.h x14, x10, 0 );

  # Test case 3: Shift right by 16 (0x00010000 >> 16 = 1)
  TEST_CASE( 4, x14, 0x00010001, \
    li x10, 0x00010000; \
    li x11, 0x00010000; \
    pnclipi.h x14, x10, 16 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

