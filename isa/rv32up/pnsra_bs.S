# See LICENSE for license details.

#*****************************************************************************
# pnsra_bs.S
#-----------------------------------------------------------------------------
#
# Test pnsra.bs instruction (packed narrow shift right arithmetic byte scalar, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # pnsra.bs rd, rs1, rs2
  # Narrows 16-bit packed elements to 8-bit by shifting right arithmetic
  # Uses rs1 register pair (rs1, rs1+1) as 64-bit input
  # Shift amount from rs2[3:0] (4 bits, 0-15)

  # Test case 1: Shift right by 1 (0x0200 >> 1 = 0x0100, narrowed to 0x00)
  # Input: x10=0x02000200, x11=0x02000200 (64-bit: 0x0200020002000200)
  # Each 16-bit element 0x0200 >> 1 = 0x0100, narrowed to 0x00
  TEST_CASE( 2, x14, 0x00000000, \
    li x10, 0x02000200; \
    li x11, 0x02000200; \
    li x12, 0x00000001; \
    pnsra.bs x14, x10, x12 );

  # Test case 2: Shift right with sign extension (0xFF00 >> 4 = 0xFFF0, narrowed to 0xF0)
  TEST_CASE( 3, x14, 0xf0f0f0f0, \
    li x10, 0xff00ff00; \
    li x11, 0xff00ff00; \
    li x12, 0x00000004; \
    pnsra.bs x14, x10, x12 );

  # Test case 3: Shift right by 8 (0x0100 >> 8 = 0x0001, narrowed to 0x01)
  TEST_CASE( 4, x14, 0x01010101, \
    li x10, 0x01000100; \
    li x11, 0x01000100; \
    li x12, 0x00000008; \
    pnsra.bs x14, x10, x12 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

