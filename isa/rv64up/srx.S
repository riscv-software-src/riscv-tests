# See LICENSE for license details.

#*****************************************************************************
# srx.S
#-----------------------------------------------------------------------------
#
# Test srx instruction (funnel shift right, RV64).
# srx rd, rs1, rs2 - funnel shift right
# rd = (rs1 << (64 - shamt)) | (rd_old >> shamt)
#   - shifts rd_old right by shamt
#   - fills high bits from low bits of rs1
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
    srx x14, a1, a2 \
  );

  # Test case 2: Shift by 4
  # rd = (0x000000000000000f << 60) | (0x123456789abcdef0 >> 4)
  #    = 0xf000000000000000 | 0x0123456789abcdef = 0xf123456789abcdef
  TEST_CASE( 3, x14, 0xf123456789abcdef, \
    li x14, 0x123456789abcdef0; \
    li a1, 0x000000000000000f; \
    li a2, 4; \
    srx x14, a1, a2 \
  );

  # Test case 3: Shift by 8
  # rd = (0x00000000000000ff << 56) | (0x0100000000000000 >> 8)
  #    = 0xff00000000000000 | 0x0001000000000000 = 0xff01000000000000
  TEST_CASE( 4, x14, 0xff01000000000000, \
    li x14, 0x0100000000000000; \
    li a1, 0x00000000000000ff; \
    li a2, 8; \
    srx x14, a1, a2 \
  );

  # Test case 4: Shift by 32
  # rd = (0x0000000012345678 << 32) | (0xabcdef0100000000 >> 32)
  #    = 0x1234567800000000 | 0x00000000abcdef01 = 0x12345678abcdef01
  TEST_CASE( 5, x14, 0x12345678abcdef01, \
    li x14, 0xabcdef0100000000; \
    li a1, 0x0000000012345678; \
    li a2, 32; \
    srx x14, a1, a2 \
  );

  # Test case 5: Shift by 63
  # rd = (0x0000000000000001 << 1) | (0x8000000000000000 >> 63)
  #    = 0x0000000000000002 | 0x0000000000000001 = 0x0000000000000003
  TEST_CASE( 6, x14, 0x0000000000000003, \
    li x14, 0x8000000000000000; \
    li a1, 0x0000000000000001; \
    li a2, 63; \
    srx x14, a1, a2 \
  );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


