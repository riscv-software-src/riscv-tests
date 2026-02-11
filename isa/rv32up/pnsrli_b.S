# See LICENSE for license details.

#*****************************************************************************
# pnsrli_b.S
#-----------------------------------------------------------------------------
#
# Test pnsrli.b instruction (packed narrow shift right logical immediate byte, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # pnsrli.b rd, rs1, imm
  # Narrows 16-bit packed elements to 8-bit by shifting right logical by immediate
  # Uses rs1 register pair (rs1, rs1+1) as 64-bit input

  # Test case 1: Shift right by 1 (0x0200 >> 1 = 0x0100, narrowed to 0x00)
  TEST_CASE( 2, x14, 0x00000000, \
    li x10, 0x02000200; \
    li x11, 0x02000200; \
    pnsrli.b x14, x10, 1 );

  # Test case 2: Shift right logical (no sign extension: 0xFF00 >> 4 = 0x0FF0, narrowed to 0xF0)
  TEST_CASE( 3, x14, 0xf0f0f0f0, \
    li x10, 0xff00ff00; \
    li x11, 0xff00ff00; \
    pnsrli.b x14, x10, 4 );

  # Test case 3: Shift right by 8 (0x0100 >> 8 = 0x0001, narrowed to 0x01)
  TEST_CASE( 4, x14, 0x01010101, \
    li x10, 0x01000100; \
    li x11, 0x01000100; \
    pnsrli.b x14, x10, 8 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

