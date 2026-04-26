# See LICENSE for license details.

#*****************************************************************************
# pnsrar_hs.S
#-----------------------------------------------------------------------------
#
# Test pnsrar.hs instruction (packed narrow shift right arithmetic rounding halfword scalar, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # pnsrar.hs rd, rs1, rs2
  # Narrows 32-bit packed elements to 16-bit by shifting right arithmetic with rounding
  # Uses rs1 register pair (rs1, rs1+1) as 64-bit input
  # Shift amount from rs2[4:0] (5 bits, 0-31)

  # Test case 1: Shift right by 1 with rounding (0x00000003 >> 1 = 1 + round = 2)
  TEST_CASE( 2, x14, 0x00020002, \
    li x10, 0x00000003; \
    li x11, 0x00000003; \
    li x12, 0x00000001; \
    pnsrar.hs x14, x10, x12 );

  # Test case 2: Shift right by 1 no rounding needed
  TEST_CASE( 3, x14, 0x00010001, \
    li x10, 0x00000002; \
    li x11, 0x00000002; \
    li x12, 0x00000001; \
    pnsrar.hs x14, x10, x12 );

  # Test case 3: Shift right by 8 with rounding
  TEST_CASE( 4, x14, 0x01000100, \
    li x10, 0x00ff8000; \
    li x11, 0x00ff8000; \
    li x12, 0x00000008; \
    pnsrar.hs x14, x10, x12 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

