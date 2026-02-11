# See LICENSE for license details.

#*****************************************************************************
# srx.S
#-----------------------------------------------------------------------------
#
# Test srx instruction (funnel shift right, RV32 only).
# srx rd, rs1, rs2 - funnel shift right
# rd = (rs1 << (32 - shamt)) | (rd_old >> shamt)
#   - shifts rd_old right by shamt
#   - fills high bits from low bits of rs1
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
    srx x14, a1, a2 \
  );

  # Test case 2: Shift by 4
  # rd = (0x0000000f << 28) | (0x12345678 >> 4) = 0xf0000000 | 0x01234567 = 0xf1234567
  TEST_CASE( 3, x14, 0xf1234567, \
    li x14, 0x12345678; \
    li a1, 0x0000000f; \
    li a2, 4; \
    srx x14, a1, a2 \
  );

  # Test case 3: Shift by 8
  # rd = (0x000000ab << 24) | (0x12345678 >> 8) = 0xab000000 | 0x00123456 = 0xab123456
  TEST_CASE( 4, x14, 0xab123456, \
    li x14, 0x12345678; \
    li a1, 0x000000ab; \
    li a2, 8; \
    srx x14, a1, a2 \
  );

  # Test case 4: Shift by 16
  # rd = (0x00005678 << 16) | (0xabcd1234 >> 16) = 0x56780000 | 0x0000abcd = 0x5678abcd
  TEST_CASE( 5, x14, 0x5678abcd, \
    li x14, 0xabcd1234; \
    li a1, 0x00005678; \
    li a2, 16; \
    srx x14, a1, a2 \
  );

  # Test case 5: Shift by 31
  # rd = (0x00000001 << 1) | (0x80000000 >> 31) = 0x00000002 | 0x00000001 = 0x00000003
  TEST_CASE( 6, x14, 0x00000003, \
    li x14, 0x80000000; \
    li a1, 0x00000001; \
    li a2, 31; \
    srx x14, a1, a2 \
  );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

