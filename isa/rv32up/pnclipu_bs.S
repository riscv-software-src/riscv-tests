# See LICENSE for license details.

#*****************************************************************************
# pnclipu_bs.S
#-----------------------------------------------------------------------------
#
# Test pnclipu.bs instruction (packed narrow clip unsigned byte scalar, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # pnclipu.bs rd, rs1, rs2
  # Narrows 16-bit elements to 8-bit by shifting right and saturating (unsigned)
  # Uses rs1 register pair (rs1, rs1+1) as 64-bit input

  # Test case 1: Shift right by 1
  TEST_CASE( 2, x14, 0x01010101, \
    li x10, 0x00020002; \
    li x11, 0x00020002; \
    li x12, 0x00000001; \
    pnclipu.bs x14, x10, x12 );

  # Test case 2: Saturation to max unsigned (0xFF)
  TEST_CASE( 3, x14, 0xffffffff, \
    li x10, 0xffffffff; \
    li x11, 0xffffffff; \
    li x12, 0x00000000; \
    pnclipu.bs x14, x10, x12 );

  # Test case 3: Shift right by 8 (0x0100 >> 8 = 1)
  TEST_CASE( 4, x14, 0x01010101, \
    li x10, 0x01000100; \
    li x11, 0x01000100; \
    li x12, 0x00000008; \
    pnclipu.bs x14, x10, x12 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

