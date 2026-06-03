# See LICENSE for license details.

#*****************************************************************************
# slx.S
#-----------------------------------------------------------------------------
#
# Test slx instruction (funnel shift left, RV64).
# slx rd, rs1, rs2 - funnel shift left
# rd = (rs1 >> (64 - shamt)) | (rd_old << shamt)
#   - shifts rd_old left by shamt
#   - fills low bits from high bits of rs1
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # Test case 1: Shift by 0 - rd unchanged
  # rd = rd_old (when shamt=0)
  TEST_CASE( 2, x14, 0x123456789abcdef0, \
    li x14, 0x123456789abcdef0; \
    li a1, 0xdeadbeefcafebabe; \
    li a2, 0; \
    slx x14, a1, a2 \
  );

  # Test case 2: Shift by 4
  # rd = (0xf000000000000000 >> 60) | (0x123456789abcdef0 << 4)
  #    = 0xf | 0x23456789abcdef00 = 0x23456789abcdef0f
  TEST_CASE( 3, x14, 0x23456789abcdef0f, \
    li x14, 0x123456789abcdef0; \
    li a1, 0xf000000000000000; \
    li a2, 4; \
    slx x14, a1, a2 \
  );

  # Test case 3: Shift by 8
  # rd = (0xff00000000000000 >> 56) | (0x0000000000000001 << 8)
  #    = 0xff | 0x100 = 0x1ff
  TEST_CASE( 4, x14, 0x00000000000001ff, \
    li x14, 0x0000000000000001; \
    li a1, 0xff00000000000000; \
    li a2, 8; \
    slx x14, a1, a2 \
  );

  # Test case 4: Shift by 32
  # rd = (0x1234567800000000 >> 32) | (0x00000000abcdef01 << 32)
  #    = 0x12345678 | 0xabcdef0100000000 = 0xabcdef0112345678
  TEST_CASE( 5, x14, 0xabcdef0112345678, \
    li x14, 0x00000000abcdef01; \
    li a1, 0x1234567800000000; \
    li a2, 32; \
    slx x14, a1, a2 \
  );

  # Test case 5: Shift by 63
  # rd = (0x8000000000000000 >> 1) | (0x0000000000000001 << 63)
  #    = 0x4000000000000000 | 0x8000000000000000 = 0xc000000000000000
  TEST_CASE( 6, x14, 0xc000000000000000, \
    li x14, 0x0000000000000001; \
    li a1, 0x8000000000000000; \
    li a2, 63; \
    slx x14, a1, a2 \
  );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


