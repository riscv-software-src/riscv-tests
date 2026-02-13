# See LICENSE for license details.

#*****************************************************************************
# pnsrari_h.S
#-----------------------------------------------------------------------------
#
# Test pnsrari.h instruction (packed narrow shift right arithmetic rounding immediate halfword, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # pnsrari.h rd, rs1, imm
  # Narrows 32-bit packed elements to 16-bit by shifting right arithmetic with rounding by immediate
  # Uses rs1 register pair (rs1, rs1+1) as 64-bit input

  # Test case 1: Shift right by 1 with rounding (0x00000003 >> 1 = 1 + round = 2)
  TEST_CASE( 2, x14, 0x00020002, \
    li x10, 0x00000003; \
    li x11, 0x00000003; \
    pnsrari.h x14, x10, 1 );

  # Test case 2: Shift right by 1 no rounding needed
  TEST_CASE( 3, x14, 0x00010001, \
    li x10, 0x00000002; \
    li x11, 0x00000002; \
    pnsrari.h x14, x10, 1 );

  # Test case 3: Shift right by 8 with rounding
  TEST_CASE( 4, x14, 0x01000100, \
    li x10, 0x00ff8000; \
    li x11, 0x00ff8000; \
    pnsrari.h x14, x10, 8 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

