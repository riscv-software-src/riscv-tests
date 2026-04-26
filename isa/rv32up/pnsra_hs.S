# See LICENSE for license details.

#*****************************************************************************
# pnsra_hs.S
#-----------------------------------------------------------------------------
#
# Test pnsra.hs instruction (packed narrow shift right arithmetic halfword scalar, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # pnsra.hs rd, rs1, rs2
  # Narrows 32-bit packed elements to 16-bit by shifting right arithmetic
  # Uses rs1 register pair (rs1, rs1+1) as 64-bit input
  # Shift amount from rs2[4:0] (5 bits, 0-31)

  # Test case 1: Shift right by 1 (0x00020000 >> 1 = 0x00010000, narrowed to 0x0001)
  # Input: x10=0x00020000, x11=0x00020000 (64-bit: two 32-bit words)
  TEST_CASE( 2, x14, 0x00010001, \
    li x10, 0x00020000; \
    li x11, 0x00020000; \
    li x12, 0x00000001; \
    pnsra.hs x14, x10, x12 );

  # Test case 2: Shift right with sign extension (0xFFFF0000 >> 8 = 0xFFFFFF00, narrowed to 0xFF00)
  TEST_CASE( 3, x14, 0xff00ff00, \
    li x10, 0xffff0000; \
    li x11, 0xffff0000; \
    li x12, 0x00000008; \
    pnsra.hs x14, x10, x12 );

  # Test case 3: Shift right by 16 (0x00010000 >> 16 = 0x00000001, narrowed to 0x0001)
  TEST_CASE( 4, x14, 0x00010001, \
    li x10, 0x00010000; \
    li x11, 0x00010000; \
    li x12, 0x00000010; \
    pnsra.hs x14, x10, x12 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

