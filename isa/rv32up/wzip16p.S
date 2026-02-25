# See LICENSE for license details.

#*****************************************************************************
# wzip16p.S
#-----------------------------------------------------------------------------
#
# Test wzip16p instruction (widening zip 16-bit elements, RV32 only).
# Combines 16-bit elements from rs1 and rs2 into 32-bit elements in rd pair.
# rd[i] = rs2[i] << 16 | rs1[i]
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # wzip16p rd, rs1, rs2
  # Widening zip: combines halfwords into words
  # Output is 64-bit in register pair (rd, rd+1)

  # Test case 1: Simple widening zip
  # rs1 = 0x00020001, rs2 = 0x00120011
  # rd = {0x00120002, 0x00110001} = 0x00120002_00110001
  TEST_CASE( 2, x14, 0x00110001, \
    li x10, 0x00020001; \
    li x12, 0x00120011; \
    wzip16p x14, x10, x12 );

  # Check high part in x15
  TEST_CASE( 3, x15, 0x00120002, \
    li x10, 0x00020001; \
    li x12, 0x00120011; \
    wzip16p x14, x10, x12 );

  # Test case 2: All zeros from rs1
  TEST_CASE( 4, x14, 0x00110000, \
    li x10, 0x00000000; \
    li x12, 0x00120011; \
    wzip16p x14, x10, x12 );

  # Test case 3: All FF pattern
  TEST_CASE( 5, x14, 0xFFFFFFFF, \
    li x10, 0xFFFFFFFF; \
    li x12, 0xFFFFFFFF; \
    wzip16p x14, x10, x12 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

