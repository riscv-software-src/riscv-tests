# See LICENSE for license details.

#*****************************************************************************
# slx.S
#-----------------------------------------------------------------------------
#
# Test slx instruction (funnel shift left, RV32 only).
# slx rd, rs1, rs2 - funnel shift left
# rd = (rs1 >> (32 - shamt)) | (rd_old << shamt)
#   - shifts rd_old left by shamt
#   - fills low bits from high bits of rs1
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # Test case 1: Shift by 0 - rd unchanged
  # rd = rd_old (when shamt=0)
  TEST_CASE( 2, x14, 0x12345678, \
    li x14, 0x12345678; \
    li a1, 0xdeadbeef; \
    li a2, 0; \
    slx x14, a1, a2 \
  );

  # Test case 2: Shift by 4
  # rd = (0xf0000000 >> 28) | (0x12345678 << 4) = 0xf | 0x23456780 = 0x2345678f
  TEST_CASE( 3, x14, 0x2345678f, \
    li x14, 0x12345678; \
    li a1, 0xf0000000; \
    li a2, 4; \
    slx x14, a1, a2 \
  );

  # Test case 3: Shift by 8
  # rd = (0xff000000 >> 24) | (0x00000001 << 8) = 0xff | 0x100 = 0x000001ff
  TEST_CASE( 4, x14, 0x000001ff, \
    li x14, 0x00000001; \
    li a1, 0xff000000; \
    li a2, 8; \
    slx x14, a1, a2 \
  );

  # Test case 4: Shift by 16
  # rd = (0x12340000 >> 16) | (0x0000abcd << 16) = 0x1234 | 0xabcd0000 = 0xabcd1234
  TEST_CASE( 5, x14, 0xabcd1234, \
    li x14, 0x0000abcd; \
    li a1, 0x12340000; \
    li a2, 16; \
    slx x14, a1, a2 \
  );

  # Test case 5: Shift by 31
  # rd = (0x80000000 >> 1) | (0x00000001 << 31) = 0x40000000 | 0x80000000 = 0xc0000000
  TEST_CASE( 6, x14, 0xc0000000, \
    li x14, 0x00000001; \
    li a1, 0x80000000; \
    li a2, 31; \
    slx x14, a1, a2 \
  );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

