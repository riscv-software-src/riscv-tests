# See LICENSE for license details.

#*****************************************************************************
# wzip8p.S
#-----------------------------------------------------------------------------
#
# Test wzip8p instruction (widening zip 8-bit elements, RV32 only).
# Combines 8-bit elements from rs1 and rs2 into 16-bit elements in rd pair.
# rd[i] = rs2[i] << 8 | rs1[i]
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # wzip8p rd, rs1, rs2
  # Widening zip: combines bytes into halfwords
  # Output is 64-bit in register pair (rd, rd+1)

  # Test case 1: Simple widening zip
  # rs1 = 0x04030201, rs2 = 0x14131211
  # rd = {0x1404, 0x1303, 0x1202, 0x1101} = 0x14041303_12021101
  TEST_CASE( 2, x14, 0x12021101, \
    li x10, 0x04030201; \
    li x12, 0x14131211; \
    wzip8p x14, x10, x12 );

  # Check high part in x15
  TEST_CASE( 3, x15, 0x14041303, \
    li x10, 0x04030201; \
    li x12, 0x14131211; \
    wzip8p x14, x10, x12 );

  # Test case 2: All zeros from rs1
  TEST_CASE( 4, x14, 0x12001100, \
    li x10, 0x00000000; \
    li x12, 0x14131211; \
    wzip8p x14, x10, x12 );

  # Test case 3: All FF pattern
  TEST_CASE( 5, x14, 0xFFFFFFFF, \
    li x10, 0xFFFFFFFF; \
    li x12, 0xFFFFFFFF; \
    wzip8p x14, x10, x12 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

